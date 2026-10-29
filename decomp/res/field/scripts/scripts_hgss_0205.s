#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0354.h"


    ScriptEntry scr_seq_R16_000
    ScriptEntry scr_seq_R16_001
    ScriptEntryEnd
scr_seq_R16_000:
    @ HGSS: SetBikeStateLock 1
    SetFlag FLAG_HGSS_UNK_149
    End
scr_seq_R16_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0354_R16_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
