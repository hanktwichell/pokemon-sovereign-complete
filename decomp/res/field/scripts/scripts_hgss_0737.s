#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0448.h"


    ScriptEntry scr_seq_T01R0102_000
    ScriptEntry scr_seq_T01R0102_001
    ScriptEntryEnd
scr_seq_T01R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0448_T01R0102_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T01R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0448_T01R0102_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
