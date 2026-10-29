#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0740.h"


    ScriptEntry scr_seq_W19_000
    ScriptEntry scr_seq_W19_001
    ScriptEntry scr_seq_W19_002
    ScriptEntry scr_seq_W19_003
    ScriptEntry scr_seq_W19_004
    ScriptEntry scr_seq_W19_005
    ScriptEntryEnd
scr_seq_W19_000:
    NPCMessage msg_0740_W19_00000
    End
scr_seq_W19_001:
    NPCMessage msg_0740_W19_00002
    End
scr_seq_W19_002:
    NPCMessage msg_0740_W19_00001
    End
scr_seq_W19_003:
    NPCMessage msg_0740_W19_00003
    End
scr_seq_W19_004:
    DrawSignpostInstantMessage msg_0740_W19_00004, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_W19_005:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0740_W19_00005, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
