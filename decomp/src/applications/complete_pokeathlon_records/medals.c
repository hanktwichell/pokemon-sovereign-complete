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
#include "grid_menu_cursor_position.h"
#include "gx_layers.h"
#include "heap.h"
#include "narc.h"
#include "overlay_manager.h"
#include "pokedex.h"
#include "pokemon.h"
#include "screen_fade.h"
#include "sound_playback.h"
#include "sprite.h"
#include "sprite_system.h"
#include "string_template.h"
#include "system.h"
#include "touch_pad.h"
#include "touch_screen.h"

#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0314.h"

// Sovereign Complete: HeartGold's Pokéathlon medals screen (include/complete_pokeathlon_records.h), an app of its
// overlay 99 (PokeathlonMedals_Init to ov99_021E82E4, with ov99_021E714C to ov99_021E77D8, in assembly in pret's
// HeartGold), written in C on Platinum's libraries with its overlay 98's parts (records_common.c). The main engine is
// on the bottom screen: there, the Pokémon with a medal, 30 a page (6 by 5) as icons in National Dex order, a gold mark
// on each with all five medals ("medalists"); the page's number and arrows; the number of medalists and, once every
// record's been played, what the next Trust Trophy needs; ten crowns, lit for the Trust Trophies earned; Return. On the
// top screen, the Pokémon under the cursor (its picture in the form, gender and Spinda spots the Pokédex last saw, its
// name), its five medals by the medals' names, and a "Medalist Pokémon" banner when it has all five. Input: the D-pad
// moves the cursor over the grid (held, it repeats; down from the bottom row to Return, and up from Return back where it
// came from), LEFT on the first column or RIGHT on the last turns the page (the page slides across), as does touching an
// arrow; touching a Pokémon moves the cursor to it; A on Return, B or touching Return closes the screen.
// HeartGold lists its 493 species (its Pokédex archive's National Dex list); here every species of Complete's (from
// 1 to NATIONAL_DEX_COUNT, the same order), so the counts and pages are wider than HeartGold's bitfields. What differs
// besides: the Pokémon's picture is Complete's 96x96; with no medals at all the page is empty (HeartGold's draws 30
// empty slots as species 0), and an empty slot under the cursor shows no medals (HeartGold reads the byte before the
// first species' there). HeartGold's grid input handler (its unk_02019BA4.c) is written into this screen: its touch
// mode switch and disabled buttons, which this screen never uses, are left out.

#define HEAP_ID_MEDALS    HEAP_ID_DIPLOMA // the diploma's, as the other HeartGold screens': they can't run together
#define MEDALS_HEAP_SIZE  0x30000

#define NUM_MEDALS         COMPLETE_POKEATHLON_COURSES
#define ICON_COLUMNS       6
#define ICON_ROWS          5
#define ICONS_PER_PAGE     (ICON_COLUMNS * ICON_ROWS)
#define GRID_RETURN        ICONS_PER_PAGE // the grid's last place: Return
#define NUM_CROWNS         10
#define PAGE_TURN_FRAMES   8
#define PAGE_TURN_STEP     64
#define GRID_NONE          0xFF
#define GRID_FORCED        0x80 // a place's neighbour flagged so: back where the cursor came from (Return's up)

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
    GFX_MEDALS_PLTT,
    GFX_MEDALS_CHAR,
    GFX_MEDALS_CELL,
    GFX_MEDALS_ANIM,
    GFX_ARROWS_PLTT = 24,
    GFX_ARROWS_CHAR,
    GFX_ARROWS_CELL,
    GFX_ARROWS_ANIM,
    GFX_BOTTOM_PLTT = 42,
    GFX_TOP_PLTT,
    GFX_BOTTOM_TILES,
    GFX_TOP_TILES,
    GFX_BOTTOM_TILEMAP,
    GFX_GRID_TILEMAP,
    GFX_MEDALIST_MARK_TILES,
    GFX_TOP_TILEMAP,
    GFX_BANNER_TILEMAP,
};

// The sprites, in HeartGold's order (its fifth unused)
enum {
    SPRITE_CURSOR = 0,
    SPRITE_PREV_PAGE,
    SPRITE_NEXT_PAGE,
    SPRITE_MON_PIC, // the top screen's
    SPRITE_CROWN = 5, // ten: the Trust Trophies
    SPRITE_MEDAL = SPRITE_CROWN + NUM_CROWNS, // five: the chosen Pokémon's, on the top screen
    SPRITE_ICON = SPRITE_MEDAL + NUM_MEDALS, // the page's 30
    NUM_SPRITES = SPRITE_ICON + ICONS_PER_PAGE,
};

enum { // the cursor's animations (the cursor and crowns' sheet, HeartGold's resource 2 here)
    ANIM_CURSOR_RETURN = 12, // and 13 touched
    ANIM_CURSOR_ICON = 14, // and 15 touched
};

enum { // the windows (ov99_021E9FDC)
    WINDOW_TITLE = 0, // "Pokémon Record"
    WINDOW_MEDALISTS, // "Medalist Pokémon: 3"
    WINDOW_TROPHY_GOAL, // "Next Trust Trophy: Five Medalists"
    WINDOW_PAGE, // "1/2"
    WINDOW_RETURN,
    WINDOW_SPECIES, // the top screen's: "Pikachu’s Medals"
    WINDOW_MEDAL_NAME, // five
    WINDOW_MEDALIST = WINDOW_MEDAL_NAME + NUM_MEDALS, // on the banner: "Medalist Pokémon"
    NUM_WINDOWS,
};

