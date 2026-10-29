#ifndef POKEPLATINUM_COMPLETE_ENCOUNTERS_H
#define POKEPLATINUM_COMPLETE_ENCOUNTERS_H

#include "generated/map_headers.h"

#include "field/field_system_decl.h"
#include "overlay006/wild_encounters.h"

// Sovereign Complete: Johto's and Kanto's wild Pokémon, Sacred Gold's tables in HeartGold's layout
// (res/field/encounters/hgss, hgss_enc_data.narc; docs/SacredGold.md).

// Fills a Johto or Kanto map's table (MapHeaderData_LoadWildEncounters): the grass slots as in the morning, day and
// night swaps of slots 2 and 3 as HeartGold has them, surfing and the rods.
void CompleteEncounters_Load(WildEncounters *data, enum MapHeaderID mapHeaderID);

// HeartGold keeps all twelve grass slots for each time of day: the species in grass slot `slot` on the field's map at
// this time of day, or 0 off Johto and Kanto (overlay006/wild_encounters.c then keeps its own).
int CompleteEncounters_GrassSpecies(FieldSystem *fieldSystem, int slot);

#endif // POKEPLATINUM_COMPLETE_ENCOUNTERS_H
