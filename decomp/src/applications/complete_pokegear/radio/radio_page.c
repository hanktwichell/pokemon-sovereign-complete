#include <nitro.h>

#include "constants/narc.h"
#include "generated/map_headers.h"
#include "generated/vars_flags.h"

#include "applications/complete_pokegear/radio.h"
#include "field/field_system.h"

#include "bg_window.h"
#include "complete_map_info.h"
#include "complete_radio.h"
#include "graphics.h"
#include "heap.h"
#include "location.h"
#include "narc.h"
#include "render_oam.h"
#include "sound_playback.h"
#include "system.h"
#include "text.h"
#include "touch_screen.h"
#include "vars_flags.h"

#include "res/graphics/complete_pokegear/complete_pokegear.naix"

// Sovereign Complete: the Pokégear's Radio page (HeartGold's pokegear_radio.c and overlay_101_021F4F34.c): the globe,
// where dragging the cursor tunes the stations of where the player is (inside a station's inner ring, a clear signal;
// in its outer ring, static), and the four buttons beside it, which put the cursor on each of the four stations. The
// player's buttons walk the field here, so the radio takes touches only (HeartGold also tunes with the + Control Pad).

#define WINDOW_TILE_START 256 // after the globe's tiles (0-127) and the app bar's (128-255), in layer 0
#define TEXT_PALETTE      12
#define TITLE_TOP         1 // the band at the top
#define SCRIPT_TOP        18 // the strip under the globe
#define WINDOW_LEFT       1
#define WINDOW_WIDTH      30
#define COLOR_STRIP       11 // the map page's place name colours
#define CURSOR_TILE       8 // marker.png's: after the player's heads
#define CURSOR_PALETTE    1
#define CURSOR_SIZE       16
#define CURSOR_DEFAULT_X  128 // HeartGold's new save
#define CURSOR_DEFAULT_Y  128
#define CURSOR_GRAB       8 // a tap this close to the cursor picks it up
#define BUTTON_SIZE       4 // tiles
#define BUTTON_SRC_ROW    24 // the NSCR's buttons below the screen: dimmed at column 0, lit at 4
#define SCREEN_ROWS       20
#define NO_BUTTON         4
#define NO_STATION        0xFF
#define SETTLE_FRAMES     60 // a new map retunes the radio once the field has its music on

struct RadioPage {
    FieldSystem *fieldSystem;
    BgConfig *bgConfig;
    enum HeapID heapID;
    Window script;
    Window title;
    RadioShow *show;
    void *screenFile;
    NNSG2dScreenData *screen;
    u16 mapHeaderID;
    s16 cursorX;
    s16 cursorY;
    u8 selection;
    u8 station;
    u8 signalStrength; // 0 none, 1 static, 2 clear
    u8 stationActive;
    u8 selectedButton;
    u8 dragging;
    u8 settle;
};

static const TouchScreenHitTable sTuningArea = { .circle = { TOUCHSCREEN_USE_CIRCLE, 128, 92, 52 } };

// Each station's inner ring (a clear signal) then its outer one
static const TouchScreenHitTable sTuningHitboxes_Johto[] = {
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 112, 76, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 112, 76, 16 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 152, 76, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 152, 76, 20 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 96, 108, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 96, 108, 16 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 136, 116, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 136, 116, 20 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR } },
};

static const TouchScreenHitTable sTuningHitboxes_Kanto[] = {
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 112, 76, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 112, 76, 16 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 152, 76, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 152, 76, 20 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 96, 108, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 96, 108, 16 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR } },
};

// With the Expansion Card: the fourth station back, and the Poké Flute's at the top
static const TouchScreenHitTable sTuningHitboxes_KantoEXPN[] = {
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 112, 76, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 112, 76, 16 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 152, 76, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 152, 76, 20 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 96, 108, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 96, 108, 16 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 136, 116, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 136, 116, 20 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 128, 48, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 128, 48, 8 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR } },
};