typedef struct MedalsScreen {
    enum HeapID heapID;
    CompletePokeathlonSave *pokeathlon; // the save's copy (HeartGold's args point into its save)
    const u8 *medals; // [species - 1], a bit a course
    Pokedex *pokedex;
    BOOL trophyGoals;
    BgConfig *bgConfig;
    NARC *narc;
    u16 species[NATIONAL_DEX_COUNT]; // those with a medal, in National Dex order
    int numSpecies;
    int lastPage;
    int page;
    u8 place; // the grid's: 0-29 the page's Pokémon, 30 Return (HeartGold's handler's next input)
    u8 previousPlace;
    u8 forcedFrom; // where the cursor came from, for a move back (HeartGold's handler's unk_0F)
    BOOL slideRight; // the turning page slides right (an earlier page)
    BOOL turning;
    BOOL redrawChosen;
    u8 turnFrame;
    PokeathlonRecordsText *text;
    PokeathlonRecordsSprites *sprites;
    ManagedSprite *spriteList[NUM_SPRITES];
} MedalsScreen;

static const u8 sBgLayers[] = { // ov99_021EA348
    BG_LAYER_MAIN_0,
    BG_LAYER_MAIN_1,
    BG_LAYER_MAIN_2,
    BG_LAYER_MAIN_3,
    BG_LAYER_SUB_0,
    BG_LAYER_SUB_1,
    BG_LAYER_SUB_2,
};

// ov99_021EA0BC: on the bottom screen, the background (0), the text (1), the grid's panel (2) and the medalists' marks
// (3), both two screens wide, to slide; on top, the background (0), the text (1) and the medalist's banner (2)
static const BgTemplate sBgTemplates[] = {
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x0000, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 3, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x0800, GX_BG_CHARBASE_0x0c000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
    { 0, 0, 0x1000, 0, BG_SCREEN_SIZE_512x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x1000, GX_BG_CHARBASE_0x14000, GX_BG_EXTPLTT_01, 2, 0, FALSE },
    { 0, 0, 0x1000, 0, BG_SCREEN_SIZE_512x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x2000, GX_BG_CHARBASE_0x18000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xf800, GX_BG_CHARBASE_0x00000, GX_BG_EXTPLTT_01, 3, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xf000, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xd800, GX_BG_CHARBASE_0x08000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
};

static const GraphicsModes sGraphicsModes = { GX_DISPMODE_GRAPHICS, GX_BGMODE_0, GX_BGMODE_0, GX_BG0_AS_2D }; // ov99_021E9F80

static const WindowTemplate sWindowTemplates[NUM_WINDOWS] = { // ov99_021E9FDC
    [WINDOW_TITLE] = { BG_LAYER_MAIN_1, 0, 0, 12, 2, 12, 1 },
    [WINDOW_MEDALISTS] = { BG_LAYER_MAIN_1, 0, 20, 18, 2, 12, 25 },
    [WINDOW_TROPHY_GOAL] = { BG_LAYER_MAIN_1, 0, 22, 24, 2, 12, 61 },
    [WINDOW_PAGE] = { BG_LAYER_MAIN_1, 15, 0, 5, 2, 12, 109 },
    [WINDOW_RETURN] = { BG_LAYER_MAIN_1, 25, 21, 6, 2, 12, 119 },
    [WINDOW_SPECIES] = { BG_LAYER_SUB_1, 7, 1, 20, 2, 12, 1 },
    [WINDOW_MEDAL_NAME] = { BG_LAYER_SUB_1, 15, 5, 11, 2, 12, 41 },
    [WINDOW_MEDAL_NAME + 1] = { BG_LAYER_SUB_1, 17, 9, 11, 2, 12, 63 },
    [WINDOW_MEDAL_NAME + 2] = { BG_LAYER_SUB_1, 18, 13, 11, 2, 12, 85 },
    [WINDOW_MEDAL_NAME + 3] = { BG_LAYER_SUB_1, 17, 17, 11, 2, 12, 107 },
    [WINDOW_MEDAL_NAME + 4] = { BG_LAYER_SUB_1, 15, 21, 11, 2, 12, 129 },
    [WINDOW_MEDALIST] = { BG_LAYER_SUB_2, 2, 18, 8, 4, 1, 512 }, // in the banner's own palette
};

static const SpriteResourceCapacities sSpriteCapacities = { 34, 5, 5, 5, 0, 0 }; // ov99_021E9FC4

// ov99_021EA180: the cursor, the page arrows (the arrows' resource 0) and the chosen Pokémon's picture
static const SpriteTemplate sButtonTemplates[] = {
    [SPRITE_CURSOR] = { 48, 36, 0, ANIM_CURSOR_ICON, 0, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 1, 2, 2, 2, 0, 0 }, 0, FALSE },
    [SPRITE_PREV_PAGE] = { 16, 84, 0, 0, 0, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE },
    [SPRITE_NEXT_PAGE] = { 240, 84, 0, 1, 0, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE },
    [SPRITE_MON_PIC] = { 48, 112, 0, 0, 0, 0, NNS_G2D_VRAM_TYPE_2DSUB, { 33, 4, 4, 4, 0, 0 }, 1, FALSE },
};

// ov99_021E810C (ov99_021E9FB0): the five medals by their names, on the top screen
static const struct {
    s16 x;
    s16 y;
} sMedalPositions[NUM_MEDALS] = {
    { 104, 48 },
    { 120, 80 },
    { 128, 112 },
    { 120, 144 },
    { 104, 176 },
};

