#include <nitro.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "generated/genders.h"
#include "generated/text_banks.h"
#include "generated/trainers.h"

#include "applications/complete_pokegear/radio.h"
#include "bg_window.h"
#include "complete_map_info.h"
#include "complete_phone.h"
#include "complete_pokegear.h"
#include "font.h"
#include "graphics.h"
#include "heap.h"
#include "message.h"
#include "narc.h"
#include "player_avatar.h"
#include "render_oam.h"
#include "savedata.h"
#include "sound_playback.h"
#include "string_gf.h"
#include "sys_task.h"
#include "sys_task_manager.h"
#include "system.h"
#include "text.h"
#include "touch_pad.h"
#include "trainer_data.h"
#include "trainer_info.h"

#include "field/field_system.h"
#include "generated/map_headers.h"

#include "data/hgss_phone_contacts.h"
#include "res/field/matrices/map_matrix.naix"
#include "res/graphics/complete_pokegear/complete_pokegear.naix"
#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: HeartGold's Pokégear on the field's bottom screen (include/complete_pokegear.h), in the
// Pokétch's place, with HeartGold's graphics (res/graphics/complete_pokegear/) and its app bar, which switches between
// its pages:
// - the Phone: its contact list. Tapping a contact calls them (CompletePhone_RequestCall: the call plays in the field's
//   message box once the player stands still); the arrows scroll the list.
// - the Map: its map of Johto and Kanto, with the player's head where they are (HeartGold's map app's place: the
//   overworld's block, or the world map place of a map off it) and the place's name; dragging scrolls it.
// - the Radio (radio/radio_page.c): the globe that tunes Johto's and Kanto's stations, and their shows; its music is
//   the field's while the page shows a station, and leaving the page turns it off.
// The app bar's last button switches to the Pokétch when the player has it. HeartGold's skin setting waits (its
// button is dimmed).

#define LIST_ROWS        6 // HeartGold's: rows of 24 pixels, behind the frame's window
#define ROW_HEIGHT       24
#define LIST_X           16 // the list's window, inside the frame
#define LIST_Y           8
#define LIST_WIDTH       208
#define NAME_BOX_WIDTH   82 // HeartGold's name box, then its title box
#define BAR_TILE_START   128 // the app bar's tiles, after the phone frame's, in one layer
#define NAME_TILE_START  256 // the map page's place name window, after them
#define BLANK_TILE       BAR_TILE_START // the app bar's first tile, an empty one
#define BAR_TOP          20 // the app bar's first tile row
#define MAP_WIDTH        48 // the map's tiles (HeartGold's map app's, 8 pixels a block)
#define MAP_HEIGHT       20
#define MAP_SCROLL_MAX   (MAP_WIDTH * 8 - 256)
#define NAME_TOP         18 // the place name's tile row, over the map's sea
#define NAME_PALETTE     12
#define MARKER_SIZE      16
#define REFRESH_FRAMES   30 // the phone book is checked for changes this often
#define CALL_HIGHLIGHT   30 // frames a called contact stays lit
#define REPEAT_DELAY     20 // a held arrow scrolls again after this, then every REPEAT_FRAMES
#define REPEAT_FRAMES    6

// The palette (HeartGold's phone palette 2) colours of a contact's row (HeartGold's PhoneContactListUI_DrawNameSlotBG)
#define COLOR_ROW_GAP   11
#define COLOR_NAME_BOX  9
#define COLOR_TITLE_BOX 10
#define LIST_PALETTE    2

enum PokegearState {
    POKEGEAR_STATE_RUN = 0,
    POKEGEAR_STATE_SHUTDOWN,
};

enum PokegearPage {
    PAGE_PHONE = 0,
    PAGE_MAP,
    PAGE_RADIO,
};

enum AppBarButton {
    APP_BAR_SETTINGS = 0,
    APP_BAR_RADIO,
    APP_BAR_MAP,
    APP_BAR_PHONE,
    APP_BAR_EXIT, // here: the Pokétch
    APP_BAR_BUTTONS,
};

