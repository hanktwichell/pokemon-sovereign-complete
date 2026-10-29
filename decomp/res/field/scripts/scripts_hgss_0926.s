#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0616.h"

#define obj_T27R0201_bozu 0

    ScriptEntry scr_seq_T27R0201_000
    ScriptEntry scr_seq_T27R0201_001
    ScriptEntry scr_seq_T27R0201_002
    ScriptEntry scr_seq_T27R0201_003
    ScriptEntryEnd
scr_seq_T27R0201_003:
    GoToIfSet FLAG_HGSS_UNK_108, _001F
    End
_001F:
    SetPosition obj_T27R0201_bozu, 16, 0, 8, DIR_WEST
    End
scr_seq_T27R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _00E8
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _00C9
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00D4
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0096
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _008B
    Message msg_0616_T27R0201_00000
    GoTo _008E
_008B:
    Message msg_0616_T27R0201_00001
_008E:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0096:
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _00B0
    Message msg_0616_T27R0201_00002
    GoTo _00B3
_00B0:
    Message msg_0616_T27R0201_00003
_00B3:
    CloseMessage
    ApplyMovement obj_T27R0201_bozu, _00F4
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    ReleaseAll
    End
_00C9:
    Message msg_0616_T27R0201_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00D4:
    ApplyMovement obj_T27R0201_bozu, _0104
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    ReleaseAll
    End
_00E8:
    Message msg_0616_T27R0201_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_00F4:
    WalkNormalNorth
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_0104:
    WalkNormalSouth
    WalkNormalEast
    FaceWest
    EndMovement
scr_seq_T27R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _0162
    GoToIfSet FLAG_HGSS_UNK_103, _0157
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _014C
    Message msg_0616_T27R0201_00006
    GoTo _014F
_014C:
    Message msg_0616_T27R0201_00007
_014F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0157:
    Message msg_0616_T27R0201_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0162:
    Message msg_0616_T27R0201_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0201_002:
    NPCMessage msg_0616_T27R0201_00010
    End
    .balign 4, 0
