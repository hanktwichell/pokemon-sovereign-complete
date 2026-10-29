#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0560.h"

#define obj_T22R0301_gsbigman 0
#define obj_T22R0301_gsboy1 1

    ScriptEntry scr_seq_T22R0301_000
    ScriptEntry scr_seq_T22R0301_001
    ScriptEntry scr_seq_T22R0301_002
    ScriptEntry scr_seq_T22R0301_003
    ScriptEntry scr_seq_T22R0301_004
    ScriptEntry scr_seq_T22R0301_005
    ScriptEntry scr_seq_T22R0301_006
    ScriptEntry scr_seq_T22R0301_007
    ScriptEntryEnd
scr_seq_T22R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0049
    ApplyMovement obj_T22R0301_gsbigman, _0164
    GoTo _0087
_0049:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0064
    ApplyMovement obj_T22R0301_gsbigman, _0188
    GoTo _0087
_0064:
    CompareVar VAR_RESULT, 0
    GoToIf 5, _007F
    ApplyMovement obj_T22R0301_gsbigman, _01AC
    GoTo _0087
_007F:
    ApplyMovement obj_T22R0301_gsbigman, _01D0
_0087:
    WaitMovement
    Message msg_0560_T22R0301_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00B0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00D7
    End
_00B0:
    Message msg_0560_T22R0301_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00D7
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0157
    End
_00D7:
    Message msg_0560_T22R0301_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00FE
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0125
    End
_00FE:
    Message msg_0560_T22R0301_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0125
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0157
    End
_0125:
    Message msg_0560_T22R0301_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _014C
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0157
    End
_014C:
    Message msg_0560_T22R0301_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0157:
    Message msg_0560_T22R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0164:
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    EndMovement
    .balign 4, 0
_0188:
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_01AC:
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_01D0:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    EndMovement
scr_seq_T22R0301_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0560_T22R0301_00012
    GoTo _0207
    End
_0207:
    Message msg_0560_T22R0301_00013
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 24, 1
    AddMenuEntry 25, 2
    AddMenuEntry 26, 3
    AddMenuEntry 27, 4
    AddMenuEntry 28, 5
    AddMenuEntry 29, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0264
    Message msg_0560_T22R0301_00014
    GoTo _0207
    GoTo _02D8
_0264:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0280
    Message msg_0560_T22R0301_00015
    GoTo _0207
    GoTo _02D8
_0280:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _029C
    Message msg_0560_T22R0301_00016
    GoTo _0207
    GoTo _02D8
_029C:
    CompareVar VAR_RESULT, 4
    GoToIf 5, _02B8
    Message msg_0560_T22R0301_00017
    GoTo _0207
    GoTo _02D8
_02B8:
    CompareVar VAR_RESULT, 5
    GoToIf 5, _02D4
    Message msg_0560_T22R0301_00018
    GoTo _0207
    GoTo _02D8
_02D4:
    CloseMessage
    ReleaseAll
_02D8:
    End
scr_seq_T22R0301_003:
    NPCMessage msg_0560_T22R0301_00011
    End
scr_seq_T22R0301_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0560_T22R0301_00019
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0353
    Message msg_0560_T22R0301_00020
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0353
    Message msg_0560_T22R0301_00021
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0353
    Message msg_0560_T22R0301_00022
    CloseMessage
    ApplyMovement obj_T22R0301_gsboy1, _035C
    WaitMovement
    Message msg_0560_T22R0301_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0353:
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_035C:
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_T22R0301_004:
    NPCMessage msg_0560_T22R0301_00007
    End
scr_seq_T22R0301_005:
    NPCMessage msg_0560_T22R0301_00010
    End
scr_seq_T22R0301_006:
    NPCMessage msg_0560_T22R0301_00009
    End
scr_seq_T22R0301_007:
    NPCMessage msg_0560_T22R0301_00008
    End
    .balign 4, 0
