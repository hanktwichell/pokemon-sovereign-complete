#include "overlay006/complete_field_encounters.h"

#include <nitro.h>

#include "generated/abilities.h"
#include "generated/items.h"
#include "generated/map_headers.h"
#include "generated/species.h"

#include "field/field_system.h"
#include "overlay006/wild_encounters.h"

#include "complete_encounters.h"
#include "complete_test.h"
#include "field_task.h"
#include "inlines.h"
#include "location.h"
#include "party.h"
#include "player_move.h"
#include "pokemon.h"
#include "save_player.h"
#include "trainer_info.h"

// Sovereign Complete: HeartGold's Headbutt trees and Rock Smash finds (its src/field/headbutt.c,
// src/field/rock_smash_item.c and the Rock Smash encounters of src/field/encounter_check.c), and the Headbutt tutor's
// list, on Johto's and Kanto's maps. The tables are tools/complete/import_hgss_field_encounters.py's.

#define HEADBUTT_SLOTS 6

typedef struct CompleteEncounterSlot {
    u16 species;
    u8 minLevel;
    u8 maxLevel;
} CompleteEncounterSlot;

typedef struct CompleteHeadbuttTile {
    u16 x;
    u16 z;
    u8 tree;
    u8 secret;
} CompleteHeadbuttTile;

typedef struct CompleteHeadbuttTable {
    u16 mapHeaderID;
    u8 numTrees;
    u8 numSecretTrees;
    u16 firstTile;
    u16 numTiles;
    CompleteEncounterSlot slots[3][HEADBUTT_SLOTS]; // common, rare, secret trees
} CompleteHeadbuttTable;

typedef struct CompleteRockSmashFind {
    u16 mapHeaderID;
    u8 odds;
    u8 items;
} CompleteRockSmashFind;

#include "data/hgss_field_encounters.h"

enum HeadbuttTreeType {
    TREE_COMMON = 0,
    TREE_RARE,
    TREE_SECRET,
    TREE_NONE = -1,
};

// HeartGold's sRareTreeLUT_*: by the last digit of the trainer ID, the kind of each of a map's trees (the fifth on
// repeat on a map with more)
static const s8 sTreeTypes1[10][1] = {
    { TREE_COMMON }, { TREE_RARE }, { TREE_COMMON }, { TREE_RARE }, { TREE_COMMON },
    { TREE_RARE }, { TREE_COMMON }, { TREE_RARE }, { TREE_COMMON }, { TREE_RARE },
};

static const s8 sTreeTypes2[10][2] = {
    { TREE_COMMON, TREE_RARE }, { TREE_RARE, TREE_COMMON }, { TREE_COMMON, TREE_RARE }, { TREE_RARE, TREE_COMMON },
    { TREE_COMMON, TREE_RARE }, { TREE_RARE, TREE_COMMON }, { TREE_COMMON, TREE_RARE }, { TREE_RARE, TREE_COMMON },
    { TREE_COMMON, TREE_RARE }, { TREE_RARE, TREE_COMMON },
};

static const s8 sTreeTypes3[10][3] = {
    { TREE_COMMON, TREE_RARE, TREE_NONE },
    { TREE_COMMON, TREE_NONE, TREE_RARE },
    { TREE_RARE, TREE_COMMON, TREE_NONE },
    { TREE_RARE, TREE_NONE, TREE_COMMON },
    { TREE_NONE, TREE_COMMON, TREE_RARE },
    { TREE_NONE, TREE_RARE, TREE_COMMON },
    { TREE_COMMON, TREE_RARE, TREE_NONE },
    { TREE_COMMON, TREE_NONE, TREE_RARE },
    { TREE_RARE, TREE_COMMON, TREE_NONE },
    { TREE_RARE, TREE_NONE, TREE_COMMON },
};

