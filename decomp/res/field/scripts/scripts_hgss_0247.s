#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0394.h"


    ScriptEntry scr_seq_R38_000
    ScriptEntry scr_seq_R38_001
    ScriptEntry scr_seq_R38_002
    ScriptEntryEnd
scr_seq_R38_000:
    End
scr_seq_R38_001:
    DrawSignpostInstantMessage msg_0394_R38_00015, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R38_002:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0394_R38_00016, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
