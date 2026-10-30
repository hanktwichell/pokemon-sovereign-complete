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
#include "overlay005/script_message.h"
#include "struct_defs/trainer.h"
#include "struct_defs/trainer_data.h"

#include "complete_badges.h"
#include "complete_bug_contest.h"
#include "complete_encounters.h"
#include "complete_map_info.h"
#include "complete_phone.h"
#include "complete_trainers.h"
#include "field_message.h"
#include "field_script_context.h"
#include "heap.h"
#include "inlines.h"
#include "map_header.h"
#include "math_util.h"
#include "message.h"
#include "message_util.h"
#include "pokedex.h"
#include "rtc.h"
#include "save_player.h"
#include "scrcmd.h"
#include "script_manager.h"
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
} CompletePhoneCall;

static CompletePhoneCall sCall;

// HeartGold's call triggers (overlay 2's ov02_02253C84): who calls, and with which call script
static const struct {
    u8 contact;
    u16 script;
} sCallTriggers[NUM_CALL_TRIGGERS] = {
    { PHONE_CONTACT_PROF__ELM, 13 }, // the Egg hatched
    { PHONE_CONTACT_PROF__ELM, 7 }, // Pokérus
    { PHONE_CONTACT_BIKE_SHOP, 85 },
    { PHONE_CONTACT_BILL, 93 }, // the boxes are full
    { PHONE_CONTACT_PROF__OAK, 0 },
    { PHONE_CONTACT_DAY_C_MAN, 0 },
    { PHONE_CONTACT_BAOBA, 0 },
    { PHONE_CONTACT_BAOBA, 142 }, // the Safari Zone's next test
    { PHONE_CONTACT_BAOBA, 143 }, // object arrangement
    { PHONE_CONTACT_BAOBA, 144 }, // new objects
    { PHONE_CONTACT_BAOBA, 145 }, // many objects
    { PHONE_CONTACT_BAOBA, 146 }, // a time loop
    { PHONE_CONTACT_MOTHER, 27 }, // Mom bought something with the player's money
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
    default: // the calls the player makes, which wait on the Pokégear's contact list
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

// HeartGold's PhoneCall_GetCallScriptId and the callers' PhoneCall_GetScriptId_*, for the calls that come to the
// player: which call script (sCall.script) and handler. FALSE when there's no call.
static BOOL ChooseScript(FieldSystem *fieldSystem)
{
    const CompletePhoneBookEntry *entry = &sPhoneBook[sCall.contact];
    BOOL incoming = sCall.kind != CALL_OUTGOING;

    sCall.handler = HANDLER_SIMPLE;
    sCall.script = 0;

    if (!incoming) {
        return FALSE; // the calls the player makes wait on the Pokégear's contact list
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
    case PHONECALLTYPE_BAOBA: // his Safari Zone calls' changes are made by src/complete_safari.c's stand-in
        sCall.script = sCall.kind == CALL_SCRIPTED ? 141 : sCall.predefined != 0 ? sCall.predefined : 154;
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
#endif

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
#endif

    if (!MapHeader_HasIncomingCalls(fieldSystem->location->mapHeaderID) || CompletePhone_MinutesSinceCall() < MIN_CALL_MINUTES) {
        return FALSE;
    }

    if (!ChooseTriggeredCall(fieldSystem)) {
        if (MTRNG_Next() % 100 > RANDOM_CALL_ODDS || !ChooseRandomCaller(fieldSystem)) {
            CompletePhone_ResetCallTimer();
            return FALSE;
        }
    }

    ScriptManager_Set(fieldSystem, SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_PHONE_INCOMING_CALL), NULL);
    return TRUE;
}

static BOOL WaitForCallMessage(ScriptContext *ctx)
{
    u8 *printerID = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_MESSAGE_ID);
    return FieldMessage_FinishedPrinting(*printerID);
}

// CompletePhoneCallStart contact, kind, script, destVar: a call from the contact (HeartGold's PhoneCall from a map
// script: kind 2 and a script of the contact's), or with PHONE_CONTACT_NONE the call the field chose. destVar: whether
// the call goes ahead.
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

// CompletePhoneCallAnswer value: the yes (MENU_YES) or no the call asked for
BOOL CompleteScrCmd_PhoneCallAnswer(ScriptContext *ctx)
{
    sCall.answer = ScriptContext_GetVar(ctx);
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
