#include <nitro.h>

#include "constants/heap.h"
#include "constants/menu.h"
#include "constants/narc.h"
#include "constants/string.h"
#include "generated/genders.h"
#include "generated/items.h"
#include "generated/map_headers.h"
#include "generated/species.h"
#include "generated/time_of_day.h"
#include "generated/text_banks.h"
#include "generated/trainers.h"
#include "generated/vars_flags.h"

#include "field/field_system.h"
#include "overlay005/daycare.h"
#include "overlay005/field_menu.h"
#include "overlay005/script_message.h"
#include "res/sound/pl_sound_data.naix"
#include "struct_defs/trainer.h"
#include "struct_defs/trainer_data.h"

#include "complete_badges.h"
#include "complete_bug_contest.h"
#include "complete_encounters.h"
#include "complete_map_info.h"
#include "complete_phone.h"
#include "complete_pokedex.h"
#include "complete_safari.h"
#include "complete_trainers.h"
#include "daycare_save.h"
#include "field_message.h"
#include "field_script_context.h"
#include "heap.h"
#include "inlines.h"
#include "map_header.h"
#include "math_util.h"
#include "message.h"
#include "message_util.h"
#include "pc_boxes.h"
#include "pokedex.h"
#include "rtc.h"
#include "save_player.h"
#include "scrcmd.h"
#include "script_manager.h"
#include "sound_playback.h"
#include "string_gf.h"
#include "string_template.h"
#include "trainer_data.h"
#include "trainer_info.h"
#include "vars_flags.h"

// Sovereign Complete: HeartGold's phone book, rematches and calls (include/complete_phone.h). The data is
// include/data/hgss_phone.h (tools/complete/import_hgss_phone.py).

typedef struct CompletePhoneBookEntry {
    u8 type; // PHONECALLTYPE_*
    u8 greeting; // a row of sGreetings, or 0xFF: none
    u8 rematchWeekday;
    u8 rematchTimeOfDay;
    u8 group; // of random callers
    u8 fishing; // a Fisherman, who talks about Pokémon on the hook
    u16 trainerID;
    u16 mapHeaderID; // where they are
    u16 gift; // given after a rematch
    u16 localScript; // the call when the player is on their map
    u16 textBank;
} CompletePhoneBookEntry;

typedef struct CompletePhoneScript {
    u8 messages[2]; // a boy's and a girl's, in the caller's bank
    u8 type; // PHONESCRIPTTYPE_*
    u16 param0;
    u16 param1;
} CompletePhoneScript;

typedef struct CompletePhoneCheck {
    u8 type; // PHONECALLGENERIC_*
    u8 chance;
    u16 handler;
    u16 script;
} CompletePhoneCheck;

#include "data/hgss_phone.h"

#define HGSS_REMATCH_GROUP_FLAG(group) (COMPLETE_FLAGS_START + 0x97B + (group)) // HeartGold's FLAG_UNK_97B on
#define REMATCH_TEAMS                  6

// The contact whose trainer is trainerID: their base trainer or one of their rematch teams; PHONE_CONTACT_NONE if none
u8 CompletePhone_ContactForTrainer(u16 trainerID)
{
    u16 base = trainerID;

    for (int set = 0; set < NELEMS(sRematchSets) && base == trainerID; set++) {
        for (int i = 1; i < REMATCH_TEAMS; i++) {
            if (sRematchSets[set][i] == trainerID) {
                base = sRematchSets[set][0];
                break;
            }
        }
    }

    for (int contact = 0; contact < NUM_PHONE_CONTACTS; contact++) {
        if (sPhoneBook[contact].trainerID != TRAINER_NONE
            && (sPhoneBook[contact].trainerID == base || sPhoneBook[contact].trainerID == trainerID)) {
            return contact;
        }
    }

    return PHONE_CONTACT_NONE;
}

static BOOL HasBeaten(VarsFlags *varsFlags, u16 trainerID)
{
    return VarsFlags_CheckFlag(varsFlags, Trainer_DefeatedFlag(trainerID));
}

// HeartGold's TryGetRematchTrainerIdByBaseTrainerId: the first team of the set not yet beaten, held back to the last
// one unlocked (its rematch group's flag)
static u16 RematchTrainer(SaveData *saveData, u16 baseTrainer)
{
    VarsFlags *varsFlags = SaveData_GetVarsFlags(saveData);
    int set, team;

    for (set = 0; set < NELEMS(sRematchSets); set++) {
        if (sRematchSets[set][0] == baseTrainer) {
            break;
        }
    }

    if (set == NELEMS(sRematchSets)) {
        return TRAINER_NONE;
    }

    for (team = 1; team < REMATCH_TEAMS; team++) {
        if (sRematchSets[set][team] == TRAINER_NONE) {
            team--;
            break;
        }

        if (!HasBeaten(varsFlags, sRematchSets[set][team])) {
            break;
        }
    }

    if (team == REMATCH_TEAMS) {
        team--;
    }

    if (team != 0 && !VarsFlags_CheckFlag(varsFlags, HGSS_REMATCH_GROUP_FLAG(team))) {
        team--;
    }

    return sRematchSets[set][team];
}

// HeartGold's PhoneBookTrainerGetRematchInfo: the team to fight when the contact wants a rematch, else TRAINER_NONE
// (Kenji only by day)
u16 CompletePhone_GetRematchTrainer(SaveData *saveData, u8 contact)
{
    if (contact >= NUM_PHONE_CONTACTS || !SaveData_GetCompletePhone(saveData)->rematches[contact].seeking) {
        return TRAINER_NONE;
    }

    if (contact == PHONE_CONTACT_KENJI) {
        enum TimeOfDay time = GetTimeOfDay();

        if (time != TIMEOFDAY_DAY && time != TIMEOFDAY_TWILIGHT) {
            return TRAINER_NONE;
        }
    }

    return RematchTrainer(saveData, sPhoneBook[contact].trainerID);
}

// HeartGold's RegisterGearNumber
BOOL CompleteScrCmd_PhoneRegister(ScriptContext *ctx)
{
    CompletePhone_Register(ctx->fieldSystem->saveData, ScriptContext_GetVar(ctx));
    return FALSE;
}

// HeartGold's CheckRegisteredPhoneNumber
BOOL CompleteScrCmd_PhoneCheckRegistered(ScriptContext *ctx)
{
    u16 contact = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = contact < NUM_PHONE_CONTACTS && CompletePhone_IsRegistered(ctx->fieldSystem->saveData, contact);
    return FALSE;
}

// HeartGold's GetPhoneBookRematch
BOOL CompleteScrCmd_PhoneGetRematch(ScriptContext *ctx)
{
    u16 contact = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = CompletePhone_GetRematchTrainer(ctx->fieldSystem->saveData, contact);
    return FALSE;
}

// HeartGold's ScrCmd_462: the rematch is fought
BOOL CompleteScrCmd_PhoneEndRematch(ScriptContext *ctx)
{
    u16 contact = ScriptContext_GetVar(ctx);

    if (contact < NUM_PHONE_CONTACTS) {
        SaveData_GetCompletePhone(ctx->fieldSystem->saveData)->rematches[contact].seeking = FALSE;
    }

    return FALSE;
}

// HeartGold's LoadPhoneDat: the contact for a trainer
BOOL CompleteScrCmd_PhoneLoadContact(ScriptContext *ctx)
{
    u16 trainerID = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = CompletePhone_ContactForTrainer(trainerID);
    return FALSE;
}

// HeartGold's GetPhoneContactMsgIds: what a phone trainer says in person, in their bank: asking for the player's number
// after the first battle (0), registered (1), turned down (2), asking again (3) and handing over a gift (4)
BOOL CompleteScrCmd_PhoneContactMessage(ScriptContext *ctx)
{
    u16 contact = ScriptContext_GetVar(ctx);
    u8 kind = ScriptContext_ReadByte(ctx);
    u16 *bankVar = ScriptContext_GetVarPointer(ctx);
    u16 *messageVar = ScriptContext_GetVarPointer(ctx);

    if (contact >= NUM_PHONE_CONTACTS) {
        *bankVar = TEXT_BANK_HGSS_MSG_0040;
        *messageVar = 0;
        return FALSE;
    }

    *bankVar = sPhoneBook[contact].textBank;
    *messageVar = (kind > 4 ? 0 : kind) + 1;
    return FALSE;
}

// HeartGold's GetPhoneContactGiftItem: the gift a call said the contact is keeping for the player, given now
BOOL CompleteScrCmd_PhoneTakeGift(ScriptContext *ctx)
{
    u16 contact = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = ITEM_NONE;

    if (contact < NUM_PHONE_CONTACTS) {
        CompletePhoneRematch *rematch = &SaveData_GetCompletePhone(ctx->fieldSystem->saveData)->rematches[contact];

        *destVar = rematch->giftItem;
        rematch->giftItem = ITEM_NONE;
    }

    return FALSE;
}

// HeartGold's GetPhoneContactRandomGiftBerry: what the contact gives after a rematch (a Cheri Berry: one of the ten
// first Berries)
BOOL CompleteScrCmd_PhoneRematchGift(ScriptContext *ctx)
{
    u16 contact = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = contact < NUM_PHONE_CONTACTS ? sPhoneBook[contact].gift : ITEM_NONE;

    if (*destVar == ITEM_CHERI_BERRY) {
        *destVar = ITEM_CHERI_BERRY + LCRNG_RandMod(10);
    }

    return FALSE;
}

// Calls: HeartGold's phone app's call engine (src/application/pokegear/phone), shown in the field's message box. A
// call is the scripts' loop over CompleteScrCmd_PhoneCallMessage, which prints the call's next message (and asks yes
// or no where HeartGold's call does) until there are none.

enum CallKind {
    CALL_OUTGOING = 0,
    CALL_INCOMING,
    CALL_SCRIPTED, // a map script's (HeartGold's PhoneCall: its isScriptedCall 2)
    CALL_TRIGGERED, // a call trigger's (its isScriptedCall 3)
};

