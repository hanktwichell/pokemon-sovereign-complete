#include "applications/complete_legend_cinematic.h"

#include <nitro.h>
#include <string.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "constants/species.h"

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
#include "sys_task.h"
#include "sys_task_extensions.h"
#include "sys_task_manager.h"
#include "system.h"

#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: HeartGold's legendary cinematics (its overlay 106, ScriptCinematic_HoOh and ScriptCinematic_Lugia,
// in assembly there), which its script command Cinematic plays between the field's fades:
// - Ho-Oh: on the Bell Tower's roof, the Clear Bell's sound spreads in rings of light, then Ho-Oh flies in over the
//   tower (two cuts, each a model of HeartGold's with its animations, by time of day), to HeartGold's Ho-Oh theme.
// - Lugia: in the Whirl Islands, Lugia rises from the water beneath the waterfall, cries, and the picture trails as it
//   spreads its wings (the DS's display capture, blending each frame with the last: HeartGold's ov106_021E5E0C, which
//   is Platinum's field motion blur, copied here as the field's overlay is out while an app runs).
// The models are HeartGold's (NARC_INDEX_DEMO__COMPLETE__LEGEND_CINEMATIC, tools/complete/import_hgss_legend_cinematic.py),
// lit by the field's light at the time, as HeartGold has it. HeartGold's sound effects for the scenes are its own:
// Platinum's stand in (docs/Music.md).

#define CINEMATIC_HEAP_ID   HEAP_ID_DISTORTION_WORLD_WARP // the Distortion World warp's: its scene can't run at the same time
#define CINEMATIC_HEAP_SIZE 0x80000 // HeartGold's
#define MAX_MODELS          2
#define MODEL_ANIMS         4
#define NO_ANIM             0xFFFF
#define TIMES_OF_DAY        3
#define LUGIA_FIRST         27 // Lugia's first file in the archive, after Ho-Oh's 27

// HeartGold's own sound effects, and Platinum's that stand in for them
#define SE_BELL_WAVE     SEQ_SE_DP_KIRAN_sseq // SEQ_SE_GS_SUZUNOONPA_APRI: the Clear Bell's sound spreading
#define SE_LIGHT_APPEARS SEQ_SE_DP_KIRAN_sseq // SEQ_SE_GS_HAKKOUTAI_SYUTUGEN: the ring of light appearing
#define SE_LIGHT_SPREADS SEQ_SE_DP_KIRAN_sseq // SEQ_SE_GS_HAKKOUTAI_HIROGARI and _HIROGARI2: the light spreading
#define SE_HO_OH_FLAP    SEQ_SE_DP_FW019_sseq // SEQ_SE_GS_HOUOUHABATAKI_APRI: Ho-Oh's wings, every 64 frames
#define SE_WATERFALL     SEQ_SE_DP_NAMI_sseq // SEQ_SE_GS_TAKI_RUGIADEMO: the waterfall, faded in, all through
#define SE_LUGIA_RISES   SEQ_SE_DP_FW463_sseq // SEQ_SE_GS_RUGIA_TAKISHUTUGEN: Lugia through the falling water

// HeartGold's ScriptCinematic_HoOh steps (sScriptCinematicSubs_HoOh)
enum HoOhStep {
    HO_OH_STEP_START = 0,
    HO_OH_STEP_END,
    HO_OH_STEP_WAIT_FADE,
    HO_OH_STEP_FIRST_CUT,
    HO_OH_STEP_SECOND_CUT_START,
    HO_OH_STEP_SECOND_CUT,
    HO_OH_STEP_DONE,
};

// HeartGold's ScriptCinematic_Lugia steps (sScriptCinematicSubs_Lugia)
enum LugiaStep {
    LUGIA_STEP_START = 0,
    LUGIA_STEP_END,
    LUGIA_STEP_WAIT_FADE,
    LUGIA_STEP_CUT,
    LUGIA_STEP_DONE,
};

typedef struct CinematicModelFiles {
    u16 model;
    u16 anims[MODEL_ANIMS];
    BOOL globalColors; // the model's colors from the field's light instead of its own
} CinematicModelFiles;

