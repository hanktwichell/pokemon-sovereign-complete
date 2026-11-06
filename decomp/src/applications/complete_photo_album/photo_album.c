// Sovereign Complete: HeartGold's photo album, its overlay 109 (include/complete_photo.h): pages of photos on the
// touch screen, two pages of six at a time, the picked one's icon and caption on the top screen; a photo is looked at
// (the field shows it again, src/complete_photo.c), deleted or moved. HeartGold's code, decompiled from its assembly
// (77 of its 79 functions compile to HeartGold's own instructions with its compiler), on Platinum's libraries
// (include/applications/complete_photo_album/hgss_compat.h). What differs from HeartGold's: the album is
// include/complete_photo.h's (its own save sector, written as the album closes when a photo was deleted or moved);
// the sprites' graphics are loaded by hand (HeartGold's resdat list named the same members); the delete prompt is
// Platinum's touch buttons, as Voltorb Flip's, which A and B press too.

#include "applications/complete_photo_album.h"

#include <nitro.h>

#include "constants/narc.h"
#include "constants/species.h"
#include "generated/text_banks.h"

#include "applications/complete_photo_album/hgss_compat.h"
#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0000.h"

#include "complete_photo.h"
#include "heap.h"
#include "message.h"
#include "sprite_system.h"
#include "yes_no_touch_menu.h"

// HeartGold's PhotoAlbum_LoadAllInUsePhotos: a copy of the album's photos (they fill its first pages)
static CompletePhoto *PhotoAlbum_LoadAllInUsePhotos(CompletePhotoAlbum *album, u8 count, enum HeapID heapID)
{
    CompletePhoto *photos = Heap_Alloc(heapID, sizeof(CompletePhoto) * (count ? count : 1));

    MI_CpuCopy8(album->photos, photos, sizeof(CompletePhoto) * count);
    return photos;
}

// HeartGold's Sprite_ResetAnimCtrlState: the sprite's animation from its start
static void PhotoAlbum_RestartAnim(ManagedSprite *sprite)
{
    ManagedSprite_SetAnim(sprite, ManagedSprite_GetActiveAnim(sprite));
}

// Sequence states of PhotoAlbum_Main (the int *state the OverlayManager keeps).
typedef enum PhotoAlbumState {
    PHOTO_ALBUM_STATE_FADE_IN,        // 0: fade both screens in from black
    PHOTO_ALBUM_STATE_BROWSE,         // 1: move the cursor, pick a photo, turn pages, EXIT/B
    PHOTO_ALBUM_STATE_FLIP_PREV_PAGE, // 2: page-turn animation to the previous page
    PHOTO_ALBUM_STATE_FLIP_NEXT_PAGE, // 3: page-turn animation to the next page
    PHOTO_ALBUM_STATE_ACTION_MENU,    // 4: VIEW / DELETE / MOVE / CANCEL list for the picked photo
    PHOTO_ALBUM_STATE_MOVE,           // 5: "Switch with which photo?" - pick the photo to swap with
    PHOTO_ALBUM_STATE_SWAPPED,        // 6: the two photos were swapped: redraw, "...were switched."
    PHOTO_ALBUM_STATE_CONFIRM_DELETE, // 7: "Is it OK to delete this photo?" YES/NO
    PHOTO_ALBUM_STATE_FADE_OUT,       // 8: fade both screens out to black
    PHOTO_ALBUM_STATE_END,            // 9: PhotoAlbum_Main returns TRUE
} PhotoAlbumState;

// PhotoAlbumAppData.mode: what the picked photo is being used for.
typedef enum PhotoAlbumMode {
    PHOTO_ALBUM_MODE_NONE,   // browsing
    PHOTO_ALBUM_MODE_MOVE,   // choosing the photo to swap the picked one with
    PHOTO_ALBUM_MODE_DELETE, // the delete YES/NO prompt is up
} PhotoAlbumMode;

// The album's grid: 4 columns (two per page) by 3 rows, 12 photos per two-page spread.
#define PHOTO_ALBUM_GRID_WIDTH  4
#define PHOTO_ALBUM_GRID_HEIGHT 3
#define PHOTO_ALBUM_PER_SPREAD  12

// cursorY of the row below the grid: the cursor sits on the EXIT button.
#define PHOTO_ALBUM_CURSOR_Y_EXIT 3

// Inputs: 0-11 are grid positions (y * PHOTO_ALBUM_GRID_WIDTH + x); also the indexes into sTouchHitboxes.
#define PHOTO_ALBUM_INPUT_EXIT      12
#define PHOTO_ALBUM_INPUT_PREV_PAGE 13
#define PHOTO_ALBUM_INPUT_NEXT_PAGE 14

// PhotoAlbumAppData.sprites
#define PHOTO_ALBUM_SPRITE_CURSOR      0 // the cursor frame (anim frame 0: photo; frame 1: EXIT)
#define PHOTO_ALBUM_SPRITE_SELECTION   1 // marks the picked photo while its menu / move / delete is up
#define PHOTO_ALBUM_SPRITE_PREV_ARROW  2 // the left page-turn arrow
#define PHOTO_ALBUM_SPRITE_NEXT_ARROW  3 // the right page-turn arrow
#define PHOTO_ALBUM_SPRITE_EXIT_BUTTON 4 // the EXIT button
#define PHOTO_ALBUM_SPRITE_MAX         5

// PhotoAlbumAppData.windows
#define PHOTO_ALBUM_WINDOW_EXIT    0 // "EXIT" on the EXIT button (main BG1)
#define PHOTO_ALBUM_WINDOW_MESSAGE 1 // the framed message box (main BG0)
#define PHOTO_ALBUM_WINDOW_DETAILS 2 // the picked photo's caption, top screen (sub BG0)
#define PHOTO_ALBUM_WINDOW_MAX     3

// PhotoAlbumAppData.messages (msg_0000_00005 + i)
#define PHOTO_ALBUM_MSG_SELECT_PHOTO   0 // "Please select a photo."
#define PHOTO_ALBUM_MSG_WHAT_TO_DO     1 // "What will you do with the selected photo?" (never printed)
#define PHOTO_ALBUM_MSG_SWITCH_WITH    2 // "Switch with which photo?"
#define PHOTO_ALBUM_MSG_SWITCHED       3 // "The selected photos were switched."
#define PHOTO_ALBUM_MSG_CONFIRM_DELETE 4 // "Is it OK to delete this photo?"
#define PHOTO_ALBUM_MSG_MAX            5

// Results of the action menu (the ListMenuItem values: msg_0000_00001 + value).
#define PHOTO_ALBUM_ACTION_VIEW   0
#define PHOTO_ALBUM_ACTION_DELETE 1
#define PHOTO_ALBUM_ACTION_MOVE   2
#define PHOTO_ALBUM_ACTION_CANCEL 3
#define PHOTO_ALBUM_ACTION_MAX    4

// Halves of the spread for PhotoAlbum_DrawSpread
#define PHOTO_ALBUM_HALF_LEFT  1
#define PHOTO_ALBUM_HALF_RIGHT 2
#define PHOTO_ALBUM_HALF_BOTH  (PHOTO_ALBUM_HALF_LEFT | PHOTO_ALBUM_HALF_RIGHT)

// Members of NARC_a_1_7_1 (a/1/7/1, shared with the photo viewer); the sprites' members are named by
// resdat 0-3 (cell 2, anim 3, char 1, palette 0).
#define PHOTO_GFX_OBJ_NCLR            0  // the sprites' palettes (5)
#define PHOTO_GFX_OBJ_NCGR            1  // the sprites' tiles
#define PHOTO_GFX_OBJ_NCER            2  // their cells
#define PHOTO_GFX_OBJ_NANR            3  // their animations
#define PHOTO_GFX_BG_NCLR             4  // BG palettes (12 x 16 colours), loaded to both screens
#define PHOTO_GFX_BG_NCGR             5  // 256-colour BG tiles: the album's pages, digits and photo icons
#define PHOTO_GFX_ALBUM_NSCR          6  // the open album, main BG3
#define PHOTO_GFX_HALF_PAGES_NSCR     7  // blank half pages (x 0-15 left, 16-31 right) and page digits (y 24-25)
#define PHOTO_GFX_ICONS_NSCR          8  // photo icons, 5x5 tiles each, 6 per row; 0 = empty slot
#define PHOTO_GFX_TOP_SCREEN_NCGR     9  // top screen background (album), sub BG2
#define PHOTO_GFX_TOP_SCREEN_NSCR     10 // top screen background (album), sub BG2

typedef struct PhotoAlbumEntry {
    u8 loadIndex; // 0x0: index in PhotoAlbumAppData.photos when loaded; written, never read
    CompletePhoto *photo; // 0x4
} PhotoAlbumEntry; // size: 0x8

typedef struct PhotoAlbumAppData {
    enum HeapID heapID;                                      // 0x000: HEAP_ID_PHOTO_ALBUM
    int subState;                                            // 0x004: steps of the enter step and the fades
    u16 seqStep;                                             // 0x008: steps of the page turns, the swap and the delete prompt
    u16 timer;                                               // 0x00A: frame counter of PHOTO_ALBUM_STATE_SWAPPED
    int menuInputState;                           // 0x00C
    CompletePhotoAlbumArgs *args;                                    // 0x010
    BgConfig *bgConfig;                                      // 0x014
    u8 exitButtonAnimActive : 1;                             // 0x018 bit 0: input waits for the EXIT button's animation
    u8 flipLayerScaleDirty : 1;                              // 0x018 bit 1: set main BG2's affine scale in the next VBlank
    u8 flipLayerToggleDirty : 1;                             // 0x018 bit 2: show/hide main BG2 in the next VBlank
    u8 flipLayerShow : 1;                                    // 0x018 bit 3: ... shown (1) or hidden (0)
    u8 flipFrame : 4;                                        // 0x018 bits 4-7: frame of the page turn (index of sFlipLayerScales)
    u8 page;                                                 // 0x019: current spread
    u8 numPages;                                             // 0x01A: number of spreads (at least 1)
    u8 cursorX;                                              // 0x01B: 0-3
    u8 cursorY;                                              // 0x01C: 0-2, or PHOTO_ALBUM_CURSOR_Y_EXIT
    u8 selectedCursorX;                                      // 0x01D: cursor position of the picked photo
    u8 selectedCursorY;                                      // 0x01E
    u8 selectedPhoto;                                        // 0x01F: index of the picked photo in entries
    u8 mode;                                                 // 0x020: PhotoAlbumMode
    u8 textPrinterId;                                        // 0x021
    u8 textFrameDelay;                                       // 0x022: from the options
    u8 frame;                                                // 0x023: window frame, from the options
    MsgData *msgData;                                        // 0x024: msg_0000
    MessageFormat *msgFormat;                                // 0x028
    String *strBuf;                                          // 0x02C
    String *exitText;                                        // 0x030: msg_0000_00000 "EXIT"
    String *messages[PHOTO_ALBUM_MSG_MAX];                   // 0x034: msg_0000_00005 - msg_0000_00009
    String *captionTemplates[2];                             // 0x048: msg_0000_00010 (one Pokemon), msg_0000_00011 ("and friends")
    Window windows[PHOTO_ALBUM_WINDOW_MAX];                  // 0x050
    TouchscreenListMenuSpawner *listMenuSpawner;             // 0x080
    TouchscreenListMenu *listMenu;                           // 0x084
    ListMenuItem *listMenuItems;                             // 0x088: VIEW, DELETE, MOVE, CANCEL
    YesNoPrompt *yesNoPrompt;                                // 0x08C
    SpriteSystem *spriteSystem;                              // 0x090
    SpriteManager *spriteManager;                            // 0x094
    ManagedSprite *sprites[PHOTO_ALBUM_SPRITE_MAX];                 // 0x098
    NNSG2dScreenData *unusedIconsScreenData;                 // 0x0AC: PHOTO_GFX_ICONS_NSCR, loaded but never used
    void *unusedIconsScreenDataRaw;                          // 0x0B0
    NNSG2dScreenData *iconsScreenData;                       // 0x0B4: PHOTO_GFX_ICONS_NSCR
    void *iconsScreenDataRaw;                                // 0x0B8
    NNSG2dScreenData *halfPagesScreenData;                   // 0x0BC: PHOTO_GFX_HALF_PAGES_NSCR
    void *halfPagesScreenDataRaw;                            // 0x0C0
    u8 numPhotosSaved;                                       // 0x0C4: photos in the save when the app started
    u8 numPhotos;                                            // 0x0C5: photos left (after deletions)
    CompletePhoto *photos;                                           // 0x0C8: copies of the saved photos (PhotoAlbum_LoadAllInUsePhotos)
    PhotoAlbumEntry entries[COMPLETE_PHOTO_ALBUM_MAX];                // 0x0CC: the album's order; written back to the save on exit
    CompletePhotoAlbum *photoAlbum;                                  // 0x1EC
    fx32 flipLayerScale;                                     // 0x1F0: scale of main BG2 (the turning page)
} PhotoAlbumAppData; // size: 0x1F4

