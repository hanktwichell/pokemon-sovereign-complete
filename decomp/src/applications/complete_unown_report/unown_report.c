#include <nitro.h>

#include "constants/graphics.h"
#include "constants/heap.h"
#include "constants/narc.h"
#include "generated/species.h"
#include "generated/text_banks.h"
#include "generated/vars_flags.h"

#include "bg_window.h"
#include "complete_unown_report.h"
#include "font.h"
#include "game_options.h"
#include "graphics.h"
#include "gx_layers.h"
#include "heap.h"
#include "message.h"
#include "narc.h"
#include "overlay_manager.h"
#include "pokedex.h"
#include "pokemon_icon.h"
#include "render_oam.h"
#include "render_text.h"
#include "screen_fade.h"
#include "sound.h"
#include "sound_playback.h"
#include "sprite.h"
#include "sprite_system.h"
#include "sprite_util.h"
#include "string_gf.h"
#include "string_template.h"
#include "system.h"
#include "text.h"
#include "touch_pad.h"
#include "touch_screen.h"
#include "save_player.h"
#include "trainer_info.h"
#include "vars_flags.h"
#include "vram_transfer.h"

#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0001.h"

// Sovereign Complete: HeartGold's Unown Report (include/complete_unown_report.h), its overlay 113 (UnownReport_Init to
// ov113_021E6B1C, in assembly in pret's HeartGold), written in C on Platinum's libraries. The book opens across both
// screens, the bottom one the main engine: the cover (the player's name, the number of Unown kinds), the Unown pages
// (14 a page, 7 on each screen, each an icon and its word), then the research reports. UP and DOWN, or the arrows,
// turn a page; B or CANCEL closes it. What differs from HeartGold's: the Unown listed are those Platinum's Pokédex has
// seen (HeartGold's lists those caught); the sprites' resources are loaded by number (HeartGold's resdat 4-7 and 73
// name members 0-3 of its a/2/3/9); its unused Yes/No prompt and window frame aren't made.

#define HEAP_ID_UNOWN_REPORT HEAP_ID_DIPLOMA // the diploma's, as the album's and the pots': the apps can't run together
#define REPORT_HEAP_SIZE     0x20000

#define ICONS_PER_PAGE      14 // 7 on each screen
#define ICONS_PER_SCREEN    7
#define MAX_UNOWN           28 // UNOWN_FORM_COUNT: A to Z, ! and ?
#define REPORT_LEVEL_SORTED 4 // from it on, the Unown pages run A to Z, then ! and ? if seen
#define NUM_REPORT_SPREADS  6

enum {
    STATE_FADE_IN = 0, // ov113_021E5BC4
    STATE_CLOSE, // ov113_021E5C0C: CANCEL's animation, then the fade out
    STATE_INPUT, // ov113_021E5D60
    STATE_TURN_PAGE, // ov113_021E5C68
    STATE_EXIT,
};

enum { // what's touched or pressed (ov113_021E5ED0)
    INPUT_CANCEL = 0,
    INPUT_PREV_PAGE,
    INPUT_NEXT_PAGE,
};

// The archive (tools/complete/import_hgss_unown_report.py: HeartGold's a/2/3/9, member n as member n)
enum {
    GFX_SPRITE_PLTT = 0,
    GFX_SPRITE_CHAR,
    GFX_SPRITE_CELL,
    GFX_SPRITE_ANIM,
    GFX_TOP_PLTT,
    GFX_BOTTOM_PLTT,
    GFX_TOP_TILES,
    GFX_BOTTOM_TILES,
    GFX_TOP_TILEMAP,
    GFX_BOTTOM_TILEMAP,
    GFX_COVER_TOP,
    GFX_COVER_BOTTOM,
    GFX_UNOWN_TOP,
    GFX_UNOWN_BOTTOM,
    GFX_REPORT_TOP,
    GFX_REPORT_BOTTOM,
};

enum { // the pages' frames, kept as maps to copy over the frame layers (HeartGold's at 0x100 to 0x150)
    FRAME_COVER_TOP = 0,
    FRAME_COVER_BOTTOM,
    FRAME_UNOWN_TOP,
    FRAME_UNOWN_BOTTOM,
    FRAME_REPORT_TOP,
    FRAME_REPORT_BOTTOM,
    NUM_FRAMES,
};

enum {
    WINDOW_CANCEL = 0, // HeartGold's at 0x68
    WINDOW_TOP, // 0x78: the left-hand page, on the top screen
    WINDOW_BOTTOM, // 0x88: the right-hand page
    WINDOW_PAGE, // 0x98: "1/4"
    NUM_WINDOWS,
};

enum {
    SPRITE_CANCEL = 0,
    SPRITE_PREV,
    SPRITE_NEXT,
    NUM_SPRITES,
};

typedef struct PageFrame {
    void *data;
    NNSG2dScreenData *screen;
    u8 width; // in tiles
    u8 height;
} PageFrame;

