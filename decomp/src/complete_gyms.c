#include "complete_gyms.h"

#include <nitro.h>
#include <string.h>

#include "constants/field/complete_tile_behaviors.h"
#include "constants/field/dynamic_map_features.h"
#include "generated/movement_actions.h"
#include "generated/vars_flags.h"

#include "field/field_system.h"
#include "field/field_system_sub2_t.h"
#include "overlay005/dynamic_terrain_height.h"
#include "overlay005/fog_manager.h"
#include "overlay005/land_data.h"
#include "overlay005/map_prop.h"
#include "overlay005/map_prop_animation.h"
#include "overlay005/ov5_021EB1A0.h"

#include "billboard.h"
#include "camera.h"
#include "field_system.h"
#include "field_task.h"
#include "heap.h"
#include "inlines.h"
#include "map_object.h"
#include "map_object_move.h"
#include "math_util.h"
#include "persisted_map_features.h"
#include "player_avatar.h"
#include "savedata_misc.h"
#include "script_manager.h"
#include "sound_playback.h"
#include "sys_task.h"
#include "terrain_collision_manager.h"
#include "unk_020655F4.h"

#include "complete_follower.h"

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

// Violet Gym (HeartGold's violet.c and InitVioletGym): a lift up to Falkner's floor, which the gym's script runs when
// the player steps on it. It is Platinum's platform lift (src/platform_lift.c) with HeartGold's model, place and
// speed; the following Pokémon rides along, as in HeartGold. HeartGold also set the 3D edge colours for this map;
// Platinum's stay.

#define VIOLET_LIFT          HGSS_INDOOR_MODEL(111)
#define VIOLET_LIFT_PLATE_ID 0
#define VIOLET_LIFT_DOWN     FX32_CONST(32)
#define VIOLET_LIFT_UP       FX32_CONST(496)
#define VIOLET_LIFT_SPEED    FX32_CONST(16)

typedef struct VioletGymPersistedData {
    u8 liftUp;
} VioletGymPersistedData;

typedef struct VioletGymLiftTask {
    fx32 targetHeight;
    u8 state;
    u8 followerWasPaused;
} VioletGymLiftTask;

enum VioletLiftTaskState {
    VIOLET_LIFT_WAIT_FOR_FOLLOWER = 0,
    VIOLET_LIFT_START,
    VIOLET_LIFT_MOVE,
    VIOLET_LIFT_STOP,
    VIOLET_LIFT_END,
};

static MapObject *Follower(FieldSystem *fieldSystem)
{
    return MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, LOCALID_COMPLETE_FOLLOWER);
}

void CompleteVioletGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem)
{
    VioletGymPersistedData *data = PersistedData(fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_VIOLET_GYM);
    VecFx32 position = { FX32_CONST(0xF8), data->liftUp ? VIOLET_LIFT_UP : VIOLET_LIFT_DOWN, FX32_CONST(0x148) };

    MapPropManager_LoadOne(fieldSystem->mapPropManager, fieldSystem->areaDataManager, VIOLET_LIFT, &position, NULL, fieldSystem->mapPropAnimMan);
    DynamicTerrainHeightManager_SetPlate(VIOLET_LIFT_PLATE_ID, 14, 19, 3, 3, position.y, fieldSystem->dynamicTerrainHeightMan);
}

void CompleteVioletGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem)
{
}

static BOOL VioletGym_LiftTask(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    VioletGymLiftTask *lift = FieldTask_GetEnv(task);
    MapObject *follower = Follower(fieldSystem);

    switch (lift->state) {
    case VIOLET_LIFT_WAIT_FOR_FOLLOWER:
        // HeartGold's ov01_02205A60: the follower finishes its step onto the lift first
        if (follower != NULL && MapObject_IsMovementPaused(follower) && !lift->followerWasPaused) {
            MapObject_SetPauseMovementOff(follower);
            lift->followerWasPaused = TRUE;
        }

        if (follower == NULL || LocalMapObj_CheckAnimationFinished(follower)) {
            if (follower != NULL && lift->followerWasPaused) {
                MapObject_SetPauseMovementOn(follower);
            }

            lift->state = VIOLET_LIFT_START;
        }

        break;
    case VIOLET_LIFT_START:
        PlayerAvatar_SetHeightCalculationEnabled(fieldSystem->playerAvatar, FALSE);
        Sound_PlayEffect(SEQ_SE_DP_ELEBETA_sseq);
        lift->state = VIOLET_LIFT_MOVE;
        break;
    case VIOLET_LIFT_MOVE: {
        MapProp *prop = MapPropManager_FindLoadedPropByModelID(fieldSystem->mapPropManager, VIOLET_LIFT);
        VecFx32 position = MapProp_GetPosition(prop);
        fx32 step = lift->targetHeight > position.y ? VIOLET_LIFT_SPEED : -VIOLET_LIFT_SPEED;

        position.y += step;

        if ((step > 0 && position.y >= lift->targetHeight) || (step < 0 && position.y <= lift->targetHeight)) {
            position.y = lift->targetHeight;
            Sound_StopEffect(SEQ_SE_DP_ELEBETA_sseq, 0);
            lift->state = VIOLET_LIFT_STOP;
        }

        // the player and the follower move with it (HeartGold's ov01_02205A34)
        VecFx32 playerPosition;
        MapObject_GetPosPtr(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar), &playerPosition);
        Player_SetYPos(fieldSystem->playerAvatar, playerPosition.y + step);

        if (follower != NULL) {
            VecFx32 followerPosition;
            MapObject_GetPosPtr(follower, &followerPosition);
            followerPosition.y = playerPosition.y + step;
            MapObject_SetPos(follower, &followerPosition);
        }

        MapProp_SetPosition(prop, &position);
        break;
    }
    case VIOLET_LIFT_STOP:
        DynamicTerrainHeightManager_SetHeight(VIOLET_LIFT_PLATE_ID, lift->targetHeight, fieldSystem->dynamicTerrainHeightMan);
        PlayerAvatar_SetHeightCalculationEnabledAndUpdate(fieldSystem->playerAvatar, TRUE);
        Sound_PlayEffect(SEQ_SE_DP_KI_GASYAN_sseq);
        lift->state = VIOLET_LIFT_END;
        break;
    case VIOLET_LIFT_END:
        Heap_Free(lift);
        return TRUE;
    }

    return FALSE;
}

// HeartGold's VioletGymInit: the lift starts down.
BOOL CompleteScrCmd_VioletGymInit(ScriptContext *ctx)
{
    VioletGymPersistedData *data = InitPersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_VIOLET_GYM);
    data->liftUp = FALSE;
    return FALSE;
}

// HeartGold's VioletGymElevator: the lift goes up with the player, or down.
BOOL CompleteScrCmd_VioletGymLift(ScriptContext *ctx)
{
    VioletGymPersistedData *data = PersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_VIOLET_GYM);
    VioletGymLiftTask *lift = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(VioletGymLiftTask));
    VecFx32 playerPosition;

    MapObject_GetPosPtr(PlayerAvatar_GetMapObject(ctx->fieldSystem->playerAvatar), &playerPosition);
    data->liftUp = playerPosition.y == VIOLET_LIFT_DOWN;
    lift->targetHeight = data->liftUp ? VIOLET_LIFT_UP : VIOLET_LIFT_DOWN;
    lift->state = VIOLET_LIFT_WAIT_FOR_FOLLOWER;
    lift->followerWasPaused = FALSE;

    FieldTask_InitCall(ctx->fieldSystem->task, VioletGym_LiftTask, lift);
    return TRUE;
}

// Cianwood Gym (HeartGold's cianwood.c): after Chuck's battle, turning the winch stops the waterfall he trains under.
// The camera pans to the waterfall while the winch (model 174's animations, played on model 173) and the waterfall's
// end (175) run once; then they stay at their last frame.

#define CIANWOOD_WINCH          HGSS_INDOOR_MODEL(173)
#define CIANWOOD_WINCH_TURNING  HGSS_INDOOR_MODEL(174)
#define CIANWOOD_WATERFALL      HGSS_INDOOR_MODEL(175)
#define CIANWOOD_CAMERA_FRAMES  24

typedef struct CianwoodGymPersistedData {
    u8 winchTurned;
} CianwoodGymPersistedData;

typedef struct CianwoodGymWinchTask {
    VecFx32 pan;
    VecFx32 panned;
    u8 frame;
    u8 state;
} CianwoodGymWinchTask;

