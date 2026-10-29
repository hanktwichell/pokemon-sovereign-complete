#include "complete_bug_contest.h"

#include <nitro.h>
#include <string.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "constants/string.h"
#include "generated/items.h"
#include "generated/pokemon_stats.h"
#include "generated/species.h"
#include "generated/text_banks.h"
#include "generated/trainer_classes.h"

#include "field/field_system.h"
#include "savedata/save_table.h"

#include "field_script_context.h"
#include "heap.h"
#include "inlines.h"
#include "message.h"
#include "party.h"
#include "pc_boxes.h"
#include "pokedex.h"
#include "pokemon.h"
#include "rtc.h"
#include "save_player.h"
#include "script_manager.h"
#include "string_gf.h"
#include "string_template.h"
#include "unk_02054884.h"

#include "res/text/bank/hgss_msg_0246.h"

// The Bug-Catching Contest (HeartGold's src/overlay_bug_contest.c and its helpers in src/unk_0206D494.c;
// docs/Features.md). It is never saved: it lives on the field's heap from the gate (the party is put away but for its
// first Pokémon that can battle) to the judging (the party comes back, and the caught Pokémon joins it or a box).
// HeartGold's tables (include/data/complete_bug_contest.h, from tools/complete/import_hgss_bug_contest.py) are the
// same in Sacred Gold.

#define BUG_CONTEST_ENCOUNTERS        10
#define BUG_CONTEST_NPCS              5
#define BUG_CONTEST_CONTESTANTS       (BUG_CONTEST_NPCS + 1)
#define BUG_CONTEST_PLAYER            BUG_CONTEST_NPCS
#define BUG_CONTEST_ENTRANTS          10 // the contestants who may be in a contest
#define BUG_CONTEST_ENTRIES           8 // each entrant's possible Pokémon
#define BUG_CONTEST_ANY_DAY           7
#define BUG_CONTEST_CONSOLATION_PLACE 3
#define BUG_CONTEST_IV_TOTAL_MAX      (31 * STAT_MAX)

#include "data/complete_bug_contest.h"

typedef struct BugContestant {
    u8 id; // the entrant (0-9), or BUG_CONTEST_PLAYER
    u16 score;
    u16 species;
} BugContestant;

typedef struct BugContest {
    s64 startTime; // first, so a harness finds each field at the same place (tools/complete/test_hgss_bug_contest.py)
    SaveData *saveData;
    Party *partyBackup;
    Pokemon *caughtMon;
    u8 leadSlot; // the Pokémon that entered, in the party it came from
    u8 partyCount; // the party's size before the contest
    u8 weekday;
    u8 placement;
    BOOL nationalDex;
    BOOL caught;
    u16 sportBalls;
    u16 prize;
    const BugContestEncounter *encounters; // the day's set
    BugContestant contestants[BUG_CONTEST_CONTESTANTS];
    u8 ranking[BUG_CONTEST_CONTESTANTS];
} BugContest;

static BugContest *sBugContest;

// The entrants' trainer classes (HeartGold's sBugContestOpponentClasses), by entrant
static const u16 sEntrantClasses[BUG_CONTEST_ENTRANTS] = {
    TRAINER_CLASS_BUG_CATCHER, // Don
    TRAINER_CLASS_BUG_CATCHER, // Ed
    TRAINER_CLASS_ACE_TRAINER_FEMALE, // Abby
    TRAINER_CLASS_POKEFAN_MALE, // William
    TRAINER_CLASS_BUG_CATCHER, // Benny
    TRAINER_CLASS_CAMPER, // Barry
    TRAINER_CLASS_PICNICKER, // Cindy
    TRAINER_CLASS_BUG_CATCHER, // Josh
    TRAINER_CLASS_YOUNGSTER, // Samuel
    TRAINER_CLASS_SCHOOL_KID_MALE, // Kipp
};

