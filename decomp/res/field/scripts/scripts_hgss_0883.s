#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0579.h"


    ScriptEntry scr_seq_T24R0701_000
    ScriptEntry scr_seq_T24R0701_001
    ScriptEntry scr_seq_T24R0701_002
    ScriptEntry scr_seq_T24R0701_003
    ScriptEntry scr_seq_T24R0701_004
    ScriptEntryEnd
scr_seq_T24R0701_000:
    NPCMessage msg_0579_T24R0701_00000
    End
scr_seq_T24R0701_001:
    PlayCry SPECIES_GLIGAR, 0
    NPCMessage msg_0579_T24R0701_00001
    End
scr_seq_T24R0701_002:
    PlayCry SPECIES_SNEASEL, 0
    NPCMessage msg_0579_T24R0701_00002
    End
scr_seq_T24R0701_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F8A, _0100
    Message msg_0579_T24R0701_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00F5
    Message msg_0579_T24R0701_00004
    SetVar VAR_0x8004, ITEM_RAZOR_FANG
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F8A
    Message msg_0579_T24R0701_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T24R0701_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F89, _010B
    Message msg_0579_T24R0701_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00F5
    Message msg_0579_T24R0701_00007
    SetVar VAR_0x8004, ITEM_RAZOR_CLAW
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F89
    Message msg_0579_T24R0701_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F5:
    Message msg_0579_T24R0701_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0100:
    Message msg_0579_T24R0701_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_010B:
    Message msg_0579_T24R0701_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