enum CallStep {
    CALL_STEP_END = 0,
    CALL_STEP_MESSAGE,
    CALL_STEP_QUESTION, // a message, then yes or no (CompleteScrCmd_PhoneCallAnswer)
    CALL_STEP_CHOICE, // a message, then a menu of the phone's choices (CompleteScrCmd_PhoneCallMenu), the pick answered
    CALL_STEP_OUT_OF_AREA, // CompleteScrCmd_PhoneCallStart's answer for a call the player can't place here
};

enum HGSSTimeOfDay {
    HGSS_MORNING = 0,
    HGSS_DAY,
    HGSS_NIGHT,
};

enum CallHandler {
    HANDLER_SIMPLE = 0,
    HANDLER_GENERIC,
    HANDLER_GENERIC2,
    HANDLER_BILL,
    HANDLER_MOTHER,
    HANDLER_OAK,
    HANDLER_DAY_CARE_LADY,
    HANDLER_DAY_CARE_MAN,
    HANDLER_BUENA,
    HANDLER_BUENA2,
    HANDLER_FRIEND,
    HANDLER_FRIEND2,
    HANDLER_KURT,
    HANDLER_GYM_LEADER_OUTGOING,
    HANDLER_GYM_LEADER_INCOMING,
    HANDLER_BAOBA,
};

#define GREETING_NONE     0xFF
#define CALL_GROUPS       3
#define CALL_STEP_DONE    100 // a handler's step past its last
#define MIN_CALL_MINUTES  10 // HeartGold's ring manager: a call at most every ten minutes
#define RANDOM_CALL_ODDS  50 // and then half the time

typedef struct CompletePhoneCall {
    StringTemplate *template;
    u16 script;
    u16 predefined;
    u16 bank;
    u16 message;
    u8 contact;
    u8 kind;
    u8 handler;
    u8 step;
    u8 gender;
    u8 timeOfDay;
    u8 hour;
    u8 weekday;
    u8 count;
    u8 flag;
    u8 answer;
    u8 group;
    u8 candidates;
    u8 trigger;
    u8 menuFirst; // the choices of a CALL_STEP_CHOICE: their first message in HeartGold's phone app's bank (0271)
    u8 menuCount;
    u8 fanfare; // the last message waits for a fanfare
} CompletePhoneCall;

static CompletePhoneCall sCall;

// HeartGold's call triggers (overlay 2's ov02_02253C84): who calls, and with which call script
// who calls, with which call script, and whether the call comes through at once (HeartGold's forcePickUp) rather than
// ringing until the player answers
static const struct {
    u8 contact;
    u16 script;
    u8 forced;
} sCallTriggers[NUM_CALL_TRIGGERS] = {
    { PHONE_CONTACT_PROF__ELM, 13, FALSE }, // the Egg hatched
    { PHONE_CONTACT_PROF__ELM, 7, FALSE }, // Pokérus
    { PHONE_CONTACT_BIKE_SHOP, 85, TRUE },
    { PHONE_CONTACT_BILL, 93, TRUE }, // the boxes are full
    { PHONE_CONTACT_PROF__OAK, 0, FALSE },
    { PHONE_CONTACT_DAY_C_MAN, 0, FALSE },
    { PHONE_CONTACT_BAOBA, 0, FALSE },
    { PHONE_CONTACT_BAOBA, 142, TRUE }, // the Safari Zone's next test
    { PHONE_CONTACT_BAOBA, 143, TRUE }, // object arrangement
    { PHONE_CONTACT_BAOBA, 144, TRUE }, // new objects
    { PHONE_CONTACT_BAOBA, 145, TRUE }, // many objects
    { PHONE_CONTACT_BAOBA, 146, TRUE }, // a time loop
    { PHONE_CONTACT_MOTHER, 27, FALSE }, // Mom bought something with the player's money
};

// Elm's calls from map scripts: the panic call, the Egg, the radio, and two "come to the lab"
static const u16 sElmScriptedCalls[] = { 2, 3, 4, 5, 6 };

// HeartGold's ov101_021F8760: which of the four kinds of place each of Ethan's or Lyra's 73 place stories is about (0:
// Johto, 1: the Safari Zone, 2: the Indigo League's routes, 3: Kanto)
static const u8 sFriendPlaceKinds[73] = {
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
};

static BOOL PhoneCheckFlag(FieldSystem *fieldSystem, u16 flag)
{
    return VarsFlags_CheckFlag(SaveData_GetVarsFlags(fieldSystem->saveData), flag);
}

static void PhoneSetFlag(FieldSystem *fieldSystem, u16 flag, BOOL set)
{
    if (set) {
        VarsFlags_SetFlag(SaveData_GetVarsFlags(fieldSystem->saveData), flag);
    } else {
        VarsFlags_ClearFlag(SaveData_GetVarsFlags(fieldSystem->saveData), flag);
    }
}

// HeartGold's Save_VarsFlags_IsInRocketTakeover: Team Rocket holds Goldenrod's Radio Tower
static BOOL InRocketTakeover(FieldSystem *fieldSystem)
{
    u16 scene = *FieldSystem_GetVarPointer(fieldSystem, VAR_HGSS_SCENE_ROCKET_TAKEOVER);
    return scene >= 2 && scene <= 4;
}

static CompletePhoneRematch *Rematch(FieldSystem *fieldSystem, u8 contact)
{
    return &SaveData_GetCompletePhone(fieldSystem->saveData)->rematches[contact];
}

// A Pokémon of the trainer's team, at random (HeartGold's getRandomTrainerMon)
static u16 RandomTrainerSpecies(u16 trainerID)
{
    static const u8 sMonSizes[] = {
        [TRDATATYPE_BASE] = sizeof(TrainerMonBase),
        [TRDATATYPE_WITH_MOVES] = sizeof(TrainerMonWithMoves),
        [TRDATATYPE_WITH_ITEM] = sizeof(TrainerMonWithItem),
        [TRDATATYPE_WITH_MOVES_AND_ITEM] = sizeof(TrainerMonWithMovesAndItem),
        [TRDATATYPE_SOVEREIGN] = sizeof(TrainerMonSovereign),
    };
    Trainer trainer;

    Trainer_Load(trainerID, &trainer);

    if (trainer.header.partySize == 0 || trainer.header.monDataType >= NELEMS(sMonSizes)) {
        return SPECIES_RATTATA;
    }

    u8 *party = Heap_AllocAtEnd(HEAP_ID_FIELD3, TRAINER_PARTY_BUFFER_SIZE);
    Trainer_LoadParty(trainerID, party);

    // the species is the third field in every layout
    u16 species = ((u16 *)(party + sMonSizes[trainer.header.monDataType] * LCRNG_RandMod(trainer.header.partySize)))[2];

    Heap_Free(party);
    return species & TRAINER_MON_SPECIES_MASK;
}

static void SetSpeciesName(StringTemplate *template, u32 idx, u16 species)
{
    String *name = MessageUtil_SpeciesName(species, HEAP_ID_FIELD3);

    StringTemplate_SetString(template, idx, name, 0, TRUE, GAME_LANGUAGE);
    String_Free(name);
}

// HeartGold's PhoneCall_InitMsgDataAndBufferNames: the player (0), the caller (1), where the player is (2) and where
// the caller is (3)
static void BufferNames(FieldSystem *fieldSystem)
{
    const CompletePhoneBookEntry *entry = &sPhoneBook[sCall.contact];
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, entry->textBank, HEAP_ID_FIELD3);
    String *name = MessageLoader_GetNewString(loader, 0);

    StringTemplate_SetPlayerName(sCall.template, 0, SaveData_GetTrainerInfo(fieldSystem->saveData));
    StringTemplate_SetString(sCall.template, 1, name, 0, TRUE, GAME_LANGUAGE);
    StringTemplate_SetLocationName(sCall.template, 2, MapHeader_GetMapLabelTextID(fieldSystem->location->mapHeaderID));
    StringTemplate_SetLocationName(sCall.template, 3, MapHeader_GetMapLabelTextID(entry->mapHeaderID));
    String_Free(name);
    MessageLoader_Free(loader);
}

// HeartGold's PhoneCall_ApplyGenericNPCcallSideEffect
static void ApplyScriptEffect(FieldSystem *fieldSystem, const CompletePhoneScript *script)
{
    u16 item;

    switch (script->type) {
    case PHONESCRIPTTYPE_REMATCH:
        Rematch(fieldSystem, sCall.contact)->seeking = TRUE;
        break;
    case PHONESCRIPTTYPE_ITEM:
        item = script->param1;

        if (item == ITEM_CHERI_BERRY) {
            item = ITEM_CHERI_BERRY + MTRNG_Next() % 10;
        } else if (item == ITEM_POKE_BALL) {
            item = ITEM_ULTRA_BALL + MTRNG_Next() % 3;
        }

        Rematch(fieldSystem, sCall.contact)->giftItem = item;
        break;
    case PHONESCRIPTTYPE_UNK1:
    case PHONESCRIPTTYPE_FLAG:
        PhoneSetFlag(fieldSystem, script->param1, script->param0);
        break;
    case PHONESCRIPTTYPE_WORD: {
        MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, sPhoneBook[sCall.contact].textBank, HEAP_ID_FIELD3);
        String *word = MessageLoader_GetNewString(loader, script->param1 + LCRNG_RandMod(script->param0));

        StringTemplate_SetString(sCall.template, 4, word, 0, TRUE, GAME_LANGUAGE);
        String_Free(word);
        MessageLoader_Free(loader);
        break;
    }
    }
}

static enum CallStep Say(u16 bank, u16 message)
{
    sCall.bank = bank;
    sCall.message = message;
    return CALL_STEP_MESSAGE;
}

static enum CallStep SayContact(u16 message)
{
    return Say(sPhoneBook[sCall.contact].textBank, message);
}

static enum CallStep SayGendered(u16 boy, u16 girl)
{
    return SayContact(sCall.gender == GENDER_MALE ? boy : girl);
}

// HeartGold's PhoneCall_PrintGreeting: by the caller's kind of greeting, the time of day, who called and the player
static enum CallStep SayGreeting(void)
{
    const u8 *greetings = sGreetings[sPhoneBook[sCall.contact].greeting];

