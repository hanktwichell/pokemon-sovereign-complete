#ifndef POKEPLATINUM_SCRCMD_MOVE_TUTOR_H
#define POKEPLATINUM_SCRCMD_MOVE_TUTOR_H

#include "field_script_context.h"
#include "pokemon.h"

BOOL ScrCmd_CheckHasSeenSpecies(ScriptContext *ctx);
BOOL ScrCmd_CheckHasLearnableTutorMoves(ScriptContext *ctx);
BOOL ScrCmd_ResetMoveSlot(ScriptContext *ctx);
BOOL ScrCmd_CheckCanAffordMove(ScriptContext *ctx);
BOOL ScrCmd_PayShardCost(ScriptContext *ctx);
BOOL ScrCmd_ShowMoveTutorMoveSelectionMenu(ScriptContext *ctx);
BOOL ScrCmd_ShowShardCost(ScriptContext *ctx);
BOOL ScrCmd_CloseShardCostWindow(ScriptContext *ctx);

// Sovereign Complete: a Pokémon's byte of the tutor moveset mask (its bit i % 8 for sTeachableMoves[i], byte i / 8)
u8 Pokemon_ReadMovesetMaskByte(Pokemon *mon, u8 offset);

#endif // POKEPLATINUM_SCRCMD_MOVE_TUTOR_H
