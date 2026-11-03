#include "overlay005/complete_legend_cutscene.h"

#include <nitro.h>
#include <string.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "generated/map_headers.h"
#include "generated/object_events_gfx.h"
#include "generated/species.h"

#include "field/field_system.h"
#include "field/field_system_sub2_t.h"
#include "overlay005/ov5_021D1A94.h"
#include "overlay005/struct_ov5_021D1BEC_decl.h"
#include "overlay006/struct_ov6_0223E6EC.h"

#include "bg_window.h"
#include "camera.h"
#include "complete_test.h"
#include "easy3d_object.h"
#include "field_script_context.h"
#include "field_task.h"
#include "graphics.h"
#include "inlines.h"
#include "gx_layers.h"
#include "heap.h"
#include "map_object.h"
#include "narc.h"
#include "player_avatar.h"
#include "sound_playback.h"
#include "sys_task.h"
#include "sys_task_manager.h"

#include "data/hgss_legend.h"
#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: HeartGold's legendary cutscenes (pokeheartgold's src/field/legend_cutscene_camera.c and
// camera_translation.c): on the Bell Tower's roof, as the Kimono Girls dance, the Clear Bell rises from the bag and
// shimmers with the four corner bells, leaves blow over the screen and the camera pans up to Ho-Oh, which flaps down
// with a ring of light; on Whirl Islands the Tidal Bell does the same with two bells and the waves, before Lugia's eye
// glints. HeartGold plays one or the other by its version (HeartGold's Ho-Oh, SoulSilver's Lugia); here the Bell
// Tower's roof plays HeartGold's and the Whirl Islands' cave SoulSilver's. The models, animations and the leaves are
// HeartGold's (NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, tools/complete/import_hgss_legend.py), drawn by the field's 3D
// object tasks (ov5_021D1A94, HeartGold's Field3dObjectTask) with Platinum's Easy3D objects (HeartGold's Field3dObject).
// HeartGold's own sound effects stand in as Platinum's (docs/Music.md): Fly's whoosh for a flap, a sparkle for the eye.

#define CUTSCENE_HEAP        HEAP_ID_FIELD1
#define TASK_PRIORITY        3
#define SE_BIRD_FLAP         SEQ_SE_DP_FW019_sseq // HeartGold's SEQ_SE_GS_HOUOU_HABATAKI and SEQ_SE_GS_RUGIA_HABATAKI
#define SE_EYE_GLIMMER       SEQ_SE_DP_KIRAN_sseq // HeartGold's SEQ_SE_GS_RUGIA_MENOHIKARI
#define LEAVES_PALETTE       6
#define LEAVES_TILEMAPS      6
#define LEAVES_SWITCH_FRAMES 6

enum ClearBellState {
    CLEAR_BELL_STATE_NONE = 0,
    CLEAR_BELL_STATE_RISE_BEGIN,
    CLEAR_BELL_STATE_RISE_WAIT,
    CLEAR_BELL_STATE_IDLE_LOOP,
    CLEAR_BELL_STATE_SHIMMER_BEGIN,
    CLEAR_BELL_STATE_SHIMMER_WAIT,
};

typedef struct CameraPathPoint {
    u16 angleX;
    u16 fovY;
    VecFx32 position; // from the camera's tracked target
    fx32 distance;
} CameraPathPoint;

// HeartGold's GFCameraTranslationWrapper: the camera moved from where it is to a point, a step a frame
typedef struct CameraPath {
    Camera *camera;
    SysTask *task;
    CameraPathPoint init;
    CameraPathPoint target;
    u8 active;
    u8 step;
    u8 duration;
} CameraPath;

typedef struct CutsceneParam {
    fx32 distance;
    u16 angleX;
    u16 fovY;
} CutsceneParam;

typedef struct ClearBellTaskData {
    NNSFndAllocator allocator;
    u8 state;
    u8 shimmerClearBellOnly;
    u8 shimmerPending;
    u8 lugia; // the Whirl Islands' (SoulSilver's)
    Easy3DModel clearBellRisingModel;
    Easy3DModel clearBellShimmerModel;
    Easy3DModel cornerBellModel;
    Easy3DAnim clearBellRisingAnims[3];
    Easy3DAnim clearBellShimmerAnims[2];
    Easy3DAnim cornerBellAnims[1];
    Easy3DObject clearBellRisingObject;
    Easy3DObject clearBellObject;
    Easy3DObject cornerBellObjects[4];
    // the waves (Lugia's)
    BOOL waves;
    Easy3DModel wavesModel;
    Easy3DAnim wavesAnims[2];
    Easy3DObject wavesObject;
    // the leaves (Ho-Oh's), on the field's layers 2 and 3
    BOOL leaves;
    NNSG2dScreenData *bg2Screens[LEAVES_TILEMAPS];
    NNSG2dScreenData *bg3Screens[LEAVES_TILEMAPS];
    void *bg2Files[LEAVES_TILEMAPS];
    void *bg3Files[LEAVES_TILEMAPS];
    u8 bg2X;
    u8 bg3X;
    u8 bgY;
    u8 switchTimer;
    u8 tilemap;
    u16 savedPalette[16];
    u16 savedBgControl[3]; // BG0, BG2 and BG3: their priorities
} ClearBellTaskData;

typedef struct LegendCutscene {
    BOOL lugia;
    UnkStruct_ov5_021D1BEC *bellTask;
    CameraPath path;
    VecFx32 lookAtTarget;
    VecFx32 lookAtPos;
    // the camera before the scene (the bells'), or before Lugia's arrival (SoulSilver's LugiaArrivesCutsceneCamera), to go
    // back to
    fx32 distance;
    CameraAngle angle;
    VecFx32 targetDistance;
    u16 fovY;
    fx32 nearClip;
    fx32 farClip;
} LegendCutscene;

// A one-off 3D effect: the Lugia's eye glint, or the ring of light round the landed bird
typedef struct EffectTaskData {
    NNSFndAllocator allocator;
    Easy3DModel model;
    Easy3DAnim anims[3];
    Easy3DObject object;
    BOOL drawing;
} EffectTaskData;

typedef struct BirdApproach {
    FieldSystem *fieldSystem;
    SysTask *task;
    UnkStruct_ov5_021D1BEC *effectTask;
    MapObject *bird;
    u8 state;
    BOOL lugia;
    BOOL done;
    fx32 yDelta;
    fx32 yEnd;
    u16 timer;
    u16 animTimer;
    u16 flapTimer;
} BirdApproach;

typedef struct EyeGlimmer {
    UnkStruct_ov5_021D1BEC *effectTask;
    SysTask *task;
    int timer;
    BOOL done;
} EyeGlimmer;

static LegendCutscene *sCutscene;
static BirdApproach *sBird;
static EyeGlimmer *sEye;

// HeartGold's sCameraParam_* and sCameraOffset_*: the scenes' camera points (each its distance, its pitch and field of
// view, and its offset)
static const CutsceneParam sCameraParamHoOh[] = {
    { FX32_CONST(666.922119148625), 0xF562, 0x5C1 },
    { FX32_CONST(666.922119148625), 0xF562, 0x5C1 },
    { FX32_CONST(666.922119148625), 0xF762, 0xCC1 },
    { FX32_CONST(666.922119148625), 0xFBA2, 0xCC1 },
};