    return Say(TEXT_BANK_HGSS_MSG_0640, greetings[sCall.timeOfDay * 2 + (sCall.kind != CALL_OUTGOING) * 6 + (sCall.gender != GENDER_MALE)]);
}

// HeartGold's GearPhoneCall_Simple and GearPhoneCall_Generic (which also names a Pokémon of the caller's team and one
// of the wild ones where they are): a greeting, if they have one, then the call script's message
static enum CallStep Call_Simple(FieldSystem *fieldSystem)
{
    const CompletePhoneScript *script = &sPhoneScripts[sCall.script];

    switch (sCall.step++) {
    case 0:
        ApplyScriptEffect(fieldSystem, script);

        if (sCall.handler == HANDLER_GENERIC) {
            const CompletePhoneBookEntry *entry = &sPhoneBook[sCall.contact];

            SetSpeciesName(sCall.template, 10, RandomTrainerSpecies(entry->trainerID));
            SetSpeciesName(sCall.template, 11, CompleteEncounters_RandomSpecies(entry->mapHeaderID, entry->fishing, sCall.timeOfDay));
        }

        if (sPhoneBook[sCall.contact].greeting != GREETING_NONE) {
            return SayGreeting();
        }

        sCall.step++;
        // fall through
    case 1:
        return SayGendered(script->messages[0], script->messages[1]);
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_Generic2: a greeting, then one of eleven messages from the call script's on
static enum CallStep Call_Generic2(FieldSystem *fieldSystem)
{
    const CompletePhoneScript *script = &sPhoneScripts[sCall.script];
    int n;

    switch (sCall.step++) {
    case 0:
        ApplyScriptEffect(fieldSystem, script);

        if (sPhoneBook[sCall.contact].greeting != GREETING_NONE) {
            return SayGreeting();
        }

        sCall.step++;
        // fall through
    case 1:
        n = LCRNG_RandMod(11);

        if (script->messages[0] == script->messages[1]) {
            return SayContact(script->messages[0] + n);
        }

        return SayGendered(script->messages[0] + n * 2, script->messages[1] + n * 2 + 1);
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_Mother: whether to save money (her savings: FLAG_HGSS_SYS_MOMS_SAVINGS), after a word on
// where the player is when they call her; on Route 30, her call (a map script's) asks at once
static enum CallStep Call_Mother(FieldSystem *fieldSystem)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(fieldSystem->saveData);

    switch (sCall.step++) {
    case 0:
        StringTemplate_SetNumber(sCall.template, 10, phone->momsSavings, 6, PADDING_MODE_NONE, CHARSET_MODE_EN);

        if (sCall.kind != CALL_SCRIPTED) {
            return SayContact(7 + MapHeader_GetMomCallIntroParam(fieldSystem->location->mapHeaderID));
        }

        sCall.step++;
        // fall through
    case 1:
        if (sCall.kind == CALL_SCRIPTED) {
            SayContact(22);
        } else if (phone->momGiftQueue[NELEMS(phone->momGiftQueue) - 1][1] != 0) { // her list of gifts to buy is full
            sCall.step = CALL_STEP_DONE;
            return SayContact(21);
        } else if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_SYS_MOMS_SAVINGS)) {
            SayContact(phone->momsSavings != 0 ? 23 : 27);
        } else {
            SayContact(phone->momsSavings != 0 ? 24 : 28);
        }

        return CALL_STEP_QUESTION;
    case 2:
        PhoneSetFlag(fieldSystem, FLAG_HGSS_SYS_MOMS_SAVINGS, sCall.answer == MENU_YES);
        return SayContact(sCall.answer == MENU_YES ? 25 : 26);
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_Buena2: her greeting by the time of day, then a password show story
static enum CallStep Call_Buena(FieldSystem *fieldSystem)
{
    switch (sCall.step++) {
    case 0:
        return SayGendered(15 + sCall.timeOfDay * 2, 16 + sCall.timeOfDay * 2);
    case 1:
        if (sCall.count == 3) { // her show is on the air
            return SayContact(36);
        } else {
            int n = LCRNG_RandMod(11 + PhoneCheckFlag(fieldSystem, FLAG_HGSS_GAME_CLEAR) * 3);

            return n == 13 ? SayGendered(34, 35) : SayContact(21 + n);
        }
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_EthanLyra2: the friend's greeting, then news, or a story about a place the player can have
// been (here Johto's always, the Indigo League's routes after eight of Johto's badges and Kanto's after the League,
// as the Pokégear's map would show them; the Safari Zone's when HeartGold's fly point flag for it is set)
static enum CallStep Call_Friend(FieldSystem *fieldSystem)
{
    switch (sCall.step++) {
    case 0:
        return SayContact(7 + sCall.timeOfDay);
    case 1:
        if (LCRNG_RandMod(1000) < 500) {
            return SayContact(10 + LCRNG_RandMod(900) / 300);
        } else {
            TrainerInfo *info = SaveData_GetTrainerInfo(fieldSystem->saveData);
            BOOL kinds[4] = { TRUE, PhoneCheckFlag(fieldSystem, FLAG_HGSS_UNK_9C9), CompleteBadges_Count(info) >= 8, PhoneCheckFlag(fieldSystem, FLAG_HGSS_GAME_CLEAR) };
            u8 places[NELEMS(sFriendPlaceKinds)];
            int count = 0;

            for (int i = 0; i < NELEMS(sFriendPlaceKinds); i++) {
                if (kinds[sFriendPlaceKinds[i]]) {
                    places[count++] = i;
                }
            }

            return SayContact(86 + places[LCRNG_RandMod(count)]);
        }
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_GymLeader_Incoming
static enum CallStep Call_GymLeader(FieldSystem *fieldSystem)
{
    switch (sCall.step++) {
    case 0:
        return SayContact(10);
    case 1:
        return Rematch(fieldSystem, sCall.contact)->seeking ? SayContact(11) : SayContact(12 + LCRNG_RandMod(3));
    default:
        return CALL_STEP_END;
    }
}

// The calls the player makes (HeartGold's phone app's outgoing calls), the ones with their own handler

// HeartGold's GearPhoneCall_Bill: how much room is left in the PC's boxes, and the box the player is using
static enum CallStep Call_Bill(FieldSystem *fieldSystem)
{
    PCBoxes *boxes = SaveData_GetPCBoxes(fieldSystem->saveData);
    String *name;
    int empty;

    switch (sCall.step++) {
    case 0:
        if (sPhoneBook[sCall.contact].greeting != GREETING_NONE) {
            return SayGreeting();
        }

        sCall.step++;
        // fall through
    case 1:
        return SayGendered(3, 4);
    case 2:
        name = String_Init(PC_BOX_NAME_BUFFER_LEN, HEAP_ID_FIELD3);
        PCBoxes_BufferBoxName(boxes, PCBoxes_GetCurrentBoxID(boxes), name);
        StringTemplate_SetString(sCall.template, 10, name, 0, TRUE, GAME_LANGUAGE);
        String_Free(name);

        empty = MAX_PC_BOXES * MAX_MONS_PER_BOX;

        for (int i = 0; i < MAX_PC_BOXES; i++) {
            empty -= PCBoxes_CountMonsInBox(boxes, i);
        }

        StringTemplate_SetNumber(sCall.template, 11, empty, 3, PADDING_MODE_NONE, CHARSET_MODE_EN);
        return SayContact(empty == 0 ? 9 : 5 + LCRNG_RandMod(3));
    case 3:
        return SayContact(8);
    default:
        return CALL_STEP_END;
    }
}

// The Johto Pokédex's species seen and caught (Mew and Celebi, its event Pokémon, aside for Oak's rating)
static void CountJohtoDex(Pokedex *pokedex, u16 *seen, u16 *caught, u16 *caughtForRating)
{
    const u16 *johtoDex = CompletePokedex_JohtoList();

    *seen = *caught = *caughtForRating = 0;

    for (int i = 0; i < JOHTO_DEX_COUNT; i++) {
        *seen += Pokedex_HasSeenSpecies(pokedex, johtoDex[i]);

        if (Pokedex_HasCaughtSpecies(pokedex, johtoDex[i])) {
            (*caught)++;
            *caughtForRating += CompletePokedex_CountsForJohtoGoal(johtoDex[i]);
        }
    }
}

// HeartGold's GetOakJohtoDexRating and GetOakNationalDexRating: Oak's word on the Pokémon caught, and its fanfare
static u16 OakRating(BOOL national, u16 caught, BOOL complete, u16 *fanfare)
{
    static const u16 sJohtoTiers[] = { 9, 19, 34, 49, 64, 79, 94, 109, 124, 139, 154, 169, 184, 199, 214, 229, 244, 253 };
    static const u16 sNationalTiers[] = { 100, 150, 200, 250, 300, 350, 400, 435, 465, 475, 483 };
    const u16 *tiers = national ? sNationalTiers : sJohtoTiers;
    int count = national ? NELEMS(sNationalTiers) : NELEMS(sJohtoTiers);

    *fanfare = SEQ_ME_HYOUKA1_sseq;

    if (!complete) {
        for (int i = 0; i < count; i++) {
            if (caught <= tiers[i]) {
                return (national ? 46 : 28) + i;
            }
        }

        return national ? 56 : 45; // past the last tier, with one still to catch
    }

    *fanfare = SEQ_ME_HYOUKA6_sseq;
    return (national ? 24 : 22) + (sCall.gender != GENDER_MALE);
}

// HeartGold's GearPhoneCall_ProfOak: whether to have the Pokédex evaluated (Johto's before the National Pokédex; then
// Johto's and the National one, until Oak has seen Johto's complete; then the National one), the Pokémon seen and
// caught in it, and his rating, with its fanfare. Seeing one complete for the first time ends the call there.
static enum CallStep Call_Oak(FieldSystem *fieldSystem)
{
    static const u8 sMenus[3][2] = { { 10, 2 }, { 12, 3 }, { 15, 2 } }; // first choice, choices: bank 0271's
    Pokedex *pokedex = SaveData_GetPokedex(fieldSystem->saveData);
    u16 seen, caught, caughtForRating, message;
    BOOL complete;

    switch (sCall.step++) {
    case 0:
        return SayGendered(13, 14);
    case 1:
        if (!Pokedex_IsNationalDexObtained(pokedex)) {
            sCall.count = 0;
        } else {
            sCall.count = PhoneCheckFlag(fieldSystem, FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_JOHTO_DEX_COMPLETION) ? 2 : 1;
        }

        sCall.menuFirst = sMenus[sCall.count][0];
        sCall.menuCount = sMenus[sCall.count][1];
        SayContact(15);
        return CALL_STEP_CHOICE;
    case 2:
        if (sCall.answer == 0) {
            sCall.flag = sCall.count == 2; // the National Pokédex
        } else if (sCall.answer == 1 && sCall.count == 1) {
            sCall.flag = TRUE;
        } else {
            sCall.step = CALL_STEP_DONE;
            return SayContact(21);
        }

        if (sCall.flag) {
            seen = Pokedex_CountSeen_National(pokedex);
            caught = Pokedex_CountCaught_National(pokedex);
        } else {
            CountJohtoDex(pokedex, &seen, &caught, &caughtForRating);
        }

        StringTemplate_SetNumber(sCall.template, 5, seen, 3, PADDING_MODE_NONE, CHARSET_MODE_EN);
        StringTemplate_SetNumber(sCall.template, 6, caught, 3, PADDING_MODE_NONE, CHARSET_MODE_EN);
        return SayContact(20);
    case 3: {
        u16 fanfare;

        if (sCall.flag) {
            caughtForRating = Pokedex_NumCaught_National(pokedex);
            complete = Pokedex_NationalDexCompleted(pokedex);
        } else {
            CountJohtoDex(pokedex, &seen, &caught, &caughtForRating);
            complete = caughtForRating >= JOHTO_DEX_GOAL;
        }

        message = OakRating(sCall.flag, caughtForRating, complete, &fanfare);
        Sound_PlayFanfare(fanfare);
        sCall.fanfare = TRUE;

        if (complete) {
            PhoneSetFlag(fieldSystem, sCall.flag ? FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION : FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_JOHTO_DEX_COMPLETION, TRUE);
            sCall.step = CALL_STEP_DONE;
        }

        return SayContact(message);
    }
    case 4:
        sCall.fanfare = FALSE;
        return SayContact(21);
    default:
        return CALL_STEP_END;
    }
}

// The levels a Pokémon at the Day-Care has grown there (HeartGold's DaycareMon_CalcLevelGrowth), 0 for none there
static int DaycareLevelGrowth(Daycare *daycare, int slot)
{
    DaycareMon *daycareMon = Daycare_GetDaycareMon(daycare, slot);
    BoxPokemon *boxMon = DaycareMon_GetBoxMon(daycareMon);

    if (BoxPokemon_GetValue(boxMon, MON_DATA_SPECIES, NULL) == SPECIES_NONE) {
        return 0;
    }

    return BoxPokemon_GiveExperience(boxMon, DaycareMon_GetSteps(daycareMon)) - BoxPokemon_GetLevel(boxMon); // on a copy
}

static enum CallStep SayDaycareGrowth(Daycare *daycare, int slot)
{
    StringTemplate_SetNickname(sCall.template, 10, DaycareMon_GetBoxMon(Daycare_GetDaycareMon(daycare, slot)));
    StringTemplate_SetNumber(sCall.template, 11, DaycareLevelGrowth(daycare, slot), 3, PADDING_MODE_NONE, CHARSET_MODE_EN);
    return SayContact(6);
}

// HeartGold's GearPhoneCall_DayCareLady: how much the Pokémon left with her have grown
static enum CallStep Call_DayCareLady(FieldSystem *fieldSystem)
{
    Daycare *daycare = SaveData_GetDaycare(fieldSystem->saveData);
    int mons = Daycare_CountMons(daycare);

    switch (sCall.step++) {
    case 0:
        return SayGendered(3, 4);
    case 1:
        if (mons == 0) {
            sCall.step = CALL_STEP_DONE;
            return SayContact(10);
        }

        return SayContact(5);
    case 2:
        if (DaycareLevelGrowth(daycare, 0) != 0) {
            if (DaycareLevelGrowth(daycare, 1) == 0) {
                sCall.step = 4;
            }

            return SayDaycareGrowth(daycare, 0);
        }

        if (DaycareLevelGrowth(daycare, 1) != 0) {
            sCall.step = 4;
            return SayDaycareGrowth(daycare, 1);
        }

        sCall.step = CALL_STEP_DONE;
        return SayContact(9);
    case 3:
        return SayDaycareGrowth(daycare, 1);
    case 4:
        return SayContact(mons == 1 ? 8 : 9);
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_DayCareMan: an Egg, or the Pokémon left with the Day-Care and how well they get along
static enum CallStep Call_DayCareMan(FieldSystem *fieldSystem)
{
    Daycare *daycare = SaveData_GetDaycare(fieldSystem->saveData);
    int mons = 0;

    switch (sCall.step++) {
    case 0:
        for (int i = 0; i < NUM_DAYCARE_MONS; i++) {
            BoxPokemon *boxMon = DaycareMon_GetBoxMon(Daycare_GetDaycareMon(daycare, i));

            if (BoxPokemon_GetValue(boxMon, MON_DATA_SPECIES, NULL) != SPECIES_NONE) {
                StringTemplate_SetNickname(sCall.template, 10 + i, boxMon);
                mons++;
            }
        }

        sCall.count = mons;
        return SayContact(2);
    case 1:
        if (Daycare_HasEgg(daycare)) {
            sCall.step = CALL_STEP_DONE;
            return SayContact(3);
        }

        if (sCall.count < 2) {
            sCall.step = 3;
            return SayContact(sCall.count == 0 ? 4 : 5);
        }

        return SayContact(6);
    case 2:
        return SayContact(7 + Daycare_GetCompatibilityLevel(daycare));
    case 3:
        return SayContact(11);
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_Buena: her greeting by the time of day, then a word on her show
static enum CallStep Call_BuenaOutgoing(FieldSystem *fieldSystem)
{
    switch (sCall.step++) {
    case 0:
        return SayGendered(3 + sCall.timeOfDay * 2, 4 + sCall.timeOfDay * 2);
    case 1:
        return SayContact(10 + LCRNG_RandMod(3));
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's ov101_021F86CC: the places Ethan or Lyra has a story about when the player calls from there
static const u16 sFriendStoryPlaces[73] = {
    MAP_HEADER_HGSS_ROUTE_1,
    MAP_HEADER_HGSS_ROUTE_2,
    MAP_HEADER_HGSS_ROUTE_3,
    MAP_HEADER_HGSS_ROUTE_4,
    MAP_HEADER_HGSS_ROUTE_5,
    MAP_HEADER_HGSS_ROUTE_6,
    MAP_HEADER_HGSS_ROUTE_7,
    MAP_HEADER_HGSS_ROUTE_8,
    MAP_HEADER_HGSS_ROUTE_9,
    MAP_HEADER_HGSS_ROUTE_10,
    MAP_HEADER_HGSS_ROUTE_11,
    MAP_HEADER_HGSS_ROUTE_12,
    MAP_HEADER_HGSS_ROUTE_13,
    MAP_HEADER_HGSS_ROUTE_14,
    MAP_HEADER_HGSS_ROUTE_15,
    MAP_HEADER_HGSS_ROUTE_16,
    MAP_HEADER_HGSS_ROUTE_17,
    MAP_HEADER_HGSS_ROUTE_18,
    MAP_HEADER_HGSS_ROUTE_19,
    MAP_HEADER_HGSS_ROUTE_20,
    MAP_HEADER_HGSS_ROUTE_21,
    MAP_HEADER_HGSS_ROUTE_22,
    MAP_HEADER_HGSS_ROUTE_24,
    MAP_HEADER_HGSS_ROUTE_25,
    MAP_HEADER_HGSS_ROUTE_26,
    MAP_HEADER_HGSS_ROUTE_27,
    MAP_HEADER_HGSS_ROUTE_28,
    MAP_HEADER_HGSS_ROUTE_29,
    MAP_HEADER_HGSS_ROUTE_30,
    MAP_HEADER_HGSS_ROUTE_31,
    MAP_HEADER_HGSS_ROUTE_32,
    MAP_HEADER_HGSS_ROUTE_33,
    MAP_HEADER_HGSS_ROUTE_34,
    MAP_HEADER_HGSS_ROUTE_35,
    MAP_HEADER_HGSS_ROUTE_36,
    MAP_HEADER_HGSS_ROUTE_37,
    MAP_HEADER_HGSS_ROUTE_38,
    MAP_HEADER_HGSS_ROUTE_39,
    MAP_HEADER_HGSS_ROUTE_40,
    MAP_HEADER_HGSS_ROUTE_41,
    MAP_HEADER_HGSS_ROUTE_42,
    MAP_HEADER_HGSS_ROUTE_43,
    MAP_HEADER_HGSS_ROUTE_44,
    MAP_HEADER_HGSS_ROUTE_45,
    MAP_HEADER_HGSS_ROUTE_46,
    MAP_HEADER_HGSS_ROUTE_47,
    MAP_HEADER_HGSS_ROUTE_48,
    MAP_HEADER_HGSS_PALLET,
    MAP_HEADER_HGSS_VIRIDIAN,
    MAP_HEADER_HGSS_PEWTER,
    MAP_HEADER_HGSS_CERULEAN,
    MAP_HEADER_HGSS_LAVENDER,
    MAP_HEADER_HGSS_VERMILION,
    MAP_HEADER_HGSS_CELADON,
    MAP_HEADER_HGSS_FUCHSIA,
    MAP_HEADER_HGSS_CINNABAR_ISLAND,
    MAP_HEADER_HGSS_INDIGO_PLATEAU,
    MAP_HEADER_HGSS_SAFFRON,
    MAP_HEADER_HGSS_NEW_BARK,
    MAP_HEADER_HGSS_CHERRYGROVE,
    MAP_HEADER_HGSS_VIOLET,
    MAP_HEADER_HGSS_AZALEA,
    MAP_HEADER_HGSS_CIANWOOD,
    MAP_HEADER_HGSS_GOLDENROD,
    MAP_HEADER_HGSS_OLIVINE,
    MAP_HEADER_HGSS_ECRUTEAK,
    MAP_HEADER_HGSS_MAHOGANY,
    MAP_HEADER_HGSS_LAKE_OF_RAGE,
    MAP_HEADER_HGSS_BLACKTHORN,
    MAP_HEADER_HGSS_MOUNT_SILVER,
    MAP_HEADER_HGSS_NATIONAL_PARK,
    MAP_HEADER_HGSS_RUINS_OF_ALPH,
    MAP_HEADER_HGSS_SAFARI_ZONE_GATE,
};

// HeartGold's GearPhoneCall_EthanLyra and GearPhoneCall_GetEthanLyraMessage: the friend's greeting, then a story about
// where the player is. HeartGold picks it by the outdoor map the player is on or in; here by the place's name, which
// the buildings of a town or route share with it.
static enum CallStep Call_FriendOutgoing(FieldSystem *fieldSystem)
{
    u16 place = MapHeader_GetMapLabelTextID(fieldSystem->location->mapHeaderID);

    switch (sCall.step++) {
    case 0:
        return SayContact(4 + sCall.timeOfDay);
    case 1:
        for (int i = 0; i < NELEMS(sFriendStoryPlaces); i++) {
            if (MapHeader_GetMapLabelTextID(sFriendStoryPlaces[i]) == place) {
                return SayContact(13 + i);
            }
        }

        return SayContact(10 + LCRNG_RandMod(3));
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_Kurt: the Balls he's making from the player's Apricorns (src/complete_apricorns.c)
static enum CallStep Call_Kurt(FieldSystem *fieldSystem)
{
    u16 quantity = *FieldSystem_GetVarPointer(fieldSystem, VAR_COMPLETE_KURT_QUANTITY);

    switch (sCall.step++) {
    case 0:
        return SayContact(PhoneCheckFlag(fieldSystem, FLAG_HGSS_UNK_127) ? 6 : 2);
    case 1:
        if (quantity == 0) {
            return SayContact(5);
        }

        if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_DAILY_KURT_MAKING_BALLS)) {
            return SayContact(4);
        }

        StringTemplate_SetItemName(sCall.template, 10, *FieldSystem_GetVarPointer(fieldSystem, VAR_COMPLETE_KURT_BALL));
        StringTemplate_SetNumber(sCall.template, 11, quantity, 2, PADDING_MODE_NONE, CHARSET_MODE_EN);
        return SayContact(3);
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_Baoba: which Safari Zone areas have new Pokémon since days passed (CompletePhone_SetSafariAreas),
// by name: none, one to five, or all of them
static enum CallStep Call_Baoba(FieldSystem *fieldSystem)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(fieldSystem->saveData);
    int count = phone->safariAreaCount;

    switch (sCall.step++) {
    case 0:
        if (count == 0) {
            return SayGendered(38, 39);
        }

        if (count >= SAFARI_ZONE_AREAS_PER_SET) {
            return SayGendered(24, 25);
        }

        MessageLoader *names = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0428, HEAP_ID_FIELD3);

        for (int i = 0; i < count; i++) {
            String *name = MessageLoader_GetNewString(names, phone->safariAreas[i]);

            StringTemplate_SetString(sCall.template, 10 + i, name, 0, TRUE, GAME_LANGUAGE);
            String_Free(name);
        }

        MessageLoader_Free(names);
        return SayGendered(14 + 2 * (count - 1), 15 + 2 * (count - 1));
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's GearPhoneCall_GymLeader_Outgoing: after all sixteen badges, a rematch at the Fighting Dojo on the leader's
// day and time. (HeartGold's isDojoFull only counts Falkner, so the dojo is never too full: the rematch is set.)
static enum CallStep Call_GymLeaderOutgoing(FieldSystem *fieldSystem)
{
    const CompletePhoneBookEntry *entry = &sPhoneBook[sCall.contact];
    CompletePhoneRematch *rematch = Rematch(fieldSystem, sCall.contact);

    switch (sCall.step++) {
    case 0:
        if (entry->mapHeaderID == fieldSystem->location->mapHeaderID) {
            sCall.step = CALL_STEP_DONE;
            return SayContact(1);
        }

        return SayContact(2);
    case 1:
        sCall.step = CALL_STEP_DONE;

        if (CompleteBadges_Count(SaveData_GetTrainerInfo(fieldSystem->saveData)) < 16) {
            return SayContact(3);
        }

        if (rematch->seeking) {
            return SayContact(9);
        }

        if (sCall.weekday != entry->rematchWeekday || sCall.timeOfDay != entry->rematchTimeOfDay) {
            return SayContact(4);
        }

        sCall.step = 2;
        SayContact(5);
        return CALL_STEP_QUESTION;
    case 2:
        if (sCall.answer != MENU_YES) {
            return SayContact(7);
        }

        rematch->seeking = TRUE;
        return SayContact(6);
    default:
        return CALL_STEP_END;
    }
}

static enum CallStep NextStep(FieldSystem *fieldSystem)
{
    switch (sCall.handler) {
    case HANDLER_SIMPLE:
    case HANDLER_GENERIC:
        return Call_Simple(fieldSystem);
    case HANDLER_GENERIC2:
        return Call_Generic2(fieldSystem);
    case HANDLER_MOTHER:
        return Call_Mother(fieldSystem);
    case HANDLER_BUENA2:
        return Call_Buena(fieldSystem);
    case HANDLER_FRIEND2:
        return Call_Friend(fieldSystem);
    case HANDLER_GYM_LEADER_INCOMING:
        return Call_GymLeader(fieldSystem);
    case HANDLER_BILL:
        return Call_Bill(fieldSystem);
    case HANDLER_OAK:
        return Call_Oak(fieldSystem);
    case HANDLER_DAY_CARE_LADY:
        return Call_DayCareLady(fieldSystem);
    case HANDLER_DAY_CARE_MAN:
        return Call_DayCareMan(fieldSystem);
    case HANDLER_BUENA:
        return Call_BuenaOutgoing(fieldSystem);
    case HANDLER_FRIEND:
        return Call_FriendOutgoing(fieldSystem);
    case HANDLER_KURT:
        return Call_Kurt(fieldSystem);
    case HANDLER_GYM_LEADER_OUTGOING:
        return Call_GymLeaderOutgoing(fieldSystem);
    case HANDLER_BAOBA:
        return Call_Baoba(fieldSystem);
    default:
        return CALL_STEP_END;
    }
}

// HeartGold's PhoneScriptGeneric_GetScriptIdInternal and its checks: the first of a contact's eight that passes
static BOOL CheckPasses(FieldSystem *fieldSystem, const CompletePhoneCheck *check)
{
    const CompletePhoneBookEntry *entry = &sPhoneBook[sCall.contact];
    CompletePhoneRematch *rematch = Rematch(fieldSystem, sCall.contact);
    BOOL beatRockets = PhoneCheckFlag(fieldSystem, FLAG_HGSS_BEAT_RADIO_TOWER_ROCKETS);
    BOOL inContest = entry->mapHeaderID == MAP_HEADER_HGSS_NATIONAL_PARK && CompleteBugContest_IsRunning();

    switch (check->type) {
    case PHONECALLGENERIC_FIGHTPOSTROCKETS:
        if (rematch->seeking || rematch->giftItem != ITEM_NONE) {
            return FALSE;
        }

        if (!beatRockets && check->handler == HANDLER_SIMPLE && sPhoneScripts[check->script].type == PHONESCRIPTTYPE_REMATCH) {
            return FALSE;
        }

        break;
    case PHONECALLGENERIC_FIGHTPOSTROCKETSNOTBUGCONTEST:
        if (!beatRockets || inContest || !rematch->seeking) {
            return FALSE;
        }

        break;
    case PHONECALLGENERIC_GIFTNOTBUGCONTEST:
        if (inContest || rematch->giftItem == ITEM_NONE) {
            return FALSE;
        }

        break;
    case PHONECALLGENERIC_POSTROCKETWEEKTIME:
        if (!beatRockets || sCall.weekday != entry->rematchWeekday || sCall.timeOfDay != entry->rematchTimeOfDay) {
            return FALSE;
        }

        break;
    case PHONECALLGENERIC_BUGCONTESTDAYS:
        if (sCall.weekday != RTC_WEEK_TUESDAY && sCall.weekday != RTC_WEEK_THURSDAY && sCall.weekday != RTC_WEEK_SATURDAY) {
            return FALSE;
        }

        break;
    case PHONECALLGENERIC_DURINGROCKETS:
        if (!InRocketTakeover(fieldSystem)) {
            return FALSE;
        }

        break;
    default:
        break;
    }

    u32 roll = MTRNG_Next() ^ MTRNG_Next();
    return (u16)((u16)roll ^ (roll >> 8)) % 100 <= check->chance;
}

static BOOL GenericScript(FieldSystem *fieldSystem)
{
    const CompletePhoneCheck *checks = &sPhoneChecks[sCall.contact * 16 + (sCall.kind != CALL_OUTGOING) * 8];
    const CompletePhoneCheck *last = checks;

    for (int i = 0; i < 8; i++) {
        if (checks[i].type == PHONECALLGENERIC_NONE || checks[i].type == PHONECALLGENERIC_NIL) {
            break;
        }

        if (CheckPasses(fieldSystem, &checks[i])) {
            sCall.handler = checks[i].handler;
            sCall.script = checks[i].script;
            return TRUE;
        }

        last = &checks[i];
    }

    if (last->type == PHONECALLGENERIC_NONE || last->type == PHONECALLGENERIC_NIL) {
        return FALSE;
    }

    // HeartGold falls back to the last check that failed
    sCall.handler = last->handler;
    sCall.script = last->script;
    return TRUE;
}

// HeartGold's ov101_021F42E4: Irwin's news, each once, as the player's journey goes
static u16 IrwinNews(FieldSystem *fieldSystem, int badges, BOOL plainBadge)
{
    TrainerInfo *info = SaveData_GetTrainerInfo(fieldSystem->saveData);
    static const struct {
        u16 told;
        u16 script;
    } sOnce[] = {
        { FLAG_HGSS_UNK_9A4, 168 },
        { FLAG_HGSS_UNK_9A3, 167 },
        { FLAG_HGSS_UNK_9A2, 166 },
        { FLAG_HGSS_UNK_9A1, 165 },
    };
    int once = -1;

    if (!PhoneCheckFlag(fieldSystem, FLAG_HGSS_UNK_998)) {
        return 0xFFFF;
    }

    PhoneSetFlag(fieldSystem, FLAG_HGSS_UNK_998, FALSE);

    if (badges >= 16) {
        once = 0;
    } else if (CompleteBadges_Has(info, BADGE_ID_HGSS_MARSH)) {
        once = 1;
    } else if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_SNORLAX_MEET)) {
        once = 2;
    } else if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_UNK_087)) {
        once = 3;
    } else if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_SYS_FLYPOINT_VERMILION)) {
        return 164;
    } else if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_GAME_CLEAR)) {
        if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_UNK_9A5)) {
            return 0xFFFF;
        }

        PhoneSetFlag(fieldSystem, FLAG_HGSS_UNK_9A5, TRUE);
        return 163;
    } else if (CompleteBadges_Has(info, BADGE_ID_HGSS_RISING)) {
        return 162;
    } else if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_BEAT_RADIO_TOWER_ROCKETS)) {
        return 161;
    } else if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_ROCKET_HIDEOUT_CLEARED)) {
        if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_UNK_9A0)) {
            return 0xFFFF;
        }

