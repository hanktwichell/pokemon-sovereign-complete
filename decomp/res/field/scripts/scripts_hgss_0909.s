#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0602.h"


    ScriptEntry scr_seq_T25R1203_000
    ScriptEntry scr_seq_T25R1203_001
    ScriptEntry scr_seq_T25R1203_002
    ScriptEntry scr_seq_T25R1203_003
    ScriptEntry scr_seq_T25R1203_004
    ScriptEntry scr_seq_T25R1203_005
    ScriptEntry scr_seq_T25R1203_006
    ScriptEntry scr_seq_T25R1203_007
    ScriptEntry scr_seq_T25R1203_008
    ScriptEntry scr_seq_T25R1203_009
    ScriptEntry scr_seq_T25R1203_010
    ScriptEntry scr_seq_T25R1203_011
    ScriptEntryEnd
scr_seq_T25R1203_000:
    NPCMessage msg_0602_T25R1203_00000
    End
scr_seq_T25R1203_001:
    NPCMessage msg_0602_T25R1203_00001
    End
scr_seq_T25R1203_002:
    NPCMessage msg_0602_T25R1203_00002
    End
scr_seq_T25R1203_003:
    NPCMessage msg_0602_T25R1203_00003
    End
scr_seq_T25R1203_004:
    NPCMessage msg_0602_T25R1203_00004
    End
scr_seq_T25R1203_005:
    NPCMessage msg_0602_T25R1203_00005
    End
scr_seq_T25R1203_006:
    NPCMessage msg_0602_T25R1203_00006
    End
scr_seq_T25R1203_007:
    NPCMessage msg_0602_T25R1203_00007
    End
scr_seq_T25R1203_008:
    NPCMessage msg_0602_T25R1203_00008
    End
scr_seq_T25R1203_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0602_T25R1203_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1203_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0602_T25R1203_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1203_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8005, 2
    GoTo _0113
    End
_0113:
    Message msg_0602_T25R1203_00011
    InitLocalTextMenu 21, 11, 0, VAR_RESULT, 1
    AddMenuEntry 13, 0
    AddMenuEntry 14, 1
    AddMenuEntry 15, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _016A
    CompareVar VAR_0x8008, 1
    GoToIf 1, _018F
    GoTo _0162
    End
_0162:
_0164:
    CloseMessage
    ReleaseAll
    End
_016A:
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0164
    CloseMessage
    @ HGSS: ScrCmd_815 0
    CallCommonScript 0x802
    ReleaseAll
    End
_018F:
    Message msg_0602_T25R1203_00012
    GoTo _0113
    End
    .balign 4, 0
