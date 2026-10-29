#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0397.h"


    ScriptEntry scr_seq_R39R0101_000
    ScriptEntry scr_seq_R39R0101_001
    ScriptEntryEnd
scr_seq_R39R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0AA, _002C
    SetFlag FLAG_HGSS_UNK_0A8
    Message msg_0397_R39R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_002C:
    SetVarFromValue VAR_0x8004, 33
    SetVarFromValue VAR_0x8005, 0
    CheckItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 999
    GoToIf 5, _0058
    Message msg_0397_R39R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0058:
    @ HGSS: ShowMoneyBox 20, 2
    Message msg_0397_R39R0101_00001
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 12, 1
    AddMenuEntryImm 13, 2
    AddMenuEntryImm 14, 3
    ShowMenu
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0111
    CompareVar VAR_RESULT, 1
    CallIf 1, _011E
    CompareVar VAR_RESULT, 2
    CallIf 1, _012C
    @ HGSS: HasEnoughMoneyVar VAR_SPECIAL_RESULT, VAR_TEMP_x4001
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00F7
    SetVar VAR_0x8004, ITEM_MOOMOO_MILK
    SetVar VAR_0x8005, VAR_MAP_LOCAL_0x00
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0104
    @ HGSS: SubMoneyVar VAR_TEMP_x4001
    @ HGSS: UpdateMoneyBox
    Message msg_0397_R39R0101_00002
    Common_GiveItemQuantity
    CloseMessage
    HideMoney
    ReleaseAll
    End
_00F7:
    Message msg_0397_R39R0101_00003
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_0104:
    Message msg_0397_R39R0101_00004
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_0111:
    Message msg_0397_R39R0101_00005
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_011E:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    SetVarFromValue VAR_MAP_LOCAL_0x01, 500
    Return
_012C:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 12
    SetVarFromValue VAR_MAP_LOCAL_0x01, 6000
    Return
scr_seq_R39R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0AA, _0158
    Message msg_0397_R39R0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0158:
    GoToIfSet FLAG_HGSS_GOT_TM83_FROM_MOOMOO_FARM_WOMAN, _0197
    Message msg_0397_R39R0101_00008
    WaitABPress
    SetVar VAR_0x8004, ITEM_TM83
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01A2
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM83_FROM_MOOMOO_FARM_WOMAN
    GoTo _0197
_0197:
    Message msg_0397_R39R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A2:
    Message msg_0397_R39R0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
