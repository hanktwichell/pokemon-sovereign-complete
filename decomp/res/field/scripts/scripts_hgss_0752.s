#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0462.h"


    ScriptEntry scr_seq_T03GYM0101_000
    ScriptEntry scr_seq_T03GYM0101_001
    ScriptEntry scr_seq_T03GYM0101_002
    ScriptEntry scr_seq_T03GYM0101_003
    ScriptEntryEnd
scr_seq_T03GYM0101_003:
    CompletePhoneGetRematch PHONE_CONTACT_BROCK, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0109
    CompletePhoneCheckRegistered PHONE_CONTACT_BROCK, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _010F
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _012A
    GoTo _0145
scr_seq_T03GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_BOULDER, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _014B
    Message msg_0462_T03GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_BROCK_BROCK, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0164
    CompleteGiveBadge BADGE_ID_HGSS_BOULDER
    AddVar VAR_HGSS_UNK_4135, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_HGSS_CAMPER_JERRY
    SetTrainerFlag TRAINER_HGSS_HIKER_EDWIN
    Message msg_0462_T03GYM0101_00001
    BufferPlayerName 0
    Message msg_0462_T03GYM0101_00002
    PlayFanfare SEQ_ME_BADGE_sseq
    WaitFanfare
    BufferPlayerName 0
    MessageGendered msg_0462_T03GYM0101_00003, msg_0462_T03GYM0101_00004
    GoTo _016A
scr_seq_T03GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_BOULDER, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01BF
    Message msg_0462_T03GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_BOULDER, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01CA
    Message msg_0462_T03GYM0101_00008
    GoTo _01D5
_0109:
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    End
_010F:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _01DD
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _01F4
_012A:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _01F6
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _020D
_0145:
    ClearFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    End
_014B:
    GoToIfUnset FLAG_HGSS_GOT_TM80_FROM_BROCK, _016A
    BufferPlayerName 0
    Message msg_0462_T03GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0164:
    BlackOutFromBattle
    ReleaseAll
    End
_016A:
    SetVar VAR_0x8004, ITEM_TM80
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _020F
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM80_FROM_BROCK
    GoToIfUnset FLAG_HGSS_GOT_TM80_FROM_BROCK, _016A
    BufferPlayerName 0
    Message msg_0462_T03GYM0101_00005
    Message msg_0462_T03GYM0101_00010
    BufferPlayerName 0
    Message msg_0462_T03GYM0101_00011
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_BROCK
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01BF:
    Message msg_0462_T03GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01CA:
    Message msg_0462_T03GYM0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01D5:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DD:
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _0219
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _01F4
_01F4:
    End
_01F6:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _0230
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _020D
_020D:
    End
_020F:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0219:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _0247
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _01F4
_0230:
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _024D
    SetFlag FLAG_HGSS_HIDE_PEWTER_GYM_BROCK
    GoTo _020D
_0247:
    GoTo _0145
_024D:
    GoTo _0145
    .balign 4, 0
