#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0606.h"

#define obj_T26GYM0101_gsgirl1 1
#define obj_T26GYM0101_gsgentleman 2

    ScriptEntry scr_seq_T26GYM0101_000
    ScriptEntry scr_seq_T26GYM0101_001
    ScriptEntry scr_seq_T26GYM0101_002
    ScriptEntry scr_seq_T26GYM0101_003
    ScriptEntry scr_seq_T26GYM0101_004
    ScriptEntry scr_seq_T26GYM0101_005
    ScriptEntry scr_seq_T26GYM0101_006
    ScriptEntry scr_seq_T26GYM0101_007
    ScriptEntryEnd
scr_seq_T26GYM0101_007:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _015C
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _015A
    ClearFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _007A
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _0072
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _0078
_0072:
    GoTo _009D
_0078:
    End
_007A:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _0095
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _009B
_0095:
    GoTo _009D
_009B:
    End
_009D:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_ERIKA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _015A
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _00CB
    GoTo _015A
    End
_00CB:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _00E8
    GoTo _0109
_00E2:
    GoTo _0107
_00E8:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0101
    GoTo _0109
_00FB:
    GoTo _0107
_0101:
    GoTo _015A
_0107:
    End
_0109:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _0124
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _0158
_0124:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _013B
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _0158
_013B:
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0152
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _0158
_0152:
    GoTo _015A
_0158:
    End
_015A:
    End
_015C:
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    End
scr_seq_T26GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _020C
    Message msg_0606_T26GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_JASMINE_JASMINE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0235
    Message msg_0606_T26GYM0101_00001
    BufferPlayerName 0
    Message msg_0606_T26GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    AddVar VAR_HGSS_MIDGAME_BADGES, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    CompareVar VAR_HGSS_MIDGAME_BADGES, 3
    GoToIf 5, _01CB
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 1
_01CB:
    Message msg_0606_T26GYM0101_00003
_01CE:
    SetVar VAR_0x8004, ITEM_TM23
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0202
    Common_GiveItemQuantity
    Message msg_0606_T26GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_TM23_FROM_JASMINE
    End
_0202:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_020C:
    GoToIfUnset FLAG_HGSS_GOT_TM23_FROM_JASMINE, _01CE
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _023B
    Message msg_0606_T26GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0235:
    BlackOutFromBattle
    ReleaseAll
    End
_023B:
    GoToIfSet FLAG_HGSS_TRADE_JASMINE_STEELIX, _036F
    CompareVar VAR_MAP_LOCAL_0x00, 77
    GoToIf 1, _0264
    SetVarFromValue VAR_MAP_LOCAL_0x00, 77
    Message msg_0606_T26GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0264:
    Message msg_0606_T26GYM0101_00008
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _034B
    Message msg_0606_T26GYM0101_00009
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_566
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _034B
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_MAP_LOCAL_0x03
    GetPartyMonForm2 VAR_0x8004, VAR_MAP_LOCAL_0x04
    CompareVar VAR_MAP_LOCAL_0x03, 0
    GoToIf 1, _0356
    CompareVar VAR_MAP_LOCAL_0x04, 0
    GoToIf 1, _030E
    CompareVar VAR_MAP_LOCAL_0x03, 487
    GoToIf 1, _0364
    CompareVar VAR_MAP_LOCAL_0x03, 492
    GoToIf 1, _0364
    CompareVar VAR_MAP_LOCAL_0x03, 172
    GoToIf 1, _0364
    CompareVar VAR_MAP_LOCAL_0x03, 479
    GoToIf 1, _0364
_030E:
    BufferPartyMonNickname 1, VAR_0x8004
    Message msg_0606_T26GYM0101_00013
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _034B
    CloseMessage
    @ HGSS: LoadNPCTrade 5
    @ HGSS: NPCTradeExec VAR_SPECIAL_x8004
    @ HGSS: NPCTradeEnd
    SetFlag FLAG_HGSS_TRADE_JASMINE_STEELIX
    SetVarFromValue VAR_MAP_LOCAL_0x00, 55
    Message msg_0606_T26GYM0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_034B:
    Message msg_0606_T26GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0356:
    BufferPlayerName 0
    Message msg_0606_T26GYM0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0364:
    Message msg_0606_T26GYM0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_036F:
    CompareVar VAR_MAP_LOCAL_0x00, 55
    GoToIf 5, _0385
    Message msg_0606_T26GYM0101_00011
    GoTo _0388
_0385:
    Message msg_0606_T26GYM0101_00012
_0388:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T26GYM0101_001:
    LockAll
    ApplyMovement obj_T26GYM0101_gsgentleman, _040C
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _03BF
    ApplyMovement obj_T26GYM0101_gsgentleman, _0414
    GoTo _03E2
_03BF:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _03DA
    ApplyMovement obj_T26GYM0101_gsgentleman, _041C
    GoTo _03E2
_03DA:
    ApplyMovement obj_T26GYM0101_gsgentleman, _0424
_03E2:
    ApplyMovement LOCALID_PLAYER, _042C
    WaitMovement
    Message msg_0606_T26GYM0101_00019
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 1
    GoToIf 5, _0408
    SetVarFromValue VAR_HGSS_UNK_410E, 2
_0408:
    End
    .balign 4, 0
_040C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0414:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_041C:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0424:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_042C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0434:
    WalkOnSpotNormalEast
    EndMovement
scr_seq_T26GYM0101_002:
    LockAll
    ApplyMovement obj_T26GYM0101_gsgirl1, _040C
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _046B
    ApplyMovement obj_T26GYM0101_gsgirl1, _04B8
    GoTo _048E
_046B:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0486
    ApplyMovement obj_T26GYM0101_gsgirl1, _04C0
    GoTo _048E
_0486:
    ApplyMovement obj_T26GYM0101_gsgirl1, _04C8
_048E:
    ApplyMovement LOCALID_PLAYER, _0434
    WaitMovement
    Message msg_0606_T26GYM0101_00021
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 2
    GoToIf 5, _04B4
    SetVarFromValue VAR_HGSS_UNK_410E, 3
_04B4:
    End
    .balign 4, 0
_04B8:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_04C0:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_04C8:
    WalkNormalWest
    EndMovement
scr_seq_T26GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04F4
    Message msg_0606_T26GYM0101_00020
    GoTo _04F7
_04F4:
    Message msg_0606_T26GYM0101_00019
_04F7:
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 1
    GoToIf 5, _0510
    SetVarFromValue VAR_HGSS_UNK_410E, 2
_0510:
    End
scr_seq_T26GYM0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0536
    Message msg_0606_T26GYM0101_00022
    GoTo _0539
_0536:
    Message msg_0606_T26GYM0101_00021
_0539:
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 2
    GoToIf 5, _0552
    SetVarFromValue VAR_HGSS_UNK_410E, 3
_0552:
    End
scr_seq_T26GYM0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0590
    CompareVar VAR_HGSS_UNK_410E, 0
    GoToIf 5, _0585
    Message msg_0606_T26GYM0101_00016
    GoTo _0588
_0585:
    Message msg_0606_T26GYM0101_00017
_0588:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0590:
    Message msg_0606_T26GYM0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T26GYM0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _05C2
    Message msg_0606_T26GYM0101_00023
    GoTo _05C5
_05C2:
    Message msg_0606_T26GYM0101_00024
_05C5:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
