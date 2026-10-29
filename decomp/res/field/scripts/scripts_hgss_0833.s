#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0534.h"


    ScriptEntry scr_seq_T11R0501_000
    ScriptEntry scr_seq_T11R0501_001
    ScriptEntryEnd
scr_seq_T11R0501_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TM29_FROM_MR_PSYCHIC, _00B0
    Message msg_0534_T11R0501_00000
    SetVar VAR_0x8004, ITEM_TM29
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _00BB
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM29_FROM_MR_PSYCHIC
    Message msg_0534_T11R0501_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T11R0501_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F58, _00EF
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 65
    GoToIf 1, _00C5
    CompareVar VAR_MAP_LOCAL_0x01, 282
    GoToIf 1, _00C5
    CompareVar VAR_MAP_LOCAL_0x01, 376
    GoToIf 1, _00C5
    CompareVar VAR_MAP_LOCAL_0x01, 475
    GoToIf 1, _00C5
    Message msg_0534_T11R0501_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B0:
    Message msg_0534_T11R0501_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00BB:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_00C5:
    BufferPartyMonSpecies 1, 0
    Message msg_0534_T11R0501_00003
    Message msg_0534_T11R0501_00004
    SetVar VAR_0x8004, ITEM_MIND_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F58
    Message msg_0534_T11R0501_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00EF:
    Message msg_0534_T11R0501_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
