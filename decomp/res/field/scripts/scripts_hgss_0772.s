#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0479.h"


    ScriptEntry scr_seq_T05R0301_000
    ScriptEntryEnd
scr_seq_T05R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_AZURE_FLUTE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _008C
    Message msg_0479_T05R0301_00000
    WaitButton
    CloseMessage
    CheckItem ITEM_MAGMA_STONE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0043
    ReleaseAll
    End
_0043:
    Message msg_0479_T05R0301_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0066
    Message msg_0479_T05R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0066:
    Message msg_0479_T05R0301_00003
    RemoveItem ITEM_MAGMA_STONE, 1, VAR_RESULT
    SetVar VAR_0x8004, ITEM_AZURE_FLUTE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0479_T05R0301_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_008C:
    Message msg_0479_T05R0301_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
