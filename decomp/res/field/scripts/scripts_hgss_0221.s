#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0369.h"

#define obj_R27_gsbigman 0

    ScriptEntry scr_seq_R27_000
    ScriptEntry scr_seq_R27_001
    ScriptEntry scr_seq_R27_002
    ScriptEntry scr_seq_R27_003
    ScriptEntry scr_seq_R27_004
    ScriptEntryEnd
scr_seq_R27_003:
    GoToIfSet FLAG_HGSS_UNK_168, _0099
    @ HGSS: ScrCmd_804 1
    End
scr_seq_R27_000:
    NPCMessage msg_0369_R27_00001
    End
scr_seq_R27_001:
    LockAll
    ApplyMovement obj_R27_gsbigman, _00E4
    WaitMovement
    Message msg_0369_R27_00000
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _009B
    ApplyMovement obj_R27_gsbigman, _00EA
    GoTo _00B6
scr_seq_R27_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0369_R27_00002, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R27_004:
    DrawSignpostInstantMessage msg_0369_R27_00003, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
_0099:
    End
_009B:
    CompareVar VAR_MAP_LOCAL_0x01, 403
    GoToIf 5, _00C9
    ApplyMovement obj_R27_gsbigman, _00F4
    GoTo _00B6
_00B6:
    WaitMovement
    Message msg_0369_R27_00001
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_408A, 1
    End
_00C9:
    ApplyMovement obj_R27_gsbigman, _00FA
    WaitMovement
    Message msg_0369_R27_00001
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_408A, 1
    End
    .balign 4, 0
_00E4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_00EA:
    WalkNormalNorth
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_00F4:
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_00FA:
    WalkNormalSouth
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
