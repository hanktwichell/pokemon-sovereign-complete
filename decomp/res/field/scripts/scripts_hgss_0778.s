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
    GoToIfSet FLAG_HGSS_HIDE_VERMILION_GYM_STOPS, _0079
    ClearFlag FLAG_HGSS_SYS_SOLVED_LT_SURGE_GYM
_0079:
    @ HGSS: VermilionGymInit
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _014A
    GoToIfUnset FLAG_HGSS_CAUGHT_ZAPDOS, _0144
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00FB
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _00C7
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _00F9
_00C7:
    CompareVar VAR_MAP_LOCAL_0x00, 10
    GoToIf 5, _00DE
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _00F9
_00DE:
    CompareVar VAR_MAP_LOCAL_0x00, 11
    GoToIf 5, _00F5
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _00F9
_00F5:
    ClearFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
_00F9:
    End
_00FB:
    GoToIfSet FLAG_HGSS_TRADE_LT_SURGE_PIKACHU, _010C
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    End
_010C:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0127
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _0142
_0127:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _013E
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    GoTo _0142
_013E:
    ClearFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
_0142:
    End
_0144:
    ClearFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    End
_014A:
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_LT_SURGE
    End
scr_seq_T06GYM0101_022:
    GoToIfSet FLAG_HGSS_HIDE_VERMILION_GYM_STOPS, _0175
    ShowObject obj_T06GYM0101_stop
    ShowObject obj_T06GYM0101_stop_2
    ShowObject obj_T06GYM0101_stop_3
    ShowObject obj_T06GYM0101_stop_4
    ShowObject obj_T06GYM0101_stop_5
    ShowObject obj_T06GYM0101_stop_6
    End
_0175:
    End
scr_seq_T06GYM0101_000:
    @ HGSS: VermilionGymCanCheck 0, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_001:
    @ HGSS: VermilionGymCanCheck 1, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_002:
    @ HGSS: VermilionGymCanCheck 2, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_003:
    @ HGSS: VermilionGymCanCheck 3, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_004:
    @ HGSS: VermilionGymCanCheck 4, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_005:
    @ HGSS: VermilionGymCanCheck 5, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_006:
    @ HGSS: VermilionGymCanCheck 6, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_007:
    @ HGSS: VermilionGymCanCheck 7, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_008:
    @ HGSS: VermilionGymCanCheck 8, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_009:
    @ HGSS: VermilionGymCanCheck 9, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_010:
    @ HGSS: VermilionGymCanCheck 10, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_011:
    @ HGSS: VermilionGymCanCheck 11, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_012:
    @ HGSS: VermilionGymCanCheck 12, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_013:
    @ HGSS: VermilionGymCanCheck 13, VAR_SPECIAL_RESULT
    GoTo _023A
    End
scr_seq_T06GYM0101_014:
    @ HGSS: VermilionGymCanCheck 14, VAR_SPECIAL_RESULT
    GoTo _023A
    End
_023A:
    CompareVar VAR_RESULT, 4
    GoToIf 1, _027D
    CompareVar VAR_RESULT, 2
    GoToIf 1, _02AA
    CompareVar VAR_RESULT, 1
    GoToIf 1, _028E
    CompareVar VAR_RESULT, 3
    GoToIf 1, _02CE
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02E5
    End
_027D:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_028E:
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
_02AA:
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
_02CE:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0485_T06GYM0101_00010
    WaitButton
    CloseMessage
    @ HGSS: VermilionGymLockAction 0, 1
    @ HGSS: ResampleVermilionGymCans
    ReleaseAll
    End
_02E5:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
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
    GoToIf 1, _03C7
    Message msg_0485_T06GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_LT_SURGE_LT__SURGE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03DD
    AddVar VAR_HGSS_UNK_4135, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetFlag FLAG_HGSS_HIDE_VERMILION_GYM_STOPS
    RemoveObject obj_T06GYM0101_stop
    RemoveObject obj_T06GYM0101_stop_2
    RemoveObject obj_T06GYM0101_stop_3
    RemoveObject obj_T06GYM0101_stop_4
    RemoveObject obj_T06GYM0101_stop_5
    RemoveObject obj_T06GYM0101_stop_6
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    Message msg_0485_T06GYM0101_00001
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0485_T06GYM0101_00003
    GoTo _0389
_0389:
    SetVar VAR_0x8004, ITEM_TM34
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _03BD
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM34_FROM_LT_SURGE
    Message msg_0485_T06GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03BD:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_03C7:
    GoToIfUnset FLAG_HGSS_GOT_TM34_FROM_LT_SURGE, _0389
    Message msg_0485_T06GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03DD:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T06GYM0101_024:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0409
    Message msg_0485_T06GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0409:
    Message msg_0485_T06GYM0101_00007
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
    GoToIf 5, _043B
    Message msg_0485_T06GYM0101_00013
    GoTo _043E
_043B:
    Message msg_0485_T06GYM0101_00014
_043E:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
