#include "complete_map_info.h"

#include <nitro.h>

#include "generated/map_headers.h"
#include "generated/vars_flags.h"

#include "field/field_system.h"

#include "location.h"
#include "map_header.h"
#include "map_matrix.h"
#include "map_object.h"
#include "rtc.h"
#include "savedata.h"
#include "vars_flags.h"

#include "res/field/matrices/map_matrix.naix"

typedef struct HGSSMapInfo {
    u32 followMode : 2;
    u32 region : 1;
    u32 worldMapX : 6;
    u32 worldMapY : 6;
    u32 momCallIntroParam : 4;
    u32 outgoingCalls : 1;
    u32 incomingCalls : 1;
    u32 radioSignal : 1;
    u32 padding : 10;
} HGSSMapInfo;

#include "data/hgss_map_info.h"

static const HGSSMapInfo *GetInfo(enum MapHeaderID mapHeaderID)
{
    if (!MapHeader_IsHGSS(mapHeaderID)) {
        return NULL;
    }

    return &sHGSSMapInfo[mapHeaderID - MAP_HEADER_HGSS_FIRST];
}

BOOL MapHeader_IsHGSS(enum MapHeaderID mapHeaderID)
{
    return mapHeaderID >= MAP_HEADER_HGSS_FIRST && mapHeaderID < MAP_HEADER_HGSS_FIRST + NELEMS(sHGSSMapInfo);
}

BOOL MapHeader_IsOnOverworldMatrix(enum MapHeaderID mapHeaderID)
{
    return MapHeader_IsOnMainMatrix(mapHeaderID) || MapHeader_GetMapMatrixID(mapHeaderID) == map_matrix_hgss_0000;
}

// Sinnoh's maps: HeartGold's usual rule, only Pokémon that aren't too tall in buildings.
enum FollowMode MapHeader_GetFollowMode(enum MapHeaderID mapHeaderID)
{
    const HGSSMapInfo *info = GetInfo(mapHeaderID);

    if (info != NULL) {
        return info->followMode;
    }

    return MapHeader_IsBuilding(mapHeaderID) ? FOLLOW_MODE_HEIGHT_RESTRICT : FOLLOW_MODE_ALLOW;
}

enum MapRegion MapHeader_GetRegion(enum MapHeaderID mapHeaderID)
{
    const HGSSMapInfo *info = GetInfo(mapHeaderID);
    return info ? info->region : MAP_REGION_SINNOH;
}

void MapHeader_GetWorldMapPos(enum MapHeaderID mapHeaderID, int *x, int *y)
{
    const HGSSMapInfo *info = GetInfo(mapHeaderID);
    *x = info ? info->worldMapX : 0;
    *y = info ? info->worldMapY : 0;
}

u32 MapHeader_GetMomCallIntroParam(enum MapHeaderID mapHeaderID)
{
    const HGSSMapInfo *info = GetInfo(mapHeaderID);
    return info ? info->momCallIntroParam : 0;
}

BOOL MapHeader_HasOutgoingCalls(enum MapHeaderID mapHeaderID)
{
    const HGSSMapInfo *info = GetInfo(mapHeaderID);
    return info ? info->outgoingCalls : FALSE;
}

BOOL MapHeader_HasIncomingCalls(enum MapHeaderID mapHeaderID)
{
    const HGSSMapInfo *info = GetInfo(mapHeaderID);
    return info ? info->incomingCalls : FALSE;
}

BOOL MapHeader_HasRadioSignal(enum MapHeaderID mapHeaderID)
{
    const HGSSMapInfo *info = GetInfo(mapHeaderID);
    return info ? info->radioSignal : FALSE;
}

#define HGSS_OVERWORLD_MATRIX    map_matrix_hgss_0000 // HeartGold's map_matrix_0000_EVERYWHERE
#define HGSS_LAND_DATA_BASE      666 // HeartGold's land data k is map_data_{666 + k} (tools/complete/import_hgss_maps.py)
#define MAHOGANY_ANTENNA_REMOVED 0x6208 // what HeartGold's ScrCmd_530 0, 1 sets VAR_HGSS_UNK_4036 to (its _020FE4A8[0])
#define LAKE_OF_RAGE_LOWERED     0xF229 // and VAR_HGSS_UNK_4037, while the lake is low (_020FE4A8[1])

