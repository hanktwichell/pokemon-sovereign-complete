#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0362.h"

#define obj_R24_gsman1 0
#define obj_R24_gswoman2 1
#define obj_R24_rocketm 2

    ScriptEntry scr_seq_R24_000
    ScriptEntry scr_seq_R24_001
    ScriptEntry scr_seq_R24_002
    ScriptEntry scr_seq_R24_003
    ScriptEntry scr_seq_R24_004
    ScriptEntryEnd
scr_seq_R24_004:
    CompareVar VAR_HGSS_SCENE_ROUTE_24_ROCKET, 2
    GoToIf 1, _0025
    End
_0025:
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_24_ROCKET, 1
    End
scr_seq_R24_003:
    LockAll
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0060
    ApplyMovement obj_R24_rocketm, _0084
    ApplyMovement obj_R24_gsman1, _00A0
    ApplyMovement obj_R24_gswoman2, _00AC
    GoTo _0078
_0060:
    ApplyMovement obj_R24_rocketm, _0090
    ApplyMovement obj_R24_gsman1, _00A0
    ApplyMovement obj_R24_gswoman2, _00AC
_0078:
    WaitMovement
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_24_ROCKET, 2
    ReleaseAll
    End
    .balign 4, 0
_0084:
    EmoteExclamationMark
    WalkFastWest 3
    EndMovement
    .balign 4, 0
_0090:
    FaceNorth
    EmoteExclamationMark
    WalkFastWest 3
    EndMovement
    .balign 4, 0
_00A0:
    Delay16 3
    FaceSouth
    EndMovement
    .balign 4, 0
_00AC:
    Delay16 3
    WalkFastSouth
    FaceNorth
    EndMovement
scr_seq_R24_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    Message msg_0362_R24_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_TEAM_ROCKET_GRUNT_24, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _014A
    Message msg_0362_R24_00002
    CloseMessage
    FadeOutBGM 0, 30
    Message msg_0362_R24_00003
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R24_rocketm, _0150
    ApplyMovement LOCALID_PLAYER, _015C
    ApplyMovement obj_R24_gsman1, _0170
    ApplyMovement obj_R24_gswoman2, _017C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    RemoveObject obj_R24_rocketm
    SetFlag FLAG_HGSS_HIDE_ROUTE_24_ROCKET
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_MACHINE_PART
    PlayMusic SEQ_GS_R_12_24_sseq
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_24_ROCKET, 3
    ReleaseAll
    End
_014A:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0150:
    WalkFastEast
    WalkFastSouth 10
    EndMovement
    .balign 4, 0
_015C:
    LockDir
    WalkFastEast
    UnlockDir
    FaceSouth
    EndMovement
    .balign 4, 0
_0170:
    Delay4 12
    FaceWest
    EndMovement
    .balign 4, 0
_017C:
    Delay4
    FaceSouth
    Delay4 10
    WalkNormalNorth
    FaceWest
    EndMovement
scr_seq_R24_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CompareVar VAR_HGSS_SCENE_ROUTE_24_ROCKET, 2
    GoToIf 5, _01B3
    GoTo _01DC
    GoTo _01DC
_01B3:
    CompareVar VAR_HGSS_SCENE_ROUTE_24_ROCKET, 3
    GoToIf 5, _01D1
    FacePlayer
    Message msg_0362_R24_00005
    GoTo _01DF
    GoTo _01DC
_01D1:
    FacePlayer
    Message msg_0362_R24_00006
    GoTo _01DF
_01DC:
    Message msg_0362_R24_00004
_01DF:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R24_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CompareVar VAR_HGSS_SCENE_ROUTE_24_ROCKET, 2
    GoToIf 5, _0206
    GoTo _022F
    GoTo _022F
_0206:
    CompareVar VAR_HGSS_SCENE_ROUTE_24_ROCKET, 3
    GoToIf 5, _0224
    FacePlayer
    Message msg_0362_R24_00008
    GoTo _0232
    GoTo _022F
_0224:
    FacePlayer
    Message msg_0362_R24_00009
    GoTo _0232
_022F:
    Message msg_0362_R24_00007
_0232:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
