#include "macros/btlcmd.inc"

// Sovereign Complete: the Pledges (src/battle/complete_pledges.c). A plain hit, but for the combined Pledge:
// subscript_complete_pledge_combine says so with the attack message, and subscript_complete_pledge_field starts its
// sea of fire, rainbow or swamp after the hit.

_000:
    CompareVarToValue OPCODE_EQU, BTLVAR_COMPLETE_PLEDGE_COMBINED, FALSE, _hit
    UpdateVar OPCODE_SET, BTLVAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_COMPLETE_PLEDGE_COMBINE
    UpdateVar OPCODE_SET, BTLVAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_COMPLETE_PLEDGE_FIELD

_hit:
    CalcCrit
    CalcDamage
    End
