#include "macros/scrcmd.inc"
#include "res/text/bank/common_strings.h"
#include "generated/trainer_message_types.h"
#include "constants/approach_type.h"
#include "res/trainers/trainer_scripts.h"
#include "generated/text_banks.h"
#include "constants/menu.h"


Battles_Trainer:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetTrainerID VAR_0x8004
    GetMovementType VAR_0x8001, VAR_LAST_TALKED
    CallIfEq VAR_0x8001, MOVEMENT_TYPE_DISGUISE_SNOW, Battles_RevealTrainer
    CallIfEq VAR_0x8001, MOVEMENT_TYPE_DISGUISE_SAND, Battles_RevealTrainer
    CallIfEq VAR_0x8001, MOVEMENT_TYPE_DISGUISE_ROCK, Battles_RevealTrainer
    CallIfEq VAR_0x8001, MOVEMENT_TYPE_DISGUISE_GRASS, Battles_RevealTrainer
    GoToIfDefeated VAR_0x8004, Battles_TryRematch
    CheckIsTrainerDoubleBattle VAR_RESULT
    GoToIfNe VAR_RESULT, TRUE, Battles_StartTrainerEncounter
    CheckHasTwoAliveMons VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_NotEnoughPokemonMessage
    GoTo Battles_StartTrainerEncounter
    End

Battles_StartTrainerEncounter:
    PlayTrainerEncounterBGM VAR_0x8004
    OpenMessage
    GetTrainerMessageTypes VAR_0x8000, VAR_0x8001, VAR_0x8002
    PrintTrainerDialogue VAR_0x8004, VAR_0x8000
    GoTo Battles_DoTrainerBattle
    End

Battles_DoTrainerBattle:
    CloseMessage
    SetMoveCodeForFacingDirection
    StartTrainerBattle VAR_0x8004
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_LostBattle
    SetTrainerFlag VAR_0x8004
    Call Battles_CompletePhoneAfterBattle // Sovereign Complete: HeartGold's phone trainers
    ReleaseAll
    End

Battles_TryRematch:
    Call Battles_CompletePhoneDefeated // Sovereign Complete: HeartGold's phone trainers
    GoToIfEq VAR_RESULT, 0xFFFF, Battles_CompletePhoneDone
    GoToIfNe VAR_RESULT, TRAINER_NONE, Battles_Rematch
    GetRematchTrainerID VAR_0x8004, VAR_RESULT
    GoToIfNe VAR_RESULT, TRAINER_NONE, Battles_Rematch
    GoTo Battles_PostBattleMessage
    End

Battles_PostBattleMessage:
    OpenMessage
    GetTrainerMessageTypes VAR_0x8000, VAR_0x8001, VAR_0x8002
    PrintTrainerDialogue VAR_0x8004, VAR_0x8001
    WaitButton
    CloseMessage
    ReleaseAll
    End

Battles_Rematch:
    SetVar VAR_0x8007, VAR_RESULT
    CheckIsTrainerDoubleBattle VAR_RESULT
    GoToIfNe VAR_RESULT, TRUE, Battles_StartRematchEncounter
    CheckHasTwoAliveMons VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_NotEnoughPokemonMessage
    GoTo Battles_StartRematchEncounter
    End

Battles_StartRematchEncounter:
    PlayTrainerEncounterBGM VAR_0x8004
    OpenMessage
    GetTrainerRematchMessageTypes VAR_0x8000, VAR_0x8001, VAR_0x8002
    PrintTrainerDialogue VAR_0x8004, VAR_0x8000
    SetVar VAR_0x8004, VAR_0x8007
    GoTo Battles_DoTrainerBattle
    End

Battles_LostBattle:
    BlackOutFromBattle
    ReleaseAll
    End

