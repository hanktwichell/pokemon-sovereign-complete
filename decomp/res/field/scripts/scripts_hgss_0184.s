#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0334.h"


    ScriptEntry scr_seq_R06_000
    ScriptEntry scr_seq_R06_001
    ScriptEntry scr_seq_R06_002
    ScriptEntryEnd
scr_seq_R06_000:
    NPCMessage msg_0334_R06_00000
    End
scr_seq_R06_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0334_R06_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R06_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_PSYDUCK, 0
    WaitCry
    Message msg_0334_R06_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
