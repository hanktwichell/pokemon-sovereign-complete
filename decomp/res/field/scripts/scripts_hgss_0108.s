#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0127.h"


    ScriptEntry scr_seq_D42R0101_000
    ScriptEntryEnd
scr_seq_D42R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_BLACKGLASSES_FROM_DARK_CAVE_MAN, _0045
    Message msg_0127_D42R0101_00000
    SetVar VAR_0x8004, ITEM_BLACKGLASSES
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0050
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_BLACKGLASSES_FROM_DARK_CAVE_MAN
_0045:
    Message msg_0127_D42R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0050:
    Message msg_0127_D42R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
