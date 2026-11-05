#include "overlay005/complete_daycare.h"

#include <nitro.h>

#include "constants/map_object.h"
#include "generated/map_headers.h"
#include "generated/movement_types.h"
#include "generated/species.h"

#include "field/field_system.h"

#include "complete_follower.h"
#include "daycare_save.h"
#include "location.h"
#include "map_object.h"
#include "pokemon.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's UpdateDaycareMonObjects (its scrcmd_daycare.c). The Pokémon left at the Route 34 Day
// Care stand in the house's yard, seen through its window, each as its walking sprite (the following Pokémon's, its
// shiny colours if shiny): the first at (8, 5), the second at (10, 9), looking about as HeartGold's do. The house's
// init script makes them again each time its map comes back; elsewhere this does nothing.

#define FIRST_LOCALID 250 // HeartGold's obj_daycare_poke_1 and 2

BOOL CompleteScrCmd_UpdateDaycareMonObjects(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    Daycare *daycare = SaveData_GetDaycare(fieldSystem->saveData);

    if (fieldSystem->location->mapHeaderID != MAP_HEADER_HGSS_ROUTE_34_DAYCARE) {
        return FALSE;
    }

    for (int i = 0, x = 8, z = 5; i < 2; i++, x += 2, z += 4) {
        MapObject *mon = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, FIRST_LOCALID + i);

        if (mon != NULL) {
            MapObject_Delete(mon);
        }

        BoxPokemon *boxMon = DaycareMon_GetBoxMon(Daycare_GetDaycareMon(daycare, i));
        int species = BoxPokemon_GetValue(boxMon, MON_DATA_SPECIES, NULL);

        if (species == SPECIES_NONE) {
            continue;
        }

        BOOL shiny = Pokemon_IsPersonalityShiny(BoxPokemon_GetValue(boxMon, MON_DATA_OT_ID, NULL), BoxPokemon_GetValue(boxMon, MON_DATA_PERSONALITY, NULL));
        int gfx = CompleteFollower_MonGfx(species, BoxPokemon_GetValue(boxMon, MON_DATA_FORM, NULL), BoxPokemon_GetGender(boxMon), shiny);

        if (gfx < 0) {
            continue;
        }

        mon = MapObjectMan_AddMapObject(fieldSystem->mapObjMan, x, z, DIR_SOUTH, gfx, MOVEMENT_TYPE_LOOK_NORTH_SOUTH_AND_EAST, fieldSystem->location->mapHeaderID);

        if (mon != NULL) {
            MapObject_SetLocalID(mon, FIRST_LOCALID + i);
        }
    }

    return FALSE;
}