static BOOL BugContest_IsEntered(BugContest *contest, u8 id, int count)
{
    for (int i = 0; i < count; i++) {
        if (contest->contestants[i].id == id) {
            return TRUE;
        }
    }

    return FALSE;
}

// Only the first Pokémon that can battle goes in; the rest wait for the judging.
static void BugContest_PutPartyAway(BugContest *contest)
{
    Party *party = SaveData_GetParty(contest->saveData);

    contest->partyBackup = Party_New(HEAP_ID_FIELD2);
    Party_Copy(party, contest->partyBackup);
    contest->partyCount = Party_GetCurrentCount(party);
    contest->leadSlot = 0;

    for (int i = 0; i < contest->partyCount; i++) {
        if (Pokemon_CanBattle(Party_GetPokemonBySlotIndex(party, i))) {
            contest->leadSlot = i;
            break;
        }
    }

    for (int i = 0; i < contest->partyCount - 1; i++) {
        Party_RemovePokemonBySlotIndex(party, i < contest->leadSlot ? 0 : 1);
    }
}

// The party comes back with the Pokémon that entered as it is now, and the caught Pokémon joins it, or the first free
// place in a box if the party was full.
static void BugContest_BringPartyBack(BugContest *contest)
{
    Party *party = SaveData_GetParty(contest->saveData);
    Pokemon *lead = Pokemon_New(HEAP_ID_FIELD2);

    Pokemon_Copy(Party_GetPokemonBySlotIndex(party, 0), lead);
    Party_Copy(contest->partyBackup, party);
    Party_AddPokemonBySlotIndex(party, contest->leadSlot, lead);
    Heap_Free(lead);
    Heap_Free(contest->partyBackup);
    contest->partyBackup = NULL;

    if (contest->caught) {
        if (contest->partyCount >= MAX_PARTY_SIZE) {
            PCBoxes_TryStoreBoxMon(SaveData_GetPCBoxes(contest->saveData), Pokemon_GetBoxPokemon(contest->caughtMon));
        } else {
            Party_AddPokemon(party, contest->caughtMon);
        }
    }
}

// Five of the ten entrants, each with one of the Pokémon they may have caught today, and its score.
static void BugContest_PickContestants(BugContest *contest)
{
    u8 fitting[BUG_CONTEST_ENTRIES];

    for (int i = 0; i < BUG_CONTEST_NPCS; i++) {
        contest->contestants[i].id = 0xFF;
    }

    for (int i = 0; i < BUG_CONTEST_NPCS; i++) {
        u8 id;

        do {
            id = LCRNG_RandMod(BUG_CONTEST_ENTRANTS);
        } while (BugContest_IsEntered(contest, id, i));

        const BugContestantEntry *entries = sBugContestantEntries[id];
        int count = 0;

        for (int j = 0; j < BUG_CONTEST_ENTRIES; j++) {
            if (entries[j].national && !contest->nationalDex) {
                continue;
            }

            if (entries[j].day < BUG_CONTEST_ANY_DAY && entries[j].day != contest->weekday) {
                continue;
            }

            fitting[count++] = j;
        }

        const BugContestantEntry *entry = &entries[fitting[count ? LCRNG_RandMod(count) : 0]];

        contest->contestants[i].id = id;
        contest->contestants[i].species = entry->species;
        contest->contestants[i].score = entry->score + LCRNG_RandMod(2 * entry->randmod) - entry->randmod;
    }
}

static void CompleteBugContest_Start(FieldSystem *fieldSystem, u8 weekday)
{
    GF_ASSERT(sBugContest == NULL);

    BugContest *contest = Heap_Alloc(HEAP_ID_FIELD2, sizeof(BugContest));

    MI_CpuClear8(contest, sizeof(BugContest));
    contest->saveData = fieldSystem->saveData;
    contest->sportBalls = BUG_CONTEST_SPORT_BALLS;
    contest->caughtMon = Pokemon_New(HEAP_ID_FIELD2);
    contest->nationalDex = Pokedex_IsNationalDexObtained(SaveData_GetPokedex(fieldSystem->saveData));
    contest->weekday = weekday;
    contest->encounters = sBugContestEncounters[contest->nationalDex && weekday / 2 < NELEMS(sBugContestEncounters) ? weekday / 2 : 0];
    contest->startTime = GetTimestamp();
    BugContest_PutPartyAway(contest);
    BugContest_PickContestants(contest);
    sBugContest = contest;
}