// ov99_021E9F60, ov99_021E9F70, ov99_021E9F90: the crowns' resources (the cursor's sheet), the picture's and the
// icons' (chars from 2 on)
static const int sCrownResources[4] = { 1, 2, 2, 2 };
static const int sMonPicResources[4] = { 33, 4, 4, 4 };
static const int sIconResources[4] = { 2, 1, 1, 1 };

// ov99_021E9F54: the page arrows
static const TouchScreenHitTable sArrowHitTable[] = {
    { .rect = { 68, 99, 0, 31 } },
    { .rect = { 68, 99, 224, 255 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR, 0, 0, 0 } },
};

// ov99_021EA03C: the grid's places, the page's Pokémon then Return
#define GRID_CELL(row, col) { .rect = { 28 + 24 * (row), 51 + 24 * (row), 32 + 32 * (col), 63 + 32 * (col) } }
#define GRID_ROW(row)       GRID_CELL(row, 0), GRID_CELL(row, 1), GRID_CELL(row, 2), GRID_CELL(row, 3), GRID_CELL(row, 4), GRID_CELL(row, 5)

static const TouchScreenHitTable sGridHitTable[] = {
    GRID_ROW(0),
    GRID_ROW(1),
    GRID_ROW(2),
    GRID_ROW(3),
    GRID_ROW(4),
    [GRID_RETURN] = { .rect = { 160, 191, 192, 255 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR, 0, 0, 0 } },
};

// ov99_021EA250: each place's cursor position and its neighbours up, down, left and right; down from the bottom row
// is Return, up from Return back where the cursor came from (else the last Pokémon)
#define GRID_PLACE(row, col)                                                                                               \
    {                                                                                                                      \
        48 + 32 * (col), 36 + 24 * (row), 0, 0,                                                                            \
            (row) > 0 ? ((row) - 1) * ICON_COLUMNS + (col) : (row) * ICON_COLUMNS + (col),                                 \
            (row) < ICON_ROWS - 1 ? ((row) + 1) * ICON_COLUMNS + (col) : GRID_RETURN,                                      \
            (col) > 0 ? (row) * ICON_COLUMNS + (col) - 1 : (row) * ICON_COLUMNS + (col),                                   \
            (col) < ICON_COLUMNS - 1 ? (row) * ICON_COLUMNS + (col) + 1 : (row) * ICON_COLUMNS + (col)                     \
    }
#define GRID_PLACE_ROW(row) GRID_PLACE(row, 0), GRID_PLACE(row, 1), GRID_PLACE(row, 2), GRID_PLACE(row, 3), GRID_PLACE(row, 4), GRID_PLACE(row, 5)

static const GridMenuCursorPosition sGridPlaces[] = {
    GRID_PLACE_ROW(0),
    GRID_PLACE_ROW(1),
    GRID_PLACE_ROW(2),
    GRID_PLACE_ROW(3),
    GRID_PLACE_ROW(4),
    [GRID_RETURN] = { 224, 176, 0, 0, GRID_FORCED | (GRID_RETURN - 1), GRID_RETURN, GRID_RETURN, GRID_RETURN },
};

static void BuildSpeciesList(MedalsScreen *app);
static void SetUpBgs(MedalsScreen *app);
static void FreeBgs(MedalsScreen *app);
static void LoadBgGraphics(MedalsScreen *app);
static void MakeSprites(MedalsScreen *app);
static void DrawPageHeader(MedalsScreen *app);
static void DrawPage(MedalsScreen *app);
static void DrawChosen(MedalsScreen *app);
static void ClearChosen(MedalsScreen *app);
static void DrawFixedText(MedalsScreen *app);
static BOOL HandleInput(MedalsScreen *app);
static BOOL TurnPageStep(MedalsScreen *app);
static void VBlank(void *data);

static void NoteForTests(MedalsScreen *app)
{
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonRecordScreen[0] = 1 + COMPLETE_POKEATHLON_SCREEN_MEDALS;
    gCompleteTestPokeathlonRecordScreen[1] = 1 + app->page;
    gCompleteTestPokeathlonRecordScreen[2] = app->place;
#endif
}

// ov99_021E7180 and ov99_021E7198: a species' medals, and whether it has all five (none for no species)
static u8 Medals(const MedalsScreen *app, u16 species)
{
    if (species == SPECIES_NONE || species > NATIONAL_DEX_COUNT) {
        return 0;
    }

    return app->medals[species - 1];
}

static BOOL IsMedalist(const MedalsScreen *app, u16 species)
{
    return MATH_CountPopulation(Medals(app, species)) == NUM_MEDALS;
}

BOOL CompletePokeathlonMedals_Init(ApplicationManager *appMan, int *state)
{
    CompletePokeathlonRecordArgs *args = ApplicationManager_Args(appMan);

    GXLayers_DisableEngineBLayers();
    GXLayers_DisableEngineALayers();
    GF_ASSERT(args != NULL);
    Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_MEDALS, MEDALS_HEAP_SIZE);

    MedalsScreen *app = ApplicationManager_NewData(appMan, sizeof(MedalsScreen), HEAP_ID_MEDALS);

    MI_CpuClear8(app, sizeof(MedalsScreen));
    app->heapID = HEAP_ID_MEDALS;
    app->pokeathlon = CompletePokeathlon_Load(args->saveData, app->heapID);
    app->medals = app->pokeathlon->medals;
    app->pokedex = SaveData_GetPokedex(args->saveData);
    app->trophyGoals = args->trophyGoals;
    app->previousPlace = GRID_NONE;
    app->forcedFrom = GRID_NONE;
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonMedals = app->pokeathlon->medals;
    gCompleteTestPokeathlonRecordScreen[3] = 0;
