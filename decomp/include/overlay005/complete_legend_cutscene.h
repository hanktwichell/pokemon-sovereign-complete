#ifndef POKEPLATINUM_OVERLAY005_COMPLETE_LEGEND_CUTSCENE_H
#define POKEPLATINUM_OVERLAY005_COMPLETE_LEGEND_CUTSCENE_H

#include "field_script_context.h"

// Sovereign Complete: HeartGold's legendary cutscenes on the Bell Tower's roof and in the Whirl Islands' cave
// (src/overlay005/complete_legend_cutscene.c). CompleteLegendCutscene op, arg runs one of HeartGold's
// LegendCutscene* commands (the op, in their order); arg is the shimmer's "Clear Bell only", or a camera point.
enum LegendCutsceneOp {
    LEGEND_CUTSCENE_CLEAR_BELL_BEGIN = 0, // LegendCutsceneClearBellAnimBegin
    LEGEND_CUTSCENE_CLEAR_BELL_END, // LegendCutsceneClearBellAnimEnd
    LEGEND_CUTSCENE_CLEAR_BELL_RISE, // LegendCutsceneClearBellRiseFromBag
    LEGEND_CUTSCENE_CLEAR_BELL_SHIMMER, // LegendCutsceneClearBellShimmer
    LEGEND_CUTSCENE_EFFECT_BEGIN, // LegendCutsceneWavesOrLeavesEffectBegin
    LEGEND_CUTSCENE_EFFECT_END, // LegendCutsceneWavesOrLeavesEffectEnd
    LEGEND_CUTSCENE_PAN_CAMERA, // LegendCutscenePanCameraTo
    LEGEND_CUTSCENE_WAIT_CAMERA_PAN, // LegendCutsceneWaitCameraPan
    LEGEND_CUTSCENE_MOVE_CAMERA, // LegendCutsceneMoveCameraTo
    LEGEND_CUTSCENE_BIRD_APPROACH, // LegendCutsceneBirdFinalApproach
    LEGEND_CUTSCENE_LUGIA_EYE, // LegendCutsceneLugiaEyeGlimmerEffect
    LEGEND_CUTSCENE_LUGIA_ARRIVES_BEGIN, // LegendCutsceneLugiaArrivesEffectBegin
    LEGEND_CUTSCENE_LUGIA_ARRIVES_END, // LegendCutsceneLugiaArrivesEffectEnd
    LEGEND_CUTSCENE_LUGIA_ARRIVES_PAN, // LegendCutsceneLugiaArrivesEffectCameraPan
};

BOOL CompleteScrCmd_LegendCutscene(ScriptContext *ctx);

#endif // POKEPLATINUM_OVERLAY005_COMPLETE_LEGEND_CUTSCENE_H