typedef struct PhotoAlbumExitButtonTaskData {
    PhotoAlbumAppData *data; // 0x0
    u32 unused;              // 0x4
} PhotoAlbumExitButtonTaskData; // size: 0x8

static void PhotoAlbum_ScreenOff(void);
static void PhotoAlbum_InitFromArgs(PhotoAlbumAppData *data);
static void PhotoAlbum_Finish(PhotoAlbumAppData *data);
static BOOL PhotoAlbum_OverlayEnterStep(PhotoAlbumAppData *data);
static BOOL PhotoAlbum_OverlayExitStep(PhotoAlbumAppData *data);
static int PhotoAlbumMainSeq_FadeIn(PhotoAlbumAppData *data);
static int PhotoAlbumMainSeq_FadeOut(PhotoAlbumAppData *data);
static int PhotoAlbumMainSeq_Browse(PhotoAlbumAppData *data);
static int PhotoAlbumMainSeq_FlipPrevPage(PhotoAlbumAppData *data);
static int PhotoAlbumMainSeq_FlipNextPage(PhotoAlbumAppData *data);
static int PhotoAlbumMainSeq_ActionMenu(PhotoAlbumAppData *data);
static int PhotoAlbumMainSeq_Move(PhotoAlbumAppData *data);
static int PhotoAlbumMainSeq_Swapped(PhotoAlbumAppData *data);
static int PhotoAlbumMainSeq_ConfirmDelete(PhotoAlbumAppData *data);
static void PhotoAlbum_SetupGraphics(PhotoAlbumAppData *data);
static void PhotoAlbum_TeardownGraphics(PhotoAlbumAppData *data);
static void PhotoAlbum_InitEntries(PhotoAlbumAppData *data);
static void PhotoAlbum_SaveEntries(PhotoAlbumAppData *data);
static void PhotoAlbum_SwapEntries(PhotoAlbumAppData *data, u8 a, u8 b);
static void PhotoAlbum_DeleteEntry(PhotoAlbumAppData *data, u8 index);
static void PhotoAlbum_DrawInitialScreen(PhotoAlbumAppData *data);
static int PhotoAlbum_Browse_HandleInput(PhotoAlbumAppData *data);
static int PhotoAlbum_Browse_DoInput(PhotoAlbumAppData *data, u8 input);
static int PhotoAlbum_Browse_HandleTouch(PhotoAlbumAppData *data, BOOL *touched);
static int PhotoAlbum_Browse_HandleKeys(PhotoAlbumAppData *data);
static int PhotoAlbum_Move_HandleInput(PhotoAlbumAppData *data);
static BOOL PhotoAlbum_Swapped_Run(PhotoAlbumAppData *data);
static int PhotoAlbum_Move_DoInput(PhotoAlbumAppData *data, u8 input);
static int PhotoAlbum_Move_HandleTouch(PhotoAlbumAppData *data, BOOL *touched);
static int PhotoAlbum_Move_HandleKeys(PhotoAlbumAppData *data);
static BOOL PhotoAlbum_RunFlipPrevPage(PhotoAlbumAppData *data);
static BOOL PhotoAlbum_RunFlipNextPage(PhotoAlbumAppData *data);
static int PhotoAlbum_ActionMenu_Run(PhotoAlbumAppData *data);
static int PhotoAlbum_ConfirmDelete_Run(PhotoAlbumAppData *data);
static void PhotoAlbum_VBlankCB(void *cbData);
static void PhotoAlbum_ApplyFlipLayerToggle(PhotoAlbumAppData *data);
static void PhotoAlbum_ScheduleFlipLayerToggle(PhotoAlbumAppData *data, BOOL show);
static void PhotoAlbum_ApplyFlipLayerScale(PhotoAlbumAppData *data);
static void PhotoAlbum_ScheduleFlipLayerScale(PhotoAlbumAppData *data, fx32 scale);
static void PhotoAlbum_SetGraphicsBanks(void);
static void PhotoAlbum_InitBgLayers(PhotoAlbumAppData *data);
static void PhotoAlbum_FreeBgLayers(PhotoAlbumAppData *data);
static void PhotoAlbum_LoadBgGraphics(PhotoAlbumAppData *data);
static void PhotoAlbum_FreeBgGraphics(PhotoAlbumAppData *data);
static void PhotoAlbum_InitText(PhotoAlbumAppData *data);
static void PhotoAlbum_DeleteText(PhotoAlbumAppData *data);
static void PhotoAlbum_CreateWindows(PhotoAlbumAppData *data);
static void PhotoAlbum_DestroyWindows(PhotoAlbumAppData *data);
static void PhotoAlbum_InitSpriteSystem(PhotoAlbumAppData *data);
static void PhotoAlbum_DestroySpriteSystem(PhotoAlbumAppData *data);
static void PhotoAlbum_CreateSpriteGraphics(PhotoAlbumAppData *data);
static void PhotoAlbum_DeleteSpriteGraphics(PhotoAlbumAppData *data);
static void PhotoAlbum_CreateSprites(PhotoAlbumAppData *data);
static void PhotoAlbum_DeleteSprites(PhotoAlbumAppData *data);
static void PhotoAlbum_DrawTurningHalfPage(PhotoAlbumAppData *data, int half, BOOL draw);
static void PhotoAlbum_DrawPageNumber(PhotoAlbumAppData *data, int bgId, int half, int page);
static void PhotoAlbum_DrawHalfSpreadIcons(PhotoAlbumAppData *data, int bgId, int page, int firstColumn);
static void PhotoAlbum_DrawSpread(PhotoAlbumAppData *data, int bgId, int halves, u8 page);
static void PhotoAlbum_DrawIcon(PhotoAlbumAppData *data, u8 icon, u8 bgId, u8 x, u8 y);
static void PhotoAlbum_DrawGridIcon(PhotoAlbumAppData *data, CompletePhoto *photo, int bgId, u8 x, u8 y);
static void PhotoAlbum_ClearSwappedIcons(PhotoAlbumAppData *data, u8 a, u8 b);
static void PhotoAlbum_PrintPhotoDetails(PhotoAlbumAppData *data, CompletePhoto *photo);
static void PhotoAlbum_DrawExitButton(PhotoAlbumAppData *data, BOOL pressed);
static void PhotoAlbum_PrintMessage(PhotoAlbumAppData *data, int msgNo, BOOL drawFrame, u8 textSpeed);
static void PhotoAlbum_SetCursorPos(PhotoAlbumAppData *data, u8 x, u8 y, BOOL show);
static void PhotoAlbum_ShowSelectionMarker(PhotoAlbumAppData *data, BOOL show);
static void PhotoAlbum_UpdatePageArrows(PhotoAlbumAppData *data);
static void PhotoAlbum_AnimatePageArrow(PhotoAlbumAppData *data, int spriteNo);
static int PhotoAlbum_ToggleMenuInputState(PhotoAlbumAppData *data);
static void PhotoAlbum_OpenActionMenu(PhotoAlbumAppData *data);
static int PhotoAlbum_ActionMenu_HandleInput(PhotoAlbumAppData *data);
static void PhotoAlbum_CreateDeleteYesNoPrompt(PhotoAlbumAppData *data);
static int PhotoAlbum_DeleteYesNoPrompt_HandleInput(PhotoAlbumAppData *data);
static void PhotoAlbum_StartExitButtonTask(PhotoAlbumAppData *data);
static void Task_PhotoAlbum_WaitExitButtonAnim(SysTask *task, void *taskData);
static u8 PhotoAlbum_CountValidMons(CompletePhoto *photo);

// _021E7884: grid position (y * 4 + x) -> slot in the spread. The left page holds slots 0-5 (2 per row),
// the right page 6-11.
static const u8 sGridPosToSpreadSlot[PHOTO_ALBUM_PER_SPREAD] = {
    0, 1, 6, 7,
    2, 3, 8, 9,
    4, 5, 10, 11,
};

// ov109_021E7890: slot in the spread -> grid position (y * 4 + x); the inverse of sGridPosToSpreadSlot.
static const u8 sSpreadSlotToGridPos[PHOTO_ALBUM_PER_SPREAD] = {
    0, 1, 4, 5, 8, 9,
    2, 3, 6, 7, 10, 11,
};

// ov109_021E789C
static const TouchscreenListMenuTemplate sActionMenuTemplate = {
    .wrapAround = TRUE,
    .centered = TRUE,
    .xOffset = 0,
    .bgId = GF_BG_LYR_MAIN_0,
    .plttOffset = 11,
    .unk4 = 0,
    .unk5 = 0,
    .baseTile = 58,
    .charOffset = 31,
    .unkA = 64,
};

// ov109_021E78B8
static const GraphicsModes sGraphicsModes = {
    .displayMode = GX_DISPMODE_GRAPHICS,
    .mainBgMode = GX_BGMODE_5,
    .subBgMode = GX_BGMODE_3,
    .bg0As2DOr3D = GX_BG0_AS_2D,
};

// ov109_021E78C8
static const OamCharTransferParam sOamCharTransferParam = {
    3,
    0x10000, // HeartGold's 0: all of the main screen's 64 KB (bank E) and the sub screen's 16 KB (bank I)
    0x4000,
    GX_OBJVRAMMODE_CHAR_1D_32K,
    GX_OBJVRAMMODE_CHAR_1D_32K,
};

static const SpriteResourceCountsListUnion sResourceCounts = { 1, 1, 1, 1, 0, 0 };

// ov109_021E78DC: horizontal scale of the turning page (main BG2) for each frame of the turn. The last
// entry is never used.
static const fx32 sFlipLayerScales[6] = {
    FX32_ONE,
    0xCCD, // 0.8
    0x99A, // 0.6
    0x666, // 0.4
    0x333, // 0.2
    0,
};

// ov109_021E78F4
static const WindowTemplate sWindowTemplates[PHOTO_ALBUM_WINDOW_MAX] = {
    [PHOTO_ALBUM_WINDOW_EXIT] = {
        .bgLayer = GF_BG_LYR_MAIN_1,
        .tilemapLeft = 24,
        .tilemapTop = 21,
        .width = 8,
        .height = 2,
        .palette = 1,
        .baseTile = 0x102,
    },
    [PHOTO_ALBUM_WINDOW_MESSAGE] = {
        .bgLayer = GF_BG_LYR_MAIN_0,
        .tilemapLeft = 2,
        .tilemapTop = 19,
        .width = 19,
        .height = 4,
        .palette = 12,
        .baseTile = 0x0B6,
    },
    [PHOTO_ALBUM_WINDOW_DETAILS] = {
        .bgLayer = GF_BG_LYR_SUB_0,
        .tilemapLeft = 1,
        .tilemapTop = 15,
        .width = 28,
        .height = 8,
        .palette = 10,
        .baseTile = 0x01F,
    },
};

// ov109_021E790C
static const BgTemplate sBgTemplate_Main0 = {
    .x = 0,
    .y = 0,
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .baseTile = 0,
    .screenSize = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_16,
    .screenBase = GX_BG_SCRBASE_0xf800,
    .charBase = GX_BG_CHARBASE_0x10000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 0,
    .areaOver = GX_BG_AREAOVER_XLU,
    .mosaic = FALSE,
};

// ov109_021E7928
static const BgTemplate sBgTemplate_Main1 = {
    .x = 0,
    .y = 0,
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .baseTile = 0,
    .screenSize = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_16,
    .screenBase = GX_BG_SCRBASE_0xf000,
    .charBase = GX_BG_CHARBASE_0x10000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 1,
    .areaOver = GX_BG_AREAOVER_XLU,
    .mosaic = FALSE,
};

// ov109_021E7944
static const BgTemplate sBgTemplate_Sub0 = {
    .x = 0,
    .y = 0,
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .baseTile = 0,
    .screenSize = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_16,
    .screenBase = GX_BG_SCRBASE_0xf800,
    .charBase = GX_BG_CHARBASE_0x10000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 0,
    .areaOver = GX_BG_AREAOVER_XLU,
    .mosaic = FALSE,
};

// ov109_021E7960
static const BgTemplate sBgTemplate_Main2 = {
    .x = 0,
    .y = 0,
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .baseTile = 0,
    .screenSize = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_256,
    .screenBase = GX_BG_SCRBASE_0xe800,
    .charBase = GX_BG_CHARBASE_0x00000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 2,
    .areaOver = GX_BG_AREAOVER_XLU,
    .mosaic = FALSE,
};

