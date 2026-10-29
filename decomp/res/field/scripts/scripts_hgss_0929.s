#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0619.h"


    ScriptEntry scr_seq_T27R0801_000
    ScriptEntry scr_seq_T27R0801_001
    ScriptEntryEnd
scr_seq_T27R0801_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_DOWSING_MACHINE, _0078
    Message msg_0619_T27R0801_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0044
    CompareVar VAR_RESULT, 1
    GoToIf 1, _008D
    End
_0044:
    Message msg_0619_T27R0801_00001
    WaitABPress
    SetVar VAR_0x8004, ITEM_DOWSING_MCHN
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0083
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_DOWSING_MACHINE
    GoTo _0078
_0078:
    Message msg_0619_T27R0801_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0083:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_008D:
    Message msg_0619_T27R0801_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0801_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0619_T27R0801_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00C7
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00F9
    End
_00C7:
    Message msg_0619_T27R0801_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00EE
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00F9
    End
_00EE:
    Message msg_0619_T27R0801_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F9:
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
