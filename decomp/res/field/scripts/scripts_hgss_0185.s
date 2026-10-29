#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0335.h"

#define obj_R06R0201_counterm 0

    ScriptEntry scr_seq_R06R0201_000
    ScriptEntry scr_seq_R06R0201_001
    ScriptEntryEnd
scr_seq_R06R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0078
    Message msg_0335_R06R0201_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R06R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement obj_R06R0201_counterm, _00AC
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _00B8
    WaitMovement
    GoToIfSet FLAG_HGSS_HIDE_SAFFRON_CITY_COPYCAT_HOUSE_CLEFAIRY_DOLL, _0083
    Message msg_0335_R06R0201_00002
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00B2
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_0078:
    Message msg_0335_R06R0201_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0083:
    Message msg_0335_R06R0201_00003
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00B2
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
    .balign 4, 0
_00AC:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_00B2:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_00B8:
    FaceWest
    EndMovement
    .balign 4, 0
