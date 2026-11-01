#include "complete_placed.h"

#include <nitro.h>
#include <string.h>

#include "constants/heap.h"
#include "constants/sovereign_totem_trials.h"
#include "generated/items.h"
#include "generated/map_headers.h"
#include "generated/movement_types.h"
#include "generated/object_events_gfx.h"
#include "generated/species.h"
#include "generated/trainer_types.h"
#include "generated/vars_flags.h"

#include "field/field_system.h"

#include "bag.h"
#include "complete_badges.h"
#include "map_object.h"
#include "party.h"
#include "pokedex.h"
#include "rtc.h"
#include "save_player.h"
#include "trainer_info.h"
#include "vars_flags.h"

#include "data/complete_placed.h"
#include "data/sovereign_totem_trials.h"

// Sovereign Complete: Sovereign's Totem trials and legendaries placed on other maps than Sovereign put them
// (data/complete/placed.yaml; docs/Features.md, "Totem trials and legendaries in three regions"). After a map's
// events load, the objects that moved away from it are taken out and those placed on it whose time has come are put
// in, each talking through CommonScript_CompletePlaced, which runs Sovereign's own trial or legendary encounter. One
// done (a trial won, a legendary caught) isn't put in again; a legendary that got away comes back on the next visit,
// as Sovereign's do.

#define MAX_OBJECT_EVENTS 96

static ObjectEvent sObjectEvents[MAX_OBJECT_EVENTS];
// The placed object whose battle is on (from CompletePlaced_Get), which the field coming back takes off the map
static int sBattling = -1;

static BOOL HasMoved(int mapHeaderID, int localID)
{
    for (int i = 0; i < NELEMS(sCompletePlacedMoved); i++) {
        if (sCompletePlacedMoved[i].mapHeaderID == mapHeaderID && sCompletePlacedMoved[i].localID == localID) {
            return TRUE;
        }
    }

    return FALSE;
}

static BOOL GateHolds(FieldSystem *fieldSystem, const CompletePlacedGate *gate)
{
    SaveData *saveData = fieldSystem->saveData;
    VarsFlags *varsFlags = SaveData_GetVarsFlags(saveData);

    switch (gate->type) {
    case PLACED_GATE_FLAG:
        return VarsFlags_CheckFlag(varsFlags, gate->id);
    case PLACED_GATE_FLAG_CLEAR:
        return !VarsFlags_CheckFlag(varsFlags, gate->id);
    case PLACED_GATE_VAR:
        return *VarsFlags_GetVarAddress(varsFlags, gate->id) >= gate->value;
    case PLACED_GATE_BADGE:
        return TrainerInfo_HasBadge(SaveData_GetTrainerInfo(saveData), gate->id);
    case PLACED_GATE_HGSS_BADGE:
        return CompleteBadges_Has(SaveData_GetTrainerInfo(saveData), gate->id);
    case PLACED_GATE_CAUGHT:
        return Pokedex_HasCaughtSpecies(SaveData_GetPokedex(saveData), gate->id);
    case PLACED_GATE_ITEM:
        return Bag_CanRemoveItem(SaveData_GetBag(saveData), gate->id, 1, HEAP_ID_FIELD1);
    case PLACED_GATE_PARTY:
        return Party_HasSpecies(SaveData_GetParty(saveData), gate->id);
    case PLACED_GATE_NIGHT:
        return GetTimeOfDay() >= TIMEOFDAY_NIGHT;
    default:
        return FALSE;
    }
}

// Whether it's on the map now: its gates hold and it isn't done (the trial won, the Pokémon caught)
static BOOL IsOut(FieldSystem *fieldSystem, const CompletePlaced *placed)
{
    VarsFlags *varsFlags = SaveData_GetVarsFlags(fieldSystem->saveData);

    if (placed->kind == PLACED_TOTEM) {
        if (VarsFlags_CheckFlag(varsFlags, FLAG_SOVEREIGN_TOTEM_TRIAL_GUMSHOOS + placed->value)) {
            return FALSE;
        }
    } else if (Pokedex_HasCaughtSpecies(SaveData_GetPokedex(fieldSystem->saveData), placed->value)) {
        return FALSE;
    }

    for (int i = 0; i < placed->numGates; i++) {
        if (!GateHolds(fieldSystem, &placed->gates[i])) {
            return FALSE;
        }
    }

    return TRUE;
}

