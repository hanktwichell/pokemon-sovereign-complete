#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0607.h"

#define obj_T26PC0101_gswoman2 7

    ScriptEntry scr_seq_T26PC0101_000
    ScriptEntry scr_seq_T26PC0101_001
    ScriptEntry scr_seq_T26PC0101_002
    ScriptEntry scr_seq_T26PC0101_003
    ScriptEntry scr_seq_T26PC0101_004
    ScriptEntryEnd
scr_seq_T26PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T26PC0101_004:
    GoToIfDefeated TRAINER_NONE, _00E6
    CompareVar VAR_MAP_LOCAL_0x07, 77
    GoToIf 1, _00C4
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0607_T26PC0101_00003
    SetVarFromValue VAR_MAP_LOCAL_0x07, 77
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0068
    ApplyMovement obj_T26PC0101_gswoman2, _00FC
    GoTo _007D
_0068:
    CompareVar VAR_RESULT, 0
    GoToIf 5, _007D
    ApplyMovement obj_T26PC0101_gswoman2, _0104
_007D:
    WaitMovement
    Message msg_0607_T26PC0101_00004
_0082:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00D5
    Message msg_0607_T26PC0101_00005
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_BEAUTY_CHARLOTTE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00E0
    SetTrainerFlag TRAINER_NONE
    Message msg_0607_T26PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00C4:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0607_T26PC0101_00008
    GoTo _0082
_00D5:
    Message msg_0607_T26PC0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E0:
    BlackOutFromBattle
    ReleaseAll
    End
_00E6:
    NPCMessage msg_0607_T26PC0101_00006
    End
    .balign 4, 0
_00FC:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0104:
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_T26PC0101_001:
    NPCMessage msg_0607_T26PC0101_00000
    End
scr_seq_T26PC0101_002:
    NPCMessage msg_0607_T26PC0101_00001
    End
scr_seq_T26PC0101_003:
    NPCMessage msg_0607_T26PC0101_00002
    End
    .balign 4, 0