// Each cut's camera (HeartGold's ov106_021E6E74, ov106_021E6E9C and ov106_021E6EFC): its distance from its target,
// its angle, its field of view, its target and its clipping planes
typedef struct CinematicCamera {
    fx32 distance;
    CameraAngle angle;
    u16 fovY;
    VecFx32 target;
    fx32 nearClip;
    fx32 farClip;
} CinematicCamera;

typedef struct CinematicModel {
    Easy3DModel model;
    Easy3DAnim anims[MODEL_ANIMS];
    BOOL hasAnim[MODEL_ANIMS];
    Easy3DObject object;
} CinematicModel;

typedef struct CinematicBlur {
    GXVRamLCDC lcdcBank;
    BOOL initialized;
    int blendA;
    int blendB;
    SysTask *task;
} CinematicBlur;

typedef struct LegendCinematic {
    CompleteLegendCinematicArgs *args;
    G3DPipelineBuffers *pipeline;
    Camera *camera;
    VecFx32 cameraTarget;
    NNSFndAllocator allocator;
    CinematicModel models[MAX_MODELS];
    int modelCount;
    int step;
    int afterFade;
    int frames;
    int totalFrames;
    CinematicBlur *blur;
} LegendCinematic;

// HeartGold's ov106_021E6E50 and ov106_021E6E2C: Ho-Oh's two cuts by time of day
static const CinematicModelFiles sHoOhFirstCut[TIMES_OF_DAY] = {
    { 0, { 1, 2, 3, 4 }, FALSE },
    { 5, { 6, 7, 8, 9 }, FALSE },
    { 10, { 11, 12, 13, 14 }, FALSE },
};

static const CinematicModelFiles sHoOhSecondCut[TIMES_OF_DAY] = {
    { 15, { 16, 17, 18, NO_ANIM }, FALSE },
    { 19, { 20, 21, 22, NO_ANIM }, FALSE },
    { 23, { 24, 25, 26, NO_ANIM }, FALSE },
};

// HeartGold's ov106_021E6EE4: Lugia, and the waterfall, which takes its colors from the field's light
static const CinematicModelFiles sLugiaCut[MAX_MODELS] = {
    { LUGIA_FIRST + 0, { LUGIA_FIRST + 1, LUGIA_FIRST + 2, LUGIA_FIRST + 3, LUGIA_FIRST + 4 }, FALSE },
    { LUGIA_FIRST + 5, { LUGIA_FIRST + 6, NO_ANIM, NO_ANIM, NO_ANIM }, TRUE },
};

static const CinematicCamera sHoOhFirstCamera = {
    0x004B4152, { 0x0C80, 0xD8E0, 0, 0 }, 0x0881, { 0x0025A7F4, 0x0024282F, (fx32)0xFFDA317D }, 0x00009000, 0x006A4000
};

static const CinematicCamera sHoOhSecondCamera = {
    0x001BA152, { 0xECA2, 0x8380, 0, 0 }, 0x0381, { (fx32)0xFFFED809, (fx32)0xFFFDF1FC, 0x0003AF93 }, 0x00096000, 0x006A4000
};

static const CinematicCamera sLugiaCamera = {
    0x00153B51, { 0x0982, 0x1E20, 0, 0 }, 0x0A01, { 0x00004DEC, 0x000803CD, 0x0002B2F5 }, 0x0007B000, 0x006A4000
};

// HeartGold's edge marking colors for the models' outlines (ov106_021E6E04, ov106_021E6EC4)
static const GXRgb sHoOhEdgeColors[8] = { 0, 0x1084, 0x1084, 0x1084, 0x1084, 0x1084, 0x1084, 0x1084 };
static const GXRgb sLugiaEdgeColors[8] = { 0, 0x7A89, 0x1084, 0x1084, 0x1084, 0x1084, 0x1084, 0x1084 };

// HeartGold's GF3dRender_InitSimpleManager's setup
static void SetUp3D(void)
{
    GXLayers_EngineAToggleLayers(GX_PLANEMASK_BG0, TRUE);
    G2_SetBG0Priority(1);
    G3X_SetShading(GX_SHADING_TOON);
    G3X_AntiAlias(TRUE);
    G3X_AlphaTest(FALSE, 0);
    G3X_AlphaBlend(TRUE);
    G3X_EdgeMarking(FALSE);
    G3X_SetFog(FALSE, GX_FOGBLEND_COLOR_ALPHA, GX_FOGSLOPE_0x8000, 0);
    G3X_SetClearColor(GX_RGB(0, 0, 0), 0, 0x7FFF, 63, FALSE);
    G3_ViewPort(0, 0, 255, 191);
}

