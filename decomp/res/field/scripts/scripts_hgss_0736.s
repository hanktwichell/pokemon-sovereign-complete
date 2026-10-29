#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0447.h"


    ScriptEntry scr_seq_T01R0101_000
    ScriptEntry scr_seq_T01R0101_001
    ScriptEntryEnd
scr_seq_T01R0101_000:
    NPCMessage msg_0447_T01R0101_00000
    End
scr_seq_T01R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0447_T01R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