void CompletePlaced_OnEventsLoaded(FieldSystem *fieldSystem, MapHeaderData *data, int mapHeaderID)
{
    BOOL here = FALSE;

    for (int i = 0; i < NELEMS(sCompletePlaced) && !here; i++) {
        here = sCompletePlaced[i].mapHeaderID == mapHeaderID;
    }
    for (int i = 0; i < NELEMS(sCompletePlacedMoved) && !here; i++) {
        here = sCompletePlacedMoved[i].mapHeaderID == mapHeaderID;
    }
    if (!here) {
        return;
    }

    int count = 0;

    for (int i = 0; i < data->numObjectEvents && count < MAX_OBJECT_EVENTS; i++) {
        if (!HasMoved(mapHeaderID, data->objectEvents[i].localID)) {
            sObjectEvents[count++] = data->objectEvents[i];
        }
    }

    for (int i = 0; i < NELEMS(sCompletePlaced) && count < MAX_OBJECT_EVENTS; i++) {
        const CompletePlaced *placed = &sCompletePlaced[i];

        if (placed->mapHeaderID != mapHeaderID || !IsOut(fieldSystem, placed)) {
            continue;
        }

        ObjectEvent *event = &sObjectEvents[count++];
        memset(event, 0, sizeof(ObjectEvent));
        event->localID = PLACED_LOCALID_BASE + i;
        event->graphicsID = placed->graphicsID;
        event->movementType = MOVEMENT_TYPE_NONE;
        event->trainerType = TRAINER_TYPE_NONE;
        event->script = SCRIPT_ID_COMPLETE_PLACED;
        event->dir = placed->dir;
        event->x = placed->x;
        event->z = placed->z;
    }

    data->objectEvents = sObjectEvents;
    data->numObjectEvents = count;
}

// The placed encounter an object (by its local ID) stands for, for CommonScript_CompletePlaced
BOOL CompletePlaced_Get(int localID, u16 *kind, u16 *value, u16 *level)
{
    int i = localID - PLACED_LOCALID_BASE;

    if (i < 0 || i >= NELEMS(sCompletePlaced)) {
        return FALSE;
    }

    sBattling = localID;
    *kind = sCompletePlaced[i].kind;
    *value = sCompletePlaced[i].value;
    *level = sCompletePlaced[i].level;
    return TRUE;
}

// As the field comes back after a battle (fieldmap.c, beside the map's OnLoad script), takes the placed object that
// was battled off the map: Sovereign's maps' OnLoad scripts do this for their own while its common script holds
// FLAG_SOVEREIGN_REMOVE_LEGENDARY (a legendary) or FLAG_MAP_LOCAL_REMOVE_OBJECT (a Totem) over the battle
void CompletePlaced_OnLoad(FieldSystem *fieldSystem)
{
    VarsFlags *varsFlags = SaveData_GetVarsFlags(fieldSystem->saveData);

    if (sBattling < 0 || !(VarsFlags_CheckFlag(varsFlags, FLAG_SOVEREIGN_REMOVE_LEGENDARY)
            || VarsFlags_CheckFlag(varsFlags, FLAG_MAP_LOCAL_REMOVE_OBJECT))) {
        return;
    }

    MapObject *mapObj = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, sBattling);

    if (mapObj != NULL) {
        MapObject_Delete(mapObj);
    }

    sBattling = -1;
}

// How far a moved Totem's level is from Sovereign's (Encounter_SovereignNewTotemTrial adds it to the Totem's and its
// helpers' levels)
int CompletePlaced_TotemLevelShift(int trial)
{
    int level = sCompletePlacedTotemLevels[trial];

    return level ? level - sSovereignTotemTrials[trial].totem.level : 0;
}