static const CutsceneParam sCameraParamLugia[] = {
    { FX32_CONST(666.922119148625), 0xDFE2, 0x5C1 },
    { FX32_CONST(666.922119148625), 0xDFE2, 0x5C1 },
    { FX32_CONST(666.922119148625), 0xDEF2, 0x5C1 },
    { FX32_CONST(666.922119148625), 0xDEF2, 0x5C1 },
    { FX32_CONST(666.922119148625), 0xDEF2, 0x5C1 },
};

static const VecFx32 sCameraOffsetHoOh[] = {
    { -FX32_CONST(195), -FX32_CONST(148.605), -FX32_CONST(45.19165) },
    { FX32_CONST(198), -FX32_CONST(148.605), -FX32_CONST(45.19165) },
    { 0, -FX32_CONST(35.751708984375), -FX32_CONST(23.0476) },
    { 0, FX32_CONST(495.6323), FX32_CONST(28.73) },
};

static const VecFx32 sCameraOffsetLugia[] = {
    { -FX32_CONST(127), 0, -FX32_CONST(208) },
    { FX32_CONST(63), 0, -FX32_CONST(208) },
    { 0, 0, -FX32_CONST(82) },
    { 0, 0, -FX32_CONST(433) },
    { 0, 0, -FX32_CONST(225) },
};

static const u8 sBg2Tilemaps[LEAVES_TILEMAPS] = { 41, 42, 43, 44, 45, 46 };
static const u8 sBg3Tilemaps[LEAVES_TILEMAPS] = { 47, 48, 49, 50, 51, 52 };

static const CutsceneParam *CameraParams(BOOL lugia)
{
    return lugia ? sCameraParamLugia : sCameraParamHoOh;
}

static const VecFx32 *CameraOffsets(BOOL lugia)
{
    return lugia ? sCameraOffsetLugia : sCameraOffsetHoOh;
}

static void PlayerPos(FieldSystem *fieldSystem, VecFx32 *pos)
{
    MapObject_GetPosPtr(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar), pos);
}

// HeartGold's camera_translation.c
static void StepCamera(Camera *camera, const CameraPathPoint *first, const CameraPathPoint *last, u8 step, u8 duration)
{
    CameraAngle angle = { 0 };

    Camera_SetDistance(first->distance + (last->distance - first->distance) * step / duration, camera);

    if (last->angleX >= first->angleX) {
        angle.x = first->angleX + (u16)(last->angleX - first->angleX) * step / duration;
    } else {
        angle.x = first->angleX - (u16)(first->angleX - last->angleX) * step / duration;
    }

    Camera_SetAngleAroundTarget(&angle, camera);
    Camera_SetFOV(first->fovY + ((int)last->fovY - (int)first->fovY) * step / duration, camera);

    VecFx32 diff, delta;

    VEC_Subtract(&last->position, &first->position, &diff);
    delta.x = diff.x * step / duration - diff.x * (step - 1) / duration;
    delta.y = diff.y * step / duration - diff.y * (step - 1) / duration;
    delta.z = diff.z * step / duration - diff.z * (step - 1) / duration;
    Camera_Move(&delta, camera);
}

static void CameraPath_End(CameraPath *path)
{
    if (path->task != NULL) {
        SysTask_Done(path->task);
        path->task = NULL;
    }

    path->active = FALSE;
}

static void CameraPath_Task(SysTask *task, void *data)
{
    CameraPath *path = data;

    path->step++;
    StepCamera(path->camera, &path->init, &path->target, path->step, path->duration);

    if (path->step >= path->duration) {
        CameraPath_End(path);
    }
}

static void CameraPath_Start(CameraPath *path, Camera *camera, const CameraPathPoint *target, int duration)
{
    if (path->active || duration == 0) {
        return;
    }

    CameraAngle angle = Camera_GetAngle(camera);
    VecFx32 lookAt = Camera_GetTarget(camera);

    path->camera = camera;
    path->target = *target;
    path->init.angleX = angle.x;
    path->init.fovY = Camera_GetFOV(camera);
    path->init.distance = Camera_GetDistance(camera);

    if (camera->targetPos != NULL) {
        VEC_Subtract(&lookAt, camera->targetPos, &path->init.position);
    } else {
        path->init.position.x = path->init.position.y = path->init.position.z = 0;
    }

    path->duration = duration;
    path->step = 0;
    path->active = TRUE;
    path->task = SysTask_Start(CameraPath_Task, path, 0);
}

static void LoadModel(Easy3DModel *model, NARC *narc, int hgssMember)
{
    Easy3DModel_LoadFrom(model, narc, LEGEND_MEMBER(hgssMember), CUTSCENE_HEAP);
}

static void LoadAnim(Easy3DAnim *anim, Easy3DModel *model, NARC *narc, int hgssMember, NNSFndAllocator *allocator)
{
    Easy3DAnim_LoadFrom(anim, model, narc, LEGEND_MEMBER(hgssMember), CUTSCENE_HEAP, allocator);
}

static void SetFrames(Easy3DAnim *anims, int count, fx32 frame)
{
    for (int i = 0; i < count; i++) {
        Easy3DAnim_SetFrame(&anims[i], frame);
    }
}

static BOOL AdvanceNoLoop(Easy3DAnim *anims, int count)
{
    int done = 0;

    for (int i = 0; i < count; i++) {
        done += Easy3DAnim_Update(&anims[i], FX32_ONE) ? 1 : 0;
    }

    return done == count;
}

static void AdvanceLooping(Easy3DAnim *anims, int count)
{
    for (int i = 0; i < count; i++) {
        Easy3DAnim_UpdateLooped(&anims[i], FX32_ONE);
    }
}

static void SetBellsVisible(ClearBellTaskData *data, BOOL visible)
{
    Easy3DObject_SetVisible(&data->clearBellObject, visible);

    if (!data->shimmerClearBellOnly) {
        for (int i = 0; i < (data->lugia ? 2 : 4); i++) {
            Easy3DObject_SetVisible(&data->cornerBellObjects[i], visible);
        }
    }
}

