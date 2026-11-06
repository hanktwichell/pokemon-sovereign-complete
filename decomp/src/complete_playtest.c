#include "complete_playtest.h"

#ifdef COMPLETE_PLAYTEST

#include <nitro.h>

#include "constants/hgss_spawns.h"
#include "constants/items.h"
#include "constants/species.h"
#include "generated/moves.h"

#include "field/field_system.h"

#include "heap.h"
#include "party.h"
#include "pokemon.h"
#include "save_catchrecords.h"
#include "savedata.h"
#include "spawn_locations.h"
#include "trainer_info.h"

// Every spawn point, Platinum's then HeartGold's (src/spawn_locations.c checks the same count)
#define SPAWN_COUNT (SPAWN_HGSS_FIRST - 1 + SPAWN_HGSS_COUNT)

// A Pokémon caught by the player (as Pokemon_GiveMonFromScript gives one, but at the level asked on any map), with
// the given moves; MOVE_NONE keeps the move it learned by its level in that slot.
static void GiveMon(FieldSystem *fieldSystem, u16 species, u8 level, u16 item, const u16 *moves)
{
    SaveData *saveData = fieldSystem->saveData;
    Pokemon *mon = Pokemon_New(HEAP_ID_FIELD2);
    u32 heldItem = item;

    Pokemon_Init(mon);
    Pokemon_InitWith(mon, species, level, INIT_IVS_RANDOM, FALSE, 0, OTID_NOT_SET, 0);
    Pokemon_SetCatchData(mon, SaveData_GetTrainerInfo(saveData), ITEM_POKE_BALL, 0, 0, HEAP_ID_FIELD2);
    Pokemon_SetValue(mon, MON_DATA_HELD_ITEM, &heldItem);

    for (u8 slot = 0; slot < LEARNED_MOVES_MAX; slot++) {
        if (moves[slot] != MOVE_NONE) {
            Pokemon_SetMoveSlot(mon, moves[slot], slot);
        }
    }

    if (Party_AddPokemon(SaveData_GetParty(saveData), mon)) {
        SaveData_UpdateCatchRecords(saveData, mon);
    }

    Heap_Free(mon);
}

// Runs once, after the new game's own setup (FieldSystem_InitNewGameState). HEAP_ID_FIELD2 exists this early.
void CompletePlaytest_SetupNewGame(FieldSystem *fieldSystem)
{
    // Champion Cynthia's Garchomp (res/trainers/data/champion_cynthia.json): its moves and its Yache Berry
    static const u16 garchompMoves[LEARNED_MOVES_MAX] = { MOVE_EARTHQUAKE, MOVE_OUTRAGE, MOVE_STONE_EDGE, MOVE_SWORDS_DANCE };
    // Fly and Surf in the last slot, after the three latest moves of their level
    static const u16 staraptorMoves[LEARNED_MOVES_MAX] = { MOVE_NONE, MOVE_NONE, MOVE_NONE, MOVE_FLY };
    static const u16 empoleonMoves[LEARNED_MOVES_MAX] = { MOVE_NONE, MOVE_NONE, MOVE_NONE, MOVE_SURF };

    GiveMon(fieldSystem, SPECIES_GARCHOMP, 80, ITEM_YACHE_BERRY, garchompMoves);
    GiveMon(fieldSystem, SPECIES_STARAPTOR, 50, ITEM_NONE, staraptorMoves);
    GiveMon(fieldSystem, SPECIES_EMPOLEON, 50, ITEM_NONE, empoleonMoves);

    // Every Fly point of the three regions, as arriving in each town records it
    for (int spawn = 1; spawn <= SPAWN_COUNT; spawn++) {
        enum MapHeaderID flyMap = GetFlyLocationMap(spawn);

        if (flyMap != MAP_HEADER_EVERYWHERE) {
            TryUnlockFlyLocationByMap(fieldSystem, flyMap);
        }
    }
}

// Fly and Surf work without their badges (src/complete_badges.c)
BOOL CompletePlaytest_AllowsFieldMove(enum Badge sinnohBadge)
{
    return sinnohBadge == BADGE_ID_COBBLE || sinnohBadge == BADGE_ID_FEN;
}

#endif // COMPLETE_PLAYTEST