typedef struct CompletePokegear {
    FieldSystem *fieldSystem;
    SaveData *saveData;
    BgConfig *bgConfig;
    SysTask *task;
    Window list;
    Window name; // the map's place name
    MessageLoader *titles; // HeartGold's phone app's bank (0271)
    MessageLoader *classes;
    u8 state;
    u8 numContacts;
    u8 top; // the first contact shown
    u8 lit; // the row of the contact called, LIST_ROWS for none
    u8 litTimer;
    u8 held; // the arrow held: 1 up, 2 down
    u8 heldFrames;
    u8 refreshTimer;
    u8 poketchShown; // the exit button lit
    u8 page;
    u8 marker; // the map shows the player's head
    s16 scrollX; // the map's
    s16 dragX; // the touch's last x as it drags the map, -1 for none
    s16 markerX; // the player's place on the map
    s16 markerY;
    u16 mapHeaderID; // the place named
    RadioPage *radio;
    u8 contacts[NUM_PHONE_CONTACTS];
    u16 appBar[4][2][32]; // HeartGold's app bar's rows: lit and dimmed
} CompletePokegear;

static CompletePokegear *sPokegear;

// Each app bar button's first tile column and width (HeartGold's app bar: five buttons and a gap before the last)
static const u8 sAppBarButtons[APP_BAR_BUTTONS][2] = { { 1, 6 }, { 7, 6 }, { 13, 6 }, { 19, 6 }, { 26, 6 } };

typedef struct Box {
    u8 top;
    u8 bottom;
    u8 left;
    u8 right;
} Box;

static const Box sUpArrow = { 16, 72, 232, 255 };
static const Box sDownArrow = { 88, 144, 232, 255 };

static BOOL Touched(const Box *rect, u16 x, u16 y)
{
    return y >= rect->top && y <= rect->bottom && x >= rect->left && x <= rect->right;
}

static void ReadPhoneBook(CompletePokegear *gear, u8 *contacts, u8 *count)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(gear->saveData);

    *count = 0;

    for (int i = 0; i < NUM_PHONE_CONTACTS && phone->contacts[i] != PHONE_CONTACT_NONE; i++) {
        contacts[(*count)++] = phone->contacts[i];
    }
}

// A contact's row (HeartGold's PhoneContactListUI_PrintNameAndClass): their name in the white box and their title in
// the blue one, lit when they're being called
static void DrawRow(CompletePokegear *gear, int row)
{
    int y = row * ROW_HEIGHT;
    int index = gear->top + row;

    Window_FillRectWithColor(&gear->list, COLOR_ROW_GAP, 0, y, LIST_WIDTH, ROW_HEIGHT);
    Window_FillRectWithColor(&gear->list, COLOR_NAME_BOX, 0, y, NAME_BOX_WIDTH, ROW_HEIGHT - 4);
    Window_FillRectWithColor(&gear->list, COLOR_TITLE_BOX, NAME_BOX_WIDTH, y, LIST_WIDTH - NAME_BOX_WIDTH, ROW_HEIGHT - 4);

    if (index >= gear->numContacts) {
        return;
    }

    u8 contact = gear->contacts[index];
    BOOL lit = row == gear->lit;
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, sPhoneContactNames[contact].textBank, HEAP_ID_POKETCH_APP);
    String *name = MessageLoader_GetNewString(loader, 0);

    Text_AddPrinterWithParamsAndColor(&gear->list, FONT_SYSTEM, name, 8, y + 2, TEXT_SPEED_NO_TRANSFER, lit ? TEXT_COLOR(4, 7, COLOR_NAME_BOX) : TEXT_COLOR(11, 8, COLOR_NAME_BOX), NULL);
    String_Free(name);
    MessageLoader_Free(loader);

    String *title = NULL;
    u8 kind = sPhoneContactNames[contact].title;

    if (kind == CONTACT_TITLE_TRAINER_CLASS) {
        title = MessageLoader_GetNewString(gear->classes, Trainer_LoadParam(sPhoneContactNames[contact].trainerID, TRDATA_CLASS));
    } else if (kind != CONTACT_TITLE_NONE) {
        title = MessageLoader_GetNewString(gear->titles, kind);
    }

    if (title != NULL) {
        Text_AddPrinterWithParamsAndColor(&gear->list, FONT_SYSTEM, title, NAME_BOX_WIDTH + 4, y + 2, TEXT_SPEED_NO_TRANSFER, lit ? TEXT_COLOR(1, 2, COLOR_TITLE_BOX) : TEXT_COLOR(5, 6, COLOR_TITLE_BOX), NULL);
        String_Free(title);
    }
}

