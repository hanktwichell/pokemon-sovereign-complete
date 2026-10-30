#ifndef POKEPLATINUM_OV6_COMPLETE_FIELD_ENCOUNTERS_H
#define POKEPLATINUM_OV6_COMPLETE_FIELD_ENCOUNTERS_H

#include "constants/complete_field_encounters.h"

#include "field/field_system_decl.h"

#include "field_task.h"

// Sovereign Complete: HeartGold's Headbutt trees and Rock Smash finds on Johto's and Kanto's maps
// (src/overlay006/complete_field_encounters.c).

// The tree the player faces: on a tree of the kind that has Pokémon for this trainer ID, a wild battle with one of
// them, in a task under task. TRUE if one starts.
BOOL CompleteFieldEncounters_TryHeadbutt(FieldSystem *fieldSystem, FieldTask *task);

// After a rock is smashed: a wild battle at the map's Rock Smash rate (in a task under task), or else an item from
// the map's list at its odds (*item). COMPLETE_ROCK_SMASH_*.
int CompleteFieldEncounters_TryRockSmash(FieldSystem *fieldSystem, FieldTask *task, u16 *item);

// Whether the species can learn Headbutt from Ilex Forest's tutor (HeartGold's list).
BOOL CompleteFieldEncounters_CanLearnHeadbutt(u16 species);

#endif // POKEPLATINUM_OV6_COMPLETE_FIELD_ENCOUNTERS_H
