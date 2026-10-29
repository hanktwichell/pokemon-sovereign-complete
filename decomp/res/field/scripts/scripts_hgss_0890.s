#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0584.h"


    ScriptEntry scr_seq_T25R0201_000
    ScriptEntry scr_seq_T25R0201_001
    ScriptEntryEnd
scr_seq_T25R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_089, _0081
    Message msg_0584_T25R0201_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0042
    CompareVar VAR_RESULT, 1
    GoToIf 1, _008C
    End
_0042:
    Message msg_0584_T25R0201_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0065
    CompareVar VAR_RESULT, 1
    GoToIf 1, _008C
    End
_0065:
    SetVar VAR_0x8004, ITEM_BICYCLE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_089
    CloseMessage
    ReleaseAll
    End
_0081:
    Message msg_0584_T25R0201_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_008C:
    Message msg_0584_T25R0201_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0201_001:
    NPCMessage msg_0584_T25R0201_00005
    End
    .balign 4, 0
