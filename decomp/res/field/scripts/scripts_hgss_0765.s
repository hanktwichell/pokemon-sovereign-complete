#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0473.h"


    ScriptEntry scr_seq_T04R0301_000
    ScriptEntry scr_seq_T04R0301_001
    ScriptEntry scr_seq_T04R0301_002
    ScriptEntry scr_seq_T04R0301_003
    ScriptEntryEnd
scr_seq_T04R0301_000:
    NPCMessage msg_0473_T04R0301_00000
    End
scr_seq_T04R0301_001:
    NPCMessage msg_0473_T04R0301_00001
    End
scr_seq_T04R0301_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_KANGASKHAN, 0
    Message msg_0473_T04R0301_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T04R0301_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ZUBAT, 0
    Message msg_0473_T04R0301_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
