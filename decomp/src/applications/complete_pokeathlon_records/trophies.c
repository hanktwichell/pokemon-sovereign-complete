#include <nitro.h>

#include "constants/graphics.h"
#include "constants/heap.h"
#include "constants/narc.h"
#include "constants/species.h"
#include "generated/genders.h"
#include "generated/text_banks.h"

#include "applications/complete_pokeathlon_records/records_common.h"

#include "bg_window.h"
#include "complete_pokeathlon.h"
#include "complete_pokeathlon_records.h"
#include "font.h"
#include "graphics.h"
#include "gx_layers.h"
#include "heap.h"
#include "narc.h"
#include "overlay_manager.h"
#include "save_player.h"
#include "screen_fade.h"
#include "sound_playback.h"
#include "sprite.h"
#include "sprite_system.h"
#include "string_template.h"
#include "system.h"
#include "touch_pad.h"
#include "trainer_info.h"

#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0314.h"

// Sovereign Complete: HeartGold's fourth Pokéathlon record screen, the player's trophies
// (include/complete_pokeathlon_records.h), an app of its overlay 99 (ov99_021E677C to ov99_021E7124, its PokeathlonUnk,
// in assembly in pret's HeartGold), written in C on Platinum's libraries with its overlay 98's parts
// (records_common.c). The main engine is on the bottom screen: there, "<player>’s Trophies", the player's icon (a boy's
// or a girl's), the four trophies (Collective: 420 and 450 points on each course; Trust: medalists; Potential: events
// whose record reaches its goal; Friendship: the points in all), each a row of ten crowns lit for those earned, the
// trophies earned in all and the Pokéathlete's title they give (one a two, "A Rookie Pokéathlete" to "An Invincible
// Pokéathlete"); Return. On the top screen, the points in all (the course records', the event records' and the medals')
// in big digits, the next Friendship Trophy's goal and its crowns. B or touching Return closes it. HeartGold counts its
// 493 species' medals, Complete all its own; the big total shows at most 9999 (HeartGold's can't pass it).

#define HEAP_ID_TROPHIES   HEAP_ID_DIPLOMA // the diploma's, as the other HeartGold screens': they can't run together
#define TROPHIES_HEAP_SIZE 0x30000

#define NUM_TROPHY_KINDS     4
#define TROPHIES_PER_KIND    10
#define MAX_TROPHIES         (NUM_TROPHY_KINDS * TROPHIES_PER_KIND)
#define TROPHY_COUNT_DIGITS  2
#define TOTAL_DIGITS         4
#define MAX_TOTAL_SHOWN      9999 // four digits (HeartGold's can't pass it)

enum {
    STATE_FADE_IN = 0,
    STATE_WAIT_FADE_IN,
    STATE_INPUT,
    STATE_WAIT_FADE_OUT,
    STATE_EXIT,
};

// The archive (tools/complete/import_hgss_pokeathlon_records.py: HeartGold's a/1/7/7, member n as member n)
enum {
    GFX_CROWNS_PLTT = 0,
    GFX_CROWNS_CHAR,
    GFX_CROWNS_CELL,
    GFX_CROWNS_ANIM,
    GFX_DIGITS_PLTT = 8,
    GFX_DIGITS_CHAR,
    GFX_DIGITS_CELL,
    GFX_DIGITS_ANIM,
    GFX_PLAYER_PLTT = 16, // two palettes: a boy's, a girl's
    GFX_PLAYER_CHAR,
    GFX_PLAYER_CELL,
    GFX_PLAYER_ANIM,
    GFX_BOTTOM_PLTT = 56,
    GFX_BOTTOM_TILES,
    GFX_BOTTOM_TILEMAP,
    GFX_TOP_PLTT,
    GFX_TOP_TILES,
    GFX_TOP_TILEMAP,
};

