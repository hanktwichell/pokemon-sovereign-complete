#include <nitro.h>

#include "constants/graphics.h"
#include "constants/heap.h"
#include "constants/narc.h"
#include "constants/species.h"
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
#include "string_gf.h"
#include "string_template.h"
#include "system.h"
#include "touch_pad.h"
#include "touch_screen.h"
#include "trainer_info.h"

#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0314.h"

// Sovereign Complete: HeartGold's Pokéathlon event record screen (include/complete_pokeathlon_records.h), an app of
// its overlay 99 (PokeathlonEventRecord_Init to ov99_021E9518, in assembly in pret's HeartGold), written in C on
// Platinum's libraries with its overlay 98's parts (records_common.c). The main engine is on the bottom screen: there,
// the ten events' panels (2 by 5), bright where the player holds a record better than the default one (the Johto
// starters' 100 seconds, 35 pennants and so on) and grey elsewhere, each with a ribbon for the player's record and a
// crown once it reaches its Potential Trophy; the mode's title and its button (Single or Link); the event's name and
// how often it's been joined; Return. On the top screen, the chosen event's panel and its five best results (each its
// three Pokémon's icons, hopping, the first place's faster), a "1st" ribbon when it's the player's, the points that
// record earned ("<n> Total"), and either the player's name as the record holder or what the next trophy needs; in
// Link mode, the link records and their players' names. Input: the D-pad moves the cursor (it wraps across the rows;
// up from the top row to the mode button, down from the bottom row to Return, back down or up to the column left),
// touching an event or the mode button moves it there; A or a touch on the mode button switches Single and Link;
// A on Return, B or touching Return closes the screen. Link play isn't in Complete, so its records stay empty.
// What differs from HeartGold's: the Pokémon's species keep 11 bits in the save (include/complete_pokeathlon.h).

#define HEAP_ID_EVENT_RECORD   HEAP_ID_DIPLOMA // the diploma's, as the other HeartGold screens': they can't run together
#define EVENT_RECORD_HEAP_SIZE 0x30000

#define NUM_EVENTS             COMPLETE_POKEATHLON_EVENTS
#define NUM_ENTRIES            COMPLETE_POKEATHLON_EVENT_ENTRIES
#define NUM_MONS               3
#define EVENT_COLUMNS          5
#define CURSOR_MODE            -1 // the Single/Link button
#define CURSOR_RETURN          NUM_EVENTS
#define EVENT_HURDLE_DASH      0 // its results in frames
#define EVENT_RELAY_RUN        6 // its results in 1/1024ths of a lap
#define FRAMES_PER_SECOND      30
#define PANEL_SIZE             6 // tiles
#define PANEL_TILES_ROW        60 // the panels' sheet: ten panels side by side, then the same lit
#define PANEL_TILES_LIT        360
#define LINK_NAME_LENGTH       12
#define FIRST_PLACE_ANIM_SPEED (FX32_ONE * 3 / 2)

enum {
    STATE_FADE_IN = 0,
    STATE_WAIT_FADE_IN,
    STATE_INPUT,
    STATE_WAIT_FADE_OUT,
    STATE_EXIT,
};

// The archive (tools/complete/import_hgss_pokeathlon_records.py: HeartGold's a/1/7/7, member n as member n)
enum {
    GFX_CURSOR_PLTT = 0,
    GFX_CURSOR_CHAR,
    GFX_CURSOR_CELL,
    GFX_CURSOR_ANIM,
    GFX_FIRST_PLACE_PLTT = 12,
    GFX_FIRST_PLACE_CHAR,
    GFX_FIRST_PLACE_CELL,
    GFX_FIRST_PLACE_ANIM,
    GFX_PLTT = 51, // three palettes: the panels', Single's and Link's (copied to palette 1 by mode)
    GFX_TILES,
    GFX_BOTTOM_TILEMAP,
    GFX_TOP_TILEMAP,
    GFX_PANEL_TILES,
};

enum { // the sprites, in HeartGold's order
    SPRITE_CURSOR = 0,
    SPRITE_FIRST_PLACE, // the top screen's "1st" ribbon
    SPRITE_CROWN, // ten: a Potential Trophy reached
    SPRITE_RIBBON = SPRITE_CROWN + NUM_EVENTS, // ten: the player's record
    SPRITE_ICON = SPRITE_RIBBON + NUM_EVENTS, // five places' three
    NUM_SPRITES = SPRITE_ICON + NUM_ENTRIES * NUM_MONS,
};

enum { // the cursor and marks' animations (the cursor's sheet, resource 0)
    ANIM_CROWN = 4,
    ANIM_CURSOR_EVENT = 10,
    ANIM_CURSOR_EVENT_TOUCHED,
    ANIM_CURSOR_BUTTON,
    ANIM_CURSOR_BUTTON_TOUCHED,
    ANIM_RIBBON = 16,
};

