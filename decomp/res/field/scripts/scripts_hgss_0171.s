#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0322.h"


    ScriptEntry scr_seq_R02R0201_000
    ScriptEntryEnd
scr_seq_R02R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_NUGGET_FROM_ROUTE_2_MAN, _0045
    Message msg_0322_R02R0201_00000
    SetVar VAR_0x8004, ITEM_NUGGET
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0050
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_NUGGET_FROM_ROUTE_2_MAN
_0045:
    Message msg_0322_R02R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0050:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
