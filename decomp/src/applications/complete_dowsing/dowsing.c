#include "complete_dowsing.h"

#include <nitro.h>
#include <nnsys.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "constants/player_avatar.h"
#include "generated/bg_event_types.h"
#include "generated/object_events_gfx.h"
#include "generated/text_banks.h"

#include "field/field_system.h"

#include "bg_window.h"
#include "field_task.h"
#include "font.h"
#include "graphics.h"
#include "heap.h"
#include "map_header_data.h"
#include "map_object.h"
#include "math_util.h"
#include "message.h"
#include "player_avatar.h"
#include "render_oam.h"
#include "script_manager.h"
#include "sound.h"
#include "sound_playback.h"
#include "string_gf.h"
#include "sys_task.h"
#include "sys_task_manager.h"
#include "system.h"
#include "text.h"
#include "touch_pad.h"
#include "touch_screen.h"
#include "unk_0203C954.h"

#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0196.h"

// Sovereign Complete: HeartGold's Dowsing Machine (include/complete_dowsing.h), its overlay 28 written in C from pret's
// assembly: each function names the ov28 one it is. The radar's circle (BG1, with its dots on BG2 under it), the four
// needles that circle it, and the field's touch-screen buttons around it (HeartGold's a/0/1/4) are drawn as the photo
// caption draws its buttons: their cells straight into the bottom screen's OAM, the needles with their own affine
// matrices, since the field's sprite renderer is Platinum's.

#define HEAP_ID_DOWSING HEAP_ID_POKETCH_APP

#define RADAR_X       84 // the radar's centre, the player, on the bottom screen; each tile is 8 pixels
#define RADAR_Y       100
#define RADAR_RADIUS  72
#define NEEDLE_RADIUS 68
#define DOTS_SIZE     15 // the dots' grid, from tile (3, 5)
#define DOTS_LEFT     3
#define DOTS_TOP      5
#define SEARCH_RANGE  17 // HeartGold's AllocAndFetchNearbyHiddenItems: the tiles around the player searched
#define NUM_NEEDLES   4
#define NUM_LABELS    5

// The archive's members (tools/complete/import_hgss_dowsing.py)
enum {
    GFX_FRAME_NSCR = 0,
    GFX_DOTS_NSCR,
    GFX_BG_NCGR,
    GFX_BG_NCLR,
    GFX_NEEDLE_NCGR,
    GFX_NEEDLE_NCER,
    GFX_NEEDLE_NANR,
    GFX_NEEDLE_NCLR,
    GFX_BUTTONS_NCLR,
    GFX_BUTTONS_NCER,
    GFX_BUTTONS_NANR,
    GFX_BUTTONS_NCGR,
};

#define BUTTON_PALETTES 4 // the buttons' palettes, then the needles' nine
#define NEEDLE_PALETTES 9

// HeartGold's sprites: the A button, the running shoes (two parts) and EXIT, from the buttons' cells
enum {
    BUTTON_A = 0,
    BUTTON_SHOES,
    BUTTON_SHOES_2,
    BUTTON_EXIT,
    NUM_BUTTONS,
};

// The A button's label: what A does (HeartGold's ov01_021E7F54 and ov28_0225E810)
enum {
    MODE_NOTHING = 0, // CHECK
    MODE_TALK,
    MODE_CHECK,
    MODE_FISHING,
    MODE_NEXT,
};

enum {
    LABEL_CHECK = 0,
    LABEL_TALK,
    LABEL_FISHING,
    LABEL_NEXT,
    LABEL_EXIT,
};

typedef struct DowsingNeedle {
    u32 angle; // in degrees, as drawn
    u32 target;
    u32 next; // the step from angle toward target
} DowsingNeedle;

typedef struct Dowsing {
    BOOL shutdown;
    FieldSystem *fieldSystem;
    BgConfig *bgConfig;
    SysTask *task;
    String *labels[NUM_LABELS];
    Window windows[NUM_LABELS];
    void *cellBankRaw[2];
    NNSG2dCellDataBank *cellBank[2]; // the buttons', the needles'
    void *animBankRaw[2];
    NNSG2dAnimBankData *animBank[2];
    u32 needleCharBase; // the needles' tiles, after the buttons'
    NNSG2dCellAnimation buttonAnims[NUM_BUTTONS];
    u8 buttonSeq[NUM_BUTTONS];
    BOOL buttonShown[NUM_BUTTONS];
    NNSG2dCellAnimation needleAnim;
    s16 nearestX; // the nearest hidden item, from the player
    s16 nearestZ;
    BOOL found;
    u32 level; // 0 nothing within range, 1 (far) to 4 (within 8 tiles)
    u32 touchX;
    u32 touchY;
    DowsingNeedle needles[NUM_NEEDLES];
    u16 needleSteps : 15; // frames left until the needles reach their targets
    u16 needlesSet : 1;
    s16 strength; // the needles' palette and blink, the beep's pitch
    u8 dots[DOTS_SIZE][DOTS_SIZE];
    u32 mode;
    u16 beepTimer;
    s16 pitch;
    BOOL touching;
    BOOL exitShown;
    BOOL exited;
} Dowsing;

static Dowsing *sDowsing;

// HeartGold's ov28_0225EB52: each label's window, all four of A's in the same place; EXIT's on its button
static const WindowTemplate sLabelWindows[NUM_LABELS] = {
    { BG_LAYER_SUB_0, 24, 20, 8, 2, 4, 0x11 },
    { BG_LAYER_SUB_0, 24, 20, 8, 2, 4, 0x01 },
    { BG_LAYER_SUB_0, 24, 20, 8, 2, 4, 0x21 },
    { BG_LAYER_SUB_0, 24, 20, 8, 2, 4, 0x31 },
    { BG_LAYER_SUB_0, 26, 2, 6, 2, 4, 0x41 },
};

