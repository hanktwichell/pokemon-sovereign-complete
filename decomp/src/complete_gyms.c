#include "complete_gyms.h"

#include <nitro.h>

#include "constants/field/dynamic_map_features.h"
#include "generated/movement_actions.h"
#include "generated/vars_flags.h"

#include "field/field_system.h"
#include "field/field_system_sub2_t.h"
#include "overlay005/land_data.h"
#include "overlay005/map_prop.h"
#include "overlay005/map_prop_animation.h"

#include "field_system.h"
#include "field_task.h"
#include "heap.h"
#include "inlines.h"
#include "map_object.h"
#include "math_util.h"
#include "persisted_map_features.h"
#include "savedata_misc.h"
#include "script_manager.h"
#include "sound_playback.h"
#include "unk_020655F4.h"

// Sovereign Complete: HeartGold's gym puzzles (include/complete_gyms.h).

// HeartGold's indoor building model k is model 930 + k here (tools/complete/import_hgss_maps.py).
#define HGSS_INDOOR_MODEL(k) (930 + (k))

static void *PersistedData(FieldSystem *fieldSystem, int id)
{
    return PersistedMapFeatures_GetBuffer(MiscSaveBlock_GetPersistedMapFeatures(FieldSystem_GetSaveData(fieldSystem)), id);
}

static void *InitPersistedData(FieldSystem *fieldSystem, int id)
{
    return PersistedMapFeatures_InitWithID(MiscSaveBlock_GetPersistedMapFeatures(FieldSystem_GetSaveData(fieldSystem)), id);
}

// A building model on the map: HeartGold's gyms move parts of the map itself, which here are props of the loaded
// map chunks (Platinum's gyms load theirs into fieldSystem->mapPropManager).
static MapProp *FindMapProp(FieldSystem *fieldSystem, int modelID)
{
    MapPropManager *mapPropManager;

    for (u8 i = 0; i < 4; i++) {
        LandDataManager_GetLoadedMapPropManager(i, fieldSystem->landDataMan, &mapPropManager);
        MapProp *prop = mapPropManager != NULL ? MapPropManager_FindLoadedPropByModelID(mapPropManager, modelID) : NULL;

        if (prop != NULL) {
            return prop;
        }
    }

    return MapPropManager_FindLoadedPropByModelID(fieldSystem->mapPropManager, modelID);
}

// A building model's animations: stopped (removed from it) or playing (added back).
static void SetPropAnimations(FieldSystem *fieldSystem, int modelID, BOOL playing)
{
    MapProp *prop = FindMapProp(fieldSystem, modelID);

    if (prop == NULL) {
        return;
    }

    NNSG3dRenderObj *renderObj = MapProp_GetRenderObj(prop);
    u8 count = MapPropAnimationManager_GetPropAnimationCount(fieldSystem->mapPropAnimMan, modelID);

    for (u8 i = 0; i < count; i++) {
        if (playing) {
            MapPropAnimationManager_AddAnimationToRenderObj(modelID, i, FALSE, renderObj, fieldSystem->mapPropAnimMan);
        } else {
            MapPropAnimationManager_RemoveAnimationFromRenderObj(fieldSystem->mapPropAnimMan, renderObj, modelID, i);
        }
    }
}

// Vermilion Gym (HeartGold's vermilion.c and InitVermilionGym): two switches hide in fifteen trash cans, the second
// next to the first; each opens one of the two electric gates, which three "stop" objects hold shut.

#define VERMILION_TRASH_CANS 15
#define VERMILION_GATE_1     HGSS_INDOOR_MODEL(199)
#define VERMILION_GATE_2     HGSS_INDOOR_MODEL(200)

typedef struct VermilionGymPersistedData {
    u8 switches[2];
    u8 gates[2];
} VermilionGymPersistedData;

typedef struct VermilionGymGateTask {
    MapObject *stops[3];
    int modelID;
    u16 steps;
    u8 action;
    u8 state;
} VermilionGymGateTask;

enum VermilionGateTaskState {
    VERMILION_GATE_START = 0,
    VERMILION_GATE_OPEN,
    VERMILION_GATE_CLOSE,
    VERMILION_GATE_WAIT,
    VERMILION_GATE_STOP_ANIMATION,
    VERMILION_GATE_PLAY_ANIMATION,
    VERMILION_GATE_END,
};

static const struct {
    u8 count;
    u8 neighbors[4];
} sVermilionTrashCans[VERMILION_TRASH_CANS] = {
    { 2, { 1, 5, 0xFF, 0xFF } },
    { 3, { 0, 2, 6, 0xFF } },
    { 3, { 1, 3, 7, 0xFF } },
    { 3, { 2, 4, 8, 0xFF } },
    { 2, { 3, 9, 0xFF, 0xFF } },
    { 3, { 0, 6, 10, 0xFF } },
    { 4, { 1, 5, 7, 11 } },
    { 4, { 2, 6, 8, 12 } },
    { 4, { 3, 7, 9, 13 } },
    { 3, { 4, 8, 14, 0xFF } },
    { 2, { 5, 11, 0xFF, 0xFF } },
    { 3, { 6, 10, 12, 0xFF } },
    { 3, { 7, 11, 13, 0xFF } },
    { 3, { 8, 12, 14, 0xFF } },
    { 2, { 9, 13, 0xFF, 0xFF } },
};

static void VermilionGym_PlaceSwitches(VermilionGymPersistedData *data)
{
    data->switches[0] = LCRNG_Next() % VERMILION_TRASH_CANS;
    data->switches[1] = sVermilionTrashCans[data->switches[0]].neighbors[LCRNG_Next() % sVermilionTrashCans[data->switches[0]].count];
}

void CompleteVermilionGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem)
{
    VermilionGymPersistedData *data = PersistedData(fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_VERMILION_GYM);

    // an open gate's sparks stop
    if (data->gates[0]) {
        SetPropAnimations(fieldSystem, VERMILION_GATE_1, FALSE);
    }

    if (data->gates[1]) {
        SetPropAnimations(fieldSystem, VERMILION_GATE_2, FALSE);
    }
}

void CompleteVermilionGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem)
{
}

static BOOL VermilionGym_GateTask(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    VermilionGymGateTask *gate = FieldTask_GetEnv(task);

    switch (gate->state) {
    case VERMILION_GATE_START: {
        int first = gate->modelID == VERMILION_GATE_1 ? 3 : 0; // the stops 4 to 6 hold the first gate, 1 to 3 the second

        for (int i = 0; i < 3; i++) {
            gate->stops[i] = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, first + i);
        }

        gate->steps = 0;
        gate->state = gate->action;
        break;
    }
    case VERMILION_GATE_OPEN:
    case VERMILION_GATE_CLOSE: {
        BOOL open = gate->state == VERMILION_GATE_OPEN;

        for (int i = 0; i < 3; i++) {
            if (gate->stops[i] != NULL) {
                BOOL west = (i < 2) == open;
                LocalMapObj_SetAnimationCode(gate->stops[i], west ? MOVEMENT_ACTION_WALK_FASTER_WEST : MOVEMENT_ACTION_WALK_FASTER_EAST);
            }
        }

        gate->state = VERMILION_GATE_WAIT;
        break;
    }
    case VERMILION_GATE_WAIT: {
        int i;

        for (i = 0; i < 3; i++) {
            if (gate->stops[i] != NULL && !LocalMapObj_IsAnimationSet(gate->stops[i])) {
                break;
            }
        }

        if (i == 3) {
            // two steps each
            if (++gate->steps >= 2) {
                gate->state = gate->action == VERMILION_GATE_OPEN ? VERMILION_GATE_STOP_ANIMATION : VERMILION_GATE_PLAY_ANIMATION;
            } else {
                gate->state = gate->action;
            }
        }

        break;
    }
    case VERMILION_GATE_STOP_ANIMATION:
    case VERMILION_GATE_PLAY_ANIMATION:
        SetPropAnimations(fieldSystem, gate->modelID, gate->state == VERMILION_GATE_PLAY_ANIMATION);
        Sound_PlayEffect(SEQ_SE_DP_UG_020_sseq);
        gate->state = VERMILION_GATE_END;
        break;
    case VERMILION_GATE_END:
        Heap_Free(gate);
        return TRUE;
    }

    return FALSE;
}

// HeartGold's VermilionGymInit: with the Thunder Badge both gates stay open; otherwise new switches. Johto's and
// Kanto's badges aren't in the save yet (step 7), so beating Lt. Surge stands in for it: his win hides the stops.
BOOL CompleteScrCmd_VermilionGymInit(ScriptContext *ctx)
{
    VermilionGymPersistedData *data = InitPersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_VERMILION_GYM);

    if (FieldSystem_CheckFlag(ctx->fieldSystem, FLAG_HGSS_HIDE_VERMILION_GYM_STOPS)) {
        data->switches[0] = 0;
        data->switches[1] = 0;
        data->gates[0] = TRUE;
        data->gates[1] = TRUE;
    } else {
        VermilionGym_PlaceSwitches(data);
        data->gates[0] = FALSE;
        data->gates[1] = FALSE;
    }

    return FALSE;
}

// HeartGold's VermilionGymCanCheck can, destVar: 4 with both gates open; with the first open, 2 for the second
// switch's can and 3 for another; else 1 for the first switch's can and 0 for another.
BOOL CompleteScrCmd_VermilionGymCanCheck(ScriptContext *ctx)
{
    u8 can = ScriptContext_ReadByte(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    VermilionGymPersistedData *data = PersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_VERMILION_GYM);

    if (data->gates[0] && data->gates[1]) {
        *destVar = 4;
    } else if (data->gates[0]) {
        *destVar = can == data->switches[1] ? 2 : 3;
    } else {
        *destVar = can == data->switches[0];
    }

    return FALSE;
}

// HeartGold's VermilionGymLockAction gate, relock: open a gate (its stops step aside, its sparks stop) or close the
// first one again (a wrong second can).
BOOL CompleteScrCmd_VermilionGymLockAction(ScriptContext *ctx)
{
    u8 lock = ScriptContext_ReadByte(ctx);
    u8 relock = ScriptContext_ReadByte(ctx);
    VermilionGymPersistedData *data = PersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_VERMILION_GYM);

    GF_ASSERT(lock < 2 && !(lock == 1 && relock));

    VermilionGymGateTask *gate = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(VermilionGymGateTask));
    gate->modelID = lock == 0 ? VERMILION_GATE_1 : VERMILION_GATE_2;
    gate->action = relock ? VERMILION_GATE_CLOSE : VERMILION_GATE_OPEN;
    gate->state = VERMILION_GATE_START;
    data->gates[lock] = !relock;

    FieldTask_InitCall(ctx->fieldSystem->task, VermilionGym_GateTask, gate);
    return TRUE;
}

// HeartGold's ResampleVermilionGymCans: new switches (after a wrong second can).
BOOL CompleteScrCmd_VermilionGymResampleCans(ScriptContext *ctx)
{
    VermilionGym_PlaceSwitches(PersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_VERMILION_GYM));
    return FALSE;
}