enum { // the windows (ov99_021EA45C)
    WINDOW_TITLE = 0, // "Event Record Single Mode"
    WINDOW_MODE_BUTTON, // "Link" (Single mode) or "Single"
    WINDOW_EVENT_NAME, // "Hurdle Dash", or "Please select event"
    WINDOW_TIMES_JOINED, // "Times Joined: 12"
    WINDOW_RETURN,
    WINDOW_DESCRIPTION, // the top screen's: "Three Pokémon Total Time Record", or "Event Record"
    WINDOW_GOAL, // "New Record <player>", "Surpass the no. 1 record!", "80 Sec. for a Potential Trophy", "Link Mode"
    WINDOW_RESULT, // five
    WINDOW_LINK_NAME = WINDOW_RESULT + NUM_ENTRIES, // five
    WINDOW_RECORD_POINTS = WINDOW_LINK_NAME + NUM_ENTRIES, // under the first place: "123"
    WINDOW_RECORD_POINTS_LABEL, // "Total"
    NUM_WINDOWS,
};

typedef struct EventRecordScreen {
    enum HeapID heapID;
    CompletePokeathlonSave *pokeathlon; // the save's copy (HeartGold's args point into its save)
    const TrainerInfo *trainerInfo;
    BOOL trophyGoals;
    CompletePokeathlonRecordsSolo solo[NUM_EVENTS]; // the player's, with the default record placed (ov99_021E92EC)
    BOOL noRecord[NUM_EVENTS]; // none of the player's beats the default
    String *linkName;
    BgConfig *bgConfig;
    NARC *narc;
    PokeathlonRecordsText *text;
    PokeathlonRecordsSprites *sprites;
    ManagedSprite *spriteList[NUM_SPRITES];
    s8 cursor; // 0-9 the events, 10 Return, -1 the mode button
    s8 column; // the last event's, for the cursor coming back from the buttons
    BOOL linkMode;
    BOOL switchMode;
    BOOL redraw;
    s8 shownEvent; // for tests: the event drawn, -1 none
} EventRecordScreen;

static const u8 sBgLayers[] = { // ov99_021EA59C
    BG_LAYER_MAIN_0,
    BG_LAYER_MAIN_1,
    BG_LAYER_MAIN_2,
    BG_LAYER_SUB_0,
    BG_LAYER_SUB_1,
    BG_LAYER_SUB_2,
};

// ov99_021EA4F4: on each screen the background (0), the text (1) and the event panels (2, drawn tile by tile)
static const BgTemplate sBgTemplates[] = {
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xe000, GX_BG_CHARBASE_0x00000, GX_BG_EXTPLTT_01, 3, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xf800, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xf000, GX_BG_CHARBASE_0x08000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x0000, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 3, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x0800, GX_BG_CHARBASE_0x08000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x1000, GX_BG_CHARBASE_0x0c000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
};

static const GraphicsModes sGraphicsModes = { GX_DISPMODE_GRAPHICS, GX_BGMODE_0, GX_BGMODE_0, GX_BG0_AS_2D }; // ov99_021EA374

static const WindowTemplate sWindowTemplates[NUM_WINDOWS] = { // ov99_021EA45C
    [WINDOW_TITLE] = { BG_LAYER_MAIN_1, 0, 1, 21, 2, 12, 1 },
    [WINDOW_MODE_BUTTON] = { BG_LAYER_MAIN_1, 25, 1, 6, 2, 12, 43 },
    [WINDOW_EVENT_NAME] = { BG_LAYER_MAIN_1, 0, 20, 24, 2, 12, 55 },
    [WINDOW_TIMES_JOINED] = { BG_LAYER_MAIN_1, 0, 22, 24, 2, 12, 103 },
    [WINDOW_RETURN] = { BG_LAYER_MAIN_1, 25, 21, 6, 2, 12, 151 },
    [WINDOW_DESCRIPTION] = { BG_LAYER_SUB_1, 1, 0, 26, 2, 12, 1 },
    [WINDOW_GOAL] = { BG_LAYER_SUB_1, 1, 2, 22, 2, 12, 53 },
    [WINDOW_RESULT] = { BG_LAYER_SUB_1, 16, 4, 11, 2, 12, 137 },
    [WINDOW_RESULT + 1] = { BG_LAYER_SUB_1, 17, 9, 11, 2, 12, 159 },
    [WINDOW_RESULT + 2] = { BG_LAYER_SUB_1, 18, 13, 11, 2, 12, 181 },
    [WINDOW_RESULT + 3] = { BG_LAYER_SUB_1, 19, 17, 11, 2, 12, 203 },
    [WINDOW_RESULT + 4] = { BG_LAYER_SUB_1, 20, 21, 11, 2, 12, 225 },
    [WINDOW_LINK_NAME] = { BG_LAYER_SUB_1, 16, 4, 11, 2, 12, 247 },
    [WINDOW_LINK_NAME + 1] = { BG_LAYER_SUB_1, 17, 8, 11, 2, 12, 269 },
    [WINDOW_LINK_NAME + 2] = { BG_LAYER_SUB_1, 18, 12, 11, 2, 12, 291 },
    [WINDOW_LINK_NAME + 3] = { BG_LAYER_SUB_1, 19, 16, 11, 2, 12, 313 },
    [WINDOW_LINK_NAME + 4] = { BG_LAYER_SUB_1, 20, 20, 11, 2, 12, 335 },
    [WINDOW_RECORD_POINTS] = { BG_LAYER_SUB_1, 17, 6, 3, 2, 12, 357 },
    [WINDOW_RECORD_POINTS_LABEL] = { BG_LAYER_SUB_1, 20, 6, 6, 2, 12, 363 },
};