// HeartGold's ov28_0225D764: CHECK, TALK, FISHING, NEXT, EXIT
static const u16 sLabelMessages[NUM_LABELS] = { msg_0196_00018, msg_0196_00017, msg_0196_00022, msg_0196_00023, msg_0196_00021 };

// HeartGold's ov28_0225EB7C: the label each mode shows
static const u8 sModeLabels[] = { LABEL_CHECK, LABEL_TALK, LABEL_CHECK, LABEL_FISHING, LABEL_NEXT };

// HeartGold's ov28_0225EA9A...ov28_0225EAA6: each button's place, its draw order and its first animation
static const s16 sButtonPos[NUM_BUTTONS][2] = { { 168, 144 }, { 184, 86 }, { 210, 94 }, { 200, 8 } };

// HeartGold's ov28_0225EA88, _0225EA7C, ov28_0225EA84 and ov28_0225EA80: the radar's circle, the A button, the
// running shoes and EXIT
static const TouchScreenHitTable sRadarCircle[] = {
    { .circle = { TOUCHSCREEN_USE_CIRCLE, RADAR_X, RADAR_Y, RADAR_RADIUS } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR, 0, 0, 0 } },
};
static const TouchScreenHitTable sAButtonRect = { .rect = { 144, 188, 157, 255 } };
static const TouchScreenHitTable sShoesRect = { .rect = { 86, 134, 178, 252 } };
static const TouchScreenHitTable sExitRect = { .rect = { 8, 39, 192, 255 } };

// HeartGold's ov28_0225EA90: for each level, the needles' strongest and the dots' brightest away from an item
static const u8 sStrengthMax[] = { 49, 79, 109, 129, 159 };
static const u8 sDotMax[] = { 29, 39, 49, 49, 159 };

// HeartGold's ov28_0225EB84: how fast the needles' strength rises at each level
static const u8 sStrengthStep[] = { 1, 2, 2, 2, 4 };

// HeartGold's ov28_0225EB14: the grid's corners outside the circle, a bit per column
static const u16 sDotMask[DOTS_SIZE] = { 0x7C1F, 0x7007, 0x6003, 0x4001, 0x4001, 0, 0, 0, 0, 0, 0x4001, 0x4001, 0x6003, 0x7007, 0x7C1F };

// HeartGold's ov28_0225EB32: a dot's tile at each brightness (a tenth of it)
static const u16 sDotTiles[16] = { 0x306D, 0x206E, 0x206F, 0x2070, 0x2071, 0x2072, 0x2073, 0x2074, 0x2075, 0x2076, 0x2077, 0x2078, 0x2079, 0x207A, 0x207B, 0x207C };

// HeartGold's ov01_02206C08, in the engine's graphics IDs: what A checks rather than talks to
static const u16 sCheckedObjects[] = {
    OBJ_EVENT_GFX_ICE_ROCK,
    OBJ_EVENT_GFX_HGSS_GTOROPHY,
    OBJ_EVENT_GFX_HGSS_MEDAL,
    OBJ_EVENT_GFX_ROTOM_FAN,
    OBJ_EVENT_GFX_ROTOM_FROST,
    OBJ_EVENT_GFX_ROTOM_HEAT,
    OBJ_EVENT_GFX_ROTOM_WASH,
    OBJ_EVENT_GFX_ROTOM_MOW,
    OBJ_EVENT_GFX_HGSS_STATUEHERO,
    OBJ_EVENT_GFX_HGSS_STATUEHEROINE,
    OBJ_EVENT_GFX_STRENGTH_BOULDER,
    OBJ_EVENT_GFX_ROCK_SMASH,
    OBJ_EVENT_GFX_CUT_TREE,
    OBJ_EVENT_GFX_POKEBALL,
    OBJ_EVENT_GFX_HGSS_BONGURI,
    OBJ_EVENT_GFX_HGSS_BTOROPHY,
    OBJ_EVENT_GFX_HGSS_SCROLL,
    OBJ_EVENT_GFX_BOOK,
    OBJ_EVENT_GFX_HGSS_SIGNSHOES,
    OBJ_EVENT_GFX_HGSS_SIGNCLOTHES,
    OBJ_EVENT_GFX_HGSS_SIGNFLAG,
    OBJ_EVENT_GFX_HGSS_SIGNPOKEGEAR,
    OBJ_EVENT_GFX_HGSS_SIGNBALL,
    OBJ_EVENT_GFX_ELITE_FOUR_ROOM_DOOR,
    OBJ_EVENT_GFX_HGSS_STOROPHY,
    OBJ_EVENT_GFX_BOLLARD,
};

static void SetTestState(Dowsing *dowsing);

// HeartGold's ov01_021F6BD0 and ov01_021F6BB0: a facing object A checks (an item, a berry tree, a field move's rock
// or tree, one of the objects above)
static BOOL IsCheckedObject(MapObject *object)
{
    u32 script = MapObject_GetScript(object);
    u32 gfx = MapObject_GetGraphicsID(object);

    if ((script >= SCRIPT_ID_OFFSET_VISIBLE_ITEMS && script < SCRIPT_ID_OFFSET_SAFARI_GAME)
        || (script >= SCRIPT_ID_OFFSET_BERRY_TREE_INTERACTIONS && script < SCRIPT_ID_OFFSET_SINGLE_BATTLES)
        || (script >= SCRIPT_ID_OFFSET_FIELD_MOVES && script < SCRIPT_ID_OFFSET_TV_BROADCAST)) {
        return TRUE;
    }

    for (int i = 0; i < NELEMS(sCheckedObjects); i++) {
        if (gfx == sCheckedObjects[i]) {
            return TRUE;
        }
    }

    return FALSE;
}