#endif

    PokeathlonRecords_SetUpScreens();
    app->narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__POKEATHLON_RECORDS, app->heapID);
    BuildSpeciesList(app);
    SetUpBgs(app);
    LoadBgGraphics(app);
    app->text = PokeathlonRecords_NewText(app->heapID, app->bgConfig, NUM_WINDOWS, sWindowTemplates, TEXT_BANK_HGSS_MSG_0314);
    MakeSprites(app);
    DrawPageHeader(app);
    DrawPage(app);
    DrawChosen(app);
    DrawFixedText(app);
    EnableTouchPad();
    InitializeTouchPad(4);
    ResetVisibleHardwareWindows(DS_SCREEN_MAIN);
    ResetVisibleHardwareWindows(DS_SCREEN_SUB);
    SetVBlankCallback(VBlank, app);
    NoteForTests(app);
    return TRUE;
}

#ifdef SOVEREIGN_TEST
// A test's request: the medals reread (a test filled them) and everything drawn from them drawn again, from page 1
static void RedrawForTest(MedalsScreen *app)
{
    int rank;

    BuildSpeciesList(app);
    app->page = 0;
    rank = PokeathlonRecords_TrustTrophyRank(PokeathlonRecords_CountMedalists(app->medals));

    for (int i = 0; i < NUM_CROWNS; i++) {
        ManagedSprite_SetAnim(app->spriteList[SPRITE_CROWN + i], i < rank ? 1 : 0);
    }

    DrawPageHeader(app);
    DrawPage(app);
    DrawFixedText(app);

    if (app->place == GRID_RETURN) {
        ClearChosen(app);
    } else {
        DrawChosen(app);
    }

    NoteForTests(app);
}
#endif