// HeartGold's ov106_021E6DB0
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

// HeartGold's ov106_021E5A44 and the light half of ov106_021E5D70
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

// HeartGold's ov106_021E5A74: the models' outlines in these colors
static void SetEdgeColors(const GXRgb *colors)
{
    G3X_EdgeMarking(TRUE);
    G3X_SetEdgeColorTable(colors);
}

// HeartGold's ov106_021E59FC
static void SetCamera(LegendCinematic *cin, const CinematicCamera *cam)
{
    cin->cameraTarget = cam->target;
    Camera_InitWithTarget(&cin->cameraTarget, cam->distance, &cam->angle, cam->fovY, CAMERA_PROJECTION_PERSPECTIVE, TRUE, cin->camera);
    Camera_SetClipping(cam->nearClip, cam->farClip, cin->camera);
    Camera_SetAsActive(cin->camera);
}

// HeartGold's ov106_021E5AA8: each model and its animations, from the start
static void LoadModels(LegendCinematic *cin, const CinematicModelFiles *files, int count)
{
    NARC *narc = NARC_ctor(NARC_INDEX_DEMO__COMPLETE__LEGEND_CINEMATIC, CINEMATIC_HEAP_ID);

    HeapExp_FndInitAllocator(&cin->allocator, CINEMATIC_HEAP_ID, 4);

    for (int i = 0; i < count; i++) {
        CinematicModel *model = &cin->models[i];

        Easy3DModel_LoadFrom(&model->model, narc, files[i].model, CINEMATIC_HEAP_ID);

        if (files[i].globalColors) {
            NNS_G3dMdlUseGlbDiff(model->model.model);
            NNS_G3dMdlUseGlbAmb(model->model.model);
            NNS_G3dMdlUseGlbSpec(model->model.model);
            NNS_G3dMdlUseGlbEmi(model->model.model);
        }

        Easy3DObject_Init(&model->object, &model->model);

        for (int j = 0; j < MODEL_ANIMS; j++) {
            model->hasAnim[j] = files[i].anims[j] != NO_ANIM;

            if (model->hasAnim[j]) {
                Easy3DAnim_LoadFrom(&model->anims[j], &model->model, narc, files[i].anims[j], CINEMATIC_HEAP_ID, &cin->allocator);
                Easy3DAnim_SetFrame(&model->anims[j], 0);
                Easy3DObject_AddAnim(&model->object, &model->anims[j]);
            }
        }
    }

    cin->modelCount = count;
    NARC_dtor(narc);
}

// HeartGold's ov106_021E5BBC
static void FreeModels(LegendCinematic *cin)
{
    for (int i = 0; i < cin->modelCount; i++) {
        for (int j = 0; j < MODEL_ANIMS; j++) {
            if (cin->models[i].hasAnim[j]) {
                Easy3DAnim_Release(&cin->models[i].anims[j], &cin->allocator);
            }
        }

        Easy3DModel_Release(&cin->models[i].model);
    }

    memset(cin->models, 0, sizeof(cin->models));
    cin->modelCount = 0;
}

// HeartGold's ov106_021E5D08: whether any animation has frames left
static BOOL AnimsRunning(LegendCinematic *cin)
{
    for (int i = 0; i < cin->modelCount; i++) {
        for (int j = 0; j < MODEL_ANIMS; j++) {
            if (cin->models[i].hasAnim[j]
                && Easy3DAnim_GetFrame(&cin->models[i].anims[j]) + FX32_ONE < Easy3DAnim_GetFrameCount(&cin->models[i].anims[j])) {
                return TRUE;
            }
        }
    }

    return FALSE;
}