// HeartGold's ov01_021E7F54: what's in front of the player
static u32 FacingMode(FieldSystem *fieldSystem)
{
    MapObject *object;

    if (sub_0203CA40(fieldSystem, &object) == TRUE) {
        return IsCheckedObject(object) ? MODE_NOTHING : MODE_TALK;
    }

    if (FieldEvent_GetInteractedBgEventScript(fieldSystem, MapHeaderData_GetBgEvents(fieldSystem), MapHeaderData_GetNumBgEvents(fieldSystem)) != 0xFFFF) {
        return MODE_CHECK;
    }

    return MODE_NOTHING;
}

// HeartGold's fieldSystem->textbox_open: a script's message box is open
static BOOL MessageBoxOpen(FieldSystem *fieldSystem)
{
    if (fieldSystem->task == NULL) {
        return FALSE;
    }

    ScriptManager *scriptManager = FieldTask_GetEnv(fieldSystem->task);

    return scriptManager != NULL && scriptManager->magic == SCRIPT_MANAGER_MAGIC_NUMBER && scriptManager->isMsgBoxOpen;
}

// HeartGold's ov28_0225EA58: a task runs on the field (a script, a menu), so the buttons that would start another hide
static BOOL FieldBusy(Dowsing *dowsing)
{
    return FieldSystem_IsRunningTask(dowsing->fieldSystem);
}

static void SetButtonAnim(Dowsing *dowsing, int button, int seq)
{
    NNS_G2dInitCellAnimation(&dowsing->buttonAnims[button], NNS_G2dGetAnimSequenceByIdx(dowsing->animBank[0], seq), dowsing->cellBank[0]);
    dowsing->buttonSeq[button] = seq;
}

// HeartGold's AllocAndFetchNearbyHiddenItems and ov28_0225DD58: the nearest hidden item still there, within 17 tiles
// each way, by steps (the first found of the nearest)
static void FindNearestItem(Dowsing *dowsing)
{
    FieldSystem *fieldSystem = dowsing->fieldSystem;
    const BgEvent *bgEvents = MapHeaderData_GetBgEvents(fieldSystem);
    int numBgEvents = MapHeaderData_GetNumBgEvents(fieldSystem);
    int playerX = PlayerAvatar_GetXPos(fieldSystem->playerAvatar);
    int playerZ = PlayerAvatar_GetZPos(fieldSystem->playerAvatar);
    u16 nearest = 0;

    dowsing->found = FALSE;

    if (bgEvents == NULL) {
        return;
    }

    for (int i = 0; i < numBgEvents; i++) {
        if (bgEvents[i].type != BG_EVENT_TYPE_HIDDEN_ITEM || FieldSystem_CheckFlag(fieldSystem, Script_GetHiddenItemFlag(bgEvents[i].script))) {
            continue;
        }

        int dx = bgEvents[i].x - playerX;
        int dz = bgEvents[i].z - playerZ;

        if (dx < -SEARCH_RANGE || dx > SEARCH_RANGE || dz < -SEARCH_RANGE || dz > SEARCH_RANGE) {
            continue;
        }

        u16 distance = abs(dx) + abs(dz);

        if (!dowsing->found || distance < nearest) {
            nearest = distance;
            dowsing->nearestX = dx;
            dowsing->nearestZ = dz;
            dowsing->found = TRUE;
        }
    }
}

// HeartGold's ov28_0225DE88: an angle's index in degrees
static u32 IdxToDegrees(u16 idx)
{
    return (u16)((u32)idx * 360 >> 16);
}

// HeartGold's ov28_0225DE78: the angle toward (x, y)
static u32 AngleTo(int x, int y)
{
    return IdxToDegrees(FX_Atan2Idx(y << FX32_SHIFT, x << FX32_SHIFT));
}

// HeartGold's ov28_0225DE64: the touch's angle from the radar's centre
static u32 TouchAngle(Dowsing *dowsing)
{
    return AngleTo((int)dowsing->touchX - RADAR_X, (int)dowsing->touchY - RADAR_Y);
}

// HeartGold's ov28_0225DE98...ov28_0225E0DC: each level's step toward the target, slower when far
static void StepNeedle(DowsingNeedle *needle, u32 level)
{
    switch (level) {
    case 0:
        needle->next = (needle->angle * 5 + needle->target) / 6;
        break;
    case 1:
        needle->next = (needle->angle * 3 + needle->target) >> 2;
        break;
    case 2:
        needle->next = (needle->angle * 2 + needle->target) / 3;
        break;
    case 3:
        needle->next = (needle->target + needle->angle) >> 1;
        break;
    default:
        needle->next = (needle->target * 2 + needle->angle) / 3;
        break;
    }
}

static void SetTargets(Dowsing *dowsing, u32 t0, u32 t1, u32 t2, u32 t3, u32 steps)
{
    dowsing->needles[0].target = t0;
    dowsing->needles[1].target = t1;
    dowsing->needles[2].target = t2;
    dowsing->needles[3].target = t3;
    dowsing->needleSteps = steps;
}

