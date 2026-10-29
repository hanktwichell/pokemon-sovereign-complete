#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0485.h"

#define obj_T06GYM0101_stop 0
#define obj_T06GYM0101_stop_2 1
#define obj_T06GYM0101_stop_3 2
#define obj_T06GYM0101_stop_4 3
#define obj_T06GYM0101_stop_5 4
#define obj_T06GYM0101_stop_6 5

    ScriptEntry scr_seq_T06GYM0101_000
    ScriptEntry scr_seq_T06GYM0101_001
    ScriptEntry scr_seq_T06GYM0101_002
    ScriptEntry scr_seq_T06GYM0101_003
    ScriptEntry scr_seq_T06GYM0101_004
    ScriptEntry scr_seq_T06GYM0101_005
    ScriptEntry scr_seq_T06GYM0101_006
    ScriptEntry scr_seq_T06GYM0101_007
    ScriptEntry scr_seq_T06GYM0101_008
    ScriptEntry scr_seq_T06GYM0101_009
    ScriptEntry scr_seq_T06GYM0101_010
    ScriptEntry scr_seq_T06GYM0101_011
    ScriptEntry scr_seq_T06GYM0101_012
    ScriptEntry scr_seq_T06GYM0101_013
    ScriptEntry scr_seq_T06GYM0101_014
    ScriptEntry scr_seq_T06GYM0101_015
    ScriptEntry scr_seq_T06GYM0101_016
    ScriptEntry scr_seq_T06GYM0101_017
    ScriptEntry scr_seq_T06GYM0101_018
    ScriptEntry scr_seq_T06GYM0101_019
    ScriptEntry scr_seq_T06GYM0101_020
    ScriptEntry scr_seq_T06GYM0101_021
    ScriptEntry scr_seq_T06GYM0101_022
    ScriptEntry scr_seq_T06GYM0101_023
    ScriptEntry scr_seq_T06GYM0101_024
    ScriptEntry scr_seq_T06GYM0101_025
    ScriptEntryEnd
scr_seq_T06GYM0101_021:
    GoToIfSet FLAG_HGSS_HIDE_VERMILION_GYM_STOPS, _0271
    ClearFlag FLAG_HGSS_SYS_SOLVED_LT_SURGE_GYM
    @ HGSS: VermilionGymInit
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _02BF
    GoToIfUnset FLAG_HGSS_CAUGHT_ZAPDOS, _02C5
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _02CB
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _02DC
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _02F3
scr_seq_T06GYM0101_022:
    GoToIfSet FLAG_HGSS_HIDE_VERMILION_GYM_STOPS, _02F5
    ShowObject obj_T06GYM0101_stop
    ShowObject obj_T06GYM0101_stop_2
    ShowObject obj_T06GYM0101_stop_3
    ShowObject obj_T06GYM0101_stop_4
    ShowObject obj_T06GYM0101_stop_5
    ShowObject obj_T06GYM0101_stop_6
    End
scr_seq_T06GYM0101_000:
    @ HGSS: VermilionGymCanCheck 0, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_001:
    @ HGSS: VermilionGymCanCheck 1, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_002:
    @ HGSS: VermilionGymCanCheck 2, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_003:
    @ HGSS: VermilionGymCanCheck 3, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_004:
    @ HGSS: VermilionGymCanCheck 4, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_005:
    @ HGSS: VermilionGymCanCheck 5, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_006:
    @ HGSS: VermilionGymCanCheck 6, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_007:
    @ HGSS: VermilionGymCanCheck 7, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_008:
    @ HGSS: VermilionGymCanCheck 8, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_009:
    @ HGSS: VermilionGymCanCheck 9, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_010:
    @ HGSS: VermilionGymCanCheck 10, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_011:
    @ HGSS: VermilionGymCanCheck 11, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_012:
    @ HGSS: VermilionGymCanCheck 12, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_013:
    @ HGSS: VermilionGymCanCheck 13, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_014:
    @ HGSS: VermilionGymCanCheck 14, VAR_SPECIAL_RESULT
    GoTo _02F7
