#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0337.h"

#define obj_R07R0101_counterm 0

    ScriptEntry scr_seq_R07R0101_000
    ScriptEntry scr_seq_R07R0101_001
    ScriptEntryEnd
scr_seq_R07R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0063
    Message msg_0337_R07R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R07R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement obj_R07R0101_counterm, _006E
    WaitMovement
    Message msg_0337_R07R0101_00002
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0074
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_0063:
    Message msg_0337_R07R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_006E:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0074:
    WalkNormalWest
    EndMovement
    .balign 4, 0
