#include "applications/complete_alph_puzzle.h"

#include <nitro.h>
#include <string.h>

#include "constants/graphics.h"
#include "constants/heap.h"
#include "generated/text_banks.h"
#include "generated/vars_flags.h"

#include "bg_window.h"
#include "font.h"
#include "game_options.h"
#include "graphics.h"
#include "gx_layers.h"
#include "heap.h"
#include "message.h"
#include "overlay_manager.h"
#include "palette.h"
#include "render_oam.h"
#include "render_window.h"
#include "save_player.h"
#include "screen_fade.h"
#include "sound_playback.h"
#include "sprite.h"
#include "sprite_system.h"
#include "string_gf.h"
#include "sys_task.h"
#include "sys_task_manager.h"
#include "system.h"
#include "text.h"
#include "touch_screen.h"
#include "vars_flags.h"
#include "vram_transfer.h"
#include "yes_no_touch_menu.h"

#include "res/graphics/alph_puzzle/alph_puzzle.naix"

// Sovereign Complete: HeartGold's Ruins of Alph puzzles (its alph_puzzle.c), with its graphics
// (res/graphics/alph_puzzle) and text (msg_0002), on Platinum's libraries. Sixteen stone panels, some fixed, lie on a
// 6x6 board; touching a loose one and letting go turns it, and dragging it moves it to a free square (not a corner).
// The picture is whole when every panel sits in the middle 4x4 the right way up. The bottom screen is the board, the
// top one the puzzle's hint. HeartGold's own sound effects aren't in the sound archive, so Platinum's stand in.

#define PUZZLE_HEAP_ID HEAP_ID_DIPLOMA // the diploma's: its app can't run at the same time

#define BOARD_TILES_WIDE 6
#define BOARD_TILES_HIGH 6
#define NUM_PANELS       16
#define PANEL_SIZE       32 // pixels
#define BOARD_LEFT       32

#define SE_PANEL_SELECT SEQ_SE_DP_BOX02_sseq // HeartGold's SEQ_SE_GS_SEKIBAN_SENTAKU
#define SE_PANEL_BACK   SEQ_SE_DP_BOX01_sseq
#define SE_PANEL_TURN   SEQ_SE_DP_SELECT78_sseq // SEQ_SE_GS_SEKIBAN_KAITEN
#define SE_SOLVED       SEQ_SE_DP_PIRORIRO2_sseq // SEQ_SE_GS_PUZZLETOKU
#define SE_QUIT         SEQ_SE_DP_DECIDE_sseq

// msg_0002
#define TEXT_QUIT         0
#define TEXT_FIRST_HINT   1
#define TEXT_CONFIRM_QUIT 5

enum PuzzleState {
    STATE_FADE_IN = 0,
    STATE_WAIT_FOR_INPUT,
    STATE_PICK_UP_PANEL,
    STATE_HOLD_PANEL,
    STATE_TURN_PANEL,
    STATE_QUIT,
    STATE_SOLVED,
    STATE_FADE_OUT,
    STATE_END,
};

enum PuzzleSprite {
    SPRITE_QUIT_BUTTON = 0, // HeartGold's drop cursor: the QUIT button's animation
    SPRITE_ORIGIN, // where the held panel came from
    SPRITE_FIRST_PANEL,
    SPRITE_MAX = SPRITE_FIRST_PANEL + NUM_PANELS,
};

enum PuzzleWindow {
    WINDOW_QUIT_BUTTON = 0,
    WINDOW_CONFIRM_QUIT,
    WINDOW_HINT,
    WINDOW_MAX,
};

// The sprite resources (HeartGold's resdat lists 8 to 11 and 74)
enum PuzzleResource {
    RESOURCE_CURSORS = 0,
    RESOURCE_PANELS,
};

typedef struct Panel {
    u8 x;
    u8 y;
    u8 rotation;
    u8 isFixed;
    ManagedSprite *sprite;
} Panel;

typedef struct AlphPuzzle {
    enum HeapID heapID;
    CompleteAlphPuzzleArgs *args;
    u16 subState;
    u16 timer;
    u8 puzzle;
    u8 quitAnimActive;
    u8 selectedPanelIndex;
    u8 hoverTileX;
    u8 hoverTileY;
    u8 textPrinterID;
    u8 textSpeed;
    u8 frame;
    u8 solved;
    s16 hoverPixelX;
    s16 hoverPixelY;
    BgConfig *bgConfig;
    PaletteData *paletteData;
    MessageLoader *messageLoader;
    String *quitText;
    String *hintText;
    String *confirmQuitText;
    Window windows[WINDOW_MAX];
    YesNoTouchMenu *yesNoMenu;
    SpriteSystem *spriteSys;
    SpriteManager *spriteMan;
    ManagedSprite *sprites[SPRITE_MAX];
    NNSG2dScreenData *highlightScreen;
    void *highlightScreenFile;
    Panel panels[NUM_PANELS];
    Panel *selectedPanel;
} AlphPuzzle;

typedef struct PuzzleSquare {
    u8 panel : 5; // 1 to 16; 0: none
    u8 rotation : 2;
    u8 isFixed : 1;
} PuzzleSquare;

#define BLANK { 0, 0, FALSE }