BOOL CompletePokeathlonMedals_Main(ApplicationManager *appMan, int *state)
{
    MedalsScreen *app = ApplicationManager_Data(appMan);

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
        if (gCompleteTestPokeathlonRecordScreen[3] != 0 && !app->turning) {
            gCompleteTestPokeathlonRecordScreen[3] = 0;
            RedrawForTest(app);
        }
#endif
        if (app->redrawChosen) {
            DrawChosen(app);
            app->redrawChosen = FALSE;
        }

        if (app->turning) {
            if (TurnPageStep(app)) {
                app->turning = FALSE;
            }
        } else if (HandleInput(app) || PokeathlonRecords_ReturnPressed()) {
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

BOOL CompletePokeathlonMedals_Exit(ApplicationManager *appMan, int *state)
{
    MedalsScreen *app = ApplicationManager_Data(appMan);

    DisableTouchPad();
    PokeathlonRecords_FreeSprites(app->sprites, app->spriteList, NUM_SPRITES);
    PokeathlonRecords_FreeText(app->text);
    FreeBgs(app);
    PokeathlonRecords_EndScreens();
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonRecordScreen[0] = 0;
    gCompleteTestPokeathlonMedals = NULL;
#endif
    Heap_Free(app->pokeathlon);
    ApplicationManager_FreeData(appMan);
    Heap_Destroy(HEAP_ID_MEDALS);
    return TRUE;
}

// ov99_021E72C0: the species with a medal, in National Dex order (HeartGold's from its Pokédex archive's list, 1 to
// 493), and the pages they fill
static void BuildSpeciesList(MedalsScreen *app)
{
    app->numSpecies = 0;

    for (u16 species = 1; species <= NATIONAL_DEX_COUNT; species++) {
        if (Medals(app, species) != 0) {
            app->species[app->numSpecies++] = species;
        }
    }

    app->lastPage = 0;

    if (app->numSpecies != 0) {
        app->lastPage = (app->numSpecies - 1) / ICONS_PER_PAGE;
    }
}

// ov99_021E7158: the Pokémon on the page shown
static int IconsOnPage(const MedalsScreen *app)
{
    if (app->page != app->lastPage) {
        return ICONS_PER_PAGE;
    }

    return app->numSpecies - app->lastPage * ICONS_PER_PAGE;
}

// ov99_021E71B0: the Pokémon under the cursor (none on Return or an empty place)
static u16 ChosenSpecies(const MedalsScreen *app)
{
    int index = app->page * ICONS_PER_PAGE + app->place;

    if (app->place >= ICONS_PER_PAGE || index >= app->numSpecies) {
        return SPECIES_NONE;
    }

    return app->species[index];
}

// ov99_021E71E4 and ov99_021E7208: the form and gender the Pokédex last saw a species in
static u8 SeenForm(const MedalsScreen *app, u16 species)
{
    if (species == SPECIES_NONE || species > NATIONAL_DEX_COUNT) {
        return 0;
    }

    return Pokedex_GetDisplayForm(app->pokedex, species, 0);
}

static u8 SeenGender(const MedalsScreen *app, u16 species)
{
    if (species == SPECIES_NONE || species > NATIONAL_DEX_COUNT) {
        return 0;
    }

    u32 gender = Pokedex_DisplayedGender(app->pokedex, species, 0);

    if (gender == (u32)-1) {
        gender = Pokemon_GetGenderOf(species, 0);
    }

    return gender;
}

// ov99_021E7D30
static void SetUpBgs(MedalsScreen *app)
{
    app->bgConfig = BgConfig_New(app->heapID);
    SetAllGraphicsModes(&sGraphicsModes);

    for (int i = 0; i < NELEMS(sBgLayers); i++) {
        Bg_InitFromTemplate(app->bgConfig, sBgLayers[i], &sBgTemplates[i], BG_TYPE_STATIC);
        Bg_ClearTilemap(app->bgConfig, sBgLayers[i]);
        Bg_ClearTilesRange(sBgLayers[i], 32, 0, app->heapID);
    }
}

// ov99_021E7EBC
static void FreeBgs(MedalsScreen *app)
{
    NARC_dtor(app->narc);

    for (int i = 0; i < NELEMS(sBgLayers); i++) {
        Bg_FreeTilemapBuffer(app->bgConfig, sBgLayers[i]);
    }

    Heap_Free(app->bgConfig);
}

// ov99_021E7DA4: two palettes on each screen; the medalists' marks' tiles from tile 1, put on the map as a page is drawn
static void LoadBgGraphics(MedalsScreen *app)
{
    NARC *narc = app->narc;
    BgConfig *bgConfig = app->bgConfig;

    Graphics_LoadPaletteFromOpenNARC(narc, GFX_BOTTOM_PLTT, PAL_LOAD_MAIN_BG, 0, PALETTE_SIZE_BYTES * 2, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_BOTTOM_TILES, bgConfig, BG_LAYER_MAIN_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_BOTTOM_TILEMAP, bgConfig, BG_LAYER_MAIN_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_BOTTOM_TILES, bgConfig, BG_LAYER_MAIN_2, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_GRID_TILEMAP, bgConfig, BG_LAYER_MAIN_2, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_MEDALIST_MARK_TILES, bgConfig, BG_LAYER_MAIN_3, 1, 0, TRUE, app->heapID);

    Graphics_LoadPaletteFromOpenNARC(narc, GFX_TOP_PLTT, PAL_LOAD_SUB_BG, 0, PALETTE_SIZE_BYTES * 2, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_TOP_TILES, bgConfig, BG_LAYER_SUB_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_TOP_TILEMAP, bgConfig, BG_LAYER_SUB_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_TOP_TILES, bgConfig, BG_LAYER_SUB_2, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_BANNER_TILEMAP, bgConfig, BG_LAYER_SUB_2, 0, 0, TRUE, app->heapID);
}

// ov99_021E7F90 and ov99_021E7F64: the arrows (0), the cursor and crowns (char 1, the rest 2), the medals (char 32,
// the rest 3, on the top screen), the 30 icons (chars 2-31, the rest 1) and the picture (char 33, the rest 4, on top)
static void LoadSpriteResources(MedalsScreen *app)
{
    SpriteSystem *spriteSys = app->sprites->spriteSystem;
    SpriteManager *spriteMan = app->sprites->spriteManager;
    NARC *narc = app->narc;

    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_CURSOR_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 1);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_CURSOR_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DMAIN, 2);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_CURSOR_CELL, TRUE, 2);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_CURSOR_ANIM, TRUE, 2);

    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_MEDALS_PLTT, FALSE, NUM_MEDALS, NNS_G2D_VRAM_TYPE_2DSUB, 3);
    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_MEDALS_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DSUB, 32);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_MEDALS_CELL, TRUE, 3);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_MEDALS_ANIM, TRUE, 3);

    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_ARROWS_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_ARROWS_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_ARROWS_CELL, TRUE, 0);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_ARROWS_ANIM, TRUE, 0);

    PokeathlonRecords_LoadIconResources(app->sprites, sIconResources, ICONS_PER_PAGE, NNS_G2D_VRAM_TYPE_2DMAIN, FALSE);
    PokeathlonRecords_LoadMonPicResources(app->sprites, sMonPicResources, NNS_G2D_VRAM_TYPE_2DSUB);
}

// ov99_021E7EF0, ov99_021E80D0, ov99_021E810C and ov99_021E8198: the cursor, arrows and picture; the five medals
// (hidden until a Pokémon's chosen); the grid's 30 icons; the ten crowns, lit for the Trust Trophies
static void MakeSprites(MedalsScreen *app)
{
    SpriteTemplate template;

    app->sprites = PokeathlonRecords_NewSprites(app->heapID, &sSpriteCapacities, NUM_SPRITES);
    LoadSpriteResources(app);

    for (int i = 0; i < NELEMS(sButtonTemplates); i++) {
        app->spriteList[i] = PokeathlonRecords_NewSprite(app->sprites, &sButtonTemplates[i]);
        ManagedSprite_SetAnimateFlag(app->spriteList[i], TRUE);
    }

    MI_CpuClear8(&template, sizeof(SpriteTemplate));
    template.vramType = NNS_G2D_VRAM_TYPE_2DSUB;
    template.resources[0] = 32;
    template.resources[1] = 3;
    template.resources[2] = 3;
    template.resources[3] = 3;

    for (int i = 0; i < NUM_MEDALS; i++) {
        ManagedSprite *medal;

        template.x = sMedalPositions[i].x;
        template.y = sMedalPositions[i].y;
        template.animIdx = i;
        template.plttIdx = i;
        medal = PokeathlonRecords_NewSprite(app->sprites, &template);
        ManagedSprite_SetAnimateFlag(medal, TRUE);
        ManagedSprite_SetDrawFlag(medal, FALSE);
        app->spriteList[SPRITE_MEDAL + i] = medal;
    }

    MI_CpuClear8(&template, sizeof(SpriteTemplate));
    template.vramType = NNS_G2D_VRAM_TYPE_2DMAIN;
    template.resources[1] = sIconResources[1];
    template.resources[2] = sIconResources[2];
    template.resources[3] = sIconResources[3];
    template.bgPriority = 1;

    for (int i = 0; i < ICONS_PER_PAGE; i++) {
        template.x = 48 + 32 * (i % ICON_COLUMNS);
        template.y = 32 + 24 * (i / ICON_COLUMNS);
        template.resources[0] = sIconResources[0] + i;
        app->spriteList[SPRITE_ICON + i] = PokeathlonRecords_NewSprite(app->sprites, &template);
    }

    PokeathlonRecords_NewSpriteRow(app->sprites, app->spriteList, sCrownResources, PokeathlonRecords_TrustTrophyRank(PokeathlonRecords_CountMedalists(app->medals)), SPRITE_CROWN, 8, 152, NNS_G2D_VRAM_TYPE_2DMAIN);
}