enum { // the sprites, in HeartGold's order
    SPRITE_PLAYER = 0,
    SPRITE_TROPHY_COUNT, // two digits
    SPRITE_TOTAL = SPRITE_TROPHY_COUNT + TROPHY_COUNT_DIGITS, // the top screen's four
    SPRITE_COLLECTIVE = SPRITE_TOTAL + TOTAL_DIGITS, // ten crowns each
    SPRITE_TRUST = SPRITE_COLLECTIVE + TROPHIES_PER_KIND,
    SPRITE_POTENTIAL = SPRITE_TRUST + TROPHIES_PER_KIND,
    SPRITE_FRIENDSHIP = SPRITE_POTENTIAL + TROPHIES_PER_KIND,
    SPRITE_TOP_FRIENDSHIP = 57, // the top screen's row (HeartGold leaves ten slots unused before it)
    NUM_SPRITES = SPRITE_TOP_FRIENDSHIP + TROPHIES_PER_KIND,
};

enum { // the windows (ov99_021E9ED0)
    WINDOW_TITLE = 0, // "<player>’s Trophies"
    WINDOW_TROPHY_NAME, // four: "Collective Trophy" and the others
    WINDOW_EARNED = WINDOW_TROPHY_NAME + NUM_TROPHY_KINDS,
    WINDOW_RANK, // "“A Rookie Pokéathlete” / Qualified for his or her Trophies / and friendships with Pokémon."
    WINDOW_RETURN,
    WINDOW_TOTALS_TITLE, // the top screen's: "Pokéathlon: Totals Pts."
    WINDOW_FRIENDSHIP_GOAL, // "3,000 Points for the 1st Friendship Trophy"
    WINDOW_COURSE_TOTAL, // "Course Record Total: 1234 Points"
    WINDOW_EVENT_TOTAL,
    WINDOW_MEDAL_TOTAL,
    WINDOW_TOTAL, // "Total"
    WINDOW_POINTS, // "Points"
    NUM_WINDOWS,
};

// HeartGold's ov99_021E6FD0 summary
typedef struct TrophySums {
    u16 courseTotal; // the five course records' totals
    u16 eventTotal; // the event records' points (HeartGold's unk_AEC)
    u16 medalTotal; // the medals held
    u32 total;
    u16 courseRecords[COMPLETE_POKEATHLON_COURSES];
    u16 medalists;
    u8 potentialEvents; // the events whose record reaches its Potential Trophy
    u8 gender;
} TrophySums;

typedef struct TrophiesScreen {
    enum HeapID heapID;
    CompletePokeathlonSave *pokeathlon; // the save's copy (HeartGold's args point into its save)
    const TrainerInfo *trainerInfo;
    TrophySums sums;
    BgConfig *bgConfig;
    NARC *narc;
    PokeathlonRecordsText *text;
    PokeathlonRecordsSprites *sprites;
    ManagedSprite *spriteList[NUM_SPRITES];
} TrophiesScreen;

static const u8 sBgLayers[] = { BG_LAYER_MAIN_0, BG_LAYER_MAIN_1, BG_LAYER_SUB_0, BG_LAYER_SUB_1 }; // ov99_021E9D88

// ov99_021E9E60: on each screen the background (0) and the text (1)
static const BgTemplate sBgTemplates[] = {
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xf800, GX_BG_CHARBASE_0x00000, GX_BG_EXTPLTT_01, 3, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xf000, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xf800, GX_BG_CHARBASE_0x00000, GX_BG_EXTPLTT_01, 3, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xf000, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
};

static const GraphicsModes sGraphicsModes = { GX_DISPMODE_GRAPHICS, GX_BGMODE_0, GX_BGMODE_0, GX_BG0_AS_2D }; // ov99_021E9D9C

