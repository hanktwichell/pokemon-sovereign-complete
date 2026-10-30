#include "complete_phone.h"

#include <nitro.h>

#include "constants/savedata/save_table.h"
#include "generated/items.h"
#include "generated/vars_flags.h"

#include "inlines.h"
#include "math_util.h"
#include "savedata.h"
#include "trainer_info.h"
#include "vars_flags.h"

// Sovereign Complete: the phone's save (include/complete_phone.h), which the main module keeps so the save can set it
// up away from the field. HeartGold's save_pokegear.c.

typedef char CompletePhoneSaveSize[sizeof(CompletePhoneSave) == 456 ? 1 : -1];

static u16 sMinutesSinceCall;
static BOOL sClockStarted;

int CompletePhone_SaveSize(void)
{
    return sizeof(CompletePhoneSave);
}

void CompletePhone_InitSave(CompletePhoneSave *phone)
{
    MI_CpuClear8(phone, sizeof(CompletePhoneSave));
    MI_CpuFill8(phone->contacts, PHONE_CONTACT_NONE, sizeof(phone->contacts));
    MI_CpuFill8(phone->recentCallers, PHONE_CONTACT_NONE, sizeof(phone->recentCallers));
}

CompletePhoneSave *SaveData_GetCompletePhone(SaveData *saveData)
{
    return SaveData_SaveTable(saveData, SAVE_TABLE_ENTRY_COMPLETE_PHONE);
}

// HeartGold's SavePokegear_IsNumberRegistered
BOOL CompletePhone_IsRegistered(SaveData *saveData, u8 contact)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(saveData);

    for (int i = 0; i < NUM_PHONE_CONTACTS; i++) {
        if (phone->contacts[i] == contact) {
            return TRUE;
        }
    }

    return FALSE;
}

// HeartGold's SavePokegear_RegisterPhoneNumber: the next free place in the book
void CompletePhone_Register(SaveData *saveData, u8 contact)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(saveData);

    if (contact >= NUM_PHONE_CONTACTS || CompletePhone_IsRegistered(saveData, contact)) {
        return;
    }

    for (int i = 0; i < NUM_PHONE_CONTACTS; i++) {
        if (phone->contacts[i] == PHONE_CONTACT_NONE) {
            phone->contacts[i] = contact;
            return;
        }
    }
}

// HeartGold's sub_02092E14: a call trigger is set (the call comes at a step after ten minutes since the last call, or
// with soon, after one more minute)
void CompletePhone_SetCallTrigger(SaveData *saveData, u8 trigger, BOOL soon)
{
    if (trigger >= NUM_CALL_TRIGGERS) {
        return;
    }

    SaveData_GetCompletePhone(saveData)->callTriggerFlags[trigger / 8] |= 1 << (trigger % 8);

    if (soon && sMinutesSinceCall < 9) {
        sMinutesSinceCall = 9;
    }
}

// HeartGold's sub_02092E34, as the field's clock moves on (src/unk_020559DC.c): the first time is the time away from
// the game, which doesn't count when it's ten minutes or more
void CompletePhone_AddMinutes(int minutes)
{
    if (!sClockStarted) {
        sClockStarted = TRUE;

        if (minutes >= 10) {
            return;
        }
    }

    sMinutesSinceCall = sMinutesSinceCall + minutes > 0xFFFF ? 0xFFFF : sMinutesSinceCall + minutes;
}

u16 CompletePhone_MinutesSinceCall(void)
{
    return sMinutesSinceCall;
}

void CompletePhone_ResetCallTimer(void)
{
    sMinutesSinceCall = 0;
}

// HeartGold's mom_gift.c: what Mom buys once her savings reach each amount (each the first time only), and Berries
// each time they pass another 3,000
static const struct {
    u16 item;
    u16 threshold;
    u16 cost;
} sMomGifts[] = {
    { ITEM_SUPER_POTION, 900, 600 },
    { ITEM_REPEL, 4000, 270 },
    { ITEM_SUPER_POTION, 7000, 600 },
    { ITEM_SILK_SCARF, 10000, 100 },
    { ITEM_MOON_STONE, 15000, 3000 },
    { ITEM_HYPER_POTION, 19000, 900 },
    { ITEM_CHOICE_SCARF, 30000, 200 },
    { ITEM_MUSCLE_BAND, 40000, 200 },
    { ITEM_FOCUS_SASH, 50000, 200 },
};

