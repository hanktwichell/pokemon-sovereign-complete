#include "macros/btlcmd.inc"

// Sovereign Complete: the sea of fire's damage at the end of the turn (BattleControllerPlayer_CheckMonConditions sets
// the battler and the HP).

_000:
    // {0} is hurt by the sea of fire!
    PrintMessage BattleStrings_Text_CompleteHurtBySeaOfFire_Ally, TAG_NICKNAME, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    GoToSubscript BATTLE_SUBSCRIPT_UPDATE_HP
