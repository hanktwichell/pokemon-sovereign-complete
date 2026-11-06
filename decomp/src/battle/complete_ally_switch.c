#include "battle/complete_ally_switch.h"

#include <nitro.h>
#include <string.h>

#include "constants/battle.h"
#include "constants/battle/condition.h"
#include "constants/battle/moves.h"
#include "constants/pokemon.h"
#include "generated/moves.h"

#include "struct_decls/battle_system.h"

#include "battle/battle_context.h"
#include "battle/battle_system.h"
#include "flags.h"

// Sovereign Complete: Ally Switch (the owner asked, Nov 5, 2026). In a double battle the user and its ally trade
// places: each Pokémon takes all that's its own (stats, statuses, volatile effects, substitute, its move history, its
// chosen action this turn) to the other position, and every record of a battler that means a Pokémon follows it there.
// What belongs to a position stays (Wish, Future Sight, a Healing Wish waiting in the slot), and so do the foes'
// chosen targets, so a move aimed at a position hits whoever stands there now, as from Gen V on.
// subscript_complete_ally_switch reads BTLVAR_COMPLETE_ALLY_SWITCH_CHECK, then BTLVAR_COMPLETE_ALLY_SWITCH, and
// redraws both positions.

static void SwapBytes(void *x, void *y, int size)
{
    u8 *p = x, *q = y;

    for (int i = 0; i < size; i++) {
        u8 t = p[i];
        p[i] = q[i];
        q[i] = t;
    }
}

#define SWAP_AT(field) SwapBytes(&battleCtx->field[a], &battleCtx->field[b], sizeof(battleCtx->field[a]))

// A battler stored as itself
static int Remap(int value, int a, int b)
{
    return value == a ? b : value == b ? a : value;
}

// A battler stored as 1 + itself (0 for none)
static int RemapPlusOne(int value, int a, int b)
{
    return value == 0 ? 0 : 1 + Remap(value - 1, a, b);
}

// Battlers stored as flags (FlagIndex), shifted
static u32 SwapFlags(u32 mask, int a, int b, int shift)
{
    u32 fa = FlagIndex(a) << shift, fb = FlagIndex(b) << shift;
    u32 out = mask & ~(fa | fb);

    if (mask & fa) {
        out |= fb;
    }
    if (mask & fb) {
        out |= fa;
    }
    return out;
}

// One party slot's bit, moved from one battler's record to the other's (records kept by battler, by party slot)
static void SwapSlotBit(u8 *rowA, u8 *rowB, int slot)
{
    u8 bit = 1 << slot;
    u8 inA = *rowA & bit, inB = *rowB & bit;

    *rowA = (*rowA & ~bit) | inB;
    *rowB = (*rowB & ~bit) | inA;
}

static BOOL OutOfReach(BattleContext *battleCtx, int battler)
{
    if (battleCtx->battleMons[battler].moveEffectsMask & MOVE_EFFECT_SEMI_INVULNERABLE) {
        return TRUE; // flying, digging, diving or vanished (Shadow Force) for its move's second turn
    }
    if ((battleCtx->sovereignCommanding | battleCtx->sovereignCommanded) & FlagIndex(battler)) {
        return TRUE; // a Tatsugiri inside its Dondozo, or the Dondozo
    }
    for (int i = 0; i < MAX_BATTLERS; i++) {
        if (battleCtx->sovereignSkyDropTarget[i] == battler + 1 || battleCtx->sovereignSkyDropHolder[i] == battler + 1) {
            return TRUE; // carrying or carried by Sky Drop
        }
    }
    return FALSE;
}

BOOL Complete_CanAllySwitch(BattleSystem *battleSys, BattleContext *battleCtx)
{
    int a = battleCtx->attacker, b = a ^ 2;
    u32 type = BattleSystem_GetBattleType(battleSys);

    battleCtx->sideEffectMon = b;

    if ((type & BATTLE_TYPE_DOUBLES) == FALSE || (type & (BATTLE_TYPE_2vs2 | BATTLE_TYPE_TAG))) {
        return FALSE; // not a double battle, or each position is another trainer's (as in the games)
    }
    if (battleCtx->selectedPartySlot[b] >= MAX_PARTY_SIZE || battleCtx->battleMons[b].curHP == 0) {
        return FALSE;
    }
    return !OutOfReach(battleCtx, a) && !OutOfReach(battleCtx, b);
}

