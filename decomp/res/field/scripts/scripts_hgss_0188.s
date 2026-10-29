#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0338.h"


    ScriptEntry scr_seq_R08_000
    ScriptEntry scr_seq_R08_001
    ScriptEntryEnd
scr_seq_R08_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0338_R08_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R08_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0338_R08_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