static void DrawList(CompletePokegear *gear)
{
    for (int row = 0; row < LIST_ROWS; row++) {
        DrawRow(gear, row);
    }

    Window_CopyToVRAM(&gear->list);
}

// HeartGold's app bar (its PokegearApp_UpdateAppSwitchButtonBGState): the phone, the map, the radio and, with a Pokétch
// to switch to, the exit button lit; the settings dimmed
static void DrawAppBar(CompletePokegear *gear)
{
    gear->poketchShown = CompletePokegear_PoketchAvailable(gear->saveData);

    for (int y = 0; y < 4; y++) {
        u16 row[32];

        for (int x = 0; x < 32; x++) {
            row[x] = gear->appBar[y][1][x];
        }

        for (int button = 0; button < APP_BAR_BUTTONS; button++) {
            BOOL lit = button == APP_BAR_PHONE || button == APP_BAR_MAP || button == APP_BAR_RADIO || (button == APP_BAR_EXIT && gear->poketchShown);

            for (int x = sAppBarButtons[button][0]; x < sAppBarButtons[button][0] + sAppBarButtons[button][1]; x++) {
                row[x] = gear->appBar[y][!lit][x];
            }
        }

        Bg_LoadToTilemapRect(gear->bgConfig, BG_LAYER_SUB_0, row, 0, BAR_TOP + y, 32, 1);
    }

    Bg_CopyTilemapBufferToVRAM(gear->bgConfig, BG_LAYER_SUB_0);
}

// Where the player is on the map, as HeartGold's map app puts them: on Johto and Kanto's overworld, its block of 32
// tiles; off it, the place the map's header gives (HeartGold's MapHeader_GetWorldMapCoords). FALSE in Sinnoh, or
// for a map with no place.
static BOOL PlayerMapPosition(CompletePokegear *gear, s16 *x, s16 *y)
{
    enum MapHeaderID mapHeaderID = gear->fieldSystem->location->mapHeaderID;
    int blockX, blockY;

    if (!MapHeader_IsHGSS(mapHeaderID)) {
        return FALSE;
    }

    if (MapHeader_GetMapMatrixID(mapHeaderID) == map_matrix_hgss_0000) {
        blockX = PlayerAvatar_GetXPos(gear->fieldSystem->playerAvatar) / 32;
        blockY = PlayerAvatar_GetZPos(gear->fieldSystem->playerAvatar) / 32;
    } else {
        MapHeader_GetWorldMapPos(mapHeaderID, &blockX, &blockY);

        if (blockX == 0 && blockY == 0) {
            return FALSE;
        }
    }

    *x = blockX * 8 + 4;
    *y = (blockY + 2) * 8 + 4;
    return *x < MAP_WIDTH * 8 && *y < MAP_HEIGHT * 8;
}

