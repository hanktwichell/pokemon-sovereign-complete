#ifndef POKEPLATINUM_COMPLETE_BERRY_POTS_APP_INTERNAL_H
#define POKEPLATINUM_COMPLETE_BERRY_POTS_APP_INTERNAL_H

// Sovereign Complete: HeartGold's Berry Pots' screen (its berry_pots_app_internal.h and overlay_16.h), on Platinum's
// types: a pot is a BerryPatch (include/complete_berry_pots.h), HeartGold's growth data Platinum's BerryGrowthData, the
// pots' time 28 bytes of the phone save, the screen's arguments CompleteBerryPotsArgs.

#include <nitro/rtc.h>

#include "constants/heap.h"

#include "bag.h"
#include "berry_patches.h"
#include "complete_berry_pots.h"

#define MAX_BERRY_POT                   COMPLETE_BERRY_POT_COUNT
#define BERRY_POT_GROWTH_STAGE_NONE     0
#define BERRY_POT_GROWTH_STAGE_PLANTED  1
#define BERRY_POT_GROWTH_STAGE_SPROUTED 2
#define BERRY_POT_GROWTH_STAGE_GROWING  3
#define BERRY_POT_GROWTH_STAGE_BLOOM    4
#define BERRY_POT_GROWTH_STAGE_BERRIES  5

// berry_pots_growth.c: HeartGold's overlay 16, on Platinum's berry patch
u8 BerryPots_GetPotGrowthStage(BerryPatch *pots, u32 idx);
u8 BerryPots_GetPotBerryId(BerryPatch *pots, u32 idx);
u32 BerryPots_GetSoilState(BerryPatch *pots, u32 idx);
u8 BerryPots_GetPotMoisture(BerryPatch *pots, u32 idx);
u8 ov16_022015EC(BerryPatch *pots, u32 idx);
u16 ov16_022015F8(BerryPatch *pots, u32 idx);
u16 ov16_02201604(BerryPatch *pots, u32 idx);
void ov16_02201610(BerryPatch *pots, u32 idx, const BerryGrowthData *growth, u32 berryID);
void BerryPots_ResetPotMoisture(BerryPatch *pots, u32 idx);
u8 BerryPots_GetPotMulch(BerryPatch *pots, u32 idx);
void BerryPots_SetPotMulch(BerryPatch *pots, u32 idx, u32 mulch);
u16 ov16_02201668(BerryPatch *pots, u32 idx);
u16 ov16_02201674(BerryPatch *pots, u32 idx);
void ov16_02201760(BerryPatch *pots, const BerryGrowthData *growth, s32 minutes);
void BerryPots_SetBerryDatetime(u8 *dest, RTCDate date, RTCTime time);
void BerryPots_CopyBerryDatetime(u8 *datetime, RTCDate *date, RTCTime *time);
u16 BerryIdToItemId(u16 berryID);
u16 ItemIdToBerryId(u16 itemID);
u16 MulchIdToItemId(u16 mulch);
u32 ItemIdToMulchId(u16 itemID);
u16 GetTotalBerryQuantity(Bag *bag, enum HeapID heapID);
u16 GetTotalMulchQuantity(Bag *bag, enum HeapID heapID);

#ifndef COMPLETE_BERRY_POTS_GROWTH_ONLY
#include "applications/complete_berry_pots/hgss_compat.h"

enum BerryPotsApp_022036FC_Action {
    BERRY_POTS_APP_022036FC_ACTION_0,
    BERRY_POTS_APP_022036FC_ACTION_1,
    BERRY_POTS_APP_022036FC_ACTION_2,
    BERRY_POTS_APP_022036FC_ACTION_3,
    BERRY_POTS_APP_022036FC_ACTION_4,
    BERRY_POTS_APP_022036FC_ACTION_5,
    BERRY_POTS_APP_022036FC_ACTION_6,
    BERRY_POTS_APP_022036FC_ACTION_7,
    BERRY_POTS_APP_022036FC_ACTION_8,
    BERRY_POTS_APP_022036FC_ACTION_9,
    BERRY_POTS_APP_022036FC_ACTION_10,
    BERRY_POTS_APP_022036FC_ACTION_11,
    BERRY_POTS_APP_022036FC_ACTION_12,
    BERRY_POTS_APP_022036FC_ACTION_13,
    BERRY_POTS_APP_022036FC_ACTION_14,
    BERRY_POTS_APP_022036FC_ACTION_15,
    BERRY_POTS_APP_022036FC_ACTION_16,
};

