#include <nitro.h>

#include "constants/heap.h"
#include "constants/hgss_spawns.h"
#include "constants/narc.h"
#include "generated/genders.h"
#include "generated/text_banks.h"
#include "generated/trainers.h"

#include "applications/complete_pokegear/radio.h"
#include "bg_window.h"
#include "complete_map_info.h"
#include "complete_phone.h"
#include "complete_pokegear.h"
#include "field_task.h"
#include "font.h"
#include "graphics.h"
#include "heap.h"
#include "location.h"
#include "message.h"
#include "narc.h"
#include "player_avatar.h"
#include "render_oam.h"
#include "savedata.h"
#include "sound_playback.h"
#include "spawn_locations.h"
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
//   message box once the player stands still), but not while a scene or a warp runs; the arrows scroll the list.
// - the Map: its map of Johto and Kanto, with the player's head where they are (HeartGold's map app's place: the
//   overworld's block, or the world map place of a map off it) and the place's name; dragging scrolls it.
// - the Radio (radio/radio_page.c): the globe that tunes Johto's and Kanto's stations, and their shows; its music is
//   the field's while the page shows a station, and leaving the page turns it off.
// - the Settings: HeartGold's six skins (its configure app), a tap on one dressing the whole Pokégear in it.
// Fly over Johto and Kanto uses the Map as HeartGold's fly map does: HeartGold's cursor on the Fly points reached, the
// D-pad or a tap moving it, A or a second tap flying there, B backing out (CompletePokegear_GetFly).
// The app bar's last button switches to the Pokétch when the player has it. A call coming in rings, the Phone button
// flashing, until the player taps it to answer.

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
#define RING_FLASH       16 // frames the Phone button is lit, then dimmed, while a call rings
#define FLY_CURSOR_TILE  12 // HeartGold's map cursor, its two frames (marker.png)
#define FLY_CURSOR_FLASH 16 // frames each of its frames shows
#define FLY_TOUCH_RANGE  12 // a tap this near a Fly point picks it
#define FLY_EDGE         24 // the map scrolls to keep the cursor this far in from its edges

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
    PAGE_SETTINGS,
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
    u8 ringing; // a call rings: the Phone button flashes
    u8 ringFrames;
    u8 page;
    u8 marker; // the map shows the player's head
    s16 scrollX; // the map's
    s16 dragX; // the touch's last x as it drags the map, -1 for none
    s16 markerX; // the player's place on the map
    s16 markerY;
    u16 mapHeaderID; // the place named
    RadioPage *radio;
    u8 skin; // HeartGold's: each graphic's variant (CompletePokegear_GetSkin)
    void *configFile; // the Settings' screen and its frame, while it shows
    void *frameFile;
    NNSG2dScreenData *configScreen;
    NNSG2dScreenData *frameScreen;
    u8 contacts[NUM_PHONE_CONTACTS];
    u16 appBar[4][2][32]; // HeartGold's app bar's rows: lit and dimmed
    BOOL mapCard; // the Map Card and the Radio Card (CompletePokegear_HasCard), as the app bar was last drawn
    BOOL radioCard;
    u8 fly; // choosing where to Fly (CompletePokegear_GetFly)
    u8 flyPage; // the page before it
    u8 flyCount;
    u8 flySelected;
    u8 flyFrames;
    u8 flySpawns[SPAWN_HGSS_COUNT]; // the Fly points reached, and where they are on the map
    s16 flyX[SPAWN_HGSS_COUNT];
    s16 flyY[SPAWN_HGSS_COUNT];
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

// HeartGold's configure app's skins (its sTouchscreenHitboxes), three a row
static const Box sSkinButtons[COMPLETE_POKEGEAR_SKINS] = {
    { 24, 64, 24, 72 },
    { 24, 64, 104, 152 },
    { 24, 64, 184, 232 },
    { 96, 136, 24, 72 },
    { 96, 136, 104, 152 },
    { 96, 136, 184, 232 },
};
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

