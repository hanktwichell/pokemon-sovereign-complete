#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0521.h"


    ScriptEntry scr_seq_T10_000
    ScriptEntryEnd
scr_seq_T10_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0521_T10_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
