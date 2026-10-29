#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0607.h"

#define obj_T26PC0101_gswoman2 7

    ScriptEntry scr_seq_T26PC0101_000
    ScriptEntry scr_seq_T26PC0101_001
    ScriptEntry scr_seq_T26PC0101_002
    ScriptEntry scr_seq_T26PC0101_003
    ScriptEntry scr_seq_T26PC0101_004
    ScriptEntry scr_seq_T26PC0101_005
    ScriptEntry scr_seq_T26PC0101_006
    ScriptEntryEnd
scr_seq_T26PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T26PC0101_004:
    GoToIfDefeated TRAINER_HGSS_BEAUTY_CHARLOTTE, _0144
    CompareVar VAR_MAP_LOCAL_0x07, 77
    GoToIf 1, _0157
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0607_T26PC0101_00003
    SetVarFromValue VAR_MAP_LOCAL_0x07, 77
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0168
    ApplyMovement obj_T26PC0101_gswoman2, _02DA
    GoTo _01C4
scr_seq_T26PC0101_001:
    NPCMessage msg_0607_T26PC0101_00000
    End
scr_seq_T26PC0101_002:
    NPCMessage msg_0607_T26PC0101_00001
    End
scr_seq_T26PC0101_003:
    NPCMessage msg_0607_T26PC0101_00002
    End
scr_seq_T26PC0101_005:
    BufferPlayerName 0
    End
scr_seq_T26PC0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0607_T26PC0101_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _020B
    Message msg_0607_T26PC0101_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021A
    SetFlag FLAG_HGSS_SG_3FD7
    SetFlag FLAG_HGSS_SG_3FD6
    SetFlag FLAG_HGSS_SG_3FD5
    SetFlag FLAG_HGSS_SG_3FC6
    SetFlag FLAG_HGSS_SG_3FC5
    SetFlag FLAG_HGSS_SG_3FC4
    SetFlag FLAG_HGSS_SG_3FC2
    SetFlag FLAG_HGSS_SG_3FBF
    SetFlag FLAG_HGSS_SG_3FBE
    SetFlag FLAG_HGSS_SG_3FBC
    SetFlag FLAG_HGSS_SG_3FBA
    SetFlag FLAG_HGSS_SG_3FB7
    SetFlag FLAG_HGSS_SG_3FB3
    SetFlag FLAG_HGSS_SG_3FB2
    SetFlag FLAG_HGSS_SG_3FA0
    SetFlag FLAG_HGSS_SG_3F9B
    SetFlag FLAG_HGSS_SG_3F8B
    SetFlag FLAG_HGSS_SG_3F62
    SetFlag FLAG_HGSS_SG_3F5D
    Message msg_0607_T26PC0101_00010
    WaitButton
    CloseMessage
    RemoveObject 8
    ReleaseAll
    End
_0144:
    NPCMessage msg_0607_T26PC0101_00006
    End
_0157:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0607_T26PC0101_00008
    GoTo _0287
_0168:
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01C4
    ApplyMovement obj_T26PC0101_gswoman2, _02E0
    WaitMovement
    Message msg_0607_T26PC0101_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02C9
    Message msg_0607_T26PC0101_00005
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_BEAUTY_CHARLOTTE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02D4
    SetTrainerFlag TRAINER_HGSS_BEAUTY_CHARLOTTE
    Message msg_0607_T26PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01C4:
    WaitMovement
    Message msg_0607_T26PC0101_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02C9
    Message msg_0607_T26PC0101_00005
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_BEAUTY_CHARLOTTE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02D4
    SetTrainerFlag TRAINER_HGSS_BEAUTY_CHARLOTTE
    Message msg_0607_T26PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_020B:
    Message msg_0607_T26PC0101_00011
    WaitButton
    CloseMessage
    RemoveObject 8
    ReleaseAll
    End
_021A:
    SetVarFromValue VAR_HGSS_SG_6130, 2
    SetFlag FLAG_HGSS_SG_3FE8
    SetFlag FLAG_HGSS_SG_3FE7
    SetFlag FLAG_HGSS_SG_3FDF
    SetFlag FLAG_HGSS_SG_3FD7
    SetFlag FLAG_HGSS_SG_3FD6
    SetFlag FLAG_HGSS_SG_3FD5
    SetFlag FLAG_HGSS_SG_3FC6
    SetFlag FLAG_HGSS_SG_3FC5
    SetFlag FLAG_HGSS_SG_3FC4
    SetFlag FLAG_HGSS_SG_3FC2
    SetFlag FLAG_HGSS_SG_3FBF
    SetFlag FLAG_HGSS_SG_3FBE
    SetFlag FLAG_HGSS_SG_3FBC
    SetFlag FLAG_HGSS_SG_3FBA
    SetFlag FLAG_HGSS_SG_3FB7
    SetFlag FLAG_HGSS_SG_3FB3
    SetFlag FLAG_HGSS_SG_3FB2
    SetFlag FLAG_HGSS_SG_3FA0
    SetFlag FLAG_HGSS_SG_3F9B
    SetFlag FLAG_HGSS_SG_3F8B
    SetFlag FLAG_HGSS_SG_3F62
    SetFlag FLAG_HGSS_SG_3F5D
    Message msg_0607_T26PC0101_00010
    WaitButton
    CloseMessage
    RemoveObject 8
    ReleaseAll
    End
_0287:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02C9
    Message msg_0607_T26PC0101_00005
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_BEAUTY_CHARLOTTE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02D4
    SetTrainerFlag TRAINER_HGSS_BEAUTY_CHARLOTTE
    Message msg_0607_T26PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02C9:
    Message msg_0607_T26PC0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02D4:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_02DA:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_02E0:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
