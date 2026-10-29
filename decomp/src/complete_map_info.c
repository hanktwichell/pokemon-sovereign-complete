#include "complete_map_info.h"

#include <nitro.h>

#include "generated/map_headers.h"

#include "map_header.h"

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