enum CianwoodWinchTaskState {
    CIANWOOD_WINCH_PAN_TO_WATERFALL = 0,
    CIANWOOD_WINCH_TURN,
    CIANWOOD_WINCH_WAIT,
    CIANWOOD_WINCH_PAN_BACK,
    CIANWOOD_WINCH_END,
};

// The winch model's own animations off, the turning ones on it, and the waterfall's on the waterfall. Returns how
// many turning animations there are.
static int CianwoodGym_BindWinchAnimations(FieldSystem *fieldSystem)
{
    MapProp *winch = FindMapProp(fieldSystem, CIANWOOD_WINCH);
    MapProp *waterfall = FindMapProp(fieldSystem, CIANWOOD_WATERFALL);
    int count;

    if (winch == NULL || waterfall == NULL) {
        return 0;
    }

    count = MapPropAnimationManager_GetPropAnimationCount(fieldSystem->mapPropAnimMan, CIANWOOD_WINCH);

    for (int i = 0; i < count; i++) {
        MapPropAnimationManager_RemoveAnimationFromRenderObj(fieldSystem->mapPropAnimMan, MapProp_GetRenderObj(winch), CIANWOOD_WINCH, i);
    }

    count = MapPropAnimationManager_GetPropAnimationCount(fieldSystem->mapPropAnimMan, CIANWOOD_WINCH_TURNING);

    for (int i = 0; i < count; i++) {
        MapPropAnimationManager_AddAnimationToRenderObj(CIANWOOD_WINCH_TURNING, i, TRUE, MapProp_GetRenderObj(winch), fieldSystem->mapPropAnimMan);
    }

    MapPropAnimationManager_AddAnimationToRenderObj(CIANWOOD_WATERFALL, 0, TRUE, MapProp_GetRenderObj(waterfall), fieldSystem->mapPropAnimMan);
    return count;
}

static MapPropAnimation *CianwoodGym_WaterfallAnimation(FieldSystem *fieldSystem)
{
    return MapPropAnimationManager_GetAnimation(CIANWOOD_WATERFALL, 0, fieldSystem->mapPropAnimMan);
}

void CompleteCianwoodGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem)
{
    CianwoodGymPersistedData *data = PersistedData(fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_CIANWOOD_GYM);

    if (!data->winchTurned) {
        return;
    }

    int count = CianwoodGym_BindWinchAnimations(fieldSystem);

    for (int i = 0; i < count; i++) {
        MapPropAnimation *animation = MapPropAnimationManager_GetAnimation(CIANWOOD_WINCH_TURNING, i, fieldSystem->mapPropAnimMan);
        MapPropAnimation_SetAnimationPaused(animation, TRUE);
        MapPropAnimation_GoToLastFrame(animation);
    }

    if (count > 0) {
        MapPropAnimation_SetAnimationPaused(CianwoodGym_WaterfallAnimation(fieldSystem), TRUE);
        MapPropAnimation_GoToLastFrame(CianwoodGym_WaterfallAnimation(fieldSystem));
    }
}

void CompleteCianwoodGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem)
{
}

// Moves the camera a frame's share of the way to pan from where it has panned so far.
static BOOL CianwoodGym_PanCamera(FieldSystem *fieldSystem, CianwoodGymWinchTask *winch, const VecFx32 *to)
{
    VecFx32 next, delta;

    winch->frame++;
    next.x = winch->pan.x + (to->x - winch->pan.x) * winch->frame / CIANWOOD_CAMERA_FRAMES;
    next.y = winch->pan.y + (to->y - winch->pan.y) * winch->frame / CIANWOOD_CAMERA_FRAMES;
    next.z = winch->pan.z + (to->z - winch->pan.z) * winch->frame / CIANWOOD_CAMERA_FRAMES;
    VEC_Subtract(&next, &winch->panned, &delta);
    Camera_Move(&delta, fieldSystem->camera);
    winch->panned = next;

    if (winch->frame >= CIANWOOD_CAMERA_FRAMES) {
        winch->pan = next;
        winch->frame = 0;
        return TRUE;
    }

    return FALSE;
}

static BOOL CianwoodGym_WinchTask(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    CianwoodGymWinchTask *winch = FieldTask_GetEnv(task);

    switch (winch->state) {
    case CIANWOOD_WINCH_PAN_TO_WATERFALL: {
        VecFx32 waterfall = { 50 * FX32_ONE, 0, 58 * FX32_ONE };

        if (CianwoodGym_PanCamera(fieldSystem, winch, &waterfall)) {
            winch->state = CIANWOOD_WINCH_TURN;
        }

        break;
    }
    case CIANWOOD_WINCH_TURN: {
        int count = CianwoodGym_BindWinchAnimations(fieldSystem);

        for (int i = 0; i < count; i++) {
            MapPropAnimation *animation = MapPropAnimationManager_GetAnimation(CIANWOOD_WINCH_TURNING, i, fieldSystem->mapPropAnimMan);
            MapPropAnimation_SetLoopCount(animation, 1);
            MapPropAnimation_GoToFirstFrame(animation);
        }

        if (count > 0) {
            MapPropAnimation_SetLoopCount(CianwoodGym_WaterfallAnimation(fieldSystem), 1);
            MapPropAnimation_GoToFirstFrame(CianwoodGym_WaterfallAnimation(fieldSystem));
            winch->state = CIANWOOD_WINCH_WAIT;
        } else {
            winch->state = CIANWOOD_WINCH_PAN_BACK;
        }

        break;
    }
    case CIANWOOD_WINCH_WAIT:
        if (MapPropAnimation_IsLoopFinished(CianwoodGym_WaterfallAnimation(fieldSystem))) {
            winch->state = CIANWOOD_WINCH_PAN_BACK;
        }

        break;
    case CIANWOOD_WINCH_PAN_BACK: {
        VecFx32 back = { 0, 0, 0 };

        if (CianwoodGym_PanCamera(fieldSystem, winch, &back)) {
            winch->state = CIANWOOD_WINCH_END;
        }

        break;
    }
    case CIANWOOD_WINCH_END:
        Heap_Free(winch);
        return TRUE;
    }

    return FALSE;
}

// HeartGold's CianwoodGymInit: the waterfall runs.
BOOL CompleteScrCmd_CianwoodGymInit(ScriptContext *ctx)
{
    CianwoodGymPersistedData *data = InitPersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_CIANWOOD_GYM);
    data->winchTurned = FALSE;
    return FALSE;
}

// HeartGold's CianwoodGymTurnWinch destVar: stops the waterfall (destVar 1), or nothing if it has stopped (0).
BOOL CompleteScrCmd_CianwoodGymTurnWinch(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    PersistedMapFeatures *features = MiscSaveBlock_GetPersistedMapFeatures(FieldSystem_GetSaveData(ctx->fieldSystem));

    *destVar = FALSE;

    if (PersistedMapFeatures_GetID(features) != DYNAMIC_MAP_FEATURES_HGSS_CIANWOOD_GYM) {
        return FALSE;
    }

    CianwoodGymPersistedData *data = PersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_CIANWOOD_GYM);

    if (data->winchTurned) {
        return FALSE;
    }

    CianwoodGymWinchTask *winch = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(CianwoodGymWinchTask));
    winch->pan = (VecFx32) { 0, 0, 0 };
    winch->panned = winch->pan;
    winch->frame = 0;
    winch->state = CIANWOOD_WINCH_PAN_TO_WATERFALL;
    data->winchTurned = TRUE;
    *destVar = TRUE;

    FieldTask_InitCall(ctx->fieldSystem->task, CianwoodGym_WinchTask, winch);
    return TRUE;
}

// Azalea Gym (HeartGold's azalea.c and InitAzaleaGym): four Spinarak carts ride on silk threads between twelve stops,
// three in each of four rows; two switches each turn a pair of points and so choose where the carts go. Riding one
// carries the player (and the follower, on the tile behind) along the cart's route.

#define AZALEA_SPINARAK          HGSS_INDOOR_MODEL(118)
#define AZALEA_POINTS_1          HGSS_INDOOR_MODEL(115)
#define AZALEA_POINTS_2          HGSS_INDOOR_MODEL(116)
#define AZALEA_POINTS_3          HGSS_INDOOR_MODEL(117)
#define AZALEA_POINTS_4          HGSS_INDOOR_MODEL(122)
#define AZALEA_CARTS             4
#define AZALEA_STOPS             12
#define AZALEA_ONE_SHOT_TAG      8 // the cart's ride animation (doors use 1 and 2)

