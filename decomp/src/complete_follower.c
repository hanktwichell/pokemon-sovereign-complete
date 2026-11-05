#include "complete_follower.h"

#include <nitro.h>

#include "constants/map_object.h"
#include "constants/player_avatar.h"
#include "constants/scrcmd.h"
#include "constants/species.h"
#include "generated/genders.h"
#include "generated/items.h"
#include "generated/movement_types.h"
#include "generated/object_events_gfx.h"

#include "field/field_system.h"
#include "overlay005/ov5_021DFB54.h"

#include "location.h"
#include "field_task.h"
#include "map_object.h"
#include "map_tile_behavior.h"
#include "party.h"
#include "player_avatar.h"
#include "pokemon.h"
#include "save_player.h"
#include "script_manager.h"
#include "system_flags.h"
#include "terrain_collision_manager.h"
#include "vars_flags.h"

#include "res/graphics/field_sprites/field_sprites.naix"

#include "complete_follower_gfx.h"
#include "complete_follower_talk.h"
#include "complete_map_info.h"

// Sovereign Complete: following Pokémon.
//
// On every map entry the follower is made again for the current lead: the first party Pokémon, if it isn't an Egg,
// hasn't fainted and has a walking sprite. Nobody follows while the player cycles or surfs, or while a partner
// trainer (Cheryl, Riley...) walks with the player, since partners use the same follow-the-player movement. The
// object is persistent, so it stays through zone changes on the overworld; warps and continuing a save remake it, and
// so does any change while the player walks about (CompleteFollower_Update).
// Each map's rule is HeartGold's: on some maps nobody follows, and in most buildings only Pokémon that aren't too tall
// (HeartGold's flag, sFollowerTooTall); Sinnoh's buildings follow the same rule.
//
// The sprites are HeartGold's 566 walking Pokémon (tools/complete/gen_follower_sprites.py), and their shiny palettes,
// a range of graphics IDs from FOLLOWER_GFX_FIRST: the field's lookups take each one's size's template entry (CompleteFollower_TemplateGfx)
// and its own texture (CompleteFollower_GfxNarcIndex). Species past HeartGold's (#494 on) have none yet.

// The lead's sprite's place in the range, as HeartGold's FollowMon_GetSpriteID picks it (its female sprite, or its
// form's, a form it lacks taking the first), or -1 for a species without one
static int FollowerSprite(int species, int form, int gender)
{
    if (species <= SPECIES_NONE || species > FOLLOWER_SPECIES_COUNT) {
        return -1;
    }

    int sprite = sFollowerGfxFirst[species];
    int forms = sFollowerGfxForms[species - 1];

    if (forms & 0x80) {
        return sprite + (gender == GENDER_FEMALE);
    }

    return sprite + (form > forms ? 0 : form);
}

static BOOL IsTooTall(int species)
{
    return species > SPECIES_NONE && species <= FOLLOWER_SPECIES_COUNT
        && (sFollowerTooTall[(species - 1) >> 3] >> ((species - 1) & 7)) & 1;
}

// The range: HeartGold's walking sprites, then the same in their shiny palettes
static BOOL IsFollowerGfx(u32 graphicsID)
{
    return graphicsID >= FOLLOWER_GFX_FIRST && graphicsID < FOLLOWER_GFX_FIRST + 2 * FOLLOWER_GFX_COUNT;
}

u32 CompleteFollower_TemplateGfx(u32 graphicsID)
{
    if (!IsFollowerGfx(graphicsID)) {
        return graphicsID;
    }

    u32 k = (graphicsID - FOLLOWER_GFX_FIRST) % FOLLOWER_GFX_COUNT;
    return (sFollowerGfxLarge[k >> 3] >> (k & 7)) & 1 ? FOLLOWER_GFX_TEMPLATE_64 : FOLLOWER_GFX_TEMPLATE_32;
}

int CompleteFollower_GfxNarcIndex(u32 graphicsID)
{
    return IsFollowerGfx(graphicsID) ? FOLLOWER_GFX_FIRST_TEXTURE + (int)(graphicsID - FOLLOWER_GFX_FIRST) : -1;
}

