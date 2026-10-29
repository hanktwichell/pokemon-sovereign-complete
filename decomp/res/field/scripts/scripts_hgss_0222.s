#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0370.h"


    ScriptEntry scr_seq_R27R0101_000
    ScriptEntryEnd
scr_seq_R27R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TM37_FROM_ROUTE_27_WOMAN, _006A
    Message msg_0370_R27R0101_00000
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    @ HGSS: MonGetFriendship VAR_SPECIAL_RESULT, VAR_TEMP_x4000
    CompareVar VAR_RESULT, 150
    GoToIf 4, _003E
    Message msg_0370_R27R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_003E:
    Message msg_0370_R27R0101_00001
    SetVar VAR_0x8004, ITEM_TM37
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0075
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM37_FROM_ROUTE_27_WOMAN
_006A:
    Message msg_0370_R27R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0075:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
