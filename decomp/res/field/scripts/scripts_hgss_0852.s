#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0552.h"


    ScriptEntry scr_seq_T21PC0101_000
    ScriptEntry scr_seq_T21PC0101_001
    ScriptEntry scr_seq_T21PC0101_002
    ScriptEntry scr_seq_T21PC0101_003
    ScriptEntry scr_seq_T21PC0101_004
    ScriptEntry scr_seq_T21PC0101_005
    ScriptEntryEnd
scr_seq_T21PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T21PC0101_004:
    NPCMessage msg_0552_T21PC0101_00004
    End
scr_seq_T21PC0101_005:
    NPCMessage msg_0552_T21PC0101_00005
    End
scr_seq_T21PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 3
    GoToIf 0, _006A
    Message msg_0552_T21PC0101_00003
    GoTo _006D
_006A:
    Message msg_0552_T21PC0101_00002
_006D:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T21PC0101_001:
    NPCMessage msg_0552_T21PC0101_00000
    End
scr_seq_T21PC0101_002:
    NPCMessage msg_0552_T21PC0101_00001
    End
    .balign 4, 0
