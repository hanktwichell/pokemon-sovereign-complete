#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0499.h"


    ScriptEntry scr_seq_T07R0106_000
    ScriptEntry scr_seq_T07R0106_001
    ScriptEntry scr_seq_T07R0106_002
    ScriptEntry scr_seq_T07R0106_003
    ScriptEntryEnd
scr_seq_T07R0106_000:
    NPCMessage msg_0499_T07R0106_00000
    End
scr_seq_T07R0106_001:
    NPCMessage msg_0499_T07R0106_00001
    End
scr_seq_T07R0106_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0499_T07R0106_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0106_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0499_T07R0106_00003
    ShowMoney 20, 2
    GoTo _005E
_005E:
    CompleteInitHGSSMenu 1, 1, 0, VAR_0x8000, 1
    AddMenuEntry 209, 0
    AddMenuEntry 210, 1
    AddMenuEntry 211, 2
    AddMenuEntry 212, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_0x8000
    CompareVar VAR_0x8008, 0
    GoToIf 1, _00C2
    CompareVar VAR_0x8008, 1
    GoToIf 1, _00CE
    CompareVar VAR_0x8008, 2
    GoToIf 1, _00DA
    Message msg_0499_T07R0106_00007
    GoTo _0205
_00C2:
    SetVarFromValue VAR_0x8001, 30
    GoTo _011C
_00CE:
    SetVarFromValue VAR_0x8001, 31
    GoTo _011C
_00DA:
    SetVarFromValue VAR_0x8001, 32
    GoTo _011C
_00E6:
    CheckMoney VAR_RESULT, 200
    Return
_00F0:
    CheckMoney VAR_RESULT, 300
    Return
_00FA:
    CheckMoney VAR_RESULT, 350
    Return
_0104:
    RemoveMoney 200
    Return
_010C:
    RemoveMoney 300
    Return
_0114:
    RemoveMoney 350
    Return
_011C:
    CompareVar VAR_0x8000, 0
    CallIf 1, _00E6
    CompareVar VAR_0x8000, 1
    CallIf 1, _00F0
    CompareVar VAR_0x8000, 2
    CallIf 1, _00FA
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01F0
    CanFitItem VAR_0x8001, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01F9
    CompareVar VAR_0x8000, 0
    CallIf 1, _0104
    CompareVar VAR_0x8000, 1
    CallIf 1, _010C
    CompareVar VAR_0x8000, 2
    CallIf 1, _0114
    UpdateMoneyDisplay
    BufferItemName 0, VAR_0x8001
    PlaySE SEQ_SE_DP_JIHANKI_sseq
    BufferItemName 0, VAR_0x8001
    Message msg_0499_T07R0106_00004
    SetVar VAR_0x8004, VAR_0x8001
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GetRandom VAR_RESULT, 64
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01E7
    PlaySE SEQ_SE_DP_JIHANKI_sseq
    BufferItemName 0, VAR_0x8001
    Message msg_0499_T07R0106_00005
    CanFitItem VAR_0x8001, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01F9
    Common_GiveItemQuantity
_01E7:
    Message msg_0499_T07R0106_00003
    GoTo _005E
_01F0:
    Message msg_0499_T07R0106_00006
    GoTo _0205
_01F9:
    Common_MessageBagIsFull
    CloseMessage
    HideMoney
    ReleaseAll
    End
_0205:
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
    .balign 4, 0