typedef struct UnownReport {
    enum HeapID heapID;
    CompleteUnownReportArgs *args;
    Pokedex *pokedex;
    u16 subState;
    int menuInputState;
    u8 textFrameDelay;
    u8 frame;
    u8 page;
    u8 pageCount;
    u8 unownPages;
    u8 reportSpreads;
    u8 numUnown;
    u8 forms[MAX_UNOWN];
    u8 reportLevel;
    BgConfig *bgConfig;
    MessageLoader *msgLoader;
    StringTemplate *strTemplate;
    String *format;
    String *text;
    String *cancelText;
    String *pageFormat;
    String *playerName;
    Window windows[NUM_WINDOWS];
    SpriteSystem *spriteSystem;
    SpriteManager *buttonManager;
    SpriteManager *iconManager;
    Sprite *sprites[NUM_SPRITES];
    ManagedSprite *icons[ICONS_PER_PAGE];
    NARC *iconNarc;
    PageFrame frames[NUM_FRAMES];
} UnownReport;

// A report spread (ov113_021E6BD0): its left (top screen) and right (bottom screen) halves, each its first message,
// how many follow on, and the report level it shows from
typedef struct ReportHalf {
    u8 message;
    u8 count;
    u8 level;
} ReportHalf;

static const ReportHalf sReportSpreads[NUM_REPORT_SPREADS][2] = {
    { { 6, 1, 1 }, { 7, 1, 1 } },
    { { 8, 1, 2 }, { 9, 1, 3 } },
    { { 10, 1, 4 }, { 11, 1, 4 } },
    { { 12, 1, 5 }, { 13, 1, 6 } },
    { { 14, 3, 7 }, { 17, 1, 7 } },
    { { 18, 1, 8 }, { 19, 1, 8 } },
};

#define REPORT_UNOWN_FONT_MESSAGE 15 // the floor's words, in the Unown font

static const TouchScreenRect sTouchRects[] = { // ov113_021E6B82
    [INPUT_CANCEL] = { .rect = { 160, 192, 192, 255 } },
    [INPUT_PREV_PAGE] = { .rect = { 16, 37, 220, 244 } },
    [INPUT_NEXT_PAGE] = { .rect = { 120, 141, 220, 244 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR, 0, 0, 0 } },
};

static const GXBanks sBanks = { // ov113_021E6CD0
    GX_VRAM_BG_128_A,
    GX_VRAM_BGEXTPLTT_NONE,
    GX_VRAM_SUB_BG_128_C,
    GX_VRAM_SUB_BGEXTPLTT_NONE,
    GX_VRAM_OBJ_64_E,
    GX_VRAM_OBJEXTPLTT_NONE,
    GX_VRAM_SUB_OBJ_16_I,
    GX_VRAM_SUB_OBJEXTPLTT_NONE,
    GX_VRAM_TEX_NONE,
    GX_VRAM_TEXPLTT_NONE,
};

static const GraphicsModes sGraphicsModes = { GX_DISPMODE_GRAPHICS, GX_BGMODE_0, GX_BGMODE_0, GX_BG0_AS_2D };

// The layers: 1 the text, 2 the page's frame, 3 the background, on each screen (ov113_021E6C04 and the rest)
static const struct {
    u8 layer;
    u8 screenBase;
    u8 charBase;
    u8 priority;
} sLayers[] = {
    { BG_LAYER_SUB_1, GX_BG_SCRBASE_0xf800, GX_BG_CHARBASE_0x10000, 1 },
    { BG_LAYER_SUB_2, GX_BG_SCRBASE_0xf000, GX_BG_CHARBASE_0x00000, 2 },
    { BG_LAYER_SUB_3, GX_BG_SCRBASE_0xe800, GX_BG_CHARBASE_0x00000, 3 },
    { BG_LAYER_MAIN_1, GX_BG_SCRBASE_0xf800, GX_BG_CHARBASE_0x10000, 1 },
    { BG_LAYER_MAIN_2, GX_BG_SCRBASE_0xf000, GX_BG_CHARBASE_0x00000, 2 },
    { BG_LAYER_MAIN_3, GX_BG_SCRBASE_0xe800, GX_BG_CHARBASE_0x00000, 3 },
};

static const WindowTemplate sWindowTemplates[NUM_WINDOWS] = { // ov113_021E6C90
    [WINDOW_CANCEL] = { BG_LAYER_MAIN_1, 25, 21, 6, 2, 12, 0x1E1 },
    [WINDOW_TOP] = { BG_LAYER_SUB_1, 2, 3, 24, 20, 12, 1 },
    [WINDOW_BOTTOM] = { BG_LAYER_MAIN_1, 2, 1, 24, 20, 12, 1 },
    [WINDOW_PAGE] = { BG_LAYER_MAIN_1, 28, 9, 3, 2, 12, 0x1ED },
};

static const RenderOamTemplate sOamTemplate = { 0, 128, 0, 32, 0, 128, 0, 32 }; // ov113_021E6CB0
static const CharTransferTemplateWithModes sCharTransfer = { // ov113_021E6BA4
    16, 0x10000, 0x4000, GX_OBJVRAMMODE_CHAR_1D_32K, GX_OBJVRAMMODE_CHAR_1D_32K
};

#define RESDAT_ID_NONE          0xFFFFFFFF
#define RESDAT_TABLE_TERMINATOR 0xFFFFFFFE

static const ResdatTableEntry sButtonHeaders[] = { // HeartGold's resdat 73
    { 0, 0, 0, 0, RESDAT_ID_NONE, RESDAT_ID_NONE, FALSE, 1 },
    { RESDAT_TABLE_TERMINATOR },
};