static void CompleteBugContest_End(void)
{
    if (sBugContest == NULL) {
        return;
    }

    BugContest_BringPartyBack(sBugContest);
    Heap_Free(sBugContest->caughtMon);
    Heap_Free(sBugContest);
    sBugContest = NULL;
}

BOOL CompleteBugContest_IsRunning(void)
{
    return sBugContest != NULL;
}

u16 CompleteBugContest_GetSportBalls(void)
{
    return sBugContest != NULL ? sBugContest->sportBalls : 0;
}

void CompleteBugContest_SetSportBalls(u16 sportBalls)
{
    if (sBugContest != NULL) {
        sBugContest->sportBalls = sportBalls;
    }
}

BOOL CompleteBugContest_HasCaught(void)
{
    return sBugContest != NULL && sBugContest->caught;
}

// The Pokémon kept so far (an empty one before the first catch).
Pokemon *CompleteBugContest_GetCaughtMon(void)
{
    return sBugContest != NULL ? sBugContest->caughtMon : NULL;
}

// The player keeps this Pokémon, in place of any kept before.
void CompleteBugContest_KeepMon(Pokemon *mon)
{
    if (sBugContest != NULL) {
        Pokemon_Copy(mon, sBugContest->caughtMon);
        sBugContest->caught = TRUE;
    }
}

// A wild Pokémon from the day's set (HeartGold's BugContest_GetEncounterSlot).
void CompleteBugContest_GetEncounter(u16 *species, u8 *level)
{
    const BugContestEncounter *encounters = sBugContest->encounters;
    u16 roll = LCRNG_RandMod(100);
    int i;

    for (i = 0; i < BUG_CONTEST_ENCOUNTERS - 1; i++) {
        if (roll >= encounters[i].rate) {
            break;
        }
    }

    *species = encounters[i].species;
    *level = encounters[i].minLevel + LCRNG_RandMod(encounters[i].maxLevel - encounters[i].minLevel + 1);
}

static int BugContest_MinutesElapsed(BugContest *contest)
{
    return TimeElapsed(contest->startTime, GetTimestamp()) / 60;
}

BOOL CompleteBugContest_IsTimeUp(void)
{
    return sBugContest != NULL && BugContest_MinutesElapsed(sBugContest) >= BUG_CONTEST_MINUTES;
}

// The kept Pokémon's score (HeartGold's BugContest_JudgePlayerMon): its species' score, its level against the slot's
// highest, its IVs and its HP, each out of 100.
static u16 BugContest_PlayerScore(BugContest *contest)
{
    if (!contest->caught) {
        return 0;
    }

    Pokemon *mon = contest->caughtMon;
    u16 species = Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL);
    const BugContestEncounter *encounter = NULL;

    for (int i = 0; i < BUG_CONTEST_ENCOUNTERS; i++) {
        if (contest->encounters[i].species == species) {
            encounter = &contest->encounters[i];
            break;
        }
    }

    if (encounter == NULL) {
        return 0;
    }

    u16 ivTotal = 0;

    for (int i = 0; i < STAT_MAX; i++) {
        ivTotal += Pokemon_GetValue(mon, MON_DATA_HP_IV + i, NULL);
    }

    return encounter->score
        + Pokemon_GetValue(mon, MON_DATA_LEVEL, NULL) * 100 / encounter->maxLevel
        + ivTotal * 100 / BUG_CONTEST_IV_TOTAL_MAX
        + Pokemon_GetValue(mon, MON_DATA_HP, NULL) * 100 / Pokemon_GetValue(mon, MON_DATA_MAX_HP, NULL);
}