        PhoneSetFlag(fieldSystem, FLAG_HGSS_UNK_9A0, TRUE);
        return 160;
    } else if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_UNK_96A)) {
        if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_UNK_99F)) {
            return 0xFFFF;
        }

        PhoneSetFlag(fieldSystem, FLAG_HGSS_UNK_99F, TRUE);
        return 159;
    } else if (CompleteBadges_Has(info, BADGE_ID_HGSS_FOG)) {
        return 158;
    } else if (plainBadge) {
        return 157;
    } else {
        return 0xFFFF;
    }

    if (PhoneCheckFlag(fieldSystem, sOnce[once].told)) {
        return 0xFFFF;
    }

    PhoneSetFlag(fieldSystem, sOnce[once].told, TRUE);
    return sOnce[once].script;
}

// HeartGold's PhoneCall_GetScriptId_ProfElm, for a call the player makes: where his research and the player's journey
// are
static u16 ElmOutgoingScript(FieldSystem *fieldSystem)
{
    int badges = CompleteBadges_Count(SaveData_GetTrainerInfo(fieldSystem->saveData));
    BOOL hatchedEgg = PhoneCheckFlag(fieldSystem, FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG);
    BOOL gotEverstone = PhoneCheckFlag(fieldSystem, FLAG_HGSS_GOT_EVERSTONE_FROM_ELM);

    if (!PhoneCheckFlag(fieldSystem, FLAG_HGSS_GOT_ELMS_PANIC_CALL)) {
        return 8;
    } else if (!PhoneCheckFlag(fieldSystem, FLAG_HGSS_GAVE_RIVAL_NAME_TO_OFFICER)) {
        return 9;
    } else if (!PhoneCheckFlag(fieldSystem, FLAG_HGSS_GOT_PICK_UP_EGG_CALL_FROM_ELM)) {
        return 10;
    } else if (!PhoneCheckFlag(fieldSystem, FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT)) {
        return 11;
    } else if (badges < 7) {
        return !hatchedEgg ? 12 : gotEverstone ? 14 + LCRNG_RandMod(2) : 13;
    } else if (InRocketTakeover(fieldSystem)) {
        return 16;
    } else if (badges < 8) {
        return 17;
    } else if (!PhoneCheckFlag(fieldSystem, FLAG_HGSS_GAME_CLEAR)) {
        return 18;
    } else if (!PhoneCheckFlag(fieldSystem, FLAG_HGSS_GOT_SS_TICKET_FROM_ELM)) {
        return 19;
    } else if (!gotEverstone) {
        return hatchedEgg ? 13 : 12;
    }

    return 20 + LCRNG_RandMod(PhoneCheckFlag(fieldSystem, FLAG_HGSS_WAS_TOLD_ABOUT_POKERUS) ? 3 : 2);
}

