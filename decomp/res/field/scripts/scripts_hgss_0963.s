#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0745.h"

#define obj_W40R0101_gsmiddleman1 0

    ScriptEntry scr_seq_W40R0101_000
    ScriptEntry scr_seq_W40R0101_001
    ScriptEntry scr_seq_W40R0101_002
    ScriptEntry scr_seq_W40R0101_003
    ScriptEntryEnd
scr_seq_W40R0101_001:
    CompareVar VAR_HGSS_UNK_40E5, 1
    GoToIf 4, _0088
    GoToIfSet FLAG_HGSS_GOT_TM23_FROM_JASMINE, _0090
    End
scr_seq_W40R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfSet FLAG_HGSS_UNK_0FB, _009E
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _00A9
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _00B6
    ApplyMovement obj_W40R0101_gsmiddleman1, _0116
    GoTo _00D1
scr_seq_W40R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _00E6
    Message msg_0745_W40R0101_00003
    GoTo _00F1
scr_seq_W40R0101_003:
    BufferPlayerName 0
    End
_0088:
    SetVarFromValue VAR_HGSS_UNK_40E5, 2
    End
_0090:
    SetPosition obj_W40R0101_gsmiddleman1, 3, 0, 3, DIR_NORTH
    End
_009E:
    Message msg_0745_W40R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A9:
    Message msg_0745_W40R0101_00001
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_0FB
    End
_00B6:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00F9
    ApplyMovement obj_W40R0101_gsmiddleman1, _011C
    GoTo _00D1
_00D1:
    WaitMovement
    Message msg_0745_W40R0101_00000
    CloseMessage
    ApplyMovement obj_W40R0101_gsmiddleman1, _0122
    WaitMovement
    ReleaseAll
    End
_00E6:
    Message msg_0745_W40R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F1:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F9:
    ApplyMovement obj_W40R0101_gsmiddleman1, _0128
    WaitMovement
    Message msg_0745_W40R0101_00000
    CloseMessage
    ApplyMovement obj_W40R0101_gsmiddleman1, _0122
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0116:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_011C:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0122:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0128:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