static const TouchScreenHitTable sTuningHitboxes_NoSignal[] = {
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR } },
};

// One signal over the whole globe
static const TouchScreenHitTable sTuningHitboxes_Rocket_Mahogany[] = {
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 128, 92, 38 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 128, 92, 52 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR } },
};

static const TouchScreenHitTable sTuningHitboxes_Alph[] = {
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 128, 92, 4 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 128, 92, 16 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR } },
};

static const TouchScreenHitTable *sTuningHitboxes[] = {
    [RADIO_STATION_SELECTION_JOHTO] = sTuningHitboxes_Johto,
    [RADIO_STATION_SELECTION_KANTO] = sTuningHitboxes_Kanto,
    [RADIO_STATION_SELECTION_KANTO_EXPN] = sTuningHitboxes_KantoEXPN,
    [RADIO_STATION_SELECTION_NO_SIGNAL] = sTuningHitboxes_NoSignal,
    [RADIO_STATION_SELECTION_ALPH] = sTuningHitboxes_Alph,
    [RADIO_STATION_SELECTION_ROCKET] = sTuningHitboxes_Rocket_Mahogany,
    [RADIO_STATION_SELECTION_MAHOGANY] = sTuningHitboxes_Rocket_Mahogany,
};

static const TouchScreenRect sTuningButtons[] = {
    { .rect = { 48, 76, 16, 48 } },
    { .rect = { 48, 76, 208, 240 } },
    { .rect = { 112, 140, 16, 48 } },
    { .rect = { 112, 140, 208, 240 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR } },
};

static const u8 sButtonTiles[][2] = { { 2, 6 }, { 26, 6 }, { 2, 14 }, { 26, 14 } };

// HeartGold's sAlphMaps and sMahoganyMaps: where the Unown's broadcast, and the Rockets' signal, are all there is
static const u16 sAlphMaps[] = {
    MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL,
    MAP_HEADER_HGSS_RUINS_OF_ALPH_HALL_ENTRANCE,
    MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT,
    MAP_HEADER_HGSS_RUINS_OF_ALPH_HALL_ENTRANCE_SINJOH_EVENT,
    MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2,
};

static const u16 sMahoganyMaps[] = {
    MAP_HEADER_HGSS_MAHOGANY,
    MAP_HEADER_HGSS_MAHOGANY_EAST_HOUSE,
    MAP_HEADER_HGSS_MAHOGANY_GYM_LEADER_ROOM,
    MAP_HEADER_HGSS_MAHOGANY_GYM_ROOM_2,
    MAP_HEADER_HGSS_MAHOGANY_GYM_ROOM_1,
    MAP_HEADER_HGSS_MAHOGANY_POKECENTER_1F,
    MAP_HEADER_HGSS_MAHOGANY_POKECENTER_B1F,
    MAP_HEADER_HGSS_MAHOGANY_SOUVENIR_SHOP,
    MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B1F,
    MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B2F,
    MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B3F,
    MAP_HEADER_HGSS_ROUTE_43,
    MAP_HEADER_HGSS_ROUTE_43_MAHOGANY_GATEHOUSE,
    MAP_HEADER_HGSS_ROUTE_43_GATEHOUSE,
    MAP_HEADER_HGSS_LAKE_OF_RAGE,
    MAP_HEADER_HGSS_LAKE_OF_RAGE_HIDDEN_POWER_HOUSE,
    MAP_HEADER_HGSS_LAKE_OF_RAGE_FISHING_GURU_HOUSE,
};

static BOOL InMaps(u16 mapHeaderID, const u16 *maps, int count)
{
    for (int i = 0; i < count; i++) {
        if (maps[i] == mapHeaderID) {
            return TRUE;
        }
    }

    return FALSE;
}

