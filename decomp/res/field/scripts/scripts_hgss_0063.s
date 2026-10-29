#include "macros/scrcmd.inc"


    ScriptEntry scr_seq_D27R0103_000
    ScriptEntry scr_seq_D27R0103_001
    ScriptEntryEnd
scr_seq_D27R0103_000:
    ApplyMovement LOCALID_PLAYER, _0038
    WaitTime 1, VAR_RESULT
    @ HGSS: ScrCmd_374 obj_player
    WaitMovement
    @ HGSS: ScreenShake 0, 1, 1, 8
    SetVarFromValue VAR_HGSS_UNK_40A7, 0
    End
    .balign 4, 0
_0038:
    WarpIn
    EndMovement
scr_seq_D27R0103_001:
    CompareVar VAR_HGSS_UNK_40A7, 1
    GoToIf 5, _0051
    ShowObject LOCALID_PLAYER
_0051:
    End
    .balign 4, 0
