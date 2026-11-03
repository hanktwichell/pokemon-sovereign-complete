#include "applications/complete_magnet_train.h"

#include <nitro.h>
#include <string.h>

#include "constants/graphics.h"
#include "constants/heap.h"
#include "constants/narc.h"

#include "camera.h"
#include "complete_test.h"
#include "easy3d_object.h"
#include "g3d_pipeline.h"
#include "gx_layers.h"
#include "heap.h"
#include "narc.h"
#include "overlay_manager.h"
#include "screen_fade.h"
#include "sound.h"
#include "sound_playback.h"
#include "system.h"

#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: HeartGold's Magnet Train ride (its overlay 104, ov104_021E5900 to ov104_021E5EB0, in assembly
// there): three cuts, each a model of HeartGold's (tools/complete/import_hgss_magnet_train.py) with its joint and
// texture animations, from a fixed camera of its own. The first two cuts end on their animation's last frame with
// the screen closing like a shutter, the third at its frame 205, fading to black; the next cut fades in. Its sound
// effects (the train setting off, passing and pulling in) are HeartGold's own, which aren't in Platinum's sound
// archive; the jingle as the train pulls in is HeartGold's (SEQ_GS_E_LINEAR).

#define TRAIN_HEAP_ID HEAP_ID_DISTORTION_WORLD_WARP // the Distortion World warp's: its scene can't run at the same time
#define TRAIN_HEAP_SIZE 0x50000
#define TRAIN_CUTS 3
#define TRAIN_CUT_ANIMS 2
#define TRAIN_LAST_CUT_FRAMES 205
#define TRAIN_FADE_STEPS 6
#define TRAIN_GENDERS 2 // the player's: GENDER_MALE, GENDER_FEMALE

enum TrainState {
    TRAIN_STATE_CUT = 0,
    TRAIN_STATE_FADE_OUT,
};

typedef struct TrainCut {
    Easy3DModel model;
    Easy3DAnim anims[TRAIN_CUT_ANIMS];
    Easy3DObject object;
} TrainCut;

typedef struct MagnetTrain {
    CompleteMagnetTrainArgs *args;
    G3DPipelineBuffers *pipeline;
    Camera *camera;
    NNSFndAllocator allocator;
    TrainCut cuts[TRAIN_CUTS];
    u8 cut;
    u8 jinglePlayed;
    u16 frames;
} MagnetTrain;

// Each cut's model and its two animations (members of HeartGold's archive), by the way, by day or by night, and by
// the player's gender (HeartGold's ov104_021E6060 to ov104_021E6108)
typedef struct TrainCutFiles {
    u16 model;
    u16 anims[TRAIN_CUT_ANIMS];
} TrainCutFiles;

static const TrainCutFiles sCutFiles[COMPLETE_MAGNET_TRAIN_WAYS][2][TRAIN_GENDERS][TRAIN_CUTS] = {
    [COMPLETE_MAGNET_TRAIN_TO_SAFFRON] = {
        { { { 0, { 1, 2 } }, { 12, { 13, 14 } }, { 24, { 25, 26 } } },
          { { 3, { 4, 5 } }, { 15, { 16, 17 } }, { 24, { 25, 26 } } } },
        { { { 6, { 7, 8 } }, { 18, { 19, 20 } }, { 27, { 28, 29 } } },
          { { 9, { 10, 11 } }, { 21, { 22, 23 } }, { 27, { 28, 29 } } } },
    },
    [COMPLETE_MAGNET_TRAIN_TO_GOLDENROD] = {
        { { { 30, { 31, 32 } }, { 42, { 43, 44 } }, { 54, { 55, 56 } } },
          { { 33, { 34, 35 } }, { 45, { 46, 47 } }, { 54, { 55, 56 } } } },
        { { { 36, { 37, 38 } }, { 48, { 49, 50 } }, { 57, { 58, 59 } } },
          { { 39, { 40, 41 } }, { 51, { 52, 53 } }, { 57, { 58, 59 } } } },
    },
};

// Each cut's camera, by the way (HeartGold's ov104_021E5FD0, ov104_021E5F88 and ov104_021E5F24): its distance from
// the model's origin, its angle and field of view, how far the camera and its target move from there, and its
// clipping planes
typedef struct TrainCamera {
    fx32 distance;
    CameraAngle angle;
    u16 fovY;
    VecFx32 offset;
    u16 nearClip;
    u16 farClip;
} TrainCamera;