Battles_NotEnoughPokemonMessage:
    GetTrainerID VAR_0x8004
    OpenMessage
    GetTrainerMessageTypes VAR_0x8000, VAR_0x8001, VAR_0x8002
    PrintTrainerDialogue VAR_0x8004, VAR_0x8002
    WaitABPress
    CloseMessage
    ReleaseAll
    End

Battles_RevealTrainer:
    ApplyMovement VAR_LAST_TALKED, Battles_Movement_RevealTrainer
    WaitMovement
    GetPlayerDir VAR_0x8000
    CallIfEq VAR_0x8000, DIR_NORTH, Battles_SetTrainerLookSouth
    CallIfEq VAR_0x8000, DIR_SOUTH, Battles_SetTrainerLookNorth
    CallIfEq VAR_0x8000, DIR_WEST, Battles_SetTrainerLookEast
    CallIfEq VAR_0x8000, DIR_EAST, Battles_SetTrainerLookWest
    Return

Battles_SetTrainerLookSouth:
    SetMovementType VAR_LAST_TALKED, MOVEMENT_TYPE_LOOK_SOUTH
    Return

Battles_SetTrainerLookNorth:
    SetMovementType VAR_LAST_TALKED, MOVEMENT_TYPE_LOOK_NORTH
    Return

Battles_SetTrainerLookEast:
    SetMovementType VAR_LAST_TALKED, MOVEMENT_TYPE_LOOK_EAST
    Return

Battles_SetTrainerLookWest:
    SetMovementType VAR_LAST_TALKED, MOVEMENT_TYPE_LOOK_WEST
    Return

    .balign 4, 0
Battles_Movement_RevealTrainer:
    RevealTrainer
    EndMovement

Battles_ApproachingTrainer:
    LockAll
    GetApproachingTrainerType VAR_RESULT
    GoToIfEq VAR_RESULT, APPROACH_TYPE_SINGLES, Battles_ApproachingTrainerSingles
    GoToIfEq VAR_RESULT, APPROACH_TYPE_DOUBLES, Battles_ApproachingTrainerDoubles
    GoToIfEq VAR_RESULT, APPROACH_TYPE_VS2, Battles_ApproachingTrainerVS2
    End

Battles_ApproachingTrainerSingles:
    GetApproachingTrainerID 0, VAR_RESULT
    SetVar VAR_0x8004, VAR_RESULT
    PlayTrainerEncounterBGM VAR_0x8004
    StartApproachingTrainerTask 0
    Call Battles_WaitTrainerSinglesTaskDone
    GetApproachingTrainerID 0, VAR_RESULT
    SetVar VAR_0x8004, VAR_RESULT
    OpenMessage
    PrintTrainerDialogue VAR_0x8004, TRMSG_PRE_BATTLE
    CloseMessage
    StartTrainerBattle VAR_0x8004
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_LostBattle
    GetApproachingTrainerID 0, VAR_RESULT
    SetVar VAR_0x8004, VAR_RESULT
    SetTrainerFlag VAR_0x8004
    Call Battles_CompletePhoneAfterBattle // Sovereign Complete: HeartGold's phone trainers
    ReleaseAll
    End

Battles_WaitTrainerSinglesTaskDone:
    CheckIsApproachingTrainerTaskDone 0, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_WaitTrainerSinglesTaskDone
    Return

