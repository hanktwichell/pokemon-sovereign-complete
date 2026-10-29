#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0124.h"

#define obj_D40R0104_bozu 0

    ScriptEntry scr_seq_D40R0104_000
    ScriptEntry scr_seq_D40R0104_001
    ScriptEntry scr_seq_D40R0104_002
    ScriptEntry scr_seq_D40R0104_003
    ScriptEntryEnd
scr_seq_D40R0104_003:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 111
    End
scr_seq_D40R0104_001:
    CompareVar VAR_MAP_LOCAL_0x03, 111
    GoToIf 5, _0032
    GoToIfSet FLAG_HGSS_UNK_106, _003A
_0032:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    End
_003A:
    SetPosition obj_D40R0104_bozu, 34, 1, 29, DIR_EAST
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    End
scr_seq_D40R0104_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_CAUGHT_LUGIA, _010D
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 8
    GoToIf 1, _0093
    GoToIfSet FLAG_HGSS_UNK_106, _00C5
    GoToIfSet FLAG_HGSS_UNK_094, _00B4
    Message msg_0124_D40R0104_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0093:
    GoToIfSet FLAG_HGSS_UNK_106, _00C5
    GoToIfSet FLAG_HGSS_UNK_094, _00B4
    Message msg_0124_D40R0104_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B4:
    Message msg_0124_D40R0104_00002
    CloseMessage
    @ HGSS: ShowLegendaryWing 1
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_106
    End
_00C5:
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 8
    GoToIf 5, _00EC
    GoToIfSet FLAG_HGSS_UNK_109, _00F7
    GoToIfSet FLAG_HGSS_UNK_105, _0102
_00EC:
    Message msg_0124_D40R0104_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F7:
    Message msg_0124_D40R0104_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0102:
    Message msg_0124_D40R0104_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_010D:
    Message msg_0124_D40R0104_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D40R0104_002:
    WaitTime 60, VAR_RESULT
    Message msg_0124_D40R0104_00003
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0142
    ApplyMovement obj_D40R0104_bozu, _0168
    GoTo _014A
_0142:
    ApplyMovement obj_D40R0104_bozu, _0154
_014A:
    WaitMovement
    WaitTime 30, VAR_RESULT
    End
    .balign 4, 0
_0154:
    FaceSouth
    LockDir
    WalkNormalNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_0168:
    FaceEast
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
    .balign 4, 0