// HeartGold's Field3dObjectTaskInit_ClearBellCutscene
static void ClearBellTask_Init(UnkStruct_ov5_021D1BEC *task, FieldSystem *fieldSystem, void *taskData)
{
    ClearBellTaskData *data = taskData;
    NARC *narc = NARC_ctor(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, CUTSCENE_HEAP);
    VecFx32 pos;

    memset(data, 0, sizeof(ClearBellTaskData));
    data->lugia = sCutscene->lugia;
    HeapExp_FndInitAllocator(&data->allocator, CUTSCENE_HEAP, 0x20);

    LoadModel(&data->clearBellRisingModel, narc, 18);
    LoadModel(&data->clearBellShimmerModel, narc, 25);
    LoadModel(&data->cornerBellModel, narc, 32);
    LoadAnim(&data->clearBellRisingAnims[0], &data->clearBellRisingModel, narc, 19, &data->allocator);
    LoadAnim(&data->clearBellRisingAnims[1], &data->clearBellRisingModel, narc, 20, &data->allocator);
    LoadAnim(&data->clearBellRisingAnims[2], &data->clearBellRisingModel, narc, 21, &data->allocator);
    LoadAnim(&data->clearBellShimmerAnims[0], &data->clearBellShimmerModel, narc, 26, &data->allocator);
    LoadAnim(&data->clearBellShimmerAnims[1], &data->clearBellShimmerModel, narc, 27, &data->allocator);
    LoadAnim(&data->cornerBellAnims[0], &data->cornerBellModel, narc, 33, &data->allocator);
    NARC_dtor(narc);

    Easy3DObject_Init(&data->clearBellRisingObject, &data->clearBellRisingModel);
    Easy3DObject_Init(&data->clearBellObject, &data->clearBellShimmerModel);

    for (int i = 0; i < 3; i++) {
        Easy3DObject_AddAnim(&data->clearBellRisingObject, &data->clearBellRisingAnims[i]);
    }

    Easy3DObject_AddAnim(&data->clearBellObject, &data->clearBellShimmerAnims[0]);
    Easy3DObject_AddAnim(&data->clearBellObject, &data->clearBellShimmerAnims[1]);
    Easy3DObject_SetVisible(&data->clearBellRisingObject, FALSE);
    Easy3DObject_SetVisible(&data->clearBellObject, FALSE);

    for (int i = 0; i < 4; i++) {
        Easy3DObject_Init(&data->cornerBellObjects[i], &data->cornerBellModel);
        Easy3DObject_AddAnim(&data->cornerBellObjects[i], &data->cornerBellAnims[0]);
        Easy3DObject_SetVisible(&data->cornerBellObjects[i], FALSE);
    }

    SetFrames(data->clearBellRisingAnims, 3, 0);
    SetFrames(data->clearBellShimmerAnims, 2, 0);
    SetFrames(data->cornerBellAnims, 1, 0);

    PlayerPos(fieldSystem, &pos);
    Easy3DObject_SetPosition(&data->clearBellRisingObject, pos.x, pos.y, pos.z);
    Easy3DObject_SetPosition(&data->clearBellObject, pos.x, pos.y, pos.z);

    if (data->lugia) {
        Easy3DObject_SetPosition(&data->cornerBellObjects[0], pos.x + FX32_CONST(128), pos.y + FX32_CONST(32), pos.z - FX32_CONST(180));
        Easy3DObject_SetPosition(&data->cornerBellObjects[1], pos.x - FX32_CONST(128), pos.y + FX32_CONST(32), pos.z - FX32_CONST(180));
    } else {
        Easy3DObject_SetPosition(&data->cornerBellObjects[0], pos.x + FX32_CONST(200), pos.y - FX32_CONST(73), pos.z + FX32_CONST(144));
        Easy3DObject_SetPosition(&data->cornerBellObjects[1], pos.x - FX32_CONST(198), pos.y - FX32_CONST(73), pos.z + FX32_CONST(144));
        Easy3DObject_SetPosition(&data->cornerBellObjects[2], pos.x + FX32_CONST(200), pos.y - FX32_CONST(73), pos.z - FX32_CONST(270));
        Easy3DObject_SetPosition(&data->cornerBellObjects[3], pos.x - FX32_CONST(198), pos.y - FX32_CONST(73), pos.z - FX32_CONST(270));
    }

    data->state = CLEAR_BELL_STATE_NONE;
}

static void EndWaves(ClearBellTaskData *data)
{
    if (data->waves) {
        Easy3DAnim_Release(&data->wavesAnims[1], &data->allocator);
        Easy3DAnim_Release(&data->wavesAnims[0], &data->allocator);
        Easy3DModel_Release(&data->wavesModel);
        data->waves = FALSE;
    }
}

static void EndLeaves(ClearBellTaskData *data)
{
    if (!data->leaves) {
        return;
    }

    GXLayers_EngineAToggleLayers(GX_PLANEMASK_BG2 | GX_PLANEMASK_BG3, FALSE);

    for (int i = 0; i < LEAVES_TILEMAPS; i++) {
        Heap_Free(data->bg2Files[i]);
        Heap_Free(data->bg3Files[i]);
    }

    reg_G2_BG0CNT = data->savedBgControl[0];
    reg_G2_BG2CNT = data->savedBgControl[1];
    reg_G2_BG3CNT = data->savedBgControl[2];
    GX_LoadBGPltt(data->savedPalette, LEAVES_PALETTE * 32, sizeof(data->savedPalette));
    data->leaves = FALSE;
}

static void ClearBellTask_Destroy(UnkStruct_ov5_021D1BEC *task, FieldSystem *fieldSystem, void *taskData)
{
    ClearBellTaskData *data = taskData;

    EndWaves(data);
    EndLeaves(data);
    Easy3DAnim_Release(&data->clearBellRisingAnims[2], &data->allocator);
    Easy3DAnim_Release(&data->clearBellRisingAnims[1], &data->allocator);
    Easy3DAnim_Release(&data->clearBellRisingAnims[0], &data->allocator);
    Easy3DAnim_Release(&data->clearBellShimmerAnims[1], &data->allocator);
    Easy3DAnim_Release(&data->clearBellShimmerAnims[0], &data->allocator);
    Easy3DAnim_Release(&data->cornerBellAnims[0], &data->allocator);
    Easy3DModel_Release(&data->clearBellRisingModel);
    Easy3DModel_Release(&data->clearBellShimmerModel);
    Easy3DModel_Release(&data->cornerBellModel);
}

// HeartGold's bellShimmerReplaceGraphics: once risen, the bell's idle animations
static void SwitchToIdle(ClearBellTaskData *data)
{
    NARC *narc = NARC_ctor(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, CUTSCENE_HEAP);

    for (int i = 0; i < 3; i++) {
        Easy3DObject_RemoveAnim(&data->clearBellRisingObject, &data->clearBellRisingAnims[i]);
    }

    for (int i = 2; i >= 0; i--) {
        Easy3DAnim_Release(&data->clearBellRisingAnims[i], &data->allocator);
    }

    LoadAnim(&data->clearBellRisingAnims[0], &data->clearBellRisingModel, narc, 22, &data->allocator);
    LoadAnim(&data->clearBellRisingAnims[1], &data->clearBellRisingModel, narc, 23, &data->allocator);
    LoadAnim(&data->clearBellRisingAnims[2], &data->clearBellRisingModel, narc, 24, &data->allocator);
    NARC_dtor(narc);

    for (int i = 0; i < 3; i++) {
        Easy3DObject_AddAnim(&data->clearBellRisingObject, &data->clearBellRisingAnims[i]);
    }

    SetFrames(data->clearBellRisingAnims, 3, 0);
}

static void LeavesStep(ClearBellTaskData *data, BgConfig *bgConfig)
{
    if (++data->switchTimer >= LEAVES_SWITCH_FRAMES) {
        data->switchTimer = 0;
        data->tilemap = (data->tilemap + 1) % LEAVES_TILEMAPS;
        Bg_LoadToTilemapRect(bgConfig, BG_LAYER_MAIN_2, data->bg2Screens[data->tilemap]->rawData, 0, 0, 32, 32);
        Bg_LoadToTilemapRect(bgConfig, BG_LAYER_MAIN_3, data->bg3Screens[data->tilemap]->rawData, 0, 0, 32, 32);
        Bg_ChangeTilemapRectPalette(bgConfig, BG_LAYER_MAIN_2, 0, 0, 32, 32, LEAVES_PALETTE);
        Bg_ChangeTilemapRectPalette(bgConfig, BG_LAYER_MAIN_3, 0, 0, 32, 32, LEAVES_PALETTE);
        Bg_ScheduleTilemapTransfer(bgConfig, BG_LAYER_MAIN_2);
        Bg_ScheduleTilemapTransfer(bgConfig, BG_LAYER_MAIN_3);
    }

    data->bg2X--;
    data->bg3X++;
    data->bgY--;
    Bg_ScheduleScroll(bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_X, data->bg2X);
    Bg_ScheduleScroll(bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_Y, data->bgY);
    Bg_ScheduleScroll(bgConfig, BG_LAYER_MAIN_3, BG_OFFSET_UPDATE_SET_X, data->bg3X);
    Bg_ScheduleScroll(bgConfig, BG_LAYER_MAIN_3, BG_OFFSET_UPDATE_SET_Y, data->bgY);
}

