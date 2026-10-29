#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0462.h"


    ScriptEntry scr_seq_T03GYM0101_000
    ScriptEntry scr_seq_T03GYM0101_001
    ScriptEntry scr_seq_T03GYM0101_002
    ScriptEntry scr_seq_T03GYM0101_003
    ScriptEntryEnd
scr_seq_T03GYM0101_003:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BROCK, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00FB
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BROCK, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00A4
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0053
    GoTo _00F5
    End
_0053:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _006E
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _00A2
_006E:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _0085
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _00A2
_0085:
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _009C
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _00A2
_009C:
    GoTo _00F5
_00A2:
    End
_00A4:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _00BF
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _00F3
_00BF:
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _00D6
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _00F3
_00D6:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _00ED
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _00F3
_00ED:
    GoTo _00F5
_00F3:
    End
_00F5:
    ClearFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    End
_00FB:
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    End
scr_seq_T03GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0195
    Message msg_0462_T03GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_BROCK_BROCK, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01B8
    AddVar VAR_HGSS_UNK_4135, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    Message msg_0462_T03GYM0101_00001
    BufferPlayerName 0
    Message msg_0462_T03GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    BufferPlayerName 0
    MessageGendered msg_0462_T03GYM0101_00003, msg_0462_T03GYM0101_00004
    GoTo _016C
_016C:
    SetVar VAR_0x8004, ITEM_TM80
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01AE
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM80_FROM_BROCK
_0195:
    GoToIfUnset FLAG_HGSS_GOT_TM80_FROM_BROCK, _016C
    BufferPlayerName 0
    Message msg_0462_T03GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AE:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_01B8:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T03GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E4
    Message msg_0462_T03GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01E4:
    Message msg_0462_T03GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0216
    Message msg_0462_T03GYM0101_00008
    GoTo _0219
_0216:
    Message msg_0462_T03GYM0101_00009
_0219:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
