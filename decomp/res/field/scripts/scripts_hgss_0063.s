#include "macros/scrcmd.inc"


    ScriptEntry scr_seq_D27R0103_000
    ScriptEntry scr_seq_D27R0103_001
    ScriptEntry scr_seq_D27R0103_002
    ScriptEntryEnd
scr_seq_D27R0103_000:
    ApplyMovement LOCALID_PLAYER, _0056
    WaitTime 1, VAR_RESULT
    ShowObject LOCALID_PLAYER
    WaitMovement
    CompleteScreenShake 0, 1, 1, 8
    SetVarFromValue VAR_HGSS_UNK_40A7, 0
    End
scr_seq_D27R0103_001:
    CompareVar VAR_HGSS_UNK_40A7, 1
    GoToIf 5, _0054
    ShowObject LOCALID_PLAYER
    End
scr_seq_D27R0103_002:
    BufferPlayerName 0
    End
_0054:
    End
    .balign 4, 0
_0056:
    WarpIn
    EndMovement
    .balign 4, 0