// HeartGold's ov106_021E5C30: each animation a frame on (each stops on its last), and the models drawn
static void Draw(LegendCinematic *cin)
{
    for (int i = 0; i < cin->modelCount; i++) {
        for (int j = 0; j < MODEL_ANIMS; j++) {
            if (cin->models[i].hasAnim[j]) {
                fx32 next = Easy3DAnim_GetFrame(&cin->models[i].anims[j]) + FX32_ONE;

                if (next < Easy3DAnim_GetFrameCount(&cin->models[i].anims[j])) {
                    Easy3DAnim_SetFrame(&cin->models[i].anims[j], next);
                }
            }
        }
    }

    G3_ResetG3X();
    Camera_ComputeProjectionMatrix(CAMERA_PROJECTION_PERSPECTIVE, cin->camera);
    Camera_ComputeViewMatrix();
    SetLight(&cin->args->light);

    for (int i = 0; i < cin->modelCount; i++) {
        Easy3DObject_Draw(&cin->models[i].object);
    }

    G3_RequestSwapBuffers(GX_SORTMODE_AUTO, GX_BUFFERMODE_Z);
}

// HeartGold's ov106_021E5954 to ov106_021E59D0: a fade in from or out to black or white over 6 frames, and the step
// after it
static void Fade(LegendCinematic *cin, enum FadeType type, u16 color, int steps, int afterFade)
{
    StartScreenFade(FADE_BOTH_SCREENS, type, type, color, steps, 1, CINEMATIC_HEAP_ID);
    cin->afterFade = afterFade;
}

// HeartGold's ov106_021E5E0C and its two tasks (Platinum's MotionBlur_New): from the next VBlank the main screen shows
// VRAM C, where each frame's picture is captured, blended with what was there
static void Blur_SetCapture(SysTask *task, void *param)
{
    CinematicBlur *blur = param;

    if (blur->initialized) {
        GX_SetCapture(GX_CAPTURE_SIZE_256x192, GX_CAPTURE_MODE_AB, GX_CAPTURE_SRCA_2D3D, GX_CAPTURE_SRCB_VRAM_0x00000, GX_CAPTURE_DEST_VRAM_C_0x00000, blur->blendA, blur->blendB);
    }
}

static void Blur_VBlankInit(SysTask *task, void *param)
{
    CinematicBlur *blur = param;

    GX_SetBankForLCDC(GX_VRAM_LCDC_C);
    GX_SetGraphicsMode(GX_DISPMODE_VRAM_C, GX_BGMODE_0, GX_BG0_AS_3D);
    blur->initialized = TRUE;
    SysTask_Done(task);
}

static CinematicBlur *Blur_New(int blendA, int blendB)
{
    GXLayers_EngineAToggleLayers(GX_PLANEMASK_BG1 | GX_PLANEMASK_BG2 | GX_PLANEMASK_BG3, FALSE);
    GX_ResetBankForBG();

    SysTask *task = SysTask_StartAndAllocateParam(Blur_SetCapture, sizeof(CinematicBlur), 5, CINEMATIC_HEAP_ID);
    CinematicBlur *blur = SysTask_GetParam(task);

    blur->task = task;
    blur->initialized = FALSE;
    blur->blendA = blendA;
    blur->blendB = blendB;
    blur->lcdcBank = GX_GetBankForLCDC();

    MI_CpuClearFast((void *)HW_LCDC_VRAM_C, HW_VRAM_C_SIZE);
    GX_SetCapture(GX_CAPTURE_SIZE_256x192, GX_CAPTURE_MODE_AB, GX_CAPTURE_SRCA_2D3D, GX_CAPTURE_SRCB_VRAM_0x00000, GX_CAPTURE_DEST_VRAM_C_0x00000, 16, 0);
    SysTask_ExecuteAfterVBlank(Blur_VBlankInit, blur, 0);

    return blur;
}

// HeartGold's ov106_021E6064 (Platinum's MotionBlur_Delete): the main screen back to its layers, VRAM C back to them
static void Blur_Delete(CinematicBlur **blur)
{
    GX_SetGraphicsMode(GX_DISPMODE_GRAPHICS, GX_BGMODE_0, GX_BG0_AS_3D);
    GX_SetBankForLCDC((*blur)->lcdcBank);
    MI_CpuClearFast((void *)HW_LCDC_VRAM_C, HW_VRAM_C_SIZE);
    SysTask_FinishAndFreeParam((*blur)->task);
    *blur = NULL;

    GX_SetBankForBG(GX_VRAM_BG_128_C);
}

