#include "complete_sinnoh.h"

#include <nitro.h>

#include "constants/narc.h"
#include "constants/pokemon.h"
#include "constants/species.h"
#include "generated/evolution_methods.h"
#include "generated/species.h"

#include "struct_defs/species.h"
#include "struct_defs/trainer_data.h"

#include "data/complete_sinnoh.h"
#include "data/hgss_trainers.h"

#include "complete_map_info.h"
#include "narc.h"
#include "party.h"
#include "pokemon.h"
#include "savedata.h"
#include "system_vars.h"
#include "vars_flags.h"

// Sovereign Complete: Sinnoh comes third, after Johto and Kanto, so its levels move up to follow Kanto's (the owner's
// call, Nov 1, 2026: a provisional integration of Claude's own; data/complete/sinnoh.yaml says by how much). Sinnoh's
// trainers' Pokémon take their new level as the party is made (TrainerData_BuildParty), evolved to match; wild Pokémon
// on Sinnoh's maps take theirs as they're made (wild_encounters.c), its legendaries and Totems too, and keep their
// species unless the plan says otherwise. Johto's and Kanto's trainers and maps keep Sacred Gold's levels.

static BOOL sOnSinnohMap;

void CompleteSinnoh_OnMapLoaded(int mapHeaderID)
{
    sOnSinnohMap = !MapHeader_IsHGSS(mapHeaderID);
}

// Sovereign's level -> the level here, straight between the plan's points
int CompleteSinnoh_Level(int level)
{
    for (int i = 0; i + 1 < NELEMS(sCompleteSinnohLevels); i++) {
        int a = sCompleteSinnohLevels[i][0], b = sCompleteSinnohLevels[i][1];
        int c = sCompleteSinnohLevels[i + 1][0], e = sCompleteSinnohLevels[i + 1][1];

        if (level >= a && level <= c) {
            return b + ((level - a) * (e - b) * 2 + (c - a)) / ((c - a) * 2); // rounded
        }
    }

    return level > MAX_POKEMON_LEVEL ? MAX_POKEMON_LEVEL : level;
}

// The evolutions whose parameter is the level they happen at
static BOOL EvolvesAtLevel(u16 method)
{
    switch (method) {
    case EVO_LEVEL:
    case EVO_LEVEL_ATK_GT_DEF:
    case EVO_LEVEL_ATK_EQ_DEF:
    case EVO_LEVEL_ATK_LT_DEF:
    case EVO_LEVEL_PID_LOW:
    case EVO_LEVEL_PID_HIGH:
    case EVO_LEVEL_NINJASK:
    case EVO_LEVEL_MALE:
    case EVO_LEVEL_FEMALE:
        return TRUE;
    default:
        return FALSE;
    }
}

// The species, evolved as far as this level takes it: by the level it evolves at, or, for a stone, a trade,
// friendship and the like, from the plan's levels on (the first evolution, then the second)
int CompleteSinnoh_EvolvedSpecies(int species, int level)
{
    for (int stage = 0; stage < 2 && species > SPECIES_NONE && species < NATIONAL_DEX_COUNT + 1; stage++) {
        SpeciesEvolution evolutions[MAX_EVOLUTIONS];
        int next = SPECIES_NONE;

        NARC_ReadWholeMemberByIndexPair(evolutions, NARC_INDEX_POKETOOL__PERSONAL__EVO, species);

        for (int i = 0; i < MAX_EVOLUTIONS && next == SPECIES_NONE; i++) {
            u16 method = evolutions[i].method;

            if (method == EVO_NONE || method == EVO_LEVEL_SHEDINJA) {
                continue;
            }

            int at = EvolvesAtLevel(method) ? evolutions[i].param
                                            : (stage == 0 ? COMPLETE_SINNOH_EVOLVE_FIRST : COMPLETE_SINNOH_EVOLVE_SECOND);

            if (level >= at) {
                next = evolutions[i].targetSpecies;
            }
        }

        if (next == SPECIES_NONE) {
            break;
        }

        species = next;
    }

    return species;
}

// After a trainer's party data is read (TrainerData_BuildParty): a Sinnoh trainer's Pokémon at their new levels,
// evolved to match. Every layout begins with the IV scale, the level and the species (with the form in its top bits
// but in Sovereign's own layout).
void CompleteSinnoh_ScaleParty(int trainerID, void *party, int monDataType, int count)
{
    static const u8 sizes[] = {
        [TRDATATYPE_BASE] = sizeof(TrainerMonBase),
        [TRDATATYPE_WITH_MOVES] = sizeof(TrainerMonWithMoves),
        [TRDATATYPE_WITH_ITEM] = sizeof(TrainerMonWithItem),
        [TRDATATYPE_WITH_MOVES_AND_ITEM] = sizeof(TrainerMonWithMovesAndItem),
        [TRDATATYPE_SOVEREIGN] = sizeof(TrainerMonSovereign),
    };

    if (trainerID >= TRAINER_HGSS_FIRST || monDataType >= NELEMS(sizes)) {
        return;
    }

    for (int i = 0; i < count; i++) {
        u16 *mon = (u16 *)((u8 *)party + i * sizes[monDataType]);
        u16 mask = monDataType == TRDATATYPE_SOVEREIGN ? 0xFFFF : TRAINER_MON_SPECIES_MASK;
        int level = CompleteSinnoh_Level(mon[1]);
        int species = mon[2] & mask;
        int evolved = CompleteSinnoh_EvolvedSpecies(species, level);

        mon[1] = level;

        if (evolved != species) {
            mon[2] = (mon[2] & ~mask) | evolved; // the form stays: a regional form evolves into the same form
        }
    }
}

// A wild Pokémon's level as it's made (wild_encounters.c): on a Sinnoh map, moved up
u8 CompleteSinnoh_WildLevel(u8 level)
{
    return sOnSinnohMap ? CompleteSinnoh_Level(level) : level;
}

// The species it first evolves into, or SPECIES_NONE
static int FirstEvolution(int species)
{
    SpeciesEvolution evolutions[MAX_EVOLUTIONS];

    NARC_ReadWholeMemberByIndexPair(evolutions, NARC_INDEX_POKETOOL__PERSONAL__EVO, species);
    return evolutions[0].method == EVO_NONE ? SPECIES_NONE : evolutions[0].targetSpecies;
}

// The party slot of the player's starter from Rowan's briefcase, or of what it evolved into (the last such in the
// party), or MAX_PARTY_SIZE when it's in the PC. Platinum's lab scene looks at slot 0, which here is the team the
// player brought from Johto and Kanto (res/field/scripts/scripts_sandgem_town_pokemon_research_lab.s).
int CompleteSinnoh_StarterSlot(SaveData *saveData)
{
    Party *party = SaveData_GetParty(saveData);
    int line[3];

    line[0] = SystemVars_GetPlayerStarter(SaveData_GetVarsFlags(saveData));
    line[1] = FirstEvolution(line[0]);
    line[2] = line[1] == SPECIES_NONE ? SPECIES_NONE : FirstEvolution(line[1]);

    for (int slot = Party_GetCurrentCount(party) - 1; slot >= 0; slot--) {
        Pokemon *mon = Party_GetPokemonBySlotIndex(party, slot);
        int species = Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL);

        if (Pokemon_GetValue(mon, MON_DATA_IS_EGG, NULL) == FALSE
            && (species == line[0] || (species != SPECIES_NONE && (species == line[1] || species == line[2])))) {
            return slot;
        }
    }

    return MAX_PARTY_SIZE;
}
