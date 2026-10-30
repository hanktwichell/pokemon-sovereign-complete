#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0366.h"


    ScriptEntry scr_seq_R26R0101_000
    ScriptEntry scr_seq_R26R0101_001
    ScriptEntryEnd
scr_seq_R26R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0366_R26R0101_00000
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    WaitForTransition
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0366_R26R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R26R0101_001:
    NPCMessage msg_0366_R26R0101_00002
    End
    .balign 4, 0