// HeartGold's Radio_GetAvailableChannels; Sinnoh has no signal (the owner's call: Johto's radio is Johto's and
// Kanto's)
static u8 AvailableChannels(RadioPage *page)
{
    u16 mapHeaderID = page->mapHeaderID;
    VarsFlags *varsFlags = SaveData_GetVarsFlags(page->fieldSystem->saveData);

    if (!MapHeader_IsHGSS(mapHeaderID) || !MapHeader_HasRadioSignal(mapHeaderID)) {
        return RADIO_STATION_SELECTION_NO_SIGNAL;
    }

    if (InMaps(mapHeaderID, sAlphMaps, NELEMS(sAlphMaps))) {
        return RADIO_STATION_SELECTION_ALPH;
    }

    if (MapHeader_GetRegion(mapHeaderID) == MAP_REGION_KANTO) {
        if (!VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_RESTORED_POWER)) {
            return RADIO_STATION_SELECTION_NO_SIGNAL;
        }

        return VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_GOT_EXPN_CARD) ? RADIO_STATION_SELECTION_KANTO_EXPN : RADIO_STATION_SELECTION_KANTO;
    }

    if (InMaps(mapHeaderID, sMahoganyMaps, NELEMS(sMahoganyMaps)) && !VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_ROCKET_HIDEOUT_CLEARED)) {
        return RADIO_STATION_SELECTION_MAHOGANY;
    }

    // HeartGold's Save_VarsFlags_IsInRocketTakeover: its scene var from 2 to 4
    u16 takeover = *VarsFlags_GetVarAddress(varsFlags, VAR_HGSS_SCENE_ROCKET_TAKEOVER);

    if (takeover >= 2 && takeover <= 4) {
        return RADIO_STATION_SELECTION_ROCKET;
    }

    return RADIO_STATION_SELECTION_JOHTO;
}

// HeartGold's Radio_GetTunedStationID: the station under (x, y), or NO_STATION, and its signal
static u8 TunedStation(RadioPage *page, s16 x, s16 y, u8 *signalStrength)
{
    int hitbox = TouchScreen_CheckTouchedHitTableID(sTuningHitboxes[page->selection], x, y);

    if (hitbox == TOUCHSCREEN_INPUT_NONE) {
        *signalStrength = 0;
        return NO_STATION;
    }

    *signalStrength = 2 - (hitbox % 2);

    switch (page->selection) {
    case RADIO_STATION_SELECTION_ROCKET:
        return 6;
    case RADIO_STATION_SELECTION_MAHOGANY:
        return 7;
    case RADIO_STATION_SELECTION_ALPH:
        return 5;
    default:
        return hitbox / 2;
    }
}

static void OpenStation(RadioPage *page)
{
    if (!page->stationActive) {
        RadioShow_BeginSegment(page->show, page->station, page->signalStrength != 2);
        page->stationActive = TRUE;
    }
}

static void CloseStation(RadioPage *page)
{
    if (page->stationActive) {
        RadioShow_EndSegment(page->show);
        page->stationActive = FALSE;
    }
}

// HeartGold's Radio_CoordsToStation: the cursor moved; off a station the map's music comes back (HeartGold's radio
// falls silent)
static void CoordsToStation(RadioPage *page)
{
    u8 signalStrength;
    u8 station = TunedStation(page, page->cursorX, page->cursorY, &signalStrength);

    if (station == NO_STATION) {
        if (page->station != NO_STATION) {
            CloseStation(page);
            CompleteRadio_TurnOff(page->fieldSystem);
        }

        page->signalStrength = 0;
        page->station = NO_STATION;
        return;
    }

    if (station == page->station) {
        if (signalStrength != page->signalStrength) {
            RadioShow_SetStaticLevel(page->show, signalStrength != 2);
            page->signalStrength = signalStrength;
        }

        return;
    }

    CloseStation(page);
    page->station = station;
    page->signalStrength = signalStrength;
    OpenStation(page);
}

