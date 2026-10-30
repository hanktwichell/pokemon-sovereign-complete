#include "complete_encounters.h"

#include <nitro.h>
#include <string.h>

#include "constants/forms.h"
#include "constants/narc.h"
#include "generated/species.h"
#include "generated/vars_flags.h"
#include "generated/time_of_day.h"

#include "field/field_system.h"

#include "complete_map_info.h"
#include "complete_test.h"
#include "inlines.h"
#include "location.h"
#include "map_header.h"
#include "narc.h"
#include "rtc.h"
#include "special_encounter.h"
#include "vars_flags.h"

// HeartGold's EncounterData (pokeheartgold's include/wild_encounter.h), 0xC4 bytes
#define HGSS_LAND_SLOTS  12
#define HGSS_WATER_SLOTS 5

typedef struct HGSSSlot {
    u8 levelMin;
    u8 levelMax;
    u16 species;
} HGSSSlot;

typedef struct HGSSEncounters {
    u8 landRate;
    u8 surfRate;
    u8 rockSmashRate;
    u8 oldRodRate;
    u8 goodRodRate;
    u8 superRodRate;
    u8 padding[2];
    u8 landLevels[HGSS_LAND_SLOTS];
    u16 landSpecies[3][HGSS_LAND_SLOTS]; // morning, day, night
    u16 radioHoenn[2];
    u16 radioSinnoh[2];
    HGSSSlot surf[HGSS_WATER_SLOTS];
    HGSSSlot rockSmash[2];
    HGSSSlot oldRod[HGSS_WATER_SLOTS];
    HGSSSlot goodRod[HGSS_WATER_SLOTS];
    HGSSSlot superRod[HGSS_WATER_SLOTS];
    u16 landSwarm;
    u16 surfSwarm;
    u16 nightFishing;
    u16 fishingSwarm;
} HGSSEncounters;

enum {
    HGSS_MORNING = 0,
    HGSS_DAY,
    HGSS_NIGHT,
};

// The last map read: its table, kept for the time-of-day swaps
static HGSSEncounters sTable;
static u16 sTableMap = 0xFFFF; // none yet

static void Read(enum MapHeaderID mapHeaderID)
{
    if (sTableMap != mapHeaderID) {
        NARC_ReadWholeMemberByIndexPair(&sTable, NARC_INDEX_FIELDDATA__ENCOUNTDATA__HGSS_ENC_DATA,
            MapHeader_GetWildEncountersArchiveID(mapHeaderID));
        sTableMap = mapHeaderID;
    }
}

static void FillWater(WaterEncounters *dest, u8 rate, const HGSSSlot *slots)
{
    dest->encounterRate = rate;

    for (int i = 0; i < HGSS_WATER_SLOTS; i++) {
        dest->encounters[i].maxLevel = slots[i].levelMax;
        dest->encounters[i].minLevel = slots[i].levelMin;
        dest->encounters[i].species = slots[i].species;
    }
}

void CompleteEncounters_Load(WildEncounters *data, enum MapHeaderID mapHeaderID)
{
    Read(mapHeaderID);
    memset(data, 0, sizeof(WildEncounters));

    data->grassEncounters.encounterRate = sTable.landRate;

    for (int i = 0; i < HGSS_LAND_SLOTS; i++) {
        data->grassEncounters.encounters[i].level = sTable.landLevels[i];
        data->grassEncounters.encounters[i].species = sTable.landSpecies[HGSS_MORNING][i];
    }

    // Platinum's own swaps get the slots they replace, so they change nothing here: day and night (slots 2, 3),
    // swarms (0, 1), the Poké Radar (4, 5, 10, 11), the GBA game in the second slot (8, 9)
    for (int i = 0; i < MAX_TIMED_ENCOUNTERS; i++) {
        data->dayEncounters[i] = sTable.landSpecies[HGSS_DAY][2 + i];
        data->nightEncounters[i] = sTable.landSpecies[HGSS_NIGHT][2 + i];
        data->swarmEncounters[i] = sTable.landSpecies[HGSS_MORNING][i];
        data->dualSlotRubyEncounters[i] = sTable.landSpecies[HGSS_MORNING][8 + i];
        data->dualSlotSapphireEncounters[i] = sTable.landSpecies[HGSS_MORNING][8 + i];
        data->dualSlotEmeraldEncouters[i] = sTable.landSpecies[HGSS_MORNING][8 + i];
        data->dualSlotFireredEncounters[i] = sTable.landSpecies[HGSS_MORNING][8 + i];
        data->dualSlotLeafgreenEncounters[i] = sTable.landSpecies[HGSS_MORNING][8 + i];
    }

    data->radarEncounters[0] = sTable.landSpecies[HGSS_MORNING][4];
    data->radarEncounters[1] = sTable.landSpecies[HGSS_MORNING][5];
    data->radarEncounters[2] = sTable.landSpecies[HGSS_MORNING][10];
    data->radarEncounters[3] = sTable.landSpecies[HGSS_MORNING][11];

    FillWater(&data->surfEncounters, sTable.surfRate, sTable.surf);
    FillWater(&data->oldRodEncounters, sTable.oldRodRate, sTable.oldRod);
    FillWater(&data->goodRodEncounters, sTable.goodRodRate, sTable.goodRod);
    FillWater(&data->superRodEncounters, sTable.superRodRate, sTable.superRod);
}