// The places and the player's prize (HeartGold's BugContest_Judge): the player wins a tie.
static void BugContest_Judge(BugContest *contest)
{
    BugContestant *player = &contest->contestants[BUG_CONTEST_PLAYER];

    player->id = BUG_CONTEST_PLAYER;
    player->score = BugContest_PlayerScore(contest);
    player->species = contest->caught ? Pokemon_GetValue(contest->caughtMon, MON_DATA_SPECIES, NULL) : SPECIES_NONE;

    for (int i = 0; i < BUG_CONTEST_CONTESTANTS; i++) {
        contest->ranking[i] = i;
    }

    for (int i = 0; i < BUG_CONTEST_CONTESTANTS - 1; i++) {
        u8 first = contest->ranking[i];
        int best = i;
        int bestScore = contest->contestants[first].score;

        for (int j = i + 1; j < BUG_CONTEST_CONTESTANTS; j++) {
            if (contest->contestants[contest->ranking[j]].score >= bestScore) {
                best = j;
                bestScore = contest->contestants[contest->ranking[j]].score;
            }
        }

        contest->ranking[i] = contest->ranking[best];
        contest->ranking[best] = first;
    }

    contest->placement = BUG_CONTEST_CONSOLATION_PLACE;

    for (int i = 0; i < BUG_CONTEST_CONSOLATION_PLACE; i++) {
        if (contest->ranking[i] == BUG_CONTEST_PLAYER) {
            contest->placement = i;
            break;
        }
    }

    switch (contest->placement) {
    case 0: {
        // with the National Dex, one of ten stones: the six from the Sun Stone on, then the Shiny, Dusk, Dawn and
        // Oval Stones
        int stone = contest->nationalDex ? LCRNG_RandMod(10) : 0;

        contest->prize = stone < 6 ? ITEM_SUN_STONE + stone : ITEM_SHINY_STONE + stone - 6;
        break;
    }
    case 1:
        contest->prize = ITEM_EVERSTONE;
        break;
    case 2:
        contest->prize = ITEM_SITRUS_BERRY;
        break;
    default:
        contest->prize = ITEM_SHED_SHELL;
        break;
    }
}

// HeartGold's BugContestAction: 0 starts the contest (with the weekday), 1 ends it.
BOOL CompleteScrCmd_BugContestAction(ScriptContext *ctx)
{
    u8 action = ScriptContext_ReadByte(ctx);
    u16 weekday = ScriptContext_GetVar(ctx);

    if (action == 0) {
        CompleteBugContest_Start(ctx->fieldSystem, weekday);
    } else {
        CompleteBugContest_End();
    }

    return FALSE;
}

// Each place's winner: the player's name, or the entrant's name (0) and class (2), then the species (1) and score (3).
BOOL CompleteScrCmd_BufferBugContestWinner(ScriptContext *ctx)
{
    StringTemplate **template = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_STR_TEMPLATE);
    u8 place = ScriptContext_ReadByte(ctx);
    BugContest *contest = sBugContest;

    if (contest == NULL) {
        return FALSE;
    }

    BugContestant *contestant = &contest->contestants[contest->ranking[place]];

    if (place == contest->placement) {
        StringTemplate_SetPlayerName(*template, 0, SaveData_GetTrainerInfo(contest->saveData));
    } else {
        MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0246, HEAP_ID_FIELD2);
        String *name = MessageLoader_GetNewString(loader, msg_0246_00078 + contestant->id);

        StringTemplate_SetString(*template, 0, name, 0, TRUE, GAME_LANGUAGE);
        String_Free(name);
        MessageLoader_Free(loader);
        StringTemplate_SetTrainerClassName(*template, 2, sEntrantClasses[contestant->id]);
    }

    MessageLoader *speciesNames = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_SPECIES_NAME, HEAP_ID_FIELD2);
    String *species = MessageLoader_GetNewString(speciesNames, contestant->species);

    StringTemplate_SetString(*template, 1, species, 0, TRUE, GAME_LANGUAGE);
    String_Free(species);
    MessageLoader_Free(speciesNames);
    StringTemplate_SetNumber(*template, 3, contestant->score, 3, PADDING_MODE_NONE, CHARSET_MODE_EN);
    return FALSE;
}

