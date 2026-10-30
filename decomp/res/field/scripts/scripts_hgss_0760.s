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
    GoToIf 5, _0267
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _026D
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 1
    GoToIf 1, _026F
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 2
    GoToIf 1, _026F
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0275
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0290
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    GoTo _02A7
scr_seq_T04GYM0101_004:
    LockAll
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    ApplyMovement obj_T04GYM0101_rocketm, _0444
    WaitMovement
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    Message msg_0469_T04GYM0101_00000
    ApplyMovement obj_T04GYM0101_rocketm, _044A
    WaitMovement
    Message msg_0469_T04GYM0101_00001
    ApplyMovement obj_T04GYM0101_rocketm, _045C
    WaitMovement
    Message msg_0469_T04GYM0101_00002
    ApplyMovement obj_T04GYM0101_rocketm, _046A
    WaitMovement
    Message msg_0469_T04GYM0101_00003
    CloseMessage
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02A9
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02F5
    End
scr_seq_T04GYM0101_006:
    @ HGSS: ScrCmd_814
    GoToIfSet FLAG_HGSS_HIDE_CERULEAN_GYM_MACHINE_PART, _0315
    ShowObject obj_T04GYM0101_stop
    ShowObject obj_T04GYM0101_stop_2
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
    GoToIfEq VAR_RESULT, 0, _0317
    Common_GiveItemQuantityNoLineFeed
    RemoveObject obj_T04GYM0101_stop
    RemoveObject obj_T04GYM0101_stop_2
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_MACHINE_PART
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_24_ROCKET, 4
    CloseMessage
    ReleaseAll
    End
scr_seq_T04GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0321
    Message msg_0469_T04GYM0101_00008
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_MISTY_MISTY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0337
    AddVar VAR_HGSS_UNK_4135, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_HGSS_SWIMMER_F_DIANA
    SetTrainerFlag TRAINER_HGSS_SWIMMER_F_BRIANA
    SetTrainerFlag TRAINER_HGSS_SWIMMER_F_JOY
    SetTrainerFlag TRAINER_HGSS_SAILOR_PARKER
    SetTrainerFlag TRAINER_HGSS_SAILOR_EDDIE
    Message msg_0469_T04GYM0101_00009
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00010
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    CallIfSet FLAG_HGSS_UNK_14D, _033D
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00011
    GoTo _0349
scr_seq_T04GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4088, 2
    GoToIf 5, _0396
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _039F
    Message msg_0469_T04GYM0101_00006
    GoTo _03A8
scr_seq_T04GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4088, 2
    GoToIf 5, _03AE
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03B9
    Message msg_0469_T04GYM0101_00006
    GoTo _03C2
scr_seq_T04GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03C8
    Message msg_0469_T04GYM0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0267:
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    End
_026D:
    End
_026F:
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    End
_0275:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _03D3
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    GoTo _03EA
_0290:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _03EC
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    GoTo _02A7
_02A7:
    End
_02A9:
    ApplyMovement obj_T04GYM0101_rocketm, _0470
    ApplyMovement LOCALID_PLAYER, _0476
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T04GYM0101_rocketm
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    StopMusic
    PlayMusic SEQ_GS_GYM_sseq
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_ROCKET
    ClearFlag FLAG_HGSS_HIDE_ROUTE_24_ROCKET
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_MISTY
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_MISTYS_BOYFRIEND
    SetVarFromValue VAR_HGSS_UNK_411C, 2
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_24_ROCKET, 1
    SetVarFromValue VAR_HGSS_UNK_4088, 1
    ReleaseAll
    End
_02F5:
    ApplyMovement obj_T04GYM0101_rocketm, _0470
    ApplyMovement LOCALID_PLAYER, _0476
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0480
    WaitMovement
    GoTo _03F2
_0315:
    End
_0317:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0321:
    GoToIfUnset FLAG_HGSS_GOT_TM03_FROM_MISTY, _0349
    Message msg_0469_T04GYM0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0337:
    BlackOutFromBattle
    ReleaseAll
    End
_033D:
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_SUICUNE
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_25, 1
    Return
_0349:
    SetVar VAR_0x8004, ITEM_TM03
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _042C
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM03_FROM_MISTY
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00012
    Message msg_0469_T04GYM0101_00017
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00018
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_MISTY
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0396:
    Message msg_0469_T04GYM0101_00004
    GoTo _0436
_039F:
    Message msg_0469_T04GYM0101_00007
    GoTo _0436
_03A8:
    GoTo _0436
_03AE:
    Message msg_0469_T04GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03B9:
    Message msg_0469_T04GYM0101_00007
    GoTo _0436
_03C2:
    GoTo _0436
_03C8:
    Message msg_0469_T04GYM0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03D3:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _043E
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    GoTo _03EA
_03EA:
    End
_03EC:
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    End
_03F2:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T04GYM0101_rocketm
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    StopMusic
    PlayMusic SEQ_GS_GYM_sseq
    SetFlag FLAG_HGSS_HIDE_CERULEAN_GYM_ROCKET
    ClearFlag FLAG_HGSS_HIDE_ROUTE_24_ROCKET
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_MISTY
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_MISTYS_BOYFRIEND
    SetVarFromValue VAR_HGSS_UNK_411C, 2
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_24_ROCKET, 1
    SetVarFromValue VAR_HGSS_UNK_4088, 1
    ReleaseAll
    End
_042C:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0436:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_043E:
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    End
    .balign 4, 0
_0444:
    WalkFasterSouth 5
    EndMovement
    .balign 4, 0
_044A:
    LockDir
    JumpFarNorth
    Delay8 2
    WalkFastSouth 2
    EndMovement
    .balign 4, 0
_045C:
    EmoteExclamationMark
    LockDir
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_046A:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0470:
    WalkFastSouth
    EndMovement
    .balign 4, 0
_0476:
    WalkFastWest
    FaceEast
    EndMovement
    .balign 4, 0
_0480:
    WalkFastWest
    EndMovement
    .balign 4, 0
