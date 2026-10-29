#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0336.h"


    ScriptEntry scr_seq_R07_000
    ScriptEntry scr_seq_R07_001
    ScriptEntryEnd
scr_seq_R07_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0336_R07_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R07_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0336_R07_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
