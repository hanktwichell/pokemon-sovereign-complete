#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0332.h"

#define obj_R05R0301_counterm 0

    ScriptEntry scr_seq_R05R0301_000
    ScriptEntry scr_seq_R05R0301_001
    ScriptEntryEnd
scr_seq_R05R0301_000:
    NPCMessage msg_0332_R05R0301_00000
    End
scr_seq_R05R0301_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement obj_R05R0301_counterm, _008C
    WaitMovement
    GoToIfSet FLAG_HGSS_HIDE_SAFFRON_CITY_COPYCAT_HOUSE_CLEFAIRY_DOLL, _0063
    Message msg_0332_R05R0301_00001
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0092
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_0063:
    Message msg_0332_R05R0301_00002
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0092
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
    .balign 4, 0
_008C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0092:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
