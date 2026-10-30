#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0454.h"

#define obj_T02GYM0101_sunglasses 4

    ScriptEntry scr_seq_T02GYM0101_000
    ScriptEntry scr_seq_T02GYM0101_001
    ScriptEntry scr_seq_T02GYM0101_002
    ScriptEntry scr_seq_T02GYM0101_003
    ScriptEntry scr_seq_T02GYM0101_004
    ScriptEntryEnd
scr_seq_T02GYM0101_002:
    @ HGSS: ViridianGymInit
    SetVarFromValue VAR_HGSS_UNK_4127, 0
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BLUE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _017E
    CompareVar VAR_HGSS_UNK_40FD, 0
    GoToIf 1, _0184
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 5, _018A
    SetFlag FLAG_HGSS_HIDE_VIRIDIAN_GYM_BLUE
    GoTo _0190
scr_seq_T02GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0192
    Message msg_0454_T02GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_BLUE_BLUE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A8
    AddVar VAR_HGSS_UNK_4135, 1
    SetFlag FLAG_HGSS_UNK_998
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_HGSS_ACE_TRAINER_M_ARABELLA
    SetTrainerFlag TRAINER_HGSS_ACE_TRAINER_F_SALMA
    SetTrainerFlag TRAINER_HGSS_ACE_TRAINER_M_BONITA
    SetTrainerFlag TRAINER_HGSS_DOUBLE_TEAM_ELAN_AND_IDA
    SetFlag FLAG_HGSS_UNK_97F
    ClearFlag FLAG_HGSS_HIDE_ROUTE_10_ZAPDOS
    ClearFlag FLAG_HGSS_SG_3FBC
    ClearFlag FLAG_HGSS_SG_3FB3
    SetFlag FLAG_HGSS_HIDE_CERULEAN_CITY_MAN_OUTSIDE_CAVE
    SetVarFromValue VAR_HGSS_UNK_4096, 1
    Message msg_0454_T02GYM0101_00001
    BufferPlayerName 0
    Message msg_0454_T02GYM0101_00002
    PlayFanfare SEQ_ME_BADGE_sseq
    WaitFanfare
    Message msg_0454_T02GYM0101_00003
    GoTo _01AE
scr_seq_T02GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01FB
    Message msg_0454_T02GYM0101_00006
    CompleteFollowerPutAway
    @ HGSS: SetFollowMonInhibitState 1
    CompleteFollowerReturn
    SetVarFromValue VAR_HGSS_UNK_4127, 1
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T02GYM0101_003:
    LockAll
    GoToIfSet FLAG_HGSS_UNK_13A, _0206
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _021D
    ApplyMovement obj_T02GYM0101_sunglasses, _0444
    ApplyMovement LOCALID_PLAYER, _0452
    GoTo _0240
scr_seq_T02GYM0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0266
    Message msg_0454_T02GYM0101_00009
    GoTo _0271
_017E:
    SetFlag FLAG_HGSS_HIDE_VIRIDIAN_GYM_BLUE
    End
_0184:
    ClearFlag FLAG_HGSS_HIDE_VIRIDIAN_GYM_BLUE
    End
_018A:
    ClearFlag FLAG_HGSS_HIDE_VIRIDIAN_GYM_BLUE
    End
_0190:
    End
_0192:
    GoToIfUnset FLAG_HGSS_GOT_TM92_FROM_BLUE, _01AE
    Message msg_0454_T02GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A8:
    BlackOutFromBattle
    ReleaseAll
    End
_01AE:
    SetVar VAR_0x8004, ITEM_TM92
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0279
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM92_FROM_BLUE
    BufferPlayerName 0
    Message msg_0454_T02GYM0101_00004
    Message msg_0454_T02GYM0101_00011
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0454_T02GYM0101_00012
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BLUE
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01FB:
    Message msg_0454_T02GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0206:
    CompleteFollowerPutAway
    @ HGSS: SetFollowMonInhibitState 1
    CompleteFollowerReturn
    SetVarFromValue VAR_HGSS_UNK_4127, 1
    ReleaseAll
    End
_021D:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0283
    ApplyMovement obj_T02GYM0101_sunglasses, _045C
    ApplyMovement LOCALID_PLAYER, _0452
    GoTo _0240