// HeartGold's Field3dObjectTaskUpdate_ClearBellCutscene, with its waves' and leaves' tasks
static void ClearBellTask_Update(UnkStruct_ov5_021D1BEC *task, FieldSystem *fieldSystem, void *taskData)
{
    ClearBellTaskData *data = taskData;

    if (data->shimmerPending && data->state == CLEAR_BELL_STATE_IDLE_LOOP) {
        data->shimmerPending = FALSE;
        data->state = CLEAR_BELL_STATE_SHIMMER_BEGIN;
    }

    switch (data->state) {
    case CLEAR_BELL_STATE_RISE_BEGIN:
        Easy3DObject_SetVisible(&data->clearBellRisingObject, TRUE);
        data->state = CLEAR_BELL_STATE_RISE_WAIT;
        break;
    case CLEAR_BELL_STATE_RISE_WAIT:
        if (AdvanceNoLoop(data->clearBellRisingAnims, 3)) {
            SwitchToIdle(data);
            data->state = CLEAR_BELL_STATE_IDLE_LOOP;
        }
        break;
    case CLEAR_BELL_STATE_IDLE_LOOP:
        AdvanceLooping(data->clearBellRisingAnims, 3);
        break;
    case CLEAR_BELL_STATE_SHIMMER_BEGIN:
        Easy3DObject_SetVisible(&data->clearBellRisingObject, FALSE);
        SetBellsVisible(data, TRUE);
        SetFrames(data->clearBellShimmerAnims, 2, 0);
        SetFrames(data->cornerBellAnims, 1, 0);
        data->state = CLEAR_BELL_STATE_SHIMMER_WAIT;
        break;
    case CLEAR_BELL_STATE_SHIMMER_WAIT:
        AdvanceLooping(data->clearBellRisingAnims, 3);
        AdvanceNoLoop(data->cornerBellAnims, 1);

        if (AdvanceNoLoop(data->clearBellShimmerAnims, 2)) {
            SetBellsVisible(data, FALSE);
            Easy3DObject_SetVisible(&data->clearBellRisingObject, TRUE);
            data->state = CLEAR_BELL_STATE_IDLE_LOOP;
        }
        break;
    default:
        break;
    }

    if (data->waves) {
        AdvanceLooping(data->wavesAnims, 2);
    }

    if (data->leaves) {
        LeavesStep(data, fieldSystem->bgConfig);
    }
}

static void ClearBellTask_Render(UnkStruct_ov5_021D1BEC *task, FieldSystem *fieldSystem, void *taskData)
{
    ClearBellTaskData *data = taskData;

    Easy3DObject_Draw(&data->clearBellRisingObject);
    Easy3DObject_Draw(&data->clearBellObject);

    for (int i = 0; i < 4; i++) {
        Easy3DObject_Draw(&data->cornerBellObjects[i]);
    }

    if (data->waves) {
        Easy3DObject_Draw(&data->wavesObject);
    }
}

static ClearBellTaskData *BellData(void)
{
    return sCutscene != NULL && sCutscene->bellTask != NULL ? ov5_021D1C2C(sCutscene->bellTask) : NULL;
}

static void BeginClearBell(FieldSystem *fieldSystem)
{
    static const UnkStruct_ov6_0223E6EC sTemplate = {
        TASK_PRIORITY, sizeof(ClearBellTaskData), ClearBellTask_Init, ClearBellTask_Destroy, ClearBellTask_Update, ClearBellTask_Render
    };

    if (sCutscene != NULL) {
        return;
    }

    sCutscene = Heap_AllocAtEnd(CUTSCENE_HEAP, sizeof(LegendCutscene));
    memset(sCutscene, 0, sizeof(LegendCutscene));
    sCutscene->lugia = fieldSystem->location->mapHeaderID == MAP_HEADER_HGSS_WHIRL_ISLANDS_B3F_LUGIA_CAVE;
    sCutscene->lookAtTarget = Camera_GetTarget(fieldSystem->camera);
    sCutscene->lookAtPos = Camera_GetPosition(fieldSystem->camera);
    sCutscene->distance = Camera_GetDistance(fieldSystem->camera);
    sCutscene->angle = Camera_GetAngle(fieldSystem->camera);
    sCutscene->fovY = Camera_GetFOV(fieldSystem->camera);
    sCutscene->nearClip = fieldSystem->camera->perspective.nearClip;
    sCutscene->farClip = fieldSystem->camera->perspective.farClip;
    sCutscene->bellTask = ov5_021D1B6C(fieldSystem->unk_04->unk_04, &sTemplate);
}

// The scene's end: HeartGold plays its cinematic of the bird's flight next (Cinematic, not ported), whose return to the
// field leaves the camera as the field has it, so the camera goes back to where it was as the scene began
static void EndClearBell(FieldSystem *fieldSystem)
{
    Camera *camera = fieldSystem->camera;

    if (sCutscene == NULL) {
        return;
    }

    CameraPath_End(&sCutscene->path);
    Camera_SetTarget(&sCutscene->lookAtTarget, camera);
    Camera_SetPosition(&sCutscene->lookAtPos, camera);
    Camera_SetDistance(sCutscene->distance, camera);
    Camera_SetAngleAroundTarget(&sCutscene->angle, camera);
    Camera_SetFOV(sCutscene->fovY, camera);
    Camera_SetClipping(sCutscene->nearClip, sCutscene->farClip, camera);

    if (sCutscene->bellTask != NULL) {
        ov5_021D1BEC(sCutscene->bellTask);
    }

    Heap_Free(sCutscene);
    sCutscene = NULL;
}

static void BeginWaves(FieldSystem *fieldSystem, ClearBellTaskData *data)
{
    NARC *narc = NARC_ctor(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, CUTSCENE_HEAP);
    VecFx32 pos;

    LoadModel(&data->wavesModel, narc, 38);
    LoadAnim(&data->wavesAnims[0], &data->wavesModel, narc, 39, &data->allocator);
    LoadAnim(&data->wavesAnims[1], &data->wavesModel, narc, 40, &data->allocator);
    NARC_dtor(narc);
    Easy3DObject_Init(&data->wavesObject, &data->wavesModel);
    Easy3DObject_AddAnim(&data->wavesObject, &data->wavesAnims[0]);
    Easy3DObject_AddAnim(&data->wavesObject, &data->wavesAnims[1]);
    Easy3DObject_SetVisible(&data->wavesObject, TRUE);
    SetFrames(data->wavesAnims, 2, 0);
    PlayerPos(fieldSystem, &pos);
    Easy3DObject_SetPosition(&data->wavesObject, pos.x, pos.y, pos.z);
    data->waves = TRUE;
}