// The buttons: CANCEL and the two arrows, on the bottom screen (ov113_021E6CF8); HeartGold's palette mode 1 keeps the
// cell's own palettes
static const SpriteTemplateFromResourceHeader sButtonTemplates[NUM_SPRITES] = {
    [SPRITE_CANCEL] = { 0, 224, 176, 0, 0, 0, 0, NNS_G2D_VRAM_TYPE_2DMAIN, 1, 0, 0, 0 },
    [SPRITE_PREV] = { 0, 236, 28, 0, 2, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, 1, 0, 0, 0 },
    [SPRITE_NEXT] = { 0, 236, 132, 0, 5, 2, 0, NNS_G2D_VRAM_TYPE_2DMAIN, 1, 0, 0, 0 },
};

enum { // the buttons' animations
    ANIM_CANCEL = 0,
    ANIM_CANCEL_PRESSED,
    ANIM_PREV,
    ANIM_PREV_PRESSED,
    ANIM_PREV_OFF,
    ANIM_NEXT,
    ANIM_NEXT_PRESSED,
    ANIM_NEXT_OFF,
};

static void ResetScreens(void);
static void InitData(UnownReport *report);
static BOOL SetUp(UnownReport *report);
static void FreeAll(UnownReport *report);
static void VBlank(void *data);
static void SetUpBgs(UnownReport *report);
static void LoadGraphics(UnownReport *report);
static void SetUpText(UnownReport *report);
static void SetUpWindows(UnownReport *report);
static void SetUpSprites(UnownReport *report);
static void FreeSprites(UnownReport *report);
static void DrawCancel(UnownReport *report, u32 anim);
static void DrawPage(UnownReport *report, u8 page);
static void UpdateArrows(UnownReport *report);
static int HandleInput(UnownReport *report);

static void PrintAt(Window *window, enum Font font, const String *text, u32 x, u32 y)
{
    Text_AddPrinterWithParamsAndColor(window, font, text, x, y, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(1, 2, 0), NULL);
}

BOOL CompleteUnownReport_Init(ApplicationManager *appMan, int *state)
{
    UnownReport *report;

    switch (*state) {
    case 0:
        ResetScreens();
        Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_UNOWN_REPORT, REPORT_HEAP_SIZE);
        report = ApplicationManager_NewData(appMan, sizeof(UnownReport), HEAP_ID_UNOWN_REPORT);
        MI_CpuFill8(report, 0, sizeof(UnownReport));
        report->heapID = HEAP_ID_UNOWN_REPORT;
        report->args = ApplicationManager_Args(appMan);
        InitData(report);
        (*state)++;
        break;
    case 1:
        if (SetUp(ApplicationManager_Data(appMan))) {
            *state = 0;
            return TRUE;
        }
        break;
    }

    return FALSE;
}

BOOL CompleteUnownReport_Main(ApplicationManager *appMan, int *state)
{
    UnownReport *report = ApplicationManager_Data(appMan);

    switch (*state) {
    case STATE_FADE_IN:
        if (report->subState == 0) {
            StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_IN, FADE_TYPE_BRIGHTNESS_IN, COLOR_BLACK, 6, 1, report->heapID);
            report->subState++;
        } else if (IsScreenFadeDone()) {
            report->subState = 0;
            *state = STATE_INPUT;
        }
        break;
    case STATE_CLOSE:
        if (report->subState == 0) {
            if (!Sprite_IsAnimated(report->sprites[SPRITE_CANCEL])) {
                StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_OUT, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, 6, 1, report->heapID);
                report->subState++;
            }
        } else if (IsScreenFadeDone()) {
            report->subState = 0;
            *state = STATE_EXIT;
        }
        break;
    case STATE_INPUT:
        *state = HandleInput(report);
        break;
    case STATE_TURN_PAGE: // the page wipes away, the next is drawn, and wipes in (HeartGold's fades 4 and 2, then 3 and 5)
        switch (report->subState) {
        case 0:
            StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_UPWARD_OUT, FADE_TYPE_DOWNWARD_OUT, COLOR_BLACK, 6, 1, report->heapID);
            report->subState++;
            break;
        case 1:
            if (IsScreenFadeDone()) {
                DrawPage(report, report->page);
                report->subState++;
            }
            break;
        case 2:
            StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_DOWNWARD_IN, FADE_TYPE_UNK_5, COLOR_BLACK, 6, 1, report->heapID);
            report->subState++;
            break;
        case 3:
            if (IsScreenFadeDone()) {
                report->subState = 0;
                *state = STATE_INPUT;
            }
            break;
        }
        break;
    case STATE_EXIT:
        return TRUE;
    }

    SpriteSystem_DrawSprites(report->buttonManager);
    SpriteSystem_DrawSprites(report->iconManager);
    return FALSE;
}

BOOL CompleteUnownReport_Exit(ApplicationManager *appMan, int *state)
{
    UnownReport *report = ApplicationManager_Data(appMan);

    DisableTouchPad();
    FreeAll(report);
    ResetScreens();
    *report->args->menuInputState = report->menuInputState;
    ApplicationManager_FreeData(appMan);
    Heap_Destroy(HEAP_ID_UNOWN_REPORT);
    return TRUE;
}