// HeartGold's four puzzles, as the board starts
static const PuzzleSquare sPuzzles[COMPLETE_ALPH_PUZZLE_MAX][BOARD_TILES_HIGH][BOARD_TILES_WIDE] = {
    [COMPLETE_ALPH_PUZZLE_KABUTO] = {
        { BLANK, BLANK, BLANK, BLANK, BLANK, BLANK },
        { { 6, 1, FALSE }, { 1, 0, TRUE }, BLANK, { 3, 0, TRUE }, { 4, 0, TRUE }, BLANK },
        { BLANK, { 5, 0, TRUE }, BLANK, { 7, 0, TRUE }, { 8, 0, TRUE }, { 11, 2, FALSE } },
        { BLANK, BLANK, { 10, 0, TRUE }, BLANK, { 12, 0, TRUE }, BLANK },
        { { 2, 3, FALSE }, { 13, 0, TRUE }, { 14, 0, TRUE }, { 15, 0, TRUE }, { 16, 0, TRUE }, BLANK },
        { BLANK, BLANK, BLANK, BLANK, { 9, 1, FALSE }, BLANK },
    },
    [COMPLETE_ALPH_PUZZLE_AERODACTYL] = {
        { BLANK, { 10, 3, FALSE }, BLANK, { 14, 2, FALSE }, BLANK, BLANK },
        { BLANK, BLANK, BLANK, { 3, 0, TRUE }, { 4, 0, TRUE }, BLANK },
        { BLANK, BLANK, BLANK, { 7, 0, TRUE }, { 8, 0, TRUE }, { 16, 3, FALSE } },
        { { 2, 3, FALSE }, { 9, 0, TRUE }, BLANK, { 11, 0, TRUE }, { 12, 0, TRUE }, BLANK },
        { BLANK, { 13, 0, TRUE }, BLANK, { 15, 0, TRUE }, BLANK, { 6, 2, FALSE } },
        { BLANK, BLANK, { 1, 2, FALSE }, BLANK, { 5, 1, FALSE }, BLANK },
    },
    [COMPLETE_ALPH_PUZZLE_OMANYTE] = {
        { BLANK, BLANK, { 11, 1, FALSE }, BLANK, { 10, 0, FALSE }, BLANK },
        { { 9, 0, FALSE }, BLANK, { 2, 0, TRUE }, { 3, 0, TRUE }, { 4, 0, TRUE }, BLANK },
        { BLANK, { 5, 0, TRUE }, { 6, 0, TRUE }, BLANK, BLANK, { 14, 2, FALSE } },
        { { 8, 0, FALSE }, BLANK, BLANK, BLANK, BLANK, { 13, 3, FALSE } },
        { { 1, 3, FALSE }, BLANK, BLANK, { 15, 0, TRUE }, { 16, 0, TRUE }, BLANK },
        { BLANK, { 7, 2, FALSE }, { 12, 1, FALSE }, BLANK, BLANK, BLANK },
    },
    [COMPLETE_ALPH_PUZZLE_HO_OH] = {
        { BLANK, BLANK, { 9, 0, FALSE }, { 14, 3, FALSE }, { 1, 3, FALSE }, BLANK },
        { { 15, 2, FALSE }, BLANK, BLANK, { 3, 0, TRUE }, { 4, 0, TRUE }, BLANK },
        { { 13, 2, FALSE }, { 5, 0, TRUE }, { 6, 0, TRUE }, { 7, 0, TRUE }, BLANK, { 10, 3, FALSE } },
        { { 2, 3, FALSE }, BLANK, BLANK, BLANK, { 12, 0, TRUE }, BLANK },
        { BLANK, BLANK, BLANK, BLANK, { 16, 0, TRUE }, { 11, 3, FALSE } },
        { BLANK, { 5, 2, FALSE }, { 8, 1, FALSE }, BLANK, BLANK, BLANK },
    },
};

static const u16 sSolvedFlags[COMPLETE_ALPH_PUZZLE_MAX] = {
    FLAG_HGSS_SYS_ALPH_PUZZLE_KABUTO,
    FLAG_HGSS_SYS_ALPH_PUZZLE_AERODACTYL,
    FLAG_HGSS_SYS_ALPH_PUZZLE_OMANYTE,
    FLAG_HGSS_SYS_ALPH_PUZZLE_HO_OH,
};

// The board's corners take no panel
static const u8 sCorners[4][2] = { { 0, 0 }, { 5, 0 }, { 0, 5 }, { 5, 5 } };

static const TouchScreenRect sQuitButtonRect[] = {
    { .rect = { 169, 191, 209, 255 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR, 0, 0, 0 } },
};

// A turned panel's sprite sits a pixel off, as HeartGold places it
static const s8 sRotationOffsets[4][2] = { { 0, 0 }, { -1, 0 }, { -1, -1 }, { 0, -1 } };

static const TextColor sQuitButtonColors[3] = {
    TEXT_COLOR(1, 2, 0),
    TEXT_COLOR(3, 4, 0),
    TEXT_COLOR(5, 6, 0),
};

static void ScreensOff(void)
{
    SetVBlankCallback(NULL, NULL);
    SetHBlankCallback(NULL, NULL);
    GXLayers_DisableEngineALayers();
    GXLayers_DisableEngineBLayers();
    GX_SetVisiblePlane(0);
    GXS_SetVisiblePlane(0);
    SetScreenColorBrightness(DS_SCREEN_MAIN, COLOR_BLACK);
    SetScreenColorBrightness(DS_SCREEN_SUB, COLOR_BLACK);
}

static void VBlankCallback(void *data)
{
    AlphPuzzle *puzzle = data;

    if (puzzle->paletteData != NULL) {
        PaletteData_CommitFadedBuffers(puzzle->paletteData);
    }

    if (puzzle->spriteSys != NULL) {
        SpriteSystem_TransferOam();
    }

    VramTransfer_Process();
    Bg_RunScheduledUpdates(puzzle->bgConfig);
    OS_SetIrqCheckFlag(OS_IE_V_BLANK);
}

static void InitPanels(AlphPuzzle *puzzle)
{
    for (int y = 0; y < BOARD_TILES_HIGH; y++) {
        for (int x = 0; x < BOARD_TILES_WIDE; x++) {
            const PuzzleSquare *square = &sPuzzles[puzzle->puzzle][y][x];

            if (square->panel != 0 && square->panel <= NUM_PANELS) {
                Panel *panel = &puzzle->panels[square->panel - 1];

                panel->x = x;
                panel->y = y;
                panel->rotation = square->rotation;
                panel->isFixed = square->isFixed;
            }
        }
    }
}