typedef struct AzaleaGymPersistedData {
    u8 spiders[AZALEA_CARTS]; // the stop each cart waits at
    u8 switches; // bit 0: switch 1, bit 1: switch 2
} AzaleaGymPersistedData;

typedef struct AzaleaRouteNode {
    u16 x;
    u16 z;
} AzaleaRouteNode;

typedef struct AzaleaRoute {
    u16 length;
    u16 destination;
    const AzaleaRouteNode *route;
} AzaleaRoute;

typedef struct AzaleaGymData {
    u8 cartProps[AZALEA_CARTS];
} AzaleaGymData;

typedef struct AzaleaGymRideTask {
    const AzaleaRouteNode *node;
    VecFx32 cartPos;
    VecFx32 moveVector;
    BOOL moveSigns[2];
    fx32 shakeDirection;
    int shakeCount;
    int shakeFrame;
    int wait;
    BOOL mapTrackingOff;
    u8 state;
    u8 stop;
    u8 cart;
    u8 switches;
    u8 backwards;
    u8 nodeIndex;
    u8 nodesDone;
    u8 segmentDone;
    s8 playerZOffset;
    u8 followerWasPaused;
} AzaleaGymRideTask;

enum AzaleaRideTaskState {
    AZALEA_RIDE_WAIT_FOR_FOLLOWER = 0,
    AZALEA_RIDE_STEP_ON,
    AZALEA_RIDE_WAIT_STEP_ON,
    AZALEA_RIDE_START_CART,
    AZALEA_RIDE_MOVE,
    AZALEA_RIDE_ARRIVE,
    AZALEA_RIDE_SHAKE,
    AZALEA_RIDE_STEP_OFF,
    AZALEA_RIDE_WAIT_STEP_OFF,
    AZALEA_RIDE_END,
};

static const AzaleaRouteNode sAzaleaRoute_1to5[] = { { 3, 31 }, { 3, 29 }, { 9, 29 }, { 9, 27 }, { 15, 28 }, { 15, 25 }, { 9, 25 }, { 9, 24 } };
static const AzaleaRouteNode sAzaleaRoute_2to6[] = { { 9, 31 }, { 9, 29 }, { 3, 29 }, { 3, 27 }, { 9, 26 }, { 9, 25 }, { 15, 25 }, { 15, 24 } };
static const AzaleaRouteNode sAzaleaRoute_3to4[] = { { 15, 31 }, { 15, 28 }, { 9, 27 }, { 9, 26 }, { 3, 27 }, { 3, 24 } };
static const AzaleaRouteNode sAzaleaRoute_7to10[] = { { 3, 16 }, { 3, 12 }, { 9, 13 }, { 9, 10 }, { 3, 10 }, { 3, 9 } };
static const AzaleaRouteNode sAzaleaRoute_7to11[] = { { 3, 16 }, { 3, 12 }, { 9, 13 }, { 9, 9 } };
static const AzaleaRouteNode sAzaleaRoute_8to10[] = { { 9, 16 }, { 9, 14 }, { 15, 14 }, { 15, 11 }, { 9, 12 }, { 9, 10 }, { 3, 10 }, { 3, 9 } };
static const AzaleaRouteNode sAzaleaRoute_8to12[] = { { 9, 16 }, { 9, 14 }, { 15, 14 }, { 15, 9 } };
static const AzaleaRouteNode sAzaleaRoute_8to11[] = { { 9, 16 }, { 9, 14 }, { 15, 14 }, { 15, 11 }, { 9, 12 }, { 9, 9 } };

static const AzaleaRouteNode sAzaleaStops[AZALEA_STOPS] = {
    { 3, 31 }, { 9, 31 }, { 15, 31 },
    { 3, 24 }, { 9, 24 }, { 15, 24 },
    { 3, 16 }, { 9, 16 }, { 15, 16 },
    { 3, 9 }, { 9, 9 }, { 15, 9 },
};

#define ROUTE(r, to) { NELEMS(r), to, r }
#define SAME_ROUTE(r, to) { ROUTE(r, to), ROUTE(r, to), ROUTE(r, to), ROUTE(r, to) }

// [stop][switches]: the route from a stop, by the switches' state (zero length: the points send no cart that way)
static const AzaleaRoute sAzaleaRoutes[AZALEA_STOPS][4] = {
    SAME_ROUTE(sAzaleaRoute_1to5, 4),
    SAME_ROUTE(sAzaleaRoute_2to6, 5),
    SAME_ROUTE(sAzaleaRoute_3to4, 3),
    SAME_ROUTE(sAzaleaRoute_3to4, 2),
    SAME_ROUTE(sAzaleaRoute_1to5, 0),
    SAME_ROUTE(sAzaleaRoute_2to6, 1),
    { {}, ROUTE(sAzaleaRoute_7to10, 9), {}, ROUTE(sAzaleaRoute_7to11, 10) },
    { ROUTE(sAzaleaRoute_8to10, 9), ROUTE(sAzaleaRoute_8to12, 11), ROUTE(sAzaleaRoute_8to11, 10), ROUTE(sAzaleaRoute_8to12, 11) },
    { {}, {}, {}, {} },
    { ROUTE(sAzaleaRoute_8to10, 7), ROUTE(sAzaleaRoute_7to10, 6), {}, {} },
    { {}, {}, ROUTE(sAzaleaRoute_8to11, 7), ROUTE(sAzaleaRoute_7to11, 6) },
    { {}, ROUTE(sAzaleaRoute_8to12, 7), {}, ROUTE(sAzaleaRoute_8to12, 7) },
};

#undef SAME_ROUTE
#undef ROUTE

// The points' animations for the switches' state: switch 1 sets models 116 and 117, switch 2 models 115 and 122.
static void AzaleaGym_SetPoints(FieldSystem *fieldSystem, int modelID, int animation, BOOL on)
{
    MapProp *prop = FindMapProp(fieldSystem, modelID);

    if (prop == NULL) {
        return;
    }

    if (on) {
        MapPropAnimationManager_AddAnimationToRenderObj(modelID, animation, TRUE, MapProp_GetRenderObj(prop), fieldSystem->mapPropAnimMan);
    } else {
        MapPropAnimationManager_RemoveAnimationFromRenderObj(fieldSystem->mapPropAnimMan, MapProp_GetRenderObj(prop), modelID, animation);
    }
}

void CompleteAzaleaGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem)
{
    AzaleaGymPersistedData *data = PersistedData(fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_AZALEA_GYM);
    AzaleaGymData *gym = Heap_Alloc(HEAP_ID_FIELD1, sizeof(AzaleaGymData));

    fieldSystem->unk_04->dynamicMapFeaturesData = gym;

    for (int i = 0; i < AZALEA_CARTS; i++) {
        const AzaleaRouteNode *stop = &sAzaleaStops[data->spiders[i]];
        VecFx32 position = { stop->x * 16 * FX32_ONE + FX32_CONST(8), 0, stop->z * 16 * FX32_ONE };

        gym->cartProps[i] = MapPropManager_LoadOne(fieldSystem->mapPropManager, fieldSystem->areaDataManager, AZALEA_SPINARAK, &position, NULL, fieldSystem->mapPropAnimMan);
    }

    u8 switch1 = data->switches & 1, switch2 = (data->switches >> 1) & 1;

    AzaleaGym_SetPoints(fieldSystem, AZALEA_POINTS_1, switch2, TRUE);
    AzaleaGym_SetPoints(fieldSystem, AZALEA_POINTS_2, switch1, TRUE);
    AzaleaGym_SetPoints(fieldSystem, AZALEA_POINTS_4, switch2, TRUE);
    AzaleaGym_SetPoints(fieldSystem, AZALEA_POINTS_3, switch1, TRUE);
}

void CompleteAzaleaGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem)
{
    Heap_Free(fieldSystem->unk_04->dynamicMapFeaturesData);
    fieldSystem->unk_04->dynamicMapFeaturesData = NULL;
}

// Whether the cart has reached a node's coordinate (1), passed it (2) or not yet (0).
static int AzaleaGym_NodeReached(BOOL positive, fx32 position, fx32 step, u16 node)
{
    fx32 target = node * FX32_ONE * 16;

    if (position + step == target) {
        return 1;
    }

    return (positive ? position + step > target : position + step < target) ? 2 : 0;
}

