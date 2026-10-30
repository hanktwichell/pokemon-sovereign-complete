#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0066.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D23R0102_policeman 3
#define obj_D23R0102_gswoman2_2 8
#define obj_D23R0102_gswoman1 9

    ScriptEntry scr_seq_D23R0102_000
    ScriptEntry scr_seq_D23R0102_001
    ScriptEntry scr_seq_D23R0102_002
    ScriptEntry scr_seq_D23R0102_003
    ScriptEntry scr_seq_D23R0102_004
    ScriptEntry scr_seq_D23R0102_005
    ScriptEntry scr_seq_D23R0102_006
    ScriptEntry scr_seq_D23R0102_007
    ScriptEntry scr_seq_D23R0102_008
    ScriptEntry scr_seq_D23R0102_009
    ScriptEntry scr_seq_D23R0102_010
    ScriptEntryEnd
scr_seq_D23R0102_007:
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _004D
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    GoTo _0068
_004D:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 4, _0064
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    GoTo _0068
_0064:
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
_0068:
    End
scr_seq_D23R0102_008:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 5
    GoToIf 5, _0083
    SetPosition obj_D23R0102_policeman, 2, 1, 7, DIR_EAST
_0083:
    End
scr_seq_D23R0102_000:
    NPCMessage msg_0066_D23R0102_00006
    End
scr_seq_D23R0102_001:
    NPCMessage msg_0066_D23R0102_00007
    End
scr_seq_D23R0102_002:
    NPCMessage msg_0066_D23R0102_00008
    End
scr_seq_D23R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_JIGGLYPUFF, 0
    Message msg_0066_D23R0102_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0102_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _00F7
    Message msg_0066_D23R0102_00002
    GoTo _00FA
_00F7:
    Message msg_0066_D23R0102_00001
_00FA:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0102_005:
    NPCMessage msg_0066_D23R0102_00000
    End
scr_seq_D23R0102_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 5
    GoToIf 5, _0133
    Message msg_0066_D23R0102_00005
    GoTo _0136
_0133:
    Message msg_0066_D23R0102_00004
_0136:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0102_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _015C
    Message msg_0066_D23R0102_00009
    GoTo _0162
_015C:
    GoTo _016A
_0162:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_016A:
    CheckItem ITEM_BLUE_CARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _01B5
    Message msg_0066_D23R0102_00010
    CloseMessage
    SetVar VAR_0x8004, ITEM_BLUE_CARD
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0539
    Common_GiveItemQuantity
    CloseMessage
    AddVar VAR_HGSS_NUM_TIMES_GIVEN_BLUE_CARD, 1
    ReleaseAll
    End
_01B5:
    CompareVar VAR_HGSS_NUM_TIMES_GIVEN_BLUE_CARD, 2
    GoToIf 0, _01CF
    BufferPlayerName 0
    MessageGendered msg_0066_D23R0102_00012, msg_0066_D23R0102_00013
    GoTo _01D2
_01CF:
    Message msg_0066_D23R0102_00011
_01D2:
    CloseMessage
    GoToIfSet FLAG_HGSS_DAILY_HEARD_BUENAS_PASSWORD, _01EA
    Message msg_0066_D23R0102_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01EA:
    GoToIfSet FLAG_HGSS_DAILY_BUENAS_PASSWORD, _0547
    Message msg_0066_D23R0102_00014
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0552
    BufferPlayerName 0
    CompareVar VAR_HGSS_NUM_TIMES_GIVEN_BLUE_CARD, 2
    GoToIf 0, _0227
    MessageGendered msg_0066_D23R0102_00017, msg_0066_D23R0102_00018
    GoTo _022B
_0227:
    MessageGendered msg_0066_D23R0102_00015, msg_0066_D23R0102_00016
_022B:
    CloseMessage
    ApplyMovement obj_D23R0102_gswoman1, _0620
    WaitMovement
    MessageGendered msg_0066_D23R0102_00020, msg_0066_D23R0102_00021
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0295
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0279
    ApplyMovement LOCALID_PLAYER, _05CC
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _05E0
    GoTo _0289
_0279:
    ApplyMovement LOCALID_PLAYER, _05F0
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0600
_0289:
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    GoTo _02BA
_0295:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _02B0
    ApplyMovement LOCALID_PLAYER, _05CC
    GoTo _02B8
_02B0:
    ApplyMovement LOCALID_PLAYER, _05F0
_02B8:
    WaitMovement
_02BA:
    @ HGSS: GetBuenasPassword VAR_SPECIAL_x8000, VAR_SPECIAL_x8001
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry VAR_0x8000, 0
    AddVar VAR_0x8000, 1
    AddMenuEntry VAR_0x8000, 1
    AddVar VAR_0x8000, 1
    AddMenuEntry VAR_0x8000, 2
    ShowMenu
    SetFlag FLAG_HGSS_UNK_102
    SetFlag FLAG_HGSS_DAILY_BUENAS_PASSWORD
    ApplyMovement obj_D23R0102_gswoman1, _0628
    WaitMovement
    CompareVar VAR_RESULT, VAR_0x8001
    GoToIf 5, _055D
    Message msg_0066_D23R0102_00022
    ApplyMovement obj_D23R0102_gswoman1, _0630
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _060C
    WaitMovement
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 30
    GoToIf 4, _033F
    AddVar VAR_HGSS_BLUE_CARD_POINTS, 1
