#include "macros/btlcmd.inc"

// Sovereign Complete: a Pledge's field ends (BattleControllerPlayer_CheckFieldConditions; BTLVAR_MSG_TEMP: 0 the sea
// of fire, 1 the rainbow, 2 the swamp; BTLSCR_MSG_TEMP a battler on its side).

_000:
    CompareVarToValue OPCODE_EQU, BTLVAR_MSG_TEMP, 1, _rainbow
    CompareVarToValue OPCODE_EQU, BTLVAR_MSG_TEMP, 2, _swamp
    // The sea of fire around your team disappeared!
    PrintMessage BattleStrings_Text_CompleteSeaOfFireEndYourTeam, TAG_NONE_SIDE_CONSCIOUS, BTLSCR_MSG_TEMP
    GoTo _wait

_rainbow:
    // The rainbow on your team’s side disappeared!
    PrintMessage BattleStrings_Text_CompleteRainbowEndYourTeam, TAG_NONE_SIDE_CONSCIOUS, BTLSCR_MSG_TEMP
    GoTo _wait

_swamp:
    // The swamp around your team disappeared!
    PrintMessage BattleStrings_Text_CompleteSwampEndYourTeam, TAG_NONE_SIDE_CONSCIOUS, BTLSCR_MSG_TEMP

_wait:
    Wait
    WaitButtonABTime 30
    End
