#include "applications/complete_photo_caption.h"

#include <nitro.h>
#include <nnsys.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "constants/species.h"
#include "generated/text_banks.h"

#include "field/field_system.h"

#include "bg_window.h"
#include "complete_photo.h"
#include "font.h"
#include "graphics.h"
#include "heap.h"
#include "map_header_util.h"
#include "message.h"
#include "render_oam.h"
#include "screen_fade.h"
#include "sound_playback.h"
#include "string_gf.h"
#include "string_template.h"
#include "sys_task.h"
#include "sys_task_manager.h"
#include "system.h"
#include "text.h"
#include "touch_pad.h"
#include "touch_screen.h"
#include "trainer_info.h"

#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0000.h"

// Sovereign Complete: HeartGold's photo viewer's bottom screen (its view_photo.c), as the field's bottom screen while
// a photo from the album shows (include/complete_photo.h): the photo's caption and place's icon, EXIT and the photo
// before and after. HeartGold's sprites for the buttons (FieldSpriteManager) are their cells, drawn into the bottom
// screen's OAM as the Pokétch's sprites are (its poketch_animation.c), since the field's sprite renderer is Platinum's.

#define HEAP_ID_PHOTO_CAPTION HEAP_ID_POKETCH_APP

// The photo album archive's members (tools/complete/import_hgss_photos.py): HeartGold's a/1/7/1
enum {
    GFX_OBJ_NCLR = 0,
    GFX_OBJ_NCGR = 1,
    GFX_OBJ_NCER = 2,
    GFX_OBJ_NANR = 3,
    GFX_BG_NCLR = 4,
    GFX_BG_NCGR = 5, // 256-colour: the places' icons among the album's tiles
    GFX_VIEWER_NCGR = 11,
    GFX_VIEWER_NSCR = 12,
};

enum {
    BUTTON_EXIT = 0,
    BUTTON_PREV,
    BUTTON_NEXT,
    BUTTON_COUNT,
    BUTTON_NONE = 0xFF,
};

typedef struct PhotoCaption {
    BOOL shutdown;
    FieldSystem *fieldSystem;
    BgConfig *bgConfig;
    SysTask *task;
    CompletePhotoShowing *showing;
    MessageLoader *loader;
    StringTemplate *template;
    String *strBuf;
    String *exitText;
    String *captions[2];
    Window windows[2];
    void *cellBankRaw;
    NNSG2dCellDataBank *cellBank;
    void *animBankRaw;
    NNSG2dAnimBankData *animBank;
    NNSG2dCellAnimation anims[BUTTON_COUNT];
    u8 pressed; // the button pressed, its animation playing, or BUTTON_NONE
    u8 answered;
} PhotoCaption;

static PhotoCaption *sCaption;

// HeartGold's ov19_0225A04E: EXIT on its button, the caption on the card
static const WindowTemplate sWindows[2] = {
    { BG_LAYER_SUB_1, 24, 21, 8, 2, 1, 0x1F0 },
    { BG_LAYER_SUB_1, 1, 8, 28, 8, 10, 0x110 },
};

// HeartGold's ov19_0225A05E (top, bottom, left, right): EXIT, the photo before, the photo after
static const TouchScreenRect sButtonRects[] = {
    { .rect = { 162, 188, 194, 254 } },
    { .rect = { 24, 56, 80, 96 } },
    { .rect = { 24, 56, 160, 176 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR } },
};

// HeartGold's sSpriteTemplates: each button's place and animation, and the animation it plays as it's pressed
// (_0225A03C); the arrows' greyed-out ones when there's no photo that way
static const s16 sButtonPos[BUTTON_COUNT][2] = { { 224, 176 }, { 88, 40 }, { 168, 40 } };
static const u8 sButtonAnim[BUTTON_COUNT] = { 8, 0, 3 };
static const u8 sButtonPressedAnim[BUTTON_COUNT] = { 9, 1, 4 };
static const u8 sButtonGreyAnim[BUTTON_COUNT] = { 8, 2, 5 };

static void SetButtonAnim(PhotoCaption *caption, int button, int anim)
{
    NNS_G2dInitCellAnimation(&caption->anims[button], NNS_G2dGetAnimSequenceByIdx(caption->animBank, anim), caption->cellBank);
}

static BOOL ButtonAvailable(PhotoCaption *caption, int button)
{
    CompletePhotoShowing *showing = caption->showing;

    if (button == BUTTON_PREV) {
        return showing->index > 0;
    }

    if (button == BUTTON_NEXT) {
        return showing->index + 1 < showing->count;
    }

    return TRUE;
}