_0240:
    WaitMovement
    Message msg_0454_T02GYM0101_00008
    CloseMessage
    SetFlag FLAG_HGSS_UNK_13A
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _02A6
    ApplyMovement obj_T02GYM0101_sunglasses, _046A
    GoTo _02C1
_0266:
    Message msg_0454_T02GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0271:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0279:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0283:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _02DA
    ApplyMovement obj_T02GYM0101_sunglasses, _0474
    ApplyMovement LOCALID_PLAYER, _0452
    GoTo _0240
_02A6:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _02FD
    ApplyMovement obj_T02GYM0101_sunglasses, _0482
    GoTo _02C1
_02C1:
    WaitMovement
    CompleteFollowerPutAway
    @ HGSS: SetFollowMonInhibitState 1
    CompleteFollowerReturn
    SetVarFromValue VAR_HGSS_UNK_4127, 1
    ReleaseAll
    End
_02DA:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0318
    ApplyMovement obj_T02GYM0101_sunglasses, _048C
    ApplyMovement LOCALID_PLAYER, _049A
    GoTo _0240
_02FD:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _033B
    ApplyMovement obj_T02GYM0101_sunglasses, _04A4
    GoTo _02C1
_0318:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0356
    ApplyMovement obj_T02GYM0101_sunglasses, _04AE
    ApplyMovement LOCALID_PLAYER, _049A
    GoTo _0240
_033B:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0379
    ApplyMovement obj_T02GYM0101_sunglasses, _04BC
    GoTo _02C1
_0356:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0394
    ApplyMovement obj_T02GYM0101_sunglasses, _04C6
    ApplyMovement LOCALID_PLAYER, _049A
    GoTo _0240
_0379:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _03B7
    ApplyMovement obj_T02GYM0101_sunglasses, _04D0
    GoTo _02C1
_0394:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _03D2
    ApplyMovement obj_T02GYM0101_sunglasses, _04DA
    ApplyMovement LOCALID_PLAYER, _04E4
    GoTo _0240
_03B7:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0408
    ApplyMovement obj_T02GYM0101_sunglasses, _04EE
    GoTo _02C1
_03D2:
    ApplyMovement obj_T02GYM0101_sunglasses, _04F4
    ApplyMovement LOCALID_PLAYER, _04E4
    WaitMovement
    Message msg_0454_T02GYM0101_00008
    CloseMessage
    SetFlag FLAG_HGSS_UNK_13A
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _02A6
    ApplyMovement obj_T02GYM0101_sunglasses, _046A
    GoTo _02C1
_0408:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _0423
    ApplyMovement obj_T02GYM0101_sunglasses, _04EE
    GoTo _02C1
_0423:
    ApplyMovement obj_T02GYM0101_sunglasses, _0502
    WaitMovement
    CompleteFollowerPutAway
    @ HGSS: SetFollowMonInhibitState 1
    CompleteFollowerReturn
    SetVarFromValue VAR_HGSS_UNK_4127, 1
    ReleaseAll
    End
    .balign 4, 0
_0444:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0452:
    Delay16 2
    FaceEast
    EndMovement
    .balign 4, 0
_045C:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_046A:
    WalkNormalEast 5
    FaceSouth
    EndMovement
    .balign 4, 0
_0474:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0482:
    WalkNormalEast 4
    FaceSouth
    EndMovement
    .balign 4, 0
_048C:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_049A:
    Delay8 2
    FaceEast
    EndMovement
    .balign 4, 0
_04A4:
    WalkNormalEast 3
    FaceSouth
    EndMovement
    .balign 4, 0
_04AE:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest
    EndMovement
    .balign 4, 0
_04BC:
    WalkNormalEast 2
    FaceSouth
    EndMovement
    .balign 4, 0
_04C6:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_04D0:
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
_04DA:
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_04E4:
    Delay8 2
    FaceWest
    EndMovement
    .balign 4, 0
_04EE:
    FaceSouth
    EndMovement
    .balign 4, 0
_04F4:
    FaceEast
    EmoteExclamationMark
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0502:
    WalkNormalWest
    FaceSouth
    EndMovement
    .balign 4, 0
