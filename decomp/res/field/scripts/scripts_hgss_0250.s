#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0397.h"


    ScriptEntry scr_seq_R39R0101_000
    ScriptEntry scr_seq_R39R0101_001
    ScriptEntryEnd
scr_seq_R39R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0AA, _004A
    SetFlag FLAG_HGSS_UNK_0A8
    Message msg_0397_R39R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R39R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0AA, _0076
    Message msg_0397_R39R0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_004A:
    SetVarFromValue VAR_0x8004, ITEM_MOOMOO_MILK
    SetVarFromValue VAR_0x8005, 0
    CheckItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 999
    GoToIf 5, _00B5
    Message msg_0397_R39R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0076:
    GoToIfSet FLAG_HGSS_GOT_TM83_FROM_MOOMOO_FARM_WOMAN, _0154
    Message msg_0397_R39R0101_00008
    WaitABPress
    SetVar VAR_0x8004, ITEM_TM83
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _015F
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM83_FROM_MOOMOO_FARM_WOMAN
    GoTo _0154
_00B5:
    ShowMoney 20, 2
    Message msg_0397_R39R0101_00001
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 12, 1
    AddMenuEntry 13, 2
    AddMenuEntry 14, 3
    ShowMenu
    CompareVar VAR_RESULT, 3
    GoToIf 1, _016A
    CompareVar VAR_RESULT, 1
    CallIf 1, _0177
    CompareVar VAR_RESULT, 2
    CallIf 1, _0185
    CheckMoney2 VAR_RESULT, VAR_MAP_LOCAL_0x01
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0193
    SetVar VAR_0x8004, ITEM_MOOMOO_MILK
    SetVar VAR_0x8005, VAR_MAP_LOCAL_0x00
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01A0
    RemoveMoney2 VAR_MAP_LOCAL_0x01
    UpdateMoneyDisplay
    Message msg_0397_R39R0101_00002
    Common_GiveItemQuantity
    CloseMessage
    HideMoney
    ReleaseAll
    End
_0154:
    Message msg_0397_R39R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_015F:
    Message msg_0397_R39R0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_016A:
    Message msg_0397_R39R0101_00005
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_0177:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    SetVarFromValue VAR_MAP_LOCAL_0x01, 500
    Return
_0185:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 12
    SetVarFromValue VAR_MAP_LOCAL_0x01, 6000
    Return
_0193:
    Message msg_0397_R39R0101_00003
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_01A0:
    Message msg_0397_R39R0101_00004
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
    .balign 4, 0