// ov99_021EA35A: each result window's row by mode (Single, Link: the link names take a line under each)
static const u8 sResultWindowY[NUM_ENTRIES][2] = { { 4, 6 }, { 9, 10 }, { 13, 14 }, { 17, 18 }, { 21, 22 } };

static const SpriteResourceCapacities sSpriteCapacities = { 17, 3, 3, 3, 0, 0 }; // ov99_021EA3AC

// ov99_021EA3F4: the cursor, and the "1st" ribbon on the top screen
static const SpriteTemplate sButtonTemplates[] = {
    [SPRITE_CURSOR] = { 32, 72, 0, ANIM_CURSOR_EVENT, 0, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE },
    [SPRITE_FIRST_PLACE] = { 232, 48, 0, 0, 0, 0, NNS_G2D_VRAM_TYPE_2DSUB, { 1, 1, 1, 1, 0, 0 }, 0, FALSE },
};

static const int sIconResources[4] = { 2, 2, 2, 2 }; // ov99_021EA364: chars 2-16, on the top screen

// ov99_021EA3C4: the mode button, then the events (HeartGold's fifth runs 104-248, behind the third and fourth)
static const TouchScreenHitTable sHitTable[] = {
    { .rect = { 0, 32, 192, 0 } }, // its right edge 0: the screen's, as the check wraps
    { .rect = { 48, 96, 8, 56 } },
    { .rect = { 48, 96, 56, 104 } },
    { .rect = { 48, 96, 104, 152 } },
    { .rect = { 48, 96, 152, 200 } },
    { .rect = { 48, 96, 104, 248 } },
    { .rect = { 112, 160, 8, 56 } },
    { .rect = { 112, 160, 56, 104 } },
    { .rect = { 112, 160, 104, 152 } },
    { .rect = { 112, 160, 152, 200 } },
    { .rect = { 112, 160, 200, 248 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR, 0, 0, 0 } },
};

// ov99_021EA350: the default record's Pokémon, the Johto starters
static const u16 sDefaultRecordMons[NUM_MONS] = { SPECIES_CHIKORITA, SPECIES_CYNDAQUIL, SPECIES_TOTODILE };

static void MergeDefaultRecords(EventRecordScreen *app);
static void SetUpBgs(EventRecordScreen *app);
static void FreeBgs(EventRecordScreen *app);
static void LoadBgGraphics(EventRecordScreen *app);
static void MakeSprites(EventRecordScreen *app);
static void DrawTitles(EventRecordScreen *app);
static void DrawPanels(EventRecordScreen *app);
static void DrawEventPage(EventRecordScreen *app);
static void DrawEventSprites(EventRecordScreen *app);
static void ShowIcons(EventRecordScreen *app, BOOL show);
static void SwitchMode(EventRecordScreen *app);
static BOOL HandleInput(EventRecordScreen *app);
static void VBlank(void *data);

static void NoteForTests(EventRecordScreen *app)
{
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonRecordScreen[0] = 1 + COMPLETE_POKEATHLON_SCREEN_EVENT_RECORD;
    gCompleteTestPokeathlonRecordScreen[1] = 1 + app->shownEvent;
    gCompleteTestPokeathlonRecordScreen[2] = app->cursor;
    gCompleteTestPokeathlonRecordScreen[4] = app->linkMode;
#endif
}

// ov99_021E9430 and ov99_021E94FC: an event's records in the mode shown (Link's straight from the save), and how
// often it's been joined
static const CompletePokeathlonEventEntry *EventEntries(const EventRecordScreen *app, int event)
{
    GF_ASSERT(event < NUM_EVENTS);
    return app->linkMode ? app->pokeathlon->recordsLink[event].entries : app->solo[event].entries;
}

static u32 TimesJoined(const EventRecordScreen *app, int event)
{
    return app->linkMode ? app->pokeathlon->recordsLink[event].timesJoined : app->solo[event].timesJoined;
}

// ov99_021E8518: the player's best reached the event's Potential Trophy (Single mode)
static BOOL PotentialTrophyReached(const EventRecordScreen *app, int event)
{
    if (app->linkMode) {
        return FALSE;
    }

    return PokeathlonRecords_EventResultReaches(event, POKEATHLON_EVENT_GOAL_POTENTIAL_TROPHY, app->solo[event].entries[0].result);
}

// ov99_021E84EC: the best reached the goal shown (the Potential Trophy's once every record's been played)
static BOOL GoalReached(const EventRecordScreen *app, int event)
{
    return PokeathlonRecords_EventResultReaches(event, app->trophyGoals ? POKEATHLON_EVENT_GOAL_POTENTIAL_TROPHY : POKEATHLON_EVENT_GOAL_DEFAULT, EventEntries(app, event)[0].result);
}

