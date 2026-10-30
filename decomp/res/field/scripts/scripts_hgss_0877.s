#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0574.h"


    ScriptEntry scr_seq_T24GYM0101_000
    ScriptEntry scr_seq_T24GYM0101_001
    ScriptEntry scr_seq_T24GYM0101_002
    ScriptEntry scr_seq_T24GYM0101_003
    ScriptEntryEnd
scr_seq_T24GYM0101_001:
    CompleteCianwoodGymInit
    ClearFlag FLAG_HGSS_SYS_CIANWOOD_WATERFALL_DISABLE
    End
scr_seq_T24GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _00F6
    CompleteCheckBadge BADGE_ID_HGSS_STORM, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0101
    Message msg_0574_T24GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_CHUCK_CHUCK, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0117
    Message msg_0574_T24GYM0101_00003
    SetTrainerFlag TRAINER_HGSS_BLACK_BELT_YOSHI
    SetTrainerFlag TRAINER_HGSS_BLACK_BELT_LAO
    SetTrainerFlag TRAINER_HGSS_BLACK_BELT_NOB
    SetTrainerFlag TRAINER_HGSS_BLACK_BELT_LUNG
    BufferPlayerName 0
    Message msg_0574_T24GYM0101_00004
    CompleteGiveBadge BADGE_ID_HGSS_STORM
    PlayFanfare SEQ_ME_BADGE_sseq
    WaitFanfare
    AddVar VAR_HGSS_MIDGAME_BADGES, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetVarFromValue VAR_HGSS_UNK_4116, 1
    CompareVar VAR_HGSS_MIDGAME_BADGES, 3
    GoToIf 5, _011D
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 1
    Message msg_0574_T24GYM0101_00005
    GoTo _0126
scr_seq_T24GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _016D
    Message msg_0574_T24GYM0101_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T24GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_STORM, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _018B
    Message msg_0574_T24GYM0101_00013
    GoTo _0196
_00F6:
    Message msg_0574_T24GYM0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0101:
    GoToIfUnset FLAG_HGSS_GOT_TM01_FROM_CHUCK, _0126
    Message msg_0574_T24GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0117:
    BlackOutFromBattle
    ReleaseAll
    End
_011D:
    Message msg_0574_T24GYM0101_00005
    GoTo _0126
_0126:
    SetVar VAR_0x8004, ITEM_TM01
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _019E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM01_FROM_CHUCK
    Message msg_0574_T24GYM0101_00006
    Message msg_0574_T24GYM0101_00015
    BufferPlayerName 0
    Message msg_0574_T24GYM0101_00016
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_CHUCK
    WaitButton
    CloseMessage
    ReleaseAll
    End
_016D:
    Message msg_0574_T24GYM0101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A9
    CloseMessage
    ReleaseAll
    End
_018B:
    Message msg_0574_T24GYM0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0196:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_019E:
    Message msg_0574_T24GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A9:
    BufferPlayerName 0
    Message msg_0574_T24GYM0101_00011
    CloseMessage
    SetFlag FLAG_HGSS_SYS_CIANWOOD_WATERFALL_DISABLE
    PlaySE SEQ_SE_DP_SHIP03_sseq
    CompleteCianwoodGymTurnWinch VAR_MAP_LOCAL_0x00
    ReleaseAll
    End
    .balign 4, 0
