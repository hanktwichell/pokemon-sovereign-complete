#ifndef POKEPLATINUM_COMPLETE_VOLTORB_FLIP_HGSS_COMPAT_H
#define POKEPLATINUM_COMPLETE_VOLTORB_FLIP_HGSS_COMPAT_H

// Sovereign Complete: HeartGold's Voltorb Flip (src/applications/complete_voltorb_flip) keeps HeartGold's code; this
// header names Platinum's libraries the way HeartGold's decomp names the same functions and types, for those files
// only. Both games run the same engine, so most of these are one function under two names.

#include <nitro.h>

#pragma require_prototypes on // a HeartGold name nothing here maps fails to compile

#include "system.h"
#include "touch_screen.h"

// The touch screen: HeartGold's TouchscreenHitbox is Platinum's TouchScreenRect (the same union)
typedef TouchScreenRect TouchscreenHitbox;
#define TOUCHSCREEN_RECTLIST_END              TOUCHSCREEN_TABLE_TERMINATOR
#define TOUCHSCREEN_CIRCLE_SENTINEL           TOUCHSCREEN_USE_CIRCLE
#define TOUCH_MENU_NO_INPUT                   TOUCHSCREEN_INPUT_NONE
#define TouchscreenHitbox_TouchNewIsIn        TouchScreen_LocationPressed
#define TouchscreenHitbox_TouchHeldIsIn       TouchScreen_LocationHeld
#define TouchscreenHitbox_FindRectAtTouchNew  TouchScreen_CheckRectanglePressed
#define TouchscreenHitbox_FindRectAtTouchHeld TouchScreen_CheckRectangleHeld
#define System_GetTouchNew()                  (gSystem.touchPressed)
#define System_GetTouchHeld()                 (gSystem.touchHeld)


// Lists of strings: HeartGold's ListMenuItem is Platinum's StringList (text is entry, value is index)
#include "string_list.h"
typedef StringList ListMenuItem;
#define LIST_NOTHING_CHOSEN                         -1
#define LIST_CANCEL                                 -2
#define ListMenuItems_New(count, heapID)            StringList_New(count, heapID)
#define ListMenuItems_AppendFromMsgData             StringList_AddFromMessageBank
#define ListMenuItems_Delete                        StringList_Free

// Windows and text
#include "bg_window.h"
#include "font.h"
#include "text.h"
#define FONT_UNK_4                                  FONT_SUBSCREEN // the small font of touch buttons
#define TEXT_SPEED_NOTRANSFER                       TEXT_SPEED_NO_TRANSFER
#define MAKE_TEXT_COLOR                             TEXT_COLOR
#define AllocWindows                                Window_New
#define WindowArray_Delete                          Windows_Delete
#define AddWindow                                   Window_AddFromTemplate
#define AddWindowParameterized                      Window_Add
#define RemoveWindow                                Window_Remove
#define FillWindowPixelBuffer                       Window_FillTilemap
#define ScheduleWindowCopyToVram                    Window_ScheduleCopyToVRAM
#define ClearWindowTilemapAndScheduleTransfer       Window_ClearAndScheduleCopyToVRAM
#define ClearWindowTilemapAndCopyToVram             Window_ClearAndCopyToVRAM
#define AddTextPrinterParameterized                 Text_AddPrinterWithParams
#define AddTextPrinterParameterizedWithColor        Text_AddPrinterWithParamsAndColor
#define TextPrinterCheckActive                      Text_IsPrinterActive
#define FontID_String_GetWidth                      Font_CalcStringWidth
#define FontID_Alloc                                Font_InitManager
#define FontID_Release                              Font_Free

// Backgrounds
#define GF_BG_LYR_MAIN_0                            BG_LAYER_MAIN_0
#define GF_BG_LYR_MAIN_1                            BG_LAYER_MAIN_1
#define GF_BG_LYR_MAIN_2                            BG_LAYER_MAIN_2
#define GF_BG_LYR_MAIN_3                            BG_LAYER_MAIN_3
#define GF_BG_LYR_SUB_0                             BG_LAYER_SUB_0
#define GF_BG_LYR_SUB_1                             BG_LAYER_SUB_1
#define GF_BG_LYR_SUB_2                             BG_LAYER_SUB_2
#define GF_BG_LYR_SUB_3                             BG_LAYER_SUB_3
#define FillBgTilemapRect                           Bg_FillTilemapRect
#define ScheduleBgTilemapBufferTransfer             Bg_ScheduleTilemapTransfer
#define BG_LoadCharTilesData                        Bg_LoadTiles

