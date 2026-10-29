#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0492.h"


    ScriptEntry scr_seq_T07GYM0101_000
    ScriptEntry scr_seq_T07GYM0101_001
    ScriptEntry scr_seq_T07GYM0101_002
    ScriptEntryEnd
scr_seq_T07GYM0101_002:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_ERIKA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0107
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_ERIKA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00DE
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _004F
    GoTo _0101
    End
_004F:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _006C
    GoTo _008D
_0066:
    GoTo _008B
_006C:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0085
    GoTo _008D
_007F:
    GoTo _008B
_0085:
    GoTo _0101
_008B:
    End
_008D:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _00A8
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    GoTo _00DC
_00A8:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _00BF
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    GoTo _00DC
_00BF:
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _00D6
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    GoTo _00DC
_00D6:
    GoTo _0101
_00DC:
    End
_00DE:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _00F9
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    GoTo _00FF
_00F9:
    GoTo _0101
_00FF:
    End
_0101:
    ClearFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    End
_0107:
    SetFlag FLAG_HGSS_HIDE_CELADON_GYM_ERIKA
    End
scr_seq_T07GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01A5
    Message msg_0492_T07GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_ERIKA_ERIKA, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01BB
    AddVar VAR_HGSS_UNK_4135, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    Message msg_0492_T07GYM0101_00001
    BufferPlayerName 0
    Message msg_0492_T07GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0492_T07GYM0101_00003
    GoTo _017C
_017C:
    SetVar VAR_0x8004, ITEM_TM19
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01C1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM19_FROM_ERIKA
_01A5:
    GoToIfUnset FLAG_HGSS_GOT_TM19_FROM_ERIKA, _017C
    Message msg_0492_T07GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01BB:
    BlackOutFromBattle
    ReleaseAll
    End
_01C1:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_T07GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01F2
    Message msg_0492_T07GYM0101_00005
    GoTo _01F5
_01F2:
    Message msg_0492_T07GYM0101_00006
_01F5:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
