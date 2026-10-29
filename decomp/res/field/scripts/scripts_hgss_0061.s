#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0092.h"


    ScriptEntry scr_seq_D26R0103_000
    ScriptEntryEnd
scr_seq_D26R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_KINGS_ROCK_FROM_SLOWPOKE_WELL_MAN, _004F
    Message msg_0092_D26R0103_00000
    WaitABPress
    CloseMessage
    SetVar VAR_0x8004, ITEM_TM18
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _005A
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_KINGS_ROCK_FROM_SLOWPOKE_WELL_MAN
    GoTo _004F
_004F:
    Message msg_0092_D26R0103_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_005A:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
