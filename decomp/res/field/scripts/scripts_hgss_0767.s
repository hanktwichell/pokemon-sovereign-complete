#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0475.h"


    ScriptEntry scr_seq_T05_000
    ScriptEntry scr_seq_T05_001
    ScriptEntry scr_seq_T05_002
    ScriptEntry scr_seq_T05_003
    ScriptEntry scr_seq_T05_004
    ScriptEntry scr_seq_T05_005
    ScriptEntry scr_seq_T05_006
    ScriptEntry scr_seq_T05_007
    ScriptEntryEnd
scr_seq_T05_000:
    NPCMessage msg_0475_T05_00000
    End
scr_seq_T05_001:
    NPCMessage msg_0475_T05_00001
    End
scr_seq_T05_002:
    NPCMessage msg_0475_T05_00002
    End
scr_seq_T05_003:
    NPCMessage msg_0475_T05_00003
    End
scr_seq_T05_004:
    DrawSignpostInstantMessage msg_0475_T05_00004, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T05_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0475_T05_00005, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T05_006:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0475_T05_00006, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T05_007:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0475_T05_00007, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
