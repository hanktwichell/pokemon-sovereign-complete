#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0370.h"


    ScriptEntry scr_seq_R27R0101_000
    ScriptEntry scr_seq_R27R0101_001
    ScriptEntryEnd
scr_seq_R27R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TM37_FROM_ROUTE_27_WOMAN, _0080
    Message msg_0370_R27R0101_00000
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonFriendship VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 150
    GoToIf 4, _008B
    Message msg_0370_R27R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R27R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0370_R27R0101_00004
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0370_R27R0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0080:
    Message msg_0370_R27R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_008B:
    Message msg_0370_R27R0101_00001
    SetVar VAR_0x8004, ITEM_TM37
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _00C2
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM37_FROM_ROUTE_27_WOMAN
    Message msg_0370_R27R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00C2:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
