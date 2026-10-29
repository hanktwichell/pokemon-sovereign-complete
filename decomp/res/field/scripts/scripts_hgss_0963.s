#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0745.h"

#define obj_W40R0101_gsmiddleman1 0

    ScriptEntry scr_seq_W40R0101_000
    ScriptEntry scr_seq_W40R0101_001
    ScriptEntry scr_seq_W40R0101_002
    ScriptEntryEnd
scr_seq_W40R0101_001:
    CompareVar VAR_HGSS_UNK_40E5, 1
    GoToIf 4, _0036
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0028
    End
_0028:
    SetPosition obj_W40R0101_gsmiddleman1, 3, 0, 3, DIR_NORTH
    End
_0036:
    SetVarFromValue VAR_HGSS_UNK_40E5, 2
    End
scr_seq_W40R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfSet FLAG_HGSS_UNK_0FB, _00BE
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _00B1
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0079
    ApplyMovement obj_W40R0101_gsmiddleman1, _00E4
    GoTo _009C
_0079:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0094
    ApplyMovement obj_W40R0101_gsmiddleman1, _00DC
    GoTo _009C
_0094:
    ApplyMovement obj_W40R0101_gsmiddleman1, _00D4
_009C:
    WaitMovement
    Message msg_0745_W40R0101_00000
    CloseMessage
    ApplyMovement obj_W40R0101_gsmiddleman1, _00CC
    WaitMovement
    ReleaseAll
    End
_00B1:
    Message msg_0745_W40R0101_00001
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_0FB
    End
_00BE:
    Message msg_0745_W40R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_00CC:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_00D4:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_00DC:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_00E4:
    WalkOnSpotNormalWest
    EndMovement
scr_seq_W40R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0108
    Message msg_0745_W40R0101_00003
    GoTo _010B
_0108:
    Message msg_0745_W40R0101_00004
_010B:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