static const WindowTemplate sWindowTemplates[NUM_WINDOWS] = { // ov99_021E9ED0
    [WINDOW_TITLE] = { BG_LAYER_MAIN_1, 0, 0, 24, 2, 12, 1 },
    [WINDOW_TROPHY_NAME] = { BG_LAYER_MAIN_1, 1, 2, 16, 2, 12, 49 },
    [WINDOW_TROPHY_NAME + 1] = { BG_LAYER_MAIN_1, 1, 6, 16, 2, 12, 81 },
    [WINDOW_TROPHY_NAME + 2] = { BG_LAYER_MAIN_1, 1, 10, 16, 2, 12, 113 },
    [WINDOW_TROPHY_NAME + 3] = { BG_LAYER_MAIN_1, 1, 14, 16, 2, 12, 145 },
    [WINDOW_EARNED] = { BG_LAYER_MAIN_1, 24, 18, 8, 2, 12, 177 },
    [WINDOW_RANK] = { BG_LAYER_MAIN_1, 1, 18, 22, 6, 12, 193 },
    [WINDOW_RETURN] = { BG_LAYER_MAIN_1, 25, 21, 6, 2, 12, 325 },
    [WINDOW_TOTALS_TITLE] = { BG_LAYER_SUB_1, 1, 0, 20, 2, 12, 1 },
    [WINDOW_FRIENDSHIP_GOAL] = { BG_LAYER_SUB_1, 1, 2, 30, 2, 12, 41 },
    [WINDOW_COURSE_TOTAL] = { BG_LAYER_SUB_1, 1, 5, 31, 2, 12, 101 },
    [WINDOW_EVENT_TOTAL] = { BG_LAYER_SUB_1, 1, 8, 31, 2, 12, 163 },
    [WINDOW_MEDAL_TOTAL] = { BG_LAYER_SUB_1, 1, 11, 30, 2, 12, 225 },
    [WINDOW_TOTAL] = { BG_LAYER_SUB_1, 3, 14, 10, 2, 12, 285 },
    [WINDOW_POINTS] = { BG_LAYER_SUB_1, 24, 22, 8, 2, 12, 305 },
};

static const SpriteResourceCapacities sSpriteCapacities = { 5, 5, 3, 3, 0, 0 }; // ov99_021E9DEC

// ov99_021E9E2C: the player's icon (a girl's in its animation 1 and second palette)
static const SpriteTemplate sPlayerTemplate = { 216, 40, 0, 0, 2, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE };

// ov99_021E9DAC, ov99_021E9D8C, ov99_021E9DBC and ov99_021E9DD4: the crowns' and digits' resources on each screen
static const int sCrownResources[4] = { 1, 1, 2, 2 };
static const int sTopCrownResources[4] = { 3, 3, 2, 2 };
static const int sDigitResources[4] = { 2, 2, 1, 1 };
static const int sTopDigitResources[4] = { 4, 4, 1, 1 };

// ov99_021E9E04: the points in all each Friendship Trophy needs, from the tenth
static const u16 sFriendshipTrophyPoints[TROPHIES_PER_KIND] = { 4500, 4200, 4000, 3800, 3600, 3400, 3300, 3200, 3100, 3000 };

static void NoteForTests(int trophies, int friendshipTrophies)
{
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonRecordScreen[0] = 1 + COMPLETE_POKEATHLON_SCREEN_TROPHIES;
    gCompleteTestPokeathlonRecordScreen[1] = trophies;
    gCompleteTestPokeathlonRecordScreen[2] = friendshipTrophies;
#endif
}

// ov99_021E6F70, ov99_021E6FA0 and ov99_021E6FD0: the sums the screen shows
static void SumUp(TrophySums *sums, const CompletePokeathlonSave *pokeathlon, const TrainerInfo *trainerInfo)
{
    MI_CpuClear8(sums, sizeof(TrophySums));

    for (int i = 0; i < COMPLETE_POKEATHLON_COURSES; i++) {
        sums->courseRecords[i] = pokeathlon->courseRecords[i].total;
        sums->courseTotal += sums->courseRecords[i];
    }

    for (int i = 0; i < COMPLETE_POKEATHLON_EVENTS; i++) {
        sums->eventTotal += pokeathlon->recordPoints[i];

        if (PokeathlonRecords_EventResultReaches(i, POKEATHLON_EVENT_GOAL_POTENTIAL_TROPHY, pokeathlon->recordsSolo[i].entries[0].result)) {
            sums->potentialEvents++; // ov98_0221F058
        }
    }

    for (int i = 0; i < NATIONAL_DEX_COUNT; i++) {
        sums->medalTotal += MATH_CountPopulation(pokeathlon->medals[i]);
    }

    sums->medalists = PokeathlonRecords_CountMedalists(pokeathlon->medals);
    sums->total = sums->courseTotal + sums->eventTotal + sums->medalTotal;
    sums->gender = TrainerInfo_Gender(trainerInfo);
}

