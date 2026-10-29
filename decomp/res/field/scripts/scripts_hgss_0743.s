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
    GoToIf 5, _0065
    CompareVar VAR_HGSS_UNK_40FD, 0
    GoToIf 1, _005F
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 5, _0059
    SetFlag FLAG_HGSS_HIDE_VIRIDIAN_GYM_BLUE
    GoTo _005D
_0059:
    ClearFlag FLAG_HGSS_HIDE_VIRIDIAN_GYM_BLUE
_005D:
    End
_005F:
    ClearFlag FLAG_HGSS_HIDE_VIRIDIAN_GYM_BLUE
    End
_0065:
    SetFlag FLAG_HGSS_HIDE_VIRIDIAN_GYM_BLUE
    End
scr_seq_T02GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0131
    Message msg_0454_T02GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_BLUE_BLUE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0147
    AddVar VAR_HGSS_UNK_4135, 1
    SetFlag FLAG_HGSS_UNK_998
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetFlag FLAG_HGSS_UNK_97F
    ClearFlag FLAG_HGSS_HIDE_ROUTE_10_ZAPDOS
    SetFlag FLAG_HGSS_HIDE_CERULEAN_CITY_MAN_OUTSIDE_CAVE
    SetVarFromValue VAR_HGSS_UNK_4096, 1
    Message msg_0454_T02GYM0101_00001
    BufferPlayerName 0
    Message msg_0454_T02GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0454_T02GYM0101_00003
    GoTo _00F0
_00F0:
    SetVar VAR_0x8004, ITEM_TM92
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0127
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM92_FROM_BLUE
    BufferPlayerName 0
    Message msg_0454_T02GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0127:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0131:
    GoToIfUnset FLAG_HGSS_GOT_TM92_FROM_BLUE, _00F0
    Message msg_0454_T02GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0147:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T02GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0186
    Message msg_0454_T02GYM0101_00006
    @ HGSS: ScrCmd_600
    @ HGSS: SetFollowMonInhibitState 1
    @ HGSS: ScrCmd_607
    @ HGSS: ScrCmd_109 253, 56
    SetVarFromValue VAR_HGSS_UNK_4127, 1
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0186:
    Message msg_0454_T02GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T02GYM0101_003:
    LockAll
    GoToIfSet FLAG_HGSS_UNK_13A, _037D
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _01C9
    ApplyMovement obj_T02GYM0101_sunglasses, _0394
    ApplyMovement LOCALID_PLAYER, _040C
    GoTo _02AB
_01C9:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _01EC
    ApplyMovement obj_T02GYM0101_sunglasses, _03A4
    ApplyMovement LOCALID_PLAYER, _040C
    GoTo _02AB
_01EC:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _020F
    ApplyMovement obj_T02GYM0101_sunglasses, _03B4
    ApplyMovement LOCALID_PLAYER, _040C
    GoTo _02AB
_020F:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0232
    ApplyMovement obj_T02GYM0101_sunglasses, _03C4
    ApplyMovement LOCALID_PLAYER, _0418
    GoTo _02AB
_0232:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0255
    ApplyMovement obj_T02GYM0101_sunglasses, _03D4
    ApplyMovement LOCALID_PLAYER, _0418
    GoTo _02AB
_0255:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0278
    ApplyMovement obj_T02GYM0101_sunglasses, _03E4
    ApplyMovement LOCALID_PLAYER, _0418
    GoTo _02AB
_0278:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _029B
    ApplyMovement obj_T02GYM0101_sunglasses, _03F0
    ApplyMovement LOCALID_PLAYER, _0424
    GoTo _02AB
_029B:
    ApplyMovement obj_T02GYM0101_sunglasses, _03FC
    ApplyMovement LOCALID_PLAYER, _0424
_02AB:
    WaitMovement
    Message msg_0454_T02GYM0101_00008
    CloseMessage
    SetFlag FLAG_HGSS_UNK_13A
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _02D1
    ApplyMovement obj_T02GYM0101_sunglasses, _0430
    GoTo _037B
_02D1:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _02EC
    ApplyMovement obj_T02GYM0101_sunglasses, _043C
    GoTo _037B
_02EC:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0307
    ApplyMovement obj_T02GYM0101_sunglasses, _0448
    GoTo _037B
_0307:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0322
    ApplyMovement obj_T02GYM0101_sunglasses, _0454
    GoTo _037B
_0322:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _033D
    ApplyMovement obj_T02GYM0101_sunglasses, _0460
    GoTo _037B
_033D:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0358
    ApplyMovement obj_T02GYM0101_sunglasses, _046C
    GoTo _037B
_0358:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _0373
    ApplyMovement obj_T02GYM0101_sunglasses, _046C
    GoTo _037B
_0373:
    ApplyMovement obj_T02GYM0101_sunglasses, _0474
_037B:
    WaitMovement
_037D:
    @ HGSS: ScrCmd_600
    @ HGSS: SetFollowMonInhibitState 1
    @ HGSS: ScrCmd_607
    @ HGSS: ScrCmd_109 253, 56
    SetVarFromValue VAR_HGSS_UNK_4127, 1
    ReleaseAll
    End
    .balign 4, 0
_0394:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_03A4:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_03B4:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_03C4:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_03D4:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest
    EndMovement
    .balign 4, 0
_03E4:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03F0:
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03FC:
    FaceEast
    EmoteExclamationMark
    WalkNormalEast
    EndMovement
    .balign 4, 0
_040C:
    Delay16 2
    FaceEast
    EndMovement
    .balign 4, 0
_0418:
    Delay8 2
    FaceEast
    EndMovement
    .balign 4, 0
_0424:
    Delay8 2
    FaceWest
    EndMovement
    .balign 4, 0
_0430:
    WalkNormalEast 5
    FaceSouth
    EndMovement
    .balign 4, 0
_043C:
    WalkNormalEast 4
    FaceSouth
    EndMovement
    .balign 4, 0
_0448:
    WalkNormalEast 3
    FaceSouth
    EndMovement
    .balign 4, 0
_0454:
    WalkNormalEast 2
    FaceSouth
    EndMovement
    .balign 4, 0
_0460:
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
_046C:
    FaceSouth
    EndMovement
    .balign 4, 0
_0474:
    WalkNormalWest
    FaceSouth
    EndMovement
scr_seq_T02GYM0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04A7
    Message msg_0454_T02GYM0101_00009
    GoTo _04AA
_04A7:
    Message msg_0454_T02GYM0101_00010
_04AA:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