// HeartGold's ov28_0225E1A4 (with ov28_0225DEB0, DF14, DFBC, E060 and E0F4): as the radar is held, the needles' targets
// at the item's level: around the touch with nothing near, pulled more toward the item the nearer it is, and within 8
// tiles all four pointing at it from the touch
static void UpdateTargets(Dowsing *dowsing)
{
    FindNearestItem(dowsing);

    u32 a = TouchAngle(dowsing);

    if (!dowsing->found) {
        SetTargets(dowsing, a, a + 300, a + 120, a + 216, 6);
        dowsing->level = 0;
    } else {
        int ax = abs(dowsing->nearestX);
        int az = abs(dowsing->nearestZ);
        u32 b = AngleTo(dowsing->nearestX, dowsing->nearestZ);

        if (ax <= 8 && az <= 8) {
            int ix = dowsing->nearestX * 8 + RADAR_X;
            int iz = dowsing->nearestZ * 8 + RADAR_Y;
            int tx = dowsing->touchX;
            int ty = dowsing->touchY;

            SetTargets(dowsing, AngleTo(ix - tx, iz - ty), AngleTo(ix + 10 - tx, iz + 12 - ty), AngleTo(ix - 12 - tx, iz - 4 - ty), AngleTo(ix - 8 - tx, iz - 8 - ty), 3);
            dowsing->level = 4;
        } else if (ax <= 12 && az <= 12) {
            SetTargets(dowsing, (a + b) / 3, (b + 60 + a) >> 1, (b - 72 + a) >> 1, ((a + 90) + (b + 45)) >> 1, 2);
            dowsing->level = 3;
        } else if (ax <= SEARCH_RANGE && az <= SEARCH_RANGE) {
            SetTargets(dowsing, (a * 2 + b) / 3, ((a + 30) * 2 + (b + 135)) / 3, ((a - 36) * 2 + (b - 120)) / 3, ((a + 90) * 2 + (b + 60)) / 3, 3);
            dowsing->level = 2;
        } else {
            SetTargets(dowsing, (a * 3 + b) >> 2, ((a + 30) * 3 + (b + 120)) >> 2, ((a - 36) * 3 + (b - 135)) >> 2, ((a + 90) * 3 + (b + 90)) >> 2, 4);
            dowsing->level = 1;
        }
    }

    if (!dowsing->needlesSet) {
        for (int i = 0; i < NUM_NEEDLES; i++) {
            dowsing->needles[i].angle = dowsing->needles[i].target;
            dowsing->needles[i].next = dowsing->needles[i].target;
        }

        dowsing->needlesSet = TRUE;
        dowsing->needleSteps = 1;
        return;
    }

    for (int i = 0; i < NUM_NEEDLES; i++) {
        DowsingNeedle *needle = &dowsing->needles[i];

        needle->target %= 360;
        needle->angle %= 360;

        if (abs((int)needle->target - (int)needle->angle) >= 180) { // the short way round
            if (needle->target > needle->angle) {
                needle->angle += 360;
            } else if (needle->target < needle->angle) {
                needle->target += 360;
            }
        }

        StepNeedle(needle, dowsing->level);
    }
}

// HeartGold's ov28_0225E31C: the needles' strength rises while the radar is held, and fades after
static void UpdateStrength(Dowsing *dowsing, int dir)
{
    if (dir >= 0) {
        dowsing->strength += sStrengthStep[dowsing->level] * dir;

        if (dowsing->strength > sStrengthMax[dowsing->level]) {
            dowsing->strength = sStrengthMax[dowsing->level];
        }
    } else if (dowsing->strength > 0) {
        dowsing->strength--;
    }
}

// HeartGold's ov28_0225E374: the needles' palette (a twentieth of the strength) and blink (its tenths, odd or even)
static void StrengthLook(Dowsing *dowsing, u16 *blink, u16 *palette)
{
    if (dowsing->strength > sStrengthMax[dowsing->level]) {
        dowsing->strength = sStrengthMax[dowsing->level];
    }

    *blink = (dowsing->strength / 10) & 1;
    *palette = dowsing->strength / 20;
}

// HeartGold's ov28_0225E51C: how bright a dot gets: within 8 tiles of an item, brightest over it
static u8 DotTarget(Dowsing *dowsing, int x, int y)
{
    if (dowsing->level != 4) {
        return sDotMax[dowsing->level];
    }

    int v = 16 - (abs(dowsing->nearestX + 7 - x) + abs(dowsing->nearestZ + 7 - y));

    if (v < 5) {
        v = 5;
    } else if (v > 16) {
        v = 16;
    }

    return 10 * v - 1;
}

// HeartGold's ov28_0225E578: the dots within 4 steps of the touch light up toward their brightness, and the rest fade
static void UpdateDots(Dowsing *dowsing, BOOL touching)
{
    int tx = 0, ty = 0;
    u16 lit = 0;

    if (touching) {
        tx = (s16)((dowsing->touchX >> 3) - DOTS_LEFT);
        ty = (s16)((dowsing->touchY >> 3) - DOTS_TOP);
    }

    for (int row = 0; row < DOTS_SIZE; row++) {
        for (int col = 0; col < DOTS_SIZE; col++) {
            if (sDotMask[row] & (1 << col)) {
                continue;
            }

            u8 *dot = &dowsing->dots[row][col];

            if (touching && col >= tx - 3 && col <= tx + 3 && row >= ty - 3 && row <= ty + 3 && abs(tx - col) + abs(ty - row) <= 4) {
                u8 target = DotTarget(dowsing, col, row);

                if (*dot < target) {
                    *dot += 10;

                    if (*dot > target) {
                        *dot = target;
                    }
                } else {
                    *dot = target;
                }
            } else {
                *dot = *dot >= 2 ? *dot - 2 : 0;
            }

            if (*dot == 0) {
                Bg_FillTilemapRect(dowsing->bgConfig, BG_LAYER_SUB_2, 0x1001, col + DOTS_LEFT, row + DOTS_TOP, 1, 1, TILEMAP_FILL_VAL_INCLUDES_PALETTE);
            } else {
                Bg_FillTilemapRect(dowsing->bgConfig, BG_LAYER_SUB_2, sDotTiles[*dot / 10], col + DOTS_LEFT, row + DOTS_TOP, 1, 1, TILEMAP_FILL_VAL_INCLUDES_PALETTE);
                lit++;
            }
        }
    }

    Bg_ScheduleTilemapTransfer(dowsing->bgConfig, BG_LAYER_SUB_2);
#ifdef SOVEREIGN_TEST
    gCompleteTestDowsing[9] = lit;
#endif
}