static const TrainCamera sCameras[COMPLETE_MAGNET_TRAIN_WAYS][TRAIN_CUTS] = {
    [COMPLETE_MAGNET_TRAIN_TO_SAFFRON] = {
        { 0x1B8152, { 0xFAA2, 0xCAE0, 0, 0 }, 0x08C1, { 0x00065CA8, 0x0003C3AA, (fx32)0xFFF7F55E }, 150, 1700 },
        { 0x29AEC1, { 0xDC22, 0, 0, 0 }, 0x05C1, { 0x00018000, 0x00039F71, (fx32)0xFFFAE435 }, 150, 900 },
        { 0x299EC1, { 0xE002, 0, 0, 0 }, 0x06C1, { 0, 0x00013885, (fx32)0xFFFE3833 }, 150, 900 },
    },
    [COMPLETE_MAGNET_TRAIN_TO_GOLDENROD] = {
        { 0x1B8152, { 0xFAA2, 0x33E0, 0, 0 }, 0x08C1, { (fx32)0xFFFA5577, 0x0003C3AA, (fx32)0xFFF8700D }, 150, 1700 },
        { 0x29AEC1, { 0xDC22, 0, 0, 0 }, 0x05C1, { 0x00018000, 0x00039F71, (fx32)0xFFFAE435 }, 150, 900 },
        { 0x299EC1, { 0xE002, 0, 0, 0 }, 0x06C1, { 0, 0x00013885, (fx32)0xFFFE3833 }, 150, 900 },
    },
};

// HeartGold's edge marking colors for its models' outlines (ov104_021E5F14)
static const GXRgb sEdgeColors[8] = { 0, 0x1084, 0x1084, 0x1084, 0x1084, 0x1084, 0x1084, 0x1084 };

static void SetUp3D(void)
{
    GXLayers_EngineAToggleLayers(GX_PLANEMASK_BG0, TRUE);
    G2_SetBG0Priority(1);
    G3X_SetShading(GX_SHADING_TOON);
    G3X_AntiAlias(TRUE);
    G3X_AlphaTest(FALSE, 0);
    G3X_AlphaBlend(TRUE);
    G3X_EdgeMarking(TRUE);
    G3X_SetEdgeColorTable(sEdgeColors);
    G3X_SetFog(FALSE, GX_FOGBLEND_COLOR_ALPHA, GX_FOGSLOPE_0x8000, 0);
    G3X_SetClearColor(GX_RGB(0, 0, 0), 0, 0x7FFF, 63, FALSE);
    G3_ViewPort(0, 0, 255, 191);
}

static void SetBanks(void)
{
    GXBanks banks = {
        GX_VRAM_BG_128_C,
        GX_VRAM_BGEXTPLTT_NONE,
        GX_VRAM_SUB_BG_32_H,
        GX_VRAM_SUB_BGEXTPLTT_NONE,
        GX_VRAM_OBJ_16_F,
        GX_VRAM_OBJEXTPLTT_NONE,
        GX_VRAM_SUB_OBJ_16_I,
        GX_VRAM_SUB_OBJEXTPLTT_NONE,
        GX_VRAM_TEX_01_AB,
        GX_VRAM_TEXPLTT_0123_E,
    };

    GXLayers_SetBanks(&banks);
    MI_CpuClear32((void *)HW_BG_VRAM, HW_BG_VRAM_SIZE);
    MI_CpuClear32((void *)HW_DB_BG_VRAM, HW_DB_BG_VRAM_SIZE);
    MI_CpuClear16((void *)HW_BG_PLTT, sizeof(GXRgb));
    MI_CpuClear16((void *)HW_DB_BG_PLTT, sizeof(GXRgb));
}

static void LoadCuts(MagnetTrain *train)
{
    const CompleteMagnetTrainArgs *args = train->args;
    const TrainCutFiles *files = sCutFiles[args->way][args->night != FALSE][args->gender];
    NARC *narc = NARC_ctor(NARC_INDEX_DEMO__COMPLETE__MAGNET_TRAIN, TRAIN_HEAP_ID);

    HeapExp_FndInitAllocator(&train->allocator, TRAIN_HEAP_ID, 4);

    for (int i = 0; i < TRAIN_CUTS; i++) {
        TrainCut *cut = &train->cuts[i];

        Easy3DModel_LoadFrom(&cut->model, narc, files[i].model, TRAIN_HEAP_ID);

        // The last cut (the train pulling in) takes its colors from the area's light, as HeartGold has it
        if (i == TRAIN_CUTS - 1) {
            NNS_G3dMdlUseGlbDiff(cut->model.model);
            NNS_G3dMdlUseGlbAmb(cut->model.model);
            NNS_G3dMdlUseGlbSpec(cut->model.model);
            NNS_G3dMdlUseGlbEmi(cut->model.model);
        }

        Easy3DObject_Init(&cut->object, &cut->model);

        for (int j = 0; j < TRAIN_CUT_ANIMS; j++) {
            Easy3DAnim_LoadFrom(&cut->anims[j], &cut->model, narc, files[i].anims[j], TRAIN_HEAP_ID, &train->allocator);
            Easy3DAnim_SetFrame(&cut->anims[j], 0);
            Easy3DObject_AddAnim(&cut->object, &cut->anims[j]);
        }
    }

    NARC_dtor(narc);
}

