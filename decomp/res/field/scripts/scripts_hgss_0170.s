#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0321.h"


    ScriptEntry scr_seq_R02R0101_000
    ScriptEntry scr_seq_R02R0101_001
    ScriptEntryEnd
scr_seq_R02R0101_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0321_R02R0101_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R02R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_PERSIAN, 0
    WaitCry
    Message msg_0321_R02R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
