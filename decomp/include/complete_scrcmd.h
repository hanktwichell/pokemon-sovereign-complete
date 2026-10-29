#ifndef POKEPLATINUM_COMPLETE_SCRCMD_H
#define POKEPLATINUM_COMPLETE_SCRCMD_H

#include "field_script_context.h"

// Sovereign Complete: script commands for HeartGold's scripts (src/complete_scrcmd.c).
BOOL CompleteScrCmd_MessageGendered(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerPause(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerWait(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerSetMovementType(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerCheckActive(ScriptContext *ctx);

#endif // POKEPLATINUM_COMPLETE_SCRCMD_H