Battles_ApproachingTrainerDoubles:
    GetApproachingTrainerID 0, VAR_RESULT
    SetVar VAR_0x8004, VAR_RESULT
    PlayTrainerEncounterBGM VAR_0x8004
    StartApproachingTrainerTask 0
    StartApproachingTrainerTask 1
    Call Battles_WaitTrainersDoublesTasksDone
    GetApproachingTrainerID 0, VAR_RESULT
    SetVar VAR_0x8004, VAR_RESULT
    OpenMessage
    PrintTrainerDialogue VAR_0x8004, TRMSG_PRE_DOUBLE_BATTLE_1
    CloseMessage
    GetApproachingTrainerID 1, VAR_RESULT
    SetVar VAR_0x8005, VAR_RESULT
    OpenMessage
    PrintTrainerDialogue VAR_0x8005, TRMSG_PRE_DOUBLE_BATTLE_2
    CloseMessage
    StartTrainerBattle VAR_0x8004, VAR_0x8005
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_LostBattle
    GetApproachingTrainerID 0, VAR_RESULT
    SetVar VAR_0x8004, VAR_RESULT
    SetTrainerFlag VAR_0x8004
    GetApproachingTrainerID 1, VAR_RESULT
    SetVar VAR_0x8005, VAR_RESULT
    SetTrainerFlag VAR_0x8005
    Call Battles_CompletePhoneAfterDoubleBattle // Sovereign Complete: HeartGold's phone trainers
    ReleaseAll
    End

Battles_WaitTrainersDoublesTasksDone:
    CheckIsApproachingTrainerTaskDone 0, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_WaitTrainersDoublesTasksDone
    CheckIsApproachingTrainerTaskDone 1, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_WaitTrainersDoublesTasksDone
    Return

Battles_ApproachingTrainerVS2:
    GetApproachingTrainerID 0, VAR_RESULT
    SetVar VAR_0x8004, VAR_RESULT
    PlayTrainerEncounterBGM VAR_0x8004
    StartApproachingTrainerTask 0
    Call Battles_WaitTrainer0VS2TaskDone
    GetApproachingTrainerID 0, VAR_RESULT
    SetVar VAR_0x8004, VAR_RESULT
    OpenMessage
    PrintTrainerDialogue VAR_0x8004, TRMSG_PRE_BATTLE
    CloseMessage
    GetApproachingTrainerID 1, VAR_RESULT
    SetVar VAR_0x8005, VAR_RESULT
    PlayTrainerEncounterBGM VAR_0x8005
    StartApproachingTrainerTask 1
    Call Battles_WaitTrainer1VS2TaskDone
    GetApproachingTrainerID 1, VAR_RESULT
    SetVar VAR_0x8005, VAR_RESULT
    OpenMessage
    PrintTrainerDialogue VAR_0x8005, TRMSG_PRE_BATTLE
    CloseMessage
    StartTrainerBattle VAR_0x8004, VAR_0x8005
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_LostBattle
    GetApproachingTrainerID 0, VAR_RESULT
    SetVar VAR_0x8004, VAR_RESULT
    SetTrainerFlag VAR_0x8004
    GetApproachingTrainerID 1, VAR_RESULT
    SetVar VAR_0x8005, VAR_RESULT
    SetTrainerFlag VAR_0x8005
    Call Battles_CompletePhoneAfterDoubleBattle // Sovereign Complete: HeartGold's phone trainers
    ReleaseAll
    End

Battles_WaitTrainer0VS2TaskDone:
    CheckIsApproachingTrainerTaskDone 0, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_WaitTrainer0VS2TaskDone
    Return

Battles_WaitTrainer1VS2TaskDone:
    CheckIsApproachingTrainerTaskDone 1, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_WaitTrainer1VS2TaskDone
    Return

    .balign 4, 0

// Sovereign Complete: HeartGold's phone trainers (its scr_seq_0953; src/overlay006/complete_phone_calls.c). A trainer
// with a Pokégear number asks for the player's after the first battle; when talked to after that, they battle again if
// a call asked for a rematch, hand over a gift a call promised, or ask for the number again. A rematch won ends the
// rematch, and some of them give an item for it. VAR_0x8006 holds the contact.
Battles_CompletePhoneDefeated:
    SetVar VAR_RESULT, TRAINER_NONE
    CompletePhoneLoadContact VAR_0x8004, VAR_0x8006
    GoToIfEq VAR_0x8006, PHONE_CONTACT_NONE, Battles_CompletePhoneReturn
    CompletePhoneGetRematch VAR_0x8006, VAR_RESULT
    GoToIfNe VAR_RESULT, TRAINER_NONE, Battles_CompletePhoneReturn
    CompletePhoneTakeGift VAR_0x8006, VAR_0x8005
    GoToIfNe VAR_0x8005, ITEM_NONE, Battles_CompletePhoneGiveGift
    CompletePhoneCheckRegistered VAR_0x8006, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_CompletePhoneAskAgain
    SetVar VAR_RESULT, TRAINER_NONE
    Return

