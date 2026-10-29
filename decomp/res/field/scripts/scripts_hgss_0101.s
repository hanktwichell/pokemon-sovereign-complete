#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0123.h"


    ScriptEntry scr_seq_D39R0103_000
    ScriptEntry scr_seq_D39R0103_001
    ScriptEntry scr_seq_D39R0103_002
    ScriptEntryEnd
scr_seq_D39R0103_000:
    ApplyMovement LOCALID_PLAYER, _0050
    WaitTime 1, VAR_RESULT
    @ HGSS: ScrCmd_374 obj_player
    WaitMovement
    @ HGSS: ScreenShake 0, 1, 1, 8
    SetVarFromValue VAR_HGSS_UNK_40AB, 0
    End
scr_seq_D39R0103_001:
    CompareVar VAR_HGSS_UNK_40AB, 1
    GoToIf 5, _004D
    ShowObject LOCALID_PLAYER
_004D:
    End
    .balign 4, 0
_0050:
    WarpIn
    EndMovement
scr_seq_D39R0103_002:
    NPCMessage msg_0123_D39R0103_00000
    End
    .balign 4, 0