// The lead, if it can follow at all (not an Egg, not fainted), or NULL
static Pokemon *Lead(FieldSystem *fieldSystem)
{
    Party *party = SaveData_GetParty(fieldSystem->saveData);

    if (Party_GetCurrentCount(party) == 0) {
        return NULL;
    }

    Pokemon *lead = Party_GetPokemonBySlotIndex(party, 0);

    if (Pokemon_GetValue(lead, MON_DATA_IS_EGG, NULL) || Pokemon_GetValue(lead, MON_DATA_HP, NULL) == 0) {
        return NULL;
    }

    return lead;
}

static int LeadSpecies(FieldSystem *fieldSystem)
{
    Pokemon *lead = Lead(fieldSystem);

    return lead == NULL ? SPECIES_NONE : Pokemon_GetValue(lead, MON_DATA_SPECIES, NULL);
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
    return IsTooTall(LeadSpecies(fieldSystem));
}

// HeartGold's follower inhibit flag (its SetFollowMonInhibitState): while set, the follower stays in its ball, as for
// Blackthorn Gym's floor puzzle after the guide's talk; the next map change clears it (src/field_map_change.c), as
// HeartGold's warps do. HeartGold keeps it in the save; here a reset brings the follower back on that map.
static BOOL sInhibited;

void CompleteFollower_SetInhibited(BOOL inhibited)
{
    sInhibited = inhibited;
}

int CompleteFollower_MonGfx(int species, int form, int gender, BOOL shiny)
{
    int sprite = FollowerSprite(species, form, gender);

    return sprite < 0 ? -1 : FOLLOWER_GFX_FIRST + sprite + (shiny ? FOLLOWER_GFX_COUNT : 0); // a shiny one's colours
}

// The graphics the follower should have here and now, or -1 when nobody should follow
static int WantedGfx(FieldSystem *fieldSystem)
{
    Pokemon *lead = Lead(fieldSystem);
    int species = lead == NULL ? SPECIES_NONE : Pokemon_GetValue(lead, MON_DATA_SPECIES, NULL);
    int gfx = lead == NULL ? -1 : CompleteFollower_MonGfx(species, Pokemon_GetValue(lead, MON_DATA_FORM, NULL), Pokemon_GetGender(lead), Pokemon_IsShiny(lead));

    if (gfx < 0 || sInhibited || !CanFollow(fieldSystem)
        || !MayFollowHere(fieldSystem->location->mapHeaderID, species, IsTooTall(species))) {
        return -1;
    }

    return gfx;
}

// A scene can leave the follower further off than its steps make up (Elm's lab: it comes out beside the player at the
// table, then the scene walks the player back to Elm), and it walks to the player's last tile at each step, so it
// would trail that far behind. With both standing still and the follower more than two tiles away (a ledge leaves
// two), it's left behind.
static BOOL IsLeftBehind(FieldSystem *fieldSystem, MapObject *follower)
{
    if (MapObject_IsMoving(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar)) || MapObject_IsMoving(follower)) {
        return FALSE;
    }

    int dx = MapObject_GetX(follower) - PlayerAvatar_GetXPos(fieldSystem->playerAvatar);
    int dz = MapObject_GetZ(follower) - PlayerAvatar_GetZPos(fieldSystem->playerAvatar);

    return (dx < 0 ? -dx : dx) + (dz < 0 ? -dz : dz) > 2;
}

// The player walks through the following Pokémon (src/map_object_move.c), which steps onto the tile the player left,
// so the two swap places, as in HeartGold; anyone else still bumps into it
BOOL CompleteFollower_IsPassedBy(const MapObject *mover, const MapObject *other)
{
    return MapObject_GetLocalID(mover) == LOCALID_PLAYER && MapObject_GetLocalID(other) == LOCALID_COMPLETE_FOLLOWER
        && MapObject_GetMovementType(other) == MOVEMENT_TYPE_FOLLOW_PLAYER;
}

