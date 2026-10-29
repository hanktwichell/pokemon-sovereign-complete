#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0371.h"


    ScriptEntry scr_seq_R28_000
    ScriptEntry scr_seq_R28_001
    ScriptEntryEnd
scr_seq_R28_000:
    SetVarFromValue VAR_HGSS_UNK_4126, 0
    End
scr_seq_R28_001:
    DrawSignpostInstantMessage msg_0371_R28_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
