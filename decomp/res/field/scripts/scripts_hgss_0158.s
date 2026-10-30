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
    BufferPlayerName 0
    GoToIfUnset FLAG_HGSS_UNK_0ED, _0129
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0134
    ApplyMovement obj_P01R0303_seaman_2, _0230
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_P01R0303_seaman_2, _0252
    ApplyMovement LOCALID_PLAYER, _026C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0261_P01R0303_00005
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_SAILOR_STANLY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A3
    Message msg_0261_P01R0303_00006
    CloseMessage
    ApplyMovement obj_P01R0303_seaman_2, _027E
    WaitMovement
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 3
    RemoveObject obj_P01R0303_seaman_2
    SetFlag FLAG_HGSS_UNK_21A
    ReleaseAll
    End
scr_seq_P01R0303_001:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0288
    WaitMovement
    Message msg_0261_P01R0303_00000
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
    Message msg_0261_P01R0303_00001
    CloseMessage
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _01A9
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0296
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _01DB
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 7
    GoToIf 4, _01EC
    ReleaseAll
    End
_0129:
    Message msg_0261_P01R0303_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0134:
    ApplyMovement obj_P01R0303_seaman_2, _02A0
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_P01R0303_seaman_2, _02C2
    ApplyMovement LOCALID_PLAYER, _02DC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0261_P01R0303_00005
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_SAILOR_STANLY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A3
    Message msg_0261_P01R0303_00006
    CloseMessage
    ApplyMovement obj_P01R0303_seaman_2, _02EE
    WaitMovement
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 3
    RemoveObject obj_P01R0303_seaman_2
    SetFlag FLAG_HGSS_UNK_21A
    ReleaseAll
    End
_01A3:
    BlackOutFromBattle
    ReleaseAll
    End
_01A9:
    ApplyMovement LOCALID_PLAYER, _0296
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _01DB
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 7
    GoToIf 4, _01EC
    ReleaseAll
    End
_01DB:
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 7
    GoToIf 4, _01EC
    ReleaseAll
    End
_01EC:
    GoToIfSet FLAG_HGSS_BOAT_ARRIVED, _0219
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    SetFlag FLAG_HGSS_BOAT_ARRIVED
    CompareVar VAR_HGSS_BOAT_DIRECTION, 1
    GoToIf 5, _021D
    Message msg_0261_P01R0303_00003
    GoTo _0228
_0219:
    ReleaseAll
    End
_021D:
    Message msg_0261_P01R0303_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0228:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0230:
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
_0252:
    FaceNorth 2
    WalkFastNorth 2
    FaceEast 2
    WalkFastEast 4
    FaceSouth 2
    WalkFastSouth
    EndMovement
    .balign 4, 0
_026C:
    Delay16
    FaceEast 2
    WalkNormalEast
    FaceNorth 2
    EndMovement
    .balign 4, 0
_027E:
    FaceNorth 2
    WalkFastNorth 7
    EndMovement
    .balign 4, 0
_0288:
    FaceSouth 2
    Delay16
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0296:
    FaceEast 2
    JumpNearFastEast
    EndMovement
    .balign 4, 0
_02A0:
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
_02C2:
    FaceNorth 2
    WalkFastNorth 2
    FaceWest 2
    WalkFastWest 4
    FaceSouth 2
    WalkFastSouth
    EndMovement
    .balign 4, 0
_02DC:
    Delay16
    FaceWest 2
    WalkNormalWest
    FaceNorth 2
    EndMovement
    .balign 4, 0
_02EE:
    FaceNorth 2
    WalkFastNorth 3
    FaceEast 2
    WalkFastEast 4
    FaceNorth 2
    WalkFastNorth 4
    EndMovement
    .balign 4, 0