// ov109_021E797C
static const BgTemplate sBgTemplate_Sub3 = {
    .x = 0,
    .y = 0,
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .baseTile = 0,
    .screenSize = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_256,
    .screenBase = GX_BG_SCRBASE_0xf000,
    .charBase = GX_BG_CHARBASE_0x00000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 2,
    .areaOver = GX_BG_AREAOVER_XLU,
    .mosaic = FALSE,
};

// ov109_021E7998
static const BgTemplate sBgTemplate_Sub2 = {
    .x = 0,
    .y = 0,
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .baseTile = 0,
    .screenSize = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_16,
    .screenBase = GX_BG_SCRBASE_0xe800,
    .charBase = GX_BG_CHARBASE_0x08000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 3,
    .areaOver = GX_BG_AREAOVER_XLU,
    .mosaic = FALSE,
};

// ov109_021E79B4
static const BgTemplate sBgTemplate_Main3 = {
    .x = 0,
    .y = 0,
    .bufferSize = GF_BG_BUF_SIZE_256x256_4BPP,
    .baseTile = 0,
    .screenSize = GF_BG_SCR_SIZE_256x256,
    .colorMode = GX_BG_COLORMODE_256,
    .screenBase = GX_BG_SCRBASE_0xe000,
    .charBase = GX_BG_CHARBASE_0x00000,
    .bgExtPltt = GX_BG_EXTPLTT_01,
    .priority = 3,
    .areaOver = GX_BG_AREAOVER_XLU,
    .mosaic = FALSE,
};

// ov109_021E79D0
static const OamManagerParam sOamManagerParam = { 0, 128, 0, 32, 0, 128, 0, 32 };

// ov109_021E79F0
static const GraphicsBanks sGraphicsBanks = {
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

// ov109_021E7A18: indexes 0-11 are the grid positions (y * 4 + x), then the PHOTO_ALBUM_INPUT_* buttons.
static const TouchscreenHitbox sTouchHitboxes[] = {
    { .rect = { 12, 44, 32, 72 } },
    { .rect = { 12, 44, 80, 120 } },
    { .rect = { 12, 44, 136, 176 } },
    { .rect = { 12, 44, 184, 224 } },
    { .rect = { 52, 84, 32, 72 } },
    { .rect = { 52, 84, 80, 120 } },
    { .rect = { 52, 84, 136, 176 } },
    { .rect = { 52, 84, 184, 224 } },
    { .rect = { 92, 124, 32, 72 } },
    { .rect = { 92, 124, 80, 120 } },
    { .rect = { 92, 124, 136, 176 } },
    { .rect = { 92, 124, 184, 224 } },
    [PHOTO_ALBUM_INPUT_EXIT] = { .rect = { 162, 188, 194, 254 } },
    [PHOTO_ALBUM_INPUT_PREV_PAGE] = { .rect = { 48, 80, 8, 24 } },
    [PHOTO_ALBUM_INPUT_NEXT_PAGE] = { .rect = { 48, 80, 232, 248 } },
    { .rect = { TOUCHSCREEN_RECTLIST_END } },
};

// ov109_021E7A58
static const SpriteTemplate sSpriteTemplates[PHOTO_ALBUM_SPRITE_MAX] = {
    [PHOTO_ALBUM_SPRITE_CURSOR] = { 28, 8, 0, 6, 0, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, SPRITE_RESOURCE_NONE, SPRITE_RESOURCE_NONE }, 1, FALSE },
    [PHOTO_ALBUM_SPRITE_SELECTION] = { 28, 8, 0, 7, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, SPRITE_RESOURCE_NONE, SPRITE_RESOURCE_NONE }, 1, FALSE },
    [PHOTO_ALBUM_SPRITE_PREV_ARROW] = { 16, 64, 0, 0, 2, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, SPRITE_RESOURCE_NONE, SPRITE_RESOURCE_NONE }, 1, FALSE },
    [PHOTO_ALBUM_SPRITE_NEXT_ARROW] = { 240, 64, 0, 3, 2, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, SPRITE_RESOURCE_NONE, SPRITE_RESOURCE_NONE }, 1, FALSE },
    [PHOTO_ALBUM_SPRITE_EXIT_BUTTON] = { 224, 176, 0, 8, 0xFF, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, SPRITE_RESOURCE_NONE, SPRITE_RESOURCE_NONE }, 1, FALSE },
};

// PhotoAlbum_Init
BOOL CompletePhotoAlbum_AppInit(OverlayManager *man, int *state) {
    switch (*state) {
    case 0:
        PhotoAlbum_ScreenOff();
        Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_PHOTO_ALBUM, 0x20000);
        PhotoAlbumAppData *data = OverlayManager_CreateAndGetData(man, sizeof(PhotoAlbumAppData), HEAP_ID_PHOTO_ALBUM);
        MI_CpuFill8(data, 0, sizeof(PhotoAlbumAppData));
        data->heapID = HEAP_ID_PHOTO_ALBUM;
        data->args = OverlayManager_GetArgs(man);
        PhotoAlbum_InitFromArgs(data);
        (*state)++;
        break;
    case 1:
        if (PhotoAlbum_OverlayEnterStep(OverlayManager_GetData(man))) {
            return TRUE;
        }
        break;
    }
    return FALSE;
}

// PhotoAlbum_Main
BOOL CompletePhotoAlbum_AppMain(OverlayManager *man, int *state) {
    PhotoAlbumAppData *data = OverlayManager_GetData(man);

    switch (*state) {
    case PHOTO_ALBUM_STATE_FADE_IN:
        *state = PhotoAlbumMainSeq_FadeIn(data);
        break;
    case PHOTO_ALBUM_STATE_BROWSE:
        *state = PhotoAlbumMainSeq_Browse(data);
        break;
    case PHOTO_ALBUM_STATE_FLIP_PREV_PAGE:
        *state = PhotoAlbumMainSeq_FlipPrevPage(data);
        break;
    case PHOTO_ALBUM_STATE_FLIP_NEXT_PAGE:
        *state = PhotoAlbumMainSeq_FlipNextPage(data);
        break;
    case PHOTO_ALBUM_STATE_ACTION_MENU:
        *state = PhotoAlbumMainSeq_ActionMenu(data);
        break;
    case PHOTO_ALBUM_STATE_MOVE:
        *state = PhotoAlbumMainSeq_Move(data);
        break;
    case PHOTO_ALBUM_STATE_SWAPPED:
        *state = PhotoAlbumMainSeq_Swapped(data);
        break;
    case PHOTO_ALBUM_STATE_CONFIRM_DELETE:
        *state = PhotoAlbumMainSeq_ConfirmDelete(data);
        break;
    case PHOTO_ALBUM_STATE_FADE_OUT:
        *state = PhotoAlbumMainSeq_FadeOut(data);
        break;
    case PHOTO_ALBUM_STATE_END:
        return TRUE;
    }
    SpriteSystem_DrawSprites(data->spriteManager);
    return FALSE;
}

// PhotoAlbum_Exit
BOOL CompletePhotoAlbum_AppExit(OverlayManager *man, int *state) {
    PhotoAlbumAppData *data = OverlayManager_GetData(man);

    if (!PhotoAlbum_OverlayExitStep(data)) {
        return FALSE;
    }
    PhotoAlbum_ScreenOff();
    PhotoAlbum_Finish(data);
    OverlayManager_FreeData(man);
    Heap_Destroy(HEAP_ID_PHOTO_ALBUM);
    return TRUE;
}

// ov109_021E5A20
static void PhotoAlbum_ScreenOff(void) {
    Main_SetVBlankIntrCB(NULL, NULL);
    HBlankInterruptDisable();
    GfGfx_DisableEngineAPlanes();
    GfGfx_DisableEngineBPlanes();
    GX_SetVisiblePlane(GX_PLANEMASK_NONE);
    GXS_SetVisiblePlane(GX_PLANEMASK_NONE);
    sub_0200FBF4(PM_LCD_TOP, RGB_BLACK);
    sub_0200FBF4(PM_LCD_BOTTOM, RGB_BLACK);
    ResetVisibleHardwareWindows(PM_LCD_TOP);
    ResetVisibleHardwareWindows(PM_LCD_BOTTOM);
}

// ov109_021E5A70
static void PhotoAlbum_InitFromArgs(PhotoAlbumAppData *data) {
    data->menuInputState = (*data->args->menuInputState);

    Options *options = SaveData_GetOptions(data->args->saveData);
    data->textFrameDelay = Options_GetTextFrameDelay(options);
    data->frame = Options_GetFrame(options);

    // Put the cursor on the photo the album was last left at.
    u8 cursorPos = data->args->cursorPos;
    u8 gridPos = sSpreadSlotToGridPos[cursorPos % PHOTO_ALBUM_PER_SPREAD];
    data->page = cursorPos / PHOTO_ALBUM_PER_SPREAD;
    data->cursorX = gridPos % PHOTO_ALBUM_GRID_WIDTH;
    data->cursorY = gridPos / PHOTO_ALBUM_GRID_WIDTH;

    data->photoAlbum = CompletePhotoAlbum_Load(data->args->saveData, data->heapID);
    data->numPhotosSaved = CompletePhotoAlbum_Count(data->photoAlbum);
    data->photos = PhotoAlbum_LoadAllInUsePhotos(data->photoAlbum, data->numPhotosSaved, data->heapID);
    data->numPhotos = data->numPhotosSaved;

    data->numPages = data->numPhotos / PHOTO_ALBUM_PER_SPREAD;
    if (data->numPhotos % PHOTO_ALBUM_PER_SPREAD != 0) {
        data->numPages++;
    }
    if (data->numPhotos == 0) {
        data->numPages = 1;
    }
    PhotoAlbum_InitEntries(data);
}

// ov109_021E5B40
static void PhotoAlbum_Finish(PhotoAlbumAppData *data) {
    PhotoAlbum_SaveEntries(data);
    Heap_Free(data->photos);
    Heap_Free(data->photoAlbum);
    (*data->args->menuInputState = data->menuInputState);
}

// ov109_021E5B60
static BOOL PhotoAlbum_OverlayEnterStep(PhotoAlbumAppData *data) {
    switch (data->subState) {
    case 0:
        PhotoAlbum_SetupGraphics(data);
        data->subState++;
        break;
    case 1:
        PhotoAlbum_DrawInitialScreen(data);
        EnableTouchPad();
        InitializeTouchPad(4);
        data->subState = 0;
        return TRUE;
    }
    return FALSE;
}

// ov109_021E5B98
static BOOL PhotoAlbum_OverlayExitStep(PhotoAlbumAppData *data) {
    DisableTouchPad();
    PhotoAlbum_TeardownGraphics(data);
    return TRUE;
}

// ov109_021E5BAC
static int PhotoAlbumMainSeq_FadeIn(PhotoAlbumAppData *data) {
    switch (data->subState) {
    case 0:
        BeginNormalPaletteFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_IN, FADE_TYPE_BRIGHTNESS_IN, RGB_BLACK, 6, 1, data->heapID);
        data->subState++;
        break;
    case 1:
        if (IsPaletteFadeFinished()) {
            data->subState = 0;
            return PHOTO_ALBUM_STATE_BROWSE;
        }
        break;
    }
    return PHOTO_ALBUM_STATE_FADE_IN;
}

// ov109_021E5BF4
static int PhotoAlbumMainSeq_FadeOut(PhotoAlbumAppData *data) {
    switch (data->subState) {
    case 0:
        BeginNormalPaletteFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_OUT, FADE_TYPE_BRIGHTNESS_OUT, RGB_BLACK, 6, 1, data->heapID);
        data->subState++;
        break;
    case 1:
        if (IsPaletteFadeFinished()) {
            data->subState = 0;
            return PHOTO_ALBUM_STATE_END;
        }
        break;
    }
    return PHOTO_ALBUM_STATE_FADE_OUT;
}

// ov109_021E5C40
static int PhotoAlbumMainSeq_Browse(PhotoAlbumAppData *data) {
    return PhotoAlbum_Browse_HandleInput(data);
}

// ov109_021E5C48
static int PhotoAlbumMainSeq_FlipPrevPage(PhotoAlbumAppData *data) {
    if (!PhotoAlbum_RunFlipPrevPage(data)) {
        return PHOTO_ALBUM_STATE_FLIP_PREV_PAGE;
    }
    if (data->mode == PHOTO_ALBUM_MODE_MOVE) {
        return PHOTO_ALBUM_STATE_MOVE;
    }
    return PHOTO_ALBUM_STATE_BROWSE;
}

// ov109_021E5C68
static int PhotoAlbumMainSeq_FlipNextPage(PhotoAlbumAppData *data) {
    if (!PhotoAlbum_RunFlipNextPage(data)) {
        return PHOTO_ALBUM_STATE_FLIP_NEXT_PAGE;
    }
    if (data->mode == PHOTO_ALBUM_MODE_MOVE) {
        return PHOTO_ALBUM_STATE_MOVE;
    }
    return PHOTO_ALBUM_STATE_BROWSE;
}