static const s8 sTreeTypes4[10][4] = {
    { TREE_NONE, TREE_COMMON, TREE_COMMON, TREE_RARE },
    { TREE_RARE, TREE_NONE, TREE_COMMON, TREE_COMMON },
    { TREE_RARE, TREE_RARE, TREE_NONE, TREE_COMMON },
    { TREE_COMMON, TREE_RARE, TREE_RARE, TREE_NONE },
    { TREE_COMMON, TREE_COMMON, TREE_RARE, TREE_RARE },
    { TREE_NONE, TREE_COMMON, TREE_RARE, TREE_COMMON },
    { TREE_RARE, TREE_NONE, TREE_COMMON, TREE_RARE },
    { TREE_COMMON, TREE_RARE, TREE_NONE, TREE_COMMON },
    { TREE_RARE, TREE_COMMON, TREE_RARE, TREE_NONE },
    { TREE_COMMON, TREE_RARE, TREE_COMMON, TREE_RARE },
};

static const s8 sTreeTypes5[10][5] = {
    { TREE_NONE, TREE_COMMON, TREE_COMMON, TREE_RARE, TREE_RARE },
    { TREE_RARE, TREE_NONE, TREE_COMMON, TREE_COMMON, TREE_RARE },
    { TREE_RARE, TREE_RARE, TREE_NONE, TREE_COMMON, TREE_COMMON },
    { TREE_COMMON, TREE_RARE, TREE_RARE, TREE_NONE, TREE_COMMON },
    { TREE_COMMON, TREE_COMMON, TREE_RARE, TREE_RARE, TREE_NONE },
    { TREE_NONE, TREE_COMMON, TREE_RARE, TREE_COMMON, TREE_RARE },
    { TREE_RARE, TREE_NONE, TREE_COMMON, TREE_RARE, TREE_COMMON },
    { TREE_COMMON, TREE_RARE, TREE_NONE, TREE_COMMON, TREE_RARE },
    { TREE_RARE, TREE_COMMON, TREE_RARE, TREE_NONE, TREE_COMMON },
    { TREE_COMMON, TREE_RARE, TREE_COMMON, TREE_RARE, TREE_NONE },
};

static BOOL EndAtOnce(FieldTask *task)
{
    return TRUE;
}

// A wild battle with one of the slots, in a task of its own under task, so the battle's task can take its place
static BOOL StartBattle(FieldSystem *fieldSystem, FieldTask *task, const CompleteEncounterSlot *slot)
{
    if (slot->species == SPECIES_NONE) {
        return FALSE;
    }

    return WildEncounters_TryCompleteEncounter(fieldSystem, FieldTask_InitCall(task, EndAtOnce, NULL), slot->species, slot->minLevel, slot->maxLevel);
}

static const CompleteHeadbuttTable *HeadbuttTable(FieldSystem *fieldSystem)
{
    for (int i = 0; i < NELEMS(sHeadbuttTables); i++) {
        if (sHeadbuttTables[i].mapHeaderID == fieldSystem->location->mapHeaderID) {
            return &sHeadbuttTables[i];
        }
    }

    return NULL;
}

static enum HeadbuttTreeType RegularTreeType(int tree, int numTrees, u32 trainerID)
{
    int digit = trainerID % 10;

    switch (numTrees) {
    case 1:
        return sTreeTypes1[digit][0];
    case 2:
        return sTreeTypes2[digit][tree];
    case 3:
        return sTreeTypes3[digit][tree];
    case 4:
        return sTreeTypes4[digit][tree];
    default:
        return sTreeTypes5[digit][tree % 5];
    }
}

// HeartGold's slot odds for a tree: 50%, 15%, 15%, 10%, 5% and 5%
static int HeadbuttSlot(void)
{
    static const u8 sCumulative[HEADBUTT_SLOTS - 1] = { 50, 65, 80, 90, 95 };
    int roll = LCRNG_RandMod(100);
    int slot = 0;

    while (slot < HEADBUTT_SLOTS - 1 && roll >= sCumulative[slot]) {
        slot++;
    }

    return slot;
}

