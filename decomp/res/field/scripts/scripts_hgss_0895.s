#include "macros/scrcmd.inc"


    ScriptEntry scr_seq_T25R0503_000
    ScriptEntryEnd
scr_seq_T25R0503_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0038
    WaitMovement
    WaitTime 40, VAR_0x8004
    @ HGSS: ScrCmd_722 0, 1, 401, 14, 11
    SetVarFromValue VAR_HGSS_UNK_411F, 0
    ReleaseAll
    End
    .balign 4, 0
_0038:
    WalkNormalEast 7
    WalkNormalNorth 2
    EndMovement
_0044:
    End
    .balign 4, 0