_033F:
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 30
    GoToIf 0, _0387
    CompareVar VAR_HGSS_NUM_TIMES_GIVEN_BLUE_CARD, 2
    GoToIf 4, _0387
    ApplyMovement obj_D23R0102_gswoman1, _0628
    WaitMovement
    MessageGendered msg_0066_D23R0102_00024, msg_0066_D23R0102_00025
    CloseMessage
    CompletePhoneRegister PHONE_CONTACT_BUENA
    Message msg_0066_D23R0102_00026
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CloseMessage
    ApplyMovement obj_D23R0102_gswoman1, _0628
    WaitMovement
    Message msg_0066_D23R0102_00027
    CloseMessage
_0387:
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 1
    GoToIf 1, _0499
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 3
    GoToIf 1, _04AD
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 5
    GoToIf 1, _04C1
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 10
    GoToIf 1, _04D5
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 15
    GoToIf 1, _04E9
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 20
    GoToIf 1, _04FD
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 25
    GoToIf 1, _0511
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 30
    GoToIf 1, _0525
    GoTo _0568
_03F5:
    Message msg_0066_D23R0102_00032
    CloseMessage
    ApplyMovement obj_D23R0102_gswoman1, _0638
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D23R0102_gswoman2_2, _0648
    ApplyMovement LOCALID_PLAYER, _0614
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferNumber 0, VAR_HGSS_BLUE_CARD_POINTS
    BufferItemName 1, VAR_0x8004
    Message msg_0066_D23R0102_00035
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0539
    Common_GiveItemQuantity
_0450:
    CompareVar VAR_HGSS_BLUE_CARD_POINTS, 30
    GoToIf 0, _0486
    Message msg_0066_D23R0102_00036
    CloseMessage
    PlayFanfare SEQ_ME_KEYITEM_sseq
    Message msg_0066_D23R0102_00037
    WaitFanfare
    CloseMessage
    CompareVar VAR_HGSS_NUM_TIMES_GIVEN_BLUE_CARD, 255
    GoToIf 4, _0480
    AddVar VAR_HGSS_NUM_TIMES_GIVEN_BLUE_CARD, 1
_0480:
    SetVarFromValue VAR_HGSS_BLUE_CARD_POINTS, 0
_0486:
    Message msg_0066_D23R0102_00038
    CloseMessage
    ApplyMovement obj_D23R0102_gswoman2_2, _0654
    WaitMovement
    ReleaseAll
    End
_0499:
    SetVarFromValue VAR_0x8004, ITEM_POKE_BALL
    SetVarFromValue VAR_0x8005, 1
    GoTo _03F5
    End
_04AD:
    SetVarFromValue VAR_0x8004, ITEM_FULL_RESTORE
    SetVarFromValue VAR_0x8005, 1
    GoTo _03F5
    End
_04C1:
    SetVarFromValue VAR_0x8004, ITEM_PROTEIN
    SetVarFromValue VAR_0x8005, 1
    GoTo _03F5
    End
_04D5:
    SetVarFromValue VAR_0x8004, ITEM_IRON
    SetVarFromValue VAR_0x8005, 1
    GoTo _03F5
    End
_04E9:
    SetVarFromValue VAR_0x8004, ITEM_CARBOS
    SetVarFromValue VAR_0x8005, 1
    GoTo _03F5
    End
_04FD:
    SetVarFromValue VAR_0x8004, ITEM_NUGGET
    SetVarFromValue VAR_0x8005, 1
    GoTo _03F5
    End
_0511:
    SetVarFromValue VAR_0x8004, ITEM_RARE_CANDY
    SetVarFromValue VAR_0x8005, 1
    GoTo _03F5
    End
_0525:
    SetVarFromValue VAR_0x8004, ITEM_HP_UP
    SetVarFromValue VAR_0x8005, 1
    GoTo _03F5
    End
_0539:
    Common_MessageBagIsFull
    CloseMessage
    GoTo _0450
    End
_0547:
    Message msg_0066_D23R0102_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0552:
    Message msg_0066_D23R0102_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_055D:
    Message msg_0066_D23R0102_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0568:
    Message msg_0066_D23R0102_00032
    CloseMessage
    ApplyMovement obj_D23R0102_gswoman1, _0638
    WaitMovement
    ReleaseAll
    End
scr_seq_D23R0102_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 1, _05C0
    CheckItem ITEM_BLUE_CARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _05B0
    Message msg_0066_D23R0102_00033
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05B0:
    BufferNumber 0, VAR_HGSS_BLUE_CARD_POINTS
    Message msg_0066_D23R0102_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05C0:
    Message msg_0066_D23R0102_00039
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_05CC:
    FaceSouth
    WalkNormalSouth 2
    WalkNormalWest
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_05E0:
    WalkNormalSouth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05F0:
    FaceSouth
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0600:
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_060C:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0614:
    WalkNormalSouth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0620:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0628:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0630:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0638:
    FaceNorth
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0648:
    WalkNormalSouth 2
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0654:
    WalkNormalWest 3
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
