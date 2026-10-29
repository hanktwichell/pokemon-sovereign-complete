#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0570.h"


    ScriptEntry scr_seq_T23R0201_000
    ScriptEntry scr_seq_T23R0201_001
    ScriptEntry scr_seq_T23R0201_002
    ScriptEntryEnd
scr_seq_T23R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _002C
    Message msg_0570_T23R0201_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_002C:
    GoToIfSet FLAG_HGSS_GOT_HM01, _0042
    Message msg_0570_T23R0201_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0042:
    Message msg_0570_T23R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T23R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_HM01, _006B
    Message msg_0570_T23R0201_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_006B:
    GoToIfSet FLAG_HGSS_GOT_CHARCOAL_FROM_AZALEA_TOWN_MAN, _00AA
    Message msg_0570_T23R0201_00004
    WaitABPress
    SetVar VAR_0x8004, ITEM_CHARCOAL
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _00B5
    Common_GiveItemQuantityNoLineFeed
    SetFlag FLAG_HGSS_GOT_CHARCOAL_FROM_AZALEA_TOWN_MAN
    CloseMessage
    ReleaseAll
    End
_00AA:
    Message msg_0570_T23R0201_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B5:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_T23R0201_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_FARFETCHD, 0
    Message msg_0570_T23R0201_00008
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
