#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0623.h"


    ScriptEntry scr_seq_T28GYM0103_000
    ScriptEntry scr_seq_T28GYM0103_001
    ScriptEntryEnd
scr_seq_T28GYM0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0030
    Message msg_0623_T28GYM0103_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0030:
    Message msg_0623_T28GYM0103_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T28GYM0103_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0062
    Message msg_0623_T28GYM0103_00002
    GoTo _0065
_0062:
    Message msg_0623_T28GYM0103_00003
_0065:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
