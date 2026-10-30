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
    ScriptEntry scr_seq_D43R0103_007
    ScriptEntryEnd
scr_seq_D43R0103_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0384
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_RIVAL
    AddObject obj_D43R0103_gsrivel
    Common_SetRivalBGM
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 37
    GoToIf 5, _00FA
    ApplyMovement obj_D43R0103_gsrivel, _0392
    GoTo _0115
scr_seq_D43R0103_001:
    End
scr_seq_D43R0103_002:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 57
    SetVarFromValue VAR_MAP_LOCAL_0x01, 42
    GoTo _015A
scr_seq_D43R0103_003:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 28
    SetVarFromValue VAR_MAP_LOCAL_0x01, 38
    GoTo _015A
scr_seq_D43R0103_004:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 31
    SetVarFromValue VAR_MAP_LOCAL_0x01, 44
    GoTo _015A
scr_seq_D43R0103_005:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 22
    SetVarFromValue VAR_MAP_LOCAL_0x01, 17
    GoTo _015A
scr_seq_D43R0103_006:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 58
    SetVarFromValue VAR_MAP_LOCAL_0x01, 28
    GoTo _015A
scr_seq_D43R0103_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0128_D43R0103_00002
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0128_D43R0103_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00FA:
    CompareVar VAR_MAP_LOCAL_0x00, 38
    GoToIf 5, _018B
    ApplyMovement obj_D43R0103_gsrivel, _03A8
    GoTo _0115
_0115:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _03BE
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    Message msg_0128_D43R0103_00000
    CloseMessage
    SetVarFromVar VAR_RESULT, VAR_HGSS_PLAYER_STARTER
    CompareVar VAR_RESULT, 152
    GoToIf 5, _01D8
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_9, 0
    GoTo _01F3
_015A:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40CA, 1
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _022E
    ApplyMovement LOCALID_PLAYER, _03C4
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03CE
    GoTo _0251
_018B:
    ApplyMovement obj_D43R0103_gsrivel, _03DC
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _03BE
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    Message msg_0128_D43R0103_00000
    CloseMessage
    SetVarFromVar VAR_RESULT, VAR_HGSS_PLAYER_STARTER
    CompareVar VAR_RESULT, 152
    GoToIf 5, _01D8
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_9, 0
    GoTo _01F3
_01D8:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _027F
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_13, 0
    GoTo _01F3
_01F3:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02C2
    Common_SetRivalBGM
    Message msg_0128_D43R0103_00001
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 37
    GoToIf 5, _02D0
    ApplyMovement obj_D43R0103_gsrivel, _03F2
    GoTo _02EB
_022E:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0303
    ApplyMovement LOCALID_PLAYER, _040C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0416
    GoTo _0251
_0251:
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_VICTORY_ROAD_2F, VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_027F:
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_5, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02C2
    Common_SetRivalBGM
    Message msg_0128_D43R0103_00001
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 37
    GoToIf 5, _02D0
    ApplyMovement obj_D43R0103_gsrivel, _03F2
    GoTo _02EB
_02C2:
    RemoveObject obj_D43R0103_gsrivel
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_RIVAL
    BlackOutFromBattle
    ReleaseAll
    End
_02D0:
    CompareVar VAR_MAP_LOCAL_0x00, 38
    GoToIf 5, _0326
    ApplyMovement obj_D43R0103_gsrivel, _0424
    GoTo _02EB
_02EB:
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_RIVAL
    RemoveObject obj_D43R0103_gsrivel
    Common_FadeToDefaultMusic2
    SetVarFromValue VAR_HGSS_UNK_40C5, 1
    ReleaseAll
    End
_0303:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0346
    ApplyMovement LOCALID_PLAYER, _0444
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _044E
    GoTo _0251
_0326:
    ApplyMovement obj_D43R0103_gsrivel, _045C
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_RIVAL
    RemoveObject obj_D43R0103_gsrivel
    Common_FadeToDefaultMusic2
    SetVarFromValue VAR_HGSS_UNK_40C5, 1
    ReleaseAll
    End
_0346:
    ApplyMovement LOCALID_PLAYER, _0476
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0480
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_VICTORY_ROAD_2F, VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0384:
    EmoteExclamationMark
    Delay8 2
    FaceSouth 2
    EndMovement
    .balign 4, 0
_0392:
    WalkFastNorth 3
    FaceEast 2
    WalkFastEast 4
    FaceNorth 2
    WalkFastNorth 3
    EndMovement
    .balign 4, 0
_03A8:
    WalkFastNorth 3
    FaceEast 2
    WalkFastEast 5
    FaceNorth 2
    WalkFastNorth 3
    EndMovement
    .balign 4, 0
_03BE:
    WalkSlowSouth
    EndMovement
    .balign 4, 0
_03C4:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_03CE:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_03DC:
    WalkFastNorth 3
    FaceEast 2
    WalkFastEast 6
    FaceNorth 2
    WalkFastNorth 3
    EndMovement
    .balign 4, 0
_03F2:
    FaceSouth 2
    WalkNormalSouth 2
    FaceWest 2
    WalkNormalWest 5
    FaceSouth 2
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
_040C:
    WalkOnSpotFasterSouth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0416:
    Delay4 3
    WalkFasterSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_0424:
    FaceSouth 2
    WalkNormalSouth 2
    FaceWest 2
    WalkNormalWest 6
    FaceSouth 2
    WalkNormalSouth 7
    EndMovement
    WaitSE SEQ_PV001_sseq
    @ HGSS data: .byte 254
    .balign 4, 0
_0444:
    WalkOnSpotFasterEast 4
    SetInvisible
    EndMovement
    .balign 4, 0
_044E:
    Delay4 3
    WalkFasterEast
    SetInvisible
    EndMovement
    .balign 4, 0
_045C:
    FaceSouth 2
    WalkNormalSouth 2
    FaceWest 2
    WalkNormalWest 7
    FaceSouth 2
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
_0476:
    WalkOnSpotFasterWest 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0480:
    Delay4 3
    WalkFasterWest
    SetInvisible
    EndMovement
    .balign 4, 0