// HeartGold's PhoneCall_GetScriptId_Kenji: Kenji trains for days at a time, then he's at the Route 45 rest stop for a
// rematch by day (a call while he's training, or at night, says so)
static u16 KenjiOutgoingScript(FieldSystem *fieldSystem)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(fieldSystem->saveData);
    CompletePhoneRematch *rematch = Rematch(fieldSystem, PHONE_CONTACT_KENJI);

    if (phone->kenjiWaitDays > 1 || (phone->kenjiActive && !rematch->seeking)) {
        return 87;
    } else if (phone->kenjiWaitDays == 1) {
        return 88;
    } else if (sCall.hour >= 17) { // HeartGold's evening and night (its late night, before 4, isn't)
        return 91;
    }

    if (!phone->kenjiActive) {
        phone->kenjiActive = TRUE;
        rematch->seeking = TRUE;
    }

    return sCall.timeOfDay == HGSS_DAY ? 90 : 89;
}

// HeartGold's PhoneCall_GetScriptId_* for the calls the player makes: the call script (sCall.script), or a handler
static BOOL OutgoingScript(FieldSystem *fieldSystem)
{
    const CompletePhoneBookEntry *entry = &sPhoneBook[sCall.contact];
    BOOL here = entry->mapHeaderID == fieldSystem->location->mapHeaderID; // the player is where the contact is

    switch (entry->type) {
    case PHONECALLTYPE_GENERIC:
        if (here) {
            sCall.script = entry->localScript;
            return sCall.script != 0;
        }

        return GenericScript(fieldSystem);
    case PHONECALLTYPE_MOM:
        if (here) {
            sCall.script = 23;
        } else if (!PhoneCheckFlag(fieldSystem, FLAG_HGSS_GAVE_RIVAL_NAME_TO_OFFICER)) {
            sCall.script = 25;
        } else if (!PhoneCheckFlag(fieldSystem, FLAG_HGSS_TALKED_TO_MOM_AFTER_NAMING_RIVAL)) {
            sCall.script = 26;
        } else {
            sCall.handler = HANDLER_MOTHER;
            return TRUE;
        }

        return TRUE;
    case PHONECALLTYPE_PROF_ELM:
        sCall.script = here ? 1 : ElmOutgoingScript(fieldSystem);
        return TRUE;
    case PHONECALLTYPE_PROF_OAK:
        if (here) {
            sCall.script = 68;
        } else if (PhoneCheckFlag(fieldSystem, FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION)) {
            sCall.script = 81;
        } else if (!Pokedex_IsNationalDexObtained(SaveData_GetPokedex(fieldSystem->saveData))
            && PhoneCheckFlag(fieldSystem, FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_JOHTO_DEX_COMPLETION)) {
            sCall.script = 80;
        } else {
            sCall.handler = HANDLER_OAK;
        }

        return TRUE;
    case PHONECALLTYPE_KURT:
        if (here) {
            sCall.script = 83;
        } else {
            sCall.handler = HANDLER_KURT;
        }

        return TRUE;
    case PHONECALLTYPE_BIKE_SHOP:
        sCall.script = here ? 84 : 85;
        return TRUE;
    case PHONECALLTYPE_KENJI:
        sCall.script = here ? 86 : KenjiOutgoingScript(fieldSystem);
        return TRUE;
    case PHONECALLTYPE_BILL:
        if (here) {
            sCall.script = 92;
        } else {
            sCall.handler = HANDLER_BILL;
        }

        return TRUE;
    case PHONECALLTYPE_DAYCARELADY:
        if (here) {
            sCall.script = 97;
        } else {
            sCall.handler = HANDLER_DAY_CARE_LADY;
        }

        return TRUE;
    case PHONECALLTYPE_DAYCAREMAN:
        sCall.handler = HANDLER_DAY_CARE_MAN;
        return TRUE;
    case PHONECALLTYPE_BUENA:
        if (InRocketTakeover(fieldSystem)) {
            sCall.script = 99;
        } else if (sCall.hour % 3 == 2) { // her password show is on the air
            sCall.script = 100;
        } else if (here) {
            sCall.script = 98;
        } else {
            sCall.handler = HANDLER_BUENA;
        }

        return TRUE;
    case PHONECALLTYPE_ETHAN_LYRA:
        if (here) {
            sCall.script = sCall.gender == GENDER_MALE ? 102 : 101;
        } else {
            sCall.handler = HANDLER_FRIEND;
        }

        return TRUE;
    case PHONECALLTYPE_GYMLEADER:
        sCall.handler = HANDLER_GYM_LEADER_OUTGOING;
        return TRUE;
    case PHONECALLTYPE_BAOBA:
        sCall.script = here ? 140 : 147 + *FieldSystem_GetVarPointer(fieldSystem, VAR_HGSS_UNK_4057);
        return TRUE;
    case PHONECALLTYPE_IRWIN:
        sCall.script = InRocketTakeover(fieldSystem) ? 156 : 172 + LCRNG_RandMod(3);
        return TRUE;
    default:
        return FALSE;
    }
}