// HeartGold's app bar (its PokegearApp_UpdateAppSwitchButtonBGState): the settings and the phone lit, the map and the
// radio with their cards, and, with a Pokétch to switch to, the exit button. While a call rings, the phone flashes.
static void DrawAppBar(CompletePokegear *gear)
{
    gear->poketchShown = CompletePokegear_PoketchAvailable(gear->saveData);
    gear->mapCard = CompletePokegear_HasCard(gear->saveData, COMPLETE_POKEGEAR_CARD_MAP);
    gear->radioCard = CompletePokegear_HasCard(gear->saveData, COMPLETE_POKEGEAR_CARD_RADIO);

    for (int y = 0; y < 4; y++) {
        u16 row[32];

        for (int x = 0; x < 32; x++) {
            row[x] = gear->appBar[y][1][x];
        }

        for (int button = 0; button < APP_BAR_BUTTONS; button++) {
            BOOL lit = button == APP_BAR_SETTINGS || (button == APP_BAR_MAP && gear->mapCard) || (button == APP_BAR_RADIO && gear->radioCard)
                || (button == APP_BAR_EXIT && gear->poketchShown)
                || (button == APP_BAR_PHONE && (!gear->ringing || gear->ringFrames < RING_FLASH));

            for (int x = sAppBarButtons[button][0]; x < sAppBarButtons[button][0] + sAppBarButtons[button][1]; x++) {
                row[x] = gear->appBar[y][!lit][x];
            }
        }

        Bg_LoadToTilemapRect(gear->bgConfig, BG_LAYER_SUB_0, row, 0, BAR_TOP + y, 32, 1);
    }

    Bg_CopyTilemapBufferToVRAM(gear->bgConfig, BG_LAYER_SUB_0);
}

