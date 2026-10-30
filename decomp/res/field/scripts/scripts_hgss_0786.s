#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0492.h"


    ScriptEntry scr_seq_T07GYM0101_000
    ScriptEntry scr_seq_T07GYM0101_001
    ScriptEntry scr_seq_T07GYM0101_002
    ScriptEntryEnd
scr_seq_T07GYM0101_002:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_ERIKA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00E9
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_ERIKA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00EF
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _010A
    GoTo _0121
scr_seq_T07GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0127
    Message msg_0492_T07GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_ERIKA_ERIKA, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _013D
    SetVarFromValue VAR_HGSS_SG_6135, 2
    AddVar VAR_HGSS_UNK_4135, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_HGSS_TWINS_JO_AND_ZOE
    SetTrainerFlag TRAINER_HGSS_LASS_MICHELLE
    SetTrainerFlag TRAINER_HGSS_PICNICKER_TANYA
    SetTrainerFlag TRAINER_HGSS_BEAUTY_JULIA
    Message msg_0492_T07GYM0101_00001
    BufferPlayerName 0
    Message msg_0492_T07GYM0101_00002
    PlayFanfare SEQ_ME_BADGE_sseq
    WaitFanfare
    Message msg_0492_T07GYM0101_00003
    GoTo _0143
scr_seq_T07GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0198
    Message msg_0492_T07GYM0101_00005
    GoTo _01A3
_00E9:
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    End
_00EF:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _01AB
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    GoTo _01B1
_010A:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _01B3
    GoTo _01C6
_0121:
    ClearFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    End
_0127:
    GoToIfUnset FLAG_HGSS_GOT_TM19_FROM_ERIKA, _0143
    Message msg_0492_T07GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013D:
    BlackOutFromBattle
    ReleaseAll
    End
_0143:
    SetVar VAR_0x8004, ITEM_TM19
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01E1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM19_FROM_ERIKA
    GoToIfUnset FLAG_HGSS_GOT_TM19_FROM_ERIKA, _0143
    Message msg_0492_T07GYM0101_00004
    Message msg_0492_T07GYM0101_00007
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0492_T07GYM0101_00008
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_ERIKA
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0198:
    Message msg_0492_T07GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A3:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AB:
    GoTo _0121
_01B1:
    End
_01B3:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _01EB
    GoTo _01C6
_01C6:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _01F1
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    GoTo _0208
_01E1:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_01EB:
    GoTo _0121
_01F1:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _020A
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    GoTo _0208
_0208:
    End
_020A:
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0221
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    GoTo _0208
_0221:
    GoTo _0121
    .balign 4, 0
