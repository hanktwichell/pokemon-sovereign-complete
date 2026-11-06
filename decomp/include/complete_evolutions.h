#ifndef POKEPLATINUM_COMPLETE_EVOLUTIONS_H
#define POKEPLATINUM_COMPLETE_EVOLUTIONS_H

#include "struct_defs/species.h"

// Sovereign Complete: Sacred Gold's evolution items (docs/SacredGold.md), used from the bag like a stone in place of
// a trade or a place. The species the item evolves into, from the species' own evolutions (as loaded, so a regional
// form's), or SPECIES_NONE.
u16 CompleteEvolution_ByItem(u16 species, const SpeciesEvolution *evolutions, u16 item);

// Sovereign Complete: trade evolutions without trading (the owner's call, Nov 6, 2026). A trade with a held item
// (Onix's Metal Coat) evolves it when the item is used from the bag, as a stone does (CompleteEvolution_ByItem; the
// items' field use is ITEM_USE_FUNC_EVO_STONE in res/items/data), and a trade with none (Kadabra, Machoke, Graveler,
// Haunter) is also a level-up evolution at this level. Sacred Gold's Covenant Orb still evolves those at any level.
#define COMPLETE_TRADE_EVOLUTION_LEVEL 37

#endif // POKEPLATINUM_COMPLETE_EVOLUTIONS_H