BOOL CompletePokeathlonEventRecord_Init(ApplicationManager *appMan, int *state)
{
    CompletePokeathlonRecordArgs *args = ApplicationManager_Args(appMan);

    GF_ASSERT(args != NULL);
    Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_EVENT_RECORD, EVENT_RECORD_HEAP_SIZE);

    EventRecordScreen *app = ApplicationManager_NewData(appMan, sizeof(EventRecordScreen), HEAP_ID_EVENT_RECORD);

    MI_CpuClear8(app, sizeof(EventRecordScreen));
    app->heapID = HEAP_ID_EVENT_RECORD;
    app->pokeathlon = CompletePokeathlon_Load(args->saveData, app->heapID); // ov99_021E93DC
    app->trainerInfo = SaveData_GetTrainerInfo(args->saveData);
    app->trophyGoals = args->trophyGoals;
    app->linkName = String_Init(LINK_NAME_LENGTH + 1, app->heapID);
    app->shownEvent = -1;
    MergeDefaultRecords(app);
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonEventRecords = app->pokeathlon->recordsSolo;
    gCompleteTestPokeathlonRecordScreen[3] = 0;
#endif

    PokeathlonRecords_SetUpScreens();
    SetUpBgs(app);
    LoadBgGraphics(app);
    app->text = PokeathlonRecords_NewText(app->heapID, app->bgConfig, NUM_WINDOWS, sWindowTemplates, TEXT_BANK_HGSS_MSG_0314);
    PokeathlonRecords_PrintMessageInFont(app->text, WINDOW_RETURN, msg_0314_00000, TRUE, 0, FONT_SUBSCREEN); // ov99_021E88D4
    DrawEventPage(app);
    MakeSprites(app);
    DrawTitles(app); // ov99_021E8818
    DrawPanels(app);
    EnableTouchPad();
    InitializeTouchPad(4);
    ResetVisibleHardwareWindows(DS_SCREEN_MAIN);
    ResetVisibleHardwareWindows(DS_SCREEN_SUB);
    SetVBlankCallback(VBlank, app);
    NoteForTests(app);
    return TRUE;
}

