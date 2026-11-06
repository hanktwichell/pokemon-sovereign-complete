#include "macros/btlcmd.inc"

// Sovereign Complete: the combined Pledge's attack message, then that it's combined, then its animation (as
// subscript_magnitude).

_000:
    CompareVarToValue OPCODE_FLAG_SET, BTLVAR_BATTLE_CTX_STATUS, SYSCTL_PLAYED_MOVE_ANIMATION, _animation
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    // The two moves have become one! It’s a combined move!
    PrintMessage BattleStrings_Text_CompletePledgeCombined, TAG_NONE
    Wait
    WaitButtonABTime 30

_animation:
    CompareVarToValue OPCODE_FLAG_SET, BTLVAR_MOVE_STATUS_FLAGS, MOVE_STATUS_DID_NOT_HIT, _end
    PlayMoveAnimation BTLSCR_ATTACKER
    Wait

_end:
    End
