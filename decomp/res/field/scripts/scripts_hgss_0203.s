#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0352.h"


    ScriptEntry scr_seq_R15_000
    ScriptEntryEnd
scr_seq_R15_000:
    DrawSignpostInstantMessage msg_0352_R15_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
