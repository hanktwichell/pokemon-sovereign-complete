#include <nitro.h>

#include "constants/items.h"
#include "generated/items.h"

#define COMPLETE_BERRY_POTS_GROWTH_ONLY // the growth only: plain Platinum code, no HeartGold names
#include "applications/complete_berry_pots/berry_pots_app_internal.h"

#include "bag.h"
#include "berry_patches.h"
#include "heap.h"

// Sovereign Complete: HeartGold's Berry Pots' growth (its overlay 16, ov16_022014A0.c), on Platinum's berry patch
// (include/complete_berry_pots.h says which field is which): a stage lasts the Berry's hours (a quarter less with Growth
// Mulch, half again with Damp), the soil dries by the Berry's rate each hour (half with Damp Mulch, half again with
// Growth), each dry hour costs the yield a point, the Berries stay 4 stages' time (6 with Stable Mulch) and the plant
// comes back 10 times (15 with Gooey Mulch). Platinum's growth data (BerryGrowthData_Init) is HeartGold's, each Berry's
// hours, drain rate and yield.

static void BerryPot_Clear(BerryPatch *pot)
{
    pot->berryID = 0;
    pot->growthStage = BERRY_POT_GROWTH_STAGE_NONE;
    pot->stageMinutesRemaining = 0;
    pot->moistureMinutesRemaining = 0;
    pot->replantCount = 0;
    pot->yield = 0;
    pot->moistureRating = 0;
    pot->yieldRating = 0;
    pot->mulchType = MULCH_TYPE_NONE;
    pot->isGrowing = FALSE; // Platinum's own growth leaves the pots be
}

static u32 BerryPot_Yield(BerryPatch *pot, const BerryGrowthData *growth)
{
    return pot->yieldRating * growth[pot->berryID - 1].baseYield;
}

static u32 BerryPot_StageMinutes(const BerryGrowthData *growth, int berryID, int mulch)
{
    s32 minutes = growth[berryID - 1].stageDuration * 60;

    if (mulch == MULCH_TYPE_GROWTH) {
        return minutes * 3 / 4;
    } else if (mulch == MULCH_TYPE_DAMP) {
        minutes += minutes / 2;
    }

    return minutes;
}

static u32 BerryPot_DrainRate(const BerryGrowthData *growth, int berryID, int mulch)
{
    s32 rate = growth[berryID - 1].moistureDrainRate;

    if (mulch == MULCH_TYPE_DAMP) {
        return rate / 2;
    } else if (mulch == MULCH_TYPE_GROWTH) {
        rate += rate / 2;
    }

    return rate;
}

static u32 BerryPot_FruitStages(BerryPatch *pot)
{
    return pot->mulchType == MULCH_TYPE_STABLE ? 6 : 4;
}

static u32 BerryPot_Replants(BerryPatch *pot)
{
    return pot->mulchType == MULCH_TYPE_GOOEY ? 15 : 10;
}

static u32 BerryPot_LifetimeStages(BerryPatch *pot)
{
    return (BerryPot_FruitStages(pot) + 3) * BerryPot_Replants(pot) + 1;
}

u8 BerryPots_GetPotGrowthStage(BerryPatch *pots, u32 idx)
{
    return pots[idx].growthStage;
}

u8 BerryPots_GetPotBerryId(BerryPatch *pots, u32 idx)
{
    return pots[idx].berryID;
}

u32 BerryPots_GetSoilState(BerryPatch *pots, u32 idx)
{
    s32 moisture = pots[idx].moistureRating;

    if (moisture == 0) {
        return 0;
    } else if (moisture <= 50) {
        return 1;
    }

    return 2;
}

u8 BerryPots_GetPotMoisture(BerryPatch *pots, u32 idx)
{
    return pots[idx].moistureRating;
}

u8 ov16_022015EC(BerryPatch *pots, u32 idx)
{
    return pots[idx].yieldRating;
}

u16 ov16_022015F8(BerryPatch *pots, u32 idx)
{
    return pots[idx].stageMinutesRemaining;
}

u16 ov16_02201604(BerryPatch *pots, u32 idx)
{
    return pots[idx].moistureMinutesRemaining;
}

// HeartGold's ov16_02201610: the Berry planted, the soil wet, the yield full
void ov16_02201610(BerryPatch *pots, u32 idx, const BerryGrowthData *growth, u32 berryID)
{
    pots[idx].berryID = berryID;
    pots[idx].growthStage = BERRY_POT_GROWTH_STAGE_PLANTED;
    pots[idx].stageMinutesRemaining = BerryPot_StageMinutes(growth, berryID, pots[idx].mulchType);
    pots[idx].moistureMinutesRemaining = 0;
    pots[idx].replantCount = 0;
    pots[idx].yield = 0;
    pots[idx].moistureRating = 100;
    pots[idx].yieldRating = 5;
    pots[idx].isGrowing = FALSE;
}

void BerryPots_ResetPotMoisture(BerryPatch *pots, u32 idx)
{
    pots[idx].moistureRating = 100;
}

u8 BerryPots_GetPotMulch(BerryPatch *pots, u32 idx)
{
    return pots[idx].mulchType;
}

void BerryPots_SetPotMulch(BerryPatch *pots, u32 idx, u32 mulch)
{
    pots[idx].mulchType = mulch;
}

u16 ov16_02201668(BerryPatch *pots, u32 idx)
{
    return pots[idx].yield;
}

// HeartGold's ov16_02201674: the Berries picked, the pot emptied
u16 ov16_02201674(BerryPatch *pots, u32 idx)
{
    u16 yield = pots[idx].yield;

    BerryPot_Clear(&pots[idx]);
    return yield;
}

