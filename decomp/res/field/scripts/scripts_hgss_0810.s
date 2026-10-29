#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0515.h"

#define obj_T08PC0101_gsgirl1 6

    ScriptEntry scr_seq_T08PC0101_000
    ScriptEntry scr_seq_T08PC0101_001
    ScriptEntry scr_seq_T08PC0101_002
    ScriptEntry scr_seq_T08PC0101_003
    ScriptEntryEnd
scr_seq_T08PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T08PC0101_001:
    NPCMessage msg_0515_T08PC0101_00000
    End
scr_seq_T08PC0101_002:
    NPCMessage msg_0515_T08PC0101_00001
    End
scr_seq_T08PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0515_T08PC0101_00002
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _006E
    ApplyMovement obj_T08PC0101_gsgirl1, _009C
    GoTo _0091
_006E:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0089
    ApplyMovement obj_T08PC0101_gsgirl1, _00C0
    GoTo _0091
_0089:
    ApplyMovement obj_T08PC0101_gsgirl1, _00E4
_0091:
    Message msg_0515_T08PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_009C:
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    EndMovement
    .balign 4, 0
_00C0:
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    EndMovement
    .balign 4, 0
_00E4:
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    EndMovement
    .balign 4, 0
