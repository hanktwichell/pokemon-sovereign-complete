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
    GoToIf 5, _015E
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0164
    ClearFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
scr_seq_T23GYM0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _018E
    Message msg_0567_T23GYM0102_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_BUGSY_BUGSY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A4
    Message msg_0567_T23GYM0102_00001
    BufferPlayerName 0
    Message msg_0567_T23GYM0102_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    SetTrainerFlag TRAINER_HGSS_BUG_CATCHER_AL
    SetTrainerFlag TRAINER_HGSS_BUG_CATCHER_BENNY
    SetTrainerFlag TRAINER_HGSS_BUG_CATCHER_JOSH
    SetTrainerFlag TRAINER_HGSS_TWINS_AMY_AND_MIMI
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    Message msg_0567_T23GYM0102_00003
    SetVar VAR_0x8004, ITEM_TM89
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01AA
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM89_FROM_BUGSY
    Message msg_0567_T23GYM0102_00005
    Message msg_0567_T23GYM0102_00008
    BufferPlayerName 0
    Message msg_0567_T23GYM0102_00009
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BUGSY
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
_015E:
    SetFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
_0164:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BUGSY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01B4
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 5, _01B4
    SetFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
_018E:
    GoToIfUnset FLAG_HGSS_GOT_TM89_FROM_BUGSY, _01E5
    Message msg_0567_T23GYM0102_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A4:
    BlackOutFromBattle
    ReleaseAll
    End
_01AA:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_01B4:
    GetDayOfWeek VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0211
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _0211
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 1, _0211
    ClearFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
_01E5:
    SetVar VAR_0x8004, ITEM_TM89
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01AA
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM89_FROM_BUGSY
    Message msg_0567_T23GYM0102_00005
_0211:
    SetFlag FLAG_HGSS_HIDE_AZALEA_GYM_BUGSY
    End
    .balign 4, 0