// HeartGold's mass outbreaks (its sSwarmMapLUT and encounter_check.c): from Oak's National Pokédex on
// (VAR_COMPLETE_OUTBREAKS), each day one of these maps has its swarm species in the grass (slots 0 and 1), on the water
// (the first surfing slot) or on the rod (Sacred Gold's tables have no fishing swarm, so those days have none). The
// day's pick is Platinum's own daily swarm value (Sinnoh's outbreaks pick from it too), as HeartGold's is a daily
// random value of its own.
enum OutbreakTerrain {
    OUTBREAK_NONE = -1,
    OUTBREAK_LAND,
    OUTBREAK_SURF,
    OUTBREAK_FISHING,
};

static const struct {
    u16 mapHeaderID;
    u8 terrain;
} sOutbreakMaps[] = {
    { MAP_HEADER_HGSS_ROUTE_1, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_ROUTE_3, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_ROUTE_9, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_ROUTE_12, OUTBREAK_FISHING },
    { MAP_HEADER_HGSS_ROUTE_13, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_ROUTE_19, OUTBREAK_SURF },
    { MAP_HEADER_HGSS_ROUTE_32, OUTBREAK_FISHING },
    { MAP_HEADER_HGSS_ROUTE_25, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_ROUTE_27, OUTBREAK_SURF },
    { MAP_HEADER_HGSS_ROUTE_34, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_ROUTE_35, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_ROUTE_38, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_ROUTE_44, OUTBREAK_FISHING },
    { MAP_HEADER_HGSS_ROUTE_45, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_ROUTE_47, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_MOUNT_MORTAR_1F_ENTRANCE, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_DARK_CAVE_ROUTE_31_SIDE, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_VIRIDIAN_FOREST, OUTBREAK_LAND },
    { MAP_HEADER_HGSS_VERMILION, OUTBREAK_SURF },
    { MAP_HEADER_HGSS_VIOLET, OUTBREAK_FISHING },
};

// Where today's outbreak is on the field's map, or OUTBREAK_NONE
static enum OutbreakTerrain OutbreakTerrainHere(FieldSystem *fieldSystem)
{
    if (*VarsFlags_GetVarAddress(SaveData_GetVarsFlags(fieldSystem->saveData), VAR_COMPLETE_OUTBREAKS) == 0) {
        return OUTBREAK_NONE;
    }

    u32 index = SpecialEncounter_GetDailyMon(SaveData_GetSpecialEncounters(fieldSystem->saveData), DAILY_SWARM) % NELEMS(sOutbreakMaps);

#ifdef SOVEREIGN_TEST
    if (gCompleteTestOutbreakMap != 0) {
        index = gCompleteTestOutbreakMap - 1;
    }
#endif

    return sOutbreakMaps[index].mapHeaderID == fieldSystem->location->mapHeaderID ? sOutbreakMaps[index].terrain : OUTBREAK_NONE;
}

void CompleteEncounters_SurfOutbreak(FieldSystem *fieldSystem, int *firstSlotSpecies)
{
    enum MapHeaderID mapHeaderID = fieldSystem->location->mapHeaderID;

    if (!MapHeader_IsHGSS(mapHeaderID) || !MapHeader_HasWildEncounters(mapHeaderID)
        || OutbreakTerrainHere(fieldSystem) != OUTBREAK_SURF) {
        return;
    }

    Read(mapHeaderID);

    if (sTable.surfSwarm != SPECIES_NONE) {
        *firstSlotSpecies = sTable.surfSwarm;
    }
}