// Tasks, palettes, files
#include "narc.h"
#include "palette.h"
#include "sys_task.h"
#include "sys_task_manager.h"
#define SysTask_CreateOnVWaitQueue                  SysTask_ExecuteAfterVBlank
#define SysTask_Destroy                             SysTask_Done
#define PaletteData_LoadPalette                     PaletteData_LoadBuffer
#define GfGfxLoader_LoadFromNarc                    LoadMemberFromNARC

// Sound: HeartGold's effects by Platinum's names; HeartGold's own (its GS ones) aren't in Platinum's sound archive,
// so the nearest of Platinum's stand in
#include "sound_playback.h"
#define PlaySE                                      Sound_PlayEffect
#define SEQ_SE_DP_SELECT                            SE_CONFIRM_sseq_3
#define SEQ_SE_DP_DECIDE                            SEQ_SE_DP_DECIDE_sseq
#define SEQ_SE_DP_BOX01                             SEQ_SE_DP_BOX01_sseq
#define SEQ_SE_DP_BOX03                             SEQ_SE_DP_BOX03_sseq
#define SEQ_SE_DP_BUTTON3                           SEQ_SE_DP_BUTTON3_sseq
#define SEQ_SE_DP_CARD2                             SEQ_SE_DP_CARD2_sseq
#define SEQ_SE_GS_PANERU_MEKURU                     SEQ_SE_DP_CARD2_sseq // a card turned over
#define SEQ_SE_GS_PANERU_MEKURUMAE                  SEQ_SE_DP_SELECT78_sseq // a card about to turn
#define SEQ_SE_GS_COIN_PAYOUT_ONE                   SEQ_SE_PL_COIN_sseq
#define SEQ_SE_GS_COIN_PAYOUT_LAST                  SEQ_SE_PL_COIN_sseq
#define SEQ_SE_GS_COIN_HAZURE                       SEQ_SE_DP_BOX03_sseq // no coins
#define SEQ_SE_GS_SLOT01                            SEQ_SE_DP_SLOT01_sseq
#define SEQ_SE_GS_SLOT02                            SEQ_SE_DP_SLOT02_sseq
#define SEQ_SE_GS_SLOT03                            SEQ_SE_DP_SLOT01_sseq

// Backgrounds and the display
#include "gx_layers.h"
typedef GXBanks GraphicsBanks;
typedef enum BgLayer GFBgLayer;
#define GF_PLANE_TOGGLE_OFF                         0
#define GF_PLANE_TOGGLE_ON                          1
#define GF_BG_SCR_SIZE_256x256                      BG_SCREEN_SIZE_256x256
#define GF_BG_TYPE_TEXT                             BG_TYPE_STATIC
#define BgConfig_Alloc                              BgConfig_New
#define InitBgFromTemplate                          Bg_InitFromTemplate
#define FreeBgTilemapBuffer                         Bg_FreeTilemapBuffer
#define BgClearTilemapBufferAndCommit               Bg_ClearTilemap
#define BgCommitTilemapBufferToVram                 Bg_CopyTilemapBufferToVRAM
#define ToggleBgLayer                               Bg_ToggleLayer
#define LoadRectToBgTilemapRect                     Bg_LoadToTilemapRect
#define BG_FillCharDataRange                        Bg_FillTilesRange
#define DoScheduledBgGpuUpdates                     Bg_RunScheduledUpdates
#define SetBothScreensModesAndDisable               SetAllGraphicsModes
#define GfGfx_SetBanks                              GXLayers_SetBanks
#define GfGfx_DisableEngineAPlanes                  GXLayers_DisableEngineALayers
#define GfGfx_DisableEngineBPlanes                  GXLayers_DisableEngineBLayers
#define GfGfx_EngineATogglePlanes                   GXLayers_EngineAToggleLayers
#define GfGfx_EngineBTogglePlanes                   GXLayers_EngineBToggleLayers