static void DrawButtons(PhotoCaption *caption)
{
    GXOamAttr oams[16];

    for (int i = 0; i < BUTTON_COUNT; i++) {
        NNSG2dFVec2 pos = { sButtonPos[i][0] << FX32_SHIFT, sButtonPos[i][1] << FX32_SHIFT };
        int count = NNS_G2dMakeCellToOams(oams, NELEMS(oams), NNS_G2dGetCellAnimationCurrentCell(&caption->anims[i]), NULL, &pos, 0, FALSE);

        NNS_G2dEntryOamManagerOam(RenderOam_GetScreenOam(DS_SCREEN_SUB), oams, count);
        NNS_G2dTickCellAnimation(&caption->anims[i], FX32_ONE);
    }
}

// HeartGold's formatPhotoFlavorText: the player's photo, the place, the lead, the date
static void PrintCaption(PhotoCaption *caption)
{
    CompletePhoto *photo = &caption->showing->photo;
    u8 valid = 0;

    StringTemplate_SetPlayerName(caption->template, 0, SaveData_GetTrainerInfo(caption->fieldSystem->saveData));
    MapHeader_LoadName(photo->mapHeaderID, HEAP_ID_PHOTO_CAPTION, caption->strBuf);
    StringTemplate_SetString(caption->template, 1, caption->strBuf, 2, 0, 2);
    String_CopyChars(caption->strBuf, photo->leadMonNick);
    StringTemplate_SetString(caption->template, 2, caption->strBuf, 2, 0, 2);
    StringTemplate_SetNumber(caption->template, 3, (u8)(photo->date >> 24) + 2000, 4, PADDING_MODE_ZEROES, CHARSET_MODE_EN);
    StringTemplate_SetNumber(caption->template, 4, (u8)(photo->date >> 16), 2, PADDING_MODE_ZEROES, CHARSET_MODE_EN);
    StringTemplate_SetNumber(caption->template, 5, (u8)(photo->date >> 8), 2, PADDING_MODE_ZEROES, CHARSET_MODE_EN);

    for (int i = 0; i < MAX_PARTY_SIZE; i++) {
        if (photo->party[i].species != SPECIES_NONE) {
            valid++;
        }
    }

    StringTemplate_Format(caption->template, caption->strBuf, caption->captions[valid > 1 ? 1 : 0]);
    Text_AddPrinterWithParamsAndColor(&caption->windows[1], FONT_SYSTEM, caption->strBuf, 0, 0, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(3, 2, 0), NULL);
    Window_ScheduleCopyToVRAM(&caption->windows[1]);

    Text_AddPrinterWithParamsAndColor(&caption->windows[0], FONT_SUBSCREEN, caption->exitText, (64 - Font_CalcStringWidth(FONT_SUBSCREEN, caption->exitText, 0)) / 2, 0, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(1, 5, 0), NULL);
    Window_ScheduleCopyToVRAM(&caption->windows[0]);
}

