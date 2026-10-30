#include "complete_phone.h"

#include <nitro.h>

#include "constants/savedata/save_table.h"
#include "generated/items.h"
#include "generated/species.h"
#include "generated/vars_flags.h"
#include "res/text/bank/special_met_location_names.h"

#include "inlines.h"
#include "math_util.h"
#include "pc_boxes.h"
#include "pokedex.h"
#include "pokemon.h"
#include "savedata.h"
#include "savedata/save_table.h"
#include "trainer_info.h"
#include "unk_02017038.h"
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

// HeartGold's sub_02093070 and sub_020930C4, after a wild battle (src/encounter.c): Bill calls once, when the boxes
// are full, and Oak each time the National Pokédex's caught count reaches another 50 (up to 450) he hasn't rated
void CompletePhone_AfterWildBattle(SaveData *saveData)
{
    VarsFlags *varsFlags = SaveData_GetVarsFlags(saveData);

    if (CompletePhone_IsRegistered(saveData, PHONE_CONTACT_BILL)
        && !VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_GOT_BILL_PC_FULL_CALL)
        && PCBoxes_FirstEmptyBox(SaveData_GetPCBoxes(saveData)) == MAX_PC_BOXES) {
        CompletePhone_SetCallTrigger(saveData, CALL_TRIGGER_BILL_PC_FULL, TRUE);
    }

    int fifties = Pokedex_CountCaught_National(SaveData_GetPokedex(saveData)) / 50;

    if (CompletePhone_IsRegistered(saveData, PHONE_CONTACT_PROF__OAK) && fifties > 0
        && !VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION + (fifties > 9 ? 9 : fifties))) {
        CompletePhone_SetCallTrigger(saveData, CALL_TRIGGER_OAK_DEX_PROGRESS, FALSE);
    }
}

// HeartGold's sub_02093134 and MonIsFromTogepiEgg, as an Egg hatches (src/egg_hatch.c): Elm's Togepi Egg, the only
// Egg from Mr. Pokémon (CompleteScrCmd_GiveTogepiEgg), hatched with the player as its trainer. Elm calls, and has
// something for the player at the lab (FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG). HeartGold tells it by the personality and
// gender it saved with the gift.
void CompletePhone_EggHatched(SaveData *saveData, Pokemon *mon)
{
    TrainerInfo *trainerInfo = SaveData_GetTrainerInfo(saveData);
    u16 species = Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL);

    if ((species != SPECIES_TOGEPI && species != SPECIES_TOGETIC && species != SPECIES_TOGEKISS)
        || Pokemon_GetValue(mon, MON_DATA_EGG_LOCATION, NULL) != SpecialMetLoc_GetId(1, SPECIAL_METLOC_NAME_MR_POKEMON)
        || Pokemon_GetValue(mon, MON_DATA_OT_ID, NULL) != TrainerInfo_ID(trainerInfo)
        || Pokemon_GetValue(mon, MON_DATA_OT_GENDER, NULL) != TrainerInfo_Gender(trainerInfo)) {
        return;
    }

    CompletePhone_SetCallTrigger(saveData, CALL_TRIGGER_ELM_EGG_HATCHED, TRUE);
    VarsFlags_SetFlag(SaveData_GetVarsFlags(saveData), FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG);
}

// HeartGold's sub_0209316C, as the Day-Care finds an Egg (src/overlay005/daycare.c): the Day-Care Man calls about it,
// the first time, and after that if the player asked him to (FLAG_HGSS_SYS_SUBSCRIBED_TO_EGG_CALLS)
void CompletePhone_DaycareHasEgg(SaveData *saveData)
{
    VarsFlags *varsFlags = SaveData_GetVarsFlags(saveData);

    if (!CompletePhone_IsRegistered(saveData, PHONE_CONTACT_DAY_C_MAN)
        || (VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_TRIGGER_EGG_CALL)
            && !VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_SUBSCRIBED_TO_EGG_CALLS))) {
        return;
    }

    CompletePhone_SetCallTrigger(saveData, CALL_TRIGGER_DAYCARE_HAS_EGG, TRUE);
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