// The system: interrupts, fades, brightness
#include "brightness_controller.h"
#include "screen_fade.h"
#define Main_SetVBlankIntrCB                        SetVBlankCallback
#define HBlankInterruptDisable                      DisableHBlank
#define BeginNormalPaletteFade                      StartScreenFade
#define IsPaletteFadeFinished                       IsScreenFadeDone
#define SCREEN_MASK_MAIN                            BRIGHTNESS_MAIN_SCREEN
#define SCREEN_MASK_SUB                             BRIGHTNESS_SUB_SCREEN
#define InitScreenBrightnessData                    BrightnessController_ResetScreenController
#define StartBrightnessTransition                   BrightnessController_StartTransition
#define MTRandom                                    MTRNG_Next
#include "constants/colors.h"
#define RGB_BLACK                                   COLOR_BLACK

// Graphics files
#include "graphics.h"
#define GF_PAL_LOCATION_MAIN_BG                     PAL_LOAD_MAIN_BG
#define GF_PAL_LOCATION_MAIN_OBJ                    PAL_LOAD_MAIN_OBJ
#define GF_PAL_LOCATION_SUB_BG                      PAL_LOAD_SUB_BG
#define GF_PAL_LOCATION_SUB_OBJ                     PAL_LOAD_SUB_OBJ
#define GF_PAL_SLOT_OFFSET(slot)                    ((slot) * 32)
#define GF_PAL_SLOT_0_OFFSET                        GF_PAL_SLOT_OFFSET(0)
#define GF_PAL_SLOT_12_OFFSET                       GF_PAL_SLOT_OFFSET(12)
#define GF_PAL_SLOT_13_OFFSET                       GF_PAL_SLOT_OFFSET(13)
#define GF_PAL_SLOT_14_OFFSET                       GF_PAL_SLOT_OFFSET(14)
#define GfGfxLoader_GXLoadPal                       Graphics_LoadPalette
#define GfGfxLoader_GXLoadPalFromOpenNarc           Graphics_LoadPaletteFromOpenNARC
#define GfGfxLoader_LoadCharDataFromOpenNarc        Graphics_LoadTilesToBgLayerFromOpenNARC
#define GfGfxLoader_LoadScrnDataFromOpenNarc        Graphics_LoadTilemapToBgLayerFromOpenNARC
#define NARC_New                                    NARC_ctor
#define NARC_Delete                                 NARC_dtor

// Messages
#include "message.h"
#include "message_util.h"
#include "string_gf.h"
#include "string_template.h"
typedef MessageLoader MsgData;
typedef StringTemplate MessageFormat;
#define MSGDATA_LOAD_DIRECT                         MSG_LOADER_PRELOAD_ENTIRE_BANK
#define MSGDATA_LOAD_LAZY                           MSG_LOADER_LOAD_ON_DEMAND
#define NewMsgDataFromNarc                          MessageLoader_Init
#define DestroyMsgData                              MessageLoader_Free
#define NewString_ReadMsgData                       MessageLoader_GetNewString
#define ReadMsgData_ExpandPlaceholders              MessageUtil_ExpandedString
#define MessageFormat_New                           StringTemplate_Default
#define MessageFormat_Delete                        StringTemplate_Free
#define BufferIntegerAsString                       StringTemplate_SetNumber
#define BufferPlayersName                           StringTemplate_SetPlayerName
#define PRINTING_MODE_LEFT_ALIGN                    PADDING_MODE_NONE
#define PRINTING_MODE_RIGHT_ALIGN                   PADDING_MODE_SPACES
#define PRINTING_MODE_LEADING_ZEROS                 PADDING_MODE_ZEROES
#define String_Delete                               String_Free

// Message boxes and the player's options
#include "game_options.h"
#include "render_text.h"
#include "render_window.h"
#define DrawFrameAndWindow2                         Window_DrawMessageBoxWithScrollCursor
#define LoadUserFrameGfx2                           LoadMessageBoxGraphics
#define LoadFontPal0                                Font_LoadTextPalette
#define LoadFontPal1                                Font_LoadScreenIndicatorsPalette
#define TextFlags_SetCanABSpeedUpPrint              RenderControlFlags_SetCanABSpeedUpPrint
#define TextFlags_SetCanTouchSpeedUpPrint           RenderControlFlags_SetSpeedUpOnTouch
#define Options_GetTextFrameDelay                   Options_TextFrameDelay
#define Options_GetFrame                            Options_Frame

