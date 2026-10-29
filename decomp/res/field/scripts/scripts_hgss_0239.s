#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0386.h"


    ScriptEntry scr_seq_R34R0201_000
    ScriptEntry scr_seq_R34R0201_001
    ScriptEntry scr_seq_R34R0201_002
    ScriptEntryEnd
scr_seq_R34R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TM12_FROM_ILEX_FOREST_GATE_WOMAN, _0055
    Message msg_0386_R34R0201_00000
    WaitABPress
    SetVar VAR_0x8004, ITEM_TM12
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0060
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM12_FROM_ILEX_FOREST_GATE_WOMAN
    GoTo _0055
_0055:
    Message msg_0386_R34R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0060:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_R34R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BUTTERFREE, 0
    Message msg_0386_R34R0201_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R34R0201_002:
    NPCMessage msg_0386_R34R0201_00004
    End
    .balign 4, 0