// ov99_021E7C58: the cursor to a place
static void MoveCursor(MedalsScreen *app, u8 place)
{
    u8 x, y;

    GridMenuCursor_GetFirstCoords(&sGridPlaces[place], &x, &y);
    ManagedSprite_SetPositionXY(app->spriteList[SPRITE_CURSOR], x, y);
    app->place = place;
    Sound_PlayEffect(SE_CONFIRM_sseq_3);
    NoteForTests(app);
}

// ov99_021E7CE4 (its handler's key and touch callbacks): a new place; its Pokémon drawn the next frame
static void ChangePlace(MedalsScreen *app, u8 place, u8 previous, BOOL touched)
{
    if (place == previous || place > GRID_RETURN) {
        return;
    }

    MoveCursor(app, place);

    if (place < GRID_RETURN) {
        app->redrawChosen = TRUE;
    } else {
        ClearChosen(app);
    }

    ManagedSprite_SetAnim(app->spriteList[SPRITE_CURSOR], (place == GRID_RETURN ? ANIM_CURSOR_RETURN : ANIM_CURSOR_ICON) + touched);
}

static void SetGridPlace(MedalsScreen *app, u8 place)
{
    app->place = place;
    app->previousPlace = GRID_NONE;
    app->forcedFrom = GRID_NONE;
}

// HeartGold's DpadBox_IsForcedInDirection: the place a move arrives at sends the cursor back the opposite way
static BOOL IsForcedBack(const GridMenuCursorPosition *place, u8 direction)
{
    switch (direction) {
    case GRID_MENU_CURSOR_POSITION_DIRECTION_UP:
        return (place->downIndex & GRID_FORCED) != 0;
    case GRID_MENU_CURSOR_POSITION_DIRECTION_DOWN:
        return (place->upIndex & GRID_FORCED) != 0;
    case GRID_MENU_CURSOR_POSITION_DIRECTION_LEFT:
        return (place->rightIndex & GRID_FORCED) != 0;
    case GRID_MENU_CURSOR_POSITION_DIRECTION_RIGHT:
        return (place->leftIndex & GRID_FORCED) != 0;
    }

    return FALSE;
}

// HeartGold's GridInputHandler_HandleInput_AllowHold: a touched place (its number), a cursor moved by the D-pad
// (-3), A on a place (its number), B (-2) or nothing (-1)
static int HandleGridInput(MedalsScreen *app)
{
    u8 direction;
    u8 target = GRID_NONE;

    for (int i = 0; sGridHitTable[i].rect.top != TOUCHSCREEN_TABLE_TERMINATOR; i++) {
        if (TouchScreen_LocationPressed(&sGridHitTable[i])) {
            SetGridPlace(app, i);
            ChangePlace(app, i, GRID_NONE, TRUE);
            return i;
        }
    }

    if (JOY_REPEAT(PAD_KEY_UP)) {
        direction = GRID_MENU_CURSOR_POSITION_DIRECTION_UP;
    } else if (JOY_REPEAT(PAD_KEY_DOWN)) {
        direction = GRID_MENU_CURSOR_POSITION_DIRECTION_DOWN;
    } else if (JOY_REPEAT(PAD_KEY_LEFT)) {
        direction = GRID_MENU_CURSOR_POSITION_DIRECTION_LEFT;
    } else if (JOY_REPEAT(PAD_KEY_RIGHT)) {
        direction = GRID_MENU_CURSOR_POSITION_DIRECTION_RIGHT;
    } else {
        direction = GRID_MENU_CURSOR_POSITION_DIRECTION_NONE;
    }

    if (direction != GRID_MENU_CURSOR_POSITION_DIRECTION_NONE) {
        target = GridMenuCursor_CheckNavigation(sGridPlaces, NULL, NULL, NULL, NULL, app->place, direction);

        if (target & GRID_FORCED) {
            target = app->forcedFrom != GRID_NONE ? app->forcedFrom : target ^ GRID_FORCED;
        }

        if (target == app->place) {
            return -1;
        }

        app->forcedFrom = IsForcedBack(&sGridPlaces[target], direction) ? app->place : GRID_NONE;
        app->previousPlace = app->place;
        app->place = target;
        ChangePlace(app, target, app->previousPlace, FALSE);
        return -3;
    }

    if (JOY_NEW(PAD_BUTTON_A)) {
        return app->place;
    }

    if (JOY_NEW(PAD_BUTTON_B)) {
        return -2;
    }

    return -1;
}