static void AzaleaGym_StepRiders(FieldSystem *fieldSystem, AzaleaGymRideTask *ride, MapObject *follower, enum MovementAction north, enum MovementAction south)
{
    enum MovementAction action = ride->backwards ? south : north;

    LocalMapObj_SetAnimationCode(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar), action);

    if (follower != NULL) {
        LocalMapObj_SetAnimationCode(follower, action);
    }
}

static BOOL AzaleaGym_RidersStepped(FieldSystem *fieldSystem, MapObject *follower)
{
    return LocalMapObj_IsAnimationSet(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar)) && (follower == NULL || LocalMapObj_IsAnimationSet(follower));
}

static BOOL AzaleaGym_RideTask(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    AzaleaGymRideTask *ride = FieldTask_GetEnv(task);
    AzaleaGymData *gym = fieldSystem->unk_04->dynamicMapFeaturesData;
    MapObject *player = PlayerAvatar_GetMapObject(fieldSystem->playerAvatar);
    MapObject *follower = Follower(fieldSystem);
    const AzaleaRoute *route = &sAzaleaRoutes[ride->stop][ride->switches];

    switch (ride->state) {
    case AZALEA_RIDE_WAIT_FOR_FOLLOWER:
        if (follower != NULL && MapObject_IsMovementPaused(follower) && !ride->followerWasPaused) {
            MapObject_SetPauseMovementOff(follower);
            ride->followerWasPaused = TRUE;
        }

        if (follower == NULL || LocalMapObj_CheckAnimationFinished(follower)) {
            if (follower != NULL && ride->followerWasPaused) {
                MapObject_SetPauseMovementOn(follower);
            }

            ride->state = AZALEA_RIDE_STEP_ON;
        }

        break;
    case AZALEA_RIDE_STEP_ON:
        AzaleaGym_StepRiders(fieldSystem, ride, follower, MOVEMENT_ACTION_WALK_NORMAL_NORTH, MOVEMENT_ACTION_WALK_NORMAL_SOUTH);
        ride->state = AZALEA_RIDE_WAIT_STEP_ON;
        // fall through
    case AZALEA_RIDE_WAIT_STEP_ON:
        if (AzaleaGym_RidersStepped(fieldSystem, follower)) {
            LocalMapObj_SetAnimationCode(player, MOVEMENT_ACTION_PAUSE_ANIMATION);
            ride->wait = 0;
            ride->state = AZALEA_RIDE_START_CART;
        }

        break;
    case AZALEA_RIDE_START_CART:
        if (ride->wait++ >= 4) {
            MapProp *cart = MapPropManager_GetLoadedPropSafely(fieldSystem->mapPropManager, gym->cartProps[ride->cart]);

            MapPropOneShotAnimationManager_LoadPropAnimations(fieldSystem->mapPropAnimMan, fieldSystem->mapPropOneShotAnimMan, AZALEA_ONE_SHOT_TAG, AZALEA_SPINARAK, MapProp_GetRenderObj(cart), MapProp_GetModel(cart), AreaDataManager_GetMapPropTexture(fieldSystem->areaDataManager), 1, 255, FALSE);
            MapPropOneShotAnimationManager_PlayAnimation(fieldSystem->mapPropOneShotAnimMan, AZALEA_ONE_SHOT_TAG, 0);
            ride->state = AZALEA_RIDE_MOVE; // HeartGold's cart sound is its own (step 6)
        }

        break;
    case AZALEA_RIDE_MOVE: {
        if (ride->segmentDone) {
            const AzaleaRouteNode *from = &route->route[ride->nodeIndex];
            ride->node = &route->route[ride->backwards ? ride->nodeIndex - 1 : ride->nodeIndex + 1];

            ride->moveVector.x = (ride->node->x - from->x) * FX32_ONE;
            ride->moveVector.y = 0;
            ride->moveVector.z = (ride->node->z - from->z) * FX32_ONE;
            ride->moveSigns[0] = ride->moveVector.x >= 0;
            ride->moveSigns[1] = ride->moveVector.z >= 0;
            VEC_Normalize(&ride->moveVector, &ride->moveVector);

            VecFx32 xAxis = { FX32_ONE, 0, 0 }, zero = { 0, 0, 0 };
            fx32 xComponent = VEC_DotProduct(&ride->moveVector, &xAxis);
            VEC_MultAdd(FX32_CONST(2), &ride->moveVector, &zero, &ride->moveVector);

            // a slanted thread: the map's loading stops following the player until the next segment
            if (!ride->mapTrackingOff && xComponent != 0 && xComponent != FX32_ONE) {
                ride->mapTrackingOff = TRUE;
                LandDataManager_ForgetTrackedTarget(fieldSystem->landDataMan);
            } else if (ride->mapTrackingOff) {
                ride->mapTrackingOff = FALSE;
                LandDataManager_TrackTarget(PlayerAvatar_GetPos(fieldSystem->playerAvatar), fieldSystem->landDataMan);
            }

            ride->segmentDone = FALSE;
        }

        int xReached = AzaleaGym_NodeReached(ride->moveSigns[0], ride->cartPos.x, ride->moveVector.x, ride->node->x);
        int zReached = AzaleaGym_NodeReached(ride->moveSigns[1], ride->cartPos.z, ride->moveVector.z, ride->node->z);

        if (xReached == 2) {
            ride->moveVector.x = 0;
        }

        if (zReached == 2) {
            ride->moveVector.z = 0;
        }

        if (xReached != 0 && zReached != 0) {
            ride->cartPos.x = ride->node->x * 16 * FX32_ONE;
            ride->cartPos.z = ride->node->z * 16 * FX32_ONE;

            if (++ride->nodesDone >= route->length - 1) {
                AzaleaGymPersistedData *data = PersistedData(fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_AZALEA_GYM);
                data->spiders[ride->cart] = route->destination;
                MapPropOneShotAnimationManager_UnloadAnimation(fieldSystem->mapPropAnimMan, fieldSystem->mapPropOneShotAnimMan, AZALEA_ONE_SHOT_TAG);
                ride->state = AZALEA_RIDE_ARRIVE;
            } else {
                ride->nodeIndex += ride->backwards ? -1 : 1;
                ride->segmentDone = TRUE;
            }
        } else {
            VEC_Add(&ride->cartPos, &ride->moveVector, &ride->cartPos);
        }

        MapProp *cart = MapPropManager_GetLoadedPropSafely(fieldSystem->mapPropManager, gym->cartProps[ride->cart]);
        VecFx32 cartPos = ride->cartPos;
        cartPos.x += FX32_CONST(8);
        MapProp_SetPosition(cart, &cartPos);

        // the player stands on the cart, the follower on the tile behind
        VecFx32 riderOffset = { 8 * FX32_ONE, 0, 8 * FX32_ONE };
        VecFx32 position;
        VEC_Add(&ride->cartPos, &riderOffset, &position);
        position.z += ride->playerZOffset * 16 * FX32_ONE;
        MapObject_SetPos(player, &position);

        if (follower != NULL) {
            VEC_Add(&ride->cartPos, &riderOffset, &position);
            position.z += (1 - ride->playerZOffset) * 16 * FX32_ONE;
            MapObject_SetPos(follower, &position);
        }

        break;
    }
    case AZALEA_RIDE_ARRIVE:
        MapObject_SetX(player, ride->node->x);
        MapObject_SetY(player, 0);
        MapObject_SetZ(player, ride->node->z + ride->playerZOffset);
        MapObject_UpdateCoords(player);
        LocalMapObj_SetAnimationCode(player, MOVEMENT_ACTION_RESUME_ANIMATION);

        if (follower != NULL) {
            MapObject_SetX(follower, ride->node->x);
            MapObject_SetY(follower, 0);
            MapObject_SetZ(follower, ride->node->z + 1 - ride->playerZOffset);
            MapObject_UpdateCoords(follower);
        }

        ride->shakeCount = 0;
        ride->shakeFrame = 0;
        ride->shakeDirection = PlayerAvatar_GetFacingDir(fieldSystem->playerAvatar) == DIR_SOUTH ? FX32_ONE : -FX32_ONE;
        ride->state = AZALEA_RIDE_SHAKE;
        break;
    case AZALEA_RIDE_SHAKE: {
        // the cart stops with a jolt: the camera shakes four times
        VecFx32 shake = { 0, 0, ride->shakeDirection };

        if (ride->shakeFrame++ == 0) {
            Camera_Move(&shake, fieldSystem->camera);
            ride->shakeCount++;
        } else if (ride->shakeFrame > 1) {
            ride->shakeFrame = 0;
            ride->shakeDirection = -ride->shakeDirection;
        }

        if (ride->shakeCount >= 4) {
            ride->wait = 0;
            ride->state = AZALEA_RIDE_STEP_OFF;
        }

        break;
    }
    case AZALEA_RIDE_STEP_OFF:
        if (ride->wait++ >= 8) {
            AzaleaGym_StepRiders(fieldSystem, ride, follower, MOVEMENT_ACTION_WALK_NORMAL_NORTH, MOVEMENT_ACTION_WALK_NORMAL_SOUTH);
            ride->state = AZALEA_RIDE_WAIT_STEP_OFF;
        }

        break;
    case AZALEA_RIDE_WAIT_STEP_OFF:
        if (AzaleaGym_RidersStepped(fieldSystem, follower)) {
            if (follower != NULL) {
                sub_020656AC(follower);
            }

            ride->state = AZALEA_RIDE_END;
        }

        break;
    case AZALEA_RIDE_END:
        Heap_Free(ride);
        return TRUE;
    }

    return FALSE;
}

