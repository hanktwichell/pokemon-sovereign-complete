#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0610.h"


    ScriptEntry scr_seq_T26R0601_000
    ScriptEntryEnd
scr_seq_T26R0601_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_GOOD_ROD, _008E
    Message msg_0610_T26R0601_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0040
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0079
    End
_0040:
    SetVar VAR_0x8004, ITEM_GOOD_ROD
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0084
    Message msg_0610_T26R0601_00001
    WaitButton
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_GOOD_ROD
    Message msg_0610_T26R0601_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0079:
    Message msg_0610_T26R0601_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0084:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_008E:
    Message msg_0610_T26R0601_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