static const u16 sMomBerries[] = {
    ITEM_OCCA_BERRY,
    ITEM_PASSHO_BERRY,
    ITEM_WACAN_BERRY,
    ITEM_RINDO_BERRY,
    ITEM_YACHE_BERRY,
    ITEM_CHOPLE_BERRY,
    ITEM_KEBIA_BERRY,
    ITEM_SHUCA_BERRY,
    ITEM_COBA_BERRY,
    ITEM_PAYAPA_BERRY,
    ITEM_TANGA_BERRY,
    ITEM_CHARTI_BERRY,
    ITEM_KASIB_BERRY,
    ITEM_HABAN_BERRY,
    ITEM_COLBUR_BERRY,
    ITEM_BABIRI_BERRY,
    ITEM_CHILAN_BERRY,
};

#define MOM_BERRY_TIER     3000
#define MOM_BERRY_QUANTITY 5
#define MOM_BERRY_COST     100

BOOL CompletePhone_MomGiftsFull(CompletePhoneSave *phone)
{
    return phone->momGiftQueue[MOM_GIFT_QUEUE_SIZE - 1][1] != 0;
}

// HeartGold's PhoneCallPersistentState_MomGiftQueue_Put, with what it cost taken from her savings
static void MomBuys(CompletePhoneSave *phone, u16 item, u16 quantity, u16 cost)
{
    for (int i = 0; i < MOM_GIFT_QUEUE_SIZE; i++) {
        if (phone->momGiftQueue[i][1] == 0) {
            phone->momGiftQueue[i][0] = item;
            phone->momGiftQueue[i][1] = quantity;
            break;
        }
    }

    phone->momsSavings = phone->momsSavings < cost ? 0 : phone->momsSavings - cost;
}

// HeartGold's MomGift_TryEnqueueGiftOnBalanceChange: TRUE when she bought something
static BOOL MomShops(CompletePhoneSave *phone, u32 before)
{
    BOOL bought = FALSE;

    if (CompletePhone_MomGiftsFull(phone)) {
        return FALSE;
    }

    for (int i = 0; i < NELEMS(sMomGifts); i++) {
        if (phone->momGiftsBought & (1 << i)) {
            continue;
        }

        if (phone->momsSavings < sMomGifts[i].threshold) {
            break;
        }

        phone->momGiftsBought |= 1 << i;
        MomBuys(phone, sMomGifts[i].item, 1, sMomGifts[i].cost);
        bought = TRUE;

        if (CompletePhone_MomGiftsFull(phone)) {
            break;
        }
    }

    if (bought) {
        return TRUE;
    }

    if (phone->momsSavings / MOM_BERRY_TIER <= before / MOM_BERRY_TIER) {
        return FALSE;
    }

    MomBuys(phone, sMomBerries[LCRNG_RandMod(NELEMS(sMomBerries))], MOM_BERRY_QUANTITY, MOM_BERRY_COST);
    return TRUE;
}

// HeartGold's sub_0205230C, as a battle hands back the player's money (src/field_battle_data_transfer.c): with her
// savings on, Mom puts a quarter of what the player made aside (to 999,999), and may buy something with her savings,
// which she calls about
void CompletePhone_MomSavingsAfterBattle(SaveData *saveData, const TrainerInfo *before, TrainerInfo *after)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(saveData);
    u32 savings = phone->momsSavings;

    if (!VarsFlags_CheckFlag(SaveData_GetVarsFlags(saveData), FLAG_HGSS_SYS_MOMS_SAVINGS)) {
        return;
    }

    int share = ((int)TrainerInfo_Money(after) - (int)TrainerInfo_Money(before)) / 4;

    if (share > 0) {
        if (savings + share >= MOMS_SAVINGS_MAX) {
            share = MOMS_SAVINGS_MAX - savings;
        }

        TrainerInfo_SetMoney(after, TrainerInfo_Money(after) - share);
        phone->momsSavings += share;
    }

    if (MomShops(phone, savings)) {
        CompletePhone_SetCallTrigger(saveData, CALL_TRIGGER_MOM_BOUGHT_SOMETHING, TRUE);
    }
}