// HeartGold's ov106_021E5900: the screens off, the 3D on, the light, and the camera
static void Begin(LegendCinematic *cin, const CinematicCamera *cam, const GXRgb *edgeColors)
{
    SetLight(&cin->args->light);
    SetEdgeColors(edgeColors);
    SetCamera(cin, cam);
}

// HeartGold's ScriptCinematic_HoOh's steps (ov106_021E60B0 to ov106_021E61F8)
static int HoOh_Step(LegendCinematic *cin)
{
    int timeOfDay = cin->args->timeOfDay < TIMES_OF_DAY ? cin->args->timeOfDay : 0;

    switch (cin->step) {
    case HO_OH_STEP_START:
        Begin(cin, &sHoOhFirstCamera, sHoOhEdgeColors);
        LoadModels(cin, &sHoOhFirstCut[timeOfDay], 1);
        Fade(cin, FADE_TYPE_BRIGHTNESS_IN, COLOR_WHITE, 6, HO_OH_STEP_FIRST_CUT);
        return HO_OH_STEP_WAIT_FADE;
    case HO_OH_STEP_END:
        FreeModels(cin);
        return HO_OH_STEP_DONE;
    case HO_OH_STEP_WAIT_FADE:
        return IsScreenFadeDone() ? cin->afterFade : HO_OH_STEP_WAIT_FADE;
    case HO_OH_STEP_FIRST_CUT:
        if (!AnimsRunning(cin) && IsScreenFadeDone()) {
            cin->frames = 0;
            return HO_OH_STEP_SECOND_CUT_START;
        }

        switch (cin->frames) {
        case 0:
            Sound_PlayEffect(SE_BELL_WAVE);
            break;
        case 40:
            Sound_PlayEffect(SE_LIGHT_APPEARS);
            break;
        case 78:
            Sound_SetSceneAndPlayBGM(SOUND_SCENE_FIELD, SEQ_GS_E_HOUOU_sseq, 1);
            Sound_PlayEffect(SE_LIGHT_SPREADS);
            break;
        case 98:
            Sound_PlayEffect(SE_LIGHT_SPREADS);
            break;
        case 129:
            Fade(cin, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, 6, HO_OH_STEP_FIRST_CUT);
            break;
        }

        cin->frames++;
        return HO_OH_STEP_FIRST_CUT;
    case HO_OH_STEP_SECOND_CUT_START:
        FreeModels(cin);
        SetCamera(cin, &sHoOhSecondCamera);
        LoadModels(cin, &sHoOhSecondCut[timeOfDay], 1);
        Fade(cin, FADE_TYPE_BRIGHTNESS_IN, COLOR_BLACK, 6, HO_OH_STEP_SECOND_CUT);
        return HO_OH_STEP_WAIT_FADE;
    case HO_OH_STEP_SECOND_CUT:
        if (!AnimsRunning(cin) && IsScreenFadeDone()) {
            cin->frames = 0;
            return HO_OH_STEP_END;
        }

        if ((cin->frames & 63) == 0) {
            Sound_PlayEffect(SE_HO_OH_FLAP);
        }

        if (cin->frames == 190) {
            Fade(cin, FADE_TYPE_BRIGHTNESS_OUT, COLOR_WHITE, 10, HO_OH_STEP_END);
        }

        cin->frames++;
        return HO_OH_STEP_SECOND_CUT;
    }

    return HO_OH_STEP_DONE;
}