// HeartGold's AzaleaGymInit: the carts at stops 1, 2, 3 and 8, both switches off.
BOOL CompleteScrCmd_AzaleaGymInit(ScriptContext *ctx)
{
    AzaleaGymPersistedData *data = InitPersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_AZALEA_GYM);

    data->spiders[0] = 0;
    data->spiders[1] = 1;
    data->spiders[2] = 2;
    data->spiders[3] = 7;
    data->switches = 0;
    return FALSE;
}

// HeartGold's AzaleaGymSpinarak stop: ride the cart waiting at that stop (0 to 11) along its route.
BOOL CompleteScrCmd_AzaleaGymRide(ScriptContext *ctx)
{
    u8 stop = ScriptContext_ReadByte(ctx);
    AzaleaGymPersistedData *data = PersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_AZALEA_GYM);
    AzaleaGymRideTask *ride;
    u8 cart;

    for (cart = 0; cart < AZALEA_CARTS; cart++) {
        if (data->spiders[cart] == stop) {
            break;
        }
    }

    const AzaleaRoute *route = &sAzaleaRoutes[stop][data->switches];

    if (cart == AZALEA_CARTS || route->length == 0) {
        GF_ASSERT(FALSE);
        return FALSE;
    }

    ride = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(AzaleaGymRideTask));
    memset(ride, 0, sizeof(AzaleaGymRideTask));
    ride->stop = stop;
    ride->cart = cart;
    ride->switches = data->switches;
    ride->segmentDone = TRUE;
    ride->state = AZALEA_RIDE_WAIT_FOR_FOLLOWER;

    // the stops in the second and fourth rows send carts back up their routes
    switch (stop) {
    case 3:
    case 4:
    case 5:
    case 9:
    case 10:
    case 11:
        ride->backwards = TRUE;
        ride->nodeIndex = route->length - 1;
        ride->playerZOffset = 1;
        break;
    }

    ride->cartPos.x = route->route[ride->nodeIndex].x * FX32_ONE * 16;
    ride->cartPos.z = route->route[ride->nodeIndex].z * FX32_ONE * 16;

    FieldTask_InitCall(ctx->fieldSystem->task, AzaleaGym_RideTask, ride);
    return TRUE;
}

static BOOL AzaleaGym_SwitchSoundTask(FieldTask *task)
{
    return !Sound_IsEffectPlaying(SEQ_SE_DP_KI_GASYAN_sseq);
}

// HeartGold's AzaleaGymSwitch n: flips switch 0 (points 116 and 117) or 1 (points 115 and 122).
BOOL CompleteScrCmd_AzaleaGymSwitch(ScriptContext *ctx)
{
    u8 switchNo = ScriptContext_ReadByte(ctx);
    AzaleaGymPersistedData *data = PersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_AZALEA_GYM);
    FieldSystem *fieldSystem = ctx->fieldSystem;

    GF_ASSERT(switchNo < 2);

    u8 before = (data->switches >> switchNo) & 1;
    data->switches ^= 1 << switchNo;
    int first = switchNo == 0 ? AZALEA_POINTS_2 : AZALEA_POINTS_1;
    int second = switchNo == 0 ? AZALEA_POINTS_3 : AZALEA_POINTS_4;

    Sound_PlayEffect(SEQ_SE_DP_KI_GASYAN_sseq);
    AzaleaGym_SetPoints(fieldSystem, first, before, FALSE);
    AzaleaGym_SetPoints(fieldSystem, second, before, FALSE);
    AzaleaGym_SetPoints(fieldSystem, first, !before, TRUE);
    AzaleaGym_SetPoints(fieldSystem, second, !before, TRUE);

    FieldTask_InitCall(fieldSystem->task, AzaleaGym_SwitchSoundTask, NULL);
    return TRUE;
}

// Blackthorn Gym (HeartGold's blackthorn.c and InitBlackthornGym): three floating floors over the lava, each with three
// buttons in its middle row. Stepping on the middle one turns the floor a quarter turn; the ones beside it move the floor
// its own width to that side (from where it points). The floor stops at the walls and the lava's edge: a move that
// can't go its whole way goes back, a turn that can't goes part way and comes back. The floors' tiles are walkable,
// and the rest of the lava isn't (CompleteBlackthornGym_DynamicMapFeaturesCheckCollision).

#define BLACKTHORN_FLOORS      3
#define BLACKTHORN_WIDE_FLOOR  HGSS_INDOOR_MODEL(120)
#define BLACKTHORN_LONG_FLOOR  HGSS_INDOOR_MODEL(121)
#define BLACKTHORN_FLOOR_TILES 18
#define BLACKTHORN_NO_BONK     0xFF

enum BlackthornAction {
    BLACKTHORN_NONE = 0,
    BLACKTHORN_TURN,
    BLACKTHORN_MOVE_RIGHT, // as the floor points when not turned
    BLACKTHORN_MOVE_LEFT,
};

enum BlackthornTaskState {
    BLACKTHORN_MOVE_START = 0,
    BLACKTHORN_MOVE_CHECK,
    BLACKTHORN_MOVE_RUN,
    BLACKTHORN_MOVE_APPLY,
    BLACKTHORN_MOVE_BONK,
    BLACKTHORN_MOVE_BONK_RETURN,
    BLACKTHORN_TURN_START,
    BLACKTHORN_TURN_RUN,
    BLACKTHORN_TURN_BONK,
    BLACKTHORN_TURN_BONK_RETURN,
    BLACKTHORN_END,
};

typedef struct BlackthornGymPersistedData {
    u16 x[BLACKTHORN_FLOORS];
    u16 z[BLACKTHORN_FLOORS];
    u8 rotation[BLACKTHORN_FLOORS];
} BlackthornGymPersistedData;

typedef struct BlackthornPoint {
    int x;
    int z;
} BlackthornPoint;

// A floor's tiles and the tiles around it, turned as the floor is (HeartGold's BlackthornGymmickPlatformData).
typedef struct BlackthornFloor {
    int shape; // 0: 5 wide and 7 long (models 120), 1: 4 wide and 8 long (121)
    u8 width;
    u8 height;
    u8 rotation;
    u8 prop;
    BlackthornPoint turnButton;
    BlackthornPoint moveLeftButton;
    BlackthornPoint moveRightButton;
    BlackthornPoint rightWall[8];
    BlackthornPoint leftWall[8];
    BlackthornPoint bottomWall[5];
    BlackthornPoint topWall[5];
    BlackthornPoint turnCheck[24];
    BlackthornPoint rightEdgeOuter[5];
    BlackthornPoint floor[BLACKTHORN_FLOOR_TILES];
} BlackthornFloor;

typedef struct BlackthornGymData {
    FieldSystem *fieldSystem;
    BlackthornFloor floors[BLACKTHORN_FLOORS];
} BlackthornGymData;

typedef struct BlackthornGymTask {
    BlackthornPoint leadingWall[9];
    VecFx32 moveVector;
    fx32 turned;
    fx32 turnExtent;
    fx32 startRotation;
    enum BlackthornAction action;
    int moveDirection;
    u8 state;
    u8 floor;
    u8 steps;
    u8 distance;
    u8 timer;
} BlackthornGymTask;

