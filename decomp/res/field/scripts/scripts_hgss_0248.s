#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0395.h"

#define obj_R38R0101_counterm 0

    ScriptEntry scr_seq_R38R0101_000
    ScriptEntry scr_seq_R38R0101_001
    ScriptEntry scr_seq_R38R0101_002
    ScriptEntry scr_seq_R38R0101_003
    ScriptEntry scr_seq_R38R0101_004
    ScriptEntryEnd
scr_seq_R38R0101_000:
    End
scr_seq_R38R0101_001:
    NPCMessage msg_0395_R38R0101_00000
    End
scr_seq_R38R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement obj_R38R0101_counterm, _0132
    WaitMovement
    Message msg_0395_R38R0101_00001
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0138
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
scr_seq_R38R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0395_R38R0101_00002
    PlayFanfare SEQ_ME_TAMAGO_GET_sseq
    WaitFanfare
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_61A5, 2
    ClearFlag FLAG_HGSS_SG_3FEC
    ClearFlag FLAG_HGSS_SG_3FEB
    ReleaseAll
    End
scr_seq_R38R0101_004:
    LockAll
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    BufferPlayerName 0
    SetPosition 1, 10, 1, 7, DIR_WEST
    ApplyMovement 1, _0144
    WaitMovement
    WaitSE SEQ_SE_DP_DOOR_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _014A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement 1, _0150
    WaitMovement
    ApplyMovement 1, _0132
    WaitMovement
    Message msg_0395_R38R0101_00004
    ApplyMovement 1, _013E
    WaitMovement
    Message msg_0395_R38R0101_00005
    ApplyMovement 1, _0144
    WaitMovement
    Message msg_0395_R38R0101_00006
    SetVar VAR_0x8004, ITEM_IRON_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0395_R38R0101_00007
    WaitButton
    CloseMessage
    ApplyMovement 1, _014A
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject 1
    WaitSE SEQ_SE_DP_DOOR_sseq
    SetVarFromValue VAR_HGSS_SG_612F, 2
    ReleaseAll
    End
    .balign 4, 0
_0132:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0138:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_013E:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0144:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_014A:
    WalkNormalEast 4
    EndMovement
    .balign 4, 0
_0150:
    WalkNormalWest 4
    EndMovement
    @ HGSS data: .byte 254, 0
    .balign 4, 0