BOOL CompletePokeathlonEventRecord_Main(ApplicationManager *appMan, int *state)
{
    EventRecordScreen *app = ApplicationManager_Data(appMan);

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
        if (gCompleteTestPokeathlonRecordScreen[3] != 0) { // a test filled the records: reread them, draw again
            gCompleteTestPokeathlonRecordScreen[3] = 0;
            MergeDefaultRecords(app);
            DrawPanels(app);

            if (app->shownEvent >= 0 && app->cursor == app->shownEvent) {
                ShowIcons(app, FALSE);
                app->redraw = TRUE;
            }
        }
#endif
        if (app->switchMode) {
            app->linkMode ^= TRUE;
            SwitchMode(app);
        }

        if (app->redraw) {
            DrawEventPage(app);
            DrawEventSprites(app);
            app->redraw = FALSE;
        }

        if (PokeathlonRecords_ReturnPressed() || HandleInput(app)) {
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

BOOL CompletePokeathlonEventRecord_Exit(ApplicationManager *appMan, int *state)
{
    EventRecordScreen *app = ApplicationManager_Data(appMan);

    DisableTouchPad();
    String_Free(app->linkName); // ov99_021E9418
    PokeathlonRecords_FreeSprites(app->sprites, app->spriteList, NUM_SPRITES);
    PokeathlonRecords_FreeText(app->text);
    FreeBgs(app);
    PokeathlonRecords_EndScreens();
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonRecordScreen[0] = 0;
    gCompleteTestPokeathlonEventRecords = NULL;
#endif
    Heap_Free(app->pokeathlon);
    ApplicationManager_FreeData(appMan);
    Heap_Destroy(HEAP_ID_EVENT_RECORD);
    return TRUE;
}

// ov99_021E92EC: each event's Single records as the screen lists them: the player's that beat the default record,
// then the default (the Johto starters'), then the rest of the player's, five in all
static void MergeDefaultRecords(EventRecordScreen *app)
{
    for (int event = 0; event < NUM_EVENTS; event++) {
        const CompletePokeathlonEventEntry *saved = app->pokeathlon->recordsSolo[event].entries;
        CompletePokeathlonEventEntry *entries = app->solo[event].entries;
        int better = 0;

        app->solo[event] = app->pokeathlon->recordsSolo[event];

        while (better < NUM_ENTRIES && PokeathlonRecords_EventResultBeats(event, POKEATHLON_EVENT_GOAL_DEFAULT, saved[better].result)) {
            better++;
        }

        app->noRecord[event] = better == 0;

        for (int i = better; i < NUM_ENTRIES; i++) {
            if (i == better) {
                entries[i].result = PokeathlonRecords_EventGoal(event, POKEATHLON_EVENT_GOAL_DEFAULT);

                for (int k = 0; k < NUM_MONS; k++) {
                    entries[i].mons[k].species = sDefaultRecordMons[k];
                    entries[i].mons[k].form = 0;
                }
            } else {
                entries[i] = saved[i - 1];
            }
        }
    }
}

// ov99_021E8590
static void SetUpBgs(EventRecordScreen *app)
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

// ov99_021E875C
static void FreeBgs(EventRecordScreen *app)
{
    NARC_dtor(app->narc);

    for (int i = 0; i < NELEMS(sBgLayers); i++) {
        Bg_FreeTilemapBuffer(app->bgConfig, sBgLayers[i]);
    }

    Heap_Free(app->bgConfig);
}

// ov99_021E860C: the same background on both screens; the panels' tiles from tile 1, put on the maps as drawn
static void LoadBgGraphics(EventRecordScreen *app)
{
    NARC *narc = app->narc;
    BgConfig *bgConfig = app->bgConfig;

    Graphics_LoadPaletteFromOpenNARC(narc, GFX_PLTT, PAL_LOAD_MAIN_BG, 0, 0, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_TILES, bgConfig, BG_LAYER_MAIN_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_BOTTOM_TILEMAP, bgConfig, BG_LAYER_MAIN_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_PANEL_TILES, bgConfig, BG_LAYER_MAIN_2, 1, 0, TRUE, app->heapID);
    Graphics_LoadPaletteFromOpenNARC(narc, GFX_PLTT, PAL_LOAD_SUB_BG, 0, 0, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_TILES, bgConfig, BG_LAYER_SUB_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_TOP_TILEMAP, bgConfig, BG_LAYER_SUB_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_PANEL_TILES, bgConfig, BG_LAYER_SUB_2, 1, 0, TRUE, app->heapID);
}

// ov99_021E87D0: the mode's colour (Single's or Link's palette) into palette 1 on both screens
static void LoadModePalette(EventRecordScreen *app)
{
    u32 source = PLTT_OFFSET(app->linkMode ? 2 : 1);

    Graphics_LoadPaletteWithSrcOffsetFromOpenNARC(app->narc, GFX_PLTT, PAL_LOAD_MAIN_BG, source, PLTT_OFFSET(1), PALETTE_SIZE_BYTES, app->heapID);
    Graphics_LoadPaletteWithSrcOffsetFromOpenNARC(app->narc, GFX_PLTT, PAL_LOAD_SUB_BG, source, PLTT_OFFSET(1), PALETTE_SIZE_BYTES, app->heapID);
}

// ov99_021E86D4: an event's 6x6-tile panel (grey, or lit) at a tile position on either screen's panel layer
static void DrawEventPanel(EventRecordScreen *app, int event, u8 x, u8 y, BOOL lit, BOOL topScreen)
{
    u8 layer = topScreen ? BG_LAYER_SUB_2 : BG_LAYER_MAIN_2;

    for (int row = 0; row < PANEL_SIZE; row++) {
        for (int col = 0; col < PANEL_SIZE; col++) {
            u16 tile = (lit ? PANEL_TILES_LIT : 0) + row * PANEL_TILES_ROW + event * PANEL_SIZE + col + 1;

            Bg_LoadToTilemapRect(app->bgConfig, layer, &tile, x + col, y + row, 1, 1);
        }
    }

    Bg_CopyTilemapBufferToVRAM(app->bgConfig, layer);
}

// ov99_021E8C88, ov99_021E8D5C, ov99_021E8D88 and ov99_021E8EBC: the cursor and marks (resource 0), the "1st" ribbon
// (1, on the top screen) and the 15 icons there (chars 2-16, the rest 2); each event's ribbon and crown
static void MakeSprites(EventRecordScreen *app)
{
    SpriteSystem *spriteSys;
    SpriteManager *spriteMan;
    SpriteTemplate template;

    app->sprites = PokeathlonRecords_NewSprites(app->heapID, &sSpriteCapacities, NUM_SPRITES);
    spriteSys = app->sprites->spriteSystem;
    spriteMan = app->sprites->spriteManager;

    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CURSOR_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CURSOR_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CURSOR_CELL, TRUE, 0);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_CURSOR_ANIM, TRUE, 0);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_FIRST_PLACE_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DSUB, 1);
    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_FIRST_PLACE_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DSUB, 1);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_FIRST_PLACE_CELL, TRUE, 1);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, app->narc, GFX_FIRST_PLACE_ANIM, TRUE, 1);
    PokeathlonRecords_LoadIconResources(app->sprites, sIconResources, NUM_ENTRIES * NUM_MONS, NNS_G2D_VRAM_TYPE_2DSUB, TRUE);

    for (int i = 0; i < NELEMS(sButtonTemplates); i++) {
        app->spriteList[i] = PokeathlonRecords_NewSprite(app->sprites, &sButtonTemplates[i]);
        ManagedSprite_SetAnimateFlag(app->spriteList[i], TRUE);
    }

    MI_CpuClear8(&template, sizeof(SpriteTemplate));
    template.vramType = NNS_G2D_VRAM_TYPE_2DMAIN;

    for (int event = 0; event < NUM_EVENTS; event++) { // drawn as the panels are (DrawPanels)
        template.x = 32 + 48 * (event % EVENT_COLUMNS);
        template.y = 72 + 64 * (event / EVENT_COLUMNS);
        template.priority = 0;
        template.animIdx = ANIM_RIBBON;
        app->spriteList[SPRITE_RIBBON + event] = PokeathlonRecords_NewSprite(app->sprites, &template);
        template.priority = 1;
        template.animIdx = ANIM_CROWN;
        app->spriteList[SPRITE_CROWN + event] = PokeathlonRecords_NewSprite(app->sprites, &template);
        ManagedSprite_SetAnimateFlag(app->spriteList[SPRITE_CROWN + event], TRUE);
    }

    MI_CpuClear8(&template, sizeof(SpriteTemplate));
    template.vramType = NNS_G2D_VRAM_TYPE_2DSUB;
    template.resources[1] = sIconResources[1];
    template.resources[2] = sIconResources[2];
    template.resources[3] = sIconResources[3];

    for (int place = 0; place < NUM_ENTRIES; place++) { // each place's three, stepped as the places' bars are
        for (int k = 0; k < NUM_MONS; k++) {
            int icon = place * NUM_MONS + k;

            template.x = 60 + 24 * k + 8 * place;
            template.y = 44 + 32 * place;
            template.priority = NUM_MONS - k;
            template.resources[0] = sIconResources[0] + icon;
            app->spriteList[SPRITE_ICON + icon] = PokeathlonRecords_NewSprite(app->sprites, &template);
            ManagedSprite_SetAnimateFlag(app->spriteList[SPRITE_ICON + icon], TRUE);
        }
    }

    DrawEventSprites(app);
}