// HeartGold's BG layers: the board (main 3) and the dragged panel's highlight (main 2), the QUIT button's label (main
// 2) and the quit question (main 0); on the top screen, the frame (sub 3 and 2) and the hint (sub 0)
static void InitBgs(AlphPuzzle *puzzle)
{
    GXBanks banks = {
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

    GXLayers_SetBanks(&banks);
    puzzle->bgConfig = BgConfig_New(puzzle->heapID);

    GraphicsModes graphicsModes = {
        .displayMode = GX_DISPMODE_GRAPHICS,
        .mainBgMode = GX_BGMODE_0,
        .subBgMode = GX_BGMODE_0,
        .bg0As2DOr3D = GX_BG0_AS_2D,
    };

    SetAllGraphicsModes(&graphicsModes);
    GX_SetDispSelect(GX_DISP_SELECT_SUB_MAIN); // the main engine on the touch screen

    static const struct {
        u8 layer;
        u8 screenBase;
        u8 charBase;
        u8 priority;
    } sLayers[] = {
        { BG_LAYER_SUB_0, GX_BG_SCRBASE_0xf800, GX_BG_CHARBASE_0x10000, 1 },
        { BG_LAYER_SUB_2, GX_BG_SCRBASE_0xf000, GX_BG_CHARBASE_0x00000, 2 },
        { BG_LAYER_SUB_3, GX_BG_SCRBASE_0xe800, GX_BG_CHARBASE_0x00000, 3 },
        { BG_LAYER_MAIN_0, GX_BG_SCRBASE_0xf800, GX_BG_CHARBASE_0x10000, 0 },
        { BG_LAYER_MAIN_2, GX_BG_SCRBASE_0xf000, GX_BG_CHARBASE_0x00000, 2 },
        { BG_LAYER_MAIN_3, GX_BG_SCRBASE_0xe800, GX_BG_CHARBASE_0x00000, 3 },
    };

    for (int i = 0; i < (int)NELEMS(sLayers); i++) {
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

        Bg_InitFromTemplate(puzzle->bgConfig, sLayers[i].layer, &template, BG_TYPE_STATIC);
        Bg_ClearTilemap(puzzle->bgConfig, sLayers[i].layer);
    }

    Bg_ClearTilesRange(BG_LAYER_SUB_0, TILE_SIZE_4BPP, 0, puzzle->heapID);
    Bg_ClearTilesRange(BG_LAYER_SUB_3, TILE_SIZE_4BPP, 0, puzzle->heapID);
    Bg_ClearTilesRange(BG_LAYER_MAIN_0, TILE_SIZE_4BPP, 0, puzzle->heapID);
    Bg_ClearTilesRange(BG_LAYER_MAIN_3, TILE_SIZE_4BPP * 2, 0, puzzle->heapID);
}

static void FreeBgs(AlphPuzzle *puzzle)
{
    static const u8 sLayers[] = { BG_LAYER_MAIN_3, BG_LAYER_MAIN_2, BG_LAYER_MAIN_0, BG_LAYER_SUB_3, BG_LAYER_SUB_2, BG_LAYER_SUB_0 };

    for (int i = 0; i < (int)NELEMS(sLayers); i++) {
        Bg_ToggleLayer(sLayers[i], FALSE);
        Bg_FreeTilemapBuffer(puzzle->bgConfig, sLayers[i]);
    }

    Heap_Free(puzzle->bgConfig);
    GX_SetDispSelect(GX_DISP_SELECT_MAIN_SUB);
}

static void LoadBgGraphics(AlphPuzzle *puzzle)
{
    enum NarcID narc = NARC_INDEX_APPLICATION__ANNON__PUZZLE_GRA;

    Graphics_LoadPalette(narc, puzzle_gra_00000010_NCLR, PAL_LOAD_MAIN_BG, 0, 0, puzzle->heapID);
    Graphics_LoadPalette(narc, puzzle_gra_00000010_NCLR, PAL_LOAD_SUB_BG, 0, 0, puzzle->heapID);
    Graphics_LoadTilesToBgLayer(narc, puzzle_gra_00000011_NCGR, puzzle->bgConfig, BG_LAYER_SUB_3, 0, 0, FALSE, puzzle->heapID);
    Graphics_LoadTilemapToBgLayer(narc, puzzle_gra_00000014_NSCR, puzzle->bgConfig, BG_LAYER_SUB_3, 0, 0, FALSE, puzzle->heapID);
    Graphics_LoadTilemapToBgLayer(narc, puzzle_gra_00000015_NSCR, puzzle->bgConfig, BG_LAYER_SUB_2, 0, 0, FALSE, puzzle->heapID);
    Graphics_LoadTilesToBgLayer(narc, puzzle_gra_00000011_NCGR, puzzle->bgConfig, BG_LAYER_MAIN_3, 0, 0, FALSE, puzzle->heapID);
    Graphics_LoadTilemapToBgLayer(narc, puzzle_gra_00000012_NSCR, puzzle->bgConfig, BG_LAYER_MAIN_3, 0, 0, FALSE, puzzle->heapID);
    puzzle->highlightScreenFile = Graphics_GetScrnData(narc, puzzle_gra_00000013_NSCR, FALSE, &puzzle->highlightScreen, puzzle->heapID);

    // HeartGold's text palette in slot 4 and the message box's in 5, over the puzzle's
    Font_LoadTextPalette(PAL_LOAD_MAIN_BG, PLTT_OFFSET(4), puzzle->heapID);
    LoadMessageBoxGraphics(puzzle->bgConfig, BG_LAYER_MAIN_0, 1, 5, puzzle->frame, puzzle->heapID);
}

static void LoadText(AlphPuzzle *puzzle)
{
    puzzle->messageLoader = MessageLoader_Init(MSG_LOADER_PRELOAD_ENTIRE_BANK, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0002, puzzle->heapID);
    puzzle->quitText = MessageLoader_GetNewString(puzzle->messageLoader, TEXT_QUIT);
    puzzle->hintText = MessageLoader_GetNewString(puzzle->messageLoader, TEXT_FIRST_HINT + puzzle->puzzle);
    puzzle->confirmQuitText = MessageLoader_GetNewString(puzzle->messageLoader, TEXT_CONFIRM_QUIT);
}

static void FreeText(AlphPuzzle *puzzle)
{
    String_Free(puzzle->confirmQuitText);
    String_Free(puzzle->hintText);
    String_Free(puzzle->quitText);
    MessageLoader_Free(puzzle->messageLoader);
}

static void InitWindows(AlphPuzzle *puzzle)
{
    Window_Add(puzzle->bgConfig, &puzzle->windows[WINDOW_QUIT_BUTTON], BG_LAYER_MAIN_2, 26, 21, 6, 3, 3, 0x3EE);
    Window_Add(puzzle->bgConfig, &puzzle->windows[WINDOW_CONFIRM_QUIT], BG_LAYER_MAIN_0, 2, 19, 27, 4, 4, 0x5B);
    Window_Add(puzzle->bgConfig, &puzzle->windows[WINDOW_HINT], BG_LAYER_SUB_0, 4, 15, 24, 6, 3, 1);

    for (int i = 0; i < WINDOW_MAX; i++) {
        Window_FillTilemap(&puzzle->windows[i], 0);
    }

    puzzle->yesNoMenu = YesNoTouchMenu_New(puzzle->heapID);
}

static void FreeWindows(AlphPuzzle *puzzle)
{
    for (int i = 0; i < WINDOW_MAX; i++) {
        Window_ClearAndCopyToVRAM(&puzzle->windows[i]);
        Window_Remove(&puzzle->windows[i]);
    }

    YesNoTouchMenu_Free(puzzle->yesNoMenu);
}

static void PlacePanelSprite(Panel *panel, s16 x, s16 y)
{
    ManagedSprite_SetPositionXY(panel->sprite, sRotationOffsets[panel->rotation][0] + x, sRotationOffsets[panel->rotation][1] + y);
}

static void PlacePanel(AlphPuzzle *puzzle, int index, u8 x, u8 y, u8 rotation)
{
    Panel *panel = &puzzle->panels[index];

    panel->x = x;
    panel->y = y;
    panel->rotation = rotation;
    PlacePanelSprite(panel, x * PANEL_SIZE + 48, y * PANEL_SIZE + 16);
    ManagedSprite_SetAffineZRotation(panel->sprite, (rotation % 4) * 0x4000);
}

static ManagedSprite *NewSprite(AlphPuzzle *puzzle, enum PuzzleResource resource, u16 anim, int priority, int bgPriority)
{
    SpriteTemplate template;

    MI_CpuClear8(&template, sizeof(SpriteTemplate));
    template.x = 208;
    template.y = 168;
    template.animIdx = anim;
    template.priority = priority;
    template.plttIdx = 0;
    template.vramType = NNS_G2D_VRAM_TYPE_2DMAIN;
    template.resources[SPRITE_RESOURCE_CHAR] = resource;
    template.resources[SPRITE_RESOURCE_PLTT] = 0;
    template.resources[SPRITE_RESOURCE_CELL] = resource;
    template.resources[SPRITE_RESOURCE_ANIM] = resource;
    template.resources[SPRITE_RESOURCE_MULTI_CELL] = SPRITE_RESOURCE_NONE;
    template.resources[SPRITE_RESOURCE_MULTI_ANIM] = SPRITE_RESOURCE_NONE;
    template.bgPriority = bgPriority;
    template.vramTransfer = FALSE;

    ManagedSprite *sprite = SpriteSystem_NewSprite(puzzle->spriteSys, puzzle->spriteMan, &template);

    // Each cell picks its own palette (the panels' is the third), which NewSprite's explicit palette would override
    ManagedSprite_SetExplicitPaletteOffset(sprite, 0);
    return sprite;
}

static void InitSprites(AlphPuzzle *puzzle)
{
    enum NarcID narc = NARC_INDEX_APPLICATION__ANNON__PUZZLE_GRA;

    VramTransfer_New(32, puzzle->heapID);
    puzzle->spriteSys = SpriteSystem_Alloc(puzzle->heapID);
    puzzle->spriteMan = SpriteManager_New(puzzle->spriteSys);

    RenderOamTemplate oamTemplate = { 0, 128, 0, 32, 0, 128, 0, 32 };
    // No room kept for transferred characters (HeartGold's template); the characters load from the bottom of VRAM
    // (LoadCharResObj's own place is that room, at the top, which 1D 32K mapping doesn't reach)
    CharTransferTemplateWithModes transferTemplate = {
        .maxTasks = 5,
        .sizeMain = 0,
        .sizeSub = 0,
        .modeMain = GX_OBJVRAMMODE_CHAR_1D_32K,
        .modeSub = GX_OBJVRAMMODE_CHAR_1D_32K,
    };
    const SpriteResourceCapacities capacities = {
        .asStruct = {
            .charCapacity = 2,
            .plttCapacity = 1,
            .cellCapacity = 2,
            .animCapacity = 2,
            .mcellCapacity = 0,
            .manimCapacity = 0,
        }
    };

    SpriteSystem_Init(puzzle->spriteSys, &oamTemplate, &transferTemplate, 16);
    SpriteSystem_InitSprites(puzzle->spriteSys, puzzle->spriteMan, SPRITE_MAX);
    SpriteSystem_InitManagerWithCapacities(puzzle->spriteSys, puzzle->spriteMan, &capacities);
    RenderOam_ClearMain(puzzle->heapID);
    RenderOam_ClearSub(puzzle->heapID);

    SpriteSystem_LoadPaletteBuffer(puzzle->paletteData, PLTTBUF_MAIN_OBJ, puzzle->spriteSys, puzzle->spriteMan, narc, puzzle_gra_00000000_NCLR, FALSE, 3, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCharResObjWithHardwareMappingType(puzzle->spriteSys, puzzle->spriteMan, narc, puzzle_gra_00000001_NCGR, FALSE, NNS_G2D_VRAM_TYPE_2DMAIN, RESOURCE_CURSORS);
    SpriteSystem_LoadCharResObjWithHardwareMappingType(puzzle->spriteSys, puzzle->spriteMan, narc, puzzle_gra_00000004_NCGR + puzzle->puzzle, FALSE, NNS_G2D_VRAM_TYPE_2DMAIN, RESOURCE_PANELS);
    SpriteSystem_LoadCellResObj(puzzle->spriteSys, puzzle->spriteMan, narc, puzzle_gra_00000002_NCER, FALSE, RESOURCE_CURSORS);
    SpriteSystem_LoadCellResObj(puzzle->spriteSys, puzzle->spriteMan, narc, puzzle_gra_00000008_NCER, FALSE, RESOURCE_PANELS);
    SpriteSystem_LoadAnimResObj(puzzle->spriteSys, puzzle->spriteMan, narc, puzzle_gra_00000003_NANR, FALSE, RESOURCE_CURSORS);
    SpriteSystem_LoadAnimResObj(puzzle->spriteSys, puzzle->spriteMan, narc, puzzle_gra_00000009_NANR, FALSE, RESOURCE_PANELS);

    // HeartGold's resource header: the cursors under the QUIT label (BG priority 3), the panels over the highlight (2)
    puzzle->sprites[SPRITE_QUIT_BUTTON] = NewSprite(puzzle, RESOURCE_CURSORS, 0, 3, 3);
    puzzle->sprites[SPRITE_ORIGIN] = NewSprite(puzzle, RESOURCE_CURSORS, 3, 1, 3);
    ManagedSprite_SetAnimationSpeed(puzzle->sprites[SPRITE_QUIT_BUTTON], FX32_ONE);
    ManagedSprite_SetAnimationSpeed(puzzle->sprites[SPRITE_ORIGIN], FX32_ONE);
    ManagedSprite_SetDrawFlag(puzzle->sprites[SPRITE_QUIT_BUTTON], TRUE);
    ManagedSprite_SetDrawFlag(puzzle->sprites[SPRITE_ORIGIN], FALSE);
    ManagedSprite_SetAnimateFlag(puzzle->sprites[SPRITE_QUIT_BUTTON], TRUE);
    ManagedSprite_SetExplicitPriority(puzzle->sprites[SPRITE_ORIGIN], 2);
    ManagedSprite_SetExplicitOamMode(puzzle->sprites[SPRITE_ORIGIN], GX_OAM_MODE_XLU);

    for (int i = 0; i < NUM_PANELS; i++) {
        ManagedSprite *sprite = NewSprite(puzzle, RESOURCE_PANELS, i, 2, 2);

        puzzle->sprites[SPRITE_FIRST_PANEL + i] = sprite;
        ManagedSprite_SetDrawFlag(sprite, TRUE);
        ManagedSprite_SetAffineOverwriteMode(sprite, AFFINE_OVERWRITE_MODE_DOUBLE);
        puzzle->panels[i].sprite = sprite;
        PlacePanel(puzzle, i, puzzle->panels[i].x, puzzle->panels[i].y, puzzle->panels[i].rotation);
    }

    GXLayers_EngineAToggleLayers(GX_PLANEMASK_OBJ, TRUE);
}

static void FreeSprites(AlphPuzzle *puzzle)
{
    GXLayers_EngineAToggleLayers(GX_PLANEMASK_OBJ, FALSE);

    for (int i = 0; i < SPRITE_MAX; i++) {
        Sprite_DeleteAndFreeResources(puzzle->sprites[i]);
    }

    SpriteSystem_FreeResourcesAndManager(puzzle->spriteSys, puzzle->spriteMan);
    SpriteSystem_Free(puzzle->spriteSys);
    puzzle->spriteSys = NULL;
    VramTransfer_Free();
    RenderOam_ClearMain(puzzle->heapID);
}

// The QUIT button: still (0), pressed (1, its animation playing) or held (2, as a panel is)
static void DrawQuitButton(AlphPuzzle *puzzle, int state)
{
    Window *window = &puzzle->windows[WINDOW_QUIT_BUTTON];

    Window_FillTilemap(window, 0);
    ManagedSprite_SetAnim(puzzle->sprites[SPRITE_QUIT_BUTTON], state);
    ManagedSprite_SetAnimateFlag(puzzle->sprites[SPRITE_QUIT_BUTTON], state == 1);

    u32 width = Font_CalcStringWidth(FONT_SYSTEM, puzzle->quitText, 0);

    Text_AddPrinterWithParamsAndColor(window, FONT_SYSTEM, puzzle->quitText, (48 - width) / 2, 4, TEXT_SPEED_NO_TRANSFER, sQuitButtonColors[state], NULL);
    Window_ScheduleCopyToVRAM(window);
}

static void DrawHint(AlphPuzzle *puzzle)
{
    Window *window = &puzzle->windows[WINDOW_HINT];

    Window_FillTilemap(window, 0);
    Text_AddPrinterWithParamsAndColor(window, FONT_SYSTEM, puzzle->hintText, 0, 0, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(2, 1, 0), NULL);
    Window_ScheduleCopyToVRAM(window);
}

// The highlight under a board square: none (0), or HeartGold's three (a free square, the panel's own, its own while
// held), from the highlight screen
static void DrawHighlight(AlphPuzzle *puzzle, u8 x, u8 y, int kind)
{
    if (kind == 0) {
        Bg_FillTilemapRect(puzzle->bgConfig, BG_LAYER_MAIN_2, 0, 4 * x + 4, 4 * y, 4, 4, 0);
    } else {
        Bg_CopyToTilemapRect(puzzle->bgConfig, BG_LAYER_MAIN_2, 4 * x + 4, 4 * y, 4, 4, puzzle->highlightScreen->rawData, 4 * (kind - 1), 0, puzzle->highlightScreen->screenWidth / 8, puzzle->highlightScreen->screenHeight / 8);
    }
}

static void UpdateHoverHighlight(AlphPuzzle *puzzle, u8 x, u8 y)
{
    Panel *panel = puzzle->selectedPanel;

    if (panel->x == puzzle->hoverTileX && panel->y == puzzle->hoverTileY) {
        DrawHighlight(puzzle, puzzle->hoverTileX, puzzle->hoverTileY, 2);
    } else {
        DrawHighlight(puzzle, puzzle->hoverTileX, puzzle->hoverTileY, 0);
    }

    if (x != 0 || y != 0) {
        DrawHighlight(puzzle, x, y, panel->x == x && panel->y == y ? 3 : 1);
    }

    Bg_ScheduleTilemapTransfer(puzzle->bgConfig, BG_LAYER_MAIN_2);
}

static void SelectPanel(AlphPuzzle *puzzle, int index)
{
    puzzle->selectedPanelIndex = index;
    puzzle->selectedPanel = &puzzle->panels[index];
    ManagedSprite_SetPriority(puzzle->selectedPanel->sprite, 0);
    ManagedSprite_OffsetPositionXY(puzzle->selectedPanel->sprite, -2, -2);
    ManagedSprite_SetDrawFlag(puzzle->sprites[SPRITE_ORIGIN], TRUE);
    ManagedSprite_SetPositionXY(puzzle->sprites[SPRITE_ORIGIN], puzzle->selectedPanel->x * PANEL_SIZE + 48, puzzle->selectedPanel->y * PANEL_SIZE + 16);
    DrawQuitButton(puzzle, 2);
}

static void DeselectPanel(AlphPuzzle *puzzle)
{
    Panel *panel = puzzle->selectedPanel;

    ManagedSprite_SetPriority(panel->sprite, 2);
    PlacePanel(puzzle, puzzle->selectedPanelIndex, panel->x, panel->y, panel->rotation);
    ManagedSprite_SetDrawFlag(puzzle->sprites[SPRITE_ORIGIN], FALSE);
    DrawQuitButton(puzzle, 0);
    puzzle->hoverTileX = 0;
    puzzle->hoverTileY = 0;
    puzzle->selectedPanel = NULL;
    puzzle->selectedPanelIndex = 0;
}

static BOOL IsSolved(AlphPuzzle *puzzle)
{
    for (int i = 0; i < NUM_PANELS; i++) {
        if (puzzle->panels[i].rotation != 0 || puzzle->panels[i].x != i % 4 + 1 || puzzle->panels[i].y != i / 4 + 1) {
            return FALSE;
        }
    }

    return TRUE;
}

// The loose panel on the touched square, or -1
static int TouchedPanel(AlphPuzzle *puzzle, u16 touchX, u16 touchY)
{
    if (touchX < BOARD_LEFT || touchX >= BOARD_LEFT + BOARD_TILES_WIDE * PANEL_SIZE) {
        return -1;
    }

    u16 x = (touchX - BOARD_LEFT) / PANEL_SIZE;
    u16 y = touchY / PANEL_SIZE;

    for (int i = 0; i < NUM_PANELS; i++) {
        if (puzzle->panels[i].x == x && puzzle->panels[i].y == y) {
            return puzzle->panels[i].isFixed ? -1 : i;
        }
    }

    return -1;
}

// The square the held panel would drop on: (0, 0), a corner, when there's none (a corner, a taken square, off the board)
static void DropSquare(AlphPuzzle *puzzle, u8 *outX, u8 *outY)
{
    *outX = 0;
    *outY = 0;

    if (puzzle->hoverPixelX < BOARD_LEFT || puzzle->hoverPixelX >= BOARD_LEFT + BOARD_TILES_WIDE * PANEL_SIZE) {
        return;
    }

    u8 x = (puzzle->hoverPixelX - BOARD_LEFT) / PANEL_SIZE;
    u8 y = puzzle->hoverPixelY / PANEL_SIZE;

    for (int i = 0; i < (int)NELEMS(sCorners); i++) {
        if (x == sCorners[i][0] && y == sCorners[i][1]) {
            return;
        }
    }

    for (int i = 0; i < NUM_PANELS; i++) {
        if (i != puzzle->selectedPanelIndex && puzzle->panels[i].x == x && puzzle->panels[i].y == y) {
            return;
        }
    }

    *outX = x;
    *outY = y;
}

static void QuitButtonAnimTask(SysTask *task, void *data)
{
    AlphPuzzle *puzzle = data;

    if (!ManagedSprite_IsAnimated(puzzle->sprites[SPRITE_QUIT_BUTTON])) {
        DrawQuitButton(puzzle, 0);
        puzzle->quitAnimActive = FALSE;
        SysTask_Done(task);
    }
}

static int WaitForInput(AlphPuzzle *puzzle)
{
    if (!gSystem.touchPressed) {
        return STATE_WAIT_FOR_INPUT;
    }

    if (TouchScreen_CheckRectanglePressed(sQuitButtonRect) == 0) {
        SysTask_Start(QuitButtonAnimTask, puzzle, 0);
        DrawQuitButton(puzzle, 1);
        puzzle->quitAnimActive = TRUE;
        Sound_PlayEffect(SE_QUIT);
        return STATE_QUIT;
    }

    int index = TouchedPanel(puzzle, gSystem.touchX, gSystem.touchY);

    if (index < 0) {
        return STATE_WAIT_FOR_INPUT;
    }

    SelectPanel(puzzle, index);
    Sound_PlayEffect(SE_PANEL_SELECT);
    return STATE_PICK_UP_PANEL;
}

// Let go at once and the panel turns; hold it and it's picked up
static int PickUpPanel(AlphPuzzle *puzzle)
{
    if (!gSystem.touchHeld) {
        puzzle->timer = 0;
        return STATE_TURN_PANEL;
    }

    if (puzzle->timer++ >= 2) {
        puzzle->timer = 0;
        puzzle->hoverPixelX = puzzle->selectedPanel->x * PANEL_SIZE + 64;
        puzzle->hoverPixelY = puzzle->selectedPanel->y * PANEL_SIZE + 32;
        puzzle->hoverTileX = puzzle->selectedPanel->x;
        puzzle->hoverTileY = puzzle->selectedPanel->y;
        DrawHighlight(puzzle, puzzle->selectedPanel->x, puzzle->selectedPanel->y, 3);
        return STATE_HOLD_PANEL;
    }

    return STATE_PICK_UP_PANEL;
}

static int HoldPanel(AlphPuzzle *puzzle)
{
    Panel *panel = puzzle->selectedPanel;

    if (!gSystem.touchHeld) {
        DrawHighlight(puzzle, panel->x, panel->y, 0);
        DrawHighlight(puzzle, puzzle->hoverTileX, puzzle->hoverTileY, 0);
        Bg_ScheduleTilemapTransfer(puzzle->bgConfig, BG_LAYER_MAIN_2);

        if (puzzle->hoverTileX == 0 && puzzle->hoverTileY == 0) { // nowhere to drop it: back where it was
            Sound_PlayEffect(SE_PANEL_BACK);
            PlacePanel(puzzle, puzzle->selectedPanelIndex, panel->x, panel->y, panel->rotation);
        } else {
            Sound_PlayEffect(SE_PANEL_SELECT);
            PlacePanel(puzzle, puzzle->selectedPanelIndex, puzzle->hoverTileX, puzzle->hoverTileY, panel->rotation);
        }

        DeselectPanel(puzzle);
        return IsSolved(puzzle) ? STATE_SOLVED : STATE_WAIT_FOR_INPUT;
    }

    s16 x = gSystem.touchX;
    s16 y = gSystem.touchY;

    x = x < 48 ? 48 : x > 208 ? 208 : x;
    y = y < 16 ? 16 : y > 176 ? 176 : y;

    ManagedSprite_SetPositionXY(puzzle->sprites[SPRITE_ORIGIN], x, y);
    PlacePanelSprite(panel, x - 2, y - 2);
    puzzle->hoverPixelX = x;
    puzzle->hoverPixelY = y;

    u8 dropX, dropY;

    DropSquare(puzzle, &dropX, &dropY);

    if (puzzle->hoverTileX != dropX || puzzle->hoverTileY != dropY) {
        UpdateHoverHighlight(puzzle, dropX, dropY);
        puzzle->hoverTileX = dropX;
        puzzle->hoverTileY = dropY;
    }

    return STATE_HOLD_PANEL;
}

static int TurnPanel(AlphPuzzle *puzzle)
{
    Panel *panel = puzzle->selectedPanel;

    switch (puzzle->subState) {
    case 0:
        Sound_PlayEffect(SE_PANEL_TURN);
        puzzle->subState++;
        break;
    case 1:
        ManagedSprite_SetAffineZRotation(panel->sprite, panel->rotation * 0x4000 + (puzzle->timer++) * 0x800);

        if (puzzle->timer >= 8) {
            puzzle->subState++;
        }
        break;
    default:
        panel->rotation = (panel->rotation + 1) % 4;
        DeselectPanel(puzzle);
        puzzle->timer = 0;
        puzzle->subState = 0;
        return IsSolved(puzzle) ? STATE_SOLVED : STATE_WAIT_FOR_INPUT;
    }

    return STATE_TURN_PANEL;
}

static int Quit(AlphPuzzle *puzzle)
{
    Window *window = &puzzle->windows[WINDOW_CONFIRM_QUIT];

    switch (puzzle->subState) {
    case 0:
        if (!puzzle->quitAnimActive) {
            Window_DrawMessageBoxWithScrollCursor(window, TRUE, 1, 5);
            Window_FillTilemap(window, 15);
            puzzle->textPrinterID = Text_AddPrinterWithParamsAndColor(window, FONT_MESSAGE, puzzle->confirmQuitText, 0, 0, puzzle->textSpeed, TEXT_COLOR(1, 2, 15), NULL);
            Window_ScheduleCopyToVRAM(window);
            puzzle->subState++;
        }
        break;
    case 1:
        if (!Text_IsPrinterActive(puzzle->textPrinterID)) {
            YesNoTouchMenuParams params = {
                .bgConfig = puzzle->bgConfig,
                .bgLayer = BG_LAYER_MAIN_0,
                .baseTile = 0x5B + 27 * 4, // after the question's window (HeartGold's 31 is under it here)
                .palette = 6,
                .tilemapLeft = 25,
                .tilemapTop = 10,
            };

            YesNoTouchMenu_InitWithParams(puzzle->yesNoMenu, &params);
            puzzle->subState++;
        }
        break;
    default: {
        u32 answer = YesNoTouchMenu_ProcessInput(puzzle->yesNoMenu);

        if (answer != YES_NO_TOUCH_MENU_YES && answer != YES_NO_TOUCH_MENU_NO) {
            break;
        }

        YesNoTouchMenu_Reset(puzzle->yesNoMenu);
        Window_EraseMessageBox(window, TRUE);
        Window_FillTilemap(window, 0);
        Window_ScheduleCopyToVRAM(window);
        Bg_ScheduleTilemapTransfer(puzzle->bgConfig, BG_LAYER_MAIN_0);
        puzzle->subState = 0;
        return answer == YES_NO_TOUCH_MENU_YES ? STATE_FADE_OUT : STATE_WAIT_FOR_INPUT;
    }
    }

    return STATE_QUIT;
}

// The panels flash white, and the puzzle is done
static int Solved(AlphPuzzle *puzzle)
{
    switch (puzzle->subState) {
    case 0:
        Sound_PlayEffect(SE_SOLVED);
        puzzle->subState++;
        break;
    case 1:
        PaletteData_Blend(puzzle->paletteData, PLTTBUF_MAIN_OBJ, 0x2B, 5, puzzle->timer, COLOR_WHITE);

        if (puzzle->timer++ >= 15) {
            puzzle->subState++;
        }
        break;
    case 2:
        PaletteData_Blend(puzzle->paletteData, PLTTBUF_MAIN_OBJ, 0x2B, 5, puzzle->timer, COLOR_WHITE);

        if (puzzle->timer-- == 0) {
            puzzle->subState++;
        }
        break;
    default:
        puzzle->subState = 0;
        puzzle->timer = 0;
        puzzle->solved = TRUE;
        return STATE_FADE_OUT;
    }

    return STATE_SOLVED;
}

BOOL CompleteAlphPuzzle_Init(ApplicationManager *appMan, int *state)
{
    ScreensOff();
    Heap_Create(HEAP_ID_APPLICATION, PUZZLE_HEAP_ID, 0x20000);

    AlphPuzzle *puzzle = ApplicationManager_NewData(appMan, sizeof(AlphPuzzle), PUZZLE_HEAP_ID);

    memset(puzzle, 0, sizeof(AlphPuzzle));
    puzzle->heapID = PUZZLE_HEAP_ID;
    puzzle->args = ApplicationManager_Args(appMan);
    puzzle->puzzle = puzzle->args->puzzle < COMPLETE_ALPH_PUZZLE_MAX ? puzzle->args->puzzle : COMPLETE_ALPH_PUZZLE_KABUTO;

    Options *options = SaveData_GetOptions(puzzle->args->saveData);

    puzzle->textSpeed = Options_TextFrameDelay(options);
    puzzle->frame = Options_Frame(options);

    puzzle->paletteData = PaletteData_New(puzzle->heapID);
    PaletteData_AllocBuffer(puzzle->paletteData, PLTTBUF_MAIN_OBJ, PALETTE_SIZE_BYTES * 16, puzzle->heapID);

    InitPanels(puzzle);
    InitBgs(puzzle);
    LoadBgGraphics(puzzle);
    LoadText(puzzle);
    InitWindows(puzzle);
    InitSprites(puzzle);
    DrawQuitButton(puzzle, 0);
    DrawHint(puzzle);

    for (int layer = BG_LAYER_MAIN_0; layer <= BG_LAYER_SUB_3; layer++) {
        Bg_ScheduleTilemapTransfer(puzzle->bgConfig, layer);
    }

    Bg_ToggleLayer(BG_LAYER_MAIN_0, TRUE);
    Bg_ToggleLayer(BG_LAYER_MAIN_2, TRUE);
    Bg_ToggleLayer(BG_LAYER_MAIN_3, TRUE);
    Bg_ToggleLayer(BG_LAYER_SUB_0, TRUE);
    Bg_ToggleLayer(BG_LAYER_SUB_2, TRUE);
    Bg_ToggleLayer(BG_LAYER_SUB_3, TRUE);

    SetVBlankCallback(VBlankCallback, puzzle);
    GXLayers_TurnBothDispOn();
    return TRUE;
}

#ifdef SOVEREIGN_TEST
// Test build: each panel's square and quarter turns (x, y, rotation), for tools/complete/test_hgss_alph_puzzle.py
u8 gCompleteTestAlphPanels[NUM_PANELS][3];
#endif

BOOL CompleteAlphPuzzle_Main(ApplicationManager *appMan, int *state)
{
    AlphPuzzle *puzzle = ApplicationManager_Data(appMan);

#ifdef SOVEREIGN_TEST
    for (int i = 0; i < NUM_PANELS; i++) {
        gCompleteTestAlphPanels[i][0] = puzzle->panels[i].x;
        gCompleteTestAlphPanels[i][1] = puzzle->panels[i].y;
        gCompleteTestAlphPanels[i][2] = puzzle->panels[i].rotation;
    }
#endif

    switch (*state) {
    case STATE_FADE_IN:
        if (puzzle->subState == 0) {
            StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_IN, FADE_TYPE_BRIGHTNESS_IN, COLOR_BLACK, 6, 1, puzzle->heapID);
            puzzle->subState++;
        } else if (IsScreenFadeDone()) {
            puzzle->subState = 0;
            *state = STATE_WAIT_FOR_INPUT;
        }
        break;
    case STATE_WAIT_FOR_INPUT:
        *state = WaitForInput(puzzle);
        break;
    case STATE_PICK_UP_PANEL:
        *state = PickUpPanel(puzzle);
        break;
    case STATE_HOLD_PANEL:
        *state = HoldPanel(puzzle);
        break;
    case STATE_TURN_PANEL:
        *state = TurnPanel(puzzle);
        break;
    case STATE_QUIT:
        *state = Quit(puzzle);
        break;
    case STATE_SOLVED:
        *state = Solved(puzzle);
        break;
    case STATE_FADE_OUT:
        if (puzzle->subState == 0) {
            StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_OUT, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, 6, 1, puzzle->heapID);
            puzzle->subState++;
        } else if (IsScreenFadeDone()) {
            puzzle->subState = 0;
            *state = STATE_END;
        }
        break;
    case STATE_END:
        return TRUE;
    }

    SpriteSystem_DrawSprites(puzzle->spriteMan);
    return FALSE;
}

BOOL CompleteAlphPuzzle_Exit(ApplicationManager *appMan, int *state)
{
    AlphPuzzle *puzzle = ApplicationManager_Data(appMan);

    if (puzzle->solved) {
        VarsFlags_SetFlag(SaveData_GetVarsFlags(puzzle->args->saveData), sSolvedFlags[puzzle->puzzle]);
    }

    SetVBlankCallback(NULL, NULL);
    FreeSprites(puzzle);
    FreeWindows(puzzle);
    FreeText(puzzle);
    Heap_Free(puzzle->highlightScreenFile);
    PaletteData_FreeBuffer(puzzle->paletteData, PLTTBUF_MAIN_OBJ);
    PaletteData_Free(puzzle->paletteData);
    FreeBgs(puzzle);
    ScreensOff();

    ApplicationManager_FreeData(appMan);
    Heap_Destroy(PUZZLE_HEAP_ID);
    return TRUE;
}
