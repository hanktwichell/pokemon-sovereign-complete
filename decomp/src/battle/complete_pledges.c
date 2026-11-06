#include "battle/complete_pledges.h"

#include <nitro.h>

#include "constants/battle.h"
#include "constants/pokemon.h"
#include "generated/moves.h"
#include "generated/pokemon_types.h"

#include "struct_decls/battle_system.h"

#include "battle/battle_context.h"
#include "battle/battle_controller_player.h"
#include "battle/battle_system.h"

// 1 Fire, 2 Water, 3 Grass, 0 another move
static int PledgeIndex(int move)
{
    switch (move) {
    case MOVE_FIRE_PLEDGE:
        return 1;
    case MOVE_WATER_PLEDGE:
        return 2;
    case MOVE_GRASS_PLEDGE:
        return 3;
    default:
        return 0;
    }
}

BOOL CompletePledge_IsPledge(int move)
{
    return PledgeIndex(move) != 0;
}

BOOL CompletePledge_TryWait(BattleSystem *battleSys, BattleContext *battleCtx)
{
    int attacker = battleCtx->attacker;
    int mine = PledgeIndex(battleCtx->moveCur);

    // the ally's Pledge, called up, doesn't wait in turn
    if (mine == 0 || battleCtx->turnFlags[attacker].completePledgeCombo
        || (BattleSystem_GetBattleType(battleSys) & BATTLE_TYPE_DOUBLES) == FALSE) {
        return FALSE;
    }

    int ally = BattleSystem_GetPartner(battleSys, attacker);
    int theirs = PledgeIndex(battleCtx->moveSelected[ally]);

    if (ally == attacker || battleCtx->battleMons[ally].curHP == 0 || theirs == 0 || theirs == mine
        || battleCtx->battlerActions[ally][BATTLE_ACTION_SELECTED_COMMAND] != PLAYER_INPUT_FIGHT) {
        return FALSE;
    }

    // still to act this turn: moved up to act next (as Round calls a Round up), where the dynamic Speed order keeps it
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSys);
    int pos = -1;

    for (int i = battleCtx->turnOrderCounter + 1; i < maxBattlers; i++) {
        if (battleCtx->battlerActionOrder[i] == ally) {
            pos = i;
        }
    }

    if (pos < 0) {
        return FALSE;
    }

    for (int i = pos; i > battleCtx->turnOrderCounter + 1; i--) {
        battleCtx->battlerActionOrder[i] = battleCtx->battlerActionOrder[i - 1];
    }

    battleCtx->battlerActionOrder[battleCtx->turnOrderCounter + 1] = ally;
    battleCtx->turnFlags[ally].sovereignMovedUp = TRUE;
    battleCtx->turnFlags[ally].completePledgeCombo = mine;
    battleCtx->msgBattlerTemp = ally;
    return TRUE;
}

BOOL CompletePledge_IsCombined(BattleContext *battleCtx, int attacker, int move)
{
    int combo = battleCtx->turnFlags[attacker].completePledgeCombo;
    int mine = PledgeIndex(move);

    return combo && mine && combo != mine;
}

// The pair's type: Fire and Grass Fire, Water and Fire Water, Grass and Water Grass
int CompletePledge_CombinedType(BattleContext *battleCtx, int attacker, int move)
{
    int pair = (1 << battleCtx->turnFlags[attacker].completePledgeCombo) | (1 << PledgeIndex(move));

    switch (pair) {
    case (1 << 1) | (1 << 3):
        return TYPE_FIRE;
    case (1 << 1) | (1 << 2):
        return TYPE_WATER;
    default:
        return TYPE_GRASS;
    }
}

int CompletePledge_StartField(BattleSystem *battleSys, BattleContext *battleCtx)
{
    int field;
    int battler;

    switch (CompletePledge_CombinedType(battleCtx, battleCtx->attacker, battleCtx->moveCur)) {
    case TYPE_FIRE:
        field = COMPLETE_PLEDGE_SEA_OF_FIRE;
        battler = battleCtx->defender;
        break;
    case TYPE_WATER:
        field = COMPLETE_PLEDGE_RAINBOW;
        battler = battleCtx->attacker;
        break;
    default:
        field = COMPLETE_PLEDGE_SWAMP;
        battler = battleCtx->defender;
        break;
    }

    int side = BattleSystem_GetBattlerSide(battleSys, battler);

    battleCtx->msgTemp = field;

    if (battleCtx->completePledgeTurns[side][field]) {
        return 0;
    }

    battleCtx->completePledgeTurns[side][field] = COMPLETE_PLEDGE_TURNS;
    return 1;
}

BOOL CompletePledge_FieldOn(BattleSystem *battleSys, BattleContext *battleCtx, int battler, enum CompletePledgeField field)
{
    return battleCtx->completePledgeTurns[BattleSystem_GetBattlerSide(battleSys, battler)][field] != 0;
}

int CompletePledge_RainbowChance(BattleSystem *battleSys, BattleContext *battleCtx, int attacker, int chance)
{
    return CompletePledge_FieldOn(battleSys, battleCtx, attacker, COMPLETE_PLEDGE_RAINBOW) ? chance * 2 : chance;
}

u32 CompletePledge_SwampSpeed(BattleSystem *battleSys, BattleContext *battleCtx, int battler, u32 speed)
{
    return CompletePledge_FieldOn(battleSys, battleCtx, battler, COMPLETE_PLEDGE_SWAMP) ? speed / 4 : speed;
}

void CompletePledge_SwapSides(BattleContext *battleCtx)
{
    for (int i = 0; i < 3; i++) {
        u8 turns = battleCtx->completePledgeTurns[0][i];

        battleCtx->completePledgeTurns[0][i] = battleCtx->completePledgeTurns[1][i];
        battleCtx->completePledgeTurns[1][i] = turns;
    }
}