// HeartGold's ViewPhotoSysTask_LoadBgGraphics and DrawLyr3Icon: the card, and the place's icon (25 of the album's
// 256-colour tiles) on BG3
static void LoadGraphics(PhotoCaption *caption)
{
    static const BgTemplate sTextTemplate = { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x7800, GX_BG_CHARBASE_0x00000, GX_BG_EXTPLTT_01, 0, 0, FALSE };
    static const BgTemplate sCardTemplate = { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x7000, GX_BG_CHARBASE_0x00000, GX_BG_EXTPLTT_01, 3, 0, FALSE };
    static const BgTemplate sIconTemplate = { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_256, GX_BG_SCRBASE_0x6800, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 2, 0, FALSE };
    NARC *narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__PHOTO_ALBUM, HEAP_ID_PHOTO_CAPTION);
    NNSG2dCharacterData *charData;

    GXS_SetGraphicsMode(GX_BGMODE_3);
    GX_SetBankForSubBG(GX_VRAM_SUB_BG_32_H);
    GX_SetBankForSubOBJ(GX_VRAM_SUB_OBJ_16_I);
    GXS_SetOBJVRamModeChar(GX_OBJVRAMMODE_CHAR_1D_32K);

    Bg_InitFromTemplate(caption->bgConfig, BG_LAYER_SUB_1, &sTextTemplate, BG_TYPE_STATIC);
    Bg_ClearTilemap(caption->bgConfig, BG_LAYER_SUB_1);
    Bg_InitFromTemplate(caption->bgConfig, BG_LAYER_SUB_2, &sCardTemplate, BG_TYPE_STATIC);
    Bg_ClearTilemap(caption->bgConfig, BG_LAYER_SUB_2);
    Bg_InitFromTemplate(caption->bgConfig, BG_LAYER_SUB_3, &sIconTemplate, BG_TYPE_STATIC_WITH_AFFINE);
    Bg_ClearTilemap(caption->bgConfig, BG_LAYER_SUB_3);
    Bg_ClearTilesRange(BG_LAYER_SUB_1, 0x20, 0, HEAP_ID_PHOTO_CAPTION);
    Bg_ClearTilesRange(BG_LAYER_SUB_3, 0x40, 0, HEAP_ID_PHOTO_CAPTION);
    Bg_SetOffset(caption->bgConfig, BG_LAYER_SUB_3, BG_OFFSET_UPDATE_SET_X, -4);

    Graphics_LoadPaletteFromOpenNARC(narc, GFX_BG_NCLR, PAL_LOAD_SUB_BG, 0, 0, HEAP_ID_PHOTO_CAPTION);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_VIEWER_NCGR, caption->bgConfig, BG_LAYER_SUB_2, 0, 0, FALSE, HEAP_ID_PHOTO_CAPTION);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_VIEWER_NSCR, caption->bgConfig, BG_LAYER_SUB_2, 0, 0, FALSE, HEAP_ID_PHOTO_CAPTION);

    void *raw = Graphics_GetCharDataFromOpenNARC(narc, GFX_BG_NCGR, FALSE, &charData, HEAP_ID_PHOTO_CAPTION);
    u32 icon = caption->showing->photo.icon + 1;

    Bg_LoadTiles(caption->bgConfig, BG_LAYER_SUB_3, (u8 *)charData->pRawData + (25 * icon + 64) * 64, 0x640, 1);
    Heap_Free(raw);

    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            Bg_FillTilemapRect(caption->bgConfig, BG_LAYER_SUB_3, 5 * i + j + 1, 13 + j, 2 + i, 1, 1, 16);
        }
    }

    Bg_ScheduleTilemapTransfer(caption->bgConfig, BG_LAYER_SUB_3);

    // the buttons' sprites
    Graphics_LoadObjectTiles(NARC_INDEX_GRAPHIC__COMPLETE__PHOTO_ALBUM, GFX_OBJ_NCGR, DS_SCREEN_SUB, 0, 0, FALSE, HEAP_ID_PHOTO_CAPTION);
    Graphics_LoadPaletteFromOpenNARC(narc, GFX_OBJ_NCLR, PAL_LOAD_SUB_OBJ, 0, PALETTE_SIZE_BYTES * 5, HEAP_ID_PHOTO_CAPTION);
    caption->cellBankRaw = Graphics_GetCellBankFromOpenNARC(narc, GFX_OBJ_NCER, FALSE, &caption->cellBank, HEAP_ID_PHOTO_CAPTION);
    caption->animBankRaw = Graphics_GetAnimBankFromOpenNARC(narc, GFX_OBJ_NANR, FALSE, &caption->animBank, HEAP_ID_PHOTO_CAPTION);
    NARC_dtor(narc);

    for (int i = 0; i < BUTTON_COUNT; i++) {
        SetButtonAnim(caption, i, ButtonAvailable(caption, i) ? sButtonAnim[i] : sButtonGreyAnim[i]);
    }

    GXS_SetVisiblePlane(GX_PLANEMASK_BG1 | GX_PLANEMASK_BG2 | GX_PLANEMASK_BG3 | GX_PLANEMASK_OBJ);
}

// HeartGold's ViewPhotoSysTask_HandleInput: touch first, then the buttons; EXIT (A or B), the photo before (left)
// or after (right), if there's one
static void HandleInput(PhotoCaption *caption)
{
    static const u8 sSounds[BUTTON_COUNT] = { 0, 1, 1 };
    int button = TouchScreen_CheckRectanglePressed(sButtonRects);

    if (button == TOUCHSCREEN_INPUT_NONE) {
        button = BUTTON_NONE;

        if (gSystem.pressedKeys & (PAD_BUTTON_A | PAD_BUTTON_B)) {
            button = BUTTON_EXIT;
        } else if (gSystem.pressedKeys & PAD_KEY_LEFT) {
            button = BUTTON_PREV;
        } else if (gSystem.pressedKeys & PAD_KEY_RIGHT) {
            button = BUTTON_NEXT;
        }
    }

    if (button == BUTTON_NONE || !ButtonAvailable(caption, button)) {
        return;
    }

    Sound_PlayEffect(sSounds[button] ? SE_CONFIRM_sseq_3 : SEQ_SE_DP_DECIDE_sseq);
    SetButtonAnim(caption, button, sButtonPressedAnim[button]);
    caption->pressed = button;
}