// HeartGold's ov28_0225E730: the beep, every eleventh frame, higher as the needles strengthen and, within 8 tiles,
// as the touch nears the item
static void Beep(Dowsing *dowsing)
{
    u16 blink, palette;

    StrengthLook(dowsing, &blink, &palette);

    s16 pitch = ((palette * 2 + blink) << 6) - 960;

    if (dowsing->level == 4) {
        int tx = (dowsing->touchX >> 3) - DOTS_LEFT;
        int ty = (dowsing->touchY >> 3) - DOTS_TOP;

        pitch += (16 - (abs(dowsing->nearestX + 7 - tx) + abs(dowsing->nearestZ + 7 - ty))) << 6;
    }

    if (dowsing->beepTimer == 0) {
        Sound_PlayEffect(SEQ_SE_GS_DOWSING_SINGLE_sseq);
        Sound_SetPitchForSequence(SEQ_SE_GS_DOWSING_SINGLE_sseq, 0xFFFF, pitch);
    }

    dowsing->beepTimer = dowsing->beepTimer == 10 ? 0 : dowsing->beepTimer + 1;
    dowsing->pitch = pitch;
}

// HeartGold's ov28_0225E7D4
static void ReadTouch(Dowsing *dowsing)
{
    dowsing->touchX = gSystem.touchX;
    dowsing->touchY = gSystem.touchY;
}

// HeartGold's ov28_0225DE04: a needle's place on the circle
static void NeedlePos(u32 angle, NNSG2dFVec2 *pos)
{
    pos->x = FX_Mul(CalcCosineDegrees_Wraparound(angle), NEEDLE_RADIUS << FX32_SHIFT) + (RADAR_X << FX32_SHIFT);
    pos->y = FX_Mul(CalcSineDegrees_Wraparound(angle), NEEDLE_RADIUS << FX32_SHIFT) + (RADAR_Y << FX32_SHIFT);
}

// HeartGold's ov28_0225E43C: the needles step toward their targets, there on the last step
static void MoveNeedles(Dowsing *dowsing)
{
    if (dowsing->needleSteps == 0) {
        return;
    }

    dowsing->needleSteps--;

    for (int i = 0; i < NUM_NEEDLES; i++) {
        DowsingNeedle *needle = &dowsing->needles[i];

        if (dowsing->needleSteps == 0) {
            needle->angle = needle->target;
        } else {
            needle->angle = needle->next;
            StepNeedle(needle, dowsing->level);
        }
    }
}

// The cell's OAMs into the bottom screen's OAM, under the labels (BG0) and over the radar (BG1, BG2)
static void DrawCell(const NNSG2dCellData *cell, const NNSG2dFVec2 *pos, u32 charBase, int paletteBase, int palette, const MtxFx22 *mtx)
{
    GXOamAttr oams[16];
    NNSG2dOamManagerInstance *oamMan = RenderOam_GetScreenOam(DS_SCREEN_SUB);
    int count;

    if (mtx != NULL) {
        u16 affineIdx = NNS_G2dEntryOamManagerAffine(oamMan, mtx);

        count = NNS_G2dMakeCellToOams(oams, NELEMS(oams), cell, mtx, pos, affineIdx, TRUE);
    } else {
        count = NNS_G2dMakeCellToOams(oams, NELEMS(oams), cell, NULL, pos, 0, FALSE);
    }

    for (int i = 0; i < count; i++) {
        G2_SetOBJPriority(&oams[i], 1);
        oams[i].charNo += charBase;
        oams[i].cParam = palette >= 0 ? paletteBase + palette : oams[i].cParam + paletteBase;
    }

    NNS_G2dEntryOamManagerOam(oamMan, oams, count);
}

static void DrawButton(Dowsing *dowsing, int button)
{
    if (!dowsing->buttonShown[button]) {
        return;
    }

    NNSG2dFVec2 pos = { sButtonPos[button][0] << FX32_SHIFT, sButtonPos[button][1] << FX32_SHIFT };

    DrawCell(NNS_G2dGetCellAnimationCurrentCell(&dowsing->buttonAnims[button]), &pos, 0, 0, -1, NULL);
    NNS_G2dTickCellAnimation(&dowsing->buttonAnims[button], FX32_ONE);
}