typedef CompleteBerryPotsArgs BerryPotsAppArgs; // HeartGold's unk14 is request, unk15 pot, unk4's fields its own

typedef struct BerryPotsAppData_UnkSub20 {
    u8 berryId;
    u8 growthStage;
    u8 unk2;
    u8 moisture;
    u8 mulch;
    u8 quantityOrYieldMaybe;
    u16 unk6;
    u16 unk8;
    u8 soilState;
    u8 unkB;
    u8 unkC;
    u8 unkD;
    Sprite *soilSpriteMaybe;
} BerryPotsAppData_UnkSub20;

typedef struct BerryPotsAppData {
    enum HeapID heapID;
    BerryPotsAppArgs *args;
    void *unk8;
    Bag *bag;
    GameStats *stats;
    BerryPatch *berryPots;
    u8 *berryDatetime;
    BerryGrowthData *berryGrowthProperties;
    BerryPotsAppData_UnkSub20 unk20[MAX_BERRY_POT];
    u16 state70;
    u16 state72;
    MenuInputState fieldMenuState;
    u8 textFrameDelay;
    u8 frame;
    u8 unk7A;
    u8 unk7B;
    u8 unk7C;
    u8 runningTasks;
    u8 unk7E;
    u8 waitFrames;
    u8 unk80;
    u8 unk81;
    u16 totalBerryQuantity;
    u16 totalMulchQuantity;
    BgConfig *bgConfig;
    TouchscreenListMenuSpawner *menuSpawner;
    u8 unk90[12];
    MsgData *msgData;
    MessageFormat *msgFmt;
    String *currentStatusString;
    String *cancelString;
    u8 unkAC[4];
    String *statusStrings[17];
    u8 unkF4[8];
    Window windows[3];
    void *unk12C;
    SpriteSystem *spriteRenderer;
    SpriteManager *spriteGfxHandler1;
    SpriteManager *spriteGfxHandler2;
    u8 unk13C[40];
    Sprite *sprites[11];
    NARC *itemIconNarc;
    NARC *berryPotsAppNarc;
    ListMenuItem *listMenuItems[4];
    TouchscreenListMenu *menu;
} BerryPotsAppData;

void ov17_022028B8(BerryPotsAppData *data);
void ov17_02202850(BerryPotsAppData *data, u32 seqNo);
void ov17_02202B58(BerryPotsAppData *data, u8 index);
ManagedSprite *ov17_022034C8(BerryPotsAppData *data, s16 x, s16 y, u8 unused);
void ov17_02202A84(BerryPotsAppData *data, int index);
void ov17_0220351C(BerryPotsAppData *data);
void ov17_02203638(BerryPotsAppData *data);
void ov17_022036FC(BerryPotsAppData *data, enum BerryPotsApp_022036FC_Action action, u8 potIndex);
void ov17_022037C8(BerryPotsAppData *data, BOOL a1);
void ov17_0220387C(BerryPotsAppData *data);
void ov17_02203928(BerryPotsAppData *data);
u32 ov17_02203A34(BerryPotsAppData *data);
BOOL ov17_02203A54(BerryPotsAppData *data);
u32 ov17_02203A74(BerryPotsAppData *data, u32 a1);
u32 ov17_02203AD4(BerryPotsAppData *data);
u32 ov17_02203B68(BerryPotsAppData *data, BOOL *a1);
BOOL ov17_02203B88(BerryPotsAppData *data);
BOOL ov17_02203C20(BerryPotsAppData *data, BOOL *a1);
int ov17_02203C78(BerryPotsAppData *data);
int ov17_02203CC8(BerryPotsAppData *data);
u32 ov17_02203D00(BerryPotsAppData *data);

#endif // COMPLETE_BERRY_POTS_GROWTH_ONLY

#endif // POKEPLATINUM_COMPLETE_BERRY_POTS_APP_INTERNAL_H