// ov113_021E59F8: nothing shown, nothing run at VBlank, before and after
static void ResetScreens(void)
{
    SetVBlankCallback(NULL, NULL);
    DisableHBlank();
    GXLayers_DisableEngineALayers();
    GXLayers_DisableEngineBLayers();
    GX_SetVisiblePlane(0);
    GXS_SetVisiblePlane(0);
    SetScreenColorBrightness(DS_SCREEN_MAIN, COLOR_BLACK);
    SetScreenColorBrightness(DS_SCREEN_SUB, COLOR_BLACK);
    ResetVisibleHardwareWindows(DS_SCREEN_MAIN);
    ResetVisibleHardwareWindows(DS_SCREEN_SUB);
}

// ov113_021E5A7C: the options, the Unown to list, the pages
static void InitData(UnownReport *report)
{
    SaveData *saveData = report->args->saveData;
    Options *options = SaveData_GetOptions(saveData);

    report->menuInputState = *report->args->menuInputState;
    report->textFrameDelay = Options_TextFrameDelay(options);
    report->frame = Options_Frame(options);
    report->pokedex = SaveData_GetPokedex(saveData);
    report->reportLevel = *VarsFlags_GetVarAddress(SaveData_GetVarsFlags(saveData), VAR_HGSS_UNOWN_REPORT_LEVEL);

    report->reportSpreads = 0; // ov113_021E5D80: the spreads up to the first one not reached yet
    while (report->reportSpreads < NUM_REPORT_SPREADS && sReportSpreads[report->reportSpreads][0].level <= report->reportLevel) {
        report->reportSpreads++;
    }

    report->numUnown = Pokedex_NumFormsSeen_Unown(report->pokedex);

    if (report->reportLevel >= REPORT_LEVEL_SORTED) { // A to Z, then ! and ? as seen (ov113_021E5A48)
        int n = 26;

        for (int i = 0; i < 26; i++) {
            report->forms[i] = i;
        }

        for (int i = 0; i < report->numUnown && n < MAX_UNOWN; i++) {
            u32 form = Pokedex_GetForm_Unown(report->pokedex, i);

            if (form == 26 || form == 27) {
                report->forms[n++] = form;
            }
        }
    } else {
        for (int i = 0; i < report->numUnown; i++) {
            report->forms[i] = Pokedex_GetForm_Unown(report->pokedex, i);
        }
    }

    report->unownPages = (report->numUnown + ICONS_PER_PAGE - 1) / ICONS_PER_PAGE;
    report->pageCount = report->unownPages + report->reportSpreads + 1;
}

// ov113_021E5B70: the screens set up, then the first page
static BOOL SetUp(UnownReport *report)
{
    switch (report->subState) {
    case 0:
        SetUpBgs(report);
        LoadGraphics(report);
        SetUpText(report);
        SetUpWindows(report);
        SetUpSprites(report);
        SetVBlankCallback(VBlank, report);
        report->subState++;
        return FALSE;
    case 1:
        DrawCancel(report, ANIM_CANCEL);
        DrawPage(report, report->page);
        EnableTouchPad();
        InitializeTouchPad(1);
        Sound_SetSceneAndPlayBGM(SOUND_SCENE_SUB_BAG, SEQ_NONE, 0); // the field's music plays on (HeartGold's scene 0x45)
        report->subState = 0;
        return TRUE;
    }

    return FALSE;
}

static void FreeAll(UnownReport *report)
{
    GXLayers_EngineBToggleLayers(GX_PLANEMASK_OBJ, FALSE);
    GXLayers_EngineAToggleLayers(GX_PLANEMASK_OBJ, FALSE);
    FreeSprites(report);

    for (int i = 0; i < NUM_WINDOWS; i++) {
        Window_ClearAndCopyToVRAM(&report->windows[i]);
        Window_Remove(&report->windows[i]);
    }

    String_Free(report->playerName);
    String_Free(report->pageFormat);
    String_Free(report->cancelText);
    String_Free(report->text);
    String_Free(report->format);
    StringTemplate_Free(report->strTemplate);
    MessageLoader_Free(report->msgLoader);
    Font_Free(FONT_SUBSCREEN);

    for (int i = NUM_FRAMES - 1; i >= 0; i--) {
        Heap_Free(report->frames[i].data);
    }

    for (int i = 0; i < NELEMS(sLayers); i++) {
        Bg_FreeTilemapBuffer(report->bgConfig, sLayers[NELEMS(sLayers) - 1 - i].layer);
    }

    Heap_Free(report->bgConfig);
    GX_SetDispSelect(GX_DISP_SELECT_MAIN_SUB); // the main engine back on the top screen
}

// ov113_021E62B0
static void VBlank(void *data)
{
    UnownReport *report = data;

    if (report->spriteSystem != NULL) {
        SpriteSystem_TransferOam();
    }

    VramTransfer_Process();
    Bg_RunScheduledUpdates(report->bgConfig);
    OS_SetIrqCheckFlag(OS_IE_V_BLANK);
}