// HeartGold's PhoneCall_GetCallScriptId and the callers' PhoneCall_GetScriptId_*: which call script (sCall.script) and
// handler. FALSE when there's no call.
static BOOL ChooseScript(FieldSystem *fieldSystem)
{
    const CompletePhoneBookEntry *entry = &sPhoneBook[sCall.contact];
    BOOL incoming = sCall.kind != CALL_OUTGOING;

    sCall.handler = HANDLER_SIMPLE;
    sCall.script = 0;

    if (!incoming) {
        return OutgoingScript(fieldSystem);
    }

    switch (entry->type) {
    case PHONECALLTYPE_GENERIC:
        return GenericScript(fieldSystem);
    case PHONECALLTYPE_MOM:
        if (sCall.kind == CALL_SCRIPTED) {
            PhoneSetFlag(fieldSystem, FLAG_HGSS_TALKED_TO_MOM_AFTER_NAMING_RIVAL, TRUE);
            sCall.handler = HANDLER_MOTHER;
            return TRUE;
        }

        sCall.script = sCall.predefined;
        break;
    case PHONECALLTYPE_PROF_ELM:
        sCall.script = sCall.kind == CALL_SCRIPTED && sCall.predefined < NELEMS(sElmScriptedCalls) ? sElmScriptedCalls[sCall.predefined] : sCall.predefined;
        break;
    case PHONECALLTYPE_PROF_OAK:
        if (sCall.kind == CALL_SCRIPTED) {
            sCall.script = 82;
        } else {
            int caught = Pokedex_CountCaught_National(SaveData_GetPokedex(fieldSystem->saveData)) / 50;
            sCall.script = 68 + (caught < 1 ? 1 : caught > 9 ? 9 : caught);
        }

        break;
    case PHONECALLTYPE_BIKE_SHOP:
        sCall.script = 85;
        break;
    case PHONECALLTYPE_BILL:
        sCall.script = 93;
        break;
    case PHONECALLTYPE_DAYCAREMAN:
        sCall.script = PhoneCheckFlag(fieldSystem, FLAG_HGSS_SYS_TRIGGER_EGG_CALL) ? 96 : 95;
        break;
    case PHONECALLTYPE_BUENA:
        if (InRocketTakeover(fieldSystem)) {
            sCall.script = 99;
            break;
        }

        sCall.count = sCall.hour % 3 == 2 ? 3 : 0; // her password show is on the air
        sCall.handler = HANDLER_BUENA2;
        return TRUE;
    case PHONECALLTYPE_ETHAN_LYRA:
        sCall.handler = HANDLER_FRIEND2;
        return TRUE;
    case PHONECALLTYPE_GYMLEADER:
        sCall.handler = HANDLER_GYM_LEADER_INCOMING;
        return TRUE;
    case PHONECALLTYPE_BAOBA: // HeartGold's PhoneCall_GetScriptId_Baoba: his Safari Zone calls do what they say as they play
        if (sCall.kind == CALL_SCRIPTED) {
            sCall.script = 141;
            break;
        }

        if (sCall.predefined == 0) { // a random call, or the one about the areas whose Pokémon changed
            sCall.handler = HANDLER_BAOBA;
            return TRUE;
        }

        sCall.script = CompleteSafari_BaobaCall(fieldSystem->saveData, sCall.predefined);
        break;
    case PHONECALLTYPE_IRWIN: {
        TrainerInfo *info = SaveData_GetTrainerInfo(fieldSystem->saveData);
        int badges = CompleteBadges_Count(info);
        BOOL plainBadge = CompleteBadges_Has(info, BADGE_ID_HGSS_PLAIN);
        u16 news = IrwinNews(fieldSystem, badges, plainBadge);

        sCall.script = news != 0xFFFF ? news : !plainBadge ? 169 : badges < 16 ? 170 : 171;
        break;
    }
    default:
        sCall.script = sCall.predefined;
        break;
    }

    return sCall.script != 0;
}