static void DrawPlaceName(CompletePokegear *gear)
{
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_LOCATION_NAMES, HEAP_ID_POKETCH_APP);
    String *name = MessageLoader_GetNewString(loader, MapHeader_GetMapLabelTextID(gear->mapHeaderID));

    Window_FillTilemap(&gear->name, COLOR_ROW_GAP);
    Text_AddPrinterWithParamsAndColor(&gear->name, FONT_SYSTEM, name, 8, 0, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(5, 6, COLOR_ROW_GAP), NULL);
    Window_CopyToVRAM(&gear->name);
    String_Free(name);
    MessageLoader_Free(loader);
}

// The page's layers: the Phone's frame (layer 0, tiles 0-127) and its list's window (layer 1); the Map's map (layer 1,
// its tiles over the frame's, which is off) and its place name's window (layer 0, tiles 256 on); or the Radio's globe
// and its windows (layer 0, radio_page.c)
static void LoadPage(CompletePokegear *gear)
{
    NARC *narc = NARC_ctor(NARC_INDEX_APPLICATION__COMPLETE__POKEGEAR, HEAP_ID_POKETCH_APP);
    NNSG2dScreenData *screen;

    if (gear->page == PAGE_PHONE) {
        Graphics_LoadTilesToBgLayerFromOpenNARC(narc, phone_NCGR, gear->bgConfig, BG_LAYER_SUB_0, 0, 0, FALSE, HEAP_ID_POKETCH_APP);
        Graphics_LoadPaletteFromOpenNARC(narc, pokegear_NCLR, PAL_LOAD_SUB_BG, 0, PALETTE_SIZE_BYTES * 16, HEAP_ID_POKETCH_APP);

        void *file = Graphics_GetScrnDataFromOpenNARC(narc, phone_NSCR, FALSE, &screen, HEAP_ID_POKETCH_APP);

        Bg_LoadToTilemapRect(gear->bgConfig, BG_LAYER_SUB_0, screen->rawData, 0, 0, 32, BAR_TOP);
        Heap_Free(file);

        Bg_ClearTilesRange(BG_LAYER_SUB_1, TILE_SIZE_4BPP, 0, HEAP_ID_POKETCH_APP);
        Window_Add(gear->bgConfig, &gear->list, BG_LAYER_SUB_1, LIST_X / 8, LIST_Y / 8, LIST_WIDTH / 8, LIST_ROWS * ROW_HEIGHT / 8, LIST_PALETTE, 1);
        Window_PutToTilemap(&gear->list);
        Bg_SetOffset(gear->bgConfig, BG_LAYER_SUB_1, BG_OFFSET_UPDATE_SET_X, 0);
        DrawList(gear);
    } else if (gear->page == PAGE_RADIO) {
        Bg_ClearTilesRange(BG_LAYER_SUB_1, TILE_SIZE_4BPP, 0, HEAP_ID_POKETCH_APP);
        Bg_ClearTilemap(gear->bgConfig, BG_LAYER_SUB_1);
        Bg_SetOffset(gear->bgConfig, BG_LAYER_SUB_1, BG_OFFSET_UPDATE_SET_X, 0);
        gear->radio = RadioPage_New(gear->fieldSystem, gear->bgConfig, HEAP_ID_POKETCH_APP);
    } else {
        Graphics_LoadTilesToBgLayerFromOpenNARC(narc, map_NCGR, gear->bgConfig, BG_LAYER_SUB_1, 0, 0, FALSE, HEAP_ID_POKETCH_APP);
        Graphics_LoadPaletteFromOpenNARC(narc, map_NCLR, PAL_LOAD_SUB_BG, 0, PALETTE_SIZE_BYTES * 16, HEAP_ID_POKETCH_APP);

        u16 *tilemap = NARC_AllocAndReadWholeMember(narc, map_tilemap_bin, HEAP_ID_POKETCH_APP);

        Bg_LoadToTilemapRect(gear->bgConfig, BG_LAYER_SUB_1, tilemap, 0, 0, MAP_WIDTH, MAP_HEIGHT);
        Heap_Free(tilemap);
        Bg_FillTilemapRect(gear->bgConfig, BG_LAYER_SUB_0, BLANK_TILE, 0, 0, 32, BAR_TOP, 0);

        gear->mapHeaderID = gear->fieldSystem->location->mapHeaderID;
        gear->marker = PlayerMapPosition(gear, &gear->markerX, &gear->markerY);
        gear->scrollX = gear->marker ? gear->markerX - 128 : 0;
        gear->scrollX = gear->scrollX < 0 ? 0 : gear->scrollX > MAP_SCROLL_MAX ? MAP_SCROLL_MAX : gear->scrollX;
        gear->dragX = -1;
        Bg_SetOffset(gear->bgConfig, BG_LAYER_SUB_1, BG_OFFSET_UPDATE_SET_X, gear->scrollX);

        Window_Add(gear->bgConfig, &gear->name, BG_LAYER_SUB_0, 0, NAME_TOP, 32, 2, NAME_PALETTE, NAME_TILE_START);
        Window_PutToTilemap(&gear->name);
        DrawPlaceName(gear);
    }

    NARC_dtor(narc);
    DrawAppBar(gear);
    Bg_CopyTilemapBufferToVRAM(gear->bgConfig, BG_LAYER_SUB_0);
    Bg_CopyTilemapBufferToVRAM(gear->bgConfig, BG_LAYER_SUB_1);
    GXS_SetVisiblePlane(GX_PLANEMASK_BG0 | GX_PLANEMASK_BG1 | (gear->page != PAGE_PHONE ? GX_PLANEMASK_OBJ : 0));
}

