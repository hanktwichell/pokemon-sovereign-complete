#ifndef POKEPLATINUM_ROAMING_POKEMON_H
#define POKEPLATINUM_ROAMING_POKEMON_H

#include "struct_defs/special_encounter.h"

#include "savedata.h"

enum RoamerRouteIndex {
    RI_ROUTE_201 = 0,
    RI_ROUTE_202,
    RI_ROUTE_203,
    RI_ROUTE_204_SOUTH,
    RI_ROUTE_204_NORTH,
    RI_ROUTE_205_SOUTH,
    RI_ROUTE_205_NORTH,
    RI_ROUTE_206,
    RI_ROUTE_207,
    RI_ROUTE_208,
    RI_ROUTE_209,
    RI_ROUTE_210_SOUTH,
    RI_ROUTE_210_NORTH,
    RI_ROUTE_211_WEST,
    RI_ROUTE_211_EAST,
    RI_ROUTE_212_NORTH,
    RI_ROUTE_212_SOUTH,
    RI_ROUTE_213,
    RI_ROUTE_214,
    RI_ROUTE_215,
    RI_ROUTE_216,
    RI_ROUTE_217,
    RI_ROUTE_218,
    RI_ROUTE_219,
    RI_ROUTE_220,
    RI_ROUTE_221,
    RI_ROUTE_222,
    RI_VALLEY_WINDWORKS_OUTSIDE,
    RI_FUEGO_IRONWORKS_OUTSIDE,
    // Sovereign Complete: HeartGold's roaming routes, Johto's then Kanto's (its field_roamer.c)
    RI_HGSS_ROUTE_29,
    RI_HGSS_ROUTE_30,
    RI_HGSS_ROUTE_31,
    RI_HGSS_ROUTE_32,
    RI_HGSS_ROUTE_33,
    RI_HGSS_ROUTE_34,
    RI_HGSS_ROUTE_35,
    RI_HGSS_ROUTE_36,
    RI_HGSS_ROUTE_37,
    RI_HGSS_ROUTE_38,
    RI_HGSS_ROUTE_39,
    RI_HGSS_ROUTE_42,
    RI_HGSS_ROUTE_43,
    RI_HGSS_ROUTE_44,
    RI_HGSS_ROUTE_45,
    RI_HGSS_ROUTE_46,
    RI_HGSS_ROUTE_1,
    RI_HGSS_ROUTE_2,
    RI_HGSS_ROUTE_3,
    RI_HGSS_ROUTE_4,
    RI_HGSS_ROUTE_5,
    RI_HGSS_ROUTE_6,
    RI_HGSS_ROUTE_7,
    RI_HGSS_ROUTE_8,
    RI_HGSS_ROUTE_9,
    RI_HGSS_ROUTE_10,
    RI_HGSS_ROUTE_11,
    RI_HGSS_ROUTE_12,
    RI_HGSS_ROUTE_13,
    RI_HGSS_ROUTE_14,
    RI_HGSS_ROUTE_15,
    RI_HGSS_ROUTE_16,
    RI_HGSS_ROUTE_17,
    RI_HGSS_ROUTE_18,
    RI_HGSS_ROUTE_19,
    RI_HGSS_ROUTE_20,
    RI_HGSS_ROUTE_21,
    RI_HGSS_ROUTE_22,
    RI_HGSS_ROUTE_24,
    RI_HGSS_ROUTE_26,
    RI_HGSS_ROUTE_28,
    RI_MAX,
};

// Sovereign Complete: each roamer roams its own region's routes, Sinnoh's, Johto's or Kanto's (HeartGold's Raikou and
// Entei roam Johto, its Latias and Latios Kanto).
#define RI_SINNOH_START 0
#define RI_JOHTO_START  RI_HGSS_ROUTE_29
#define RI_KANTO_START  RI_HGSS_ROUTE_1

void RoamingPokemon_MoveToRandomMap(SpecialEncounter *speEnc, const u8 roamerSlot);
void RoamingPokemon_RandomizeAllLocations(SpecialEncounter *speEnc);
void RoamingPokemon_MoveAllLocations(SpecialEncounter *speEnc);
int RoamingPokemon_GetRouteFromId(const u8 id);
BOOL RoamingPokemon_AnyRoamersActive(SpecialEncounter *speEnc);
void RoamingPokemon_UpdatePlayerRecentRoutes(SpecialEncounter *speEnc, const int newMap);
void RoamingPokemon_ActivateSlot(SaveData *saveData, const u8 speciesID);

#endif // POKEPLATINUM_ROAMING_POKEMON_H