// HeartGold's ov28_0225E3BC and ov28_0225E424: the needles, shown while they've strength, in its palette and blink,
// each turned to its angle
static void DrawNeedles(Dowsing *dowsing)
{
    u16 blink, palette;

    if (dowsing->strength == 0) {
        return;
    }

    StrengthLook(dowsing, &blink, &palette);
    NNS_G2dInitCellAnimation(&dowsing->needleAnim, NNS_G2dGetAnimSequenceByIdx(dowsing->animBank[1], blink), dowsing->cellBank[1]);

    for (int i = 0; i < NUM_NEEDLES; i++) {
        NNSG2dFVec2 pos;
        MtxFx22 mtx;
        u16 rot = CalcAngleRotationIdx_Wraparound(dowsing->needles[i].angle);

        NeedlePos(dowsing->needles[i].angle, &pos);
        MTX_Rot22(&mtx, FX_SinIdx(rot), FX_CosIdx(rot));
        DrawCell(NNS_G2dGetCellAnimationCurrentCell(&dowsing->needleAnim), &pos, dowsing->needleCharBase, BUTTON_PALETTES, palette + 1, &mtx);
    }
}

// HeartGold's ov28_0225E8B8: a button held after a touch on it shows pressed
static BOOL PressButton(Dowsing *dowsing, int button, const TouchScreenHitTable *rect, int seq, int pressedSeq)
{
    BOOL held = TouchScreen_LocationHeld(rect);

    if (held && gSystem.touchPressed) {
        SetButtonAnim(dowsing, button, pressedSeq);
        return TRUE;
    }

    if (held && dowsing->buttonSeq[button] == pressedSeq) {
        return TRUE;
    }

    SetButtonAnim(dowsing, button, seq);
    return FALSE;
}

static void ShowLabel(Dowsing *dowsing, u32 mode)
{
    dowsing->mode = mode;
    Window_ScheduleCopyToVRAM(&dowsing->windows[sModeLabels[mode]]);
}

// HeartGold's ov28_0225E810: what A does now
static void UpdateMode(Dowsing *dowsing)
{
    FieldSystem *fieldSystem = dowsing->fieldSystem;
    u32 mode = dowsing->mode;

    if (MessageBoxOpen(fieldSystem)) {
        mode = MODE_NEXT;
    } else if (FieldSystem_IsRunningTask(fieldSystem)) {
        u32 gfx = MapObject_GetGraphicsID(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar));

        if (gfx == OBJ_EVENT_GFX_PLAYER_M_FISHING || gfx == OBJ_EVENT_GFX_PLAYER_F_FISHING) { // HeartGold's: a rod out
            mode = MODE_FISHING;
        }
    } else {
        mode = FacingMode(fieldSystem);
    }

    if (mode != dowsing->mode) {
        ShowLabel(dowsing, mode);
    }
}

// HeartGold's ov28_0225E900: the A button, A while it's held
static void UpdateAButton(Dowsing *dowsing)
{
    if (FieldSystem_IsRunningFieldMapInner(dowsing->fieldSystem)) {
        UpdateMode(dowsing);
    }

    if (PressButton(dowsing, BUTTON_A, &sAButtonRect, 5, 6)) {
        gCompleteSimulatedKeys |= PAD_BUTTON_A;
    }
}

static void ShowShoes(Dowsing *dowsing, BOOL on)
{
    SetButtonAnim(dowsing, BUTTON_SHOES, on ? 4 : 3);
    SetButtonAnim(dowsing, BUTTON_SHOES_2, on ? 7 : 11);
}

// HeartGold's ov28_0225E938: the running shoes, a touch to turn them on or off, hidden on the bike or while the field
// is busy
static void UpdateShoes(Dowsing *dowsing)
{
    FieldSystem *fieldSystem = dowsing->fieldSystem;
    BOOL shown = PlayerAvatar_GetPlayerState(fieldSystem->playerAvatar) != PLAYER_AVATAR_CYCLING && !FieldBusy(dowsing);

    dowsing->buttonShown[BUTTON_SHOES] = shown;
    dowsing->buttonShown[BUTTON_SHOES_2] = shown;

    if (shown && TouchScreen_LocationPressed(&sShoesRect)) {
        BOOL on = !CompleteDowsing_RunningShoesOn(fieldSystem->saveData);

        CompleteDowsing_SetRunningShoes(fieldSystem->saveData, on);
        ShowShoes(dowsing, on);
    }
}

// HeartGold's ov28_0225E9E0: EXIT, hidden while the field is busy; touched, the Pokégear or Pokétch comes back
static void UpdateExit(Dowsing *dowsing)
{
    if (FieldBusy(dowsing)) {
        if (dowsing->exitShown) {
            Window_ClearAndScheduleCopyToVRAM(&dowsing->windows[LABEL_EXIT]);
            dowsing->exitShown = FALSE;
        }

        SetButtonAnim(dowsing, BUTTON_EXIT, 8);
        dowsing->buttonShown[BUTTON_EXIT] = FALSE;
        return;
    }

    if (!dowsing->exitShown) {
        Window_ScheduleCopyToVRAM(&dowsing->windows[LABEL_EXIT]);
        dowsing->exitShown = TRUE;
    }

    dowsing->buttonShown[BUTTON_EXIT] = TRUE;

    if (PressButton(dowsing, BUTTON_EXIT, &sExitRect, 8, 9) && !dowsing->exited) {
        dowsing->exited = TRUE;
        CompleteDowsing_SetOn(FALSE);
    }
}

