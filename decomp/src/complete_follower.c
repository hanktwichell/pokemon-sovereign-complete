#include "complete_follower.h"

#include <nitro.h>

#include "constants/map_object.h"
#include "constants/player_avatar.h"
#include "constants/species.h"
#include "generated/movement_types.h"
#include "generated/object_events_gfx.h"

#include "field/field_system.h"

#include "location.h"
#include "map_object.h"
#include "party.h"
#include "player_avatar.h"
#include "pokemon.h"
#include "save_player.h"
#include "system_flags.h"
#include "vars_flags.h"

#include "complete_follower_gfx.h"
#include "complete_map_info.h"

// Sovereign Complete: following Pokémon (prototype).
//
// On every map entry the follower is made again for the current lead: the first party Pokémon, if it isn't an Egg,
// hasn't fainted and has a walking sprite. Nobody follows while the player cycles or surfs, or while a partner
// trainer (Cheryl, Riley...) walks with the player, since partners use the same follow-the-player movement. The
// object is persistent, so it stays through zone changes on the overworld; warps and continuing a save remake it.
// Each map's rule is HeartGold's: on some maps nobody follows, and in most buildings only Pokémon that aren't too tall
// (HeartGold's flag, carried in sFollowerGfx); Sinnoh's buildings follow the same rule.

static int FollowerGfxIndex(int species)
{
    for (int i = 0; i < (int)NELEMS(sFollowerGfx); i++) {
        if (sFollowerGfx[i].species == species) {
            return i;
        }
    }

    return -1;
}

static int LeadSpecies(FieldSystem *fieldSystem)
{
    Party *party = SaveData_GetParty(fieldSystem->saveData);

    if (Party_GetCurrentCount(party) == 0) {
        return SPECIES_NONE;
    }

    Pokemon *lead = Party_GetPokemonBySlotIndex(party, 0);

    if (Pokemon_GetValue(lead, MON_DATA_IS_EGG, NULL) || Pokemon_GetValue(lead, MON_DATA_HP, NULL) == 0) {
        return SPECIES_NONE;
    }

    return Pokemon_GetValue(lead, MON_DATA_SPECIES, NULL);
}

// HeartGold's Diglett and Dugtrio stay in their ball in the Bell Tower.
static BOOL IsBellTower(enum MapHeaderID mapHeaderID)
{
    return mapHeaderID == MAP_HEADER_HGSS_BELL_TOWER_1F
        || (mapHeaderID >= MAP_HEADER_HGSS_BELL_TOWER_2F && mapHeaderID <= MAP_HEADER_HGSS_BELL_TOWER_9F)
        || mapHeaderID == MAP_HEADER_HGSS_BELL_TOWER_ROOF
        || mapHeaderID == MAP_HEADER_HGSS_BELL_TOWER_10F;
}

// The map's rule, as HeartGold's: some maps let nobody follow, and some (most buildings) only Pokémon that aren't too
// tall (src/complete_map_info.c).
static BOOL MayFollowHere(enum MapHeaderID mapHeaderID, int species, BOOL tooTall)
{
    if ((species == SPECIES_DIGLETT || species == SPECIES_DUGTRIO) && IsBellTower(mapHeaderID)) {
        return FALSE;
    }

    switch (MapHeader_GetFollowMode(mapHeaderID)) {
    case FOLLOW_MODE_PREVENT:
        return FALSE;
    case FOLLOW_MODE_HEIGHT_RESTRICT:
        return !tooTall;
    default:
        return TRUE;
    }
}

static BOOL CanFollow(FieldSystem *fieldSystem)
{
    return PlayerAvatar_GetPlayerState(fieldSystem->playerAvatar) == PLAYER_AVATAR_WALKING
        && !SystemFlag_CheckHasPartner(SaveData_GetVarsFlags(fieldSystem->saveData));
}

BOOL CompleteFollower_IsTooTall(FieldSystem *fieldSystem)
{
    int gfx = FollowerGfxIndex(LeadSpecies(fieldSystem));

    return gfx >= 0 && sFollowerGfx[gfx].tooTall;
}

void CompleteFollower_Refresh(FieldSystem *fieldSystem)
{
    MapObject *follower = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, LOCALID_COMPLETE_FOLLOWER);

    if (follower != NULL) {
        MapObject_Delete(follower);
    }

    int species = LeadSpecies(fieldSystem);
    int gfx = FollowerGfxIndex(species);

    if (gfx < 0 || !CanFollow(fieldSystem)
        || !MayFollowHere(fieldSystem->location->mapHeaderID, species, sFollowerGfx[gfx].tooTall)) {
        return;
    }

    follower = MapObjectMan_AddMapObject(fieldSystem->mapObjMan,
        PlayerAvatar_GetXPos(fieldSystem->playerAvatar),
        PlayerAvatar_GetZPos(fieldSystem->playerAvatar),
        PlayerAvatar_GetFacingDir(fieldSystem->playerAvatar),
        sFollowerGfx[gfx].graphicsID,
        MOVEMENT_TYPE_FOLLOW_PLAYER,
        fieldSystem->location->mapHeaderID);

    if (follower == NULL) {
        return;
    }

    MapObject_SetLocalID(follower, LOCALID_COMPLETE_FOLLOWER);
    MapObject_SetStatusFlagOn(follower, MAP_OBJ_STATUS_PERSISTENT);
}

#ifdef SOVEREIGN_TEST
u16 gCompleteTestFollowerTile[2];

void CompleteFollower_TestRecordTile(FieldSystem *fieldSystem)
{
    MapObject *follower = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, LOCALID_COMPLETE_FOLLOWER);

    gCompleteTestFollowerTile[0] = follower != NULL ? MapObject_GetX(follower) : 0xFFFF;
    gCompleteTestFollowerTile[1] = follower != NULL ? MapObject_GetZ(follower) : 0xFFFF;
}
#endif
