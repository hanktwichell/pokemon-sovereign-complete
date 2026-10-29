#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0350.h"


    ScriptEntry scr_seq_R13_000
    ScriptEntry scr_seq_R13_001
    ScriptEntry scr_seq_R13_002
    ScriptEntryEnd
scr_seq_R13_000:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0350_R13_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R13_001:
    DrawSignpostInstantMessage msg_0350_R13_00001, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R13_002:
    DrawSignpostInstantMessage msg_0350_R13_00002, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
