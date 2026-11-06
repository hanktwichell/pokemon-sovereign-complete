#ifndef POKEPLATINUM_BATTLE_COMPLETE_ALLY_SWITCH_H
#define POKEPLATINUM_BATTLE_COMPLETE_ALLY_SWITCH_H

#include "struct_decls/battle_system.h"

#include "battle/battle_context.h"

// Sovereign Complete: Ally Switch (src/battle/complete_ally_switch.c)
BOOL Complete_CanAllySwitch(BattleSystem *battleSys, BattleContext *battleCtx);
BOOL Complete_AllySwitch(BattleSystem *battleSys, BattleContext *battleCtx);

#endif // POKEPLATINUM_BATTLE_COMPLETE_ALLY_SWITCH_H
