#ifndef POKEPLATINUM_COMPLETE_EVOLUTIONS_H
#define POKEPLATINUM_COMPLETE_EVOLUTIONS_H

#include "struct_defs/species.h"

// Sovereign Complete: Sacred Gold's evolution items (docs/SacredGold.md), used from the bag like a stone in place of
// a trade or a place. The species the item evolves into, from the species' own evolutions (as loaded, so a regional
// form's), or SPECIES_NONE.
u16 CompleteEvolution_ByItem(u16 species, const SpeciesEvolution *evolutions, u16 item);

#endif // POKEPLATINUM_COMPLETE_EVOLUTIONS_H
