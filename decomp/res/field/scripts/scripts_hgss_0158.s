#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0261.h"

#define obj_P01R0303_seaman_2 0

    ScriptEntry scr_seq_P01R0303_000
    ScriptEntry scr_seq_P01R0303_001
    ScriptEntryEnd
scr_seq_P01R0303_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_UNK_0ED, _0112
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 1, _009D
    ApplyMovement obj_P01R0303_seaman_2, _0120
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_P01R0303_seaman_2, _0144
    ApplyMovement LOCALID_PLAYER, _01C8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0261_P01R0303_00005
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_SAILOR_STANLY, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _010C
    Message msg_0261_P01R0303_00006
    CloseMessage
    ApplyMovement obj_P01R0303_seaman_2, _0160
    WaitMovement
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 3
    RemoveObject obj_P01R0303_seaman_2
    SetFlag FLAG_HGSS_UNK_21A
    ReleaseAll
    End
_009D:
    ApplyMovement obj_P01R0303_seaman_2, _016C
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_P01R0303_seaman_2, _0190
    ApplyMovement LOCALID_PLAYER, _01DC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0261_P01R0303_00005
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_SAILOR_STANLY, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _010C
    Message msg_0261_P01R0303_00006
    CloseMessage
    ApplyMovement obj_P01R0303_seaman_2, _01AC
    WaitMovement
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 3
    RemoveObject obj_P01R0303_seaman_2
    SetFlag FLAG_HGSS_UNK_21A
    ReleaseAll
    End
_010C:
    BlackOutFromBattle
    ReleaseAll
    End
_0112:
    Message msg_0261_P01R0303_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0120:
    EmoteExclamationMark
    Delay8
    FaceEast 2
    FaceWest 2
    FaceEast 2
    LockDir
    JumpFarWest
    UnlockDir
    EndMovement
    .balign 4, 0
_0144:
    FaceNorth 2
    WalkFastNorth 2
    FaceEast 2
    WalkFastEast 4
    FaceSouth 2
    WalkFastSouth
    EndMovement
    .balign 4, 0
_0160:
    FaceNorth 2
    WalkFastNorth 7
    EndMovement
    .balign 4, 0
_016C:
    EmoteExclamationMark
    Delay8
    FaceWest 2
    FaceEast 2
    FaceWest 2
    LockDir
    JumpFarEast
    UnlockDir
    EndMovement
    .balign 4, 0
_0190:
    FaceNorth 2
    WalkFastNorth 2
    FaceWest 2
    WalkFastWest 4
    FaceSouth 2
    WalkFastSouth
    EndMovement
    .balign 4, 0
_01AC:
    FaceNorth 2
    WalkFastNorth 3
    FaceEast 2
    WalkFastEast 4
    FaceNorth 2
    WalkFastNorth 4
    EndMovement
    .balign 4, 0
_01C8:
    Delay16
    FaceEast 2
    WalkNormalEast
    FaceNorth 2
    EndMovement
    .balign 4, 0
_01DC:
    Delay16
    FaceWest 2
    WalkNormalWest
    FaceNorth 2
    EndMovement
scr_seq_P01R0303_001:
    LockAll
    ApplyMovement LOCALID_PLAYER, _02B4
    WaitMovement
    Message msg_0261_P01R0303_00000
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0261_P01R0303_00001
    CloseMessage
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0247
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
_0247:
    ApplyMovement LOCALID_PLAYER, _02C4
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0268
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
_0268:
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 7
    GoToIf 4, _0279
    ReleaseAll
    End
_0279:
    GoToIfSet FLAG_HGSS_BOAT_ARRIVED, _02AD
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    SetFlag FLAG_HGSS_BOAT_ARRIVED
    CompareVar VAR_HGSS_BOAT_DIRECTION, 1
    GoToIf 5, _02A6
    Message msg_0261_P01R0303_00003
    GoTo _02A9
_02A6:
    Message msg_0261_P01R0303_00002
_02A9:
    WaitButton
    CloseMessage
_02AD:
    ReleaseAll
    End
    .balign 4, 0
_02B4:
    FaceSouth 2
    Delay16
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_02C4:
    FaceEast 2
    JumpNearFastEast
    EndMovement
    .balign 4, 0