// ov113_021E6300: the main engine on the bottom screen, three layers on each
static void SetUpBgs(UnownReport *report)
{
    GXLayers_SetBanks(&sBanks);
    report->bgConfig = BgConfig_New(report->heapID);
    SetAllGraphicsModes(&sGraphicsModes);
    GX_SetDispSelect(GX_DISP_SELECT_SUB_MAIN);

    for (int i = 0; i < NELEMS(sLayers); i++) {
        BgTemplate template = {
            .x = 0,
            .y = 0,
            .bufferSize = 0x800,
            .baseTile = 0,
            .screenSize = BG_SCREEN_SIZE_256x256,
            .colorMode = GX_BG_COLORMODE_16,
            .screenBase = sLayers[i].screenBase,
            .charBase = sLayers[i].charBase,
            .bgExtPltt = GX_BG_EXTPLTT_01,
            .priority = sLayers[i].priority,
            .areaOver = 0,
            .mosaic = FALSE,
        };

        Bg_InitFromTemplate(report->bgConfig, sLayers[i].layer, &template, BG_TYPE_STATIC);
        Bg_ClearTilemap(report->bgConfig, sLayers[i].layer);
    }

    for (int i = 0; i < NELEMS(sLayers); i++) {
        Bg_ClearTilesRange(sLayers[i].layer, 32, 0, report->heapID);
    }
}

// ov113_021E64DC
static void LoadFrame(UnownReport *report, PageFrame *frame, NARC *narc, u32 member)
{
    frame->data = Graphics_GetScrnDataFromOpenNARC(narc, member, TRUE, &frame->screen, report->heapID);
    frame->width = frame->screen->screenWidth / 8;
    frame->height = frame->screen->screenHeight / 8;
}

// ov113_021E650C: the screens' palettes, tiles and backgrounds; the pages' frames; the text's palette
static void LoadGraphics(UnownReport *report)
{
    NARC *narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__UNOWN_REPORT, report->heapID);

    Graphics_LoadPaletteFromOpenNARC(narc, GFX_BOTTOM_PLTT, PAL_LOAD_MAIN_BG, 0, 0, report->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_BOTTOM_TILES, report->bgConfig, BG_LAYER_MAIN_3, 0, 0, TRUE, report->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_BOTTOM_TILEMAP, report->bgConfig, BG_LAYER_MAIN_3, 0, 0, TRUE, report->heapID);
    Graphics_LoadPaletteFromOpenNARC(narc, GFX_TOP_PLTT, PAL_LOAD_SUB_BG, 0, 0, report->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_TOP_TILES, report->bgConfig, BG_LAYER_SUB_3, 0, 0, TRUE, report->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_TOP_TILEMAP, report->bgConfig, BG_LAYER_SUB_3, 0, 0, TRUE, report->heapID);

    for (int i = 0; i < NUM_FRAMES; i++) {
        LoadFrame(report, &report->frames[i], narc, GFX_COVER_TOP + i);
    }

    NARC_dtor(narc);
    Font_LoadScreenIndicatorsPalette(PAL_LOAD_MAIN_BG, PLTT_OFFSET(12), report->heapID);
    Font_LoadScreenIndicatorsPalette(PAL_LOAD_SUB_BG, PLTT_OFFSET(12), report->heapID);
}

// ov113_021E6680: HeartGold's message bank 1, the strings
static void SetUpText(UnownReport *report)
{
    Font_InitManager(FONT_SUBSCREEN, report->heapID);
    report->msgLoader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0001, report->heapID);
    report->strTemplate = StringTemplate_New(16, 16, report->heapID);
    report->format = String_Init(0x200, report->heapID);
    report->text = String_Init(0x200, report->heapID);
    report->cancelText = MessageLoader_GetNewString(report->msgLoader, msg_0001_00000);
    report->pageFormat = MessageLoader_GetNewString(report->msgLoader, msg_0001_00005);
    report->playerName = TrainerInfo_NameNewString(SaveData_GetTrainerInfo(report->args->saveData), report->heapID);
}

// ov113_021E671C
static void SetUpWindows(UnownReport *report)
{
    for (int i = 0; i < NUM_WINDOWS; i++) {
        Window_AddFromTemplate(report->bgConfig, &report->windows[i], &sWindowTemplates[i]);
        Window_FillTilemap(&report->windows[i], 0);
    }
}

