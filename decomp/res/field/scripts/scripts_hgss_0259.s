#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0406.h"


    ScriptEntry scr_seq_R46_000
    ScriptEntry scr_seq_R46_001
    ScriptEntry scr_seq_R46_002
    ScriptEntryEnd
scr_seq_R46_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAVE_RIVAL_NAME_TO_OFFICER, _002C
    Message msg_0406_R46_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_002C:
    Message msg_0406_R46_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R46_001:
    DrawSignpostInstantMessage msg_0406_R46_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R46_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0406_R46_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