// ov99_021E7AD4: a page on or back (by an arrow or the D-pad at the grid's edge), the cursor to the new page's first
// place if an arrow was touched (Return stays), else across the row to the other edge; the page slides in
static void TurnPage(MedalsScreen *app, BOOL next, BOOL touched)
{
    int previousPage = app->page;
    u8 place = 0;

    if (next) {
        app->page++;
    } else if (app->page != 0) {
        app->page--;
    }

    if (app->page > app->lastPage) {
        app->page = app->lastPage;
    }

    if (app->page == previousPage) {
        return;
    }

    Sound_PlayEffect(SE_CONFIRM_sseq_3);
    app->slideRight = !next;
    app->turning = TRUE;

    if (touched) {
        if (app->place == GRID_RETURN) {
            place = GRID_RETURN;
        }
    } else {
        place = next ? app->place - (ICON_COLUMNS - 1) : app->place + (ICON_COLUMNS - 1);
    }

    SetGridPlace(app, place);
    MoveCursor(app, place);
    ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_CURSOR], FALSE);
}

// ov99_021E7BC8: TRUE to leave (A on Return); an arrow touched or the D-pad's LEFT or RIGHT going nowhere on the grid
// turns the page
static BOOL HandleInput(MedalsScreen *app)
{
    int result = HandleGridInput(app);
    int arrow = TouchScreen_CheckPressedHitTableID(sArrowHitTable);

    if (arrow != TOUCHSCREEN_INPUT_NONE) {
        TurnPage(app, arrow == 1, TRUE);
        return FALSE;
    }

    if (result == -1 && app->place < GRID_RETURN) {
        if (gSystem.pressedKeysRepeatable == PAD_KEY_LEFT) {
            TurnPage(app, FALSE, FALSE);
        } else if (gSystem.pressedKeysRepeatable == PAD_KEY_RIGHT) {
            TurnPage(app, TRUE, FALSE);
        }

        return FALSE;
    }

    return app->place == GRID_RETURN && JOY_NEW(PAD_BUTTON_A);
}

// ov99_021E7598: a frame of the page turn. The grid's panel, marks and icons slide a quarter screen a frame, eight
// frames: the new page is drawn halfway, its icons set a whole screen back to come in from the other side.
static BOOL TurnPageStep(MedalsScreen *app)
{
    int step = app->slideRight ? PAGE_TURN_STEP : -PAGE_TURN_STEP;

    if (app->turnFrame == 0) {
        DrawPageHeader(app);

        if (app->place == GRID_RETURN) {
            ClearChosen(app);
        } else {
            DrawChosen(app);
        }
    } else if (app->turnFrame == PAGE_TURN_FRAMES / 2) {
        DrawPage(app);

        for (int i = 0; i < ICONS_PER_PAGE; i++) {
            s16 x, y;

            ManagedSprite_GetPositionXY(app->spriteList[SPRITE_ICON + i], &x, &y);
            ManagedSprite_SetPositionXY(app->spriteList[SPRITE_ICON + i], x - 2 * app->turnFrame * step, y);
        }
    }

    if (app->turnFrame < PAGE_TURN_FRAMES) {
        Bg_ScheduleScroll(app->bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_ADD_X, -step);
        Bg_ScheduleScroll(app->bgConfig, BG_LAYER_MAIN_3, BG_OFFSET_UPDATE_ADD_X, -step);

        for (int i = 0; i < ICONS_PER_PAGE; i++) {
            ManagedSprite_OffsetPositionXY(app->spriteList[SPRITE_ICON + i], step, 0);
        }

        app->turnFrame++;
        return FALSE;
    }

    Bg_ScheduleScroll(app->bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_X, 0);
    Bg_ScheduleScroll(app->bgConfig, BG_LAYER_MAIN_3, BG_OFFSET_UPDATE_SET_X, 0);
    app->turnFrame = 0;
    ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_CURSOR], TRUE);
    return TRUE;
}

// ov99_021E7508: the arrows (where there's a page that way) and "1/2"
static void DrawPageHeader(MedalsScreen *app)
{
    ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_PREV_PAGE], app->lastPage != 0 && app->page != 0);
    ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_NEXT_PAGE], app->lastPage != 0 && app->page < app->lastPage);
    StringTemplate_SetNumber(app->text->template, 0, app->page + 1, 2, PADDING_MODE_SPACES, CHARSET_MODE_EN);
    StringTemplate_SetNumber(app->text->template, 1, app->lastPage + 1, 2, PADDING_MODE_SPACES, CHARSET_MODE_EN);
    PokeathlonRecords_PrintMessageAt(app->text, WINDOW_PAGE, msg_0314_00129, 0, 0);
}

// ov99_021E738C and ov99_021E73E0: a medalist's mark, a 2x2-tile block at its icon's lower right
static void DrawMedalistMark(MedalsScreen *app, int icon, u16 species)
{
    if (!IsMedalist(app, species)) {
        return;
    }

    u8 x = (icon % ICON_COLUMNS) * 4 + 6;
    u8 y = (icon / ICON_COLUMNS) * 3 + 4;

    for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 2; col++) {
            u16 tile = row * 2 + col + 1;

            Bg_LoadToTilemapRect(app->bgConfig, BG_LAYER_MAIN_3, &tile, x + col, y + row, 1, 1);
        }
    }

    Bg_CopyTilemapBufferToVRAM(app->bgConfig, BG_LAYER_MAIN_3);
}