// ov99_021E89A4: the mode's title and its button's label (the other mode's name)
static void DrawTitles(EventRecordScreen *app)
{
    PokeathlonRecords_PrintMessageAt(app->text, WINDOW_TITLE, app->linkMode ? msg_0314_00056 : msg_0314_00055, 1, 0);
    PokeathlonRecords_PrintMessageInFont(app->text, WINDOW_MODE_BUTTON, app->linkMode ? msg_0314_00111 : msg_0314_00110, TRUE, 0, FONT_SUBSCREEN);
}

// ov99_021E9038: the ten panels, lit where the player holds a record (all in Link mode), with their ribbons (Single
// mode) and crowns
static void DrawPanels(EventRecordScreen *app)
{
    for (int event = 0; event < NUM_EVENTS; event++) {
        BOOL lit = app->linkMode || !app->noRecord[event];

        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_RIBBON + event], !app->linkMode && lit);
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_CROWN + event], PotentialTrophyReached(app, event));
        DrawEventPanel(app, event, 1 + PANEL_SIZE * (event % EVENT_COLUMNS), 6 + 8 * (event / EVENT_COLUMNS), lit, FALSE);
    }
}

// ov99_021E88EC: a result in its event's unit (seconds and tenths, laps and tenths, or a count)
static void PrintResult(EventRecordScreen *app, u16 result, int window, u32 y)
{
    StringTemplate *template = app->text->template;

    GF_ASSERT(result != COMPLETE_POKEATHLON_NO_RESULT);

    switch (app->cursor) {
    case EVENT_HURDLE_DASH:
        StringTemplate_SetNumber(template, 0, result / FRAMES_PER_SECOND, 3, PADDING_MODE_SPACES, CHARSET_MODE_EN);
        StringTemplate_SetNumber(template, 1, result % FRAMES_PER_SECOND * 10 / FRAMES_PER_SECOND, 1, PADDING_MODE_SPACES, CHARSET_MODE_EN);
        break;
    case EVENT_RELAY_RUN:
        StringTemplate_SetNumber(template, 0, result >> 10, 3, PADDING_MODE_SPACES, CHARSET_MODE_EN);
        StringTemplate_SetNumber(template, 1, ((result & 0x3FF) * 10) >> 10, 1, PADDING_MODE_SPACES, CHARSET_MODE_EN);
        break;
    default:
        StringTemplate_SetNumber(template, 0, result, 3, PADDING_MODE_SPACES, CHARSET_MODE_EN);
        break;
    }

    PokeathlonRecords_PrintMessageAt(app->text, window, msg_0314_00086 + app->cursor, 0, y);
}

// ov99_021E9020
static void ClearLinkNames(EventRecordScreen *app)
{
    for (int i = 0; i < NUM_ENTRIES; i++) {
        PokeathlonRecords_ClearWindow(app->text, WINDOW_LINK_NAME + i);
    }
}

// ov99_021E9518: a link record's player (HeartGold's names, 12 characters, 0x18 bytes apart from 0x30 in the event's
// link records; never there in Complete, which has no link play)
static const String *LinkName(EventRecordScreen *app, int event, int place)
{
    const u8 *names = (const u8 *)&app->pokeathlon->recordsLink[event] + 0x30;

    String_CopyNumChars(app->linkName, (const charcode_t *)(names + 0x18 * place), LINK_NAME_LENGTH);
    return app->linkName;
}

