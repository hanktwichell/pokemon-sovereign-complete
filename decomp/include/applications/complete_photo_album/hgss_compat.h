#ifndef POKEPLATINUM_COMPLETE_PHOTO_ALBUM_HGSS_COMPAT_H
#define POKEPLATINUM_COMPLETE_PHOTO_ALBUM_HGSS_COMPAT_H

// Sovereign Complete: HeartGold's photo album (src/applications/complete_photo_album/) keeps HeartGold's code (its
// overlay 109, decompiled); this header adds what it needs to Voltorb Flip's names for Platinum's libraries. Only the
// album's own files include it.

// The touch screen list menu: Voltorb Flip's port of HeartGold's, compiled again into the album's overlay under its
// own names (src/applications/complete_photo_album/list_menu.c), as each overlay needs its own copy
#define TouchscreenListMenuSpawner_Create        PhotoAlbumListMenuSpawner_Create
#define TouchscreenListMenuSpawner_Destroy       PhotoAlbumListMenuSpawner_Destroy
#define TouchscreenListMenu_Create               PhotoAlbumListMenu_Create
#define TouchscreenListMenu_CreateWithAlignment  PhotoAlbumListMenu_CreateWithAlignment
#define TouchscreenListMenu_CreateWithCallback   PhotoAlbumListMenu_CreateWithCallback
#define TouchscreenListMenu_WasLastInputTouch    PhotoAlbumListMenu_WasLastInputTouch
#define TouchscreenListMenu_Destroy              PhotoAlbumListMenu_Destroy
#define TouchscreenListMenu_DestroyButtons       PhotoAlbumListMenu_DestroyButtons
#define TouchscreenListMenu_HandleInput          PhotoAlbumListMenu_HandleInput

#include "applications/complete_voltorb_flip/hgss_compat.h"
#include "applications/complete_voltorb_flip/touchscreen_list_menu.h"

#include "graphics.h"
#include "map_header_util.h"
#include "save_player.h"
#include "render_oam.h"
#include "screen_fade.h"
#include "sprite.h"
#include "string_gf.h"
#include "string_template.h"
#include "touch_pad.h"
#include "vram_transfer.h"

#define HEAP_ID_PHOTO_ALBUM HEAP_ID_DIPLOMA // the diploma's: its app can't run at the same time (as Voltorb Flip's)

#define sub_0200FBF4                            SetScreenColorBrightness
#define GF_CreateVramTransferManager            VramTransfer_New
#define GF_DestroyVramTransferManager           VramTransfer_Free
#define NNS_GfdDoVramTransfer                   VramTransfer_Process
#define thunk_ClearMainOAM                      Utility_Clear2DMainOAM
#define thunk_ClearSubOAM                       Utility_Clear2DSubOAM
#define SetBgAffine                             Bg_SetAffineParams
#define BgSetPosTextAndCommit                   Bg_SetOffset
#define BG_POS_OP_SET_X                         BG_OFFSET_UPDATE_SET_X
#define BG_ClearCharDataRange                   Bg_ClearTilesRange
#define CopyToBgTilemapRect                     Bg_CopyToTilemapRect
#define GfGfxLoader_GetScrnDataFromOpenNarc     Graphics_GetScrnDataFromOpenNARC
#define GF_BG_TYPE_256x16PLTT                   BG_TYPE_STATIC_WITH_AFFINE
#define GF_BG_BUF_SIZE_256x256_4BPP             0x800
#define MessageFormat_New_Custom                StringTemplate_New
#define StringExpandPlaceholders                StringTemplate_Format
#define CopyU16ArrayToString                    String_CopyChars
#define String_New                              String_Init
#define SysTask_CreateOnMainQueue               SysTask_Start
#define BufferString(fmt, idx, str, gender, cap, lang) StringTemplate_SetString(fmt, idx, str, gender, cap, lang)

#endif // POKEPLATINUM_COMPLETE_PHOTO_ALBUM_HGSS_COMPAT_H