// A tile beside the player the follower may come out on: no wall, step or ledge between, no water, no door or warp,
// and nobody on it (or leaving it)
static BOOL CanStandBeside(FieldSystem *fieldSystem, const VecFx32 *playerPos, int x, int z)
{
    s8 vertical;
    u8 behavior = TerrainCollisionManager_GetTileBehavior(fieldSystem, x, z);

    if (TerrainCollisionManager_WillMapObjectCollide(fieldSystem, playerPos, x, z, &vertical)) {
        return FALSE;
    }

    if (TileBehavior_IsSurfable(behavior) || TileBehavior_IsDoor(behavior)
        || TileBehavior_IsWarpEast(behavior) || TileBehavior_IsWarpWest(behavior)
        || TileBehavior_IsWarpNorth(behavior) || TileBehavior_IsWarpSouth(behavior)
        || TileBehavior_IsWarpEntranceEast(behavior) || TileBehavior_IsWarpEntranceWest(behavior)
        || TileBehavior_IsWarpEntranceNorth(behavior) || TileBehavior_IsWarpEntranceSouth(behavior)
        || TileBehavior_IsWarpStairsEast(behavior) || TileBehavior_IsWarpStairsWest(behavior)
        || TileBehavior_IsWarpPanel(behavior)
        || TileBehavior_IsJumpNorth(behavior) || TileBehavior_IsJumpSouth(behavior)
        || TileBehavior_IsJumpWest(behavior) || TileBehavior_IsJumpEast(behavior)) {
        return FALSE;
    }

    return sub_0206326C(fieldSystem->mapObjMan, x, z, TRUE) == NULL;
}

// The tile the follower comes out on: behind the player, else to either side; never the player's own, nor the one
// ahead (the step out of a door goes there). FALSE when none is free: it comes out a step later.
static BOOL FindTileBeside(FieldSystem *fieldSystem, int *x, int *z)
{
    static const s8 sOffsets[4][2] = { [DIR_NORTH] = { 0, -1 }, [DIR_SOUTH] = { 0, 1 }, [DIR_WEST] = { -1, 0 }, [DIR_EAST] = { 1, 0 } };
    static const u8 sBehind[4] = { [DIR_NORTH] = DIR_SOUTH, [DIR_SOUTH] = DIR_NORTH, [DIR_WEST] = DIR_EAST, [DIR_EAST] = DIR_WEST };
    static const u8 sSides[4][2] = { [DIR_NORTH] = { DIR_WEST, DIR_EAST }, [DIR_SOUTH] = { DIR_EAST, DIR_WEST }, [DIR_WEST] = { DIR_NORTH, DIR_SOUTH }, [DIR_EAST] = { DIR_SOUTH, DIR_NORTH } };
    int facing = PlayerAvatar_GetFacingDir(fieldSystem->playerAvatar);
    int px = PlayerAvatar_GetXPos(fieldSystem->playerAvatar), pz = PlayerAvatar_GetZPos(fieldSystem->playerAvatar);
    VecFx32 playerPos;

    if (facing < DIR_NORTH || facing > DIR_EAST) {
        facing = DIR_SOUTH;
    }

    MapObject_GetPosPtr(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar), &playerPos);
    u8 tries[3] = { sBehind[facing], sSides[facing][0], sSides[facing][1] };

    for (int i = 0; i < 3; i++) {
        int tx = px + sOffsets[tries[i]][0], tz = pz + sOffsets[tries[i]][1];

        if (CanStandBeside(fieldSystem, &playerPos, tx, tz)) {
            *x = tx;
            *z = tz;
            return TRUE;
        }
    }

    return FALSE;
}

// Waiting on the player's tile, hidden: made as a map loads (the map's terrain isn't loaded yet, so no tile beside it
// can be checked), or a scene left it there with no tile free beside. It comes out once the player moves off it.
static BOOL sHiddenOnPlayer;

static BOOL IsOnPlayer(FieldSystem *fieldSystem, MapObject *follower)
{
    return MapObject_GetX(follower) == PlayerAvatar_GetXPos(fieldSystem->playerAvatar)
        && MapObject_GetZ(follower) == PlayerAvatar_GetZPos(fieldSystem->playerAvatar);
}

// The follower never stands on the player's tile in view: on it (standing still), it moves to a free tile beside the
// player, else waits there hidden; off it again, it shows. Only with the map's terrain loaded (on the field).
static void KeepOffPlayer(FieldSystem *fieldSystem, MapObject *follower)
{
    int x, z;

    if (MapObject_IsMoving(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar)) || MapObject_IsMoving(follower)) {
        return;
    }

    if (!IsOnPlayer(fieldSystem, follower)) {
        if (sHiddenOnPlayer) {
            sHiddenOnPlayer = FALSE;
            MapObject_SetHidden(follower, FALSE);
        }
    } else if (FindTileBeside(fieldSystem, &x, &z)) {
        MapObject_SetPosDirFromCoords(follower, x, 0, z, PlayerAvatar_GetFacingDir(fieldSystem->playerAvatar));
        MapObject_RecalculateObjectHeight(follower);
        sHiddenOnPlayer = FALSE;
        MapObject_SetHidden(follower, FALSE);
    } else if (!sHiddenOnPlayer) {
        sHiddenOnPlayer = TRUE;
        MapObject_SetHidden(follower, TRUE);
    }
}