// turnOff: the player left the Radio page, so its music ends (a shutdown leaves it on, for the page to pick it up again)
static void UnloadPage(CompletePokegear *gear, BOOL turnOff)
{
    if (gear->page == PAGE_PHONE) {
        Window_Remove(&gear->list);
    } else if (gear->page == PAGE_RADIO) {
        RadioPage_Free(gear->radio, turnOff);
        gear->radio = NULL;
    } else {
        Window_Remove(&gear->name);
    }

    Bg_ClearTilemap(gear->bgConfig, BG_LAYER_SUB_1);
}

static void ChangePage(CompletePokegear *gear, enum PokegearPage page)
{
    if (page == gear->page) {
        return;
    }

    Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
    UnloadPage(gear, TRUE);
    gear->page = page;
    CompletePokegear_SetPage(page);
    gear->lit = LIST_ROWS;
    gear->held = 0;
    LoadPage(gear);
}

// The layers of both pages: layer 0 the app bar (tiles 128-255) with the phone's frame or the map's place name, layer 1
// the list or the map (a 512-pixel-wide screen, for the map's 384); the player's head on the Map is a sprite
static void LoadGraphics(CompletePokegear *gear)
{
    static const BgTemplate sFrameTemplate = {
        .x = 0,
        .y = 0,
        .bufferSize = 0x800,
        .baseTile = 0,
        .screenSize = BG_SCREEN_SIZE_256x256,
        .colorMode = GX_BG_COLORMODE_16,
        .screenBase = GX_BG_SCRBASE_0x7800,
        .charBase = GX_BG_CHARBASE_0x04000,
        .bgExtPltt = GX_BG_EXTPLTT_01,
        .priority = 0,
        .areaOver = 0,
        .mosaic = FALSE,
    };
    static const BgTemplate sListTemplate = {
        .x = 0,
        .y = 0,
        .bufferSize = 0x1000,
        .baseTile = 0,
        .screenSize = BG_SCREEN_SIZE_512x256,
        .colorMode = GX_BG_COLORMODE_16,
        .screenBase = GX_BG_SCRBASE_0x6800,
        .charBase = GX_BG_CHARBASE_0x00000,
        .bgExtPltt = GX_BG_EXTPLTT_01,
        .priority = 1,
        .areaOver = 0,
        .mosaic = FALSE,
    };
    NNSG2dScreenData *screen;

    GXS_SetGraphicsMode(GX_BGMODE_0);
    GX_SetBankForSubBG(GX_VRAM_SUB_BG_32_H);
    GX_SetBankForSubOBJ(GX_VRAM_SUB_OBJ_16_I);
    GXS_SetOBJVRamModeChar(GX_OBJVRAMMODE_CHAR_1D_32K);

    Bg_InitFromTemplate(gear->bgConfig, BG_LAYER_SUB_0, &sFrameTemplate, BG_TYPE_STATIC);
    Bg_InitFromTemplate(gear->bgConfig, BG_LAYER_SUB_1, &sListTemplate, BG_TYPE_STATIC);

    NARC *narc = NARC_ctor(NARC_INDEX_APPLICATION__COMPLETE__POKEGEAR, HEAP_ID_POKETCH_APP);

    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, app_bar_NCGR, gear->bgConfig, BG_LAYER_SUB_0, BAR_TILE_START, 0, FALSE, HEAP_ID_POKETCH_APP);

    // the app bar's two states, lit (its rows 0-3) and dimmed (4-7), its tiles after the phone frame's
    void *file = Graphics_GetScrnDataFromOpenNARC(narc, app_bar_NSCR, FALSE, &screen, HEAP_ID_POKETCH_APP);
    const u16 *src = (const u16 *)screen->rawData;

    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 32; x++) {
            gear->appBar[y][0][x] = src[y * 32 + x] + BAR_TILE_START;
            gear->appBar[y][1][x] = src[(y + 4) * 32 + x] + BAR_TILE_START;
        }
    }

    Heap_Free(file);
    NARC_dtor(narc);

    // the player's heads, a boy's then a girl's, and the radio's cursor; their palettes
    Graphics_LoadObjectTiles(NARC_INDEX_APPLICATION__COMPLETE__POKEGEAR, marker_NCGR, DS_SCREEN_SUB, 0, 0, FALSE, HEAP_ID_POKETCH_APP);
    Graphics_LoadPalette(NARC_INDEX_APPLICATION__COMPLETE__POKEGEAR, marker_NCLR, PAL_LOAD_SUB_OBJ, 0, PALETTE_SIZE_BYTES * 2, HEAP_ID_POKETCH_APP);

    LoadPage(gear);
    GXS_SetVisibleWnd(GX_WNDMASK_NONE);
}