// The application: HeartGold's OverlayManager is Platinum's ApplicationManager
#include "overlay_manager.h"
typedef ApplicationManager OverlayManager;
#define OverlayManager_CreateAndGetData             ApplicationManager_NewData
#define OverlayManager_FreeData                     ApplicationManager_FreeData
#define OverlayManager_GetArgs                      ApplicationManager_Args
#define OverlayManager_GetData                      ApplicationManager_Data

// The save: the player, coins, game records
#include "coins.h"
#include "game_records.h"
#include "trainer_info.h"
#include "generated/trainer_score_events.h"
typedef TrainerInfo PlayerProfile;
typedef GameRecords GameStats;
#define Save_GameStats_Get                          SaveData_GetGameRecords
#define GameStats_AddScore                          GameRecords_IncrementTrainerScore
#define SCORE_EVENT_VOLTORB_FLIP                    TRAINER_SCORE_EVENT_UNK_06 // HeartGold's score for it, at its index

// Sprites: HeartGold's sprite system is Platinum's; a sub-screen sprite's y is past the main screen's in both (by 192
// here, HeartGold's renderer put it at 524, set by G2dRenderer_SetSubSurfaceCoords, which Voltorb Flip doesn't call)
#include "sprite_system.h"
typedef SpriteTemplate ManagedSpriteTemplate;
typedef SpriteResourceCapacities SpriteResourceCountsListUnion;
typedef RenderOamTemplate OamManagerParam;
typedef CharTransferTemplateWithModes OamCharTransferParam;
#define SpriteSystem_NewSpriteWithYOffset(sys, man, template, yOffset) SpriteSystem_NewSprite(sys, man, template)
#define ManagedSprite_SetPaletteOverride            ManagedSprite_SetExplicitPalette

// Sounds HeartGold's code checks
#define GF_IsAnySEPlaying                           Sound_IsAnyEffectPlaying
#define IsSEPlaying                                 Sound_IsEffectPlaying
#define PlayFanfare                                 Sound_PlayFanfare
#define SEQ_SE_GS_OKOZUKAI                          SEQ_SE_PL_COIN_sseq // the payout counting up
#define SEQ_ME_CARDGAME1                            SEQ_ME_CARDGAME1_sseq
#define SEQ_ME_CARDGAME2                            SEQ_ME_CARDGAME2_sseq
#define SEQ_ME_MUSHITORI3                           SEQ_ME_MUSHITORI3_sseq
#define IsFanfarePlaying                            Sound_IsBGMPausedByFanfare // and resumes the music once it's done, as HeartGold's

// The yes/no prompt: Platinum's touch one (yes_no_touch_menu.c), with HeartGold's buttons added in voltorb_flip.c
#include "yes_no_touch_menu.h"
typedef YesNoTouchMenu YesNoPrompt;
typedef enum YesNoResponse {
    YESNORESPONSE_WAIT = YES_NO_TOUCH_MENU_NOTHING_CHOSEN,
    YESNORESPONSE_YES = YES_NO_TOUCH_MENU_YES,
    YESNORESPONSE_NO = YES_NO_TOUCH_MENU_NO,
} YesNoResponse;
#define YesNoPrompt_Create                          YesNoTouchMenu_New
#define YesNoPrompt_Destroy                         YesNoTouchMenu_Free
#define YesNoPrompt_Reset                           YesNoTouchMenu_Reset

// Whether the player last used the touch screen or the buttons: MenuInputStateMgr (voltorb_flip.h)
#include "applications/complete_voltorb_flip/voltorb_flip.h"
#define MenuInputStateMgr_GetState(mgr)        ((mgr)->state)
#define MenuInputStateMgr_SetState(mgr, value) ((mgr)->state = (value))

#endif // POKEPLATINUM_COMPLETE_VOLTORB_FLIP_HGSS_COMPAT_H