int CompleteEncounters_GrassSpecies(FieldSystem *fieldSystem, int slot)
{
    enum MapHeaderID mapHeaderID = fieldSystem->location->mapHeaderID;

    if (!MapHeader_IsHGSS(mapHeaderID) || !MapHeader_HasWildEncounters(mapHeaderID)) {
        return 0;
    }

    Read(mapHeaderID);

    // HeartGold's times: morning 4-10, day 10-20 (Platinum's day and twilight), night 20-4
    int time = HGSS_MORNING;

    switch (GetTimeOfDay()) {
    case TIMEOFDAY_DAY:
    case TIMEOFDAY_TWILIGHT:
        time = HGSS_DAY;
        break;
    case TIMEOFDAY_NIGHT:
    case TIMEOFDAY_LATE_NIGHT:
        time = HGSS_NIGHT;
        break;
    default:
        break;
    }

    if (slot < 2 && sTable.landSwarm != SPECIES_NONE && OutbreakTerrainHere(fieldSystem) == OUTBREAK_LAND) {
        return sTable.landSwarm;
    }

    return sTable.landSpecies[time][slot];
}

u8 CompleteEncounters_RockSmash(FieldSystem *fieldSystem, int slot, u16 *species, u8 *minLevel, u8 *maxLevel)
{
    enum MapHeaderID mapHeaderID = fieldSystem->location->mapHeaderID;

    if (!MapHeader_IsHGSS(mapHeaderID) || !MapHeader_HasWildEncounters(mapHeaderID)) {
        return 0;
    }

    Read(mapHeaderID);
    *species = sTable.rockSmash[slot].species;
    *minLevel = sTable.rockSmash[slot].levelMin;
    *maxLevel = sTable.rockSmash[slot].levelMax;
    return *species != 0 ? sTable.rockSmashRate : 0;
}

u16 CompleteEncounters_RandomSpecies(enum MapHeaderID mapHeaderID, BOOL fishing, int time)
{
    if (!MapHeader_IsHGSS(mapHeaderID) || !MapHeader_HasWildEncounters(mapHeaderID)) {
        return SPECIES_RATTATA;
    }

    Read(mapHeaderID);

    if (fishing) {
        int slot = LCRNG_RandMod(5);
        return slot == 3 && time == HGSS_NIGHT ? sTable.nightFishing : sTable.goodRod[slot].species;
    }

    return sTable.landSpecies[time][LCRNG_RandMod(HGSS_LAND_SLOTS)];
}

BOOL CompleteEncounters_IsRuinsOfAlphHall(enum MapHeaderID mapHeaderID)
{
    return mapHeaderID == MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL
        || mapHeaderID == MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT
        || mapHeaderID == MAP_HEADER_HGSS_RUINS_OF_ALPH_HALL_ENTRANCE_SINJOH_EVENT
        || mapHeaderID == MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2;
}

// HeartGold's encounter_check.c: each solved puzzle lets out its letters (Kabuto's A to J, Aerodactyl's R to V,
// Omanyte's K to Q, Ho-Oh's W to Z), and the hall's entrance in the Sinjoh Ruins event has only ! and ?
u32 CompleteEncounters_UnownForms(FieldSystem *fieldSystem)
{
    static const struct {
        u16 flag;
        u8 first;
        u8 last;
    } sPuzzleForms[] = {
        { FLAG_HGSS_SYS_ALPH_PUZZLE_KABUTO, UNOWN_FORM_A, UNOWN_FORM_J },
        { FLAG_HGSS_SYS_ALPH_PUZZLE_AERODACTYL, UNOWN_FORM_R, UNOWN_FORM_V },
        { FLAG_HGSS_SYS_ALPH_PUZZLE_OMANYTE, UNOWN_FORM_K, UNOWN_FORM_Q },
        { FLAG_HGSS_SYS_ALPH_PUZZLE_HO_OH, UNOWN_FORM_W, UNOWN_FORM_Z },
    };
    enum MapHeaderID mapHeaderID = fieldSystem->location->mapHeaderID;
    VarsFlags *varsFlags = SaveData_GetVarsFlags(fieldSystem->saveData);
    u32 forms = 0;

    if (!CompleteEncounters_IsRuinsOfAlphHall(mapHeaderID)) {
        return 0;
    }

    for (int i = 0; i < (int)NELEMS(sPuzzleForms); i++) {
        if (VarsFlags_CheckFlag(varsFlags, sPuzzleForms[i].flag)) {
            forms |= ((1 << (sPuzzleForms[i].last + 1)) - 1) & ~((1 << sPuzzleForms[i].first) - 1);
        }
    }

    if (forms != 0 && mapHeaderID == MAP_HEADER_HGSS_RUINS_OF_ALPH_HALL_ENTRANCE_SINJOH_EVENT) {
        forms = (1 << UNOWN_FORM_EXC) | (1 << UNOWN_FORM_QUE);
    }

    return forms;
}