static void FreeCuts(MagnetTrain *train)
{
    for (int i = 0; i < TRAIN_CUTS; i++) {
        for (int j = 0; j < TRAIN_CUT_ANIMS; j++) {
            Easy3DAnim_Release(&train->cuts[i].anims[j], &train->allocator);
        }

        Easy3DModel_Release(&train->cuts[i].model);
    }
}

// HeartGold's ov104_021E5BEC: the cut's camera around the model's origin. HeartGold's camera follows its target, which
// never moves (the origin), so this one doesn't follow it.
static void SetCamera(MagnetTrain *train)
{
    const TrainCamera *cam = &sCameras[train->args->way][train->cut];
    VecFx32 target = { 0, 0, 0 };

    Camera_InitWithTarget(&target, cam->distance, &cam->angle, cam->fovY, CAMERA_PROJECTION_PERSPECTIVE, FALSE, train->camera);
    Camera_Move(&cam->offset, train->camera);
    Camera_SetClipping(cam->nearClip << FX32_SHIFT, cam->farClip << FX32_SHIFT, train->camera);
    Camera_SetAsActive(train->camera);
}

static void SetLight(const ModelAttributes *light)
{
    for (int i = 0; i < GX_LIGHTS_COUNT; i++) {
        NNS_G3dGlbLightVector(i, light->lightVectors[i].x, light->lightVectors[i].y, light->lightVectors[i].z);
        NNS_G3dGlbLightColor(i, light->lightColors[i]);
    }

    NNS_G3dGlbMaterialColorDiffAmb(light->diffuseReflectColor, light->ambientReflectColor, light->setDiffuseColorAsVertexColor);
    NNS_G3dGlbMaterialColorSpecEmi(light->specularReflectColor, light->emissionColor, light->enableSpecularReflectShininessTable);
    NNS_G3dGlbPolygonAttr(light->enabledLightsMask, light->polygonMode, light->cullMode, light->polygonID, light->alpha, light->miscFlags);
}

// HeartGold's ov104_021E5E78: the first two cuts end on their animation's last frame, the last at its frame 205
static BOOL CutEnded(const TrainCut *cut, int index)
{
    fx32 next = Easy3DAnim_GetFrame(&cut->anims[0]) + FX32_ONE;

    if (index + 1 >= TRAIN_CUTS) {
        return next == TRAIN_LAST_CUT_FRAMES * FX32_ONE;
    }

    return next == Easy3DAnim_GetFrameCount(&cut->anims[0]);
}

static void DrawCut(MagnetTrain *train)
{
    TrainCut *cut = &train->cuts[train->cut];

    for (int j = 0; j < TRAIN_CUT_ANIMS; j++) {
        fx32 next = Easy3DAnim_GetFrame(&cut->anims[j]) + FX32_ONE;

        if (next < Easy3DAnim_GetFrameCount(&cut->anims[j])) {
            Easy3DAnim_SetFrame(&cut->anims[j], next);
        }
    }

    G3_ResetG3X();
    Camera_ComputeProjectionMatrix(CAMERA_PROJECTION_PERSPECTIVE, train->camera);
    Camera_ComputeViewMatrix();
    SetLight(&train->args->light);
    Easy3DObject_Draw(&cut->object);
    G3_RequestSwapBuffers(GX_SORTMODE_MANUAL, GX_BUFFERMODE_W);
}

