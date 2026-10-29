#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0742.h"


    ScriptEntry scr_seq_W20_000
    ScriptEntry scr_seq_W20_001
    ScriptEntryEnd
scr_seq_W20_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0742_W20_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_W20_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0742_W20_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
