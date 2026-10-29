#include "macros/scrcmd.inc"


    ScriptEntry scr_seq_D43R0102_000
    ScriptEntry scr_seq_D43R0102_001
    ScriptEntryEnd
scr_seq_D43R0102_000:
    ApplyMovement LOCALID_PLAYER, _0048
    ShowObject LOCALID_PLAYER
    WaitMovement
    CompleteScreenShake 0, 1, 1, 8
    SetVarFromValue VAR_HGSS_UNK_40CA, 0
    End
scr_seq_D43R0102_001:
    CompareVar VAR_HGSS_UNK_40CA, 1
    GoToIf 5, _0043
    ShowObject LOCALID_PLAYER
_0043:
    End
    .balign 4, 0
_0048:
    WarpIn
    EndMovement
    .balign 4, 0