// HeartGold's Radio_ToggleChannelSelectionButtons: a button lit, another dimmed
static void ToggleButtons(RadioPage *page, u8 on, u8 off)
{
    if (off < NO_BUTTON) {
        Bg_CopyToTilemapRect(page->bgConfig, BG_LAYER_SUB_0, sButtonTiles[off][0], sButtonTiles[off][1], BUTTON_SIZE, BUTTON_SIZE, page->screen->rawData, 0, BUTTON_SRC_ROW, page->screen->screenWidth / 8, page->screen->screenHeight / 8);
    }

    if (on < NO_BUTTON) {
        Bg_CopyToTilemapRect(page->bgConfig, BG_LAYER_SUB_0, sButtonTiles[on][0], sButtonTiles[on][1], BUTTON_SIZE, BUTTON_SIZE, page->screen->rawData, BUTTON_SIZE, BUTTON_SRC_ROW, page->screen->screenWidth / 8, page->screen->screenHeight / 8);
    }

    Bg_ScheduleTilemapTransfer(page->bgConfig, BG_LAYER_SUB_0);
}

static void MoveCursor(RadioPage *page, s16 x, s16 y)
{
    page->cursorX = x;
    page->cursorY = y;
    CompleteRadio_SetCursor(x, y);
    CoordsToStation(page);
}

// The stations where the player is, and what's on where the cursor is (a new map: what's on there)
static void Retune(RadioPage *page)
{
    CloseStation(page);
    page->mapHeaderID = page->fieldSystem->location->mapHeaderID;
    page->selection = AvailableChannels(page);
    page->show->mapHeaderID = page->mapHeaderID;
    page->show->regionNo = MapHeader_GetRegion(page->mapHeaderID) == MAP_REGION_KANTO;
    page->station = NO_STATION;
    page->signalStrength = 0;
    CoordsToStation(page);
}

RadioPage *RadioPage_New(FieldSystem *fieldSystem, BgConfig *bgConfig, enum HeapID heapID)
{
    RadioPage *page = Heap_Alloc(heapID, sizeof(RadioPage));

    MI_CpuClear8(page, sizeof(RadioPage));
    page->fieldSystem = fieldSystem;
    page->bgConfig = bgConfig;
    page->heapID = heapID;
    page->selectedButton = NO_BUTTON;
    page->station = NO_STATION;

    NARC *narc = NARC_ctor(NARC_INDEX_APPLICATION__COMPLETE__POKEGEAR, heapID);

    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, radio_NCGR, bgConfig, BG_LAYER_SUB_0, 0, 0, FALSE, heapID);
    Graphics_LoadPaletteFromOpenNARC(narc, radio_NCLR, PAL_LOAD_SUB_BG, 0, PALETTE_SIZE_BYTES * 16, heapID);
    page->screenFile = Graphics_GetScrnDataFromOpenNARC(narc, radio_NSCR, FALSE, &page->screen, heapID);
    Bg_LoadToTilemapRect(bgConfig, BG_LAYER_SUB_0, page->screen->rawData, 0, 0, 32, SCREEN_ROWS);
    NARC_dtor(narc);

    Window_Add(bgConfig, &page->title, BG_LAYER_SUB_0, WINDOW_LEFT, TITLE_TOP, WINDOW_WIDTH, 2, TEXT_PALETTE, WINDOW_TILE_START);
    Window_Add(bgConfig, &page->script, BG_LAYER_SUB_0, WINDOW_LEFT, SCRIPT_TOP, WINDOW_WIDTH, 2, TEXT_PALETTE, WINDOW_TILE_START + WINDOW_WIDTH * 2);
    Window_FillTilemap(&page->title, 0);
    Window_FillTilemap(&page->script, COLOR_STRIP);
    Window_PutToTilemap(&page->title);
    Window_PutToTilemap(&page->script);
    Window_CopyToVRAM(&page->title);
    Window_CopyToVRAM(&page->script);

    page->show = RadioShow_Create(fieldSystem->saveData, fieldSystem->location->mapHeaderID, 0, &page->script, &page->title, TEXT_COLOR(5, 6, COLOR_STRIP), heapID);

    CompleteRadio_GetCursor(&page->cursorX, &page->cursorY);

    if (page->cursorX == 0x7FFF) {
        page->cursorX = CURSOR_DEFAULT_X;
        page->cursorY = CURSOR_DEFAULT_Y;
    }

    Retune(page);
    return page;
}