// The follower on the player's tile, hidden (sHiddenOnPlayer)
static MapObject *AddOnPlayer(FieldSystem *fieldSystem)
{
    MapObject *follower = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, LOCALID_COMPLETE_FOLLOWER);

    if (follower != NULL) {
        MapObject_Delete(follower);
    }

    sHiddenOnPlayer = FALSE;

    int gfx = WantedGfx(fieldSystem);

    if (gfx < 0) {
        return NULL;
    }

    follower = MapObjectMan_AddMapObject(fieldSystem->mapObjMan,
        PlayerAvatar_GetXPos(fieldSystem->playerAvatar),
        PlayerAvatar_GetZPos(fieldSystem->playerAvatar),
        PlayerAvatar_GetFacingDir(fieldSystem->playerAvatar),
        gfx,
        MOVEMENT_TYPE_FOLLOW_PLAYER,
        fieldSystem->location->mapHeaderID);

    if (follower == NULL) {
        return NULL;
    }

    MapObject_SetLocalID(follower, LOCALID_COMPLETE_FOLLOWER);
    MapObject_SetScript(follower, SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_FOLLOWER_TALK));
    MapObject_SetStatusFlagOn(follower, MAP_OBJ_STATUS_PERSISTENT);
    MapObject_SetHidden(follower, TRUE);
    sHiddenOnPlayer = TRUE;
    return follower;
}

// As HeartGold's follower goes back in its ball on the bike and while surfing, and changes with the lead: on each
// field frame the player has control (src/overlay005/field_control.c), the follower is made again when it isn't the
// one the lead, the player and the map call for (the lead changed in the party menu or fainted, the player got on or
// off the bike or the water, or walked onto a map where nobody follows), or a scene put it away or left it behind
void CompleteFollower_Update(FieldSystem *fieldSystem)
{
    MapObject *follower = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, LOCALID_COMPLETE_FOLLOWER);
    int gfx = WantedGfx(fieldSystem);

    if (follower == NULL ? gfx < 0 : (int)MapObject_GetGraphicsID(follower) == gfx && (sHiddenOnPlayer || !MapObject_IsHidden(follower)) && !IsLeftBehind(fieldSystem, follower)) {
        if (follower != NULL) {
            KeepOffPlayer(fieldSystem, follower);
        }

        return;
    }

    CompleteFollower_Refresh(fieldSystem);
}

// On the field (a script, or the field frame above): beside the player at once, else on the player's tile, hidden
void CompleteFollower_Refresh(FieldSystem *fieldSystem)
{
    MapObject *follower = AddOnPlayer(fieldSystem);

    if (follower != NULL) {
        KeepOffPlayer(fieldSystem, follower);
    }
}

// As a map loads (src/field_map_change.c), before its terrain: on the player's tile, hidden, till the field runs
void CompleteFollower_RefreshOnMapLoad(FieldSystem *fieldSystem)
{
    AddOnPlayer(fieldSystem);
}

// The mood is in the byte HeartGold keeps it in: the high byte of block D's spare halfword (MON_DATA_UNUSED_159), whose
// low byte holds HeartGold's own Balls (src/pokemon.c)
s8 CompleteFollower_GetMood(Pokemon *mon)
{
    return (s8)(Pokemon_GetValue(mon, MON_DATA_UNUSED_159, NULL) >> 8);
}

void CompleteFollower_SetMood(Pokemon *mon, int mood)
{
    u16 value = Pokemon_GetValue(mon, MON_DATA_UNUSED_159, NULL);

    mood = mood > 127 ? 127 : mood < -127 ? -127 : mood;
    value = (value & 0xFF) | ((u8)mood << 8);
    Pokemon_SetValue(mon, MON_DATA_UNUSED_159, &value);
}

void CompleteFollower_AddMood(Pokemon *mon, int by)
{
    int species = Pokemon_GetValue(mon, MON_DATA_SPECIES_OR_EGG, NULL);

    if (species != SPECIES_NONE && species != SPECIES_EGG) {
        CompleteFollower_SetMood(mon, CompleteFollower_GetMood(mon) + by);
    }
}