// ov109_021E5C88
static int PhotoAlbumMainSeq_ActionMenu(PhotoAlbumAppData *data) {
    return PhotoAlbum_ActionMenu_Run(data);
}

// ov109_021E5C90
static int PhotoAlbumMainSeq_Move(PhotoAlbumAppData *data) {
    return PhotoAlbum_Move_HandleInput(data);
}

// ov109_021E5C98
static int PhotoAlbumMainSeq_Swapped(PhotoAlbumAppData *data) {
    if (PhotoAlbum_Swapped_Run(data)) {
        return PHOTO_ALBUM_STATE_BROWSE;
    }
    return PHOTO_ALBUM_STATE_SWAPPED;
}

// ov109_021E5CAC
static int PhotoAlbumMainSeq_ConfirmDelete(PhotoAlbumAppData *data) {
    return PhotoAlbum_ConfirmDelete_Run(data);
}

// ov109_021E5CB4
static void PhotoAlbum_SetupGraphics(PhotoAlbumAppData *data) {
    PhotoAlbum_InitBgLayers(data);
    PhotoAlbum_LoadBgGraphics(data);
    PhotoAlbum_InitText(data);
    PhotoAlbum_CreateWindows(data);
    PhotoAlbum_CreateSpriteGraphics(data);
    Main_SetVBlankIntrCB(PhotoAlbum_VBlankCB, data);
}

// ov109_021E5CE4
static void PhotoAlbum_TeardownGraphics(PhotoAlbumAppData *data) {
    PhotoAlbum_DeleteSpriteGraphics(data);
    PhotoAlbum_DestroyWindows(data);
    PhotoAlbum_DeleteText(data);
    PhotoAlbum_FreeBgGraphics(data);
    PhotoAlbum_FreeBgLayers(data);
}

// ov109_021E5D08
static void PhotoAlbum_InitEntries(PhotoAlbumAppData *data) {
    u8 i;

    data->numPhotos = data->numPhotosSaved;
    MI_CpuFill8(data->entries, 0, sizeof(data->entries));
    for (i = 0; i < data->numPhotos; i++) {
        PhotoAlbumEntry *entry = &data->entries[i];
        entry->loadIndex = i;
        entry->photo = &data->photos[i];
    }
}

// ov109_021E5D5C
// Writes the photos back in the album's new order, then clears the slots of the deleted ones.
static void PhotoAlbum_SaveEntries(PhotoAlbumAppData *data) {
    u8 i;
    BOOL changed = data->numPhotos != data->numPhotosSaved;

    for (i = 0; i < data->numPhotos; i++) {
        changed |= data->entries[i].photo != &data->photos[i];
        data->photoAlbum->photos[i] = *data->entries[i].photo;
    }
    for (; i < data->numPhotosSaved; i++) {
        MI_CpuClear8(&data->photoAlbum->photos[i], sizeof(CompletePhoto));
    }

    if (changed) { // Sovereign Complete: the album's sector written only for a change
        CompletePhotoAlbum_Save(data->args->saveData, data->photoAlbum);
    }
}

// ov109_021E5DB8
static void PhotoAlbum_SwapEntries(PhotoAlbumAppData *data, u8 a, u8 b) {
    PhotoAlbumEntry tmp;

    MI_CpuCopy8(&data->entries[a], &tmp, sizeof(PhotoAlbumEntry));
    MI_CpuCopy8(&data->entries[b], &data->entries[a], sizeof(PhotoAlbumEntry));
    MI_CpuCopy8(&tmp, &data->entries[b], sizeof(PhotoAlbumEntry));
}

// ov109_021E5DEC
static void PhotoAlbum_DeleteEntry(PhotoAlbumAppData *data, u8 index) {
    u8 i;

    data->numPhotos--;
    if (index < data->numPhotos) {
        for (i = index; i < data->numPhotos; i++) {
            MI_CpuCopy8(&data->entries[i + 1], &data->entries[i], sizeof(PhotoAlbumEntry));
        }
    }
    MI_CpuFill8(&data->entries[data->numPhotos], 0, sizeof(PhotoAlbumEntry));

    data->numPages = data->numPhotos / PHOTO_ALBUM_PER_SPREAD;
    if (data->numPhotos % PHOTO_ALBUM_PER_SPREAD != 0) {
        data->numPages++;
    }
    if (data->numPhotos == 0) {
        data->numPages = 1;
    }

    if (index >= data->numPhotos) {
        // The last photo was deleted: move the cursor to the one before it, or to EXIT if none is left.
        if (data->numPhotos == 0) {
            data->cursorX = 3;
            data->cursorY = PHOTO_ALBUM_CURSOR_Y_EXIT;
            data->page = 0;
            return;
        }
        if (index != 0) {
            index--;
        }
        data->page = index / PHOTO_ALBUM_PER_SPREAD;
        u8 gridPos = sSpreadSlotToGridPos[index % PHOTO_ALBUM_PER_SPREAD];
        data->cursorX = gridPos % PHOTO_ALBUM_GRID_WIDTH;
        data->cursorY = gridPos / PHOTO_ALBUM_GRID_WIDTH;
    }
}

// ov109_021E5EC8
static void PhotoAlbum_DrawInitialScreen(PhotoAlbumAppData *data) {
    PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_3, PHOTO_ALBUM_HALF_BOTH, data->page);
    PhotoAlbum_UpdatePageArrows(data);
    PhotoAlbum_DrawExitButton(data, FALSE);
    PhotoAlbum_PrintMessage(data, PHOTO_ALBUM_MSG_SELECT_PHOTO, TRUE, 0);
    PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
    ScheduleBgTilemapBufferTransfer(data->bgConfig, GF_BG_LYR_MAIN_3);
    ScheduleBgTilemapBufferTransfer(data->bgConfig, GF_BG_LYR_MAIN_2);
}

// Not a function in the overlay: inlined in the key handlers.
static inline u8 PhotoAlbum_CursorPosToInput(u8 x, u8 y) {
    if (y >= PHOTO_ALBUM_CURSOR_Y_EXIT) {
        return PHOTO_ALBUM_INPUT_EXIT;
    }
    return y * PHOTO_ALBUM_GRID_WIDTH + x;
}

// ov109_021E5F10
static int PhotoAlbum_Browse_HandleInput(PhotoAlbumAppData *data) {
    BOOL touched = FALSE;

    if (data->exitButtonAnimActive) {
        return PHOTO_ALBUM_STATE_BROWSE;
    }
    int ret = PhotoAlbum_Browse_HandleTouch(data, &touched);
    if (!touched) {
        ret = PhotoAlbum_Browse_HandleKeys(data);
    }
    return ret;
}

// ov109_021E5F40
static int PhotoAlbum_Browse_DoInput(PhotoAlbumAppData *data, u8 input) {
    switch (input) {
    case PHOTO_ALBUM_INPUT_EXIT:
        data->args->photoWasSelected = FALSE;
        PlaySE(SEQ_SE_DP_SELECT);
        PhotoAlbum_DrawExitButton(data, TRUE);
        return PHOTO_ALBUM_STATE_FADE_OUT;
    case PHOTO_ALBUM_INPUT_PREV_PAGE:
        if (data->page == 0) {
            return PHOTO_ALBUM_STATE_BROWSE;
        }
        PhotoAlbum_AnimatePageArrow(data, PHOTO_ALBUM_SPRITE_PREV_ARROW);
        PlaySE(SEQ_SE_GS_ALBUMMEKURU_sseq);
        return PHOTO_ALBUM_STATE_FLIP_PREV_PAGE;
    case PHOTO_ALBUM_INPUT_NEXT_PAGE:
        if (data->page == data->numPages - 1) {
            return PHOTO_ALBUM_STATE_BROWSE;
        }
        PhotoAlbum_AnimatePageArrow(data, PHOTO_ALBUM_SPRITE_NEXT_ARROW);
        PlaySE(SEQ_SE_GS_ALBUMMEKURU_sseq);
        return PHOTO_ALBUM_STATE_FLIP_NEXT_PAGE;
    default: {
        u8 photoNo = sGridPosToSpreadSlot[input] + data->page * PHOTO_ALBUM_PER_SPREAD;
        if (photoNo >= data->numPhotos) {
            return PHOTO_ALBUM_STATE_BROWSE;
        }
        data->selectedPhoto = photoNo;
        data->selectedCursorX = data->cursorX;
        data->selectedCursorY = data->cursorY;
        PlaySE(SEQ_SE_DP_SELECT);
        PhotoAlbum_OpenActionMenu(data);
        PhotoAlbum_PrintPhotoDetails(data, data->entries[photoNo].photo);
        PhotoAlbum_ShowSelectionMarker(data, TRUE);
        return PHOTO_ALBUM_STATE_ACTION_MENU;
    }
    }
}

// ov109_021E5FFC
static int PhotoAlbum_Browse_HandleTouch(PhotoAlbumAppData *data, BOOL *touched) {
    u32 input = TouchscreenHitbox_FindRectAtTouchNew(sTouchHitboxes);
    if (input == (u32)TOUCH_MENU_NO_INPUT) {
        return PHOTO_ALBUM_STATE_BROWSE;
    }
    if (data->menuInputState == MENU_INPUT_STATE_BUTTONS) {
        PhotoAlbum_ToggleMenuInputState(data);
    }
    *touched = TRUE;
    if (input < PHOTO_ALBUM_PER_SPREAD) {
        data->cursorX = input % PHOTO_ALBUM_GRID_WIDTH;
        data->cursorY = input / PHOTO_ALBUM_GRID_WIDTH;
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
        PlaySE(SEQ_SE_DP_SELECT);
    }
    return PhotoAlbum_Browse_DoInput(data, input);
}

// ov109_021E6058
static int PhotoAlbum_Browse_HandleKeys(PhotoAlbumAppData *data) {
    u8 input;

    if (data->menuInputState == MENU_INPUT_STATE_TOUCH && (gSystem.pressedKeys & (PAD_BUTTON_A | PAD_BUTTON_B | PAD_KEY_UP | PAD_KEY_DOWN | PAD_KEY_LEFT | PAD_KEY_RIGHT))) {
        PhotoAlbum_ToggleMenuInputState(data);
    }

    if (gSystem.pressedKeys & PAD_BUTTON_A) {
        input = PhotoAlbum_CursorPosToInput(data->cursorX, data->cursorY);
        return PhotoAlbum_Browse_DoInput(data, input);
    }
    if (gSystem.pressedKeys & PAD_BUTTON_B) {
        return PhotoAlbum_Browse_DoInput(data, PHOTO_ALBUM_INPUT_EXIT);
    }
    if (gSystem.pressedKeys & PAD_KEY_LEFT) {
        input = PhotoAlbum_CursorPosToInput(data->cursorX, data->cursorY);
        if (input == PHOTO_ALBUM_INPUT_EXIT) {
            return PHOTO_ALBUM_STATE_BROWSE;
        }
        if (data->cursorX != 0) {
            PlaySE(SEQ_SE_DP_SELECT);
            data->cursorX--;
            PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
        } else if (data->page != 0) {
            return PhotoAlbum_Browse_DoInput(data, PHOTO_ALBUM_INPUT_PREV_PAGE);
        }
    } else if (gSystem.pressedKeys & PAD_KEY_RIGHT) {
        input = PhotoAlbum_CursorPosToInput(data->cursorX, data->cursorY);
        if (input == PHOTO_ALBUM_INPUT_EXIT) {
            return PHOTO_ALBUM_STATE_BROWSE;
        }
        if (data->cursorX < PHOTO_ALBUM_GRID_WIDTH - 1) {
            PlaySE(SEQ_SE_DP_SELECT);
            data->cursorX++;
            PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
        } else if (data->page < data->numPages - 1) {
            return PhotoAlbum_Browse_DoInput(data, PHOTO_ALBUM_INPUT_NEXT_PAGE);
        }
    } else if (gSystem.pressedKeys & PAD_KEY_UP) {
        // cursorY is never 4 (it wraps over 0-3), so this never happens.
        if (data->cursorY == 4 && data->cursorX < 3) {
            data->cursorX = 3;
        }
        PlaySE(SEQ_SE_DP_SELECT);
        data->cursorY = (data->cursorY + 3) % 4;
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
    } else if (gSystem.pressedKeys & PAD_KEY_DOWN) {
        PlaySE(SEQ_SE_DP_SELECT);
        data->cursorY = (data->cursorY + 1) % 4;
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
    }
    return PHOTO_ALBUM_STATE_BROWSE;
}