static void Shutdown(PhotoCaption *caption)
{
    DisableTouchPad();

    for (int i = 0; i < 2; i++) {
        Window_ClearAndCopyToVRAM(&caption->windows[i]);
        Window_Remove(&caption->windows[i]);
    }

    for (int i = 0; i < 2; i++) {
        String_Free(caption->captions[i]);
    }

    String_Free(caption->exitText);
    String_Free(caption->strBuf);
    Font_Free(FONT_SUBSCREEN);
    StringTemplate_Free(caption->template);
    MessageLoader_Free(caption->loader);
    Heap_Free(caption->cellBankRaw);
    Heap_Free(caption->animBankRaw);
    Bg_SetOffset(caption->bgConfig, BG_LAYER_SUB_3, BG_OFFSET_UPDATE_SET_X, 0);
    Bg_FreeTilemapBuffer(caption->bgConfig, BG_LAYER_SUB_3);
    Bg_FreeTilemapBuffer(caption->bgConfig, BG_LAYER_SUB_2);
    Bg_FreeTilemapBuffer(caption->bgConfig, BG_LAYER_SUB_1);
    GXS_SetGraphicsMode(GX_BGMODE_0);
}

static void PhotoCaption_Task(SysTask *task, void *data)
{
    PhotoCaption *caption = data;

    if (caption->shutdown) {
        Shutdown(caption);
        SysTask_Done(task);
        Heap_Free(caption);
        sCaption = NULL;
        Heap_Destroy(HEAP_ID_PHOTO_CAPTION);
        return;
    }

    if (caption->pressed == BUTTON_NONE) {
        if (IsScreenFadeDone() && !caption->answered) {
            HandleInput(caption);
        }
    } else if (!NNS_G2dIsAnimCtrlActive(NNS_G2dGetCellAnimationAnimCtrl(&caption->anims[caption->pressed]))) {
        // HeartGold's: once the button's animation is over, the field hears the answer
        static const u8 sInputs[BUTTON_COUNT] = { COMPLETE_PHOTO_INPUT_EXIT, COMPLETE_PHOTO_INPUT_PREV, COMPLETE_PHOTO_INPUT_NEXT };

        caption->showing->input = sInputs[caption->pressed];
        caption->pressed = BUTTON_NONE;
        caption->answered = TRUE;
    }

    DrawButtons(caption);
}

void CompletePhotoCaption_Create(FieldSystem *fieldSystem, BgConfig *bgConfig)
{
    Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_PHOTO_CAPTION, HEAP_SIZE_PRE_POKETCH_SUBSCREEN);

    PhotoCaption *caption = Heap_Alloc(HEAP_ID_PHOTO_CAPTION, sizeof(PhotoCaption));

    MI_CpuClear8(caption, sizeof(PhotoCaption));
    caption->fieldSystem = fieldSystem;
    caption->bgConfig = bgConfig;
    caption->showing = CompletePhoto_Showing();
    caption->pressed = BUTTON_NONE;
    Font_InitManager(FONT_SUBSCREEN, HEAP_ID_PHOTO_CAPTION); // EXIT's font, which the field doesn't load (HeartGold's FontID_Alloc(4))
    caption->loader = MessageLoader_Init(MSG_LOADER_PRELOAD_ENTIRE_BANK, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0000, HEAP_ID_PHOTO_CAPTION);
    caption->template = StringTemplate_New(6, 22, HEAP_ID_PHOTO_CAPTION);
    caption->strBuf = String_Init(128, HEAP_ID_PHOTO_CAPTION);
    caption->exitText = MessageLoader_GetNewString(caption->loader, msg_0000_00000);

    for (int i = 0; i < 2; i++) {
        caption->captions[i] = MessageLoader_GetNewString(caption->loader, msg_0000_00010 + i);
    }

    LoadGraphics(caption);

    for (int i = 0; i < 2; i++) {
        Window_AddFromTemplate(caption->bgConfig, &caption->windows[i], &sWindows[i]);
        Window_FillTilemap(&caption->windows[i], 0);
    }

    PrintCaption(caption);
    EnableTouchPad();
    InitializeTouchPad(4);
    caption->task = SysTask_Start(PhotoCaption_Task, caption, 0);
    sCaption = caption;
}

void CompletePhotoCaption_StartShutdown(void)
{
    if (sCaption != NULL) {
        sCaption->shutdown = TRUE;
    }
}

BOOL CompletePhotoCaption_IsShutdown(void)
{
    return sCaption == NULL;
}