Battles_CompletePhoneAfterDoubleBattle:
    CompletePhoneLoadContact VAR_0x8004, VAR_0x8006
    GoToIfNe VAR_0x8006, PHONE_CONTACT_NONE, Battles_CompletePhoneAfterBattleContact
    CompletePhoneLoadContact VAR_0x8005, VAR_0x8006
    GoToIfNe VAR_0x8006, PHONE_CONTACT_NONE, Battles_CompletePhoneAfterBattleContact
    Return

Battles_CompletePhoneAfterBattle:
    CompletePhoneLoadContact VAR_0x8004, VAR_0x8006
    GoToIfEq VAR_0x8006, PHONE_CONTACT_NONE, Battles_CompletePhoneReturn
Battles_CompletePhoneAfterBattleContact:
    CompletePhoneGetRematch VAR_0x8006, VAR_RESULT
    GoToIfNe VAR_RESULT, TRAINER_NONE, Battles_CompletePhoneAfterRematch
    CompletePhoneCheckRegistered VAR_0x8006, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Battles_CompletePhoneAskFirst
    Return

Battles_CompletePhoneAfterRematch:
    CompletePhoneEndRematch VAR_0x8006
    CompletePhoneRematchGift VAR_0x8006, VAR_0x8005
    GoToIfNe VAR_0x8005, ITEM_NONE, Battles_CompletePhoneGiveGift
    Return

Battles_CompletePhoneGiveGift:
    CompletePhoneContactMessage VAR_0x8006, 4, VAR_0x8000, VAR_0x8001
    BufferPlayerName 0
    MessageFromBank VAR_0x8000, VAR_0x8001
    SetVar VAR_0x8004, VAR_0x8005
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, Battles_CompletePhoneBagIsFull
    Common_GiveItemQuantityNoLineFeed
    GoTo Battles_CompletePhoneGiftEnd

Battles_CompletePhoneBagIsFull:
    Common_MessageBagIsFull
Battles_CompletePhoneGiftEnd:
    CloseMessage
    SetVar VAR_RESULT, 0xFFFF
    Return

Battles_CompletePhoneAskFirst:
    CompletePhoneContactMessage VAR_0x8006, 0, VAR_0x8000, VAR_0x8001
    GoTo Battles_CompletePhoneAsk

Battles_CompletePhoneAskAgain:
    CompletePhoneContactMessage VAR_0x8006, 3, VAR_0x8000, VAR_0x8001
Battles_CompletePhoneAsk:
    BufferPlayerName 0
    MessageFromBank VAR_0x8000, VAR_0x8001
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, Battles_CompletePhoneDeclined
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    MessageFromBank TEXT_BANK_HGSS_MSG_0040, 101
    CompletePhoneRegister VAR_0x8006
    CompletePhoneContactMessage VAR_0x8006, 1, VAR_0x8000, VAR_0x8001
    GoTo Battles_CompletePhoneAnswer

Battles_CompletePhoneDeclined:
    CompletePhoneContactMessage VAR_0x8006, 2, VAR_0x8000, VAR_0x8001
Battles_CompletePhoneAnswer:
    MessageFromBank VAR_0x8000, VAR_0x8001
    WaitButton
    CloseMessage
    SetVar VAR_RESULT, 0xFFFF
    Return

Battles_CompletePhoneReturn:
    Return

Battles_CompletePhoneDone:
    ReleaseAll
    End
