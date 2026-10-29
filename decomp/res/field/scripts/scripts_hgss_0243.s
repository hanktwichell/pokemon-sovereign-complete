#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0390.h"

#define obj_R36_usokky 4
#define obj_R36_gsgirl1_2 5

    ScriptEntry scr_seq_R36_000
    ScriptEntry scr_seq_R36_001
    ScriptEntry scr_seq_R36_002
    ScriptEntry scr_seq_R36_003
    ScriptEntry scr_seq_R36_004
    ScriptEntry scr_seq_R36_005
    ScriptEntry scr_seq_R36_006
    ScriptEntry scr_seq_R36_007
    ScriptEntry scr_seq_R36_008
    ScriptEntry scr_seq_R36_009
    ScriptEntry scr_seq_R36_010
    ScriptEntryEnd
scr_seq_R36_002:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0049
    ClearFlag FLAG_HGSS_UNK_1C4
    GoTo _004D
_0049:
    SetFlag FLAG_HGSS_UNK_1C4
_004D:
    End
scr_seq_R36_010:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _005C
    End
_005C:
    SetFlag FLAG_HGSS_HIDE_ROUTE_36_SUDOWOODO
    RemoveObject obj_R36_usokky
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_R36_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfUnset FLAG_HGSS_HIDE_GOLDENROD_FLOWERSHOP_GIRL, _0261
    CheckItem ITEM_SQUIRTBOTTLE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _009A
    ApplyMovement obj_R36_gsgirl1_2, _053C
    WaitMovement
_009A:
    ApplyMovement obj_R36_usokky, _038C
    WaitMovement
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00B9
    ReleaseAll
    End
_00B9:
    Message msg_0390_R36_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00E0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _025B
    End
_00E0:
    BufferPlayerName 0
    Message msg_0390_R36_00001
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_WEST
    GoToIf 5, _0109
    ApplyMovement LOCALID_PLAYER, _039C
    GoTo _012C
_0109:
    CompareVar VAR_RESULT, DIR_SOUTH
    GoToIf 5, _0124
    ApplyMovement LOCALID_PLAYER, _03AC
    GoTo _012C
_0124:
    ApplyMovement LOCALID_PLAYER, _03A4
_012C:
    WaitMovement
    SetFlag FLAG_HGSS_UNK_0B4
    Message msg_0390_R36_00002
    CloseMessage
    ApplyMovement obj_R36_usokky, _0394
    WaitMovement
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_SUDOWOODO, 20, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0255
    @ HGSS: GetStaticEncounterOutcome VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, BATTLE_RESULT_DRAW
    GoToIf 1, _0251
    CompareVar VAR_MAP_LOCAL_0x01, BATTLE_RESULT_CAPTURED_MON
    CallIf 1, _023F
    SetFlag FLAG_HGSS_UNK_0B5
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_NORTH
    GoToIf 5, _01BC
    CompleteFollowerPause FALSE
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _03B4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause TRUE
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _01C6
_01BC:
    ApplyMovement obj_R36_gsgirl1_2, _0360
    WaitMovement
_01C6:
    Message msg_0390_R36_00015
    SetVar VAR_0x8004, ITEM_BERRY_POTS
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0390_R36_00016
    Message msg_0390_R36_00017
    SetVar VAR_0x8004, ITEM_ORAN_BERRY
    SetVar VAR_0x8005, 3
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_PECHA_BERRY
    SetVar VAR_0x8005, 3
    Common_GiveItemQuantity
    Message msg_0390_R36_00018
    CloseMessage
_0200:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0225
    ApplyMovement obj_R36_gsgirl1_2, _0378
    WaitMovement
    GoTo _022F
_0225:
    ApplyMovement obj_R36_gsgirl1_2, _0380
    WaitMovement
_022F:
    RemoveObject obj_R36_gsgirl1_2
    SetFlag FLAG_HGSS_HIDE_ROUTE_36_FLOWERSHOP_GIRL
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_FLOWERSHOP_GIRL
    ReleaseAll
    End
_023F:
    SetFlag FLAG_HGSS_CAUGHT_SUDOWOODO
    Return
    Common_MessageBagIsFull
    CloseMessage
    GoTo _0200
_0251:
    ReleaseAll
    End
