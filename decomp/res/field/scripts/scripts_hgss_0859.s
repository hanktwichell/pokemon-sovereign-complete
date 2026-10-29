#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0558.h"


    ScriptEntry scr_seq_T22GYM0101_000
    ScriptEntry scr_seq_T22GYM0101_001
    ScriptEntry scr_seq_T22GYM0101_002
    ScriptEntry scr_seq_T22GYM0101_003
    ScriptEntry scr_seq_T22GYM0101_004
    ScriptEntry scr_seq_T22GYM0101_005
    ScriptEntryEnd
scr_seq_T22GYM0101_000:
    CompleteVioletGymInit
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_FALKNER, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00A7
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_FALKNER, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _007E
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _005B
    GoTo _00A1
_005B:
    GetDayOfWeek VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 5, _0076
    SetFlag FLAG_HGSS_HIDE_VIOLET_GYM_FALKNER
    GoTo _007C
_0076:
    GoTo _00A1
_007C:
    End
_007E:
    GetDayOfWeek VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _0099
    SetFlag FLAG_HGSS_HIDE_VIOLET_GYM_FALKNER
    GoTo _009F
_0099:
    GoTo _00A1
_009F:
    End
_00A1:
    ClearFlag FLAG_HGSS_HIDE_VIOLET_GYM_FALKNER
    End
_00A7:
    SetFlag FLAG_HGSS_HIDE_VIOLET_GYM_FALKNER
    End
scr_seq_T22GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0168
    Message msg_0558_T22GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_FALKNER_FALKNER, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _017E
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_HGSS_BIRD_KEEPER_GS_ROD
    SetTrainerFlag TRAINER_HGSS_BIRD_KEEPER_GS_ABE
    SetVarFromValue VAR_HGSS_SCENE_VIOLET_CITY_OW, 1
    SetFlag FLAG_HGSS_UNK_192
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 6
    SetFlag FLAG_HGSS_UNK_0F4
    SetFlag FLAG_HGSS_HIDE_WIFI_CLUB_CLOSED_LADY
    Message msg_0558_T22GYM0101_00001
    BufferPlayerName 0
    Message msg_0558_T22GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0558_T22GYM0101_00003
    GoTo _0126
_0126:
    SetVar VAR_0x8004, ITEM_TM51
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _015E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM51_FROM_FALKNER
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    Message msg_0558_T22GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_015E:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0168:
    GoToIfUnset FLAG_HGSS_GOT_TM51_FROM_FALKNER, _0126
    Message msg_0558_T22GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_017E:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T22GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01AA
    Message msg_0558_T22GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AA:
    Message msg_0558_T22GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T22GYM0101_005:
    NPCMessage msg_0558_T22GYM0101_00006
    End
scr_seq_T22GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01EF
    Message msg_0558_T22GYM0101_00009
    GoTo _01F2
_01EF:
    Message msg_0558_T22GYM0101_00010
_01F2:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T22GYM0101_004:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompleteVioletGymLift
    End
    .balign 4, 0
