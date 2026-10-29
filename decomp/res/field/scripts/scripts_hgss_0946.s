#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0633.h"


    ScriptEntry scr_seq_T30R0201_000
    ScriptEntry scr_seq_T30R0201_001
    ScriptEntryEnd
scr_seq_T30R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_SUPER_ROD, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0076
    Message msg_0633_T30R0201_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0081
    Message msg_0633_T30R0201_00001
    SetVar VAR_0x8004, ITEM_SUPER_ROD
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0633_T30R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30R0201_001:
    PlayCry SPECIES_DRAGONAIR, 0
    NPCMessage msg_0633_T30R0201_00004
    WaitCry
    End
_0076:
    Message msg_0633_T30R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0081:
    Message msg_0633_T30R0201_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
