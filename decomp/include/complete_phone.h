#ifndef POKEPLATINUM_COMPLETE_PHONE_H
#define POKEPLATINUM_COMPLETE_PHONE_H

#include "constants/hgss_phone.h"

#include "field/field_system_decl.h"
#include "field_script_context.h"
#include "pokemon.h"
#include "savedata.h"
#include "trainer_info.h"

// Sovereign Complete: HeartGold's Pokégear phone (its save_pokegear.c, phonebook_dat.c, overlay 26's rematches and the
// phone app's calls). The contacts the player has, which of them want a rematch or have a gift waiting, and Mom's
// savings are saved (SAVE_TABLE_ENTRY_COMPLETE_PHONE); the phone book and calls are
// src/overlay006/complete_phone_calls.c, with HeartGold's data (tools/complete/import_hgss_phone.py). Until the
// Pokétch and Pokégear question is answered, calls show in the field's message box.

typedef struct CompletePhoneRematch {
    u16 seeking : 1; // wants a rematch (a call asked for one)
    u16 hasGift : 1;
    u16 unused : 14;
    u16 giftItem; // kept for the player (a call said so), ITEM_NONE after it's given
} CompletePhoneRematch;

typedef struct CompletePhoneSave {
    u8 contacts[NUM_PHONE_CONTACTS]; // the phone book in the order registered, PHONE_CONTACT_NONE after the last
    u8 kenjiWaitDays : 7;
    u8 kenjiActive : 1;
    CompletePhoneRematch rematches[NUM_PHONE_CONTACTS];
    u32 momsSavings;
    u16 momGiftQueue[5][2]; // what Mom bought for the player, and how many, for the Poké Marts' deliveryman
    u8 callTriggerFlags[2]; // HeartGold's call triggers (src/overlay006/complete_phone_calls.c), a bit each
    u8 recentCallers[8]; // the last random callers of each call group
    u16 momGiftsBought; // Mom's list of things to buy with her savings, a bit each
    u8 reserved[44];
} CompletePhoneSave;

#define MOM_GIFT_QUEUE_SIZE          5
#define MOMS_SAVINGS_MAX             999999
#define COMPLETE_PHONE_INCOMING_CALL (0x814 - 0x7D0) // CommonScript_CompletePhoneIncomingCall

int CompletePhone_SaveSize(void);
void CompletePhone_InitSave(CompletePhoneSave *phone);
CompletePhoneSave *SaveData_GetCompletePhone(SaveData *saveData);

BOOL CompletePhone_IsRegistered(SaveData *saveData, u8 contact);
void CompletePhone_Register(SaveData *saveData, u8 contact);
void CompletePhone_SetCallTrigger(SaveData *saveData, u8 trigger, BOOL soon);
BOOL CompletePhone_MomGiftsFull(CompletePhoneSave *phone);
void CompletePhone_MomSavingsAfterBattle(SaveData *saveData, const TrainerInfo *before, TrainerInfo *after);
void CompletePhone_AfterWildBattle(SaveData *saveData);
void CompletePhone_EggHatched(SaveData *saveData, Pokemon *mon);
void CompletePhone_DaycareHasEgg(SaveData *saveData);

// The minutes since the last call (HeartGold's ring manager's, which isn't saved either)
void CompletePhone_AddMinutes(int minutes);
u16 CompletePhone_MinutesSinceCall(void);
void CompletePhone_ResetCallTimer(void);

// src/overlay006/complete_phone_calls.c (loaded with the field)
u8 CompletePhone_ContactForTrainer(u16 trainerID);
u16 CompletePhone_GetRematchTrainer(SaveData *saveData, u8 contact);
BOOL CompletePhone_TryIncomingCall(FieldSystem *fieldSystem);

BOOL CompleteScrCmd_PhoneRegister(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneCheckRegistered(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneGetRematch(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneEndRematch(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneLoadContact(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneContactMessage(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneTakeGift(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneRematchGift(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneCallStart(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneCallMessage(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneCallAnswer(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneCallEnd(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneSetCallTrigger(ScriptContext *ctx);
BOOL CompleteScrCmd_PhoneClearCallTrigger(ScriptContext *ctx);

// src/overlay006/complete_moms_savings.c: Mom's gifts at the Poké Marts and her bank at home
BOOL CompleteScrCmd_MomGiftCheck(ScriptContext *ctx);
BOOL CompleteScrCmd_MomGiftPeek(ScriptContext *ctx);
BOOL CompleteScrCmd_MomGiftTake(ScriptContext *ctx);
BOOL CompleteScrCmd_BankCheckBalance(ScriptContext *ctx);
BOOL CompleteScrCmd_BankOrWalletIsFull(ScriptContext *ctx);
BOOL CompleteScrCmd_BankShowBalance(ScriptContext *ctx);
BOOL CompleteScrCmd_BankHideBalance(ScriptContext *ctx);
BOOL CompleteScrCmd_BankTransaction(ScriptContext *ctx);

#ifdef SOVEREIGN_TEST
extern u8 gCompleteTestPhoneCaller;
#endif

#endif // POKEPLATINUM_COMPLETE_PHONE_H
