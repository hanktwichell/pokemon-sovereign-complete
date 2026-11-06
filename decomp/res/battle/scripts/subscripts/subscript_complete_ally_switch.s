#include "macros/btlcmd.inc"

// Sovereign Complete: Ally Switch. The user and its ally trade places (src/battle/complete_ally_switch.c). It fails
// outside a double battle, in a multi battle, without a living ally, and while either can't be reached (flying or
// digging for a move's second turn, carried by Sky Drop, inside a Dondozo). The foes' moves already aimed at a
// position hit whoever stands there now. The check names the ally the side-effect
// battler; after the switch the attacker is the user where it now stands and the side-effect battler is the ally.

_000:
    CompareVarToValue OPCODE_EQU, BTLVAR_COMPLETE_ALLY_SWITCH_CHECK, 0, _fail
    // As from Gen IX, it shares the protection moves' chain: used again right after one of them (or itself) it may
    // fail, and it fails when no one is left to move this turn
    TryProtection _fail
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    // A Pokémon behind a substitute shows itself while the two move
    CompareMonDataToValue OPCODE_FLAG_NOT, BTLSCR_ATTACKER, BATTLEMON_VOLATILE_STATUS, VOLATILE_CONDITION_SUBSTITUTE, _allyDoll
    PlayBattleAnimation BTLSCR_ATTACKER, BATTLE_ANIMATION_SUB_OUT
    Wait 
    RestoreSprite BTLSCR_ATTACKER
    Wait 
    PlayBattleAnimation BTLSCR_ATTACKER, BATTLE_ANIMATION_SUB_IN
    Wait 

_allyDoll:
    CompareMonDataToValue OPCODE_FLAG_NOT, BTLSCR_SIDE_EFFECT_MON, BATTLEMON_VOLATILE_STATUS, VOLATILE_CONDITION_SUBSTITUTE, _switch
    PlayBattleAnimation BTLSCR_SIDE_EFFECT_MON, BATTLE_ANIMATION_SUB_OUT
    Wait 
    RestoreSprite BTLSCR_SIDE_EFFECT_MON
    Wait 
    PlayBattleAnimation BTLSCR_SIDE_EFFECT_MON, BATTLE_ANIMATION_SUB_IN
    Wait 

_switch:
    PlaySound BTLSCR_ATTACKER, 1980
    SetMosaic BTLSCR_ATTACKER, 8, 1
    SetMosaic BTLSCR_SIDE_EFFECT_MON, 8, 1
    Wait 
    CompareVarToValue OPCODE_EQU, BTLVAR_COMPLETE_ALLY_SWITCH, 0, _fail
    ChangeForm BTLSCR_ATTACKER
    ChangeForm BTLSCR_SIDE_EFFECT_MON
    SovereignRefreshHealthBox BTLSCR_ATTACKER
    SovereignRefreshHealthBox BTLSCR_SIDE_EFFECT_MON
    PlaySound BTLSCR_ATTACKER, 1984
    SetMosaic BTLSCR_ATTACKER, 0, 1
    SetMosaic BTLSCR_SIDE_EFFECT_MON, 0, 1
    Wait 
    CompareMonDataToValue OPCODE_FLAG_NOT, BTLSCR_ATTACKER, BATTLEMON_VOLATILE_STATUS, VOLATILE_CONDITION_SUBSTITUTE, _allyBack
    PlayBattleAnimation BTLSCR_ATTACKER, BATTLE_ANIMATION_SUB_OUT
    Wait 
    RefreshSprite BTLSCR_ATTACKER
    Wait 
    PlayBattleAnimation BTLSCR_ATTACKER, BATTLE_ANIMATION_SUB_IN
    Wait 

_allyBack:
    CompareMonDataToValue OPCODE_FLAG_NOT, BTLSCR_SIDE_EFFECT_MON, BATTLEMON_VOLATILE_STATUS, VOLATILE_CONDITION_SUBSTITUTE, _message
    PlayBattleAnimation BTLSCR_SIDE_EFFECT_MON, BATTLE_ANIMATION_SUB_OUT
    Wait 
    RefreshSprite BTLSCR_SIDE_EFFECT_MON
    Wait 
    PlayBattleAnimation BTLSCR_SIDE_EFFECT_MON, BATTLE_ANIMATION_SUB_IN
    Wait 

_message:
    // {0} and {1} switched places!
    PrintMessage BattleStrings_Text_CompleteAllySwitch_AllyAlly, TAG_NICKNAME_NICKNAME, BTLSCR_ATTACKER, BTLSCR_SIDE_EFFECT_MON
    Wait 
    WaitButtonABTime 30
    End 

_fail:
    UpdateVar OPCODE_FLAG_ON, BTLVAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
