#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0400.h"

#define obj_R42R0101_counterm 0

    ScriptEntry scr_seq_R42R0101_000
    ScriptEntry scr_seq_R42R0101_001
    ScriptEntry scr_seq_R42R0101_002
    ScriptEntry scr_seq_R42R0101_003
    ScriptEntry scr_seq_R42R0101_004
    ScriptEntryEnd
scr_seq_R42R0101_000:
    End
scr_seq_R42R0101_001:
    NPCMessage msg_0400_R42R0101_00000
    End
scr_seq_R42R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement obj_R42R0101_counterm, _0088
    WaitMovement
    Message msg_0400_R42R0101_00001
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _008E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
scr_seq_R42R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0400_R42R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R42R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0400_R42R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0088:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_008E:
    WalkNormalWest
    EndMovement
    .balign 4, 0