// HeartGold's beginLeavesEffect: its two layers of leaves over the 3D, each a loop of six tilemaps, drifting
static void BeginLeaves(FieldSystem *fieldSystem, ClearBellTaskData *data)
{
    BgConfig *bgConfig = fieldSystem->bgConfig;

    for (int i = 0; i < LEAVES_TILEMAPS; i++) {
        data->bg2Files[i] = Graphics_GetScrnData(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, LEGEND_MEMBER(sBg2Tilemaps[i]), FALSE, &data->bg2Screens[i], CUTSCENE_HEAP);
        data->bg3Files[i] = Graphics_GetScrnData(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, LEGEND_MEMBER(sBg3Tilemaps[i]), FALSE, &data->bg3Screens[i], CUTSCENE_HEAP);
    }

    data->savedBgControl[0] = reg_G2_BG0CNT;
    data->savedBgControl[1] = reg_G2_BG2CNT;
    data->savedBgControl[2] = reg_G2_BG3CNT;
    MI_CpuCopy16((void *)(HW_BG_PLTT + LEAVES_PALETTE * 32), data->savedPalette, sizeof(data->savedPalette));

    Bg_LoadTilemapBuffer(bgConfig, BG_LAYER_MAIN_2, data->bg2Screens[0]->rawData, data->bg2Screens[0]->szByte);
    Bg_LoadTilemapBuffer(bgConfig, BG_LAYER_MAIN_3, data->bg3Screens[0]->rawData, data->bg3Screens[0]->szByte);
    Bg_ChangeTilemapRectPalette(bgConfig, BG_LAYER_MAIN_2, 0, 0, 32, 32, LEAVES_PALETTE);
    Bg_ChangeTilemapRectPalette(bgConfig, BG_LAYER_MAIN_3, 0, 0, 32, 32, LEAVES_PALETTE);
    Graphics_LoadTilesToBgLayer(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, LEGEND_MEMBER(53), bgConfig, BG_LAYER_MAIN_2, 0, 0, FALSE, CUTSCENE_HEAP);
    Graphics_LoadTilesToBgLayer(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, LEGEND_MEMBER(53), bgConfig, BG_LAYER_MAIN_3, 0, 0, FALSE, CUTSCENE_HEAP);
    Graphics_LoadPalette(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, LEGEND_MEMBER(54), PAL_LOAD_MAIN_BG, LEAVES_PALETTE * 32, 32, CUTSCENE_HEAP);
    Bg_ScheduleTilemapTransfer(bgConfig, BG_LAYER_MAIN_2);
    Bg_ScheduleTilemapTransfer(bgConfig, BG_LAYER_MAIN_3);
    GXLayers_EngineAToggleLayers(GX_PLANEMASK_BG2 | GX_PLANEMASK_BG3, TRUE);
    data->switchTimer = 0;
    data->tilemap = 0;
    data->bg2X = data->bg3X = data->bgY = 0;
    G2_SetBG2Priority(0);
    G2_SetBG3Priority(1);
    G2_SetBG0Priority(2);
    data->leaves = TRUE;
}

// HeartGold's LegendCutscene_MoveCamera: straight to one of the scene's camera points
static void MoveCamera(FieldSystem *fieldSystem, u8 scene)
{
    const CutsceneParam *param = &CameraParams(sCutscene->lugia)[scene];
    CameraAngle angle = { 0 };

    angle.x = param->angleX;
    Camera_SetTarget(&sCutscene->lookAtTarget, fieldSystem->camera);
    Camera_SetPosition(&sCutscene->lookAtPos, fieldSystem->camera);
    Camera_SetDistance(param->distance, fieldSystem->camera);
    Camera_SetAngleAroundTarget(&angle, fieldSystem->camera);
    Camera_SetFOV(param->fovY, fieldSystem->camera);
    Camera_Move(&CameraOffsets(sCutscene->lugia)[scene], fieldSystem->camera);
    Camera_SetClipping(FX32_CONST(150), FX32_CONST(1700), fieldSystem->camera);
}

// HeartGold's LegendCutscene_StartPanCameraTo: to the scene's first point (0) or its last
static void PanCamera(FieldSystem *fieldSystem, u8 destination)
{
    int point = destination == 0 ? 0 : 3;
    const CutsceneParam *param = &CameraParams(sCutscene->lugia)[point];
    CameraPathPoint target;
    int duration;

    target.angleX = param->angleX;
    target.fovY = param->fovY;
    target.position = CameraOffsets(sCutscene->lugia)[point];
    target.distance = param->distance;

    if (!sCutscene->lugia) {
        duration = destination == 0 ? 200 : 20;
    } else {
        duration = destination == 0 ? 160 : 200;
    }

    CameraPath_Start(&sCutscene->path, fieldSystem->camera, &target, duration);
}

static void EffectTask_Init(UnkStruct_ov5_021D1BEC *task, FieldSystem *fieldSystem, void *taskData)
{
    memset(taskData, 0, sizeof(EffectTaskData));
}

static void EffectTask_Destroy(UnkStruct_ov5_021D1BEC *task, FieldSystem *fieldSystem, void *taskData)
{
    EffectTaskData *data = taskData;

    for (int i = 2; i >= 0; i--) {
        Easy3DAnim_Release(&data->anims[i], &data->allocator);
    }

    Easy3DModel_Release(&data->model);
}

static void EffectTask_Update(UnkStruct_ov5_021D1BEC *task, FieldSystem *fieldSystem, void *taskData)
{
}

static void EffectTask_Render(UnkStruct_ov5_021D1BEC *task, FieldSystem *fieldSystem, void *taskData)
{
    EffectTaskData *data = taskData;

    if (data->drawing) {
        Easy3DObject_Draw(&data->object);
    }
}

// A 3D effect of one to three animations (HeartGold's ov02_02245E04, its loadEyeGlimmer3dModel and
// Task_BirdFinalApproach's init) at pos
static UnkStruct_ov5_021D1BEC *StartEffectAnims(FieldSystem *fieldSystem, int model, const int *anims, int count, const VecFx32 *pos)
{
    static const UnkStruct_ov6_0223E6EC sTemplate = {
        TASK_PRIORITY, sizeof(EffectTaskData), EffectTask_Init, EffectTask_Destroy, EffectTask_Update, EffectTask_Render
    };
    UnkStruct_ov5_021D1BEC *task = ov5_021D1B6C(fieldSystem->unk_04->unk_04, &sTemplate);
    EffectTaskData *data = ov5_021D1C2C(task);
    NARC *narc = NARC_ctor(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, CUTSCENE_HEAP);

    GF_ASSERT(count >= 1 && count <= 3);
    HeapExp_FndInitAllocator(&data->allocator, CUTSCENE_HEAP, 0x20);
    LoadModel(&data->model, narc, model);

    for (int i = 0; i < count; i++) {
        LoadAnim(&data->anims[i], &data->model, narc, anims[i], &data->allocator);
    }

    NARC_dtor(narc);
    Easy3DObject_Init(&data->object, &data->model);

    for (int i = 0; i < count; i++) {
        Easy3DObject_AddAnim(&data->object, &data->anims[i]);
    }

    SetFrames(data->anims, count, 0);
    Easy3DObject_SetPosition(&data->object, pos->x, pos->y, pos->z);
    Easy3DObject_SetVisible(&data->object, TRUE);
    return task;
}

static UnkStruct_ov5_021D1BEC *StartEffect(FieldSystem *fieldSystem, int model, const int anims[3], const VecFx32 *pos)
{
    return StartEffectAnims(fieldSystem, model, anims, 3, pos);
}