// ov99_021E89EC and ov99_021E8788: the chosen event: its name and how often it's been joined (bottom screen); its
// panel, description, five results and the line above them (top screen)
static void DrawEventPage(EventRecordScreen *app)
{
    PokeathlonRecordsText *text = app->text;
    int event = app->cursor;
    const CompletePokeathlonEventEntry *entries = EventEntries(app, event);

    PokeathlonRecords_SetEventName(text->template, 0, event);
    PokeathlonRecords_PrintMessageAt(text, WINDOW_EVENT_NAME, msg_0314_00062, 1, 1);
    PokeathlonRecords_PrintMessageInFont(text, WINDOW_DESCRIPTION, msg_0314_00065 + event, FALSE, 1, FONT_SYSTEM);
    StringTemplate_SetNumber(text->template, 0, TimesJoined(app, event), 7, PADDING_MODE_SPACES, CHARSET_MODE_EN);
    PokeathlonRecords_PrintMessageAt(text, WINDOW_TIMES_JOINED, msg_0314_00054, 1, 0);

    for (int i = 0; i < NUM_ENTRIES; i++) {
        u32 y = i == 0 && !app->linkMode ? 1 : 0; // the first place's bar, a pixel lower

        if (entries[i].result != COMPLETE_POKEATHLON_NO_RESULT) {
            PrintResult(app, entries[i].result, WINDOW_RESULT + i, y);
        } else {
            PokeathlonRecords_PrintMessageInFont(text, WINDOW_RESULT + i, msg_0314_00096 + event, FALSE, y, FONT_SYSTEM);
        }
    }

    app->shownEvent = event;
    DrawEventPanel(app, event, 26, 0, app->linkMode || !app->noRecord[event], TRUE);

    if (app->linkMode) {
        PokeathlonRecords_PrintMessage(text, WINDOW_GOAL, msg_0314_00075, FALSE);
        ClearLinkNames(app);

        for (int i = 0; i < NUM_ENTRIES; i++) {
            if (entries[i].result != COMPLETE_POKEATHLON_NO_RESULT) {
                PokeathlonRecords_PrintStringAt(text, WINDOW_LINK_NAME + i, LinkName(app, event, i), 0, 1);
            }
        }

        NoteForTests(app);
        return;
    }

    if (app->noRecord[event]) {
        PokeathlonRecords_ClearWindow(text, WINDOW_RECORD_POINTS);
        PokeathlonRecords_ClearWindow(text, WINDOW_RECORD_POINTS_LABEL);
    } else {
        PokeathlonRecords_PrintNumberMessage(text, WINDOW_RECORD_POINTS, msg_0314_00107, app->pokeathlon->recordPoints[event], 3, 0);
        PokeathlonRecords_PrintMessage(text, WINDOW_RECORD_POINTS_LABEL, msg_0314_00106, FALSE);
    }

    if (app->trophyGoals ? GoalReached(app, event) : !app->noRecord[event]) {
        StringTemplate_SetPlayerName(text->template, 0, app->trainerInfo);
        PokeathlonRecords_PrintMessage(text, WINDOW_GOAL, msg_0314_00108, FALSE); // "New Record <player>"
    } else if (app->trophyGoals) {
        PokeathlonRecords_PrintMessage(text, WINDOW_GOAL, msg_0314_00076 + event, FALSE); // "80 Sec. for a Potential Trophy"
    } else {
        PokeathlonRecords_PrintMessage(text, WINDOW_GOAL, msg_0314_00109, FALSE); // "Surpass the no. 1 record!"
    }

    NoteForTests(app);
}

// ov99_021E8FEC
static void ShowIcons(EventRecordScreen *app, BOOL show)
{
    for (int i = 0; i < NUM_ENTRIES * NUM_MONS; i++) {
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_ICON + i], show);
    }
}

// ov99_021E8F50 and ov99_021E8C50: each result's three icons (the first place's hopping faster), and the "1st" ribbon
// where the first is the player's (Single mode)
static void DrawEventSprites(EventRecordScreen *app)
{
    const CompletePokeathlonEventEntry *entries = EventEntries(app, app->cursor);

    for (int i = 0; i < NUM_ENTRIES; i++) {
        if (entries[i].result == COMPLETE_POKEATHLON_NO_RESULT) {
            continue;
        }

        for (int k = 0; k < NUM_MONS; k++) {
            CompletePokeathlonRecordMon mon;
            ManagedSprite *icon = app->spriteList[SPRITE_ICON + i * NUM_MONS + k];

            MI_CpuClear8(&mon, sizeof(CompletePokeathlonRecordMon));
            mon.species = entries[i].mons[k].species;
            mon.form = entries[i].mons[k].form;

            if (mon.species == SPECIES_NONE) {
                continue;
            }

            PokeathlonRecords_DrawIcon(app->sprites, icon, &mon, TRUE);
            ManagedSprite_SetDrawFlag(icon, TRUE);

            if (i == 0) {
                ManagedSprite_SetAnimationSpeed(icon, FIRST_PLACE_ANIM_SPEED);
            }
        }
    }

    ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_FIRST_PLACE], !app->linkMode && !app->noRecord[app->cursor]);
}

