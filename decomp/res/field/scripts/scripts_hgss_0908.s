#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0601.h"


    ScriptEntry scr_seq_T25R1202_000
    ScriptEntry scr_seq_T25R1202_001
    ScriptEntry scr_seq_T25R1202_002
    ScriptEntry scr_seq_T25R1202_003
    ScriptEntry scr_seq_T25R1202_004
    ScriptEntry scr_seq_T25R1202_005
    ScriptEntry scr_seq_T25R1202_006
    ScriptEntry scr_seq_T25R1202_007
    ScriptEntry scr_seq_T25R1202_008
    ScriptEntry scr_seq_T25R1202_009
    ScriptEntry scr_seq_T25R1202_010
    ScriptEntry scr_seq_T25R1202_011
    ScriptEntry scr_seq_T25R1202_012
    ScriptEntryEnd
scr_seq_T25R1202_000:
    NPCMessage msg_0601_T25R1202_00000
    End
scr_seq_T25R1202_001:
    NPCMessage msg_0601_T25R1202_00001
    End
scr_seq_T25R1202_002:
    NPCMessage msg_0601_T25R1202_00002
    End
scr_seq_T25R1202_003:
    NPCMessage msg_0601_T25R1202_00003
    End
scr_seq_T25R1202_004:
    NPCMessage msg_0601_T25R1202_00004
    End
scr_seq_T25R1202_005:
    NPCMessage msg_0601_T25R1202_00005
    End
scr_seq_T25R1202_006:
    NPCMessage msg_0601_T25R1202_00006
    End
scr_seq_T25R1202_007:
    NPCMessage msg_0601_T25R1202_00007
    End
scr_seq_T25R1202_008:
    NPCMessage msg_0601_T25R1202_00008
    End
scr_seq_T25R1202_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0601_T25R1202_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1202_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0601_T25R1202_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1202_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8005, 6
    GoTo _0117
    End
_0117:
    Message msg_0601_T25R1202_00013
    InitLocalTextMenu 21, 11, 0, VAR_RESULT, 1
    AddMenuEntry 15, 0
    AddMenuEntry 16, 1
    AddMenuEntry 17, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _016E
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0193
    GoTo _0166
    End
_0166:
_0168:
    CloseMessage
    ReleaseAll
    End
_016E:
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0168
    CloseMessage
    CallCommonScript 0x802
    ReleaseAll
    End
_0193:
    Message msg_0601_T25R1202_00014
    GoTo _0117
    End
scr_seq_T25R1202_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8005, 5
    GoTo _01B2
    End
_01B2:
    Message msg_0601_T25R1202_00011
    InitLocalTextMenu 21, 11, 0, VAR_RESULT, 1
    AddMenuEntry 15, 0
    AddMenuEntry 16, 1
    AddMenuEntry 17, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0209
    CompareVar VAR_0x8008, 1
    GoToIf 1, _022E
    GoTo _0201
    End
_0201:
_0203:
    CloseMessage
    ReleaseAll
    End
_0209:
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0203
    CloseMessage
    CallCommonScript 0x802
    ReleaseAll
    End
_022E:
    Message msg_0601_T25R1202_00012
    GoTo _01B2
    End
    .balign 4, 0
