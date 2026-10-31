#include "location.h"

#include "generated/map_headers.h"

#include "field_overworld_state.h"
#include "savedata.h"

static const Location sPlayerStartLocation = {
    .mapHeaderID = MAP_HEADER_TWINLEAF_TOWN_PLAYER_HOUSE_2F,
    .warpId = WARP_ID_NONE,
    .x = 4,
    .z = 6,
    .faceDirection = FACE_UP,
};

static const Location sPlayerFirstRespawnLocation = {
    .mapHeaderID = MAP_HEADER_TWINLEAF_TOWN,
    .warpId = WARP_ID_NONE,
    .x = 116,
    .z = 886,
    .faceDirection = FACE_DOWN,
};

void SetPlayerStartLocation(Location *outLocation)
{
    *outLocation = sPlayerStartLocation;
}

void SetPlayerFirstRespawnLocation(Location *outLocation)
{
    *outLocation = sPlayerFirstRespawnLocation;
}

// Sovereign Complete: a new game starts in the player's room in New Bark Town (HeartGold's sLocation_PlayerRoom), as
// the story starts in Johto. Sinnoh's League still sends the player home to Twinleaf Town (SetPlayerStartLocation),
// with the rest of Platinum's opening (docs/Roadmap.md, "Still open").
static const Location sCompleteNewGameLocation = {
    .mapHeaderID = MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_2F,
    .warpId = WARP_ID_NONE,
    .x = 6,
    .z = 6,
    .faceDirection = FACE_DOWN,
};

void InitPlayerStartLocation(SaveData *saveData)
{
    *FieldOverworldState_GetPlayerLocation(SaveData_GetFieldOverworldState(saveData)) = sCompleteNewGameLocation;
}