// The player's head over the map, each frame (HeartGold's PGMAP_SPRITE_CURSOR), while it's in view
static void DrawMarker(CompletePokegear *gear)
{
    GXOamAttr oam;
    int x = gear->markerX - gear->scrollX - MARKER_SIZE / 2;
    int y = gear->markerY - MARKER_SIZE / 2;

    if (gear->page != PAGE_MAP || !gear->marker || x < -MARKER_SIZE || x >= 256) {
        return;
    }

    u32 head = TrainerInfo_Gender(SaveData_GetTrainerInfo(gear->saveData)) == GENDER_MALE ? 0 : 4;

    G2_SetOBJAttr(&oam, x & 0x1FF, y, 0, GX_OAM_MODE_NORMAL, FALSE, GX_OAM_EFFECT_NONE, GX_OAM_SHAPE_16x16, GX_OAM_COLORMODE_16, head, 0, 0);
    NNS_G2dEntryOamManagerOam(RenderOam_GetScreenOam(DS_SCREEN_SUB), &oam, 1);
}

// Dragging the map scrolls it (HeartGold's map scrolls by touch too)
static void HandleMapTouch(CompletePokegear *gear)
{
    if (!gSystem.touchHeld || gSystem.touchY >= BAR_TOP * 8) {
        gear->dragX = -1;
        return;
    }

    if (gear->dragX >= 0) {
        int scrollX = gear->scrollX - (gSystem.touchX - gear->dragX);

        scrollX = scrollX < 0 ? 0 : scrollX > MAP_SCROLL_MAX ? MAP_SCROLL_MAX : scrollX;

        if (scrollX != gear->scrollX) {
            gear->scrollX = scrollX;
            Bg_SetOffset(gear->bgConfig, BG_LAYER_SUB_1, BG_OFFSET_UPDATE_SET_X, scrollX);
        }
    }

    gear->dragX = gSystem.touchX;
}

