#include "roaming_pokemon.h"

#include <nitro.h>
#include <string.h>

#include "constants/species.h"
#include "generated/map_headers.h"

#include "struct_defs/special_encounter.h"

#include "heap.h"
#include "inlines.h"
#include "pokemon.h"
#include "save_player.h"
#include "savedata.h"
#include "special_encounter.h"
#include "trainer_info.h"

typedef struct NearbyRoutes {
    u16 numPossibilities;
    u16 adjacentRouteIndexes[6]; // Sovereign Complete: 6 for HeartGold's Route 5
} NearbyRoutes;

static void MoveRoamerRandom(SpecialEncounter *speEnc, const u8 roamerSlot, const int playerPreviousMap);
static void MoveRoamerNearby(SpecialEncounter *param0, const u8 roamerSlot, const int playerPreviousMap);
static void SetNewMapLocation(SpecialEncounter *speEnc, const u8 roamerSlot, const u8 newMapIndex, const int newMapId);

// Includes adjacent routes as well as routes connected to adjacent towns.
// e.g. Route 202's entry includes both routes connected to Sandgem Town and all 3 routes connected to Jubilife City.
static const NearbyRoutes sNearbyRoutes[RI_MAX] = {
    [RI_ROUTE_201] = {
        2,
        { RI_ROUTE_202, RI_ROUTE_219, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_202] = {
        5,
        { RI_ROUTE_201, RI_ROUTE_203, RI_ROUTE_204_SOUTH, RI_ROUTE_218, RI_ROUTE_219 },
    },
    [RI_ROUTE_203] = {
        4,
        { RI_ROUTE_202, RI_ROUTE_204_SOUTH, RI_ROUTE_207, RI_ROUTE_218, 0xFFFF },
    },
    [RI_ROUTE_204_SOUTH] = {
        4,
        { RI_ROUTE_202, RI_ROUTE_203, RI_ROUTE_204_NORTH, RI_ROUTE_218, 0xFFFF },
    },
    [RI_ROUTE_204_NORTH] = {
        2,
        { RI_ROUTE_204_SOUTH, RI_ROUTE_205_SOUTH, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_205_SOUTH] = {
        4,
        { RI_ROUTE_204_NORTH, RI_ROUTE_205_NORTH, RI_VALLEY_WINDWORKS_OUTSIDE, RI_FUEGO_IRONWORKS_OUTSIDE, 0xFFFF },
    },
    [RI_ROUTE_205_NORTH] = {
        3,
        { RI_ROUTE_205_SOUTH, RI_ROUTE_206, 9, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_206] = {
        3,
        { RI_ROUTE_205_NORTH, RI_ROUTE_207, RI_ROUTE_211_WEST, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_207] = {
        3,
        { RI_ROUTE_203, RI_ROUTE_206, RI_ROUTE_208, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_208] = {
        3,
        { RI_ROUTE_207, RI_ROUTE_209, RI_ROUTE_212_NORTH, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_209] = {
        3,
        { RI_ROUTE_208, RI_ROUTE_210_SOUTH, RI_ROUTE_212_NORTH, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_210_SOUTH] = {
        3,
        { RI_ROUTE_209, RI_ROUTE_210_NORTH, RI_ROUTE_215, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_210_NORTH] = {
        2,
        { RI_ROUTE_210_SOUTH, RI_ROUTE_211_EAST, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_211_WEST] = {
        4,
        { RI_ROUTE_205_NORTH, RI_ROUTE_206, RI_ROUTE_211_EAST, RI_ROUTE_216, 0xFFFF },
    },
    [RI_ROUTE_211_EAST] = {
        3,
        { RI_ROUTE_210_NORTH, RI_ROUTE_211_WEST, RI_ROUTE_216, 0xFFFF },
    },
    [RI_ROUTE_212_NORTH] = {
        3,
        { RI_ROUTE_208, RI_ROUTE_209, RI_ROUTE_212_SOUTH, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_212_SOUTH] = {
        2,
        { RI_ROUTE_212_NORTH, RI_ROUTE_213, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_213] = {
        3,
        { RI_ROUTE_212_SOUTH, RI_ROUTE_214, RI_ROUTE_222, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_214] = {
        3,
        { RI_ROUTE_213, RI_ROUTE_215, RI_ROUTE_222, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_215] = {
        2,
        { RI_ROUTE_210_SOUTH, RI_ROUTE_214, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_216] = {
        3,
        { RI_ROUTE_211_WEST, RI_ROUTE_211_EAST, RI_ROUTE_217, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_217] = {
        1,
        { RI_ROUTE_216, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_218] = {
        3,
        { RI_ROUTE_202, RI_ROUTE_203, RI_ROUTE_204_SOUTH, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_219] = {
        3,
        { RI_ROUTE_201, RI_ROUTE_202, RI_ROUTE_220, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_220] = {
        2,
        { RI_ROUTE_219, RI_ROUTE_221, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_221] = {
        1,
        { RI_ROUTE_220, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_ROUTE_222] = {
        2,
        { RI_ROUTE_213, RI_ROUTE_214, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_VALLEY_WINDWORKS_OUTSIDE] = {
        1,
        { RI_ROUTE_205_SOUTH, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_FUEGO_IRONWORKS_OUTSIDE] = {
        1,
        { RI_ROUTE_205_SOUTH, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    // Sovereign Complete: HeartGold's roaming routes and their neighbours (its sRoamerAdjacencyTable)
    [RI_HGSS_ROUTE_29] = {
        2,
        { RI_HGSS_ROUTE_30, RI_HGSS_ROUTE_46, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_30] = {
        2,
        { RI_HGSS_ROUTE_29, RI_HGSS_ROUTE_31, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_31] = {
        3,
        { RI_HGSS_ROUTE_30, RI_HGSS_ROUTE_32, RI_HGSS_ROUTE_36, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_32] = {
        3,
        { RI_HGSS_ROUTE_31, RI_HGSS_ROUTE_33, RI_HGSS_ROUTE_36, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_33] = {
        2,
        { RI_HGSS_ROUTE_32, RI_HGSS_ROUTE_34, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_34] = {
        2,
        { RI_HGSS_ROUTE_33, RI_HGSS_ROUTE_35, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_35] = {
        2,
        { RI_HGSS_ROUTE_34, RI_HGSS_ROUTE_36, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_36] = {
        3,
        { RI_HGSS_ROUTE_31, RI_HGSS_ROUTE_32, RI_HGSS_ROUTE_37, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_37] = {
        3,
        { RI_HGSS_ROUTE_36, RI_HGSS_ROUTE_38, RI_HGSS_ROUTE_42, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_38] = {
        3,
        { RI_HGSS_ROUTE_37, RI_HGSS_ROUTE_39, RI_HGSS_ROUTE_42, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_39] = {
        1,
        { RI_HGSS_ROUTE_38, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_42] = {
        4,
        { RI_HGSS_ROUTE_37, RI_HGSS_ROUTE_38, RI_HGSS_ROUTE_43, RI_HGSS_ROUTE_44, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_43] = {
        2,
        { RI_HGSS_ROUTE_42, RI_HGSS_ROUTE_44, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_44] = {
        3,
        { RI_HGSS_ROUTE_42, RI_HGSS_ROUTE_43, RI_HGSS_ROUTE_46, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_45] = {
        2,
        { RI_HGSS_ROUTE_44, RI_HGSS_ROUTE_46, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_46] = {
        2,
        { RI_HGSS_ROUTE_29, RI_HGSS_ROUTE_45, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_1] = {
        2,
        { RI_HGSS_ROUTE_2, RI_HGSS_ROUTE_22, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_2] = {
        3,
        { RI_HGSS_ROUTE_1, RI_HGSS_ROUTE_22, RI_HGSS_ROUTE_3, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_3] = {
        2,
        { RI_HGSS_ROUTE_2, RI_HGSS_ROUTE_4, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_4] = {
        3,
        { RI_HGSS_ROUTE_3, RI_HGSS_ROUTE_5, RI_HGSS_ROUTE_24, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_5] = {
        6,
        { RI_HGSS_ROUTE_4, RI_HGSS_ROUTE_6, RI_HGSS_ROUTE_7, RI_HGSS_ROUTE_8, RI_HGSS_ROUTE_9, RI_HGSS_ROUTE_24 },
    },
    [RI_HGSS_ROUTE_6] = {
        3,
        { RI_HGSS_ROUTE_7, RI_HGSS_ROUTE_8, RI_HGSS_ROUTE_11, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_7] = {
        4,
        { RI_HGSS_ROUTE_5, RI_HGSS_ROUTE_6, RI_HGSS_ROUTE_8, RI_HGSS_ROUTE_16, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_8] = {
        5,
        { RI_HGSS_ROUTE_5, RI_HGSS_ROUTE_6, RI_HGSS_ROUTE_7, RI_HGSS_ROUTE_10, RI_HGSS_ROUTE_12, 0xFFFF },
    },
    [RI_HGSS_ROUTE_9] = {
        4,
        { RI_HGSS_ROUTE_4, RI_HGSS_ROUTE_5, RI_HGSS_ROUTE_10, RI_HGSS_ROUTE_24, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_10] = {
        3,
        { RI_HGSS_ROUTE_8, RI_HGSS_ROUTE_9, RI_HGSS_ROUTE_12, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_11] = {
        2,
        { RI_HGSS_ROUTE_6, RI_HGSS_ROUTE_12, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_12] = {
        4,
        { RI_HGSS_ROUTE_8, RI_HGSS_ROUTE_10, RI_HGSS_ROUTE_11, RI_HGSS_ROUTE_13, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_13] = {
        2,
        { RI_HGSS_ROUTE_12, RI_HGSS_ROUTE_14, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_14] = {
        2,
        { RI_HGSS_ROUTE_13, RI_HGSS_ROUTE_15, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_15] = {
        3,
        { RI_HGSS_ROUTE_14, RI_HGSS_ROUTE_18, RI_HGSS_ROUTE_19, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_16] = {
        2,
        { RI_HGSS_ROUTE_7, RI_HGSS_ROUTE_22, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_17] = {
        2,
        { RI_HGSS_ROUTE_16, RI_HGSS_ROUTE_18, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_18] = {
        3,
        { RI_HGSS_ROUTE_15, RI_HGSS_ROUTE_17, RI_HGSS_ROUTE_19, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_19] = {
        2,
        { RI_HGSS_ROUTE_15, RI_HGSS_ROUTE_18, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_20] = {
        2,
        { RI_HGSS_ROUTE_19, RI_HGSS_ROUTE_21, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_21] = {
        2,
        { RI_HGSS_ROUTE_1, RI_HGSS_ROUTE_19, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_22] = {
        4,
        { RI_HGSS_ROUTE_1, RI_HGSS_ROUTE_2, RI_HGSS_ROUTE_26, RI_HGSS_ROUTE_28, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_24] = {
        3,
        { RI_HGSS_ROUTE_4, RI_HGSS_ROUTE_5, RI_HGSS_ROUTE_9, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_26] = {
        2,
        { RI_HGSS_ROUTE_22, RI_HGSS_ROUTE_28, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF },
    },
    [RI_HGSS_ROUTE_28] = {
        3,
        { RI_HGSS_ROUTE_22, RI_HGSS_ROUTE_26, RI_HGSS_ROUTE_9, 0xFFFF, 0xFFFF, 0xFFFF },
    },
};

// All outdoor areas with encounters on the mainland except Trophy Garden, Great Marsh, and the ones past Sunyshore City
static const int RoamingPokemonRoutes[RI_MAX] = {
    [RI_ROUTE_201] = MAP_HEADER_ROUTE_201,
    [RI_ROUTE_202] = MAP_HEADER_ROUTE_202,
    [RI_ROUTE_203] = MAP_HEADER_ROUTE_203,
    [RI_ROUTE_204_SOUTH] = MAP_HEADER_ROUTE_204_SOUTH,
    [RI_ROUTE_204_NORTH] = MAP_HEADER_ROUTE_204_NORTH,
    [RI_ROUTE_205_SOUTH] = MAP_HEADER_ROUTE_205_SOUTH,
    [RI_ROUTE_205_NORTH] = MAP_HEADER_ROUTE_205_NORTH,
    [RI_ROUTE_206] = MAP_HEADER_ROUTE_206,
    [RI_ROUTE_207] = MAP_HEADER_ROUTE_207,
    [RI_ROUTE_208] = MAP_HEADER_ROUTE_208,
    [RI_ROUTE_209] = MAP_HEADER_ROUTE_209,
    [RI_ROUTE_210_SOUTH] = MAP_HEADER_ROUTE_210_SOUTH,
    [RI_ROUTE_210_NORTH] = MAP_HEADER_ROUTE_210_NORTH,
    [RI_ROUTE_211_WEST] = MAP_HEADER_ROUTE_211_WEST,
    [RI_ROUTE_211_EAST] = MAP_HEADER_ROUTE_211_EAST,
    [RI_ROUTE_212_NORTH] = MAP_HEADER_ROUTE_212_NORTH,
    [RI_ROUTE_212_SOUTH] = MAP_HEADER_ROUTE_212_SOUTH,
    [RI_ROUTE_213] = MAP_HEADER_ROUTE_213,
    [RI_ROUTE_214] = MAP_HEADER_ROUTE_214,
    [RI_ROUTE_215] = MAP_HEADER_ROUTE_215,
    [RI_ROUTE_216] = MAP_HEADER_ROUTE_216,
    [RI_ROUTE_217] = MAP_HEADER_ROUTE_217,
    [RI_ROUTE_218] = MAP_HEADER_ROUTE_218,
    [RI_ROUTE_219] = MAP_HEADER_ROUTE_219,
    [RI_ROUTE_220] = MAP_HEADER_ROUTE_220,
    [RI_ROUTE_221] = MAP_HEADER_ROUTE_221,
    [RI_ROUTE_222] = MAP_HEADER_ROUTE_222,
    [RI_VALLEY_WINDWORKS_OUTSIDE] = MAP_HEADER_VALLEY_WINDWORKS_OUTSIDE,
    [RI_FUEGO_IRONWORKS_OUTSIDE] = MAP_HEADER_FUEGO_IRONWORKS_OUTSIDE,
    // Sovereign Complete
    [RI_HGSS_ROUTE_29] = MAP_HEADER_HGSS_ROUTE_29,
    [RI_HGSS_ROUTE_30] = MAP_HEADER_HGSS_ROUTE_30,
    [RI_HGSS_ROUTE_31] = MAP_HEADER_HGSS_ROUTE_31,
    [RI_HGSS_ROUTE_32] = MAP_HEADER_HGSS_ROUTE_32,
    [RI_HGSS_ROUTE_33] = MAP_HEADER_HGSS_ROUTE_33,
    [RI_HGSS_ROUTE_34] = MAP_HEADER_HGSS_ROUTE_34,
    [RI_HGSS_ROUTE_35] = MAP_HEADER_HGSS_ROUTE_35,
    [RI_HGSS_ROUTE_36] = MAP_HEADER_HGSS_ROUTE_36,
    [RI_HGSS_ROUTE_37] = MAP_HEADER_HGSS_ROUTE_37,
    [RI_HGSS_ROUTE_38] = MAP_HEADER_HGSS_ROUTE_38,
    [RI_HGSS_ROUTE_39] = MAP_HEADER_HGSS_ROUTE_39,
    [RI_HGSS_ROUTE_42] = MAP_HEADER_HGSS_ROUTE_42,
    [RI_HGSS_ROUTE_43] = MAP_HEADER_HGSS_ROUTE_43,
    [RI_HGSS_ROUTE_44] = MAP_HEADER_HGSS_ROUTE_44,
    [RI_HGSS_ROUTE_45] = MAP_HEADER_HGSS_ROUTE_45,
    [RI_HGSS_ROUTE_46] = MAP_HEADER_HGSS_ROUTE_46,
    [RI_HGSS_ROUTE_1] = MAP_HEADER_HGSS_ROUTE_1,
    [RI_HGSS_ROUTE_2] = MAP_HEADER_HGSS_ROUTE_2,
    [RI_HGSS_ROUTE_3] = MAP_HEADER_HGSS_ROUTE_3,
    [RI_HGSS_ROUTE_4] = MAP_HEADER_HGSS_ROUTE_4,
    [RI_HGSS_ROUTE_5] = MAP_HEADER_HGSS_ROUTE_5,
    [RI_HGSS_ROUTE_6] = MAP_HEADER_HGSS_ROUTE_6,
    [RI_HGSS_ROUTE_7] = MAP_HEADER_HGSS_ROUTE_7,
    [RI_HGSS_ROUTE_8] = MAP_HEADER_HGSS_ROUTE_8,
    [RI_HGSS_ROUTE_9] = MAP_HEADER_HGSS_ROUTE_9,
    [RI_HGSS_ROUTE_10] = MAP_HEADER_HGSS_ROUTE_10,
    [RI_HGSS_ROUTE_11] = MAP_HEADER_HGSS_ROUTE_11,
    [RI_HGSS_ROUTE_12] = MAP_HEADER_HGSS_ROUTE_12,
    [RI_HGSS_ROUTE_13] = MAP_HEADER_HGSS_ROUTE_13,
    [RI_HGSS_ROUTE_14] = MAP_HEADER_HGSS_ROUTE_14,
    [RI_HGSS_ROUTE_15] = MAP_HEADER_HGSS_ROUTE_15,
    [RI_HGSS_ROUTE_16] = MAP_HEADER_HGSS_ROUTE_16,
    [RI_HGSS_ROUTE_17] = MAP_HEADER_HGSS_ROUTE_17,
    [RI_HGSS_ROUTE_18] = MAP_HEADER_HGSS_ROUTE_18,
    [RI_HGSS_ROUTE_19] = MAP_HEADER_HGSS_ROUTE_19,
    [RI_HGSS_ROUTE_20] = MAP_HEADER_HGSS_ROUTE_20,
    [RI_HGSS_ROUTE_21] = MAP_HEADER_HGSS_ROUTE_21,
    [RI_HGSS_ROUTE_22] = MAP_HEADER_HGSS_ROUTE_22,
    [RI_HGSS_ROUTE_24] = MAP_HEADER_HGSS_ROUTE_24,
    [RI_HGSS_ROUTE_26] = MAP_HEADER_HGSS_ROUTE_26,
    [RI_HGSS_ROUTE_28] = MAP_HEADER_HGSS_ROUTE_28,
};

void RoamingPokemon_MoveToRandomMap(SpecialEncounter *speEnc, const u8 roamerSlot)
{
    int previousMap = SpecialEncounter_GetPlayerPreviousMap(speEnc);
    MoveRoamerRandom(speEnc, roamerSlot, previousMap);
}

// Used when Teleporting/Flying
void RoamingPokemon_RandomizeAllLocations(SpecialEncounter *speEnc)
{
    for (u8 i = 0; i < ROAMING_SLOT_MAX; i++) {
        if (SpecialEncounter_IsRoamerActive(speEnc, i)) {
            RoamingPokemon_MoveToRandomMap(speEnc, i);
        }
    }
}

// Moves all Roamers. For each, it has a 1/16 chance to randomize its location. Otherwise, it will move to a nearby route.
void RoamingPokemon_MoveAllLocations(SpecialEncounter *specialEncounter)
{
    for (u8 i = 0; i < ROAMING_SLOT_MAX; i++) {
        if (SpecialEncounter_IsRoamerActive(specialEncounter, i)) {
            if (LCRNG_RandMod(16) == 0) {
                RoamingPokemon_MoveToRandomMap(specialEncounter, i);
            } else {
                {
                    int previousMap = SpecialEncounter_GetPlayerPreviousMap(specialEncounter);
                    MoveRoamerNearby(specialEncounter, i, previousMap);
                }
            }
        }
    }
}

int RoamingPokemon_GetRouteFromId(const u8 routeId)
{
    GF_ASSERT(routeId < RI_MAX);
    return RoamingPokemonRoutes[routeId];
}

BOOL RoamingPokemon_AnyRoamersActive(SpecialEncounter *speEnc)
{

    for (u8 i = 0; i < ROAMING_SLOT_MAX; i++) {
        if (SpecialEncounter_IsRoamerActive(speEnc, i)) {
            return TRUE;
        }
    }

    return FALSE;
}

// Runs when the player changes maps. Roamers cannot move to the map the player just left.
void RoamingPokemon_UpdatePlayerRecentRoutes(SpecialEncounter *speEnc, const int newMap)
{
    if (RoamingPokemon_AnyRoamersActive(speEnc)) {
        SpecialEncounter_UpdateRecentRoutes(speEnc, newMap);
    }
}

void RoamingPokemon_ActivateSlot(SaveData *saveData, const u8 slot)
{
    Pokemon *roamerMonData;
    Roamer *newRoamer;
    SpecialEncounter *speEnc;
    int previouslyVisitedMap;
    TrainerInfo *trainer;
    int species;
    u8 level;

    speEnc = SaveData_GetSpecialEncounters(saveData);
    newRoamer = SpecialEncounter_GetRoamer(speEnc, slot);

    switch (slot) {
    case ROAMING_SLOT_MESPRIT:
        species = SPECIES_MESPRIT;
        level = 50;
        break;
    case ROAMING_SLOT_CRESSELIA:
        species = SPECIES_CRESSELIA;
        level = 50;
        break;
    // Sovereign (decision 28): vanilla's unused Darkrai slot holds Zeraora, released by the Legend Archivist.
    case ROAMING_SLOT_ZERAORA:
        species = SPECIES_ZERAORA;
        level = 50;
        break;
    case ROAMING_SLOT_MOLTRES:
        species = SPECIES_MOLTRES;
        level = 60;
        break;
    case ROAMING_SLOT_ZAPDOS:
        species = SPECIES_ZAPDOS;
        level = 60;
        break;
    case ROAMING_SLOT_ARTICUNO:
        species = SPECIES_ARTICUNO;
        level = 60;
        break;
    // Sovereign (the Chronicles, docs/PostgameLegendaries.md): the Forces of Nature, released by the Legend Archivist.
    case ROAMING_SLOT_TORNADUS:
        species = SPECIES_TORNADUS;
        level = 65;
        break;
    case ROAMING_SLOT_THUNDURUS:
        species = SPECIES_THUNDURUS;
        level = 65;
        break;
    // Sovereign (decision 28): the Loyal Three and Calyrex's steeds roam too.
    case ROAMING_SLOT_OKIDOGI:
        species = SPECIES_OKIDOGI;
        level = 65;
        break;
    case ROAMING_SLOT_MUNKIDORI:
        species = SPECIES_MUNKIDORI;
        level = 65;
        break;
    case ROAMING_SLOT_FEZANDIPITI:
        species = SPECIES_FEZANDIPITI;
        level = 65;
        break;
    case ROAMING_SLOT_GLASTRIER:
        species = SPECIES_GLASTRIER;
        level = 70;
        break;
    case ROAMING_SLOT_SPECTRIER:
        species = SPECIES_SPECTRIER;
        level = 70;
        break;
    // Sovereign Complete: HeartGold's roamers, at its levels (Sacred Gold keeps them)
    case ROAMING_SLOT_RAIKOU:
        species = SPECIES_RAIKOU;
        level = 40;
        break;
    case ROAMING_SLOT_ENTEI:
        species = SPECIES_ENTEI;
        level = 40;
        break;
    case ROAMING_SLOT_LATIAS:
        species = SPECIES_LATIAS;
        level = 35;
        break;
    case ROAMING_SLOT_LATIOS:
        species = SPECIES_LATIOS;
        level = 35;
        break;
    default:
        GF_ASSERT(FALSE);
        return;
    }

    Roamer_SetData(newRoamer, ROAMER_DATA_SPECIES, species);
    Roamer_SetData(newRoamer, ROAMER_DATA_LEVEL, level);

    trainer = SaveData_GetTrainerInfo(saveData);
    roamerMonData = Pokemon_New(HEAP_ID_FIELD1);

    Pokemon_Init(roamerMonData);
    Pokemon_InitWith(roamerMonData, species, level, INIT_IVS_RANDOM, FALSE, 0, OTID_SET, TrainerInfo_ID_LowHalf(trainer));
    Roamer_SetData(newRoamer, ROAMER_DATA_STATUS, 0);
    Roamer_SetData(newRoamer, ROAMER_DATA_ACTIVE, 1);
    Roamer_SetData(newRoamer, ROAMER_DATA_IVS, Pokemon_GetValue(roamerMonData, MON_DATA_COMBINED_IVS, NULL));
    Roamer_SetData(newRoamer, ROAMER_DATA_PERSONALITY, Pokemon_GetValue(roamerMonData, MON_DATA_PERSONALITY, NULL));
    Roamer_SetData(newRoamer, ROAMER_DATA_CURRENT_HP, Pokemon_GetValue(roamerMonData, MON_DATA_MAX_HP, NULL));
    Heap_Free(roamerMonData);

    previouslyVisitedMap = SpecialEncounter_GetPlayerPreviousMap(speEnc);
    MoveRoamerRandom(speEnc, slot, previouslyVisitedMap);
}

// Sovereign Complete: the routes of the roamer's region (RI_SINNOH_START, RI_JOHTO_START, RI_KANTO_START).
static void RoamerRegionRoutes(const u8 roamerSlot, u8 *first, u8 *count)
{
    switch (roamerSlot) {
    case ROAMING_SLOT_RAIKOU:
    case ROAMING_SLOT_ENTEI:
        *first = RI_JOHTO_START;
        *count = RI_KANTO_START - RI_JOHTO_START;
        break;
    case ROAMING_SLOT_LATIAS:
    case ROAMING_SLOT_LATIOS:
        *first = RI_KANTO_START;
        *count = RI_MAX - RI_KANTO_START;
        break;
    default:
        *first = RI_SINNOH_START;
        *count = RI_JOHTO_START - RI_SINNOH_START;
        break;
    }
}

static void MoveRoamerRandom(SpecialEncounter *specialEncounter, const u8 roamerSlot, const int playerPreviousMap)
{
    u8 newIndex;
    int currentRoute;
    int newRoute;
    u8 firstRoute, routeCount;

    currentRoute = RoamingPokemonRoutes[SpecialEncounter_GetRoamerRouteIndex(specialEncounter, roamerSlot)];
    RoamerRegionRoutes(roamerSlot, &firstRoute, &routeCount);

    while (TRUE) {
        newIndex = firstRoute + LCRNG_RandMod(routeCount); // Sovereign Complete: was LCRNG_RandMod(RI_MAX)
        newRoute = RoamingPokemonRoutes[newIndex];

        if ((newRoute != playerPreviousMap) && (newRoute != currentRoute)) {
            SetNewMapLocation(specialEncounter, roamerSlot, newIndex, newRoute);
            break;
        }
    }
}

static void MoveRoamerNearby(SpecialEncounter *specialEncounter, const u8 roamerSlot, const int playerPreviousMap)
{
    const NearbyRoutes *possibleNewRoutes;
    u8 newMapIndex;
    int newMapId;

    possibleNewRoutes = &(sNearbyRoutes[SpecialEncounter_GetRoamerRouteIndex(specialEncounter, roamerSlot)]);

    if (possibleNewRoutes->numPossibilities == 1) {
        newMapIndex = possibleNewRoutes->adjacentRouteIndexes[0];
        newMapId = RoamingPokemonRoutes[newMapIndex];

        if (newMapId == playerPreviousMap) {
            MoveRoamerRandom(specialEncounter, roamerSlot, playerPreviousMap);
        } else {
            SetNewMapLocation(specialEncounter, roamerSlot, newMapIndex, newMapId);
        }
    } else {
        u8 nearbyIndex;

        while (TRUE) {
            nearbyIndex = LCRNG_RandMod(possibleNewRoutes->numPossibilities);
            newMapIndex = possibleNewRoutes->adjacentRouteIndexes[nearbyIndex];
            newMapId = RoamingPokemonRoutes[newMapIndex];

            if (newMapId != playerPreviousMap) {
                SetNewMapLocation(specialEncounter, roamerSlot, newMapIndex, newMapId);
                break;
            }
        }
    }
}

static void SetNewMapLocation(SpecialEncounter *specialEncounter, const u8 roamerSlot, const u8 newMapIndex, const int newMapId)
{
    Roamer *roamer = SpecialEncounter_GetRoamer(specialEncounter, roamerSlot);

    SpecialEncounter_SetRoamerRouteIndex(specialEncounter, roamerSlot, newMapIndex);
    Roamer_SetData(roamer, ROAMER_DATA_MAP_ID, newMapId);
}
