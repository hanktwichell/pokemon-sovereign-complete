#include "complete_phone.h"

#include <nitro.h>

#include "constants/savedata/save_table.h"

#include "savedata.h"

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