static void Scroll(CompletePokegear *gear, int by)
{
    int top = gear->top + by;

    if (top < 0 || (by > 0 && top + LIST_ROWS > gear->numContacts)) {
        return;
    }

    gear->top = top;
    gear->lit = LIST_ROWS;
    Sound_PlayEffect(SEQ_SE_DP_BUTTON3_sseq);
    DrawList(gear);
}

// The app bar: the Map, the Phone, and the exit button (to the Pokétch, when the player has it)
static void HandleAppBarTouch(CompletePokegear *gear, u16 x)
{
    if (x >= sAppBarButtons[APP_BAR_EXIT][0] * 8) {
        if (gear->poketchShown) {
            Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
            CompleteBottomScreen_RequestSwitch(gear->saveData);
        } else {
            Sound_PlayEffect(SEQ_SE_DP_BEEP_sseq);
        }
    } else if (x >= sAppBarButtons[APP_BAR_PHONE][0] * 8) {
        ChangePage(gear, PAGE_PHONE);
    } else if (x >= sAppBarButtons[APP_BAR_MAP][0] * 8) {
        ChangePage(gear, PAGE_MAP);
    } else if (x >= sAppBarButtons[APP_BAR_RADIO][0] * 8) {
        ChangePage(gear, PAGE_RADIO);
    } else {
        Sound_PlayEffect(SEQ_SE_DP_BEEP_sseq); // the settings (HeartGold's skins) aren't here
    }
}

static void HandleTouch(CompletePokegear *gear)
{
    u16 x = gSystem.touchX, y = gSystem.touchY;

    if (gSystem.touchPressed && y >= BAR_TOP * 8) {
        HandleAppBarTouch(gear, x);
        return;
    }

    if (gear->page == PAGE_MAP) {
        HandleMapTouch(gear);
        return;
    }

    if (gear->page == PAGE_RADIO) {
        return; // RadioPage_Run
    }

    if (gSystem.touchHeld && gear->held) {
        if (++gear->heldFrames >= REPEAT_DELAY && (gear->heldFrames - REPEAT_DELAY) % REPEAT_FRAMES == 0) {
            Scroll(gear, gear->held == 1 ? -1 : 1);
        }

        return;
    }

    gear->held = 0;

    if (!gSystem.touchPressed) {
        return;
    }

    if (x >= LIST_X && x < LIST_X + LIST_WIDTH && y >= LIST_Y && y < LIST_Y + LIST_ROWS * ROW_HEIGHT) {
        int row = (y - LIST_Y) / ROW_HEIGHT;

        if ((y - LIST_Y) % ROW_HEIGHT < ROW_HEIGHT - 4 && gear->top + row < gear->numContacts) {
            gear->lit = row;
            gear->litTimer = CALL_HIGHLIGHT;
            Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
            DrawList(gear);
            CompletePhone_RequestCall(gear->contacts[gear->top + row]);
        }
    } else if (Touched(&sUpArrow, x, y) || Touched(&sDownArrow, x, y)) {
        gear->held = Touched(&sUpArrow, x, y) ? 1 : 2;
        gear->heldFrames = 0;
        Scroll(gear, gear->held == 1 ? -1 : 1);
    }
}

static void Shutdown(CompletePokegear *gear)
{
    DisableTouchPad();
    UnloadPage(gear, FALSE);
    Bg_FreeTilemapBuffer(gear->bgConfig, BG_LAYER_SUB_0);
    Bg_FreeTilemapBuffer(gear->bgConfig, BG_LAYER_SUB_1);
    MessageLoader_Free(gear->titles);
    MessageLoader_Free(gear->classes);
}

