#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0469.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T04GYM0101_rocketm 7
#define obj_T04GYM0101_stop 8
#define obj_T04GYM0101_stop_2 9

    ScriptEntry scr_seq_T04GYM0101_000
    ScriptEntry scr_seq_T04GYM0101_001
    ScriptEntry scr_seq_T04GYM0101_002
    ScriptEntry scr_seq_T04GYM0101_003
    ScriptEntry scr_seq_T04GYM0101_004
    ScriptEntry scr_seq_T04GYM0101_005
    ScriptEntry scr_seq_T04GYM0101_006
    ScriptEntry scr_seq_T04GYM0101_007
    ScriptEntryEnd
scr_seq_T04GYM0101_007:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00ED
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _00E5
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 1
    GoToIf 1, _00E7
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 2
    GoToIf 1, _00E7
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00AD
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0090
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    GoTo _00AB
_0090:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _00A7
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    GoTo _00AB
_00A7:
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
_00AB:
    End
_00AD:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _00C8
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    GoTo _00E3
_00C8:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _00DF
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    GoTo _00E3
_00DF:
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
_00E3:
    End
_00E5:
    End
_00E7:
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    End
_00ED:
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    End
scr_seq_T04GYM0101_004:
    LockAll
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T04GYM0101_rocketm, _01C8
    WaitMovement
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    Message msg_0469_T04GYM0101_00000
    ApplyMovement obj_T04GYM0101_rocketm, _01D0
    WaitMovement
    Message msg_0469_T04GYM0101_00001
    ApplyMovement obj_T04GYM0101_rocketm, _01E4
    WaitMovement
    Message msg_0469_T04GYM0101_00002
    ApplyMovement obj_T04GYM0101_rocketm, _01F4
    WaitMovement
    Message msg_0469_T04GYM0101_00003
    CloseMessage
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0179
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0159
    End
_0159:
    ApplyMovement obj_T04GYM0101_rocketm, _01FC
    ApplyMovement LOCALID_PLAYER, _0204
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0210
    WaitMovement
    GoTo _018B
_0179:
    ApplyMovement obj_T04GYM0101_rocketm, _01FC
    ApplyMovement LOCALID_PLAYER, _0204
    WaitMovement
_018B:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T04GYM0101_rocketm
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    StopMusic
    PlayMusic SEQ_GYM_sseq
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_ROCKET
    ClearFlag FLAG_HGSS_HIDE_ROUTE_24_ROCKET
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_MISTY
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_MISTYS_BOYFRIEND
    SetVarFromValue VAR_HGSS_UNK_411C, 2
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_24_ROCKET, 1
    SetVarFromValue VAR_HGSS_UNK_4088, 1
    ReleaseAll
    End
    .balign 4, 0
_01C8:
    WalkFasterSouth 5
    EndMovement
    .balign 4, 0
_01D0:
    LockDir
    JumpFarNorth
    Delay8 2
    WalkFastSouth 2
    EndMovement
    .balign 4, 0
_01E4:
    EmoteExclamationMark
    LockDir
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_01F4:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_01FC:
    WalkFastSouth
    EndMovement
    .balign 4, 0
_0204:
    WalkFastWest
    FaceEast
    EndMovement
    .balign 4, 0
_0210:
    WalkFastWest
    EndMovement
scr_seq_T04GYM0101_006:
    @ HGSS: ScrCmd_814
    GoToIfSet FLAG_HGSS_HIDE_CERULEAN_GYM_MACHINE_PART, _022F
    ShowObject obj_T04GYM0101_stop
    ShowObject obj_T04GYM0101_stop_2
    End
_022F:
    End
scr_seq_T04GYM0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00016
    SetVar VAR_0x8004, ITEM_MACHINE_PART
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _027C
    Common_GiveItemQuantityNoLineFeed
    RemoveObject obj_T04GYM0101_stop
    RemoveObject obj_T04GYM0101_stop_2
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_MACHINE_PART
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_24_ROCKET, 4
    CloseMessage
    ReleaseAll
    End
_027C:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_T04GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0348
    Message msg_0469_T04GYM0101_00008
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_MISTY_MISTY, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _035E
    AddVar VAR_HGSS_UNK_4135, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    Message msg_0469_T04GYM0101_00009
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00010
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    CallIfSet FLAG_HGSS_UNK_14D, _0364
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00011
    GoTo _0307
_0307:
    SetVar VAR_0x8004, ITEM_TM03
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _033E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM03_FROM_MISTY
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_033E:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0348:
    GoToIfUnset FLAG_HGSS_GOT_TM03_FROM_MISTY, _0307
    Message msg_0469_T04GYM0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_035E:
    BlackOutFromBattle
    ReleaseAll
    End
_0364:
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_SUICUNE
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_25, 1
    Return
scr_seq_T04GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4088, 2
    GoToIf 5, _03AD
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03A4
    Message msg_0469_T04GYM0101_00006
    GoTo _03A7
_03A4:
    Message msg_0469_T04GYM0101_00007
_03A7:
    GoTo _03F6
_03AD:
    Message msg_0469_T04GYM0101_00004
    GoTo _03F6
scr_seq_T04GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4088, 2
    GoToIf 5, _03F3
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03EA
    Message msg_0469_T04GYM0101_00006
    GoTo _03ED
_03EA:
    Message msg_0469_T04GYM0101_00007
_03ED:
    GoTo _03F6
_03F3:
    Message msg_0469_T04GYM0101_00005
_03F6:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T04GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0424
    Message msg_0469_T04GYM0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0424:
    Message msg_0469_T04GYM0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