// ov99_021E7100: the Friendship Trophies the points in all earn
static int FriendshipTrophies(u32 total)
{
    int i;

    for (i = 0; i < TROPHIES_PER_KIND; i++) {
        if (sFriendshipTrophyPoints[i] <= total) {
            break;
        }
    }

    return TROPHIES_PER_KIND - i;
}

// ov99_021E7124: the Collective Trophies, two a course (from 420 and 450 points)
static int CollectiveTrophies(const TrophySums *sums)
{
    int trophies = 0;

    for (int i = 0; i < COMPLETE_POKEATHLON_COURSES; i++) {
        trophies += PokeathlonRecords_CourseTrophyRank(sums->courseRecords[i]);
    }

    return trophies;
}

// ov98_0221F150: a number's digits (1 for 0)
static int DigitCount(u32 number)
{
    int digits = 0;

    if (number == 0) {
        return 1;
    }

    for (; number != 0; number /= 10) {
        digits++;
    }

    return digits;
}

static void SetUpBgs(TrophiesScreen *app);
static void FreeBgs(TrophiesScreen *app);
static void LoadBgGraphics(TrophiesScreen *app);
static void MakeSprites(TrophiesScreen *app);
static void Draw(TrophiesScreen *app);
static void VBlank(void *data);

BOOL CompletePokeathlonTrophies_Init(ApplicationManager *appMan, int *state)
{
    CompletePokeathlonRecordArgs *args = ApplicationManager_Args(appMan);

    GF_ASSERT(args != NULL);
    Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_TROPHIES, TROPHIES_HEAP_SIZE);

    TrophiesScreen *app = ApplicationManager_NewData(appMan, sizeof(TrophiesScreen), HEAP_ID_TROPHIES);

    MI_CpuClear8(app, sizeof(TrophiesScreen));
    app->heapID = HEAP_ID_TROPHIES;
    app->pokeathlon = CompletePokeathlon_Load(args->saveData, app->heapID);
    app->trainerInfo = SaveData_GetTrainerInfo(args->saveData);
    SumUp(&app->sums, app->pokeathlon, app->trainerInfo); // ov99_021E6FD0
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonSaveCopy = app->pokeathlon;
    gCompleteTestPokeathlonRecordScreen[3] = 0;
#endif

    PokeathlonRecords_SetUpScreens();
    SetUpBgs(app);
    LoadBgGraphics(app);
    app->text = PokeathlonRecords_NewText(app->heapID, app->bgConfig, NUM_WINDOWS, sWindowTemplates, TEXT_BANK_HGSS_MSG_0314);
    MakeSprites(app);
    Draw(app);
    EnableTouchPad();
    InitializeTouchPad(4);
    ResetVisibleHardwareWindows(DS_SCREEN_MAIN);
    ResetVisibleHardwareWindows(DS_SCREEN_SUB);
    SetVBlankCallback(VBlank, app);
    return TRUE;
}

