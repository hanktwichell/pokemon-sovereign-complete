#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0404.h"


    ScriptEntry scr_seq_R44_000
    ScriptEntry scr_seq_R44_001
    ScriptEntry scr_seq_R44_002
    ScriptEntryEnd
scr_seq_R44_000:
    End
scr_seq_R44_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0404_R44_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R44_002:
    DrawSignpostInstantMessage msg_0404_R44_00001, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