// The share (in 256ths of a quarter turn, 64 for all of it) a floor turns before the tile at that place in its turn
// check list stops it, if that tile is a wall or ground.
static const u8 sBlackthornTurnExtents_Wide[] = {
    10, 10, 13, 18, 25, 38, 51,
    64, 64, 23, 28, 35, 45, 55,
};
static const u8 sBlackthornTurnExtents_Long[] = {
    8, 9, 10, 14, 19, 26, 37, 51,
    64, 17, 19, 23, 28, 35, 46, 55,
    64, 64, 64, 30, 35, 41, 49, 57,
};
static const u8 sBlackthornEdgeExtents_Wide[] = { 64, 64, 64, 64, 42 };
static const u8 sBlackthornEdgeExtents_Long[] = { 64, 20, 30, 46 };

static void BlackthornGym_TurnPoint(u8 rotation, int x, int z, BlackthornPoint *point)
{
    int dx = point->x - x;
    int dz = point->z - z;

    switch (rotation) {
    case 1:
        point->x = x - dz;
        point->z = z + dx;
        break;
    case 2:
        point->x = x - dx;
        point->z = z - dz;
        break;
    case 3:
        point->x = x + dz;
        point->z = z - dx;
        break;
    }
}

static void BlackthornGym_TurnFloor(u8 rotation, int x, int z, BlackthornFloor *floor)
{
    int turnTiles = floor->shape == 0 ? 14 : 24;

    BlackthornGym_TurnPoint(rotation, x, z, &floor->moveLeftButton);
    BlackthornGym_TurnPoint(rotation, x, z, &floor->moveRightButton);

    for (int i = 0; i < floor->height; i++) {
        BlackthornGym_TurnPoint(rotation, x, z, &floor->rightWall[i]);
        BlackthornGym_TurnPoint(rotation, x, z, &floor->leftWall[i]);
    }

    for (int i = 0; i < floor->width; i++) {
        BlackthornGym_TurnPoint(rotation, x, z, &floor->bottomWall[i]);
        BlackthornGym_TurnPoint(rotation, x, z, &floor->topWall[i]);
        BlackthornGym_TurnPoint(rotation, x, z, &floor->rightEdgeOuter[i]);
    }

    for (int i = 0; i < turnTiles; i++) {
        BlackthornGym_TurnPoint(rotation, x, z, &floor->turnCheck[i]);
    }

    for (int i = 0; i < BLACKTHORN_FLOOR_TILES; i++) {
        BlackthornGym_TurnPoint(rotation, x, z, &floor->floor[i]);
    }
}

// HeartGold's BlackthornPlatform_Init: the floor centred on its turn button at (x, z), turned rotation quarter turns.
static void BlackthornGym_InitFloor(u8 index, u8 rotation, int x, int z, BlackthornFloor *floor)
{
    BOOL wide = index != 1;
    int i, j;

    floor->turnButton = (BlackthornPoint) { x, z };
    floor->moveLeftButton = (BlackthornPoint) { x + 1, z };
    floor->moveRightButton = (BlackthornPoint) { x - 1, z };
    floor->shape = wide ? 0 : 1;
    floor->width = wide ? 5 : 4;
    floor->height = wide ? 7 : 8;

    int right = wide ? 3 : 2;

    for (i = 0; i < floor->height; i++) {
        floor->rightWall[i] = (BlackthornPoint) { x + right, z - 2 + i };
        floor->leftWall[i] = (BlackthornPoint) { x - 3, z - 2 + i };
    }

    for (i = 0; i < floor->width; i++) {
        floor->bottomWall[i] = (BlackthornPoint) { x - 2 + i, z + (wide ? 5 : 6) };
        floor->topWall[i] = (BlackthornPoint) { x - 2 + i, z - 3 };
        floor->rightEdgeOuter[i] = (BlackthornPoint) { x + 3, z - 2 + i };
    }

    for (i = 0; i < (wide ? 2 : 3); i++) {
        for (j = 0; j < floor->height; j++) {
            floor->turnCheck[i * floor->height + j] = (BlackthornPoint) { x - 4 - i, z + (wide ? 4 : 5) - j };
        }
    }

    for (i = 0; i < 6; i++) {
        for (j = 0; j < 3; j++) {
            floor->floor[i * 3 + j] = (BlackthornPoint) { x - 1 + j, z - 1 + i };
        }
    }

    floor->rotation = rotation;
    BlackthornGym_TurnFloor(rotation, x, z, floor);
}

static BOOL BlackthornGym_IsLava(FieldSystem *fieldSystem, int x, int z)
{
    return TerrainCollisionManager_GetTileBehavior(fieldSystem, x, z) == TILE_BEHAVIOR_COMPLETE_MAGMA;
}

// The first of the tiles that stops a floor (a wall, or ground rather than lava), or BLACKTHORN_NO_BONK.
static u8 BlackthornGym_FirstBonk(FieldSystem *fieldSystem, u8 count, const BlackthornPoint *points)
{
    for (u8 i = 0; i < count; i++) {
        if (TerrainCollisionManager_CheckCollision(fieldSystem, points[i].x, points[i].z) || !BlackthornGym_IsLava(fieldSystem, points[i].x, points[i].z)) {
            return i;
        }
    }

    return BLACKTHORN_NO_BONK;
}

static u16 BlackthornGym_TurnExtent(FieldSystem *fieldSystem, u8 count, const BlackthornPoint *points, const u8 *extents)
{
    for (u8 i = 0; i < count; i++) {
        if (TerrainCollisionManager_CheckCollision(fieldSystem, points[i].x, points[i].z) || !BlackthornGym_IsLava(fieldSystem, points[i].x, points[i].z)) {
            int extent = extents[i] << 8;

            if (extent < 0x4000) {
                return extent;
            }
        }
    }

    return 0x4000;
}

void CompleteBlackthornGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem)
{
    BlackthornGymPersistedData *data = PersistedData(fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_BLACKTHORN_GYM);
    BlackthornGymData *gym = Heap_Alloc(HEAP_ID_FIELD1, sizeof(BlackthornGymData));
    static const int models[BLACKTHORN_FLOORS] = { BLACKTHORN_WIDE_FLOOR, BLACKTHORN_LONG_FLOOR, BLACKTHORN_WIDE_FLOOR };

    memset(gym, 0, sizeof(BlackthornGymData));
    gym->fieldSystem = fieldSystem;
    fieldSystem->unk_04->dynamicMapFeaturesData = gym;

    for (int i = 0; i < BLACKTHORN_FLOORS; i++) {
        VecFx32 position = { 16 * FX32_ONE * data->x[i] + 8 * FX32_ONE, 48 * FX32_ONE, 16 * FX32_ONE * data->z[i] + 8 * FX32_ONE };
        VecFx32 rotation = { 0, -4 * FX32_ONE * data->rotation[i], 0 };

        gym->floors[i].prop = MapPropManager_LoadOne(fieldSystem->mapPropManager, fieldSystem->areaDataManager, models[i], &position, &rotation, fieldSystem->mapPropAnimMan);
        BlackthornGym_InitFloor(i, data->rotation[i], data->x[i], data->z[i], &gym->floors[i]);
    }
}

void CompleteBlackthornGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem)
{
    Heap_Free(fieldSystem->unk_04->dynamicMapFeaturesData);
    fieldSystem->unk_04->dynamicMapFeaturesData = NULL;
}

// The floors' tiles are walkable over the lava; the rest of the lava isn't.
BOOL CompleteBlackthornGym_DynamicMapFeaturesCheckCollision(FieldSystem *fieldSystem, const int tileX, const int tileZ, const fx32 height, BOOL *isColliding)
{
    BlackthornGymData *gym = fieldSystem->unk_04->dynamicMapFeaturesData;

    if (gym == NULL) {
        return FALSE;
    }

    for (int i = 0; i < BLACKTHORN_FLOORS; i++) {
        for (int j = 0; j < BLACKTHORN_FLOOR_TILES; j++) {
            if (tileX == gym->floors[i].floor[j].x && tileZ == gym->floors[i].floor[j].z) {
                *isColliding = FALSE;
                return TRUE;
            }
        }
    }

    if (BlackthornGym_IsLava(fieldSystem, tileX, tileZ)) {
        *isColliding = TRUE;
        return TRUE;
    }

    return FALSE;
}

static MapProp *BlackthornGym_FloorProp(FieldSystem *fieldSystem, BlackthornGymData *gym, u8 floor)
{
    return MapPropManager_GetLoadedPropSafely(fieldSystem->mapPropManager, gym->floors[floor].prop);
}