BOOL CompletePokeathlonTrophies_Main(ApplicationManager *appMan, int *state)
{
    TrophiesScreen *app = ApplicationManager_Data(appMan);

    switch (*state) {
    case STATE_FADE_IN:
        StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_IN, FADE_TYPE_BRIGHTNESS_IN, COLOR_BLACK, 6, 1, app->heapID);
        *state = STATE_WAIT_FADE_IN;
        break;
    case STATE_WAIT_FADE_IN:
        if (IsScreenFadeDone()) {
            *state = STATE_INPUT;
        }
        break;
    case STATE_INPUT:
#ifdef SOVEREIGN_TEST
        if (gCompleteTestPokeathlonRecordScreen[3] != 0) { // a test filled the save's copy: sum it up again, draw again
            gCompleteTestPokeathlonRecordScreen[3] = 0;
            SumUp(&app->sums, app->pokeathlon, app->trainerInfo);
            Draw(app);
        }
#endif
        if (PokeathlonRecords_ReturnPressed()) {
            Sound_PlayEffect(SE_CONFIRM_sseq_3); // HeartGold's SEQ_SE_DP_SELECT
            StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_OUT, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, 6, 1, app->heapID);
            *state = STATE_WAIT_FADE_OUT;
        }
        break;
    case STATE_WAIT_FADE_OUT:
        if (IsScreenFadeDone()) {
            *state = STATE_EXIT;
        }
        break;
    case STATE_EXIT:
        return TRUE;
    }

    PokeathlonRecords_DrawSprites(app->sprites);
    return FALSE;
}

BOOL CompletePokeathlonTrophies_Exit(ApplicationManager *appMan, int *state)
{
    TrophiesScreen *app = ApplicationManager_Data(appMan);

    DisableTouchPad();
    PokeathlonRecords_FreeSprites(app->sprites, app->spriteList, NUM_SPRITES);
    PokeathlonRecords_FreeText(app->text);
    FreeBgs(app);
    PokeathlonRecords_EndScreens();
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonRecordScreen[0] = 0;
    gCompleteTestPokeathlonSaveCopy = NULL;
#endif
    Heap_Free(app->pokeathlon);
    ApplicationManager_FreeData(appMan);
    Heap_Destroy(HEAP_ID_TROPHIES);
    return TRUE;
}

// ov99_021E695C
static void SetUpBgs(TrophiesScreen *app)
{
    app->bgConfig = BgConfig_New(app->heapID);
    SetAllGraphicsModes(&sGraphicsModes);

    for (int i = 0; i < NELEMS(sBgLayers); i++) {
        Bg_InitFromTemplate(app->bgConfig, sBgLayers[i], &sBgTemplates[i], BG_TYPE_STATIC);
        Bg_ClearTilemap(app->bgConfig, sBgLayers[i]);
        Bg_ClearTilesRange(sBgLayers[i], 32, 0, app->heapID);
    }

    app->narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__POKEATHLON_RECORDS, app->heapID);
}

// ov99_021E6A70
static void FreeBgs(TrophiesScreen *app)
{
    NARC_dtor(app->narc);

    for (int i = 0; i < NELEMS(sBgLayers); i++) {
        Bg_FreeTilemapBuffer(app->bgConfig, sBgLayers[i]);
    }

    Heap_Free(app->bgConfig);
}