// ov109_021E61BC
static int PhotoAlbum_Move_HandleInput(PhotoAlbumAppData *data) {
    BOOL touched = FALSE;

    int ret = PhotoAlbum_Move_HandleTouch(data, &touched);
    if (!touched) {
        ret = PhotoAlbum_Move_HandleKeys(data);
    }
    return ret;
}

// ov109_021E61DC
static BOOL PhotoAlbum_Swapped_Run(PhotoAlbumAppData *data) {
    switch (data->seqStep) {
    case 0:
        // The two swapped slots stay blank for 16 frames.
        if (data->timer++ < 15) {
            return FALSE;
        }
        PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_3, PHOTO_ALBUM_HALF_BOTH, data->page);
        PhotoAlbum_PrintMessage(data, PHOTO_ALBUM_MSG_SWITCHED, FALSE, data->textFrameDelay);
        data->timer = 0;
        data->seqStep++;
        break;
    case 1:
        if (data->timer++ < 30) {
            return FALSE;
        }
        if (TextPrinterCheckActive(data->textPrinterId)) {
            return FALSE;
        }
        data->timer = 0;
        data->seqStep++;
        break;
    default:
        data->mode = PHOTO_ALBUM_MODE_NONE;
        PlaySE(SEQ_SE_DP_SELECT);
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
        PhotoAlbum_PrintMessage(data, PHOTO_ALBUM_MSG_SELECT_PHOTO, FALSE, 0);
        ScheduleBgTilemapBufferTransfer(data->bgConfig, GF_BG_LYR_MAIN_3);
        data->timer = 0;
        data->seqStep = 0;
        return TRUE;
    }
    return FALSE;
}

// ov109_021E628C
static int PhotoAlbum_Move_DoInput(PhotoAlbumAppData *data, u8 input) {
    switch (input) {
    case PHOTO_ALBUM_INPUT_EXIT:
        // Cancels the move (the album stays open).
        PlaySE(SEQ_SE_DP_SELECT);
        PhotoAlbum_PrintPhotoDetails(data, NULL);
        PhotoAlbum_ShowSelectionMarker(data, FALSE);
        PhotoAlbum_StartExitButtonTask(data);
        PhotoAlbum_PrintMessage(data, PHOTO_ALBUM_MSG_SELECT_PHOTO, FALSE, 0);
        data->mode = PHOTO_ALBUM_MODE_NONE;
        return PHOTO_ALBUM_STATE_BROWSE;
    case PHOTO_ALBUM_INPUT_PREV_PAGE:
        if (data->page == 0) {
            return PHOTO_ALBUM_STATE_MOVE;
        }
        PhotoAlbum_AnimatePageArrow(data, PHOTO_ALBUM_SPRITE_PREV_ARROW);
        PlaySE(SEQ_SE_GS_ALBUMMEKURU_sseq);
        return PHOTO_ALBUM_STATE_FLIP_PREV_PAGE;
    case PHOTO_ALBUM_INPUT_NEXT_PAGE:
        if (data->page == data->numPages - 1) {
            return PHOTO_ALBUM_STATE_MOVE;
        }
        PhotoAlbum_AnimatePageArrow(data, PHOTO_ALBUM_SPRITE_NEXT_ARROW);
        PlaySE(SEQ_SE_GS_ALBUMMEKURU_sseq);
        return PHOTO_ALBUM_STATE_FLIP_NEXT_PAGE;
    default: {
        u8 photoNo = sGridPosToSpreadSlot[input] + data->page * PHOTO_ALBUM_PER_SPREAD;
        if (photoNo >= data->numPhotos) {
            return PHOTO_ALBUM_STATE_MOVE;
        }
        PlaySE(SEQ_SE_DP_SELECT);
        PhotoAlbum_ShowSelectionMarker(data, FALSE);
        PhotoAlbum_PrintPhotoDetails(data, NULL);
        if (photoNo != data->selectedPhoto) {
            PhotoAlbum_SwapEntries(data, data->selectedPhoto, photoNo);
            PhotoAlbum_ClearSwappedIcons(data, data->selectedPhoto, photoNo);
            PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, FALSE);
            data->timer = 0;
            return PHOTO_ALBUM_STATE_SWAPPED;
        }
        // Picked the same photo again: cancel the move.
        data->mode = PHOTO_ALBUM_MODE_NONE;
        PhotoAlbum_PrintMessage(data, PHOTO_ALBUM_MSG_SELECT_PHOTO, FALSE, 0);
        return PHOTO_ALBUM_STATE_BROWSE;
    }
    }
}

// ov109_021E638C
static int PhotoAlbum_Move_HandleTouch(PhotoAlbumAppData *data, BOOL *touched) {
    u32 input = TouchscreenHitbox_FindRectAtTouchNew(sTouchHitboxes);
    if (input == (u32)TOUCH_MENU_NO_INPUT) {
        return PHOTO_ALBUM_STATE_MOVE;
    }
    if (data->menuInputState == MENU_INPUT_STATE_BUTTONS) {
        PhotoAlbum_ToggleMenuInputState(data);
    }
    *touched = TRUE;
    if (input < PHOTO_ALBUM_PER_SPREAD) {
        data->cursorX = input % PHOTO_ALBUM_GRID_WIDTH;
        data->cursorY = input / PHOTO_ALBUM_GRID_WIDTH;
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
        PlaySE(SEQ_SE_DP_SELECT);
    }
    return PhotoAlbum_Move_DoInput(data, input);
}

// ov109_021E63E8
static int PhotoAlbum_Move_HandleKeys(PhotoAlbumAppData *data) {
    u8 input;

    if (data->menuInputState == MENU_INPUT_STATE_TOUCH && (gSystem.pressedKeys & (PAD_BUTTON_A | PAD_BUTTON_B | PAD_KEY_UP | PAD_KEY_DOWN | PAD_KEY_LEFT | PAD_KEY_RIGHT))) {
        PhotoAlbum_ToggleMenuInputState(data);
    }

    if (gSystem.pressedKeys & PAD_BUTTON_A) {
        input = PhotoAlbum_CursorPosToInput(data->cursorX, data->cursorY);
        return PhotoAlbum_Move_DoInput(data, input);
    }
    if (gSystem.pressedKeys & PAD_BUTTON_B) {
        return PhotoAlbum_Move_DoInput(data, PHOTO_ALBUM_INPUT_EXIT);
    }
    if (gSystem.pressedKeys & PAD_KEY_LEFT) {
        input = PhotoAlbum_CursorPosToInput(data->cursorX, data->cursorY);
        if (input == PHOTO_ALBUM_INPUT_EXIT) {
            // Original behaviour: returns to the browse state while still in PHOTO_ALBUM_MODE_MOVE.
            return PHOTO_ALBUM_STATE_BROWSE;
        }
        if (data->cursorX != 0) {
            PlaySE(SEQ_SE_DP_SELECT);
            data->cursorX--;
            PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
        } else if (data->page != 0) {
            data->cursorX = (data->cursorX + 3) % 4;
            return PhotoAlbum_Move_DoInput(data, PHOTO_ALBUM_INPUT_PREV_PAGE);
        }
    } else if (gSystem.pressedKeys & PAD_KEY_RIGHT) {
        input = PhotoAlbum_CursorPosToInput(data->cursorX, data->cursorY);
        if (input == PHOTO_ALBUM_INPUT_EXIT) {
            // Original behaviour: returns to the browse state while still in PHOTO_ALBUM_MODE_MOVE.
            return PHOTO_ALBUM_STATE_BROWSE;
        }
        if (data->cursorX < PHOTO_ALBUM_GRID_WIDTH - 1) {
            PlaySE(SEQ_SE_DP_SELECT);
            data->cursorX++;
            PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
        } else if (data->page < data->numPages - 1) {
            data->cursorX = (data->cursorX + 1) % 4;
            return PhotoAlbum_Move_DoInput(data, PHOTO_ALBUM_INPUT_NEXT_PAGE);
        }
    } else if (gSystem.pressedKeys & PAD_KEY_UP) {
        // cursorY is never 4 (it wraps over 0-3), so this never happens.
        if (data->cursorY == 4 && data->cursorX < 3) {
            data->cursorX = 3;
        }
        PlaySE(SEQ_SE_DP_SELECT);
        data->cursorY = (data->cursorY + 3) % 4;
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
    } else if (gSystem.pressedKeys & PAD_KEY_DOWN) {
        PlaySE(SEQ_SE_DP_SELECT);
        data->cursorY = (data->cursorY + 1) % 4;
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
    }
    return PHOTO_ALBUM_STATE_MOVE;
}

// ov109_021E656C
// Turns the left page over to the right. Main BG2 holds the turning page, scaled horizontally about the
// album's spine; main BG3 shows what lies under it.
static BOOL PhotoAlbum_RunFlipPrevPage(PhotoAlbumAppData *data) {
    switch (data->seqStep) {
    case 0:
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, FALSE);
        PhotoAlbum_ShowSelectionMarker(data, FALSE);
        PhotoAlbum_ScheduleFlipLayerToggle(data, TRUE);
        PhotoAlbum_ScheduleFlipLayerScale(data, FX32_ONE);
        PhotoAlbum_DrawTurningHalfPage(data, PHOTO_ALBUM_HALF_LEFT, TRUE);
        PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_2, PHOTO_ALBUM_HALF_LEFT, data->page);
        PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_3, PHOTO_ALBUM_HALF_LEFT, data->page - 1);
        data->flipFrame = 0;
        data->seqStep++;
        break;
    case 1:
        data->flipFrame++;
        PhotoAlbum_ScheduleFlipLayerScale(data, sFlipLayerScales[data->flipFrame]);
        if (data->flipFrame >= 4) {
            PhotoAlbum_DrawTurningHalfPage(data, PHOTO_ALBUM_HALF_RIGHT, TRUE);
            PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_2, PHOTO_ALBUM_HALF_RIGHT, data->page - 1);
            data->seqStep++;
        }
        break;
    case 2:
        data->flipFrame -= 1;
        PhotoAlbum_ScheduleFlipLayerScale(data, sFlipLayerScales[data->flipFrame]);
        if (data->flipFrame == 0) {
            PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_3, PHOTO_ALBUM_HALF_RIGHT, data->page - 1);
            PhotoAlbum_ScheduleFlipLayerToggle(data, FALSE);
            PhotoAlbum_ScheduleFlipLayerScale(data, FX32_ONE);
            data->page--;
            PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
            PhotoAlbum_UpdatePageArrows(data);
            if (data->mode == PHOTO_ALBUM_MODE_MOVE) {
                PhotoAlbum_ShowSelectionMarker(data, TRUE);
            }
            data->seqStep = 0;
            return TRUE;
        }
        break;
    }
    return FALSE;
}

// ov109_021E66C4
// Turns the right page over to the left (see PhotoAlbum_RunFlipPrevPage).
static BOOL PhotoAlbum_RunFlipNextPage(PhotoAlbumAppData *data) {
    switch (data->seqStep) {
    case 0:
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, FALSE);
        PhotoAlbum_ShowSelectionMarker(data, FALSE);
        PhotoAlbum_ScheduleFlipLayerToggle(data, TRUE);
        PhotoAlbum_ScheduleFlipLayerScale(data, FX32_ONE);
        PhotoAlbum_DrawTurningHalfPage(data, PHOTO_ALBUM_HALF_RIGHT, TRUE);
        PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_2, PHOTO_ALBUM_HALF_RIGHT, data->page);
        PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_3, PHOTO_ALBUM_HALF_RIGHT, data->page + 1);
        data->flipFrame = 0;
        data->seqStep++;
        break;
    case 1:
        data->flipFrame++;
        PhotoAlbum_ScheduleFlipLayerScale(data, sFlipLayerScales[data->flipFrame]);
        if (data->flipFrame >= 4) {
            PhotoAlbum_DrawTurningHalfPage(data, PHOTO_ALBUM_HALF_LEFT, TRUE);
            PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_2, PHOTO_ALBUM_HALF_LEFT, data->page + 1);
            data->seqStep++;
        }
        break;
    case 2:
        data->flipFrame -= 1;
        PhotoAlbum_ScheduleFlipLayerScale(data, sFlipLayerScales[data->flipFrame]);
        if (data->flipFrame == 0) {
            PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_3, PHOTO_ALBUM_HALF_LEFT, data->page + 1);
            PhotoAlbum_ScheduleFlipLayerToggle(data, FALSE);
            PhotoAlbum_ScheduleFlipLayerScale(data, FX32_ONE);
            data->page++;
            PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
            PhotoAlbum_UpdatePageArrows(data);
            if (data->mode == PHOTO_ALBUM_MODE_MOVE) {
                PhotoAlbum_ShowSelectionMarker(data, TRUE);
            }
            data->seqStep = 0;
            return TRUE;
        }
        break;
    }
    return FALSE;
}

