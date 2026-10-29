#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0567.h"


    ScriptEntry scr_seq_T23GYM0102_000
    ScriptEntry scr_seq_T23GYM0102_001
    ScriptEntry scr_seq_T23GYM0102_002
    ScriptEntry scr_seq_T23GYM0102_003
    ScriptEntry scr_seq_T23GYM0102_004
    ScriptEntry scr_seq_T23GYM0102_005
    ScriptEntry scr_seq_T23GYM0102_006
    ScriptEntry scr_seq_T23GYM0102_007
    ScriptEntry scr_seq_T23GYM0102_008
    ScriptEntry scr_seq_T23GYM0102_009
    ScriptEntry scr_seq_T23GYM0102_010
    ScriptEntry scr_seq_T23GYM0102_011
    ScriptEntry scr_seq_T23GYM0102_012
    ScriptEntry scr_seq_T23GYM0102_013
    ScriptEntry scr_seq_T23GYM0102_014
    ScriptEntry scr_seq_T23GYM0102_015
    ScriptEntry scr_seq_T23GYM0102_016
    ScriptEntryEnd
scr_seq_T23GYM0102_016:
    @ HGSS: AzaleaGymInit
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BUGSY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00CD
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _006C
    ClearFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
_006C:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BUGSY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0096
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 5, _0096
    SetFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
_0096:
    GetDayOfWeek VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00C7
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _00C7
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 1, _00C7
    ClearFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
_00C7:
    SetFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
_00CD:
    SetFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
scr_seq_T23GYM0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _017A
    Message msg_0567_T23GYM0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_BUGSY_BUGSY, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0174
    Message msg_0567_T23GYM0102_00001
    BufferPlayerName 0
    Message msg_0567_T23GYM0102_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    Message msg_0567_T23GYM0102_00003
_0136:
    SetVar VAR_0x8004, ITEM_TM89
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _016A
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM89_FROM_BUGSY
    Message msg_0567_T23GYM0102_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_016A:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0174:
    BlackOutFromBattle
    ReleaseAll
    End
_017A:
    GoToIfUnset FLAG_HGSS_GOT_TM89_FROM_BUGSY, _0136
    Message msg_0567_T23GYM0102_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T23GYM0102_000:
    End
scr_seq_T23GYM0102_002:
    @ HGSS: AzaleaGymSpinarak 0
    End
scr_seq_T23GYM0102_003:
    @ HGSS: AzaleaGymSpinarak 1
    End
scr_seq_T23GYM0102_004:
    @ HGSS: AzaleaGymSpinarak 2
    End
scr_seq_T23GYM0102_005:
    @ HGSS: AzaleaGymSpinarak 3
    End
scr_seq_T23GYM0102_006:
    @ HGSS: AzaleaGymSpinarak 4
    End
scr_seq_T23GYM0102_007:
    @ HGSS: AzaleaGymSpinarak 5
    End
scr_seq_T23GYM0102_008:
    @ HGSS: AzaleaGymSpinarak 6
    End
scr_seq_T23GYM0102_009:
    @ HGSS: AzaleaGymSpinarak 7
    End
scr_seq_T23GYM0102_010:
    @ HGSS: AzaleaGymSpinarak 8
    End
scr_seq_T23GYM0102_011:
    @ HGSS: AzaleaGymSpinarak 9
    End
scr_seq_T23GYM0102_012:
    @ HGSS: AzaleaGymSpinarak 10
    End
scr_seq_T23GYM0102_013:
    @ HGSS: AzaleaGymSpinarak 11
    End
scr_seq_T23GYM0102_014:
    @ HGSS: AzaleaGymSwitch 0
    End
scr_seq_T23GYM0102_015:
    @ HGSS: AzaleaGymSwitch 1
    End
    .balign 4, 0