void RadioPage_Free(RadioPage *page, BOOL turnOff)
{
    CloseStation(page);

    if (turnOff) {
        CompleteRadio_TurnOff(page->fieldSystem);
    }

    RadioShow_Delete(page->show);
    Window_Remove(&page->script);
    Window_Remove(&page->title);
    Heap_Free(page->screenFile);
    Heap_Free(page);

#ifdef SOVEREIGN_TEST
    gCompleteTestRadio[1] = NO_STATION;
    gCompleteTestRadio[4] = CompleteRadio_Music();
#endif
}

// HeartGold's Radio_HandleTouchInput_Internal and Radio_HandleDragCursor
static void HandleTouch(RadioPage *page)
{
    if (page->dragging) {
        if (!gSystem.touchHeld) {
            page->dragging = FALSE;
        } else if (TouchScreen_IsTouchInHitTable(&sTuningArea, gSystem.touchX, gSystem.touchY)) {
            MoveCursor(page, gSystem.touchX, gSystem.touchY);
        }

        return;
    }

    if (!gSystem.touchPressed) {
        return;
    }

    int button = TouchScreen_CheckRectanglePressed(sTuningButtons);

    if (button != TOUCHSCREEN_INPUT_NONE) {
        ToggleButtons(page, button, page->selectedButton);
        page->selectedButton = button;
        Sound_PlayEffect(SEQ_SE_DP_BUTTON9_sseq);
        MoveCursor(page, sTuningHitboxes_Johto[button * 2].circle.x, sTuningHitboxes_Johto[button * 2].circle.y);
        return;
    }

    if (!TouchScreen_IsTouchInHitTable(&sTuningArea, gSystem.touchX, gSystem.touchY)) {
        return;
    }

    TouchScreenHitTable grab = { .circle = { TOUCHSCREEN_USE_CIRCLE, page->cursorX, page->cursorY, CURSOR_GRAB } };

    if (TouchScreen_IsTouchInHitTable(&grab, gSystem.touchX, gSystem.touchY)) {
        page->dragging = TRUE;
        ToggleButtons(page, NO_BUTTON, page->selectedButton);
        page->selectedButton = NO_BUTTON;
        MoveCursor(page, gSystem.touchX, gSystem.touchY);
    }
}

static void DrawCursor(RadioPage *page)
{
    GXOamAttr oam;

    G2_SetOBJAttr(&oam, (page->cursorX - CURSOR_SIZE / 2) & 0x1FF, page->cursorY - CURSOR_SIZE / 2, 0, GX_OAM_MODE_NORMAL, FALSE, GX_OAM_EFFECT_NONE, GX_OAM_SHAPE_16x16, GX_OAM_COLORMODE_16, CURSOR_TILE, CURSOR_PALETTE, 0);
    NNS_G2dEntryOamManagerOam(RenderOam_GetScreenOam(DS_SCREEN_SUB), &oam, 1);
}

void RadioPage_Run(RadioPage *page)
{
    if (page->mapHeaderID != page->fieldSystem->location->mapHeaderID) {
        if (++page->settle >= SETTLE_FRAMES) {
            page->settle = 0;
            Retune(page);
        }
    } else {
        page->settle = 0;
    }

    HandleTouch(page);

    if (page->stationActive) {
        RadioShow_Main(page->show);
    }

    DrawCursor(page);

#ifdef SOVEREIGN_TEST
    gCompleteTestRadio[0] = page->selection;
    gCompleteTestRadio[1] = page->stationActive ? page->show->curStation : NO_STATION;
    gCompleteTestRadio[2] = (page->station << 8) | page->signalStrength;
    gCompleteTestRadio[3] = (page->cursorX & 0xFF) | (page->cursorY << 8);
    gCompleteTestRadio[4] = CompleteRadio_Music();
#endif
}