static void BerryPot_NextStage(BerryPatch *pot, const BerryGrowthData *growth)
{
    switch (pot->growthStage) {
    case BERRY_POT_GROWTH_STAGE_NONE:
        GF_ASSERT(FALSE);
        return;
    case BERRY_POT_GROWTH_STAGE_PLANTED:
    case BERRY_POT_GROWTH_STAGE_SPROUTED:
    case BERRY_POT_GROWTH_STAGE_GROWING:
        pot->growthStage++;
        return;
    case BERRY_POT_GROWTH_STAGE_BLOOM:
        pot->yield = BerryPot_Yield(pot, growth);

        if (pot->yield < 2) {
            pot->yield = 2;
        }

        pot->growthStage++;
        return;
    case BERRY_POT_GROWTH_STAGE_BERRIES: // the Berries fall; the plant grows again from its sprout
        pot->yield = 0;
        pot->growthStage = BERRY_POT_GROWTH_STAGE_SPROUTED;
        pot->yieldRating = 5;
        pot->replantCount++;

        if (pot->replantCount == BerryPot_Replants(pot)) {
            BerryPot_Clear(pot);
        }
        return;
    }
}

static void BerryPot_Dry(BerryPatch *pot, const BerryGrowthData *growth, int minutes)
{
    if (pot->growthStage == BERRY_POT_GROWTH_STAGE_BERRIES) {
        return;
    }

    int rate = BerryPot_DrainRate(growth, pot->berryID, pot->mulchType);
    int hours = (minutes + pot->moistureMinutesRemaining) / 60;

    pot->moistureMinutesRemaining = (minutes + pot->moistureMinutesRemaining) % 60;

    if (hours == 0) {
        return;
    }

    if (pot->moistureRating >= rate * hours) {
        pot->moistureRating -= hours * rate;
        return;
    }

    if (pot->moistureRating != 0) {
        hours -= (pot->moistureRating + rate - 1) / rate;
        pot->moistureRating = 0;
    }

    if (pot->yieldRating > hours) {
        pot->yieldRating -= hours;
        return;
    }

    pot->yieldRating = 0;
}

// HeartGold's ov16_02201760: the minutes since the pots last grew, pot by pot
void ov16_02201760(BerryPatch *pots, const BerryGrowthData *growth, s32 minutes)
{
    for (s32 i = 0; i < MAX_BERRY_POT; i++) {
        BerryPatch *pot = &pots[i];

        if (pot->berryID == 0 || pot->growthStage == BERRY_POT_GROWTH_STAGE_NONE) {
            continue;
        }

        s32 stage = BerryPot_StageMinutes(growth, pot->berryID, pot->mulchType);

        if (minutes >= stage * (s32)BerryPot_LifetimeStages(pot)) {
            BerryPot_Clear(pot);
            continue;
        }

        s32 left = minutes;

        while (pot->growthStage != BERRY_POT_GROWTH_STAGE_NONE && left != 0) {
            if (pot->stageMinutesRemaining > left) {
                BerryPot_Dry(pot, growth, left);
                pot->stageMinutesRemaining -= left;
                break;
            }

            BerryPot_Dry(pot, growth, pot->stageMinutesRemaining);
            BerryPot_NextStage(pot, growth);
            left -= pot->stageMinutesRemaining;
            pot->stageMinutesRemaining = BerryPot_StageMinutes(growth, pot->berryID, pot->mulchType);

            if (pot->growthStage == BERRY_POT_GROWTH_STAGE_BERRIES) {
                pot->stageMinutesRemaining *= BerryPot_FruitStages(pot);
            }
        }
    }
}

void BerryPots_SetBerryDatetime(u8 *dest, RTCDate date, RTCTime time)
{
    MI_CpuCopy8(&date, dest, sizeof(RTCDate));
    MI_CpuCopy8(&time, dest + sizeof(RTCDate), sizeof(RTCTime));
}

void BerryPots_CopyBerryDatetime(u8 *datetime, RTCDate *date, RTCTime *time)
{
    MI_CpuCopy8(datetime, date, sizeof(RTCDate));
    MI_CpuCopy8(datetime + sizeof(RTCDate), time, sizeof(RTCTime));
}

u16 BerryIdToItemId(u16 berryID)
{
    return berryID == 0 ? ITEM_NONE : berryID + ITEM_CHERI_BERRY - 1;
}

u16 ItemIdToBerryId(u16 itemID)
{
    return itemID == ITEM_NONE ? 0 : itemID - ITEM_CHERI_BERRY + 1;
}

u16 MulchIdToItemId(u16 mulch)
{
    return mulch == MULCH_TYPE_NONE ? ITEM_NONE : mulch + ITEM_GROWTH_MULCH - 1;
}

u32 ItemIdToMulchId(u16 itemID)
{
    return itemID == ITEM_NONE ? MULCH_TYPE_NONE : itemID - ITEM_GROWTH_MULCH + 1;
}

u16 GetTotalBerryQuantity(Bag *bag, enum HeapID heapID)
{
    u16 total = 0;

    for (s32 i = 0; i < NUM_BERRIES; i++) {
        total += Bag_GetItemQuantity(bag, ITEM_CHERI_BERRY + i, heapID);
    }

    return total;
}

u16 GetTotalMulchQuantity(Bag *bag, enum HeapID heapID)
{
    u16 total = 0;

    for (s32 i = 0; i < MULCH_TYPE_GOOEY; i++) {
        total += Bag_GetItemQuantity(bag, ITEM_GROWTH_MULCH + i, heapID);
    }

    return total;
}
