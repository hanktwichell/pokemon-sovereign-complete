#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0544.h"


    ScriptEntry scr_seq_T20R0102_000
    ScriptEntry scr_seq_T20R0102_001
    ScriptEntryEnd
scr_seq_T20R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    MessageGendered msg_0544_T20R0102_00000, msg_0544_T20R0102_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0102_001:
    NPCMessage msg_0544_T20R0102_00002
    End
    .balign 4, 0