// HeartGold's Task_LugiaEyeGlimmer
static void EyeGlimmer_Task(SysTask *task, void *taskData)
{
    EyeGlimmer *eye = taskData;
    EffectTaskData *data = ov5_021D1C2C(eye->effectTask);

    data->drawing = TRUE;

    if (++eye->timer == 2) {
        Sound_PlayEffect(SE_EYE_GLIMMER);
    }

    if (AdvanceNoLoop(data->anims, 3)) {
        ov5_021D1BEC(eye->effectTask);
        SysTask_Done(eye->task);
        eye->done = TRUE;
    }
}

static void StartEyeGlimmer(FieldSystem *fieldSystem)
{
    static const int sAnims[3] = { 29, 30, 31 };
    VecFx32 pos;

    PlayerPos(fieldSystem, &pos);
    pos.y += FX32_CONST(100);
    pos.z -= FX32_CONST(350);
    sEye = Heap_AllocAtEnd(CUTSCENE_HEAP, sizeof(EyeGlimmer));
    memset(sEye, 0, sizeof(EyeGlimmer));
    sEye->effectTask = StartEffect(fieldSystem, 28, sAnims, &pos);
    sEye->task = SysTask_Start(EyeGlimmer_Task, sEye, 0);
}

static MapObject *FindBird(FieldSystem *fieldSystem, BOOL lugia)
{
    MapObject *mapObj = NULL;
    int index = 0;

    while (MapObjectMan_FindObjectWithStatus(fieldSystem->mapObjMan, &mapObj, &index, MAP_OBJ_STATUS_0)) {
        if (MapObject_GetGraphicsID(mapObj) == (lugia ? OBJ_EVENT_GFX_LEGENDARY_LUGIA : OBJ_EVENT_GFX_LEGENDARY_HO_OH)) {
            return mapObj;
        }
    }

    return NULL;
}

enum BirdState {
    BIRD_STATE_INIT = 0,
    BIRD_STATE_CORRECT_POS,
    BIRD_STATE_FLAP_DOWN,
    BIRD_STATE_DELAY,
    BIRD_STATE_DELAY_CRY,
    BIRD_STATE_CIRCLE,
    BIRD_STATE_WAIT_AFTER,
    BIRD_STATE_FINISH,
};

// HeartGold's Task_BirdFinalApproach: the bird, raised above its place, flaps down to it, then cries with a ring of
// light round it
static void Bird_Task(SysTask *task, void *taskData)
{
    BirdApproach *bird = taskData;
    FieldSystem *fieldSystem = bird->fieldSystem;
    VecFx32 pos;

    if (bird->bird == NULL) {
        bird->state = BIRD_STATE_FINISH;
    }

    switch (bird->state) {
    case BIRD_STATE_INIT: {
        static const int sAnims[3] = { 35, 36, 37 };

        PlayerPos(fieldSystem, &pos);

        if (!bird->lugia) {
            pos.y += FX32_CONST(40);
            pos.z -= FX32_CONST(16);
        } else {
            pos.z -= FX32_CONST(280);
        }

        bird->effectTask = StartEffect(fieldSystem, 34, sAnims, &pos);
        bird->state++;
        break;
    }
    case BIRD_STATE_CORRECT_POS:
        MapObject_GetPosPtr(bird->bird, &pos);
        bird->yEnd = pos.y;
        bird->yDelta = bird->lugia ? FX32_CONST(160) : FX32_CONST(120);
        pos.y += bird->yDelta;
        MapObject_SetPos(bird->bird, &pos);
        MapObject_SetHidden(bird->bird, FALSE);
        bird->timer = 0;
        bird->flapTimer = 0;
        bird->state++;
        break;
    case BIRD_STATE_FLAP_DOWN:
        if (++bird->timer >= (bird->lugia ? 18 : 0)) {
            if (bird->flapTimer == 0) {
                Sound_PlayEffect(SE_BIRD_FLAP);
                bird->flapTimer = 24;
            }

            bird->flapTimer--;
        }

        MapObject_GetPosPtr(bird->bird, &pos);
        bird->yDelta -= FX32_ONE;

        if (bird->yDelta <= 0) {
            bird->yDelta = 0;
            bird->timer = 0;
            bird->state++;
        }

        pos.y = bird->yEnd + bird->yDelta;
        MapObject_SetPos(bird->bird, &pos);
        break;
    case BIRD_STATE_DELAY:
        if (++bird->timer >= 60) {
            bird->timer = 0;
            bird->state++;
        }
        break;
    case BIRD_STATE_DELAY_CRY:
        if (++bird->timer >= 50) {
            ((EffectTaskData *)ov5_021D1C2C(bird->effectTask))->drawing = TRUE;
            Sound_PlayPokemonCry(bird->lugia ? SPECIES_LUGIA : SPECIES_HO_OH, 0);
            bird->animTimer = 0;
            bird->timer = 0;
            bird->state++;
        }
        break;
    case BIRD_STATE_CIRCLE: {
        BOOL done = AdvanceNoLoop(((EffectTaskData *)ov5_021D1C2C(bird->effectTask))->anims, 3);

        if (done && ++bird->animTimer >= 65) {
            ((EffectTaskData *)ov5_021D1C2C(bird->effectTask))->drawing = FALSE;
            bird->timer = 0;
            bird->state++;
        } else if (!done) {
            bird->animTimer++;
        }
        break;
    }
    case BIRD_STATE_WAIT_AFTER:
        if (++bird->timer >= 30) {
            bird->state++;
        }
        break;
    case BIRD_STATE_FINISH:
        if (bird->effectTask != NULL) {
            ov5_021D1BEC(bird->effectTask);
            bird->effectTask = NULL;
        }

        SysTask_Done(task);
        bird->done = TRUE;
        break;
    }
}

static void StartBird(FieldSystem *fieldSystem)
{
    BOOL lugia = fieldSystem->location->mapHeaderID == MAP_HEADER_HGSS_WHIRL_ISLANDS_B3F_LUGIA_CAVE;

    sBird = Heap_AllocAtEnd(CUTSCENE_HEAP, sizeof(BirdApproach));
    memset(sBird, 0, sizeof(BirdApproach));
    sBird->fieldSystem = fieldSystem;
    sBird->lugia = lugia;
    sBird->bird = FindBird(fieldSystem, lugia);
    sBird->task = SysTask_Start(Bird_Task, sBird, 0);
}

// SoulSilver's LegendCutscene_BeginLugiaArrivesEffect: the camera to the cave's last point as Lugia rises, kept to pan
// back with
static void BeginLugiaArrives(FieldSystem *fieldSystem)
{
    Camera *camera = fieldSystem->camera;
    VecFx32 lookAt = Camera_GetTarget(camera);
    CameraAngle angle = { 0 };

    if (sCutscene != NULL) {
        return;
    }

    sCutscene = Heap_AllocAtEnd(CUTSCENE_HEAP, sizeof(LegendCutscene));
    memset(sCutscene, 0, sizeof(LegendCutscene));
    sCutscene->lugia = TRUE;
    sCutscene->distance = Camera_GetDistance(camera);
    sCutscene->angle = Camera_GetAngle(camera);

    if (camera->targetPos != NULL) {
        VEC_Subtract(&lookAt, camera->targetPos, &sCutscene->targetDistance);
    }

    sCutscene->fovY = Camera_GetFOV(camera);
    sCutscene->nearClip = camera->perspective.nearClip;
    sCutscene->farClip = camera->perspective.farClip;

    angle.x = sCameraParamLugia[4].angleX;
    Camera_SetDistance(sCameraParamLugia[4].distance, camera);
    Camera_SetAngleAroundTarget(&angle, camera);
    Camera_SetFOV(sCameraParamLugia[4].fovY, camera);
    Camera_Move(&sCameraOffsetLugia[4], camera);
    Camera_SetClipping(FX32_CONST(150), FX32_CONST(1700), camera);
}