// HeartGold's ScriptCinematic_Lugia's steps (ov106_021E6280 to ov106_021E62F4)
static int Lugia_Step(LegendCinematic *cin)
{
    switch (cin->step) {
    case LUGIA_STEP_START:
        Begin(cin, &sLugiaCamera, sLugiaEdgeColors);
        LoadModels(cin, sLugiaCut, MAX_MODELS);
        Fade(cin, FADE_TYPE_BRIGHTNESS_IN, COLOR_BLACK, 6, LUGIA_STEP_CUT);
        return LUGIA_STEP_WAIT_FADE;
    case LUGIA_STEP_END:
        FreeModels(cin);
        return LUGIA_STEP_DONE;
    case LUGIA_STEP_WAIT_FADE:
        return IsScreenFadeDone() ? cin->afterFade : LUGIA_STEP_WAIT_FADE;
    case LUGIA_STEP_CUT:
        if (!AnimsRunning(cin) && IsScreenFadeDone()) {
            cin->frames = 0;
            Sound_StopEffect(SE_WATERFALL, 0);

            if (cin->blur != NULL) {
                Blur_Delete(&cin->blur);
            }

            return LUGIA_STEP_END;
        }

        switch (cin->frames) {
        case 0:
            Sound_PlayEffect(SE_WATERFALL);
            break;
        case 115:
            Sound_PlayEffect(SE_LUGIA_RISES);
            break;
        case 145:
            Sound_PlayPokemonCry(SPECIES_LUGIA, 0);
            cin->blur = Blur_New(5, 13);
            break;
        case 232:
            Fade(cin, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, 6, LUGIA_STEP_END);
            break;
        }

        cin->frames++;
        return LUGIA_STEP_CUT;
    }

    return LUGIA_STEP_DONE;
}

BOOL CompleteLegendCinematic_Init(ApplicationManager *appMan, int *state)
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

    Heap_Create(HEAP_ID_APPLICATION, CINEMATIC_HEAP_ID, CINEMATIC_HEAP_SIZE);

    LegendCinematic *cin = ApplicationManager_NewData(appMan, sizeof(LegendCinematic), CINEMATIC_HEAP_ID);
    memset(cin, 0, sizeof(LegendCinematic));
    cin->args = ApplicationManager_Args(appMan);

    SetBanks();
    cin->pipeline = G3DPipeline_Init(CINEMATIC_HEAP_ID, TEXTURE_VRAM_SIZE_256K, PALETTE_VRAM_SIZE_64K, SetUp3D);
    cin->camera = Camera_Alloc(CINEMATIC_HEAP_ID);

    gSystem.whichScreenIs3D = DS_SCREEN_MAIN;
    GXLayers_SwapDisplay();
    GXLayers_TurnBothDispOn();

#ifdef SOVEREIGN_TEST
    memset(gCompleteTestLegendCinematic, 0, sizeof(gCompleteTestLegendCinematic));
    gCompleteTestLegendCinematic[0] = 0x100 + cin->args->cinematic;
#endif
    return TRUE;
}

BOOL CompleteLegendCinematic_Main(ApplicationManager *appMan, int *state)
{
    LegendCinematic *cin = ApplicationManager_Data(appMan);
    int done;

    if (cin->args->cinematic == COMPLETE_LEGEND_CINEMATIC_LUGIA) {
        cin->step = Lugia_Step(cin);
        done = cin->step == LUGIA_STEP_DONE;
    } else {
        cin->step = HoOh_Step(cin);
        done = cin->step == HO_OH_STEP_DONE;
    }

#ifdef SOVEREIGN_TEST
    gCompleteTestLegendCinematic[1] = cin->step;
    gCompleteTestLegendCinematic[2] = cin->totalFrames;
    gCompleteTestLegendCinematic[3] = cin->modelCount;
    gCompleteTestLegendCinematic[4] = cin->blur != NULL;
    gCompleteTestLegendCinematic[5] = (u16)reg_GX_DISPCNT;
    gCompleteTestLegendCinematic[6] = reg_GX_MASTER_BRIGHT;
    gCompleteTestLegendCinematic[7] = done;
#endif

    if (done) {
        return TRUE;
    }

    Draw(cin);
    cin->totalFrames++;
    return FALSE;
}

BOOL CompleteLegendCinematic_Exit(ApplicationManager *appMan, int *state)
{
    LegendCinematic *cin = ApplicationManager_Data(appMan);

    if (cin->blur != NULL) {
        Blur_Delete(&cin->blur);
    }

    FreeModels(cin);
    Camera_Delete(cin->camera);
    G3DPipelineBuffers_Free(cin->pipeline);
    SetVBlankCallback(NULL, NULL);
    DisableHBlank();
    ApplicationManager_FreeData(appMan);
    Heap_Destroy(CINEMATIC_HEAP_ID);

    return TRUE;
}
