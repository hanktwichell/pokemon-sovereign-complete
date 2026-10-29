#include "complete_evolutions.h"

#include <nitro.h>

#include "constants/items.h"
#include "constants/species.h"
#include "generated/evolution_methods.h"

#include "pokemon.h"

// Sovereign Complete: Sacred Gold's evolution items (include/complete_evolutions.h). Each stands for one way of
// evolving: the Covenant Orb for a trade with no held item (Kadabra, Machoke, Graveler, Haunter, and the later
// generations' Boldore, Gurdurr, Phantump, Pumpkaboo), the Voltaic Ore for Mt. Coronet's magnetic field (Magneton,
// Nosepass), the Woodland and Chilled Ores for the Moss and Ice Rocks, and the Aubade and Serenade Orbs for Eevee's
// friendship by day (Espeon) and by night (Umbreon). The species' own ways still work.
static const struct {
    u16 item;
    u16 method;
    u16 species; // only this species, or SPECIES_NONE for any with the method
} sItemMethods[] = {
    { ITEM_COVENANT_ORB, EVO_TRADE, SPECIES_NONE },
    { ITEM_VOLTAIC_ORE, EVO_LEVEL_MAGNETIC_FIELD, SPECIES_NONE },
    { ITEM_WOODLAND_ORE, EVO_LEVEL_MOSS_ROCK, SPECIES_NONE },
    { ITEM_CHILLED_ORE, EVO_LEVEL_ICE_ROCK, SPECIES_NONE },
    { ITEM_AUBADE_ORB, EVO_LEVEL_HAPPINESS_DAY, SPECIES_EEVEE },
    { ITEM_SERENADE_ORB, EVO_LEVEL_HAPPINESS_NIGHT, SPECIES_EEVEE },
};

u16 CompleteEvolution_ByItem(u16 species, const SpeciesEvolution *evolutions, u16 item)
{
    for (int i = 0; i < NELEMS(sItemMethods); i++) {
        if (sItemMethods[i].item != item
            || (sItemMethods[i].species != SPECIES_NONE && sItemMethods[i].species != species)) {
            continue;
        }

        for (int j = 0; j < MAX_EVOLUTIONS; j++) {
            if (evolutions[j].method == sItemMethods[i].method) {
                return evolutions[j].targetSpecies;
            }
        }
    }

    return SPECIES_NONE;
}