static void InitCall(FieldSystem *fieldSystem, u8 contact, u8 kind, u16 predefined)
{
    RTCDate date;
    RTCTime time;

    MI_CpuClear8(&sCall, sizeof(sCall));
    sCall.contact = contact;
    sCall.kind = kind;
    sCall.predefined = predefined;
    sCall.trigger = 0xFF;
    sCall.gender = TrainerInfo_Gender(SaveData_GetTrainerInfo(fieldSystem->saveData));

    GetCurrentDateTime(&date, &time);
    sCall.weekday = date.week;
    sCall.hour = time.hour;
    // HeartGold's times: morning 4-10, day 10-20, night 20-4
    sCall.timeOfDay = time.hour >= 4 && time.hour < 10 ? HGSS_MORNING : time.hour >= 10 && time.hour < 20 ? HGSS_DAY : HGSS_NIGHT;
}

// HeartGold's SAVE_MISC_DATA recent callers (save_misc.c's _020F677C): of each call group, the last ones to call
static const u8 sRecentCallers[CALL_GROUPS][2] = { { 0, 4 }, { 4, 2 }, { 6, 2 } }; // first, count

static BOOL CalledRecently(CompletePhoneSave *phone, u8 group, u8 contact)
{
    for (int i = 0; i < sRecentCallers[group][1]; i++) {
        u8 caller = phone->recentCallers[sRecentCallers[group][0] + i];

        if (caller == PHONE_CONTACT_NONE) {
            break;
        }

        if (caller == contact) {
            return TRUE;
        }
    }

    return FALSE;
}

static int RecentCallerCount(CompletePhoneSave *phone, u8 group)
{
    int count = 0;

    for (int i = 0; i < sRecentCallers[group][1]; i++) {
        count += phone->recentCallers[sRecentCallers[group][0] + i] != PHONE_CONTACT_NONE;
    }

    return count;
}

static void ForgetRecentCallers(CompletePhoneSave *phone, u8 group)
{
    MI_CpuFill8(&phone->recentCallers[sRecentCallers[group][0]], PHONE_CONTACT_NONE, sRecentCallers[group][1]);
}

// HeartGold's sub_0202AB18: the caller joins the group's recent callers (the oldest leaves when it's full, and all of
// them when the group has only that many callers)
static void RememberCaller(CompletePhoneSave *phone, u8 group, u8 candidates, u8 contact)
{
    u8 *callers = &phone->recentCallers[sRecentCallers[group][0]];
    int count = sRecentCallers[group][1];

    for (int i = 0; i < count; i++) {
        if (callers[i] == PHONE_CONTACT_NONE) {
            callers[i] = contact;
            return;
        }
    }

    if (candidates == count + 1) {
        ForgetRecentCallers(phone, group);
        callers[0] = contact;
        return;
    }

    MI_CpuCopy8(&callers[1], &callers[0], count - 1);
    callers[count - 1] = contact;
}

// HeartGold's ov02_02251FDC: a random caller from the phone book, of a random group, who isn't on this map and hasn't
// called lately
static BOOL ChooseRandomCaller(FieldSystem *fieldSystem)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(fieldSystem->saveData);
    u8 inGroup[NUM_PHONE_CONTACTS], callers[NUM_PHONE_CONTACTS];
    int numInGroup = 0, numCallers = 0;
    u16 roll = LCRNG_RandMod(1000);
    u8 group = roll < 500 ? 0 : roll < 800 ? 1 : 2;

    for (int i = 0; i < NUM_PHONE_CONTACTS && phone->contacts[i] != PHONE_CONTACT_NONE; i++) {
        const CompletePhoneBookEntry *entry = &sPhoneBook[phone->contacts[i]];

        if (entry->group == group
            && (entry->type == PHONECALLTYPE_GENERIC || entry->type == PHONECALLTYPE_GYMLEADER || entry->type == PHONECALLTYPE_ETHAN_LYRA
                || entry->type == PHONECALLTYPE_BUENA || entry->type == PHONECALLTYPE_IRWIN)) {
            inGroup[numInGroup++] = phone->contacts[i];
        }
    }

    if (numInGroup == 0) {
        return FALSE;
    }

    if (RecentCallerCount(phone, group) == numInGroup) {
        ForgetRecentCallers(phone, group);
    }

    RTCDate date;
    RTCTime time;
    GetCurrentDateTime(&date, &time);

    for (int i = 0; i < numInGroup; i++) {
        const CompletePhoneBookEntry *entry = &sPhoneBook[inGroup[i]];

        if (entry->mapHeaderID == fieldSystem->location->mapHeaderID || CalledRecently(phone, group, inGroup[i])) {
            continue;
        }

        if (inGroup[i] == PHONE_CONTACT_BUENA && (time.hour % 3 == 2 || InRocketTakeover(fieldSystem))) {
            continue;
        }

        if (entry->mapHeaderID == MAP_HEADER_HGSS_NATIONAL_PARK && CompleteBugContest_IsRunning()) {
            continue;
        }

        callers[numCallers++] = inGroup[i];
    }

    if (numCallers == 0) {
        return FALSE;
    }

    InitCall(fieldSystem, callers[MTRNG_Next() % (numCallers * 100) / 100], CALL_INCOMING, 0);
    sCall.group = group;
    sCall.candidates = numInGroup;
    return TRUE;
}

// HeartGold's ov02_02252218: a call trigger that's set, at random (its caller not on this map; the Day-Care Man only
// when the player has his number)
static BOOL ChooseTriggeredCall(FieldSystem *fieldSystem)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(fieldSystem->saveData);
    u8 triggers[NUM_CALL_TRIGGERS];
    int count = 0;

    for (int i = 0; i < NUM_CALL_TRIGGERS; i++) {
        u8 contact = sCallTriggers[i].contact;

        if (!(phone->callTriggerFlags[i / 8] & (1 << (i % 8)))) {
            continue;
        }

        if (contact == PHONE_CONTACT_DAY_C_MAN ? !CompletePhone_IsRegistered(fieldSystem->saveData, contact)
                                               : sPhoneBook[contact].mapHeaderID == fieldSystem->location->mapHeaderID) {
            continue;
        }

        triggers[count++] = i;
    }

    if (count == 0) {
        return FALSE;
    }

    u8 trigger = triggers[LCRNG_RandMod(count)];
    InitCall(fieldSystem, sCallTriggers[trigger].contact, CALL_TRIGGERED, sCallTriggers[trigger].script);
    sCall.trigger = trigger;
    return TRUE;
}

#ifdef SOVEREIGN_TEST
u8 gCompleteTestPhoneCaller; // the contact + 1 who calls at the next step, at once
u8 gCompleteTestPhoneRing; // the contact + 1 whose call rings at the next step
#endif

// The call chosen rings on the Pokégear until the player answers (include/complete_phone.h)
static void Ring(void)
{
    CompletePhoneRing ring = { sCall.contact, sCall.kind, sCall.predefined, sCall.trigger, sCall.group, sCall.candidates };

    CompletePhone_StartRinging(&ring);
}