// ov109_021E681C
static int PhotoAlbum_ActionMenu_Run(PhotoAlbumAppData *data) {
    int ret = PhotoAlbum_ActionMenu_HandleInput(data);
    if (ret < 0) {
        ret = PHOTO_ALBUM_STATE_ACTION_MENU;
    }
    return ret;
}

// ov109_021E682C
static int PhotoAlbum_ConfirmDelete_Run(PhotoAlbumAppData *data) {
    switch (data->seqStep) {
    case 0:
        PhotoAlbum_CreateDeleteYesNoPrompt(data);
        data->seqStep++;
        break;
    case 1:
        if (PhotoAlbum_DeleteYesNoPrompt_HandleInput(data) != PHOTO_ALBUM_STATE_CONFIRM_DELETE) {
            data->seqStep = 0;
            return PHOTO_ALBUM_STATE_BROWSE;
        }
        break;
    }
    return PHOTO_ALBUM_STATE_CONFIRM_DELETE;
}

// ov109_021E685C
static void PhotoAlbum_VBlankCB(void *cbData) {
    PhotoAlbumAppData *data = cbData;

    if (data->spriteSystem != NULL) {
        SpriteSystem_TransferOam();
    }
    PhotoAlbum_ApplyFlipLayerToggle(data);
    PhotoAlbum_ApplyFlipLayerScale(data);
    NNS_GfdDoVramTransfer();
    DoScheduledBgGpuUpdates(data->bgConfig);
    OS_SetIrqCheckFlag(OS_IE_V_BLANK);
}

// ov109_021E6898
static void PhotoAlbum_ApplyFlipLayerToggle(PhotoAlbumAppData *data) {
    if (data->flipLayerToggleDirty) {
        ToggleBgLayer(GF_BG_LYR_MAIN_2, data->flipLayerShow);
    }
    data->flipLayerToggleDirty = FALSE;
}

// ov109_021E68B8
static void PhotoAlbum_ScheduleFlipLayerToggle(PhotoAlbumAppData *data, BOOL show) {
    data->flipLayerShow = (u8)show;
    data->flipLayerToggleDirty = TRUE;
}

// ov109_021E68D4
static void PhotoAlbum_ApplyFlipLayerScale(PhotoAlbumAppData *data) {
    MtxFx22 mtx;

    if (data->flipLayerScaleDirty) {
        mtx._01 = 0;
        mtx._10 = 0;
        mtx._11 = FX_Inv(FX32_ONE);
        mtx._00 = FX_Inv(data->flipLayerScale);
        SetBgAffine(data->bgConfig, GF_BG_LYR_MAIN_2, &mtx, 128, 120);
        data->flipLayerScaleDirty = FALSE;
    }
}

// ov109_021E691C
static void PhotoAlbum_ScheduleFlipLayerScale(PhotoAlbumAppData *data, fx32 scale) {
    data->flipLayerScale = scale;
    data->flipLayerScaleDirty = TRUE;
}

// ov109_021E692C
static void PhotoAlbum_SetGraphicsBanks(void) {
    GraphicsBanks banks = sGraphicsBanks;
    GfGfx_SetBanks(&banks);
}

// ov109_021E694C
static void PhotoAlbum_InitBgLayers(PhotoAlbumAppData *data) {
    PhotoAlbum_SetGraphicsBanks();
    data->bgConfig = BgConfig_Alloc(data->heapID);

    GraphicsModes modes = sGraphicsModes;
    SetBothScreensModesAndDisable(&modes);

    // The main engine (the album) goes to the bottom (touch) screen.
    GX_SetDispSelect(GX_DISP_SELECT_SUB_MAIN);

    BgTemplate sub0 = sBgTemplate_Sub0;
    InitBgFromTemplate(data->bgConfig, GF_BG_LYR_SUB_0, &sub0, GF_BG_TYPE_TEXT);
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_SUB_0);

    BgTemplate sub3 = sBgTemplate_Sub3;
    InitBgFromTemplate(data->bgConfig, GF_BG_LYR_SUB_3, &sub3, GF_BG_TYPE_256x16PLTT);
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_SUB_3);

    BgTemplate sub2 = sBgTemplate_Sub2;
    InitBgFromTemplate(data->bgConfig, GF_BG_LYR_SUB_2, &sub2, GF_BG_TYPE_TEXT);
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_SUB_2);

    BgTemplate main0 = sBgTemplate_Main0;
    InitBgFromTemplate(data->bgConfig, GF_BG_LYR_MAIN_0, &main0, GF_BG_TYPE_TEXT);
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_MAIN_0);

    BgTemplate main1 = sBgTemplate_Main1;
    InitBgFromTemplate(data->bgConfig, GF_BG_LYR_MAIN_1, &main1, GF_BG_TYPE_TEXT);
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_MAIN_1);

    BgTemplate main2 = sBgTemplate_Main2;
    InitBgFromTemplate(data->bgConfig, GF_BG_LYR_MAIN_2, &main2, GF_BG_TYPE_256x16PLTT);
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_MAIN_2);

    BgTemplate main3 = sBgTemplate_Main3;
    InitBgFromTemplate(data->bgConfig, GF_BG_LYR_MAIN_3, &main3, GF_BG_TYPE_256x16PLTT);
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_MAIN_3);

    BG_ClearCharDataRange(GF_BG_LYR_SUB_0, 0x20, 0, data->heapID);
    BG_ClearCharDataRange(GF_BG_LYR_SUB_2, 0x20, 0, data->heapID);
    BG_ClearCharDataRange(GF_BG_LYR_MAIN_0, 0x20, 0, data->heapID);
    BG_ClearCharDataRange(GF_BG_LYR_MAIN_3, 0x40, 0, data->heapID);
    BgSetPosTextAndCommit(data->bgConfig, GF_BG_LYR_SUB_3, BG_POS_OP_SET_X, -4);
}

// ov109_021E6AFC
static void PhotoAlbum_FreeBgLayers(PhotoAlbumAppData *data) {
    BgSetPosTextAndCommit(data->bgConfig, GF_BG_LYR_SUB_3, BG_POS_OP_SET_X, 0);
    FreeBgTilemapBuffer(data->bgConfig, GF_BG_LYR_MAIN_3);
    FreeBgTilemapBuffer(data->bgConfig, GF_BG_LYR_MAIN_2);
    FreeBgTilemapBuffer(data->bgConfig, GF_BG_LYR_MAIN_1);
    FreeBgTilemapBuffer(data->bgConfig, GF_BG_LYR_MAIN_0);
    FreeBgTilemapBuffer(data->bgConfig, GF_BG_LYR_SUB_2);
    FreeBgTilemapBuffer(data->bgConfig, GF_BG_LYR_SUB_3);
    FreeBgTilemapBuffer(data->bgConfig, GF_BG_LYR_SUB_0);
    Heap_Free(data->bgConfig);
    GX_SetDispSelect(GX_DISP_SELECT_MAIN_SUB);
}

// ov109_021E6B5C
static void PhotoAlbum_LoadBgGraphics(PhotoAlbumAppData *data) {
    NARC *narc = NARC_New(NARC_INDEX_GRAPHIC__COMPLETE__PHOTO_ALBUM, data->heapID);

    GfGfxLoader_GXLoadPalFromOpenNarc(narc, PHOTO_GFX_BG_NCLR, GF_PAL_LOCATION_MAIN_BG, GF_PAL_SLOT_0_OFFSET, 0, data->heapID);
    GfGfxLoader_GXLoadPalFromOpenNarc(narc, PHOTO_GFX_BG_NCLR, GF_PAL_LOCATION_SUB_BG, GF_PAL_SLOT_0_OFFSET, 0, data->heapID);
    GfGfxLoader_LoadCharDataFromOpenNarc(narc, PHOTO_GFX_TOP_SCREEN_NCGR, data->bgConfig, GF_BG_LYR_SUB_2, 0, 0, FALSE, data->heapID);
    GfGfxLoader_LoadCharDataFromOpenNarc(narc, PHOTO_GFX_BG_NCGR, data->bgConfig, GF_BG_LYR_SUB_3, 0, 0, FALSE, data->heapID);
    GfGfxLoader_LoadScrnDataFromOpenNarc(narc, PHOTO_GFX_TOP_SCREEN_NSCR, data->bgConfig, GF_BG_LYR_SUB_2, 0, 0, FALSE, data->heapID);
    GfGfxLoader_LoadCharDataFromOpenNarc(narc, PHOTO_GFX_BG_NCGR, data->bgConfig, GF_BG_LYR_MAIN_3, 0, 0, FALSE, data->heapID);
    GfGfxLoader_LoadScrnDataFromOpenNarc(narc, PHOTO_GFX_ALBUM_NSCR, data->bgConfig, GF_BG_LYR_MAIN_3, 0, 0, FALSE, data->heapID);
    data->unusedIconsScreenDataRaw = GfGfxLoader_GetScrnDataFromOpenNarc(narc, PHOTO_GFX_ICONS_NSCR, FALSE, &data->unusedIconsScreenData, data->heapID);
    data->iconsScreenDataRaw = GfGfxLoader_GetScrnDataFromOpenNarc(narc, PHOTO_GFX_ICONS_NSCR, FALSE, &data->iconsScreenData, data->heapID);
    data->halfPagesScreenDataRaw = GfGfxLoader_GetScrnDataFromOpenNarc(narc, PHOTO_GFX_HALF_PAGES_NSCR, FALSE, &data->halfPagesScreenData, data->heapID);
    NARC_Delete(narc);

    LoadFontPal1(GF_PAL_LOCATION_MAIN_BG, GF_PAL_SLOT_12_OFFSET, data->heapID);
    LoadUserFrameGfx2(data->bgConfig, GF_BG_LYR_MAIN_0, 1, 13, data->frame, data->heapID);
}

// ov109_021E6C7C
static void PhotoAlbum_FreeBgGraphics(PhotoAlbumAppData *data) {
    Heap_Free(data->halfPagesScreenDataRaw);
    Heap_Free(data->iconsScreenDataRaw);
    Heap_Free(data->unusedIconsScreenDataRaw);
}

// ov109_021E6C9C
static void PhotoAlbum_InitText(PhotoAlbumAppData *data) {
    int i;

    FontID_Alloc(FONT_UNK_4, data->heapID);
    data->msgData = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0000, data->heapID);
    data->msgFormat = MessageFormat_New_Custom(6, 22, data->heapID);
    data->strBuf = String_New(128, data->heapID);
    data->exitText = NewString_ReadMsgData(data->msgData, msg_0000_00000);
    for (i = 0; i < PHOTO_ALBUM_MSG_MAX; i++) {
        data->messages[i] = NewString_ReadMsgData(data->msgData, msg_0000_00005 + i);
    }
    for (i = 0; i < 2; i++) {
        data->captionTemplates[i] = NewString_ReadMsgData(data->msgData, msg_0000_00010 + i);
    }
    data->listMenuItems = ListMenuItems_New(PHOTO_ALBUM_ACTION_MAX, data->heapID);
    for (i = 0; i < PHOTO_ALBUM_ACTION_MAX; i++) {
        ListMenuItems_AppendFromMsgData(data->listMenuItems, data->msgData, msg_0000_00001 + i, i);
    }
}

// ov109_021E6D2C
static void PhotoAlbum_DeleteText(PhotoAlbumAppData *data) {
    int i;

    ListMenuItems_Delete(data->listMenuItems);
    data->listMenuItems = NULL;
    for (i = 0; i < 2; i++) {
        String_Delete(data->captionTemplates[i]);
    }
    for (i = 0; i < PHOTO_ALBUM_MSG_MAX; i++) {
        String_Delete(data->messages[i]);
    }
    String_Delete(data->exitText);
    String_Delete(data->strBuf);
    MessageFormat_Delete(data->msgFormat);
    DestroyMsgData(data->msgData);
    FontID_Release(FONT_UNK_4);
}

// ov109_021E6D84
static void PhotoAlbum_CreateWindows(PhotoAlbumAppData *data) {
    for (int i = 0; i < PHOTO_ALBUM_WINDOW_MAX; i++) {
        AddWindow(data->bgConfig, &data->windows[i], &sWindowTemplates[i]);
        FillWindowPixelBuffer(&data->windows[i], 0);
    }
    data->yesNoPrompt = YesNoPrompt_Create(data->heapID);
}

// ov109_021E6DBC
static void PhotoAlbum_DestroyWindows(PhotoAlbumAppData *data) {
    for (int i = 0; i < PHOTO_ALBUM_WINDOW_MAX; i++) {
        ClearWindowTilemapAndCopyToVram(&data->windows[i]);
        RemoveWindow(&data->windows[i]);
    }
    YesNoPrompt_Destroy(data->yesNoPrompt);
}

