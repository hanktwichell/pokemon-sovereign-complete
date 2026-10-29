#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0574.h"


    ScriptEntry scr_seq_T24GYM0101_000
    ScriptEntry scr_seq_T24GYM0101_001
    ScriptEntry scr_seq_T24GYM0101_002
    ScriptEntry scr_seq_T24GYM0101_003
    ScriptEntryEnd
scr_seq_T24GYM0101_001:
    @ HGSS: CianwoodGymInit
    ClearFlag FLAG_HGSS_SYS_CIANWOOD_WATERFALL_DISABLE
    End
scr_seq_T24GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _010A
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00EE
    Message msg_0574_T24GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_CHUCK_CHUCK, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0104
    Message msg_0574_T24GYM0101_00003
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    BufferPlayerName 0
    Message msg_0574_T24GYM0101_00004
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    AddVar VAR_HGSS_MIDGAME_BADGES, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetVarFromValue VAR_HGSS_UNK_4116, 1
    CompareVar VAR_HGSS_MIDGAME_BADGES, 3
    GoToIf 5, _00A6
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 1
_00A6:
    Message msg_0574_T24GYM0101_00005
    GoTo _00AF
_00AF:
    SetVar VAR_0x8004, ITEM_TM01
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _00E3
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM01_FROM_CHUCK
    Message msg_0574_T24GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E3:
    Message msg_0574_T24GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00EE:
    GoToIfUnset FLAG_HGSS_GOT_TM01_FROM_CHUCK, _00AF
    Message msg_0574_T24GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0104:
    BlackOutFromBattle
    ReleaseAll
    End
_010A:
    Message msg_0574_T24GYM0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T24GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0135
    Message msg_0574_T24GYM0101_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0135:
    Message msg_0574_T24GYM0101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0153
    CloseMessage
    ReleaseAll
    End
_0153:
    BufferPlayerName 0
    Message msg_0574_T24GYM0101_00011
    CloseMessage
    SetFlag FLAG_HGSS_SYS_CIANWOOD_WATERFALL_DISABLE
    PlaySE SEQ_SE_DP_SHIP03_sseq
    @ HGSS: CianwoodGymTurnWinch VAR_TEMP_x4000
    ReleaseAll
    End
scr_seq_T24GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _019A
    Message msg_0574_T24GYM0101_00013
    GoTo _019D
_019A:
    Message msg_0574_T24GYM0101_00014
_019D:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