static void PanBackFromLugia(FieldSystem *fieldSystem)
{
    CameraPathPoint target;

    if (sCutscene == NULL) {
        return;
    }

    target.angleX = sCutscene->angle.x;
    target.fovY = sCutscene->fovY;
    target.position = sCutscene->targetDistance;
    target.distance = sCutscene->distance;
    CameraPath_Start(&sCutscene->path, fieldSystem->camera, &target, 30);
}

static BOOL CameraPanDone(ScriptContext *ctx)
{
    return sCutscene == NULL || !sCutscene->path.active;
}

static BOOL LugiaPanDone(ScriptContext *ctx)
{
    if (sCutscene != NULL && sCutscene->path.active) {
        return FALSE;
    }

    if (sCutscene != NULL) {
        Camera_SetClipping(sCutscene->nearClip, sCutscene->farClip, ctx->fieldSystem->camera);
    }

    return TRUE;
}

static BOOL BirdDone(ScriptContext *ctx)
{
    if (sBird == NULL || !sBird->done) {
        return sBird == NULL;
    }

    Heap_Free(sBird);
    sBird = NULL;
    return TRUE;
}

static BOOL EyeDone(ScriptContext *ctx)
{
    if (sEye == NULL || !sEye->done) {
        return sEye == NULL;
    }

    Heap_Free(sEye);
    sEye = NULL;
    return TRUE;
}

static BOOL RunOp(ScriptContext *ctx);

BOOL CompleteScrCmd_LegendCutscene(ScriptContext *ctx)
{
    BOOL result = RunOp(ctx);

#ifdef SOVEREIGN_TEST
    gCompleteTestLegend[2] = sCutscene != NULL;
#endif
    return result;
}

static BOOL RunOp(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    u16 op = ScriptContext_ReadHalfWord(ctx);
    u16 arg = ScriptContext_ReadHalfWord(ctx);
    ClearBellTaskData *bell = BellData();

#ifdef SOVEREIGN_TEST
    gCompleteTestLegend[0]++;
    gCompleteTestLegend[1] = op;

    if (op == LEGEND_CUTSCENE_CLEAR_BELL_BEGIN) {
        gCompleteTestLegend[3] = Camera_GetDistance(fieldSystem->camera) >> FX32_SHIFT;
    }
#endif

    switch (op) {
    case LEGEND_CUTSCENE_CLEAR_BELL_BEGIN:
        BeginClearBell(fieldSystem);
        return FALSE;
    case LEGEND_CUTSCENE_CLEAR_BELL_END:
        EndClearBell(fieldSystem);
#ifdef SOVEREIGN_TEST
        gCompleteTestLegend[4] = Camera_GetDistance(fieldSystem->camera) >> FX32_SHIFT;
#endif
        return FALSE;
    case LEGEND_CUTSCENE_CLEAR_BELL_RISE:
        if (bell != NULL) {
            bell->state = CLEAR_BELL_STATE_RISE_BEGIN;
        }
        return FALSE;
    case LEGEND_CUTSCENE_CLEAR_BELL_SHIMMER:
        if (bell != NULL) {
            bell->shimmerClearBellOnly = arg;

            if (bell->state == CLEAR_BELL_STATE_IDLE_LOOP) {
                bell->state = CLEAR_BELL_STATE_SHIMMER_BEGIN;
            } else {
                bell->shimmerPending = TRUE; // HeartGold's Task_WaitShimmerEffectAndRestart
            }
        }
        return TRUE;
    case LEGEND_CUTSCENE_EFFECT_BEGIN:
        if (bell != NULL && bell->lugia) {
            BeginWaves(fieldSystem, bell);
        } else if (bell != NULL) {
            BeginLeaves(fieldSystem, bell);
        }
        return FALSE;
    case LEGEND_CUTSCENE_EFFECT_END:
        if (bell != NULL) {
            EndWaves(bell);
            EndLeaves(bell);
        }
        return FALSE;
    case LEGEND_CUTSCENE_PAN_CAMERA:
        if (sCutscene != NULL) {
            PanCamera(fieldSystem, arg);
        }
        return FALSE;
    case LEGEND_CUTSCENE_WAIT_CAMERA_PAN:
        ScriptContext_Pause(ctx, CameraPanDone);
        return TRUE;
    case LEGEND_CUTSCENE_MOVE_CAMERA:
        if (sCutscene != NULL && arg < 3) {
            MoveCamera(fieldSystem, arg);
        }
        return FALSE;
    case LEGEND_CUTSCENE_BIRD_APPROACH:
        StartBird(fieldSystem);
        ScriptContext_Pause(ctx, BirdDone);
        return TRUE;
    case LEGEND_CUTSCENE_LUGIA_EYE:
        StartEyeGlimmer(fieldSystem);
        ScriptContext_Pause(ctx, EyeDone);
        return TRUE;
    case LEGEND_CUTSCENE_LUGIA_ARRIVES_BEGIN:
        BeginLugiaArrives(fieldSystem);
        return FALSE;
    case LEGEND_CUTSCENE_LUGIA_ARRIVES_END:
        if (sCutscene != NULL && sCutscene->bellTask == NULL) {
            CameraPath_End(&sCutscene->path);
            Heap_Free(sCutscene);
            sCutscene = NULL;
        }
        return FALSE;
    case LEGEND_CUTSCENE_LUGIA_ARRIVES_PAN:
        PanBackFromLugia(fieldSystem);
        ScriptContext_Pause(ctx, LugiaPanDone);
        return TRUE;
    default:
        return FALSE;
    }
}

// HeartGold's ScrCmd_708 (ov02_022460AC): one of the Rocket Hideout's traps going off under the player, its model and
// animations at the player's feet (HeartGold's ov02_02253264), played to their end. HeartGold's own trap sounds stand
// in as Platinum's (docs/Music.md): an electronic buzz, the poison step, a thud.
typedef struct HideoutTrap {
    UnkStruct_ov5_021D1BEC *effectTask;
    u8 animCount;
} HideoutTrap;

static const struct {
    u8 model;
    u8 animCount;
    int anims[3];
    u16 se;
} sHideoutTraps[COMPLETE_HIDEOUT_TRAPS] = {
    [COMPLETE_HIDEOUT_TRAP_ELECTRIC] = { 10, 1, { 11 }, SEQ_SE_DP_DENSI01_sseq }, // SEQ_SE_GS_DENKI_TRAP
    [COMPLETE_HIDEOUT_TRAP_POISON] = { 3, 2, { 4, 5 }, SEQ_SE_DP_DOKU2_sseq }, // SEQ_SE_GS_DOKU_TRAP
    [COMPLETE_HIDEOUT_TRAP_ROCK] = { 6, 3, { 7, 8, 9 }, SEQ_SE_DP_WALL_HIT2_sseq }, // SEQ_SE_GS_IWA_TRAP
};