BOOL CompleteMagnetTrain_Init(ApplicationManager *appMan, int *state)
{
    SetVBlankCallback(NULL, NULL);
    DisableHBlank();
    GXLayers_DisableEngineALayers();
    GXLayers_DisableEngineBLayers();
    GX_SetVisiblePlane(0);
    GXS_SetVisiblePlane(0);
    GX_SetVisibleWnd(GX_WNDMASK_NONE);
    GXS_SetVisibleWnd(GX_WNDMASK_NONE);
    G2_BlendNone();
    G2S_BlendNone();

    Heap_Create(HEAP_ID_APPLICATION, TRAIN_HEAP_ID, TRAIN_HEAP_SIZE);

    MagnetTrain *train = ApplicationManager_NewData(appMan, sizeof(MagnetTrain), TRAIN_HEAP_ID);
    memset(train, 0, sizeof(MagnetTrain));
    train->args = ApplicationManager_Args(appMan);

    SetBanks();
    train->pipeline = G3DPipeline_Init(TRAIN_HEAP_ID, TEXTURE_VRAM_SIZE_256K, PALETTE_VRAM_SIZE_64K, SetUp3D);
    train->camera = Camera_Alloc(TRAIN_HEAP_ID);
    LoadCuts(train);
    SetCamera(train);

    // The station's song fades as the ride begins (HeartGold's field task fades it with the screen)
    Sound_StopBGM(Sound_GetCurrentBGM(), TRAIN_FADE_STEPS);

    gSystem.whichScreenIs3D = DS_SCREEN_MAIN;
    GXLayers_SwapDisplay();
    GXLayers_TurnBothDispOn();
    StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_IN, FADE_TYPE_BRIGHTNESS_IN, COLOR_BLACK, TRAIN_FADE_STEPS, 1, TRAIN_HEAP_ID);

#ifdef SOVEREIGN_TEST
    memset(gCompleteTestMagnetTrain, 0, sizeof(gCompleteTestMagnetTrain));
    gCompleteTestMagnetTrain[1] = sCutFiles[train->args->way][train->args->night != FALSE][train->args->gender][0].model;
#endif
    return TRUE;
}

BOOL CompleteMagnetTrain_Main(ApplicationManager *appMan, int *state)
{
    MagnetTrain *train = ApplicationManager_Data(appMan);
    TrainCut *cut = &train->cuts[train->cut];

    switch (*state) {
    case TRAIN_STATE_CUT:
        if (CutEnded(cut, train->cut)) {
            if (train->cut + 1 < TRAIN_CUTS) {
                StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_UNK_8, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, TRAIN_FADE_STEPS, 1, TRAIN_HEAP_ID);
            } else {
                StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_OUT, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, TRAIN_FADE_STEPS, 1, TRAIN_HEAP_ID);
            }

            (*state)++;
        }
        break;
    case TRAIN_STATE_FADE_OUT:
        if (IsScreenFadeDone()) {
#ifdef SOVEREIGN_TEST
            gCompleteTestMagnetTrain[0] = train->cut + 1;
#endif
            if (train->cut + 1 >= TRAIN_CUTS) {
#ifdef SOVEREIGN_TEST
                gCompleteTestMagnetTrain[3] = TRUE;
#endif
                return TRUE;
            }

            train->cut++;
            cut = &train->cuts[train->cut];
            SetCamera(train);
            StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_IN, FADE_TYPE_BRIGHTNESS_IN, COLOR_BLACK, TRAIN_FADE_STEPS, 1, TRAIN_HEAP_ID);
            *state = TRAIN_STATE_CUT;
        }
        break;
    }

    // As the last cut begins, the train pulls in to its jingle
    if (train->cut == TRAIN_CUTS - 1 && train->jinglePlayed == FALSE) {
        Sound_SetSceneAndPlayBGM(SOUND_SCENE_FIELD, SEQ_GS_E_LINEAR_sseq, 1);
        train->jinglePlayed = TRUE;
    }

    DrawCut(train);
    train->frames++;
#ifdef SOVEREIGN_TEST
    gCompleteTestMagnetTrain[2] = train->frames;
    gCompleteTestMagnetTrain[4] = train->args->light.lightColors[0];
    gCompleteTestMagnetTrain[5] = train->args->light.diffuseReflectColor;
    gCompleteTestMagnetTrain[6] = (u16)reg_GX_DISPCNT;
    gCompleteTestMagnetTrain[7] = reg_GX_MASTER_BRIGHT;
#endif
    return FALSE;
}

BOOL CompleteMagnetTrain_Exit(ApplicationManager *appMan, int *state)
{
    MagnetTrain *train = ApplicationManager_Data(appMan);

    FreeCuts(train);
    Camera_Delete(train->camera);
    G3DPipelineBuffers_Free(train->pipeline);
    SetVBlankCallback(NULL, NULL);
    DisableHBlank();
    ApplicationManager_FreeData(appMan);
    Heap_Destroy(TRAIN_HEAP_ID);

    return TRUE;
}