_0255:
    BlackOutFromBattle
    ReleaseAll
    End
_025B:
    CloseMessage
    ReleaseAll
    End
_0261:
    ApplyMovement obj_R36_usokky, _038C
    WaitMovement
    Message msg_0390_R36_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0296
    CompareVar VAR_RESULT, 1
    GoToIf 1, _025B
    End
_0296:
    BufferPlayerName 0
    Message msg_0390_R36_00001
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _02BF
    ApplyMovement LOCALID_PLAYER, _039C
    GoTo _02E2
_02BF:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02DA
    ApplyMovement LOCALID_PLAYER, _03AC
    GoTo _02E2
_02DA:
    ApplyMovement LOCALID_PLAYER, _03A4
_02E2:
    WaitMovement
    Message msg_0390_R36_00002
    CloseMessage
    ApplyMovement obj_R36_usokky, _0394
    WaitMovement
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_SUDOWOODO, 20, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0255
    @ HGSS: GetStaticEncounterOutcome VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, BATTLE_RESULT_CAPTURED_MON
    CallIf 1, _023F
    @ HGSS: StaticWildWonOrCaughtCheck VAR_TEMP_x4000, 0
    CompareVar VAR_MAP_LOCAL_0x00, TRUE
    GoToIf 1, _0251
    ReleaseAll
    End
    .balign 4, 0
    @ HGSS: _0340: // unreferenced
    WalkNormalNorth 2
    FaceSouth
    EndMovement
    .balign 4, 0
    @ HGSS: _034C: // unreferenced
    Delay4 5
    WalkOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
    @ HGSS: _0358: // unreferenced
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0360:
    WalkNormalNorth 3
    FaceEast
    EndMovement
    .balign 4, 0
    @ HGSS: _036C: // unreferenced
    Delay8
    FaceSouth
    EndMovement
    .balign 4, 0
_0378:
    WalkNormalWest 10
    EndMovement
    .balign 4, 0
_0380:
    WalkNormalSouth 2
    WalkNormalWest 10
    EndMovement
    .balign 4, 0
_038C:
    WalkOnSpotNormalNorth 3
    EndMovement
    .balign 4, 0
_0394:
    WalkOnSpotFastNorth 6
    EndMovement
    .balign 4, 0
_039C:
    WalkOnSpotSlowWest 4
    EndMovement
    .balign 4, 0
_03A4:
    WalkOnSpotSlowNorth 4
    EndMovement
    .balign 4, 0
_03AC:
    WalkOnSpotSlowSouth 4
    EndMovement
    .balign 4, 0
_03B4:
    WalkNormalSouth
    EndMovement
scr_seq_R36_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    @ HGSS: MonHasRibbon VAR_SPECIAL_RESULT, VAR_SPECIAL_x8002, RIBBON_CARELESS
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04E2
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _04F6
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _0490
    GoToIfSet FLAG_HGSS_GOT_HARD_STONE_FROM_ARTHUR, _0472
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0423
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 15
    GoTo _046A
_0423:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 12
    SetVar VAR_0x8004, ITEM_HARD_STONE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0486
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HARD_STONE_FROM_ARTHUR
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 13
_046A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0472:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 14
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0486:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0490:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _04B3
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 15
    GoTo _046A
_04B3:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 40
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 42
    @ HGSS: GiveRibbon VAR_SPECIAL_x8002, RIBBON_CARELESS
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04E2:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 41
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04F6:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 43
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R36_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_SQUIRTBOTTLE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0530
    Message msg_0390_R36_00013
    GoTo _0533
_0530:
    Message msg_0390_R36_00014
_0533:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_053C:
    FaceNorth
    EndMovement
scr_seq_R36_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_HM06, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0572
    Message msg_0390_R36_00003
    SetVar VAR_0x8004, ITEM_HM06
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
_0572:
    Message msg_0390_R36_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    Message msg_0390_R36_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_R36_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_HIDE_ROUTE_36_SUDOWOODO, _05AE
    Message msg_0390_R36_00007
    GoTo _05B1
_05AE:
    Message msg_0390_R36_00008
_05B1:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R36_003:
    DrawSignpostInstantMessage msg_0390_R36_00009, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R36_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0390_R36_00010, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R36_005:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0390_R36_00011, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R36_006:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0390_R36_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