// ov113_021E677C and ov113_021E69CC: the buttons (from the archive) and the 14 Unown icons, 7 on each screen
static void SetUpSprites(UnownReport *report)
{
    static const SpriteResourceCapacities sButtonCapacities = { 1, 1, 1, 1, 0, 0 };
    static const SpriteResourceCapacities sIconCapacities = { ICONS_PER_PAGE, 1, 1, 1, 0, 0 }; // ov113_021E6BB8

    VramTransfer_New(32, report->heapID);
    report->spriteSystem = SpriteSystem_Alloc(report->heapID);
    SpriteSystem_Init(report->spriteSystem, &sOamTemplate, &sCharTransfer, 2);
    Utility_Clear2DMainOAM(report->heapID);
    Utility_Clear2DSubOAM(report->heapID);

    report->buttonManager = SpriteManager_New(report->spriteSystem);
    SpriteSystem_InitSprites(report->spriteSystem, report->buttonManager, ICONS_PER_PAGE + NUM_SPRITES);
    SpriteSystem_InitManagerWithCapacities(report->spriteSystem, report->buttonManager, &sButtonCapacities);

    NARC *narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__UNOWN_REPORT, report->heapID);

    SpriteSystem_LoadPlttResObjFromOpenNarc(report->spriteSystem, report->buttonManager, narc, GFX_SPRITE_PLTT, FALSE, 3, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCharResObjFromOpenNarc(report->spriteSystem, report->buttonManager, narc, GFX_SPRITE_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCellResObjFromOpenNarc(report->spriteSystem, report->buttonManager, narc, GFX_SPRITE_CELL, TRUE, 0);
    SpriteSystem_LoadAnimResObjFromOpenNarc(report->spriteSystem, report->buttonManager, narc, GFX_SPRITE_ANIM, TRUE, 0);
    NARC_dtor(narc);

    SpriteManager *buttons = report->buttonManager;
    buttons->resourceHeaders = SpriteResourcesHeaderList_NewFromResdat(sButtonHeaders, report->heapID,
        buttons->ownedResources[SPRITE_RESOURCE_CHAR], buttons->ownedResources[SPRITE_RESOURCE_PLTT],
        buttons->ownedResources[SPRITE_RESOURCE_CELL], buttons->ownedResources[SPRITE_RESOURCE_ANIM], NULL, NULL);

    report->iconManager = SpriteManager_New(report->spriteSystem);
    SpriteSystem_InitManagerWithCapacities(report->spriteSystem, report->iconManager, &sIconCapacities);
    report->iconManager->sprites = report->buttonManager->sprites; // one sprite list, the buttons' (as HeartGold's)

    report->iconNarc = NARC_ctor(NARC_INDEX_POKETOOL__ICONGRA__PL_POKE_ICON, report->heapID);
    SpriteSystem_LoadPlttResObjFromOpenNarc(report->spriteSystem, report->iconManager, report->iconNarc, PokeIconPalettesFileIndex(), FALSE, 3, NNS_G2D_VRAM_TYPE_MAX, 1);
    SpriteSystem_LoadCellResObjFromOpenNarc(report->spriteSystem, report->iconManager, report->iconNarc, PokeIconCellsFileIndex(), FALSE, 1);
    SpriteSystem_LoadAnimResObj(report->spriteSystem, report->iconManager, NARC_INDEX_POKETOOL__ICONGRA__PL_POKE_ICON, PokeIconAnimationFileIndex(), FALSE, 1);

    for (int i = 0; i < ICONS_PER_PAGE; i++) { // A to N to start, each replaced by the page's
        SpriteSystem_LoadCharResObjFromOpenNarc(report->spriteSystem, report->iconManager, report->iconNarc,
            PokeIconSpriteIndex(SPECIES_UNOWN, FALSE, i), FALSE,
            i < ICONS_PER_SCREEN ? NNS_G2D_VRAM_TYPE_2DSUB : NNS_G2D_VRAM_TYPE_2DMAIN, i + 1);
    }

    for (int i = 0; i < NUM_SPRITES; i++) {
        report->sprites[i] = SpriteSystem_NewSpriteFromResourceHeader(report->spriteSystem, report->buttonManager, &sButtonTemplates[i]);
        Sprite_SetExplicitPaletteOffsetAutoAdjust(report->sprites[i], 0); // HeartGold's palette mode 1
        Sprite_SetDrawFlag(report->sprites[i], TRUE);
        Sprite_SetAnimateFlag(report->sprites[i], TRUE);
        Sprite_SetExplicitPriority(report->sprites[i], 2); // HeartGold's Sprite_SetPriority: the BG priority
    }

    SpriteTemplate template;

    MI_CpuFill8(&template, 0, sizeof(SpriteTemplate));
    template.x = 40;
    template.plttIdx = PokeIconPaletteIndex(SPECIES_UNOWN, 0, FALSE);
    template.resources[SPRITE_RESOURCE_PLTT] = 1;
    template.resources[SPRITE_RESOURCE_CELL] = 1;
    template.resources[SPRITE_RESOURCE_ANIM] = 1;
    template.resources[SPRITE_RESOURCE_MULTI_CELL] = SPRITE_RESOURCE_NONE;
    template.resources[SPRITE_RESOURCE_MULTI_ANIM] = SPRITE_RESOURCE_NONE;
    template.bgPriority = 1;
    template.vramTransfer = FALSE;

    for (int i = 0; i < ICONS_PER_PAGE; i++) {
        if (i < ICONS_PER_SCREEN) {
            template.y = 29 + 24 * i;
            template.vramType = NNS_G2D_VRAM_TYPE_2DSUB;
        } else {
            template.y = 13 + 24 * (i - ICONS_PER_SCREEN);
            template.vramType = NNS_G2D_VRAM_TYPE_2DMAIN;
        }

        template.resources[SPRITE_RESOURCE_CHAR] = i + 1;
        report->icons[i] = SpriteSystem_NewSprite(report->spriteSystem, report->iconManager, &template);
        ManagedSprite_SetDrawFlag(report->icons[i], FALSE);
    }

    GXLayers_EngineAToggleLayers(GX_PLANEMASK_OBJ, TRUE);
    GXLayers_EngineBToggleLayers(GX_PLANEMASK_OBJ, TRUE);
}

// ov113_021E6AB0 and ov113_021E6930. The button manager is loaded by capacities, not from resource lists, so it's
// freed as the icons' is (DestroySpriteManager would free its unset lists' table: the Berry Pots' freeze); the icons'
// manager lets go of the one sprite list, which the buttons' deletes.
static void FreeSprites(UnownReport *report)
{
    for (int i = 0; i < ICONS_PER_PAGE; i++) {
        if (report->icons[i] != NULL) {
            Sprite_DeleteAndFreeResources(report->icons[i]);
        }
    }

    for (int i = 0; i < NUM_SPRITES; i++) {
        if (report->sprites[i] != NULL) {
            Sprite_Delete(report->sprites[i]);
        }
    }

    report->iconManager->sprites = NULL;
    SpriteSystem_FreeResourcesAndManager(report->spriteSystem, report->iconManager);
    SpriteManager_FreeResourceHeaders(report->buttonManager);
    SpriteSystem_FreeResourcesAndManager(report->spriteSystem, report->buttonManager);
    report->iconManager = NULL;
    report->buttonManager = NULL;
    NARC_dtor(report->iconNarc);
    SpriteSystem_Free(report->spriteSystem);
    report->spriteSystem = NULL;
    VramTransfer_Free();
    Utility_Clear2DMainOAM(report->heapID);
}

// ov113_021E5E64: CANCEL, and its text centred on it
static void DrawCancel(UnownReport *report, u32 anim)
{
    Window *window = &report->windows[WINDOW_CANCEL];

    Sprite_SetAnim(report->sprites[SPRITE_CANCEL], anim);
    Sprite_RestartAnim(report->sprites[SPRITE_CANCEL]);
    Window_FillTilemap(window, 0);
    u32 width = Font_CalcStringWidth(FONT_SUBSCREEN, report->cancelText, 0);
    Text_AddPrinterWithParamsAndColor(window, FONT_SUBSCREEN, report->cancelText, (48 - width) / 2, 0, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(7, 15, 0), NULL);
    Window_ScheduleCopyToVRAM(window);
}

// ov113_021E6238: a page's frame over a screen's frame layer
static void ShowFrame(UnownReport *report, const PageFrame *frame, u8 layer)
{
    Bg_CopyToTilemapRect(report->bgConfig, layer, 0, 0, 32, 24, frame->screen->rawData, 0, 0, frame->width, frame->height);
    Bg_ScheduleTilemapTransfer(report->bgConfig, layer);
}

static void HideIcons(UnownReport *report)
{
    for (int i = 0; i < ICONS_PER_PAGE; i++) {
        ManagedSprite_SetDrawFlag(report->icons[i], FALSE);
    }
}

// ov113_021E5FC0: the cover: the title and the player's name above, the number of Unown kinds below
static void DrawCover(UnownReport *report)
{
    ShowFrame(report, &report->frames[FRAME_COVER_TOP], BG_LAYER_SUB_2);
    ShowFrame(report, &report->frames[FRAME_COVER_BOTTOM], BG_LAYER_MAIN_2);
    HideIcons(report);

    MessageLoader_GetString(report->msgLoader, msg_0001_00001, report->text);
    PrintAt(&report->windows[WINDOW_TOP], FONT_SYSTEM, report->text, 0, 56);
    PrintAt(&report->windows[WINDOW_TOP], FONT_SYSTEM, report->playerName, 176 - Font_CalcStringWidth(FONT_SYSTEM, report->playerName, 0), 72);
    MessageLoader_GetString(report->msgLoader, msg_0001_00003, report->text);
    PrintAt(&report->windows[WINDOW_BOTTOM], FONT_SYSTEM, report->text, 4, 60);
    MessageLoader_GetString(report->msgLoader, msg_0001_00004, report->format);
    StringTemplate_SetNumber(report->strTemplate, 0, report->numUnown, 2, PADDING_MODE_SPACES, CHARSET_MODE_EN);
    StringTemplate_Format(report->strTemplate, report->text, report->format);
    PrintAt(&report->windows[WINDOW_BOTTOM], FONT_SYSTEM, report->text, 4, 76);
}

// ov113_021E6084: an Unown page: 7 on each screen, each its icon and its word
static void DrawUnownPage(UnownReport *report, u8 unownPage)
{
    ShowFrame(report, &report->frames[FRAME_UNOWN_TOP], BG_LAYER_SUB_2);
    ShowFrame(report, &report->frames[FRAME_UNOWN_BOTTOM], BG_LAYER_MAIN_2);

    for (int i = 0; i < ICONS_PER_PAGE; i++) {
        int n = unownPage * ICONS_PER_PAGE + i;

        if (n >= report->numUnown) {
            ManagedSprite_SetDrawFlag(report->icons[i], FALSE);
            continue;
        }

        ManagedSprite_SetDrawFlag(report->icons[i], TRUE);
        SpriteSystem_ReplaceCharResObjFromOpenNarc(report->spriteSystem, report->iconManager, report->iconNarc,
            PokeIconSpriteIndex(SPECIES_UNOWN, FALSE, report->forms[n]), FALSE, i + 1);
        MessageLoader_GetString(report->msgLoader, msg_0001_00020 + report->forms[n], report->text);

        if (i < ICONS_PER_SCREEN) {
            PrintAt(&report->windows[WINDOW_TOP], FONT_SYSTEM, report->text, 48, 24 * i);
        } else {
            PrintAt(&report->windows[WINDOW_BOTTOM], FONT_SYSTEM, report->text, 48, 24 * (i - ICONS_PER_SCREEN));
        }
    }
}

// ov113_021E613C: a report spread, its halves shown once the researchers reached them; the floor's words in the Unown
// font
static void DrawReportHalf(UnownReport *report, const ReportHalf *half, Window *window)
{
    if (half->level > report->reportLevel) {
        return;
    }

    for (int i = 0; i < half->count; i++) {
        MessageLoader_GetString(report->msgLoader, half->message + i, report->text);

        if (half->message + i == REPORT_UNOWN_FONT_MESSAGE) {
            PrintAt(window, FONT_UNOWN, report->text, 4, 0);
        } else {
            PrintAt(window, FONT_SYSTEM, report->text, 4, 24);
        }
    }
}

static void DrawReportPage(UnownReport *report, u8 spread)
{
    if (spread == 0) { // the frames stay for the spreads after it, as the pages turn one at a time
        ShowFrame(report, &report->frames[FRAME_REPORT_TOP], BG_LAYER_SUB_2);
        ShowFrame(report, &report->frames[FRAME_REPORT_BOTTOM], BG_LAYER_MAIN_2);
        HideIcons(report);
    }

    DrawReportHalf(report, &sReportSpreads[spread][0], &report->windows[WINDOW_TOP]);
    DrawReportHalf(report, &sReportSpreads[spread][1], &report->windows[WINDOW_BOTTOM]);
}

// ov113_021E5DA4: the page, its number, the arrows
static void DrawPage(UnownReport *report, u8 page)
{
    Window_FillTilemap(&report->windows[WINDOW_TOP], 0);
    Window_FillTilemap(&report->windows[WINDOW_BOTTOM], 0);
    Window_FillTilemap(&report->windows[WINDOW_PAGE], 0);

    if (page == 0) {
        DrawCover(report);
    } else if (page - 1 < report->unownPages) {
        DrawUnownPage(report, page - 1);
    } else {
        DrawReportPage(report, page - report->unownPages - 1);
    }

    StringTemplate_SetNumber(report->strTemplate, 0, report->page + 1, 1, PADDING_MODE_NONE, CHARSET_MODE_EN);
    StringTemplate_SetNumber(report->strTemplate, 1, report->pageCount, 1, PADDING_MODE_NONE, CHARSET_MODE_EN);
    StringTemplate_Format(report->strTemplate, report->text, report->pageFormat);
    Text_AddPrinterWithParamsAndColor(&report->windows[WINDOW_PAGE], FONT_SYSTEM, report->text, 0, 0, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(15, 2, 0), NULL);

    Window_ScheduleCopyToVRAM(&report->windows[WINDOW_TOP]);
    Window_ScheduleCopyToVRAM(&report->windows[WINDOW_BOTTOM]);
    Window_ScheduleCopyToVRAM(&report->windows[WINDOW_PAGE]);
    UpdateArrows(report);
#ifdef SOVEREIGN_TEST
    gCompleteTestUnownReportPage = page + 1;
#endif
}

// ov113_021E6B1C: an arrow greyed at either end of the book
static void UpdateArrows(UnownReport *report)
{
    BOOL first = report->pageCount == 1 || report->page == 0;
    BOOL last = report->pageCount == 1 || report->page == report->pageCount - 1;

    Sprite_SetAnim(report->sprites[SPRITE_PREV], first ? ANIM_PREV_OFF : ANIM_PREV);
    Sprite_SetAnim(report->sprites[SPRITE_NEXT], last ? ANIM_NEXT_OFF : ANIM_NEXT);
}

// ov113_021E5ED0
static int Select(UnownReport *report, int input)
{
    switch (input) {
    case INPUT_CANCEL:
        Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
        DrawCancel(report, ANIM_CANCEL_PRESSED);
        return STATE_CLOSE;
    case INPUT_PREV_PAGE:
        if (report->page == 0) {
            return STATE_INPUT;
        }

        report->page--;
        Sprite_SetAnim(report->sprites[SPRITE_PREV], ANIM_PREV_PRESSED);
        Sound_PlayEffect(SE_CONFIRM_sseq_3); // HeartGold's SEQ_SE_DP_SELECT
        return STATE_TURN_PAGE;
    case INPUT_NEXT_PAGE:
        if (report->page >= report->pageCount - 1) {
            return STATE_INPUT;
        }

        report->page++;
        Sprite_SetAnim(report->sprites[SPRITE_NEXT], ANIM_NEXT_PRESSED);
        Sound_PlayEffect(SE_CONFIRM_sseq_3); // HeartGold's SEQ_SE_DP_SELECT
        return STATE_TURN_PAGE;
    }

    return STATE_INPUT;
}

// ov113_021E5D60: a touch first (ov113_021E5F94), else B, UP or DOWN (ov113_021E5F48)
static int HandleInput(UnownReport *report)
{
    int touched = TouchScreen_CheckRectanglePressed(sTouchRects);

    if (touched != TOUCHSCREEN_INPUT_NONE) {
        report->menuInputState = 1; // the touch screen
        return Select(report, touched);
    }

    if (gSystem.pressedKeys & (PAD_BUTTON_A | PAD_BUTTON_B | PAD_KEY_RIGHT | PAD_KEY_LEFT | PAD_KEY_UP | PAD_KEY_DOWN | PAD_BUTTON_X | PAD_BUTTON_Y)) {
        report->menuInputState = 0; // the buttons
    }

    if (gSystem.pressedKeys & PAD_BUTTON_B) {
        return Select(report, INPUT_CANCEL);
    } else if (gSystem.pressedKeys & PAD_KEY_UP) {
        return Select(report, INPUT_PREV_PAGE);
    } else if (gSystem.pressedKeys & PAD_KEY_DOWN) {
        return Select(report, INPUT_NEXT_PAGE);
    }

    return STATE_INPUT;
}
