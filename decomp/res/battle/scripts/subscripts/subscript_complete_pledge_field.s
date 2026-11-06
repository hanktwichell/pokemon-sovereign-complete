#include "macros/btlcmd.inc"

// Sovereign Complete: after the combined Pledge's hit, its field for 4 turns (BTLVAR_COMPLETE_PLEDGE_FIELD starts it
// and sets BTLVAR_MSG_TEMP to which: 0 a sea of fire on the target's side, 1 a rainbow on the user's, 2 a swamp on the
// target's), unless it's up already.

_000:
    CompareVarToValue OPCODE_EQU, BTLVAR_COMPLETE_PLEDGE_FIELD, FALSE, _end
    CompareVarToValue OPCODE_EQU, BTLVAR_MSG_TEMP, 1, _rainbow
    CompareVarToValue OPCODE_EQU, BTLVAR_MSG_TEMP, 2, _swamp
    // A sea of fire enveloped your team!
    PrintMessage BattleStrings_Text_CompleteSeaOfFireYourTeam, TAG_NONE_SIDE_CONSCIOUS, BTLSCR_DEFENDER
    GoTo _wait

_rainbow:
    // A rainbow appeared in the sky on your team’s side!
    PrintMessage BattleStrings_Text_CompleteRainbowYourTeam, TAG_NONE_SIDE_CONSCIOUS, BTLSCR_ATTACKER
    GoTo _wait

_swamp:
    // A swamp enveloped your team!
    PrintMessage BattleStrings_Text_CompleteSwampYourTeam, TAG_NONE_SIDE_CONSCIOUS, BTLSCR_DEFENDER

_wait:
    Wait
    WaitButtonABTime 30

_end:
    End
