#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0383.h"


    ScriptEntry scr_seq_R33_000
    ScriptEntry scr_seq_R33_001
    ScriptEntryEnd
scr_seq_R33_000:
    NPCMessage msg_0383_R33_00000
    End
scr_seq_R33_001:
    DrawSignpostInstantMessage msg_0383_R33_00001, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