// Where a tile of a map is on the map, as HeartGold's map app puts it: on Johto and Kanto's overworld, its block of 32
// tiles; off it, the place the map's header gives (HeartGold's MapHeader_GetWorldMapCoords). FALSE in Sinnoh, or
// for a map with no place.
static BOOL MapPosition(enum MapHeaderID mapHeaderID, int tileX, int tileZ, s16 *x, s16 *y)
{
    int blockX, blockY;

    if (!MapHeader_IsHGSS(mapHeaderID)) {
        return FALSE;
    }

    if (MapHeader_GetMapMatrixID(mapHeaderID) == map_matrix_hgss_0000) {
        blockX = tileX / 32;
        blockY = tileZ / 32;
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

static BOOL PlayerMapPosition(CompletePokegear *gear, s16 *x, s16 *y)
{
    return MapPosition(gear->fieldSystem->location->mapHeaderID, PlayerAvatar_GetXPos(gear->fieldSystem->playerAvatar),
        PlayerAvatar_GetZPos(gear->fieldSystem->playerAvatar), x, y);
}

static void SetMapScroll(CompletePokegear *gear, int scrollX)
{
    scrollX = scrollX < 0 ? 0 : scrollX > MAP_SCROLL_MAX ? MAP_SCROLL_MAX : scrollX;

    if (scrollX != gear->scrollX) {
        gear->scrollX = scrollX;
        Bg_SetOffset(gear->bgConfig, BG_LAYER_SUB_1, BG_OFFSET_UPDATE_SET_X, scrollX);
    }
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

// The Settings: HeartGold's configure screen (its six skins) on layer 1, and on layer 0 over it its frame around the
// skin in use (HeartGold's PokegearConfigure_SetNewSkin, on a layer of its own there too), both with the screen's tiles
static void DrawSettings(CompletePokegear *gear)
{
    const u16 *frame = (const u16 *)gear->frameScreen->rawData;
    int frameWidth = gear->frameScreen->screenWidth / 8;
    int left = 10 * (gear->skin % 3) + 2, top = 9 * (gear->skin / 3) + 2;

    Bg_LoadToTilemapRect(gear->bgConfig, BG_LAYER_SUB_1, gear->configScreen->rawData, 0, 0, 32, BAR_TOP);
    Bg_FillTilemapRect(gear->bgConfig, BG_LAYER_SUB_0, BLANK_TILE, 0, 0, 32, BAR_TOP, 0);

    for (int y = 0; y < 7; y++) {
        for (int x = 0; x < 9; x++) {
            u16 entry = frame[y * frameWidth + x];

            if ((entry & 0x3FF) != 0) {
                Bg_LoadToTilemapRect(gear->bgConfig, BG_LAYER_SUB_0, &entry, left + x, top + y, 1, 1);
            }
        }
    }

    Bg_CopyTilemapBufferToVRAM(gear->bgConfig, BG_LAYER_SUB_0);
    Bg_CopyTilemapBufferToVRAM(gear->bgConfig, BG_LAYER_SUB_1);
}

static void LoadSettings(CompletePokegear *gear, NARC *narc)
{
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, config_0_NCGR + gear->skin, gear->bgConfig, BG_LAYER_SUB_0, 0, 0, FALSE, HEAP_ID_POKETCH_APP);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, config_0_NCGR + gear->skin, gear->bgConfig, BG_LAYER_SUB_1, 0, 0, FALSE, HEAP_ID_POKETCH_APP);
    Graphics_LoadPaletteFromOpenNARC(narc, config_0_NCLR + gear->skin, PAL_LOAD_SUB_BG, 0, PALETTE_SIZE_BYTES * 16, HEAP_ID_POKETCH_APP);
    gear->configFile = Graphics_GetScrnDataFromOpenNARC(narc, config_0_NSCR + gear->skin, FALSE, &gear->configScreen, HEAP_ID_POKETCH_APP);
    gear->frameFile = Graphics_GetScrnDataFromOpenNARC(narc, config_frame_0_NSCR + gear->skin, FALSE, &gear->frameScreen, HEAP_ID_POKETCH_APP);
    DrawSettings(gear);
}

// The page's layers: the Phone's frame (layer 0, tiles 0-127) and its list's window (layer 1); the Map's map (layer 1,
// its tiles over the frame's, which is off) and its place name's window (layer 0, tiles 256 on); or the Radio's globe
// and its windows (layer 0, radio_page.c)
static void LoadPage(CompletePokegear *gear)
{
    NARC *narc = NARC_ctor(NARC_INDEX_APPLICATION__COMPLETE__POKEGEAR, HEAP_ID_POKETCH_APP);
    NNSG2dScreenData *screen;

    if (gear->page == PAGE_PHONE) {
        Graphics_LoadTilesToBgLayerFromOpenNARC(narc, phone_0_NCGR + gear->skin, gear->bgConfig, BG_LAYER_SUB_0, 0, 0, FALSE, HEAP_ID_POKETCH_APP);
        Graphics_LoadPaletteFromOpenNARC(narc, pokegear_0_NCLR + gear->skin, PAL_LOAD_SUB_BG, 0, PALETTE_SIZE_BYTES * 16, HEAP_ID_POKETCH_APP);

        void *file = Graphics_GetScrnDataFromOpenNARC(narc, phone_0_NSCR + gear->skin, FALSE, &screen, HEAP_ID_POKETCH_APP);

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
        gear->radio = RadioPage_New(gear->fieldSystem, gear->bgConfig, HEAP_ID_POKETCH_APP, gear->skin);
    } else if (gear->page == PAGE_SETTINGS) {
        Bg_ClearTilemap(gear->bgConfig, BG_LAYER_SUB_1);
        Bg_SetOffset(gear->bgConfig, BG_LAYER_SUB_1, BG_OFFSET_UPDATE_SET_X, 0);
        LoadSettings(gear, narc);
    } else {
        Graphics_LoadTilesToBgLayerFromOpenNARC(narc, map_NCGR, gear->bgConfig, BG_LAYER_SUB_1, 0, 0, FALSE, HEAP_ID_POKETCH_APP);
        Graphics_LoadPaletteFromOpenNARC(narc, map_0_NCLR + gear->skin, PAL_LOAD_SUB_BG, 0, PALETTE_SIZE_BYTES * 16, HEAP_ID_POKETCH_APP);

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
    GXS_SetVisiblePlane(GX_PLANEMASK_BG0 | GX_PLANEMASK_BG1 | (gear->page == PAGE_MAP || gear->page == PAGE_RADIO ? GX_PLANEMASK_OBJ : 0));
}

// turnOff: the player left the Radio page, so its music ends (a shutdown leaves it on, for the page to pick it up again)
static void UnloadPage(CompletePokegear *gear, BOOL turnOff)
{
    if (gear->page == PAGE_PHONE) {
        Window_Remove(&gear->list);
    } else if (gear->page == PAGE_RADIO) {
        RadioPage_Free(gear->radio, turnOff);
        gear->radio = NULL;
    } else if (gear->page == PAGE_SETTINGS) {
        Heap_Free(gear->configFile);
        Heap_Free(gear->frameFile);
        gear->configFile = gear->frameFile = NULL;
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

// The skin's app bar: its two states, lit (its rows 0-3) and dimmed (4-7), its tiles after the page's
static void LoadAppBar(CompletePokegear *gear)
{
    NNSG2dScreenData *screen;
    NARC *narc = NARC_ctor(NARC_INDEX_APPLICATION__COMPLETE__POKEGEAR, HEAP_ID_POKETCH_APP);

    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, app_bar_0_NCGR + gear->skin, gear->bgConfig, BG_LAYER_SUB_0, BAR_TILE_START, 0, FALSE, HEAP_ID_POKETCH_APP);

    void *file = Graphics_GetScrnDataFromOpenNARC(narc, app_bar_0_NSCR + gear->skin, FALSE, &screen, HEAP_ID_POKETCH_APP);
    const u16 *src = (const u16 *)screen->rawData;

    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 32; x++) {
            gear->appBar[y][0][x] = src[y * 32 + x] + BAR_TILE_START;
            gear->appBar[y][1][x] = src[(y + 4) * 32 + x] + BAR_TILE_START;
        }
    }

    Heap_Free(file);
    NARC_dtor(narc);
}

// A skin tapped on the Settings: the whole Pokégear in it (HeartGold's comes back to its apps in it)
static void ChangeSkin(CompletePokegear *gear, u8 skin)
{
    if (skin == gear->skin) {
        return;
    }

    Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
    CompletePokegear_SetSkin(gear->saveData, skin);
    UnloadPage(gear, FALSE);
    gear->skin = skin;
    LoadAppBar(gear);
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
    GXS_SetGraphicsMode(GX_BGMODE_0);
    GX_SetBankForSubBG(GX_VRAM_SUB_BG_32_H);
    GX_SetBankForSubOBJ(GX_VRAM_SUB_OBJ_16_I);
    GXS_SetOBJVRamModeChar(GX_OBJVRAMMODE_CHAR_1D_32K);

    Bg_InitFromTemplate(gear->bgConfig, BG_LAYER_SUB_0, &sFrameTemplate, BG_TYPE_STATIC);
    Bg_InitFromTemplate(gear->bgConfig, BG_LAYER_SUB_1, &sListTemplate, BG_TYPE_STATIC);

    LoadAppBar(gear);

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
        SetMapScroll(gear, gear->scrollX - (gSystem.touchX - gear->dragX));
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

// Fly's pick: its name below the map, and the map scrolled to show it
static void ShowFlyPick(CompletePokegear *gear)
{
    int x = gear->flyX[gear->flySelected] - gear->scrollX;

    gear->mapHeaderID = GetFlyLocationMap(gear->flySpawns[gear->flySelected]);
    DrawPlaceName(gear);

    if (x < FLY_EDGE || x >= 256 - FLY_EDGE) {
        SetMapScroll(gear, gear->flyX[gear->flySelected] - 128);
    }
}

// HeartGold's fly map, on the Map: the Fly points reached that have a place on it (CompleteMapInfo_FlyPoints), the
// cursor on the nearest to the player
static void StartFly(CompletePokegear *gear)
{
    u8 spawns[SPAWN_HGSS_COUNT];
    int count = CompleteMapInfo_FlyPoints(gear->fieldSystem, spawns, SPAWN_HGSS_COUNT);
    s16 playerX = 0, playerY = 0;
    BOOL player = PlayerMapPosition(gear, &playerX, &playerY);
    int nearest = -1;

    gear->flyCount = 0;

    for (int i = 0; i < count; i++) {
        Location location;
        u8 n = gear->flyCount;

        Location_InitFly(spawns[i], &location);

        if (MapPosition(location.mapHeaderID, location.x, location.z, &gear->flyX[n], &gear->flyY[n])) {
            int dist = (gear->flyX[n] - playerX) * (gear->flyX[n] - playerX) + (gear->flyY[n] - playerY) * (gear->flyY[n] - playerY);

            if (nearest < 0 || dist < nearest) {
                nearest = dist;
                gear->flySelected = n;
            }

            gear->flySpawns[gear->flyCount++] = spawns[i];
        }
    }

    if (gear->flyCount == 0) {
        CompletePokegear_SetFly(COMPLETE_POKEGEAR_FLY_CANCELLED, 0);
        return;
    }

    if (!player) {
        gear->flySelected = 0;
    }

    gear->flyPage = gear->page;
    ChangePage(gear, PAGE_MAP);
    gear->fly = TRUE;
    gear->flyFrames = 0;
    ShowFlyPick(gear);
}

static void EndFly(CompletePokegear *gear, enum CompletePokegearFly result)
{
    Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
    CompletePokegear_SetFly(result, result == COMPLETE_POKEGEAR_FLY_CHOSEN ? gear->flySpawns[gear->flySelected] : 0);
    gear->fly = FALSE;
    gear->mapHeaderID = gear->fieldSystem->location->mapHeaderID;
    DrawPlaceName(gear);
    ChangePage(gear, gear->flyPage);
}

// The D-pad moves the cursor to the nearest Fly point that way (within about 60 degrees of it), as HeartGold's does
static void MoveFlyCursor(CompletePokegear *gear, int dx, int dy)
{
    int best = -1, bestDist = 0;

    for (int i = 0; i < gear->flyCount; i++) {
        int ox = gear->flyX[i] - gear->flyX[gear->flySelected];
        int oy = gear->flyY[i] - gear->flyY[gear->flySelected];
        int along = ox * dx + oy * dy;
        int across = ox * dy - oy * dx;

        across = across < 0 ? -across : across;

        if (i == gear->flySelected || along <= 0 || across > along * 2) {
            continue;
        }

        if (best < 0 || along + across * 2 < bestDist) {
            best = i;
            bestDist = along + across * 2;
        }
    }

    if (best >= 0) {
        gear->flySelected = best;
        Sound_PlayEffect(SEQ_SE_DP_SELECT5_sseq);
        ShowFlyPick(gear);
    }
}

static void RunFly(CompletePokegear *gear)
{
    u16 spawn;

    if (CompletePokegear_GetFly(&spawn) != COMPLETE_POKEGEAR_FLY_CHOOSING) { // the field stopped asking
        gear->fly = FALSE;
        return;
    }

    if (gSystem.pressedKeys & PAD_BUTTON_A) {
        EndFly(gear, COMPLETE_POKEGEAR_FLY_CHOSEN);
    } else if (gSystem.pressedKeys & PAD_BUTTON_B) {
        EndFly(gear, COMPLETE_POKEGEAR_FLY_CANCELLED);
    } else if (gSystem.pressedKeys & PAD_KEY_RIGHT) {
        MoveFlyCursor(gear, 1, 0);
    } else if (gSystem.pressedKeys & PAD_KEY_LEFT) {
        MoveFlyCursor(gear, -1, 0);
    } else if (gSystem.pressedKeys & PAD_KEY_DOWN) {
        MoveFlyCursor(gear, 0, 1);
    } else if (gSystem.pressedKeys & PAD_KEY_UP) {
        MoveFlyCursor(gear, 0, -1);
    }
}

// A tap on a Fly point picks it, and a tap on the one picked flies there; elsewhere the map drags as usual
static BOOL HandleFlyTouch(CompletePokegear *gear)
{
    int x = gSystem.touchX + gear->scrollX, y = gSystem.touchY;
    int best = -1, bestDist = FLY_TOUCH_RANGE * FLY_TOUCH_RANGE + 1;

    if (!gSystem.touchPressed) {
        return FALSE;
    }

    for (int i = 0; i < gear->flyCount; i++) {
        int dist = (gear->flyX[i] - x) * (gear->flyX[i] - x) + (gear->flyY[i] - y) * (gear->flyY[i] - y);

        if (dist < bestDist) {
            best = i;
            bestDist = dist;
        }
    }

    if (best < 0) {
        return FALSE;
    }

    if (best == gear->flySelected) {
        EndFly(gear, COMPLETE_POKEGEAR_FLY_CHOSEN);
    } else {
        gear->flySelected = best;
        Sound_PlayEffect(SEQ_SE_DP_SELECT5_sseq);
        ShowFlyPick(gear);
    }

    return TRUE;
}

// HeartGold's cursor on Fly's pick, flashing between its two frames, over the player's head
static void DrawFlyCursor(CompletePokegear *gear)
{
    GXOamAttr oam;
    int x = gear->flyX[gear->flySelected] - gear->scrollX - MARKER_SIZE / 2;
    int y = gear->flyY[gear->flySelected] - MARKER_SIZE / 2;
    int frame = (gear->flyFrames++ / FLY_CURSOR_FLASH) % 2;

    if (!gear->fly || x < -MARKER_SIZE || x >= 256) {
        return;
    }

    G2_SetOBJAttr(&oam, x & 0x1FF, y, 0, GX_OAM_MODE_NORMAL, FALSE, GX_OAM_EFFECT_NONE, GX_OAM_SHAPE_16x16, GX_OAM_COLORMODE_16, FLY_CURSOR_TILE + frame * 4, 0, 0);
    NNS_G2dEntryOamManagerOam(RenderOam_GetScreenOam(DS_SCREEN_SUB), &oam, 1);
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
        // a call ringing: the Phone answers it (the field makes the call as the player stands still), but not in a
        // scene or a warp
        if (CompletePhone_IsRinging() && !FieldSystem_IsRunningTask(gear->fieldSystem)) {
            Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
            CompletePhone_Answer();
        }

        ChangePage(gear, PAGE_PHONE);
    } else if (x >= sAppBarButtons[APP_BAR_MAP][0] * 8) {
        if (gear->mapCard) {
            ChangePage(gear, PAGE_MAP);
        } else {
            Sound_PlayEffect(SEQ_SE_DP_BEEP_sseq); // no Map Card yet
        }
    } else if (x >= sAppBarButtons[APP_BAR_RADIO][0] * 8) {
        if (gear->radioCard) {
            ChangePage(gear, PAGE_RADIO);
        } else {
            Sound_PlayEffect(SEQ_SE_DP_BEEP_sseq); // no Radio Card yet
        }
    } else {
        ChangePage(gear, PAGE_SETTINGS);
    }
}

static void HandleTouch(CompletePokegear *gear)
{
    u16 x = gSystem.touchX, y = gSystem.touchY;

    if (gSystem.touchPressed && y >= BAR_TOP * 8) {
        if (gear->fly) {
            Sound_PlayEffect(SEQ_SE_DP_BEEP_sseq); // the other pages wait for Fly's pick
        } else {
            HandleAppBarTouch(gear, x);
        }

        return;
    }

    if (gear->page == PAGE_MAP) {
        if (!gear->fly || !HandleFlyTouch(gear)) {
            HandleMapTouch(gear);
        }

        return;
    }

    if (gear->page == PAGE_RADIO) {
        return; // RadioPage_Run
    }

    if (gear->page == PAGE_SETTINGS) {
        for (int skin = 0; gSystem.touchPressed && skin < COMPLETE_POKEGEAR_SKINS; skin++) {
            if (Touched(&sSkinButtons[skin], x, y)) {
                ChangeSkin(gear, skin);
                break;
            }
        }

        return;
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

        if ((y - LIST_Y) % ROW_HEIGHT < ROW_HEIGHT - 4 && gear->top + row < gear->numContacts
            && FieldSystem_IsRunningTask(gear->fieldSystem)) {
            Sound_PlayEffect(SEQ_SE_DP_BEEP_sseq); // no calls during a scene, a warp or a battle's way in
        } else if ((y - LIST_Y) % ROW_HEIGHT < ROW_HEIGHT - 4 && gear->top + row < gear->numContacts) {
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

    u16 spawn;

    if (!gear->fly && CompletePokegear_GetFly(&spawn) == COMPLETE_POKEGEAR_FLY_CHOOSING) {
        StartFly(gear);
    }

    HandleTouch(gear);

    if (gear->fly) {
        RunFly(gear);
        DrawFlyCursor(gear);
    }

    DrawMarker(gear);

    if (gear->page == PAGE_RADIO && gear->radio != NULL) {
        RadioPage_Run(gear->radio);
    }

#ifdef SOVEREIGN_TEST
    gCompleteTestPokegearMap[0] = gear->page;
    gCompleteTestPokegearMap[1] = gear->marker ? gear->markerX : 0xFFFF;
    gCompleteTestPokegearMap[2] = gear->marker ? gear->markerY : 0xFFFF;
    gCompleteTestPokegearMap[3] = gear->scrollX;
    gCompleteTestPokegearMap[4] = gear->skin;
    gCompleteTestPokegearMap[5] = gear->fly ? gear->flySpawns[gear->flySelected] : 0xFFFF;
    gCompleteTestPokegearMap[6] = gear->fly ? gear->flyX[gear->flySelected] - gear->scrollX : 0xFFFF;
    gCompleteTestPokegearMap[7] = gear->fly ? gear->flyY[gear->flySelected] : 0xFFFF;
#endif

    // a call ringing: the Phone button flashes
    if (CompletePhone_IsRinging() || gear->ringing) {
        gear->ringing = CompletePhone_IsRinging();
        gear->ringFrames = (gear->ringFrames + 1) % (RING_FLASH * 2);

        if (gear->ringFrames % RING_FLASH == 0 || !gear->ringing) {
            DrawAppBar(gear);
        }
    }

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

            if (!gear->fly && gear->mapHeaderID != gear->fieldSystem->location->mapHeaderID) {
                gear->mapHeaderID = gear->fieldSystem->location->mapHeaderID;
                DrawPlaceName(gear);
            }
        }

        // the Pokétch to switch to, or a card just given (the guide's Map Card, the quiz's Radio Card): the bar again
        if (CompletePokegear_PoketchAvailable(gear->saveData) != gear->poketchShown
            || CompletePokegear_HasCard(gear->saveData, COMPLETE_POKEGEAR_CARD_MAP) != gear->mapCard
            || CompletePokegear_HasCard(gear->saveData, COMPLETE_POKEGEAR_CARD_RADIO) != gear->radioCard) {
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

    // the page it was last on, unless that app's card is gone (an older save) or not had yet
    if ((gear->page == PAGE_MAP && !CompletePokegear_HasCard(gear->saveData, COMPLETE_POKEGEAR_CARD_MAP))
        || (gear->page == PAGE_RADIO && !CompletePokegear_HasCard(gear->saveData, COMPLETE_POKEGEAR_CARD_RADIO))) {
        gear->page = PAGE_PHONE;
    }
    gear->skin = CompletePokegear_GetSkin(gear->saveData);
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
