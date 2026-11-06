#ifndef POKEPLATINUM_COMPLETE_BERRY_POTS_HGSS_COMPAT_H
#define POKEPLATINUM_COMPLETE_BERRY_POTS_HGSS_COMPAT_H

// Sovereign Complete: HeartGold's Berry Pots' screen (src/applications/complete_berry_pots/) keeps HeartGold's code
// (its overlay 17, decompiled); this header adds what it needs to Voltorb Flip's names for Platinum's libraries. Only
// the screen's own files include it.

// The touch screen list menu: Voltorb Flip's port of HeartGold's, compiled again into this overlay under its own names
// (src/applications/complete_berry_pots/list_menu.c), as each overlay needs its own copy
#define COMPLETE_LIST_MENU_NAMED // the album's header leaves these alone
#define TouchscreenListMenuSpawner_Create        BerryPotsListMenuSpawner_Create
#define TouchscreenListMenuSpawner_Destroy       BerryPotsListMenuSpawner_Destroy
#define TouchscreenListMenu_Create               BerryPotsListMenu_Create
#define TouchscreenListMenu_CreateWithAlignment  BerryPotsListMenu_CreateWithAlignment
#define TouchscreenListMenu_CreateWithCallback   BerryPotsListMenu_CreateWithCallback
#define TouchscreenListMenu_WasLastInputTouch    BerryPotsListMenu_WasLastInputTouch
#define TouchscreenListMenu_Destroy              BerryPotsListMenu_Destroy
#define TouchscreenListMenu_DestroyButtons       BerryPotsListMenu_DestroyButtons
#define TouchscreenListMenu_HandleInput          BerryPotsListMenu_HandleInput

#include "applications/complete_photo_album/hgss_compat.h" // the album's additions (it includes Voltorb Flip's)

#include "constants/narc.h"
#include "generated/game_records.h"
#include "generated/text_banks.h"

#include "bag.h"
#include "berry_data.h"
#include "game_records.h"
#include "item.h"
#include "rtc.h"
#include "savedata.h"
#include "sound.h"
#include "sprite.h"
#include "sprite_util.h"

#define HEAP_ID_BERRY_POTS_APP HEAP_ID_DIPLOMA // the diploma's, as the album's: the apps can't run at the same time

// The screen's NARC (tools/complete/import_hgss_berry_pots.py: HeartGold's a/2/1/6, member n as member n), its text
// (HeartGold's message bank 248) and the item icons
#define NARC_a_2_1_6                             NARC_INDEX_GRAPHIC__COMPLETE__BERRY_POTS
#define NARC_itemtool_itemdata_item_icon         NARC_INDEX_ITEMTOOL__ITEMDATA__ITEM_ICON
#define NARC_msgdata_msg                         NARC_INDEX_MSGDATA__PL_MSG
#define msg_0248                                 TEXT_BANK_HGSS_MSG_0248
#define ITEMNARC_NCGR                            ITEM_FILE_TYPE_ICON
#define ITEMNARC_NCLR                            ITEM_FILE_TYPE_PALETTE
#define GetItemIndexMapping                      Item_FileID
#define GetItemIconCell()                        Item_IconNCERFile()
#define GetItemIconAnim()                        Item_IconNANRFile()

// The bag, the save, the clock
#define Save_Bag_Get                             SaveData_GetBag
#define Bag_AddItem                              Bag_TryAddItem
#define Bag_HasSpaceForItem                      Bag_CanFitItem
#define Bag_TakeItem                             Bag_TryRemoveItem
#define ItemIdIsBerry                            Item_IsBerry
#define Save_PlayerData_GetOptionsAddr           SaveData_GetOptions
#define GF_RTC_CopyDateTime                      GetCurrentDateTime
#define GameStats_Inc                            GameRecords_IncrementRecordValue
#define GAME_STAT_BERRIES_PLANTED                RECORD_BERRIES_PLANTED
#define BufferItemName                           StringTemplate_SetItemName
#define GetNutName(berryId, heapID)              BerryData_AllocAndGetName((berryId) != 0 ? (berryId) - 1 : 0, heapID)

// Sounds: HeartGold's own (tools/complete/import_hgss_sound.py), loaded as they play; the bag's scene, as HeartGold's
// screen sets its own scene without music
#define SEQ_SE_GS_KP01                           SEQ_SE_GS_KP01_sseq
#define SEQ_SE_GS_MIZU                           SEQ_SE_GS_MIZU_sseq
#define StopSE                                   Sound_StopEffect
#define BERRY_POTS_SOUND_SCENE                   SOUND_SCENE_SUB_BAG

// Sprites: HeartGold's unmanaged sprite template is Platinum's template for a sprite from a resource header; its
// managers share one sprite list
typedef SpriteTemplateFromResourceHeader UnmanagedSpriteTemplate;
#define SpriteSystem_CreateSpriteFromResourceHeader BerryPots_CreateSpriteFromResourceHeader

// HeartGold's template ends with a palette mode (Platinum's dummy18), which Platinum's version ignores, always setting
// the palette given: 0 sets it, 1 keeps the cell's own palettes (the pots' soil, the plants'), 2 sets it from where
// the sprite's palettes are
static inline Sprite *BerryPots_CreateSpriteFromResourceHeader(SpriteSystem *system, SpriteManager *manager, const UnmanagedSpriteTemplate *template)
{
    Sprite *sprite = SpriteSystem_NewSpriteFromResourceHeader(system, manager, template);

    if (sprite != NULL && template->dummy18 == 1) {
        Sprite_SetExplicitPaletteOffsetAutoAdjust(sprite, 0);
    } else if (sprite != NULL && template->dummy18 == 2) {
        Sprite_SetExplicitPaletteWithOffset(sprite, template->plttIdx);
    }

    return sprite;
}
#define SpriteManager_SetSpriteList(man, list)   ((man)->sprites = (list))
#define Sprite_ResetAnimCtrlState                Sprite_RestartAnim
#define Sprite_SetAnimActiveFlag                 Sprite_SetAnimateFlag
#define Sprite_SetAnimCtrlSeq                    Sprite_SetAnim
#define Sprite_SetAnimationFrame                 Sprite_SetAnimFrame
#define sub_0200E2B8                             SpriteSystem_ReplaceCharResObjFromOpenNarc

#endif // POKEPLATINUM_COMPLETE_BERRY_POTS_HGSS_COMPAT_H
