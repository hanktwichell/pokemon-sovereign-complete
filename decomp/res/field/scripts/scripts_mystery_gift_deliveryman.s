#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/mystery_gift_deliveryman.h"


    ScriptEntry MysteryGiftDeliveryman_OnMartTransition
    ScriptEntry MysteryGiftDeliveryman_Deliveryman
    ScriptEntry MysteryGiftDeliveryman_CompleteMomGiftDeliveryman
    ScriptEntryEnd

MysteryGiftDeliveryman_OnMartTransition:
    // Sovereign Complete: Johto's and Kanto's Marts have Mom's deliveryman too (HeartGold's std_hide_show_deliverymen),
    // shown when she bought something
    CompleteMomGiftCheck VAR_RESULT
    SetFlag FLAG_HGSS_HIDE_MOM_GIFT_DELIVERYMAN
    GoToIfEq VAR_RESULT, FALSE, MysteryGiftDeliveryman_CompleteOnMartTransition
    ClearFlag FLAG_HGSS_HIDE_MOM_GIFT_DELIVERYMAN
MysteryGiftDeliveryman_CompleteOnMartTransition:
    LoadMysteryGift
    CheckAvailableMysteryGift VAR_AVAILABLE_MYSTERY_GIFT_EXISTS
    GoToIfEq VAR_AVAILABLE_MYSTERY_GIFT_EXISTS, FALSE, MysteryGiftDeliveryman_HideDeliveryman
    ClearFlag FLAG_HIDE_MART_MYSTERY_GIFT_DELIVERYMAN
    UnloadMysteryGiftNotReceived
    End

MysteryGiftDeliveryman_HideDeliveryman:
    SetFlag FLAG_HIDE_MART_MYSTERY_GIFT_DELIVERYMAN
    UnloadMysteryGiftNotReceived
    End

MysteryGiftDeliveryman_Deliveryman:
    LoadMysteryGift
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckAvailableMysteryGift VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, MysteryGiftDeliveryman_NoMoreGifts
    GetTimeOfDay VAR_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    GoToIfEq VAR_0x8008, TIMEOFDAY_MORNING, MysteryGiftDeliveryman_MorningGreeting
    GoToIfEq VAR_0x8008, TIMEOFDAY_DAY, MysteryGiftDeliveryman_MiddayGreeting
    GoTo MysteryGiftDeliveryman_EveningGreeting

MysteryGiftDeliveryman_MorningGreeting:
    BufferPlayerName 0
    Message MysteryGiftDeliveryman_Text_MorningGreeting
    GoTo MysteryGiftDeliveryman_TryGiveMysteryGift

MysteryGiftDeliveryman_MiddayGreeting:
    BufferPlayerName 0
    Message MysteryGiftDeliveryman_Text_MiddayGreeting
    GoTo MysteryGiftDeliveryman_TryGiveMysteryGift

MysteryGiftDeliveryman_EveningGreeting:
    BufferPlayerName 0
    Message MysteryGiftDeliveryman_Text_EveningGreeting
    GoTo MysteryGiftDeliveryman_TryGiveMysteryGift

MysteryGiftDeliveryman_TryGiveMysteryGift:
    CheckCanReceiveMysteryGift VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, MysteryGiftDeliveryman_CantReceiveGift
    PlayFanfare SEQ_FANFA4_sseq
    PrepareMysteryGiftReceivedMsg VAR_0x8005, VAR_0x8006
    MessageFromBank VAR_0x8005, VAR_0x8006
    WaitFanfare
    Message MysteryGiftDeliveryman_Text_LookForwardNextVisit
    WaitButton
    GiveMysteryGift
    GoTo MysteryGiftDeliveryman_UnloadGiftReceived

MysteryGiftDeliveryman_CantReceiveGift:
    PrepareMysterGiftCantReceiveMsg VAR_0x8005, VAR_0x8006
    MessageFromBank VAR_0x8005, VAR_0x8006
    WaitButton
    GoTo MysteryGiftDeliveryman_UnloadGiftNotReceived

MysteryGiftDeliveryman_NoMoreGifts:
    Message MysteryGiftDeliveryman_Text_NoMoreGifts
    WaitButton
    GoTo MysteryGiftDeliveryman_UnloadGiftNotReceived

MysteryGiftDeliveryman_UnloadGiftNotReceived:
    CloseMessage
    ReleaseAll
    UnloadMysteryGiftNotReceived
    End

MysteryGiftDeliveryman_UnloadGiftReceived:
    CloseMessage
    ReleaseAll
    UnloadMysteryGiftReceived
    End

// Sovereign Complete: Mom's deliveryman (HeartGold's scr_seq_0144_002), with what she bought with the player's savings
// (src/overlay006/complete_moms_savings.c), one thing a visit
MysteryGiftDeliveryman_CompleteMomGiftDeliveryman:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteMomGiftCheck VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, MysteryGiftDeliveryman_CompleteNoMorePackages
    GetTimeOfDay VAR_RESULT
    BufferPlayerName 0
    GoToIfEq VAR_RESULT, TIMEOFDAY_MORNING, MysteryGiftDeliveryman_CompleteMorningGreeting
    GoToIfEq VAR_RESULT, TIMEOFDAY_DAY, MysteryGiftDeliveryman_CompleteDayGreeting
    MessageFromBank TEXT_BANK_HGSS_MSG_0209, 29
    GoTo MysteryGiftDeliveryman_CompleteGivePackage

MysteryGiftDeliveryman_CompleteMorningGreeting:
    MessageFromBank TEXT_BANK_HGSS_MSG_0209, 27
    GoTo MysteryGiftDeliveryman_CompleteGivePackage

MysteryGiftDeliveryman_CompleteDayGreeting:
    MessageFromBank TEXT_BANK_HGSS_MSG_0209, 28
MysteryGiftDeliveryman_CompleteGivePackage:
    CompleteMomGiftPeek VAR_0x8004, VAR_0x8005
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, MysteryGiftDeliveryman_CompleteNoRoom
    Common_GiveItemQuantity
    CompleteMomGiftTake
    CompletePhoneClearCallTrigger CALL_TRIGGER_MOM_BOUGHT_SOMETHING
    MessageFromBank TEXT_BANK_HGSS_MSG_0209, 20
    WaitButton
    CloseMessage
    ReleaseAll
    End

MysteryGiftDeliveryman_CompleteNoRoom:
    BufferItemName 0, VAR_0x8004
    MessageFromBank TEXT_BANK_HGSS_MSG_0209, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End

MysteryGiftDeliveryman_CompleteNoMorePackages:
    MessageFromBank TEXT_BANK_HGSS_MSG_0209, 30
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
