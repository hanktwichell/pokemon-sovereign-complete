#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0329.h"


    ScriptEntry scr_seq_R05_000
    ScriptEntry scr_seq_R05_001
    ScriptEntryEnd
scr_seq_R05_000:
    NPCMessage msg_0329_R05_00000
    End
scr_seq_R05_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0329_R05_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