// ov99_021E7428 and ov99_021E7450: the page's icons (each in the form the Pokédex last saw), with their marks
static void DrawPage(MedalsScreen *app)
{
    int count = IconsOnPage(app);

    Bg_ClearTilemap(app->bgConfig, BG_LAYER_MAIN_3);

    for (int i = 0; i < ICONS_PER_PAGE; i++) {
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_ICON + i], FALSE);
    }

    for (int i = 0; i < count; i++) {
        CompletePokeathlonRecordMon mon;
        u16 species = app->species[app->page * ICONS_PER_PAGE + i];

        MI_CpuClear8(&mon, sizeof(CompletePokeathlonRecordMon));
        mon.species = species;
        mon.form = SeenForm(app, species);
        PokeathlonRecords_DrawIcon(app->sprites, app->spriteList[SPRITE_ICON + i], &mon, FALSE);
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_ICON + i], TRUE);
        DrawMedalistMark(app, i, species);
    }

    NoteForTests(app);
}

// ov99_021E7758: "Pikachu’s Medals", or nothing
static void DrawChosenName(MedalsScreen *app, u16 species)
{
    if (species == SPECIES_NONE) {
        PokeathlonRecords_ClearWindow(app->text, WINDOW_SPECIES);
        return;
    }

    PokeathlonRecords_SetSpeciesName(app->text, 0, species);
    PokeathlonRecords_PrintMessage(app->text, WINDOW_SPECIES, msg_0314_00124, FALSE);
}

// ov99_021E7258
static void ShowChosenMedals(MedalsScreen *app, u16 species)
{
    u8 medals = Medals(app, species);

    for (int i = 0; i < NUM_MEDALS; i++) {
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_MEDAL + i], (medals >> i) & 1);
    }
}

// ov99_021E7794 and ov99_021E76D8: the chosen Pokémon on the top screen, its picture as the Pokédex last saw it (the
// first Spinda seen's spots), its name and medals, and the medalist's banner if it has all five
static void DrawChosen(MedalsScreen *app)
{
    CompletePokeathlonRecordMon mon;
    u16 species = ChosenSpecies(app);

    MI_CpuClear8(&mon, sizeof(CompletePokeathlonRecordMon));
    mon.species = species;
    mon.form = SeenForm(app, species);
    mon.gender = SeenGender(app, species);

    if (species == SPECIES_SPINDA) {
        mon.personality = Pokedex_GetForm_Spinda(app->pokedex, 0);
    }

    PokeathlonRecords_DrawMonPic(app->spriteList[SPRITE_MON_PIC], &mon, NNS_G2D_VRAM_TYPE_2DSUB, app->heapID);
    DrawChosenName(app, species);
    ShowChosenMedals(app, species);
    GXLayers_EngineBToggleLayers(GX_PLANEMASK_BG2, IsMedalist(app, species));
}

// ov99_021E77D8: nothing chosen (the cursor on Return)
static void ClearChosen(MedalsScreen *app)
{
    ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_MON_PIC], FALSE);
    DrawChosenName(app, SPECIES_NONE);

    for (int i = 0; i < NUM_MEDALS; i++) {
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_MEDAL + i], FALSE);
    }

    GXLayers_EngineBToggleLayers(GX_PLANEMASK_BG2, FALSE);
}

// ov99_021E8224: the banner's "Medalist Pokémon", "Pokémon Record", Return, the medals' names, the number of medalists
// (four digits from 1,000) and, once every record's been played, what the next Trust Trophy needs
static void DrawFixedText(MedalsScreen *app)
{
    PokeathlonRecordsText *text = app->text;
    u16 medalists = PokeathlonRecords_CountMedalists(app->medals);

    PokeathlonRecords_PrintMessageEx(text, WINDOW_MEDALIST, msg_0314_00126, TRUE, 0, 0, FONT_SYSTEM, 3);
    PokeathlonRecords_PrintMessageAt(text, WINDOW_TITLE, msg_0314_00127, 1, 0);
    PokeathlonRecords_PrintMessageInFont(text, WINDOW_RETURN, msg_0314_00000, TRUE, 0, FONT_SUBSCREEN);

    for (int i = 0; i < NUM_MEDALS; i++) {
        PokeathlonRecords_SetMedalName(text->template, 0, i);
        PokeathlonRecords_PrintMessage(text, WINDOW_MEDAL_NAME + i, msg_0314_00004, FALSE);
    }

    StringTemplate_SetNumber(text->template, 0, medalists, DEX_NUMBER_DIGITS(medalists), PADDING_MODE_SPACES, CHARSET_MODE_EN);
    PokeathlonRecords_PrintMessageAt(text, WINDOW_MEDALISTS, msg_0314_00128, 1, 0);

    if (app->trophyGoals) {
        PokeathlonRecords_PrintMessageAt(text, WINDOW_TROPHY_GOAL, msg_0314_00113 + PokeathlonRecords_TrustTrophyRank(medalists), 1, 0);
    }
}

// ov99_021E7A54
static void VBlank(void *data)
{
    MedalsScreen *app = data;

    SpriteSystem_TransferOam();
    Bg_RunScheduledUpdates(app->bgConfig);
    OS_SetIrqCheckFlag(OS_IE_V_BLANK);
}