// ov99_021E69D8: two palettes and a background on each screen
static void LoadBgGraphics(TrophiesScreen *app)
{
    Graphics_LoadPaletteFromOpenNARC(app->narc, GFX_BOTTOM_PLTT, PAL_LOAD_MAIN_BG, 0, PALETTE_SIZE_BYTES * 2, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(app->narc, GFX_BOTTOM_TILES, app->bgConfig, BG_LAYER_MAIN_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(app->narc, GFX_BOTTOM_TILEMAP, app->bgConfig, BG_LAYER_MAIN_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadPaletteFromOpenNARC(app->narc, GFX_TOP_PLTT, PAL_LOAD_SUB_BG, 0, PALETTE_SIZE_BYTES * 2, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(app->narc, GFX_TOP_TILES, app->bgConfig, BG_LAYER_SUB_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(app->narc, GFX_TOP_TILEMAP, app->bgConfig, BG_LAYER_SUB_0, 0, 0, TRUE, app->heapID);
}

// ov99_021E6C30: a number's sprites, one a digit from the left, spacing apart; its leading zeros hidden (drawn by Draw)
static void MakeNumber(TrophiesScreen *app, int startIdx, int digits, s16 x, s16 y, int spacing, BOOL mainScreen)
{
    SpriteTemplate template;
    const int *resources = mainScreen ? sDigitResources : sTopDigitResources;

    MI_CpuClear8(&template, sizeof(SpriteTemplate));
    template.y = y;
    template.vramType = mainScreen ? NNS_G2D_VRAM_TYPE_2DMAIN : NNS_G2D_VRAM_TYPE_2DSUB;

    for (int i = 0; i < 4; i++) {
        template.resources[i] = resources[i];
    }

    for (int i = 0; i < digits; i++) {
        template.x = x + spacing * i;
        app->spriteList[startIdx + i] = PokeathlonRecords_NewSprite(app->sprites, &template);
        ManagedSprite_SetAnimateFlag(app->spriteList[startIdx + i], TRUE);
    }
}

static void DrawNumber(TrophiesScreen *app, u32 number, int startIdx, int digits)
{
    int hidden = digits - DigitCount(number);

    for (int i = 0; i < digits; i++) {
        ManagedSprite_SetAnim(app->spriteList[startIdx + i], PokeathlonRecords_Digit(number, digits - i));
        ManagedSprite_SetDrawFlag(app->spriteList[startIdx + i], i >= hidden);
    }
}

// ov99_021E6A9C and ov99_021E6C14: the player's icon (resource 0, two palettes), the digits (char 2 and the rest 2 and
// 1 here, char 4 and the rest 4 and 1 on top) and the crowns (char 1 and the rest 1 and 2 here, char 3 and the rest 3
// and 2 on top); then the icon, the numbers and the crowns' rows
static void MakeSprites(TrophiesScreen *app)
{
    SpriteSystem *spriteSys;
    SpriteManager *spriteMan;
    SpriteTemplate template = sPlayerTemplate;

    app->sprites = PokeathlonRecords_NewSprites(app->heapID, &sSpriteCapacities, NUM_SPRITES);
    spriteSys = app->sprites->spriteSystem;
    spriteMan = app->sprites->spriteManager;

    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_PLAYER_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_PLAYER_PLTT, FALSE, 2, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_PLAYER_CELL, TRUE, 0);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_PLAYER_ANIM, TRUE, 0);
    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_DIGITS_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DSUB, 4);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_DIGITS_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DSUB, 4);
    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_DIGITS_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 2);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_DIGITS_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DMAIN, 2);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_DIGITS_CELL, TRUE, 1);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_DIGITS_ANIM, TRUE, 1);
    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CROWNS_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 1);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CROWNS_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DMAIN, 1);
    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CROWNS_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DSUB, 3);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CROWNS_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DSUB, 3);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CROWNS_CELL, TRUE, 2);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CROWNS_ANIM, TRUE, 2);

    if (app->sums.gender == GENDER_FEMALE) { // HeartGold's animation 1 and palette 1
        template.animIdx = 1;
        template.plttIdx = 1;
    }

    app->spriteList[SPRITE_PLAYER] = PokeathlonRecords_NewSprite(app->sprites, &template);
    ManagedSprite_SetAnimateFlag(app->spriteList[SPRITE_PLAYER], TRUE);
    MakeNumber(app, SPRITE_TROPHY_COUNT, TROPHY_COUNT_DIGITS, 200, 112, 32, TRUE);
    MakeNumber(app, SPRITE_TOTAL, TOTAL_DIGITS, 80, 160, 32, FALSE);
    PokeathlonRecords_NewSpriteRow(app->sprites, app->spriteList, sCrownResources, 0, SPRITE_COLLECTIVE, 16, 40, NNS_G2D_VRAM_TYPE_2DMAIN);
    PokeathlonRecords_NewSpriteRow(app->sprites, app->spriteList, sCrownResources, 0, SPRITE_TRUST, 16, 72, NNS_G2D_VRAM_TYPE_2DMAIN);
    PokeathlonRecords_NewSpriteRow(app->sprites, app->spriteList, sCrownResources, 0, SPRITE_POTENTIAL, 16, 104, NNS_G2D_VRAM_TYPE_2DMAIN);
    PokeathlonRecords_NewSpriteRow(app->sprites, app->spriteList, sCrownResources, 0, SPRITE_FRIENDSHIP, 16, 136, NNS_G2D_VRAM_TYPE_2DMAIN);
    PokeathlonRecords_NewSpriteRow(app->sprites, app->spriteList, sTopCrownResources, 0, SPRITE_TOP_FRIENDSHIP, 96, 120, NNS_G2D_VRAM_TYPE_2DSUB);
}