// The Lake of Rage is low on Wednesdays once Team Rocket's hideout is cleared, seen from the lake or Route 43
// (HeartGold's ShouldUseAlternateLakeOfRage)
BOOL CompleteMapInfo_IsLakeOfRageLow(SaveData *saveData, enum MapHeaderID mapHeaderID)
{
    RTCDate date;

    GetCurrentDate(&date);
    return VarsFlags_CheckFlag(SaveData_GetVarsFlags(saveData), FLAG_HGSS_ROCKET_HIDEOUT_CLEARED)
        && (mapHeaderID == MAP_HEADER_HGSS_LAKE_OF_RAGE || mapHeaderID == MAP_HEADER_HGSS_ROUTE_43)
        && date.week == RTC_WEEK_WEDNESDAY;
}

// HeartGold's map loads change the overworld's blocks (its RemoveMahoganyTownAntennaTree, ShouldUseAlternateLakeOfRage
// and SetLakeOfRageWaterLevel): Mahogany Town's antenna tree goes once Team Rocket's hideout is cleared, and the Lake
// of Rage is low on Wednesdays after that, seen from the lake or Route 43
void CompleteMapInfo_LoadMatrix(MapMatrix *mapMatrix, SaveData *saveData, enum MapHeaderID mapHeaderID)
{
    if (mapMatrix->matrixID != HGSS_OVERWORLD_MATRIX) {
        return;
    }

    VarsFlags *varsFlags = SaveData_GetVarsFlags(saveData);
    u16 *landDataIDs = mapMatrix->data.landDataIDs;
    int width = mapMatrix->width;

    if (*VarsFlags_GetVarAddress(varsFlags, VAR_HGSS_UNK_4036) == MAHOGANY_ANTENNA_REMOVED) {
        landDataIDs[width * 5 + 16] = HGSS_LAND_DATA_BASE + 86;
    }

    BOOL lowered = CompleteMapInfo_IsLakeOfRageLow(saveData, mapHeaderID);

    *VarsFlags_GetVarAddress(varsFlags, VAR_HGSS_UNK_4037) = lowered ? LAKE_OF_RAGE_LOWERED : 0;

    for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 3; col++) {
            landDataIDs[width * (row + 1) + 15 + col] = HGSS_LAND_DATA_BASE + (lowered ? 95 : 89) + row * 3 + col;
        }
    }
}

// HeartGold's boulder holes (its ov01_02206A14): which boulder (local ID) falls through which hole, and the flag that
// hides its fallen copy on the floor below
static const struct {
    u16 localID;
    u16 x;
    u16 z;
    u16 fallenFlag;
} sBoulderHoles[] = {
    { 0, 11, 10, FLAG_HGSS_HIDE_ICE_PATH_BOULDER_1_FALLEN },
    { 1, 10, 18, FLAG_HGSS_HIDE_ICE_PATH_BOULDER_2_FALLEN },
    { 2, 18, 7, FLAG_HGSS_HIDE_ICE_PATH_BOULDER_3_FALLEN },
    { 3, 19, 19, FLAG_HGSS_HIDE_ICE_PATH_BOULDER_4_FALLEN },
};

// HeartGold's ov01_021F1F8C, without its fade and field reload around it (its std_boulder_fell_down)
BOOL CompleteMapInfo_BoulderFell(FieldSystem *fieldSystem, MapObject *boulder)
{
    if (fieldSystem->location->mapHeaderID != MAP_HEADER_HGSS_ICE_PATH_B1F) {
        return FALSE;
    }

    for (int i = 0; i < NELEMS(sBoulderHoles); i++) {
        if (MapObject_GetLocalID(boulder) == sBoulderHoles[i].localID && MapObject_GetX(boulder) == sBoulderHoles[i].x
            && MapObject_GetZ(boulder) == sBoulderHoles[i].z) {
            MapObject_SetFlagAndDeleteObject(boulder);
            VarsFlags_ClearFlag(SaveData_GetVarsFlags(fieldSystem->saveData), sBoulderHoles[i].fallenFlag);
            return TRUE;
        }
    }

    return FALSE;
}