// The floor and the player standing on it move by the task's step.
static void BlackthornGym_StepFloor(FieldSystem *fieldSystem, BlackthornGymData *gym, BlackthornGymTask *task)
{
    MapProp *prop = BlackthornGym_FloorProp(fieldSystem, gym, task->floor);
    VecFx32 position = MapProp_GetPosition(prop);
    MapObject *player = PlayerAvatar_GetMapObject(fieldSystem->playerAvatar);
    VecFx32 playerPosition;

    VEC_Add(&position, &task->moveVector, &position);
    MapProp_SetPosition(prop, &position);
    MapObject_GetPosPtr(player, &playerPosition);
    VEC_Add(&playerPosition, &task->moveVector, &playerPosition);
    MapObject_SetPos(player, &playerPosition);
}

static void BlackthornGym_NextLeadingWall(int height, BlackthornGymTask *task)
{
    for (int i = 0; i < height; i++) {
        switch (task->moveDirection) {
        case 0:
            task->leadingWall[i].x++;
            break;
        case 1:
            task->leadingWall[i].z++;
            break;
        case 2:
            task->leadingWall[i].x--;
            break;
        case 3:
            task->leadingWall[i].z--;
            break;
        }
    }
}

static BOOL BlackthornGym_Task(FieldTask *fieldTask)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(fieldTask);
    BlackthornGymTask *task = FieldTask_GetEnv(fieldTask);
    BlackthornGymData *gym = fieldSystem->unk_04->dynamicMapFeaturesData;
    BlackthornFloor *floor = &gym->floors[task->floor];
    BlackthornGymPersistedData *data = PersistedData(fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_BLACKTHORN_GYM);

    switch (task->state) {
    case BLACKTHORN_MOVE_START:
        for (int i = 0; i < floor->height; i++) {
            task->leadingWall[i] = task->action == BLACKTHORN_MOVE_RIGHT ? floor->rightWall[i] : floor->leftWall[i];
        }

        task->state = BLACKTHORN_MOVE_CHECK;
        // fall through
    case BLACKTHORN_MOVE_CHECK:
        task->timer = 0;
        task->state = BlackthornGym_FirstBonk(fieldSystem, floor->height, task->leadingWall) == BLACKTHORN_NO_BONK ? BLACKTHORN_MOVE_RUN : BLACKTHORN_MOVE_BONK;
        break;
    case BLACKTHORN_MOVE_RUN:
        BlackthornGym_StepFloor(fieldSystem, gym, task);

        if (++task->timer >= 2) {
            task->timer = 0;
            BlackthornGym_NextLeadingWall(floor->height, task);

            if (++task->steps >= task->distance) {
                MapObject *player = PlayerAvatar_GetMapObject(fieldSystem->playerAvatar);
                VecFx32 playerPosition;

                MapObject_GetPosPtr(player, &playerPosition);
                MapObject_SetX(player, playerPosition.x / (16 * FX32_ONE));
                MapObject_SetZ(player, playerPosition.z / (16 * FX32_ONE));
                MapObject_UpdateCoords(player);
                task->state = BLACKTHORN_MOVE_APPLY;
            } else {
                task->state = BLACKTHORN_MOVE_CHECK;
            }
        }

        break;
    case BLACKTHORN_MOVE_APPLY: {
        VecFx32 position = MapProp_GetPosition(BlackthornGym_FloorProp(fieldSystem, gym, task->floor));
        int x = position.x / (16 * FX32_ONE);
        int z = position.z / (16 * FX32_ONE);

        data->x[task->floor] = x;
        data->z[task->floor] = z;
        BlackthornGym_InitFloor(task->floor, floor->rotation, x, z, floor);
        task->state = BLACKTHORN_END;
        break;
    }
    case BLACKTHORN_MOVE_BONK:
        // HeartGold's bonk sound is its own (step 6)
        if (task->steps == 0) {
            task->state = BLACKTHORN_END;
        } else {
            task->moveVector.x = -task->moveVector.x;
            task->moveVector.z = -task->moveVector.z;
            task->state = BLACKTHORN_MOVE_BONK_RETURN;
        }

        break;
    case BLACKTHORN_MOVE_BONK_RETURN:
        BlackthornGym_StepFloor(fieldSystem, gym, task);

        if (++task->timer >= 2) {
            task->timer = 0;

            if (--task->steps == 0) {
                task->state = BLACKTHORN_END;
            }
        }

        break;
    case BLACKTHORN_TURN_START: {
        // HeartGold's ov04_02255CBC: no turn with a wall or ground at the floor's sides; part of one if something is
        // in the way of the turn
        task->timer = 0;

        if (BlackthornGym_FirstBonk(fieldSystem, floor->width, floor->bottomWall) != BLACKTHORN_NO_BONK
            || BlackthornGym_FirstBonk(fieldSystem, floor->width, floor->topWall) != BLACKTHORN_NO_BONK
            || BlackthornGym_FirstBonk(fieldSystem, floor->height, floor->leftWall) != BLACKTHORN_NO_BONK
            || BlackthornGym_FirstBonk(fieldSystem, floor->width - 1, floor->rightWall) != BLACKTHORN_NO_BONK) {
            task->state = BLACKTHORN_END;
            break;
        }

        u16 extent = BlackthornGym_TurnExtent(fieldSystem, floor->shape == 0 ? 14 : 24, floor->turnCheck, floor->shape == 0 ? sBlackthornTurnExtents_Wide : sBlackthornTurnExtents_Long);
        u16 edgeExtent = BlackthornGym_TurnExtent(fieldSystem, floor->width, floor->rightEdgeOuter, floor->shape == 0 ? sBlackthornEdgeExtents_Wide : sBlackthornEdgeExtents_Long);

        if (edgeExtent < extent) {
            extent = edgeExtent;
        }

        if (extent >= 0x4000) {
            task->state = BLACKTHORN_TURN_RUN;
        } else {
            task->turnExtent = extent;
            task->startRotation = MapProp_GetRotation(BlackthornGym_FloorProp(fieldSystem, gym, task->floor))->y;
            task->turned = 0;
            task->state = BLACKTHORN_TURN_BONK;
        }

        break;
    }
    case BLACKTHORN_TURN_RUN:
        MapProp_GetRotation(BlackthornGym_FloorProp(fieldSystem, gym, task->floor))->y -= FX32_CONST(0.25);

        if (++task->timer >= 16) {
            MapObject *player = PlayerAvatar_GetMapObject(fieldSystem->playerAvatar);

            data->rotation[task->floor] = (data->rotation[task->floor] + 1) % 4;
            floor->rotation = data->rotation[task->floor];
            BlackthornGym_TurnFloor(1, MapObject_GetX(player), MapObject_GetZ(player), floor);
            task->state = BLACKTHORN_END;
        }

        break;
    case BLACKTHORN_TURN_BONK: {
        VecFx32 *rotation = MapProp_GetRotation(BlackthornGym_FloorProp(fieldSystem, gym, task->floor));

        rotation->y -= FX32_CONST(0.25);
        task->turned += FX32_CONST(0.25);

        if (task->turned >= task->turnExtent) {
            rotation->y = task->startRotation - task->turnExtent;
            task->state = BLACKTHORN_TURN_BONK_RETURN;
        }

        break;
    }
    case BLACKTHORN_TURN_BONK_RETURN: {
        VecFx32 *rotation = MapProp_GetRotation(BlackthornGym_FloorProp(fieldSystem, gym, task->floor));

        rotation->y += FX32_CONST(0.25);
        task->turned -= FX32_CONST(0.25);

        if (task->turned <= 0) {
            rotation->y = task->startRotation;
            task->state = BLACKTHORN_END;
        }

        break;
    }
    case BLACKTHORN_END:
        Sound_StopEffect(SEQ_SE_DP_ELEBETA_sseq, 0);
        Heap_Free(task);
        return TRUE;
    }

    return FALSE;
}

