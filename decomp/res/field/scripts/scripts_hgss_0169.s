#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0320.h"


    ScriptEntry scr_seq_R02_000
    ScriptEntryEnd
scr_seq_R02_000:
    DrawSignpostInstantMessage msg_0320_R02_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
