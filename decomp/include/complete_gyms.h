#ifndef POKEPLATINUM_COMPLETE_GYMS_H
#define POKEPLATINUM_COMPLETE_GYMS_H

#include "field/field_system_decl.h"
#include "field_script_context.h"

// Sovereign Complete: HeartGold's gym puzzles (its src/field/gymmick/*.c and src/gymmick_init.c), on Platinum's
// dynamic map features (src/dynamic_map_features.c): a gym's init script stores its puzzle's state with the feature's
// ID (persisted map features, the same 32 bytes as HeartGold's gymmick), and the map's loading runs its Init and Free.
// docs/ScriptConversion.md.

void CompleteVermilionGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem);
void CompleteVermilionGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem);

BOOL CompleteScrCmd_VermilionGymInit(ScriptContext *ctx);
BOOL CompleteScrCmd_VermilionGymCanCheck(ScriptContext *ctx);
BOOL CompleteScrCmd_VermilionGymLockAction(ScriptContext *ctx);
BOOL CompleteScrCmd_VermilionGymResampleCans(ScriptContext *ctx);

void CompleteVioletGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem);
void CompleteVioletGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem);

BOOL CompleteScrCmd_VioletGymInit(ScriptContext *ctx);
BOOL CompleteScrCmd_VioletGymLift(ScriptContext *ctx);

void CompleteCianwoodGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem);
void CompleteCianwoodGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem);

BOOL CompleteScrCmd_CianwoodGymInit(ScriptContext *ctx);
BOOL CompleteScrCmd_CianwoodGymTurnWinch(ScriptContext *ctx);

void CompleteAzaleaGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem);
void CompleteAzaleaGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem);

BOOL CompleteScrCmd_AzaleaGymInit(ScriptContext *ctx);
BOOL CompleteScrCmd_AzaleaGymRide(ScriptContext *ctx);
BOOL CompleteScrCmd_AzaleaGymSwitch(ScriptContext *ctx);

void CompleteBlackthornGym_DynamicMapFeaturesInit(FieldSystem *fieldSystem);
void CompleteBlackthornGym_DynamicMapFeaturesFree(FieldSystem *fieldSystem);
BOOL CompleteBlackthornGym_DynamicMapFeaturesCheckCollision(FieldSystem *fieldSystem, const int tileX, const int tileZ, const fx32 height, BOOL *isColliding);
BOOL CompleteBlackthornGym_CheckButton(FieldSystem *fieldSystem);

BOOL CompleteScrCmd_BlackthornGymInit(ScriptContext *ctx);

#endif // POKEPLATINUM_COMPLETE_GYMS_H