// The player has stepped onto a tile (HeartGold's ov04_02255090, from Field_ProcessStep): a floor's button starts its
// move or turn.
BOOL CompleteBlackthornGym_CheckButton(FieldSystem *fieldSystem)
{
    BlackthornGymData *gym = fieldSystem->unk_04->dynamicMapFeaturesData;

    if (gym == NULL) {
        return FALSE;
    }

    int x = PlayerAvatar_GetXPos(fieldSystem->playerAvatar);
    int z = PlayerAvatar_GetZPos(fieldSystem->playerAvatar);
    enum BlackthornAction action = BLACKTHORN_NONE;
    u8 i;

    for (i = 0; i < BLACKTHORN_FLOORS; i++) {
        BlackthornFloor *floor = &gym->floors[i];

        if (x == floor->turnButton.x && z == floor->turnButton.z) {
            action = BLACKTHORN_TURN;
        } else if (x == floor->moveLeftButton.x && z == floor->moveLeftButton.z) {
            action = BLACKTHORN_MOVE_RIGHT;
        } else if (x == floor->moveRightButton.x && z == floor->moveRightButton.z) {
            action = BLACKTHORN_MOVE_LEFT;
        }

        if (action != BLACKTHORN_NONE) {
            break;
        }
    }

    if (action == BLACKTHORN_NONE) {
        return FALSE;
    }

    BlackthornGymTask *task = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(BlackthornGymTask));
    memset(task, 0, sizeof(BlackthornGymTask));
    task->floor = i;
    task->action = action;

    if (action == BLACKTHORN_TURN) {
        task->state = BLACKTHORN_TURN_START;
    } else {
        task->state = BLACKTHORN_MOVE_START;
        task->distance = gym->floors[i].width;
        task->moveDirection = ((action == BLACKTHORN_MOVE_RIGHT ? 0 : 2) + gym->floors[i].rotation) % 4;
        task->moveVector.x = task->moveDirection == 0 ? 8 * FX32_ONE : task->moveDirection == 2 ? -8 * FX32_ONE : 0;
        task->moveVector.z = task->moveDirection == 1 ? 8 * FX32_ONE : task->moveDirection == 3 ? -8 * FX32_ONE : 0;
    }

    Sound_PlayEffect(SEQ_SE_DP_ELEBETA_sseq); // a stand-in for HeartGold's floor sound (step 6)
    FieldSystem_CreateTask(fieldSystem, BlackthornGym_Task, task);
    return TRUE;
}

// HeartGold's BlackthornGymInit: the floors where the gym starts them.
BOOL CompleteScrCmd_BlackthornGymInit(ScriptContext *ctx)
{
    BlackthornGymPersistedData *data = InitPersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_BLACKTHORN_GYM);

    data->x[0] = 13;
    data->z[0] = 75;
    data->rotation[0] = 0;
    data->x[1] = 9;
    data->z[1] = 58;
    data->rotation[1] = 1;
    data->x[2] = 14;
    data->z[2] = 32;
    data->rotation[2] = 0;
    return FALSE;
}

// Ecruteak Gym (HeartGold's ecruteak.c and InitEcruteakGym): the gym is dark, so the path between its pits doesn't show,
// and only people show in the dark. Its four sages carry candles, which go out as each loses. HeartGold binds a candle
// to its sage from its common trainer script; here a task keeps each candle on its sage, and puts it out when the
// sage's trainer flag is set.

#define ECRUTEAK_CANDLE     HGSS_INDOOR_MODEL(128)
#define ECRUTEAK_SAGES      4
#define ECRUTEAK_FIRST_SAGE 2 // obj_T27GYM0101_itako to _itako_4

typedef struct EcruteakGymPersistedData {
    u8 candlesOut[ECRUTEAK_SAGES];
    u8 fresh; // just set up by the gym's script: the candles of sages beaten before are out already
} EcruteakGymPersistedData;

typedef struct EcruteakGymData {
    FieldSystem *fieldSystem;
    SysTask *task;
    u8 candleProps[ECRUTEAK_SAGES];
    u8 delay[ECRUTEAK_SAGES];
    u8 shrink[ECRUTEAK_SAGES];
} EcruteakGymData;

static BOOL EcruteakGym_SageBeaten(FieldSystem *fieldSystem, MapObject *sage)
{
    return sage != NULL && Script_IsTrainerDefeated(fieldSystem, Script_GetTrainerID(MapObject_GetScript(sage)));
}

static void EcruteakGym_Task(SysTask *sysTask, void *param)
{
    EcruteakGymData *gym = param;
    FieldSystem *fieldSystem = gym->fieldSystem;
    EcruteakGymPersistedData *data = PersistedData(fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_ECRUTEAK_GYM);
    MapObject *mapObj;
    int index = 0;

    // people show in the dark (HeartGold's ApplyFogToMapObjects)
    while (MapObjectMan_FindObjectWithStatus(fieldSystem->mapObjMan, &mapObj, &index, MAP_OBJ_STATUS_0)) {
        Billboard *billboard = ov5_021EB1A0(mapObj);

        if (billboard != NULL) {
            NNS_G3dMdlSetMdlFogEnableFlagAll(Billboard_GetModel(billboard), FALSE);
        }
    }

    for (int i = 0; i < ECRUTEAK_SAGES; i++) {
        MapProp *candle = MapPropManager_GetLoadedPropSafely(fieldSystem->mapPropManager, gym->candleProps[i]);
        MapObject *sage = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, ECRUTEAK_FIRST_SAGE + i);

        if (data->candlesOut[i]) {
            continue;
        }

        if (sage != NULL) {
            VecFx32 position;
            MapObject_GetPosPtr(sage, &position);
            MapProp_SetPosition(candle, &position);
        }

        // HeartGold's Task_ExtinguishCandle: half a second, then the flame shrinks away
        if (EcruteakGym_SageBeaten(fieldSystem, sage) && gym->delay[i]++ >= 30) {
            if (gym->shrink[i] == 0) {
                gym->shrink[i] = 1; // HeartGold's candle sound is its own (step 6)
            }

            if (++gym->shrink[i] >= 4) {
                MapProp_SetHidden(candle, TRUE);
                data->candlesOut[i] = TRUE;
            }

            candle->scale.x = candle->scale.y = candle->scale.z = FX32_ONE / gym->shrink[i];
        }
    }
}

void CompleteEcruteakGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem)
{
    EcruteakGymPersistedData *data = PersistedData(fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_ECRUTEAK_GYM);
    EcruteakGymData *gym = Heap_Alloc(HEAP_ID_FIELD1, sizeof(EcruteakGymData));
    char fogDensity[G3X_FOG_DENSITY_TABLE_SIZE];

    memset(gym, 0, sizeof(EcruteakGymData));
    gym->fieldSystem = fieldSystem;
    fieldSystem->unk_04->dynamicMapFeaturesData = gym;

    // the dark: black fog at its thickest everywhere
    memset(fogDensity, 127, sizeof(fogDensity));
    FogManager_ApplyParameters(fieldSystem->fogMan, FOG_PARAMETER_ALL, TRUE, GX_FOGBLEND_COLOR_ALPHA, GX_FOGSLOPE_0x0020, 0);
    FogManager_ApplyColor(fieldSystem->fogMan, FOG_PARAMETER_ALL, GX_RGB(0, 0, 0), 31);
    FogManager_ApplyDensityTable(fieldSystem->fogMan, fogDensity);

    for (int i = 0; i < ECRUTEAK_SAGES; i++) {
        MapObject *sage = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, ECRUTEAK_FIRST_SAGE + i);
        VecFx32 position = { 0, 0, 0 };

        if (data->fresh) {
            data->candlesOut[i] = EcruteakGym_SageBeaten(fieldSystem, sage);
        }

        if (sage != NULL) {
            MapObject_GetPosPtr(sage, &position);
        }

        gym->candleProps[i] = MapPropManager_LoadOne(fieldSystem->mapPropManager, fieldSystem->areaDataManager, ECRUTEAK_CANDLE, &position, NULL, fieldSystem->mapPropAnimMan);
        MapProp_SetHidden(MapPropManager_GetLoadedPropSafely(fieldSystem->mapPropManager, gym->candleProps[i]), data->candlesOut[i]);
    }

    data->fresh = FALSE;
    gym->task = SysTask_Start(EcruteakGym_Task, gym, 0);
}

void CompleteEcruteakGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem)
{
    EcruteakGymData *gym = fieldSystem->unk_04->dynamicMapFeaturesData;

    SysTask_Done(gym->task);
    Heap_Free(gym);
    fieldSystem->unk_04->dynamicMapFeaturesData = NULL;
}

// HeartGold's EcruteakGymInit: the candles are lit (but those of the sages beaten before).
BOOL CompleteScrCmd_EcruteakGymInit(ScriptContext *ctx)
{
    EcruteakGymPersistedData *data = InitPersistedData(ctx->fieldSystem, DYNAMIC_MAP_FEATURES_HGSS_ECRUTEAK_GYM);

    data->fresh = TRUE;
    return FALSE;
}
