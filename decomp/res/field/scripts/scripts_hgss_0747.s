#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0457.h"


    ScriptEntry scr_seq_T02R0301_000
    ScriptEntry scr_seq_T02R0301_001
    ScriptEntry scr_seq_T02R0301_002
    ScriptEntry scr_seq_T02R0301_003
    ScriptEntry scr_seq_T02R0301_004
    ScriptEntry scr_seq_T02R0301_005
    ScriptEntry scr_seq_T02R0301_006
    ScriptEntry scr_seq_T02R0301_007
    ScriptEntryEnd
scr_seq_T02R0301_000:
    NPCMessage msg_0457_T02R0301_00000
    End
scr_seq_T02R0301_001:
    NPCMessage msg_0457_T02R0301_00001
    End
scr_seq_T02R0301_002:
    NPCMessage msg_0457_T02R0301_00002
    End
scr_seq_T02R0301_003:
    NPCMessage msg_0457_T02R0301_00003
    End
scr_seq_T02R0301_004:
    NPCMessage msg_0457_T02R0301_00004
    End
scr_seq_T02R0301_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0457_T02R0301_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T02R0301_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0457_T02R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T02R0301_007:
    NPCMessage msg_0457_T02R0301_00007
    End
    .balign 4, 0
