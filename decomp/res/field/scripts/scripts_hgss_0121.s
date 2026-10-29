#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0136.h"

#define obj_D48R0101_gsleader5 3

    ScriptEntry scr_seq_D48R0101_000
    ScriptEntry scr_seq_D48R0101_001
    ScriptEntry scr_seq_D48R0101_002
    ScriptEntry scr_seq_D48R0101_003
    ScriptEntry scr_seq_D48R0101_004
    ScriptEntry scr_seq_D48R0101_005
    ScriptEntry scr_seq_D48R0101_006
    ScriptEntryEnd
scr_seq_D48R0101_005:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    GoToIf 1, _0031
    SetFlag FLAG_HGSS_HIDE_CLIFFS_EDGE_GATE_CHUCK
    End
_0031:
    ClearFlag FLAG_HGSS_HIDE_CLIFFS_EDGE_GATE_CHUCK
    End
scr_seq_D48R0101_006:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    GoToIf 1, _0046
    End
_0046:
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 1, _0065
    SetPosition obj_D48R0101_gsleader5, 19, 0, 40, DIR_SOUTH
    End
_0065:
    End
scr_seq_D48R0101_004:
    LockAll
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _0086
    ApplyMovement obj_D48R0101_gsleader5, _0130
    GoTo _008E
_0086:
    ApplyMovement obj_D48R0101_gsleader5, _0148
_008E:
    WaitMovement
    BufferPlayerName 0
    Message msg_0136_D48R0101_00007
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _00B3
    ApplyMovement obj_D48R0101_gsleader5, _0160
    GoTo _00BB
_00B3:
    ApplyMovement obj_D48R0101_gsleader5, _016C
_00BB:
    WaitMovement
    Message msg_0136_D48R0101_00008
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _00DD
    ApplyMovement obj_D48R0101_gsleader5, _0178
    GoTo _00E5
_00DD:
    ApplyMovement obj_D48R0101_gsleader5, _0180
_00E5:
    WaitMovement
    Message msg_0136_D48R0101_00009
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _010F
    ApplyMovement LOCALID_PLAYER, _01A8
    ApplyMovement obj_D48R0101_gsleader5, _0188
    GoTo _0117
_010F:
    ApplyMovement obj_D48R0101_gsleader5, _0194
_0117:
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_CLIFFS_EDGE_GATE_CHUCK
    RemoveObject obj_D48R0101_gsleader5
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 3
    ReleaseAll
    End
    .balign 4, 0
_0130:
    WalkOnSpotNormalEast
    Delay8
    WalkNormalEast 2
    WalkNormalSouth
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0148:
    WalkOnSpotNormalSouth
    Delay8
    WalkNormalSouth 3
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0160:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_016C:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0178:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0180:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0188:
    Delay8
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0194:
    Delay8
    WalkNormalNorth 4
    WalkNormalEast 2
    WalkNormalNorth 9
    EndMovement
    .balign 4, 0
_01A8:
    LockDir
    WalkNormalNorth
    UnlockDir
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_D48R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40EB, 1
    GoToIf 1, _0215
    GoToIfSet FLAG_HGSS_UNK_0F5, _01E7
    Message msg_0136_D48R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01E7:
    Message msg_0136_D48R0101_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _020A
    Message msg_0136_D48R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_020A:
    Message msg_0136_D48R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0215:
    Message msg_0136_D48R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0220:
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0228:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0230:
    WalkNormalNorth 2
    EndMovement
scr_seq_D48R0101_001:
    NPCMessage msg_0136_D48R0101_00005
    End
scr_seq_D48R0101_002:
    NPCMessage msg_0136_D48R0101_00006
    End
scr_seq_D48R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0F5, _027C
    Message msg_0136_D48R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_027C:
    Message msg_0136_D48R0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