// HeartGold's ov02_02251F20, at each step (src/overlay005/field_control.c): ten minutes after the last call, on a map
// with a signal, a call trigger's call, or half the time a random caller's. The phone rings and the call plays out at
// once (in HeartGold the player answers it on the Pokégear).
BOOL CompletePhone_TryIncomingCall(FieldSystem *fieldSystem)
{
#ifdef SOVEREIGN_TEST
    if (gCompleteTestPhoneCaller != 0) {
        InitCall(fieldSystem, gCompleteTestPhoneCaller - 1, CALL_INCOMING, 0);
        gCompleteTestPhoneCaller = 0;
        ScriptManager_Set(fieldSystem, SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_PHONE_INCOMING_CALL), NULL);
        return TRUE;
    }

    if (gCompleteTestPhoneRing != 0) {
        InitCall(fieldSystem, gCompleteTestPhoneRing - 1, CALL_INCOMING, 0);
        gCompleteTestPhoneRing = 0;
        Ring();
        return FALSE;
    }
#endif

    if (CompletePhone_IsRinging() || !MapHeader_HasIncomingCalls(fieldSystem->location->mapHeaderID)
        || CompletePhone_MinutesSinceCall() < MIN_CALL_MINUTES) {
        return FALSE;
    }

    if (ChooseTriggeredCall(fieldSystem)) {
        // HeartGold's forced calls (the Bike Shop's, Bill's, Baoba's) come through at once
        if (sCallTriggers[sCall.trigger].forced) {
            ScriptManager_Set(fieldSystem, SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_PHONE_INCOMING_CALL), NULL);
            return TRUE;
        }
    } else if (MTRNG_Next() % 100 > RANDOM_CALL_ODDS || !ChooseRandomCaller(fieldSystem)) {
        CompletePhone_ResetCallTimer();
        return FALSE;
    }

    Ring();
    return FALSE;
}

#ifdef SOVEREIGN_TEST
u8 gCompleteTestPhoneCallee; // the contact + 1 the player calls as the field next runs
#endif

// A call the player placed on the Pokégear (CompletePhone_RequestCall), once they stand still on the field: HeartGold's
// phone app's outgoing call, shown in the field's message box
BOOL CompletePhone_TryOutgoingCall(FieldSystem *fieldSystem)
{
    CompletePhoneRing ring;

    // a call that rang, answered on the Pokégear: the call as it was chosen
    if (CompletePhone_TakeAnswer(&ring)) {
        InitCall(fieldSystem, ring.contact, ring.kind, ring.predefined);
        sCall.trigger = ring.trigger;
        sCall.group = ring.group;
        sCall.candidates = ring.candidates;
        ScriptManager_Set(fieldSystem, SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_PHONE_INCOMING_CALL), NULL);
        return TRUE;
    }

    u8 contact = CompletePhone_TakeRequestedCall();

#ifdef SOVEREIGN_TEST
    if (gCompleteTestPhoneCallee != 0) {
        contact = gCompleteTestPhoneCallee - 1;
        gCompleteTestPhoneCallee = 0;
    }
#endif

    if (contact >= NUM_PHONE_CONTACTS || !CompletePhone_IsRegistered(fieldSystem->saveData, contact)) {
        return FALSE;
    }

    InitCall(fieldSystem, contact, CALL_OUTGOING, 0);
    ScriptManager_Set(fieldSystem, SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_PHONE_OUTGOING_CALL), NULL);
    return TRUE;
}

// Whether the player can place a call here: HeartGold's map headers say for Johto and Kanto (not in the Elite Four's
// rooms, the Safari Zone's areas or Lugia's cave); Sinnoh's maps, which HeartGold's phone never knew, all have a signal
static BOOL CanPlaceCall(FieldSystem *fieldSystem)
{
    enum MapHeaderID mapHeaderID = fieldSystem->location->mapHeaderID;
    return !MapHeader_IsHGSS(mapHeaderID) || MapHeader_HasOutgoingCalls(mapHeaderID);
}

// A message of the call is done, and the fanfare a rating plays with it (HeartGold waits for both)
static BOOL WaitForCallMessage(ScriptContext *ctx)
{
    u8 *printerID = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_MESSAGE_ID);

    if (!FieldMessage_FinishedPrinting(*printerID)) {
        return FALSE;
    }

    return !sCall.fanfare || !Sound_IsBGMPausedByFanfare();
}

// CompletePhoneCallStart contact, kind, script, destVar: a call from the contact (HeartGold's PhoneCall from a map
// script: kind 2 and a script of the contact's), or with PHONE_CONTACT_NONE the call the field chose. destVar: whether
// the call goes ahead, or CALL_STEP_OUT_OF_AREA for a call the player can't place here.
BOOL CompleteScrCmd_PhoneCallStart(ScriptContext *ctx)
{
    u16 contact = ScriptContext_GetVar(ctx);
    u16 kind = ScriptContext_GetVar(ctx);
    u16 script = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    if (contact != PHONE_CONTACT_NONE) {
        InitCall(ctx->fieldSystem, contact, kind, script);
    }

    *destVar = FALSE;

    if (sCall.contact < NUM_PHONE_CONTACTS && sCall.kind == CALL_OUTGOING && !CanPlaceCall(ctx->fieldSystem)) {
        *destVar = CALL_STEP_OUT_OF_AREA;
        return FALSE;
    }

    if (sCall.contact >= NUM_PHONE_CONTACTS || !ChooseScript(ctx->fieldSystem)) {
        return FALSE;
    }

    sCall.template = StringTemplate_New(16, 64, HEAP_ID_FIELD3);
    BufferNames(ctx->fieldSystem);
    *destVar = TRUE;
    return FALSE;
}

// CompletePhoneCallMessage destVar: prints the call's next message (enum CallStep in destVar: whether there was one,
// and whether a yes or no follows)
BOOL CompleteScrCmd_PhoneCallMessage(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = sCall.template != NULL ? NextStep(ctx->fieldSystem) : CALL_STEP_END;

    if (*destVar == CALL_STEP_END) {
        return FALSE;
    }

    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, sCall.bank, HEAP_ID_FIELD3);
    MessageLoader *scriptLoader = ctx->loader;

    ctx->loader = loader; // ScriptMessage_ShowTemplate reads the script's bank
    ScriptMessage_ShowTemplate(ctx, sCall.template, sCall.message, TRUE);
    ctx->loader = scriptLoader;
    MessageLoader_Free(loader);

    ScriptContext_Pause(ctx, WaitForCallMessage);
    return TRUE;
}

static BOOL ResumeOnCallMenu(ScriptContext *ctx)
{
    return *FieldSystem_GetVarPointer(ctx->fieldSystem, ctx->data[0]) != LIST_MENU_NO_SELECTION_YET;
}

// CompletePhoneCallMenu destVar: the call's choices (HeartGold's phone app's touch screen menus, from its bank 0271) as
// a menu by the message box; destVar: the pick, or the last choice (Quit) on B
BOOL CompleteScrCmd_PhoneCallMenu(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    FieldMenuManager **menu = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_FIELD_MENU_MANAGER);
    StringTemplate **template = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_STR_TEMPLATE);
    u16 destVarID = ScriptContext_ReadHalfWord(ctx);

    *menu = FieldMenuManager_New(fieldSystem, 31, 13, 0, TRUE, FieldSystem_GetVarPointer(fieldSystem, destVarID), *template, FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_WINDOW), NULL);
    MessageLoader_Free((*menu)->messageLoader); // the menu frees its own loader as it closes
    (*menu)->messageLoader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0271, HEAP_ID_FIELD1);

    for (int i = 0; i < sCall.menuCount; i++) {
        FieldMenuManager_AddMenuEntry(*menu, sCall.menuFirst + i, i);
    }

    FieldMenuManager_SetHorizontalAnchor(*menu, TRUE);
    FieldMenuManager_SetVerticalAnchor(*menu, TRUE);
    FieldMenuManager_ShowSingleColumnMenu(*menu);
    ctx->data[0] = destVarID;
    ScriptContext_Pause(ctx, ResumeOnCallMenu);
    return TRUE;
}

// CompletePhoneCallAnswer value: the yes (MENU_YES) or no the call asked for, or the choice the player picked
BOOL CompleteScrCmd_PhoneCallAnswer(ScriptContext *ctx)
{
    u16 answer = ScriptContext_GetVar(ctx);

    sCall.answer = answer == (u16)MENU_CANCEL && sCall.menuCount != 0 ? sCall.menuCount - 1 : answer;
    sCall.menuCount = 0;
    return FALSE;
}

// CompletePhoneCallEnd: the call is over (HeartGold's phone app's exit): a random caller is remembered, a call trigger
// is done, and the next call waits ten minutes
BOOL CompleteScrCmd_PhoneCallEnd(ScriptContext *ctx)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(ctx->fieldSystem->saveData);

    if (sCall.template != NULL) {
        StringTemplate_Free(sCall.template);
        sCall.template = NULL;
    }

    if (sCall.kind == CALL_INCOMING && sCall.candidates != 0) {
        RememberCaller(phone, sCall.group, sCall.candidates, sCall.contact);
    }

    if (sCall.trigger < NUM_CALL_TRIGGERS) {
        phone->callTriggerFlags[sCall.trigger / 8] &= ~(1 << (sCall.trigger % 8));
    }

    sCall.contact = PHONE_CONTACT_NONE;
    sCall.fanfare = FALSE;
    CompletePhone_ResetCallTimer();
    return FALSE;
}

// HeartGold's ScrCmd_148: a call trigger is set, and with soon, the next step may already ring
BOOL CompleteScrCmd_PhoneSetCallTrigger(ScriptContext *ctx)
{
    u8 trigger = ScriptContext_ReadByte(ctx);
    u8 soon = ScriptContext_ReadByte(ctx);

    CompletePhone_SetCallTrigger(ctx->fieldSystem->saveData, trigger, soon);
    return FALSE;
}

// HeartGold's ScrCmd_149 (UnsetPhoneCallTrigger): a call trigger is called off (Mom's, once her gift is picked up)
BOOL CompleteScrCmd_PhoneClearCallTrigger(ScriptContext *ctx)
{
    u8 trigger = ScriptContext_ReadByte(ctx);

    if (trigger < NUM_CALL_TRIGGERS) {
        SaveData_GetCompletePhone(ctx->fieldSystem->saveData)->callTriggerFlags[trigger / 8] &= ~(1 << (trigger % 8));
    }

    return FALSE;
}
