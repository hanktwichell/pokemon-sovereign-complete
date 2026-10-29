#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0518.h"


    ScriptEntry scr_seq_T08R0601_000
    ScriptEntry scr_seq_T08R0601_001
    ScriptEntry scr_seq_T08R0601_002
    ScriptEntry scr_seq_T08R0601_003
    ScriptEntryEnd
scr_seq_T08R0601_000:
    NPCMessage msg_0518_T08R0601_00000
    End
scr_seq_T08R0601_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_AIPOM, 0
    Message msg_0518_T08R0601_00001
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08R0601_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_AIPOM, 0
    Message msg_0518_T08R0601_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08R0601_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_AIPOM, 0
    Message msg_0518_T08R0601_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
