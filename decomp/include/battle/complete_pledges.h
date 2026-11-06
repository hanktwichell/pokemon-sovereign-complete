#ifndef POKEPLATINUM_BATTLE_COMPLETE_PLEDGES_H
#define POKEPLATINUM_BATTLE_COMPLETE_PLEDGES_H

#include "struct_decls/battle_system.h"

#include "battle/battle_context.h"

// Sovereign Complete: the Pledges' combinations (the owner's call, Nov 6, 2026; docs/Features.md, "The Pledges"), as in
// Gen VI on. In a double battle, a Pledge user whose ally has chosen a different Pledge and is still to act this turn
// waits for it: the ally acts next, and its Pledge becomes the combined one, 150 power with the user's STAB, its type
// and its field by the pair (Fire and Grass: Fire, a sea of fire on the target's side; Water and Fire: Water, a rainbow
// on the user's side; Grass and Water: Grass, a swamp on the target's side), each for 4 turns.

enum CompletePledgeField {
    COMPLETE_PLEDGE_SEA_OF_FIRE = 0, // its non-Fire Pokemon lose 1/8 of their max HP at the end of each turn
    COMPLETE_PLEDGE_RAINBOW, // its Pokemon's moves' added effects are twice as likely
    COMPLETE_PLEDGE_SWAMP, // its Pokemon's Speed is quartered
};

#define COMPLETE_PLEDGE_TURNS 4

BOOL CompletePledge_IsPledge(int move);
// The attacker waits for its ally's Pledge (and the ally is moved up to act next, its Pledge combined): TRUE when it
// does, and its move goes no further. msgBattlerTemp is the ally then.
BOOL CompletePledge_TryWait(BattleSystem *battleSys, BattleContext *battleCtx);
// Whether this is the combined Pledge, and its type
BOOL CompletePledge_IsCombined(BattleContext *battleCtx, int attacker, int move);
int CompletePledge_CombinedType(BattleContext *battleCtx, int attacker, int move);
// After the combined Pledge's hit: starts its field (msgTemp the field), 1 when it did, 0 when it was up already
int CompletePledge_StartField(BattleSystem *battleSys, BattleContext *battleCtx);
BOOL CompletePledge_FieldOn(BattleSystem *battleSys, BattleContext *battleCtx, int battler, enum CompletePledgeField field);
// An added effect's chance with a rainbow on the attacker's side
int CompletePledge_RainbowChance(BattleSystem *battleSys, BattleContext *battleCtx, int attacker, int chance);
// A Speed in a swamp
u32 CompletePledge_SwampSpeed(BattleSystem *battleSys, BattleContext *battleCtx, int battler, u32 speed);
// Court Change swaps the sides' fields too
void CompletePledge_SwapSides(BattleContext *battleCtx);

#endif // POKEPLATINUM_BATTLE_COMPLETE_PLEDGES_H