// HeartGold's ItemIdGetMoodEffect: what using an item on a Pokémon does to its mood
int CompleteFollower_ItemMood(u16 item)
{
    switch (item) {
    case ITEM_RARE_CANDY:
        return 40;
    case ITEM_ENERGYPOWDER:
    case ITEM_HEAL_POWDER:
        return -20;
    case ITEM_ENERGY_ROOT:
        return -30;
    case ITEM_REVIVAL_HERB:
        return -40;
    case ITEM_HP_UP:
    case ITEM_PROTEIN:
    case ITEM_IRON:
    case ITEM_CARBOS:
    case ITEM_CALCIUM:
    case ITEM_ZINC:
        return 8;
    case ITEM_GUARD_SPEC:
    case ITEM_DIRE_HIT:
    case ITEM_X_ATTACK:
    case ITEM_X_DEFENSE:
    case ITEM_X_SPEED:
    case ITEM_X_ACCURACY:
    case ITEM_X_SPECIAL:
    case ITEM_X_SP_DEF:
        return 10;
    default:
        return 0;
    }
}

void CompleteFollower_MoodTowardsNeutral(FieldSystem *fieldSystem)
{
    if (MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, LOCALID_COMPLETE_FOLLOWER) == NULL) {
        return;
    }

    Pokemon *lead = Party_GetPokemonBySlotIndex(SaveData_GetParty(fieldSystem->saveData), 0);
    int mood = CompleteFollower_GetMood(lead);

    if (mood != 0) {
        CompleteFollower_SetMood(lead, mood < 0 ? mood + 1 : mood - 1);
    }
}

// The leaves are in block C's spare byte (MON_DATA_UNUSED_121)
u8 CompleteFollower_GetShinyLeaves(Pokemon *mon)
{
    return Pokemon_GetValue(mon, MON_DATA_UNUSED_121, NULL);
}

void CompleteFollower_SetShinyLeaves(Pokemon *mon, u8 leaves)
{
    Pokemon_SetValue(mon, MON_DATA_UNUSED_121, &leaves);
}

#ifdef SOVEREIGN_TEST
u16 gCompleteTestFollowerTile[2];
u16 gCompleteTestFollowerGfx;
u8 gCompleteTestFollowerHidden;
u8 gCompleteTestFollowerAction;
u16 gCompleteTestFollowerLead[2];

void CompleteFollower_TestRecordTile(FieldSystem *fieldSystem)
{
    MapObject *follower = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, LOCALID_COMPLETE_FOLLOWER);

    gCompleteTestFollowerTile[0] = follower != NULL ? MapObject_GetX(follower) : 0xFFFF;
    gCompleteTestFollowerTile[1] = follower != NULL ? MapObject_GetZ(follower) : 0xFFFF;
    gCompleteTestFollowerGfx = follower != NULL ? MapObject_GetGraphicsID(follower) : 0xFFFF;
    gCompleteTestFollowerHidden = follower != NULL && MapObject_IsHidden(follower);

    if (gCompleteTestFollowerAction == COMPLETE_TEST_FOLLOWER_NONE || FieldSystem_IsRunningTask(fieldSystem)) {
        return;
    }

    if (gCompleteTestFollowerAction == COMPLETE_TEST_FOLLOWER_SWAP_LEAD) {
        Party_SwapSlots(SaveData_GetParty(fieldSystem->saveData), 0, 1);
    } else if (gCompleteTestFollowerAction == COMPLETE_TEST_FOLLOWER_BICYCLE) { // as the Bicycle does
        BOOL cycling = PlayerAvatar_GetPlayerState(fieldSystem->playerAvatar) == PLAYER_AVATAR_CYCLING;

        PlayerAvatar_SetTransitionState(fieldSystem->playerAvatar, cycling ? PLAYER_TRANSITION_WALKING : PLAYER_TRANSITION_CYCLING);
        PlayerAvatar_RequestChangeState(fieldSystem->playerAvatar);
    } else if (gCompleteTestFollowerAction == COMPLETE_TEST_FOLLOWER_SET_LEAD) {
        Pokemon *lead = Party_GetPokemonBySlotIndex(SaveData_GetParty(fieldSystem->saveData), 0);
        u32 species = gCompleteTestFollowerLead[0], form = gCompleteTestFollowerLead[1];

        Pokemon_SetValue(lead, MON_DATA_SPECIES, &species);
        Pokemon_SetValue(lead, MON_DATA_FORM, &form);
    }

    gCompleteTestFollowerAction = COMPLETE_TEST_FOLLOWER_NONE;
}
#endif
