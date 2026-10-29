#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0340.h"


    ScriptEntry scr_seq_R09_000
    ScriptEntryEnd
scr_seq_R09_000:
    DrawSignpostInstantMessage msg_0340_R09_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