// ov99_021E8828: the other mode: its title, button, colour and panels; the result windows moved to its rows; the top
// screen cleared and "Please select event"
static void SwitchMode(EventRecordScreen *app)
{
    PokeathlonRecordsText *text = app->text;

    DrawTitles(app);
    DrawPanels(app);
    LoadModePalette(app);

    for (int i = 0; i < NUM_ENTRIES; i++) {
        PokeathlonRecords_ClearWindow(text, WINDOW_RESULT + i);
        Window_ClearAndScheduleCopyToVRAM(&text->windows[WINDOW_RESULT + i]);
        Window_SetYPos(&text->windows[WINDOW_RESULT + i], sResultWindowY[i][app->linkMode]);
    }

    ShowIcons(app, FALSE);
    Bg_ClearTilemap(app->bgConfig, BG_LAYER_SUB_2);
    ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_FIRST_PLACE], FALSE);
    PokeathlonRecords_ClearWindow(text, WINDOW_TIMES_JOINED);
    PokeathlonRecords_ClearWindow(text, WINDOW_GOAL);
    PokeathlonRecords_ClearWindow(text, WINDOW_RECORD_POINTS);
    PokeathlonRecords_ClearWindow(text, WINDOW_RECORD_POINTS_LABEL);
    ClearLinkNames(app);
    PokeathlonRecords_PrintMessageAt(text, WINDOW_EVENT_NAME, msg_0314_00063, 1, 1);
    PokeathlonRecords_PrintMessageAt(text, WINDOW_DESCRIPTION, msg_0314_00064, 0, 1);
    app->switchMode = FALSE;
    app->shownEvent = -1;
    NoteForTests(app);
}

// ov99_021E90F4: TRUE to leave (A on Return). A touch moves the cursor to an event or the mode button (switching
// modes); the D-pad's held keys repeat. A new event is drawn the next frame.
static BOOL HandleInput(EventRecordScreen *app)
{
    s8 previous = app->cursor;
    ManagedSprite *cursor = app->spriteList[SPRITE_CURSOR];

    if (TouchScreen_Tapped()) {
        int touched = TouchScreen_CheckPressedHitTableID(sHitTable);

        if (touched != TOUCHSCREEN_INPUT_NONE) {
            app->cursor = touched - 1;
            ManagedSprite_SetAnim(cursor, ANIM_CURSOR_EVENT_TOUCHED);
            Sound_PlayEffect(SE_CONFIRM_sseq_3);

            if (app->cursor == CURSOR_MODE) {
                app->switchMode = TRUE;
                ManagedSprite_SetAnim(cursor, ANIM_CURSOR_BUTTON_TOUCHED);
                Sound_PlayEffect(SE_CONFIRM_sseq_3);
            }

            ManagedSprite_SetAnimateFlag(cursor, TRUE);
        }
    } else {
        u32 keys = gSystem.pressedKeysRepeatableRaw; // HeartGold's newAndRepeatedKeysRaw

        if (JOY_NEW(PAD_BUTTON_A)) {
            if (previous == CURSOR_RETURN) {
                return TRUE;
            }

            if (previous == CURSOR_MODE) {
                app->switchMode = TRUE;
                Sound_PlayEffect(SE_CONFIRM_sseq_3);
            }
        }

        if (app->cursor == CURSOR_MODE) {
            if (keys & PAD_KEY_DOWN) {
                app->cursor = app->column;
            }
        } else if (app->cursor == CURSOR_RETURN) {
            if (keys & PAD_KEY_UP) {
                app->cursor = app->column + EVENT_COLUMNS;
            }
        } else {
            if (keys & PAD_KEY_RIGHT) {
                app->cursor++;
            } else if (keys & PAD_KEY_LEFT) {
                app->cursor--;
            } else if (keys & PAD_KEY_DOWN) {
                app->cursor += EVENT_COLUMNS;
            } else if (keys & PAD_KEY_UP) {
                app->cursor -= EVENT_COLUMNS;
            }

            if (app->cursor > CURSOR_RETURN) {
                app->cursor = CURSOR_RETURN;
            } else if (app->cursor < CURSOR_MODE) {
                app->cursor = CURSOR_MODE;
            }

            if (app->cursor != CURSOR_MODE && app->cursor != CURSOR_RETURN) {
                app->column = app->cursor % EVENT_COLUMNS;
            }
        }
    }

    if (app->cursor == previous) {
        return FALSE;
    }

    Sound_PlayEffect(SE_CONFIRM_sseq_3);

    if (app->cursor == CURSOR_MODE) {
        ManagedSprite_SetPositionXY(cursor, 224, 16);
        ManagedSprite_SetAnim(cursor, ANIM_CURSOR_BUTTON);
    } else if (app->cursor == CURSOR_RETURN) {
        ManagedSprite_SetPositionXY(cursor, 224, 176);
        ManagedSprite_SetAnim(cursor, ANIM_CURSOR_BUTTON);
    } else {
        ManagedSprite_SetPositionXY(cursor, 32 + 48 * (app->cursor % EVENT_COLUMNS), 72 + 64 * (app->cursor / EVENT_COLUMNS));

        if (ManagedSprite_GetActiveAnim(cursor) != ANIM_CURSOR_EVENT_TOUCHED) {
            ManagedSprite_SetAnim(cursor, ANIM_CURSOR_EVENT);
        }

        if (!(previous == CURSOR_RETURN && app->cursor == CURSOR_RETURN - 1)) { // HeartGold's: back up to the last event
            ShowIcons(app, FALSE);
            app->redraw = TRUE;
        }
    }

    NoteForTests(app);
    return FALSE;
}

// ov99_021E856C
static void VBlank(void *data)
{
    EventRecordScreen *app = data;

    SpriteSystem_TransferOam();
    Bg_RunScheduledUpdates(app->bgConfig);
    OS_SetIrqCheckFlag(OS_IE_V_BLANK);
}
