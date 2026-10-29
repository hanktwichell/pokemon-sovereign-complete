#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0050.h"

#define obj_D02R0103_stop 0

    ScriptEntry scr_seq_D02R0103_000
    ScriptEntry scr_seq_D02R0103_001
    ScriptEntry scr_seq_D02R0103_002
    ScriptEntryEnd
scr_seq_D02R0103_002:
    ShowObject obj_D02R0103_stop
    @ HGSS: ScrCmd_379 VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _003D
    SetPosition obj_D02R0103_stop, 18, 0, 10, DIR_SOUTH
    SetWarpEventPos 2, 20, 3
    GoTo _005E
_003D:
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 5, _005E
    SetPosition obj_D02R0103_stop, 18, 0, 10, DIR_SOUTH
    SetWarpEventPos 2, 20, 3
_005E:
    End
scr_seq_D02R0103_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0050_D02R0103_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D02R0103_001:
    NPCMessage msg_0050_D02R0103_00001
    End
    .balign 4, 0
