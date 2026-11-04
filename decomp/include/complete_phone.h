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
// src/overlay006/complete_phone_calls.c, with HeartGold's data (tools/complete/import_hgss_phone.py). Calls show in
// the field's message box: the ones that come in, and the ones the player places from the Pokégear.

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
    u8 pokegearSkin; // HeartGold's Pokégear skin (its settings), 0-5 (include/complete_pokegear.h)
    u16 bikeSteps; // HeartGold's GAME_STAT_STEPS_BIKED, counted up to the Bike Shop's call (CompletePhone_CountBikeStep)
    u8 safariAreas[6]; // HeartGold's PhoneCallPersistentState_SafariZoneArrangement: the areas whose Pokémon changed,
    u8 safariAreaCount; // which Baoba calls about (CompletePhone_SetSafariAreas)
    u8 reserved[33];
} CompletePhoneSave;

#define MOM_GIFT_QUEUE_SIZE          5
#define MOMS_SAVINGS_MAX             999999
#define COMPLETE_PHONE_INCOMING_CALL (0x814 - 0x7D0) // CommonScript_CompletePhoneIncomingCall
#define COMPLETE_PHONE_OUTGOING_CALL (0x81E - 0x7D0) // CommonScript_CompletePhoneOutgoingCall

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
void CompletePhone_CountBikeStep(SaveData *saveData); // a step on the bike (src/player_move.c)
void CompletePhone_SetSafariAreas(SaveData *saveData, const u8 *areas, int count); // Baoba's call about them
BOOL CompletePhone_CheckCallTrigger(SaveData *saveData, u8 trigger);

// A call the player places on the Pokégear: the field makes it as the player stands still
// (CompletePhone_TryOutgoingCall)
void CompletePhone_RequestCall(u8 contact);
u8 CompletePhone_TakeRequestedCall(void); // PHONE_CONTACT_NONE for none

// A call coming in rings (HeartGold's GearPhoneRingManager) until the player answers it on the Pokégear (its Phone
// button) or, after HeartGold's 59 seconds, it stops: the call, as CompletePhone_TryIncomingCall chose it, waits here
// (the field's overlay may be reloaded in between), and the field makes it as the player stands still.
typedef struct CompletePhoneRing {
    u8 contact;
    u8 kind;
    u16 predefined;
    u8 trigger;
    u8 group;
    u8 candidates;
} CompletePhoneRing;

void CompletePhone_StartRinging(const CompletePhoneRing *call);
BOOL CompletePhone_IsRinging(void); // or answered, until the field takes the call
void CompletePhone_Answer(void); // the Pokégear: the player answered
BOOL CompletePhone_TakeAnswer(CompletePhoneRing *call); // the field: the call answered, once
void CompletePhone_UpdateRinging(void); // each frame the field runs: the ring, and HeartGold's limit

// The minutes since the last call (HeartGold's ring manager's, which isn't saved either)
void CompletePhone_AddMinutes(int minutes);
u16 CompletePhone_MinutesSinceCall(void);
void CompletePhone_ResetCallTimer(void);

// src/overlay006/complete_phone_calls.c (loaded with the field)
u8 CompletePhone_ContactForTrainer(u16 trainerID);
u16 CompletePhone_GetRematchTrainer(SaveData *saveData, u8 contact);
BOOL CompletePhone_TryIncomingCall(FieldSystem *fieldSystem);
BOOL CompletePhone_TryOutgoingCall(FieldSystem *fieldSystem);

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
BOOL CompleteScrCmd_PhoneCallMenu(ScriptContext *ctx);
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
extern u8 gCompleteTestPhoneCallee;
extern u8 gCompleteTestPhoneRing; // the contact + 1 whose call rings at the next step

#endif

#endif // POKEPLATINUM_COMPLETE_PHONE_H