static void CompletePokegear_Task(SysTask *task, void *data)
{
    CompletePokegear *gear = data;

    if (gear->state == POKEGEAR_STATE_SHUTDOWN) {
        Shutdown(gear);
        SysTask_Done(task);
        Heap_Free(gear);
        sPokegear = NULL;
#ifdef SOVEREIGN_TEST
        gCompleteTestPokegear = NULL;
#endif
        Heap_Destroy(HEAP_ID_POKETCH_APP);
        return;
    }

    HandleTouch(gear);
    DrawMarker(gear);

    if (gear->page == PAGE_RADIO && gear->radio != NULL) {
        RadioPage_Run(gear->radio);
    }

#ifdef SOVEREIGN_TEST
    gCompleteTestPokegearMap[0] = gear->page;
    gCompleteTestPokegearMap[1] = gear->marker ? gear->markerX : 0xFFFF;
    gCompleteTestPokegearMap[2] = gear->marker ? gear->markerY : 0xFFFF;
    gCompleteTestPokegearMap[3] = gear->scrollX;
#endif

    if (gear->litTimer != 0 && --gear->litTimer == 0 && gear->page == PAGE_PHONE) {
        gear->lit = LIST_ROWS;
        DrawList(gear);
    }

    if (++gear->refreshTimer >= REFRESH_FRAMES) {
        u8 contacts[NUM_PHONE_CONTACTS], count;

        gear->refreshTimer = 0;
        ReadPhoneBook(gear, contacts, &count);

        if (count != gear->numContacts || memcmp(contacts, gear->contacts, count) != 0) {
            MI_CpuCopy8(contacts, gear->contacts, count);
            gear->numContacts = count;
            gear->top = 0;

            if (gear->page == PAGE_PHONE) {
                DrawList(gear);
            }
        }

        // the map follows the player as they walk
        if (gear->page == PAGE_MAP) {
            s16 x, y;
            BOOL marker = PlayerMapPosition(gear, &x, &y);

            gear->marker = marker;
            gear->markerX = x;
            gear->markerY = y;

            if (gear->mapHeaderID != gear->fieldSystem->location->mapHeaderID) {
                gear->mapHeaderID = gear->fieldSystem->location->mapHeaderID;
                DrawPlaceName(gear);
            }
        }

        if (CompletePokegear_PoketchAvailable(gear->saveData) != gear->poketchShown) {
            DrawAppBar(gear);
        }
    }
}

void CompletePokegear_Create(FieldSystem *fieldSystem, BgConfig *bgConfig)
{
    Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_POKETCH_APP, HEAP_SIZE_PRE_POKETCH_SUBSCREEN);

    CompletePokegear *gear = Heap_Alloc(HEAP_ID_POKETCH_APP, sizeof(CompletePokegear));

    MI_CpuClear8(gear, sizeof(CompletePokegear));
    gear->fieldSystem = fieldSystem;
    gear->saveData = FieldSystem_GetSaveData(fieldSystem);
    gear->bgConfig = bgConfig;
    gear->lit = LIST_ROWS;
    gear->page = CompletePokegear_GetPage();
    gear->titles = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0271, HEAP_ID_POKETCH_APP);
    gear->classes = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_TRAINER_CLASS_NAMES, HEAP_ID_POKETCH_APP);
    ReadPhoneBook(gear, gear->contacts, &gear->numContacts);

    LoadGraphics(gear);

    EnableTouchPad();
    InitializeTouchPad(4);

    sPokegear = gear;
#ifdef SOVEREIGN_TEST
    gCompleteTestPokegear = gear;
#endif
    gear->task = SysTask_Start(CompletePokegear_Task, gear, 0);
}

void CompletePokegear_StartShutdown(void)
{
    if (sPokegear != NULL) {
        sPokegear->state = POKEGEAR_STATE_SHUTDOWN;
    }
}

BOOL CompletePokegear_IsShutdown(void)
{
    return sPokegear == NULL;
}
