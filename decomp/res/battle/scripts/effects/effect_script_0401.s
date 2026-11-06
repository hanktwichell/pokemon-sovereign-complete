#include "macros/btlcmd.inc"

// Sovereign Complete: Ally Switch, subscript_complete_ally_switch.

_000:
    UpdateVar OPCODE_SET, BTLVAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_COMPLETE_ALLY_SWITCH
    End 
