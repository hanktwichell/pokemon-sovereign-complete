#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0128.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D43R0103_gsrivel 0

    ScriptEntry scr_seq_D43R0103_000
    ScriptEntry scr_seq_D43R0103_001
    ScriptEntry scr_seq_D43R0103_002
    ScriptEntry scr_seq_D43R0103_003
    ScriptEntry scr_seq_D43R0103_004
    ScriptEntry scr_seq_D43R0103_005
    ScriptEntry scr_seq_D43R0103_006
    ScriptEntryEnd
scr_seq_D43R0103_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0168
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_RIVAL
    AddObject obj_D43R0103_gsrivel
    Common_SetRivalBGM
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 37
    GoToIf 5, _0059
    ApplyMovement obj_D43R0103_gsrivel, _0180
    GoTo _007C
_0059:
    CompareVar VAR_MAP_LOCAL_0x00, 38
    GoToIf 5, _0074
    ApplyMovement obj_D43R0103_gsrivel, _0198
    GoTo _007C
_0074:
    ApplyMovement obj_D43R0103_gsrivel, _01B0
_007C:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0178
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    Message msg_0128_D43R0103_00000
    CloseMessage
    @ HGSS: GetStarterChoice VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 5, _00C1
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_9, 0, 0, 0
    GoTo _00E4
_00C1:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _00DC
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_13, 0, 0, 0
    GoTo _00E4
_00DC:
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_5, 0, 0, 0
_00E4:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _015A
    Common_SetRivalBGM
    Message msg_0128_D43R0103_00001
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 37
    GoToIf 5, _011F
    ApplyMovement obj_D43R0103_gsrivel, _01C8
    GoTo _0142
_011F:
    CompareVar VAR_MAP_LOCAL_0x00, 38
    GoToIf 5, _013A
    ApplyMovement obj_D43R0103_gsrivel, _01E4
    GoTo _0142
_013A:
    ApplyMovement obj_D43R0103_gsrivel, _0200
_0142:
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_RIVAL
    RemoveObject obj_D43R0103_gsrivel
    Common_FadeToDefaultMusic2
    SetVarFromValue VAR_HGSS_UNK_40C5, 1
    ReleaseAll
    End
_015A:
    RemoveObject obj_D43R0103_gsrivel
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_RIVAL
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0168:
    EmoteExclamationMark
    Delay8 2
    FaceSouth 2
    EndMovement
    .balign 4, 0
_0178:
    WalkSlowSouth
    EndMovement
    .balign 4, 0
_0180:
    WalkFastNorth 3
    FaceEast 2
    WalkFastEast 4
    FaceNorth 2
    WalkFastNorth 3
    EndMovement
    .balign 4, 0
_0198:
    WalkFastNorth 3
    FaceEast 2
    WalkFastEast 5
    FaceNorth 2
    WalkFastNorth 3
    EndMovement
    .balign 4, 0
_01B0:
    WalkFastNorth 3
    FaceEast 2
    WalkFastEast 6
    FaceNorth 2
    WalkFastNorth 3
    EndMovement
    .balign 4, 0
_01C8:
    FaceSouth 2
    WalkNormalSouth 2
    FaceWest 2
    WalkNormalWest 5
    FaceSouth 2
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
_01E4:
    FaceSouth 2
    WalkNormalSouth 2
    FaceWest 2
    WalkNormalWest 6
    FaceSouth 2
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
_0200:
    FaceSouth 2
    WalkNormalSouth 2
    FaceWest 2
    WalkNormalWest 7
    FaceSouth 2
    WalkNormalSouth 7
    EndMovement
scr_seq_D43R0103_001:
    End
scr_seq_D43R0103_002:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 57
    SetVarFromValue VAR_MAP_LOCAL_0x01, 42
    GoTo _0278
scr_seq_D43R0103_003:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 28
    SetVarFromValue VAR_MAP_LOCAL_0x01, 38
    GoTo _0278
scr_seq_D43R0103_004:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 31
    SetVarFromValue VAR_MAP_LOCAL_0x01, 44
    GoTo _0278
scr_seq_D43R0103_005:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 22
    SetVarFromValue VAR_MAP_LOCAL_0x01, 17
    GoTo _0278
scr_seq_D43R0103_006:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 58
    SetVarFromValue VAR_MAP_LOCAL_0x01, 28
    GoTo _0278
_0278:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40CA, 1
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02A9
    ApplyMovement LOCALID_PLAYER, _0330
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _033C
    GoTo _02FF
_02A9:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02CC
    ApplyMovement LOCALID_PLAYER, _034C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0358
    GoTo _02FF
_02CC:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _02EF
    ApplyMovement LOCALID_PLAYER, _0384
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0390
    GoTo _02FF
_02EF:
    ApplyMovement LOCALID_PLAYER, _0368
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0374
_02FF:
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_VICTORY_ROAD_2F, VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0330:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_033C:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_034C:
    WalkOnSpotFasterSouth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0358:
    Delay4 3
    WalkFasterSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_0368:
    WalkOnSpotFasterWest 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0374:
    Delay4 3
    WalkFasterWest
    SetInvisible
    EndMovement
    .balign 4, 0
_0384:
    WalkOnSpotFasterEast 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0390:
    Delay4 3
    WalkFasterEast
    SetInvisible
    EndMovement
    .balign 4, 0
