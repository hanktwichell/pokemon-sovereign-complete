#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0358.h"


    ScriptEntry scr_seq_R18_000
    ScriptEntry scr_seq_R18_001
    ScriptEntryEnd
scr_seq_R18_000:
    GoToIfSet FLAG_HGSS_UNK_149, _0017
    End
_0017:
    ForceBicycling 1
    End
scr_seq_R18_001:
    DrawSignpostInstantMessage msg_0358_R18_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