// ov109_021E6DE4
static void PhotoAlbum_InitSpriteSystem(PhotoAlbumAppData *data) {
    GF_CreateVramTransferManager(32, data->heapID);
    data->spriteSystem = SpriteSystem_Alloc(data->heapID);
    SpriteSystem_Init(data->spriteSystem, &sOamManagerParam, &sOamCharTransferParam, 3);
    thunk_ClearMainOAM(data->heapID);
    thunk_ClearSubOAM(data->heapID);
    data->spriteManager = SpriteManager_New(data->spriteSystem);
    SpriteSystem_InitSprites(data->spriteSystem, data->spriteManager, PHOTO_ALBUM_SPRITE_MAX);
    SpriteSystem_InitManagerWithCapacities(data->spriteSystem, data->spriteManager, &sResourceCounts);

    NARC *narc = NARC_New(NARC_INDEX_GRAPHIC__COMPLETE__PHOTO_ALBUM, data->heapID);

    SpriteSystem_LoadPlttResObjFromOpenNarc(data->spriteSystem, data->spriteManager, narc, PHOTO_GFX_OBJ_NCLR, FALSE, 5, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCharResObjFromOpenNarc(data->spriteSystem, data->spriteManager, narc, PHOTO_GFX_OBJ_NCGR, FALSE, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCellResObjFromOpenNarc(data->spriteSystem, data->spriteManager, narc, PHOTO_GFX_OBJ_NCER, FALSE, 0);
    SpriteSystem_LoadAnimResObjFromOpenNarc(data->spriteSystem, data->spriteManager, narc, PHOTO_GFX_OBJ_NANR, FALSE, 0);
    NARC_Delete(narc);
}

// ov109_021E6E64
static void PhotoAlbum_DestroySpriteSystem(PhotoAlbumAppData *data) {
    SpriteSystem_FreeResourcesAndManager(data->spriteSystem, data->spriteManager);
    data->spriteManager = NULL;
    SpriteSystem_Free(data->spriteSystem);
    data->spriteSystem = NULL;
    GF_DestroyVramTransferManager();
    thunk_ClearMainOAM(data->heapID);
}

// ov109_021E6E9C
static void PhotoAlbum_CreateSpriteGraphics(PhotoAlbumAppData *data) {
    PhotoAlbum_InitSpriteSystem(data);
    PhotoAlbum_CreateSprites(data);
    data->listMenuSpawner = TouchscreenListMenuSpawner_Create(data->heapID, NULL);
    GfGfx_EngineATogglePlanes(GX_PLANEMASK_OBJ, GF_PLANE_TOGGLE_ON);
}

// ov109_021E6EC0
static void PhotoAlbum_DeleteSpriteGraphics(PhotoAlbumAppData *data) {
    GfGfx_EngineATogglePlanes(GX_PLANEMASK_OBJ, GF_PLANE_TOGGLE_OFF);
    PhotoAlbum_DeleteSprites(data);
    TouchscreenListMenuSpawner_Destroy(data->listMenuSpawner);
    PhotoAlbum_DestroySpriteSystem(data);
}

// ov109_021E6EE4
static void PhotoAlbum_CreateSprites(PhotoAlbumAppData *data) {
    for (int i = 0; i < PHOTO_ALBUM_SPRITE_MAX; i++) {
        data->sprites[i] = SpriteSystem_NewSprite(data->spriteSystem, data->spriteManager, &sSpriteTemplates[i]);
        ManagedSprite_SetDrawFlag(data->sprites[i], TRUE);
        ManagedSprite_SetAnimationSpeed(data->sprites[i], FX32_ONE);
    }
    ManagedSprite_SetAnimateFlag(data->sprites[PHOTO_ALBUM_SPRITE_CURSOR], FALSE);
    ManagedSprite_SetDrawFlag(data->sprites[PHOTO_ALBUM_SPRITE_SELECTION], FALSE);
    // HeartGold's ManagedSprite_SetPriority is the BG priority (Platinum's explicit one): EXIT's text, on BG0, shows over it
    ManagedSprite_SetExplicitPriority(data->sprites[PHOTO_ALBUM_SPRITE_EXIT_BUTTON], 2);
    ManagedSprite_SetAnimateFlag(data->sprites[PHOTO_ALBUM_SPRITE_EXIT_BUTTON], TRUE);
}

// ov109_021E6F60
static void PhotoAlbum_DeleteSprites(PhotoAlbumAppData *data) {
    for (int i = 0; i < PHOTO_ALBUM_SPRITE_MAX; i++) {
        Sprite_DeleteAndFreeResources(data->sprites[i]);
    }
}

// ov109_021E6F7C
// Clears main BG2 (the turning page) and, if draw is set, puts a blank left (half 1) or right (half 2)
// page on it.
static void PhotoAlbum_DrawTurningHalfPage(PhotoAlbumAppData *data, int half, BOOL draw) {
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_MAIN_2);
    if (draw) {
        NNSG2dScreenData *screenData = data->halfPagesScreenData;
        CopyToBgTilemapRect(data->bgConfig, GF_BG_LYR_MAIN_2, (half / 2) * 16, 0, 16, 24, screenData->rawData, (half / 2) * 16, 0, screenData->screenWidth / 8, screenData->screenHeight / 8);
    }
}

// ov109_021E6FD4
// Draws the number of the left (page * 2 + 1) or right (page * 2 + 2) page at the bottom of that page.
static void PhotoAlbum_DrawPageNumber(PhotoAlbumAppData *data, int bgId, int half, int page) {
    u8 x;
    u8 digit;

    if (half == PHOTO_ALBUM_HALF_LEFT) {
        x = 3;
        digit = page * 2 + 1;
    } else {
        x = 28;
        digit = page * 2 + 2;
    }
    NNSG2dScreenData *screenData = data->halfPagesScreenData;
    CopyToBgTilemapRect(data->bgConfig, bgId, x, 15, 1, 2, screenData->rawData, digit, 24, screenData->screenWidth / 8, screenData->screenHeight / 8);
}

// ov109_021E7030
// Draws the icons of columns firstColumn and firstColumn + 1 (one page) of the given spread.
static void PhotoAlbum_DrawHalfSpreadIcons(PhotoAlbumAppData *data, int bgId, int page, int firstColumn) {
    int x, y;

    for (y = 0; y < PHOTO_ALBUM_GRID_HEIGHT; y++) {
        for (x = firstColumn; x < firstColumn + 2; x++) {
            u8 photoNo = sGridPosToSpreadSlot[y * PHOTO_ALBUM_GRID_WIDTH + x] + page * PHOTO_ALBUM_PER_SPREAD;
            if (photoNo < data->numPhotos) {
                PhotoAlbum_DrawGridIcon(data, data->entries[photoNo].photo, bgId, x, y);
            } else {
                PhotoAlbum_DrawGridIcon(data, NULL, bgId, x, y);
            }
        }
    }
}

// ov109_021E70C4
// Draws the icons and page numbers of the given halves (PHOTO_ALBUM_HALF_*) of a spread on main BG2 or BG3.
static void PhotoAlbum_DrawSpread(PhotoAlbumAppData *data, int bgId, int halves, u8 page) {
    if (halves & PHOTO_ALBUM_HALF_LEFT) {
        PhotoAlbum_DrawHalfSpreadIcons(data, bgId, page, 0);
        PhotoAlbum_DrawPageNumber(data, bgId, PHOTO_ALBUM_HALF_LEFT, page);
    }
    if (halves & PHOTO_ALBUM_HALF_RIGHT) {
        PhotoAlbum_DrawHalfSpreadIcons(data, bgId, page, 2);
        PhotoAlbum_DrawPageNumber(data, bgId, PHOTO_ALBUM_HALF_RIGHT, page);
    }
    ScheduleBgTilemapBufferTransfer(data->bgConfig, bgId);
}

// ov109_021E7114
// Copies a 5x5-tile photo icon (0 = empty slot, n + 1 = Photo.iconId n) to (x, y) of a BG.
static void PhotoAlbum_DrawIcon(PhotoAlbumAppData *data, u8 icon, u8 bgId, u8 x, u8 y) {
    NNSG2dScreenData *screenData = data->iconsScreenData;
    CopyToBgTilemapRect(data->bgConfig, bgId, x, y, 5, 5, screenData->rawData, (icon % 6) * 5, (icon / 6) * 5, screenData->screenWidth / 8, screenData->screenHeight / 8);
}

// ov109_021E7178
static void PhotoAlbum_DrawGridIcon(PhotoAlbumAppData *data, CompletePhoto *photo, int bgId, u8 x, u8 y) {
    u8 icon = 0;

    if (photo != NULL) {
        icon = photo->icon + 1;
    }
    PhotoAlbum_DrawIcon(data, icon, bgId, x * 6 + 4 + (u8)(x / 2), y * 5 + 1);
}

// ov109_021E71BC
// Blanks the slots of two swapped photos if they are on the current spread.
static void PhotoAlbum_ClearSwappedIcons(PhotoAlbumAppData *data, u8 a, u8 b) {
    u8 gridPos;

    if (a / PHOTO_ALBUM_PER_SPREAD == data->page) {
        gridPos = sSpreadSlotToGridPos[a % PHOTO_ALBUM_PER_SPREAD];
        PhotoAlbum_DrawGridIcon(data, NULL, GF_BG_LYR_MAIN_3, gridPos % PHOTO_ALBUM_GRID_WIDTH, gridPos / PHOTO_ALBUM_GRID_WIDTH);
    }
    if (b / PHOTO_ALBUM_PER_SPREAD == data->page) {
        gridPos = sSpreadSlotToGridPos[b % PHOTO_ALBUM_PER_SPREAD];
        PhotoAlbum_DrawGridIcon(data, NULL, GF_BG_LYR_MAIN_3, gridPos % PHOTO_ALBUM_GRID_WIDTH, gridPos / PHOTO_ALBUM_GRID_WIDTH);
    }
    ScheduleBgTilemapBufferTransfer(data->bgConfig, GF_BG_LYR_MAIN_3);
}

// ov109_021E7248
// Shows a photo's icon and caption on the top screen, or clears them if photo is NULL.
static void PhotoAlbum_PrintPhotoDetails(PhotoAlbumAppData *data, CompletePhoto *photo) {
    ScheduleBgTilemapBufferTransfer(data->bgConfig, GF_BG_LYR_SUB_2);
    ScheduleBgTilemapBufferTransfer(data->bgConfig, GF_BG_LYR_SUB_3);
    FillWindowPixelBuffer(&data->windows[PHOTO_ALBUM_WINDOW_DETAILS], 0);
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_SUB_0);
    BgClearTilemapBufferAndCommit(data->bgConfig, GF_BG_LYR_SUB_3);
    if (photo == NULL) {
        ScheduleWindowCopyToVram(&data->windows[PHOTO_ALBUM_WINDOW_DETAILS]);
        return;
    }

    BufferPlayersName(data->msgFormat, 0, SaveData_GetTrainerInfo(data->args->saveData));
    MapHeader_LoadName(photo->mapHeaderID, data->heapID, data->strBuf);
    BufferString(data->msgFormat, 1, data->strBuf, 2, 0, 2);
    CopyU16ArrayToString(data->strBuf, photo->leadMonNick);
    BufferString(data->msgFormat, 2, data->strBuf, 2, 0, 2);
    u8 year = photo->date >> 24;
    BufferIntegerAsString(data->msgFormat, 3, year + 2000, 4, PRINTING_MODE_LEADING_ZEROS, TRUE);
    u8 month = photo->date >> 16;
    BufferIntegerAsString(data->msgFormat, 4, month, 2, PRINTING_MODE_LEADING_ZEROS, TRUE);
    u8 day = photo->date >> 8;
    BufferIntegerAsString(data->msgFormat, 5, day, 2, PRINTING_MODE_LEADING_ZEROS, TRUE);
    if (PhotoAlbum_CountValidMons(photo) > 1) {
        StringExpandPlaceholders(data->msgFormat, data->strBuf, data->captionTemplates[1]);
    } else {
        StringExpandPlaceholders(data->msgFormat, data->strBuf, data->captionTemplates[0]);
    }
    AddTextPrinterParameterizedWithColor(&data->windows[PHOTO_ALBUM_WINDOW_DETAILS], FONT_SYSTEM, data->strBuf, 0, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(3, 2, 0), NULL);
    ScheduleWindowCopyToVram(&data->windows[PHOTO_ALBUM_WINDOW_DETAILS]);
    PhotoAlbum_DrawIcon(data, photo->icon + 1, GF_BG_LYR_SUB_3, 13, 8);
}

