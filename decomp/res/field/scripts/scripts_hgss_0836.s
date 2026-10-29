#include "macros/scrcmd.inc"


    ScriptEntry scr_seq_T11R0603_000
    ScriptEntryEnd
scr_seq_T11R0603_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0038
    WaitMovement
    WaitTime 40, VAR_0x8004
    @ HGSS: ScrCmd_722 1, 1, 198, 17, 11
    SetVarFromValue VAR_HGSS_UNK_411E, 0
    ReleaseAll
    End
    .balign 4, 0
_0038:
    WalkNormalWest 7
    WalkNormalNorth 2
    EndMovement
    End
    .balign 4, 0