// HeartGold's ov28_0225D650 and ov28_0225D6FC: the labels on BG0, the radar's frame on BG1 and its dots on BG2 under it
static void LoadGraphics(Dowsing *dowsing, NARC *narc)
{
    static const BgTemplate sLabelTemplate = { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x7800, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 0, 0, FALSE };
    static const BgTemplate sFrameTemplate = { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x7000, GX_BG_CHARBASE_0x00000, GX_BG_EXTPLTT_01, 1, 0, FALSE };
    static const BgTemplate sDotsTemplate = { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x6800, GX_BG_CHARBASE_0x00000, GX_BG_EXTPLTT_01, 2, 0, FALSE };
    BgConfig *bgConfig = dowsing->bgConfig;

    // HeartGold's ov28_0225D628
    GX_SetBankForSubBG(GX_VRAM_SUB_BG_32_H);
    GX_SetBankForSubOBJ(GX_VRAM_SUB_OBJ_16_I);
    GXS_SetOBJVRamModeChar(GX_OBJVRAMMODE_CHAR_1D_32K);
    GXS_SetGraphicsMode(GX_BGMODE_0);
    G2S_BlendNone();

    Bg_InitFromTemplate(bgConfig, BG_LAYER_SUB_0, &sLabelTemplate, BG_TYPE_STATIC);
    Bg_ClearTilesRange(BG_LAYER_SUB_0, 0x20, 0, HEAP_ID_DOWSING);
    Bg_ClearTilemap(bgConfig, BG_LAYER_SUB_0);
    Bg_InitFromTemplate(bgConfig, BG_LAYER_SUB_1, &sFrameTemplate, BG_TYPE_STATIC);
    Bg_InitFromTemplate(bgConfig, BG_LAYER_SUB_2, &sDotsTemplate, BG_TYPE_STATIC);

    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_BG_NCGR, bgConfig, BG_LAYER_SUB_1, 0, 0, TRUE, HEAP_ID_DOWSING);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_FRAME_NSCR, bgConfig, BG_LAYER_SUB_1, 0, 0, TRUE, HEAP_ID_DOWSING);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_DOTS_NSCR, bgConfig, BG_LAYER_SUB_2, 0, 0, TRUE, HEAP_ID_DOWSING);
    Graphics_LoadPaletteFromOpenNARC(narc, GFX_BG_NCLR, PAL_LOAD_SUB_BG, 0, 0, HEAP_ID_DOWSING);

    // HeartGold's ov28_0225DA74 and ov28_0225DB8C: the buttons' tiles, then the needles'; the buttons' four palettes,
    // then the needles' nine
    u32 buttonTiles = Graphics_LoadObjectTiles(NARC_INDEX_GRAPHIC__COMPLETE__DOWSING, GFX_BUTTONS_NCGR, DS_SCREEN_SUB, 0, 0, TRUE, HEAP_ID_DOWSING);

    Graphics_LoadObjectTiles(NARC_INDEX_GRAPHIC__COMPLETE__DOWSING, GFX_NEEDLE_NCGR, DS_SCREEN_SUB, buttonTiles, 0, TRUE, HEAP_ID_DOWSING);
    dowsing->needleCharBase = buttonTiles / 32;
    Graphics_LoadPaletteFromOpenNARC(narc, GFX_BUTTONS_NCLR, PAL_LOAD_SUB_OBJ, 0, PALETTE_SIZE_BYTES * BUTTON_PALETTES, HEAP_ID_DOWSING);
    Graphics_LoadPaletteFromOpenNARC(narc, GFX_NEEDLE_NCLR, PAL_LOAD_SUB_OBJ, PALETTE_SIZE_BYTES * BUTTON_PALETTES, PALETTE_SIZE_BYTES * NEEDLE_PALETTES, HEAP_ID_DOWSING);
    dowsing->cellBankRaw[0] = Graphics_GetCellBankFromOpenNARC(narc, GFX_BUTTONS_NCER, TRUE, &dowsing->cellBank[0], HEAP_ID_DOWSING);
    dowsing->animBankRaw[0] = Graphics_GetAnimBankFromOpenNARC(narc, GFX_BUTTONS_NANR, TRUE, &dowsing->animBank[0], HEAP_ID_DOWSING);
    dowsing->cellBankRaw[1] = Graphics_GetCellBankFromOpenNARC(narc, GFX_NEEDLE_NCER, TRUE, &dowsing->cellBank[1], HEAP_ID_DOWSING);
    dowsing->animBankRaw[1] = Graphics_GetAnimBankFromOpenNARC(narc, GFX_NEEDLE_NANR, TRUE, &dowsing->animBank[1], HEAP_ID_DOWSING);

    SetButtonAnim(dowsing, BUTTON_A, 5);
    SetButtonAnim(dowsing, BUTTON_EXIT, 8);
    ShowShoes(dowsing, CompleteDowsing_RunningShoesOn(dowsing->fieldSystem->saveData));
    dowsing->buttonShown[BUTTON_A] = TRUE;

    GXS_SetVisiblePlane(GX_PLANEMASK_BG0 | GX_PLANEMASK_BG1 | GX_PLANEMASK_BG2 | GX_PLANEMASK_OBJ);
}

// HeartGold's ov28_0225D7E0: every label printed, the one for A's mode and EXIT shown
static void PrintLabels(Dowsing *dowsing)
{
    for (int i = 0; i < NUM_LABELS; i++) {
        Window_AddFromTemplate(dowsing->bgConfig, &dowsing->windows[i], &sLabelWindows[i]);
        Window_FillTilemap(&dowsing->windows[i], 0);
        Text_AddPrinterWithParamsAndColor(&dowsing->windows[i], FONT_SUBSCREEN, dowsing->labels[i], 0, 0, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(15, 1, 0), NULL);
        Window_LoadTiles(&dowsing->windows[i]);
    }

    ShowLabel(dowsing, dowsing->mode);
    Window_ScheduleCopyToVRAM(&dowsing->windows[LABEL_EXIT]);
    dowsing->exitShown = TRUE;
}