// ov109_021E7388
static void PhotoAlbum_DrawExitButton(PhotoAlbumAppData *data, BOOL pressed) {
    FillWindowPixelBuffer(&data->windows[PHOTO_ALBUM_WINDOW_EXIT], 0);
    if (pressed) {
        ManagedSprite_SetAnim(data->sprites[PHOTO_ALBUM_SPRITE_EXIT_BUTTON], 9);
        PhotoAlbum_RestartAnim(data->sprites[PHOTO_ALBUM_SPRITE_EXIT_BUTTON]);
    }
    AddTextPrinterParameterizedWithColor(&data->windows[PHOTO_ALBUM_WINDOW_EXIT], FONT_UNK_4, data->exitText, (64 - FontID_String_GetWidth(FONT_UNK_4, data->exitText, 0)) / 2, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 5, 0), NULL);
    ScheduleWindowCopyToVram(&data->windows[PHOTO_ALBUM_WINDOW_EXIT]);
    ScheduleBgTilemapBufferTransfer(data->bgConfig, GF_BG_LYR_MAIN_1);
}

// ov109_021E73F8
static void PhotoAlbum_PrintMessage(PhotoAlbumAppData *data, int msgNo, BOOL drawFrame, u8 textSpeed) {
    if (drawFrame) {
        DrawFrameAndWindow2(&data->windows[PHOTO_ALBUM_WINDOW_MESSAGE], TRUE, 1, 13);
    }
    FillWindowPixelBuffer(&data->windows[PHOTO_ALBUM_WINDOW_MESSAGE], 15);
    if (textSpeed == 0) {
        AddTextPrinterParameterizedWithColor(&data->windows[PHOTO_ALBUM_WINDOW_MESSAGE], FONT_SYSTEM, data->messages[msgNo], 0, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 15), NULL);
    } else {
        data->textPrinterId = AddTextPrinterParameterizedWithColor(&data->windows[PHOTO_ALBUM_WINDOW_MESSAGE], FONT_SYSTEM, data->messages[msgNo], 0, 0, textSpeed, MAKE_TEXT_COLOR(1, 2, 15), NULL);
    }
    ScheduleWindowCopyToVram(&data->windows[PHOTO_ALBUM_WINDOW_MESSAGE]);
}

// ov109_021E7474
static void PhotoAlbum_SetCursorPos(PhotoAlbumAppData *data, u8 x, u8 y, BOOL show) {
    s16 posX, posY;

    ManagedSprite_SetDrawFlag(data->sprites[PHOTO_ALBUM_SPRITE_CURSOR], show);
    if (y == PHOTO_ALBUM_CURSOR_Y_EXIT) {
        posX = 192;
        posY = 160;
        ManagedSprite_SetAnimationFrame(data->sprites[PHOTO_ALBUM_SPRITE_CURSOR], 1);
    } else {
        posX = x * 48 + 28 + (x / 2) * 8;
        posY = y * 40 + 8;
        ManagedSprite_SetAnimationFrame(data->sprites[PHOTO_ALBUM_SPRITE_CURSOR], 0);
    }
    ManagedSprite_SetPositionXY(data->sprites[PHOTO_ALBUM_SPRITE_CURSOR], posX, posY);
}

// ov109_021E74D4
// The marker is only shown if the picked photo is on the current spread.
static void PhotoAlbum_ShowSelectionMarker(PhotoAlbumAppData *data, BOOL show) {
    if (data->page != (u8)(data->selectedPhoto / PHOTO_ALBUM_PER_SPREAD)) {
        show = FALSE;
    }
    ManagedSprite_SetPositionXY(data->sprites[PHOTO_ALBUM_SPRITE_SELECTION], data->selectedCursorX * 48 + 28 + (data->selectedCursorX / 2) * 8, data->selectedCursorY * 40 + 8);
    ManagedSprite_SetDrawFlag(data->sprites[PHOTO_ALBUM_SPRITE_SELECTION], show);
}

// ov109_021E7524
static void PhotoAlbum_UpdatePageArrows(PhotoAlbumAppData *data) {
    ManagedSprite_SetAnimateFlag(data->sprites[PHOTO_ALBUM_SPRITE_PREV_ARROW], FALSE);
    ManagedSprite_SetAnimateFlag(data->sprites[PHOTO_ALBUM_SPRITE_NEXT_ARROW], FALSE);
    if (data->page == 0) {
        ManagedSprite_SetAnim(data->sprites[PHOTO_ALBUM_SPRITE_PREV_ARROW], 2); // greyed out
    } else {
        ManagedSprite_SetAnim(data->sprites[PHOTO_ALBUM_SPRITE_PREV_ARROW], 0);
    }
    if (data->numPages == 0 || data->page == data->numPages - 1) {
        ManagedSprite_SetAnim(data->sprites[PHOTO_ALBUM_SPRITE_NEXT_ARROW], 5); // greyed out
    } else {
        ManagedSprite_SetAnim(data->sprites[PHOTO_ALBUM_SPRITE_NEXT_ARROW], 3);
    }
}

// ov109_021E7584
static void PhotoAlbum_AnimatePageArrow(PhotoAlbumAppData *data, int spriteNo) {
    PhotoAlbum_RestartAnim(data->sprites[spriteNo]);
    ManagedSprite_SetAnimateFlag(data->sprites[spriteNo], TRUE);
    if (spriteNo == PHOTO_ALBUM_SPRITE_PREV_ARROW) {
        ManagedSprite_SetAnim(data->sprites[spriteNo], 1);
    } else {
        ManagedSprite_SetAnim(data->sprites[spriteNo], 4);
    }
}

// ov109_021E75B4
static int PhotoAlbum_ToggleMenuInputState(PhotoAlbumAppData *data) {
    data->menuInputState = data->menuInputState == MENU_INPUT_STATE_BUTTONS ? MENU_INPUT_STATE_TOUCH : MENU_INPUT_STATE_BUTTONS;
    return 0;
}

// ov109_021E75C8
static void PhotoAlbum_OpenActionMenu(PhotoAlbumAppData *data) {
    TouchscreenListMenuHeader header;

    MI_CpuFill8(&header, 0, sizeof(TouchscreenListMenuHeader));
    header.template = sActionMenuTemplate;
    header.listMenuItems = data->listMenuItems;
    header.bgConfig = data->bgConfig;
    header.numWindows = PHOTO_ALBUM_ACTION_MAX;
    data->listMenu = TouchscreenListMenu_Create(data->listMenuSpawner, &header, data->menuInputState, 24, 11, 6, 0);
    PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, FALSE);
}

// ov109_021E7640
// Returns the next state, or a negative value while the menu is still open.
static int PhotoAlbum_ActionMenu_HandleInput(PhotoAlbumAppData *data) {
    int input = TouchscreenListMenu_HandleInput(data->listMenu);
    if (input == LIST_NOTHING_CHOSEN) {
        return LIST_NOTHING_CHOSEN;
    }

    u8 wasTouch = TouchscreenListMenu_WasLastInputTouch(data->listMenu);
    TouchscreenListMenu_Destroy(data->listMenu);
    if (data->menuInputState != wasTouch) {
        PhotoAlbum_ToggleMenuInputState(data);
    }

    switch (input) {
    case PHOTO_ALBUM_ACTION_VIEW:
        data->args->photoWasSelected = TRUE;
        data->args->cursorPos = data->selectedPhoto;
        return PHOTO_ALBUM_STATE_FADE_OUT;
    case PHOTO_ALBUM_ACTION_DELETE:
        PhotoAlbum_PrintMessage(data, PHOTO_ALBUM_MSG_CONFIRM_DELETE, FALSE, 0);
        data->mode = PHOTO_ALBUM_MODE_DELETE;
        return PHOTO_ALBUM_STATE_CONFIRM_DELETE;
    case PHOTO_ALBUM_ACTION_MOVE:
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
        PhotoAlbum_PrintMessage(data, PHOTO_ALBUM_MSG_SWITCH_WITH, FALSE, 0);
        data->mode = PHOTO_ALBUM_MODE_MOVE;
        return PHOTO_ALBUM_STATE_MOVE;
    default: // PHOTO_ALBUM_ACTION_CANCEL or LIST_CANCEL (B)
        PhotoAlbum_PrintPhotoDetails(data, NULL);
        PhotoAlbum_ShowSelectionMarker(data, FALSE);
        PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
        return PHOTO_ALBUM_STATE_BROWSE;
    }
}

// ov109_021E76F0
static void PhotoAlbum_CreateDeleteYesNoPrompt(PhotoAlbumAppData *data) {
    YesNoTouchMenuParams params = { 0 }; // Sovereign Complete: Platinum's touch buttons (HeartGold's prompt's), as Voltorb Flip's

    params.bgConfig = data->bgConfig;
    params.bgLayer = GF_BG_LYR_MAIN_0;
    params.baseTile = 122;
    params.palette = 14;
    params.tilemapLeft = 25;
    params.tilemapTop = 16;
    YesNoTouchMenu_InitWithParams(data->yesNoPrompt, &params);
}

// ov109_021E7748
static int PhotoAlbum_DeleteYesNoPrompt_HandleInput(PhotoAlbumAppData *data) {
    // Sovereign Complete: the buttons too, as Voltorb Flip's prompt takes them: A presses Yes, B No
    if (data->yesNoPrompt->pressedButton == BUTTON_NONE) {
        if (gSystem.pressedKeys & PAD_BUTTON_A) {
            data->yesNoPrompt->pressedButton = BUTTON_YES;
            PlaySE(SEQ_SE_DP_BUTTON9_sseq);
        } else if (gSystem.pressedKeys & PAD_BUTTON_B) {
            data->yesNoPrompt->pressedButton = BUTTON_NO;
            PlaySE(SEQ_SE_DP_BUTTON9_sseq);
        }
    }

    int response = YesNoTouchMenu_ProcessInput(data->yesNoPrompt);

    switch (response) {
    case YESNORESPONSE_YES:
        PhotoAlbum_DeleteEntry(data, data->selectedPhoto);
        break;
    case YESNORESPONSE_NO:
        break;
    default:
        return PHOTO_ALBUM_STATE_CONFIRM_DELETE;
    }

    YesNoPrompt_Reset(data->yesNoPrompt); // Sovereign Complete: Platinum's buttons keep no input mode of their own
    PhotoAlbum_ShowSelectionMarker(data, FALSE);
    if (response == YESNORESPONSE_YES) {
        PhotoAlbum_DrawSpread(data, GF_BG_LYR_MAIN_3, PHOTO_ALBUM_HALF_BOTH, data->page);
        PhotoAlbum_UpdatePageArrows(data);
    }
    PhotoAlbum_SetCursorPos(data, data->cursorX, data->cursorY, TRUE);
    PhotoAlbum_PrintPhotoDetails(data, NULL);
    PhotoAlbum_PrintMessage(data, PHOTO_ALBUM_MSG_SELECT_PHOTO, FALSE, 0);
    data->mode = PHOTO_ALBUM_MODE_NONE;
    return PHOTO_ALBUM_STATE_BROWSE;
}

// ov109_021E77D4
// Plays the EXIT button's press animation; browse input waits for it (exitButtonAnimActive).
static void PhotoAlbum_StartExitButtonTask(PhotoAlbumAppData *data) {
    PhotoAlbumExitButtonTaskData *taskData = Heap_AllocAtEnd(data->heapID, sizeof(PhotoAlbumExitButtonTaskData));
    MI_CpuFill8(taskData, 0, sizeof(PhotoAlbumExitButtonTaskData));
    taskData->data = data;
    SysTask_CreateOnMainQueue(Task_PhotoAlbum_WaitExitButtonAnim, taskData, 0);
    PhotoAlbum_DrawExitButton(data, TRUE);
    data->exitButtonAnimActive = TRUE;
}

// ov109_021E7810
static void Task_PhotoAlbum_WaitExitButtonAnim(SysTask *task, void *_taskData) {
    PhotoAlbumExitButtonTaskData *taskData = _taskData;

    if (!ManagedSprite_IsAnimated(taskData->data->sprites[PHOTO_ALBUM_SPRITE_EXIT_BUTTON])) {
        PhotoAlbum_DrawExitButton(taskData->data, FALSE);
        taskData->data->exitButtonAnimActive = FALSE;
        MI_CpuFill8(taskData, 0, sizeof(PhotoAlbumExitButtonTaskData));
        Heap_Free(taskData);
        SysTask_Destroy(task);
    }
}

// ov109_021E7850
static u8 PhotoAlbum_CountValidMons(CompletePhoto *photo) {
    u8 count = 0;
    for (u8 i = 0; i < MAX_PARTY_SIZE; i++) {
        int species = photo->party[i].species;
        if (species > SPECIES_NONE && species < NATIONAL_DEX_COUNT + 1) {
            count++;
        }
    }
    return count;
}