// The player's place (0-2, or 3), prize and caught species (0 if none).
BOOL CompleteScrCmd_JudgeBugContest(ScriptContext *ctx)
{
    u16 *placement = ScriptContext_GetVarPointer(ctx);
    u16 *prize = ScriptContext_GetVarPointer(ctx);
    u16 *species = ScriptContext_GetVarPointer(ctx);
    BugContest *contest = sBugContest;

    if (contest == NULL) {
        *placement = BUG_CONTEST_CONSOLATION_PLACE;
        *prize = ITEM_NONE;
        *species = SPECIES_NONE;
        return FALSE;
    }

    BugContest_Judge(contest);
    *placement = contest->placement;
    *prize = contest->prize;
    *species = contest->contestants[BUG_CONTEST_PLAYER].species;
    return FALSE;
}

// The caught Pokémon's name; TRUE if it goes to a box (the party was full).
BOOL CompleteScrCmd_BufferBugContestMonNick(ScriptContext *ctx)
{
    StringTemplate **template = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_STR_TEMPLATE);
    u8 slot = ScriptContext_ReadByte(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    BugContest *contest = sBugContest;

    if (contest == NULL || !contest->caught) {
        *destVar = FALSE;
        return FALSE;
    }

    StringTemplate_SetNickname(*template, slot, Pokemon_GetBoxPokemon(contest->caughtMon));
    *destVar = contest->partyCount >= MAX_PARTY_SIZE;
    return FALSE;
}

// The minutes left, at least 1.
BOOL CompleteScrCmd_BugContestGetTimeLeft(ScriptContext *ctx)
{
    StringTemplate **template = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_STR_TEMPLATE);
    u8 slot = ScriptContext_ReadByte(ctx);
    int left = sBugContest != NULL ? BUG_CONTEST_MINUTES - BugContest_MinutesElapsed(sBugContest) : BUG_CONTEST_MINUTES;

    if (left < 1) {
        left = 1;
    }

    StringTemplate_SetNumber(*template, slot, left, 2, PADDING_MODE_NONE, CHARSET_MODE_EN);
    return FALSE;
}

// Whether entrant (0-9) is in today's contest.
BOOL CompleteScrCmd_IsBugContestantRegistered(ScriptContext *ctx)
{
    u16 id = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = sBugContest != NULL && BugContest_IsEntered(sBugContest, id, BUG_CONTEST_NPCS);
    return FALSE;
}

// HeartGold's naming screen for the caught Pokémon (NicknameInput 255): Platinum's names a party Pokémon, so the caught
// one joins the contest's one-Pokémon party for it (its slot in destVar) and leaves after (BugContestNicknameEnd).
BOOL CompleteScrCmd_BugContestNicknameStart(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    Party *party = SaveData_GetParty(ctx->fieldSystem->saveData);

    *destVar = Party_GetCurrentCount(party);

    if (sBugContest != NULL && sBugContest->caught) {
        Party_AddPokemon(party, sBugContest->caughtMon);
    }

    return FALSE;
}

BOOL CompleteScrCmd_BugContestNicknameEnd(ScriptContext *ctx)
{
    Party *party = SaveData_GetParty(ctx->fieldSystem->saveData);
    int slot = Party_GetCurrentCount(party) - 1;

    if (sBugContest != NULL && sBugContest->caught && slot > 0) {
        Pokemon_Copy(Party_GetPokemonBySlotIndex(party, slot), sBugContest->caughtMon);
        Party_RemovePokemonBySlotIndex(party, slot);
    }

    return FALSE;
}