static void LightCrowns(TrophiesScreen *app, int startIdx, int lit)
{
    for (int i = 0; i < TROPHIES_PER_KIND; i++) {
        ManagedSprite_SetAnim(app->spriteList[startIdx + i], i < lit ? 1 : 0);
    }
}

// ov99_021E6D34, ov99_021E6CF4 and ov99_021E6D14: the texts, the trophies' crowns, the trophies in all and the title
// they earn (one more a two), the points in all
static void Draw(TrophiesScreen *app)
{
    PokeathlonRecordsText *text = app->text;
    const TrophySums *sums = &app->sums;
    int collective = CollectiveTrophies(sums);
    int trust = PokeathlonRecords_TrustTrophyRank(sums->medalists);
    int friendship = FriendshipTrophies(sums->total);
    int trophies = collective + trust + sums->potentialEvents + friendship;

    GF_ASSERT(trophies <= MAX_TROPHIES);
    StringTemplate_SetPlayerName(text->template, 0, app->trainerInfo);
    PokeathlonRecords_PrintMessageAt(text, WINDOW_TITLE, msg_0314_00011, 1, 0);

    for (int i = 0; i < NUM_TROPHY_KINDS; i++) {
        PokeathlonRecords_PrintMessage(text, WINDOW_TROPHY_NAME + i, msg_0314_00012 + i, FALSE);
    }

    PokeathlonRecords_PrintMessageAt(text, WINDOW_EARNED, msg_0314_00032, 2, 0);
    PokeathlonRecords_PrintMessageInFont(text, WINDOW_RETURN, msg_0314_00000, TRUE, 0, FONT_SUBSCREEN);
    PokeathlonRecords_PrintMessage(text, WINDOW_RANK, msg_0314_00033 + trophies / 2, FALSE);
    PokeathlonRecords_PrintMessage(text, WINDOW_TOTALS_TITLE, msg_0314_00016, FALSE);
    PokeathlonRecords_PrintMessage(text, WINDOW_TOTAL, msg_0314_00031, FALSE);
    PokeathlonRecords_PrintMessage(text, WINDOW_POINTS, msg_0314_00001, FALSE);
    PokeathlonRecords_PrintNumberMessage(text, WINDOW_COURSE_TOTAL, msg_0314_00028, sums->courseTotal, 4, 0);
    PokeathlonRecords_PrintNumberMessage(text, WINDOW_EVENT_TOTAL, msg_0314_00029, sums->eventTotal, 4, 0);
    PokeathlonRecords_PrintNumberMessage(text, WINDOW_MEDAL_TOTAL, msg_0314_00030, sums->medalTotal, 4, 0);
    PokeathlonRecords_PrintMessage(text, WINDOW_FRIENDSHIP_GOAL, msg_0314_00017 + friendship, FALSE);

    DrawNumber(app, trophies, SPRITE_TROPHY_COUNT, TROPHY_COUNT_DIGITS);
    DrawNumber(app, sums->total > MAX_TOTAL_SHOWN ? MAX_TOTAL_SHOWN : sums->total, SPRITE_TOTAL, TOTAL_DIGITS);
    LightCrowns(app, SPRITE_COLLECTIVE, collective);
    LightCrowns(app, SPRITE_TRUST, trust);
    LightCrowns(app, SPRITE_POTENTIAL, sums->potentialEvents);
    LightCrowns(app, SPRITE_FRIENDSHIP, friendship);
    LightCrowns(app, SPRITE_TOP_FRIENDSHIP, friendship);
    NoteForTests(trophies, friendship);
}

// ov99_021E6938
static void VBlank(void *data)
{
    TrophiesScreen *app = data;

    SpriteSystem_TransferOam();
    Bg_RunScheduledUpdates(app->bgConfig);
    OS_SetIrqCheckFlag(OS_IE_V_BLANK);
}