// HeartGold's ov28_0225D5EC
static void Shutdown(Dowsing *dowsing)
{
    DisableTouchPad();
    Sound_StopEffect(SEQ_SE_GS_DOWSING_SINGLE_sseq, 0);

    for (int i = 0; i < NUM_LABELS; i++) {
        Window_ClearAndCopyToVRAM(&dowsing->windows[i]);
        Window_Remove(&dowsing->windows[i]);
        String_Free(dowsing->labels[i]);
    }

    Font_Free(FONT_SUBSCREEN);

    for (int i = 0; i < 2; i++) {
        Heap_Free(dowsing->cellBankRaw[i]);
        Heap_Free(dowsing->animBankRaw[i]);
    }

    Bg_FreeTilemapBuffer(dowsing->bgConfig, BG_LAYER_SUB_2);
    Bg_FreeTilemapBuffer(dowsing->bgConfig, BG_LAYER_SUB_1);
    Bg_FreeTilemapBuffer(dowsing->bgConfig, BG_LAYER_SUB_0);
}

// HeartGold's ov28_0225DC2C, each frame: the radar while it's held (not while a task runs on the field), then the
// needles and the buttons
static void Dowsing_Task(SysTask *task, void *data)
{
    Dowsing *dowsing = data;

    if (dowsing->shutdown) {
        Shutdown(dowsing);
        SysTask_Done(task);
        Heap_Free(dowsing);
        sDowsing = NULL;
#ifdef SOVEREIGN_TEST
        gCompleteTestDowsing[0] = 0;
#endif
        Heap_Destroy(HEAP_ID_DOWSING);
        return;
    }

    if (!dowsing->touching && TouchScreen_CheckPressedHitTableID(sRadarCircle) != TOUCHSCREEN_INPUT_NONE) {
        dowsing->touching = TRUE;
    }

    if (FieldSystem_IsRunningTask(dowsing->fieldSystem) || TouchScreen_CheckHeldHitTableID(sRadarCircle) == TOUCHSCREEN_INPUT_NONE || !dowsing->touching) {
        UpdateStrength(dowsing, -1);
        UpdateDots(dowsing, FALSE);
        dowsing->needlesSet = FALSE;
        dowsing->beepTimer = 0;
        dowsing->pitch = 0;
        dowsing->touching = FALSE;
        Sound_StopEffect(SEQ_SE_GS_DOWSING_SINGLE_sseq, 0);
    } else {
        ReadTouch(dowsing);
        UpdateTargets(dowsing);
        UpdateStrength(dowsing, 1);
        UpdateDots(dowsing, TRUE);
        Beep(dowsing);
    }

    MoveNeedles(dowsing);
    UpdateAButton(dowsing);
    UpdateShoes(dowsing);
    UpdateExit(dowsing);

    // HeartGold's draw order: the A button, the shoes' second part, EXIT and the needles over the shoes' first part
    DrawButton(dowsing, BUTTON_A);
    DrawButton(dowsing, BUTTON_SHOES_2);
    DrawButton(dowsing, BUTTON_EXIT);
    DrawNeedles(dowsing);
    DrawButton(dowsing, BUTTON_SHOES);
    SetTestState(dowsing);
}

static void SetTestState(Dowsing *dowsing)
{
#ifdef SOVEREIGN_TEST
    gCompleteTestDowsing[0] = 1;
    gCompleteTestDowsing[1] = dowsing->level;
    gCompleteTestDowsing[2] = (u16)dowsing->nearestX;
    gCompleteTestDowsing[3] = (u16)dowsing->nearestZ;
    gCompleteTestDowsing[4] = dowsing->found;
    gCompleteTestDowsing[5] = dowsing->strength;
    gCompleteTestDowsing[6] = dowsing->mode;
    gCompleteTestDowsing[7] = dowsing->touching;
    gCompleteTestDowsing[8] = dowsing->needles[0].angle;
    gCompleteTestDowsing[10] = (u16)dowsing->pitch;
    gCompleteTestDowsing[11] = CompleteDowsing_RunningShoesOn(dowsing->fieldSystem->saveData);
#endif
}

// HeartGold's ov28_0225D520
void CompleteDowsing_Create(FieldSystem *fieldSystem, BgConfig *bgConfig)
{
    Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_DOWSING, HEAP_SIZE_PRE_POKETCH_SUBSCREEN);

    Dowsing *dowsing = Heap_Alloc(HEAP_ID_DOWSING, sizeof(Dowsing));

    MI_CpuClear8(dowsing, sizeof(Dowsing));
    dowsing->fieldSystem = fieldSystem;
    dowsing->bgConfig = bgConfig;
    dowsing->mode = FacingMode(fieldSystem);
    Font_InitManager(FONT_SUBSCREEN, HEAP_ID_DOWSING); // HeartGold's FontID_Alloc(4)

    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_PRELOAD_ENTIRE_BANK, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0196, HEAP_ID_DOWSING);

    for (int i = 0; i < NUM_LABELS; i++) {
        dowsing->labels[i] = MessageLoader_GetNewString(loader, sLabelMessages[i]);
    }

    MessageLoader_Free(loader);

    NARC *narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__DOWSING, HEAP_ID_DOWSING);

    LoadGraphics(dowsing, narc);
    NARC_dtor(narc);
    PrintLabels(dowsing);
    UpdateDots(dowsing, FALSE);
    EnableTouchPad();
    InitializeTouchPad(4);
    dowsing->task = SysTask_Start(Dowsing_Task, dowsing, 0);
    sDowsing = dowsing;
}

void CompleteDowsing_StartShutdown(void)
{
    if (sDowsing != NULL) {
        sDowsing->shutdown = TRUE;
    }
}

BOOL CompleteDowsing_IsShutdown(void)
{
    return sDowsing == NULL;
}