BOOL CompleteFieldEncounters_TryHeadbutt(FieldSystem *fieldSystem, FieldTask *task)
{
    const CompleteHeadbuttTable *table = HeadbuttTable(fieldSystem);
    int x, z;

    if (table == NULL) {
        return FALSE;
    }

    PlayerAvatar_GetFacingTileCoords(fieldSystem->playerAvatar, &x, &z);

    for (int i = table->firstTile; i < table->firstTile + table->numTiles; i++) {
        const CompleteHeadbuttTile *tile = &sHeadbuttTiles[i];

        if (tile->x != x || tile->z != z) {
            continue;
        }

        enum HeadbuttTreeType type = tile->secret ? TREE_SECRET : RegularTreeType(tile->tree, table->numTrees, TrainerInfo_ID(SaveData_GetTrainerInfo(fieldSystem->saveData)));

        if (type == TREE_NONE) {
            return FALSE;
        }

        return StartBattle(fieldSystem, task, &table->slots[type][HeadbuttSlot()]);
    }

    return FALSE;
}

// HeartGold's DrawRockSmashIdx: which of the map's list's eight items
static int RockSmashItemIndex(void)
{
    static const u8 sCumulative[7] = { 25, 45, 55, 65, 75, 85, 95 };
    int roll = LCRNG_RandMod(100);
    int index = 0;

    while (index < 7 && roll >= sCumulative[index]) {
        index++;
    }

    return index;
}

static BOOL TryRockSmashItem(FieldSystem *fieldSystem, u16 *item)
{
    Pokemon *lead = Party_GetPokemonBySlotIndex(SaveData_GetParty(fieldSystem->saveData), 0);
    int ability = Pokemon_GetValue(lead, MON_DATA_IS_EGG, NULL) ? ABILITY_NONE : Pokemon_GetValue(lead, MON_DATA_ABILITY, NULL);

    for (int i = 0; i < NELEMS(sRockSmashFinds); i++) {
        const CompleteRockSmashFind *find = &sRockSmashFinds[i];

        if (find->mapHeaderID != fieldSystem->location->mapHeaderID) {
            continue;
        }

        int odds = find->odds;

        if (ability == ABILITY_SUCTION_CUPS || ability == ABILITY_MAGNET_PULL || ability == ABILITY_KEEN_EYE) {
            odds += 5;
        }

        if (LCRNG_RandMod(100) >= odds) {
            return FALSE;
        }

        int index = RockSmashItemIndex();

        if ((ability == ABILITY_SERENE_GRACE || ability == ABILITY_SUPER_LUCK) && index < 7) {
            index++;
        }

        *item = sRockSmashItems[find->items][index];

#ifdef SOVEREIGN_TEST
        gCompleteTestFieldEncounter.items++;
        gCompleteTestFieldEncounter.item = *item;
#endif

        return TRUE;
    }

    return FALSE;
}

int CompleteFieldEncounters_TryRockSmash(FieldSystem *fieldSystem, FieldTask *task, u16 *item)
{
    CompleteEncounterSlot slot;
    u8 rate = CompleteEncounters_RockSmash(fieldSystem, LCRNG_RandMod(100) >= 80, &slot.species, &slot.minLevel, &slot.maxLevel);

    *item = ITEM_NONE;

    if (rate != 0 && LCRNG_RandMod(100) < rate && StartBattle(fieldSystem, task, &slot)) {
        return COMPLETE_ROCK_SMASH_BATTLE;
    }

    if (TryRockSmashItem(fieldSystem, item)) {
        return COMPLETE_ROCK_SMASH_ITEM;
    }

    return COMPLETE_ROCK_SMASH_NOTHING;
}

BOOL CompleteFieldEncounters_CanLearnHeadbutt(u16 species)
{
    return species < NELEMS(sHeadbuttLearners) * 8 && (sHeadbuttLearners[species / 8] & (1 << (species % 8))) != 0;
}