static BOOL HideoutTrap_Task(FieldTask *task)
{
    HideoutTrap *trap = FieldTask_GetEnv(task);
    EffectTaskData *data = ov5_021D1C2C(trap->effectTask);

    data->drawing = TRUE;

    if (AdvanceNoLoop(data->anims, trap->animCount)) {
        ov5_021D1BEC(trap->effectTask);
        Heap_Free(trap);
#ifdef SOVEREIGN_TEST
        gCompleteTestLegend[0]++;
#endif
        return TRUE;
    }

    return FALSE;
}

BOOL CompleteScrCmd_HideoutTrap(ScriptContext *ctx)
{
    u16 kind = ScriptContext_GetVar(ctx);
    FieldSystem *fieldSystem = ctx->fieldSystem;
    HideoutTrap *trap;
    VecFx32 pos;

    if (kind >= COMPLETE_HIDEOUT_TRAPS) {
        GF_ASSERT(FALSE);
        return FALSE;
    }

    trap = Heap_AllocAtEnd(CUTSCENE_HEAP, sizeof(HideoutTrap));
    PlayerPos(fieldSystem, &pos);
    trap->animCount = sHideoutTraps[kind].animCount;
    trap->effectTask = StartEffectAnims(fieldSystem, sHideoutTraps[kind].model, sHideoutTraps[kind].anims, trap->animCount, &pos);
    Sound_PlayEffect(sHideoutTraps[kind].se);
#ifdef SOVEREIGN_TEST
    gCompleteTestLegend[1] = 0x100 + kind;
#endif
    FieldTask_InitCall(fieldSystem->task, HideoutTrap_Task, trap);
    return TRUE;
}

// HeartGold's ScrCmd_709 (ov02_022462E8): the Rocket Hideout's alarm as a Persian statue sees the player, a red
// screen (HeartGold's demo/legend 12 to 14) over the field, faded in and out twice, a step a frame to 12 of 31 and back
// (its ov02_02246490). HeartGold's siren is its own: a beep stands in. The screen is on the field's layer 2, as the
// leaves are, its palette, priorities and blending put back after.
#define ALARM_PALETTE   6
#define ALARM_PULSES    2
#define ALARM_PEAK      12
#define ALARM_SE        SEQ_SE_DP_DENSI06_sseq // SEQ_SE_GS_AJITO_SIREN

typedef struct HideoutAlarm {
    FieldSystem *fieldSystem;
    u8 state;
    u8 pulses;
    u8 step;
    u8 alpha;
    u16 savedPalette[16];
    u16 savedBg0Control;
    u16 savedBg2Control;
    u16 savedBlendControl;
    u16 savedBlendAlpha;
} HideoutAlarm;

static void HideoutAlarm_SetBlend(u8 alpha)
{
    G2_SetBlendAlpha(GX_BLEND_PLANEMASK_BG2, GX_BLEND_PLANEMASK_BG0 | GX_BLEND_PLANEMASK_BG1 | GX_BLEND_PLANEMASK_BG3 | GX_BLEND_PLANEMASK_OBJ | GX_BLEND_PLANEMASK_BD, alpha, 31 - alpha);
}

static void HideoutAlarm_Begin(HideoutAlarm *alarm)
{
    BgConfig *bgConfig = alarm->fieldSystem->bgConfig;

    alarm->savedBg0Control = reg_G2_BG0CNT;
    alarm->savedBg2Control = reg_G2_BG2CNT;
    alarm->savedBlendControl = reg_G2_BLDCNT;
    alarm->savedBlendAlpha = reg_G2_BLDALPHA;
    MI_CpuCopy16((void *)(HW_BG_PLTT + ALARM_PALETTE * 32), alarm->savedPalette, sizeof(alarm->savedPalette));

    alarm->alpha = 0;
    HideoutAlarm_SetBlend(0);
    Graphics_LoadPalette(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, LEGEND_MEMBER(12), PAL_LOAD_MAIN_BG, ALARM_PALETTE * 32, 32, CUTSCENE_HEAP);
    Graphics_LoadTilesToBgLayer(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, LEGEND_MEMBER(13), bgConfig, BG_LAYER_MAIN_2, 0, 0x40, FALSE, CUTSCENE_HEAP);
    Graphics_LoadTilemapToBgLayer(NARC_INDEX_FIELDDATA__COMPLETE__LEGEND, LEGEND_MEMBER(14), bgConfig, BG_LAYER_MAIN_2, 0, 0, FALSE, CUTSCENE_HEAP);
    Bg_ChangeTilemapRectPalette(bgConfig, BG_LAYER_MAIN_2, 0, 0, 32, 32, ALARM_PALETTE);
    Bg_ScheduleTilemapTransfer(bgConfig, BG_LAYER_MAIN_2);
    Bg_SetOffset(bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_X, 0);
    Bg_SetOffset(bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_Y, 0);
    G2_SetBG2Priority(0);
    G2_SetBG0Priority(1);
    GXLayers_EngineAToggleLayers(GX_PLANEMASK_BG2, TRUE);
}

static void HideoutAlarm_End(HideoutAlarm *alarm)
{
    BgConfig *bgConfig = alarm->fieldSystem->bgConfig;

    GXLayers_EngineAToggleLayers(GX_PLANEMASK_BG2, FALSE);
    Bg_ClearTilemap(bgConfig, BG_LAYER_MAIN_2);
    reg_G2_BG0CNT = alarm->savedBg0Control;
    reg_G2_BG2CNT = alarm->savedBg2Control;
    reg_G2_BLDCNT = alarm->savedBlendControl;
    reg_G2_BLDALPHA = alarm->savedBlendAlpha;
    GX_LoadBGPltt(alarm->savedPalette, ALARM_PALETTE * 32, sizeof(alarm->savedPalette));
}

// HeartGold's ov02_02246490: one pulse, a step a frame; TRUE once it's over
static BOOL HideoutAlarm_Pulse(HideoutAlarm *alarm)
{
    HideoutAlarm_SetBlend(alarm->alpha);

    if (alarm->step++ < ALARM_PEAK) {
        alarm->alpha++;
    } else {
        alarm->alpha--;
    }

    if (alarm->step > ALARM_PEAK * 2) {
        alarm->step = 0;
        alarm->alpha = 0;
        return TRUE;
    }

    return FALSE;
}

static BOOL HideoutAlarm_Task(FieldTask *task)
{
    HideoutAlarm *alarm = FieldTask_GetEnv(task);

    switch (alarm->state) {
    case 0:
        HideoutAlarm_Begin(alarm);
        Sound_PlayEffect(ALARM_SE);
        alarm->state++;
        break;
    case 1:
        if (HideoutAlarm_Pulse(alarm) && ++alarm->pulses >= ALARM_PULSES) {
            alarm->state++;
        }
        break;
    default:
        HideoutAlarm_End(alarm);
        Heap_Free(alarm);
#ifdef SOVEREIGN_TEST
        gCompleteTestLegend[0]++;
#endif
        return TRUE;
    }

    return FALSE;
}

BOOL CompleteScrCmd_HideoutAlarm(ScriptContext *ctx)
{
    HideoutAlarm *alarm = Heap_AllocAtEnd(CUTSCENE_HEAP, sizeof(HideoutAlarm));

    memset(alarm, 0, sizeof(HideoutAlarm));
    alarm->fieldSystem = ctx->fieldSystem;
#ifdef SOVEREIGN_TEST
    gCompleteTestLegend[1] = 0x200;
#endif
    FieldTask_InitCall(ctx->fieldSystem->task, HideoutAlarm_Task, alarm);
    return TRUE;
}
