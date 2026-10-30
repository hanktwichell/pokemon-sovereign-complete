#include "complete_encounters.h"

#include <nitro.h>
#include <string.h>

#include "constants/narc.h"
#include "generated/time_of_day.h"

#include "field/field_system.h"

#include "complete_map_info.h"
#include "location.h"
#include "map_header.h"
#include "narc.h"
#include "rtc.h"

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