BOOL Complete_AllySwitch(BattleSystem *battleSys, BattleContext *battleCtx)
{
    int a = battleCtx->attacker, b = a ^ 2;
    int slotA = battleCtx->selectedPartySlot[a], slotB = battleCtx->selectedPartySlot[b];
    int side = a & 1;
    int i, j;

    if (Complete_CanAllySwitch(battleSys, battleCtx) == FALSE) {
        return FALSE;
    }

    // The Pokémon, its party slot and the party's order (the left one first)
    SWAP_AT(battleMons);
    SWAP_AT(selectedPartySlot);
    SwapBytes(&battleCtx->partyOrder[side][0], &battleCtx->partyOrder[side][1], 1);

    // This turn: its chosen action, its turn flags, its speed tie roll; the turn's order follows the Pokémon
    SWAP_AT(battlerActions);
    SWAP_AT(turnFlags);
    SWAP_AT(selfTurnFlags);
    SWAP_AT(moveFailFlags);
    SWAP_AT(speedRand);
    SWAP_AT(clearVolatileStatus);
    for (i = 0; i < MAX_BATTLERS; i++) {
        battleCtx->battlerActionOrder[i] = Remap(battleCtx->battlerActionOrder[i], a, b);
        battleCtx->monSpeedOrder[i] = Remap(battleCtx->monSpeedOrder[i], a, b);
    }

    // Its move history
    SWAP_AT(moveLockedInto);
    SWAP_AT(moveProtect);
    SWAP_AT(moveHit);
    SWAP_AT(moveHitBattler);
    SWAP_AT(moveHitType);
    SWAP_AT(movePrevByBattler);
    SWAP_AT(moveCopied);
    SWAP_AT(moveCopiedHit);
    SWAP_AT(moveSketched);
    SWAP_AT(moveSelected);
    SWAP_AT(moveSlot);
    SWAP_AT(conversion2Move);
    SWAP_AT(conversion2Battler);
    SWAP_AT(conversion2Type);
    SWAP_AT(metronomeMove);
    SWAP_AT(storedDamage);
    SWAP_AT(lastHitByBattler);
    SWAP_AT(recycleItem);

    // What the AI has seen of it
    SWAP_AT(aiContext.battlerMoves);
    SWAP_AT(aiContext.battlerAbilities);
    SWAP_AT(aiContext.battlerHeldItems);

    // Sovereign's records of each Pokémon
    SWAP_AT(sovereignMirrorHerbRises);
    SWAP_AT(sovereignLastMoveUsed);
    SWAP_AT(sovereignLastMoveFailed);
    SWAP_AT(sovereignLaserFocus);
    SWAP_AT(sovereignThroatChop);
    SWAP_AT(sovereignSmackedDown);
    SWAP_AT(sovereignHPBeforeHit);
    SWAP_AT(sovereignHPBeforeAction);
    SWAP_AT(sovereignHPBeforeTurnEnd);
    SWAP_AT(sovereignHPOnEntry);
    SWAP_AT(sovereignDragonCheer);
    SWAP_AT(sovereignCudChewBerry);
    SWAP_AT(sovereignCudChewTurn);
    SWAP_AT(sovereignTelekinesis);
    SWAP_AT(sovereignSyrupBomb);
    SWAP_AT(sovereignSyrupBombSource);
    SWAP_AT(sovereignSyrupBombSourceSlot);
    SWAP_AT(sovereignOctolock);
    SWAP_AT(sovereignOctolockSource);
    SWAP_AT(sovereignOctolockSourceSlot);
    SWAP_AT(sovereignIllusion);
    SWAP_AT(sovereignOrderUpStat);
    SWAP_AT(sovereignShieldMove);
    SWAP_AT(sovereignSkyDropTarget);
    SWAP_AT(sovereignSkyDropHolder);

    // Records kept by battler and party slot: the two Pokémon's entries change rows
    SwapSlotBit(&battleCtx->sovereignOncePerBattle[a], &battleCtx->sovereignOncePerBattle[b], slotA);
    SwapSlotBit(&battleCtx->sovereignOncePerBattle[a], &battleCtx->sovereignOncePerBattle[b], slotB);
    SwapSlotBit(&battleCtx->sovereignAteBerry[a], &battleCtx->sovereignAteBerry[b], slotA);
    SwapSlotBit(&battleCtx->sovereignAteBerry[a], &battleCtx->sovereignAteBerry[b], slotB);
    SwapBytes(&battleCtx->sovereignTimesHit[a][slotA], &battleCtx->sovereignTimesHit[b][slotA], 1);
    SwapBytes(&battleCtx->sovereignTimesHit[a][slotB], &battleCtx->sovereignTimesHit[b][slotB], 1);

    // The Exp. record is kept by the foe's position: a foe's pair trades it
    if (a & 1) {
        SwapBytes(&battleCtx->sideGetExpMask[0], &battleCtx->sideGetExpMask[1], sizeof(battleCtx->sideGetExpMask[0]));
    }

    // Battler flags
    battleCtx->fieldConditionsMask = SwapFlags(battleCtx->fieldConditionsMask, a, b, FIELD_CONDITION_UPROAR_SHIFT);
    battleCtx->battlersSwitchingMask = SwapFlags(battleCtx->battlersSwitchingMask, a, b, 0);
    battleCtx->sovereignMegaPending = SwapFlags(battleCtx->sovereignMegaPending, a, b, 0);
    battleCtx->sovereignDefiantPending = SwapFlags(battleCtx->sovereignDefiantPending, a, b, 0);
    battleCtx->sovereignAdrenalinePending = SwapFlags(battleCtx->sovereignAdrenalinePending, a, b, 0);
    battleCtx->sovereignEjectPackPending = SwapFlags(battleCtx->sovereignEjectPackPending, a, b, 0);
    battleCtx->sovereignQuickDraw = SwapFlags(battleCtx->sovereignQuickDraw, a, b, 0);
    battleCtx->sovereignSoulHeartDone = SwapFlags(battleCtx->sovereignSoulHeartDone, a, b, 0);
    battleCtx->sovereignGlaiveRush = SwapFlags(battleCtx->sovereignGlaiveRush, a, b, 0);
    battleCtx->sovereignSaltCure = SwapFlags(battleCtx->sovereignSaltCure, a, b, 0);
    battleCtx->sovereignTarShot = SwapFlags(battleCtx->sovereignTarShot, a, b, 0);
    battleCtx->sovereignDancers = SwapFlags(battleCtx->sovereignDancers, a, b, 0);

    // Every record naming one of the two now names where it stands
    for (i = 0; i < MAX_BATTLERS; i++) {
        BattleMon *mon = &battleCtx->battleMons[i];

        mon->statusVolatile = (mon->statusVolatile & ~VOLATILE_CONDITION_ATTRACT)
            | SwapFlags(mon->statusVolatile & VOLATILE_CONDITION_ATTRACT, a, b, VOLATILE_CONDITION_ATTRACT_SHIFT);
        mon->moveEffectsData.lockOnTarget = Remap(mon->moveEffectsData.lockOnTarget, a, b);
        mon->moveEffectsData.bindTarget = Remap(mon->moveEffectsData.bindTarget, a, b);
        mon->moveEffectsData.meanLookTarget = Remap(mon->moveEffectsData.meanLookTarget, a, b);

        if (battleCtx->moveHitBattler[i] != BATTLER_NONE) {
            battleCtx->moveHitBattler[i] = Remap(battleCtx->moveHitBattler[i], a, b);
        }
        if (battleCtx->conversion2Move[i] != MOVE_NONE) {
            battleCtx->conversion2Battler[i] = Remap(battleCtx->conversion2Battler[i], a, b);
        }
        battleCtx->lastHitByBattler[i] = Remap(battleCtx->lastHitByBattler[i], a, b);
        SwapBytes(&battleCtx->moveCopiedHit[i][a], &battleCtx->moveCopiedHit[i][b], sizeof(battleCtx->moveCopiedHit[i][a]));

        TurnFlags *flags = &battleCtx->turnFlags[i];

        SwapBytes(&flags->physicalDamageTakenFrom[a], &flags->physicalDamageTakenFrom[b], sizeof(int));
        SwapBytes(&flags->specialDamageTakenFrom[a], &flags->specialDamageTakenFrom[b], sizeof(int));
        flags->physicalDamageLastAttacker = Remap(flags->physicalDamageLastAttacker, a, b);
        flags->specialDamageLastAttacker = Remap(flags->specialDamageLastAttacker, a, b);
        flags->physicalDamageAttackerMask = SwapFlags(flags->physicalDamageAttackerMask, a, b, 0);
        flags->specialDamageAttackerMask = SwapFlags(flags->specialDamageAttackerMask, a, b, 0);
        flags->lastAttacker = Remap(flags->lastAttacker, a, b);
        flags->assuranceDamageMask = SwapFlags(flags->assuranceDamageMask, a, b, 0);

        if (battleCtx->sovereignSyrupBomb[i]) {
            battleCtx->sovereignSyrupBombSource[i] = Remap(battleCtx->sovereignSyrupBombSource[i], a, b);
        }
        if (battleCtx->sovereignOctolock[i]) {
            battleCtx->sovereignOctolockSource[i] = Remap(battleCtx->sovereignOctolockSource[i], a, b);
        }
        battleCtx->sovereignSkyDropTarget[i] = RemapPlusOne(battleCtx->sovereignSkyDropTarget[i], a, b);
        battleCtx->sovereignSkyDropHolder[i] = RemapPlusOne(battleCtx->sovereignSkyDropHolder[i], a, b);
    }

    for (i = 0; i < NUM_BATTLE_SIDES; i++) {
        if (battleCtx->sideConditions[i].followMe) {
            battleCtx->sideConditions[i].followMeUser = Remap(battleCtx->sideConditions[i].followMeUser, a, b);
        }
    }

    for (j = 0; j < 2; j++) {
        battleCtx->sovereignDartsTargets[j] = Remap(battleCtx->sovereignDartsTargets[j], a, b);
    }
    battleCtx->sovereignMoveFormBattler = RemapPlusOne(battleCtx->sovereignMoveFormBattler, a, b);
    battleCtx->sovereignGemBoost = RemapPlusOne(battleCtx->sovereignGemBoost, a, b);
    battleCtx->sovereignInstructed = RemapPlusOne(battleCtx->sovereignInstructed, a, b);
    battleCtx->sovereignExtraActor = RemapPlusOne(battleCtx->sovereignExtraActor, a, b);

    // The move goes on with its user where it now stands; the ally is the side-effect battler for the message
    battleCtx->attacker = b;
    battleCtx->defender = b;
    battleCtx->sideEffectMon = a;
    return TRUE;
}