scr_seq_T06GYM0101_015:
    End
scr_seq_T06GYM0101_016:
    End
scr_seq_T06GYM0101_017:
    End
scr_seq_T06GYM0101_018:
    End
scr_seq_T06GYM0101_019:
    End
scr_seq_T06GYM0101_020:
    End
scr_seq_T06GYM0101_023:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _033A
    Message msg_0485_T06GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_LT_SURGE_LT__SURGE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0350
    AddVar VAR_HGSS_UNK_4135, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_STOPS
    RemoveObject obj_T06GYM0101_stop
    RemoveObject obj_T06GYM0101_stop_2
    RemoveObject obj_T06GYM0101_stop_3
    RemoveObject obj_T06GYM0101_stop_4
    RemoveObject obj_T06GYM0101_stop_5
    RemoveObject obj_T06GYM0101_stop_6
    SetTrainerFlag TRAINER_HGSS_GUITARIST_VINCENT
    SetTrainerFlag TRAINER_HGSS_GENTLEMAN_GREGORY
    SetTrainerFlag TRAINER_HGSS_JUGGLER_HORTON
    Message msg_0485_T06GYM0101_00001
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0485_T06GYM0101_00003
    GoTo _0356
scr_seq_T06GYM0101_024:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03A0
    Message msg_0485_T06GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T06GYM0101_025:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03AB
    Message msg_0485_T06GYM0101_00013
    GoTo _03B6
_0271:
    @ HGSS: VermilionGymInit
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _02BF
    GoToIfUnset FLAG_HGSS_CAUGHT_ZAPDOS, _02C5
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _02CB
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _02DC
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _02F3
_02BF:
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    End
_02C5:
    ClearFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    End
_02CB:
    GoToIfSet FLAG_HGSS_TRADE_LT_SURGE_PIKACHU, _03BE
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    End
_02DC:
    CompareVar VAR_MAP_LOCAL_0x00, 10
    GoToIf 5, _03D9
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _02F3
_02F3:
    End
_02F5:
    End
_02F7:
    CompareVar VAR_RESULT, 4
    GoToIf 1, _03F0
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0401
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0425
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0441
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0458
    End
_033A:
    GoToIfUnset FLAG_HGSS_GOT_TM34_FROM_LT_SURGE, _0356
    Message msg_0485_T06GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0350:
    BlackOutFromBattle
    ReleaseAll
    End
_0356:
    SetVar VAR_0x8004, ITEM_TM34
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0469
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM34_FROM_LT_SURGE
    Message msg_0485_T06GYM0101_00004
    Message msg_0485_T06GYM0101_00015
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00016
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_LT__SURGE
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03A0:
    Message msg_0485_T06GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03AB:
    Message msg_0485_T06GYM0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03B6:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03BE:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0473
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _048A
_03D9:
    CompareVar VAR_MAP_LOCAL_0x00, 11
    GoToIf 5, _048C
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _02F3
_03F0:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0401:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0485_T06GYM0101_00009
    WaitButton
    CloseMessage
    @ HGSS: VermilionGymLockAction 1, 0
    SetFlag FLAG_HGSS_SYS_SOLVED_LT_SURGE_GYM
    Message msg_0485_T06GYM0101_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0425:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0485_T06GYM0101_00009
    WaitButton
    CloseMessage
    @ HGSS: VermilionGymLockAction 0, 0
    Message msg_0485_T06GYM0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0441:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0485_T06GYM0101_00010
    WaitButton
    CloseMessage
    @ HGSS: VermilionGymLockAction 0, 1
    @ HGSS: ResampleVermilionGymCans
    ReleaseAll
    End
_0458:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0469:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0473:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0492
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _048A
_048A:
    End
_048C:
    ClearFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    End
_0492:
    ClearFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    End
    .balign 4, 0
