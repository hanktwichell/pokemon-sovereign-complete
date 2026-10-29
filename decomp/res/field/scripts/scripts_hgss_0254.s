#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0401.h"


    ScriptEntry scr_seq_R43_000
    ScriptEntry scr_seq_R43_001
    ScriptEntry scr_seq_R43_002
    ScriptEntry scr_seq_R43_003
    ScriptEntryEnd
scr_seq_R43_000:
    End
scr_seq_R43_001:
    DrawSignpostInstantMessage msg_0401_R43_00018, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R43_002:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0401_R43_00019, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R43_003:
    DrawSignpostInstantMessage msg_0401_R43_00020, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
