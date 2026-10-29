#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "generated/ribbons.h"
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
    ScriptEntry scr_seq_R36_011
    ScriptEntry scr_seq_R36_012
    ScriptEntryEnd
scr_seq_R36_002:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0237
    ClearFlag FLAG_HGSS_UNK_1C4
    GoTo _023D
scr_seq_R36_010:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _023F
    End
scr_seq_R36_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfUnset FLAG_HGSS_HIDE_GOLDENROD_FLOWERSHOP_GIRL, _024D
    CheckItem ITEM_SQUIRTBOTTLE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0282
    ApplyMovement obj_R36_gsgirl1_2, _0782
    WaitMovement
    ApplyMovement obj_R36_usokky, _0788
    WaitMovement
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02A1
    ReleaseAll
    End
scr_seq_R36_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    GetPartyMonRibbon VAR_RESULT, VAR_0x8002, RIBBON_CARELESS
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02C8
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _02DC
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _02F0
    GoToIfSet FLAG_HGSS_GOT_HARD_STONE_FROM_ARTHUR, _0313
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0327
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 15
    GoTo _0376
scr_seq_R36_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_SQUIRTBOTTLE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _037E
    Message msg_0390_R36_00013
    GoTo _0389
scr_seq_R36_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_HM06, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0391
    Message msg_0390_R36_00003
    SetVar VAR_0x8004, ITEM_HM06
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0390_R36_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R36_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_HIDE_ROUTE_36_SUDOWOODO, _039C
    Message msg_0390_R36_00007
    GoTo _03A7
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
scr_seq_R36_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfSet FLAG_HGSS_SG_3F77, _03AF
    Message msg_0390_R36_00022
    CloseMessage
    CompleteScreenShake 3, 3, 15, 5
    FacePlayer
    Message msg_0390_R36_00020
    SetVar VAR_0x8004, ITEM_TM31
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0390_R36_00021
    SetFlag FLAG_HGSS_SG_3F77
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R36_012:
    End
_0237:
    SetFlag FLAG_HGSS_UNK_1C4
    End
_023D:
    End
_023F:
    SetFlag FLAG_HGSS_HIDE_ROUTE_36_SUDOWOODO
    RemoveObject obj_R36_usokky
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_024D:
    ApplyMovement obj_R36_usokky, _0788
    WaitMovement
    Message msg_0390_R36_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03BA
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03E3
    End
_0282:
    ApplyMovement obj_R36_usokky, _0788
    WaitMovement
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02A1
    ReleaseAll
    End
_02A1:
    Message msg_0390_R36_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03E9
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03E3
    End
_02C8:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 41
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02DC:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 43
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02F0:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0412
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 15
    GoTo _0376
_0313:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 14
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0327:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 12
    SetVar VAR_0x8004, ITEM_HARD_STONE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _043B
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HARD_STONE_FROM_ARTHUR
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 13
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0376:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_037E:
    Message msg_0390_R36_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0389:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0391:
    Message msg_0390_R36_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_039C:
    Message msg_0390_R36_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03A7:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03AF:
    Message msg_0390_R36_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03BA:
    BufferPlayerName 0
    Message msg_0390_R36_00001
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0445
    ApplyMovement LOCALID_PLAYER, _078E
    GoTo _0460
_03E3:
    CloseMessage
    ReleaseAll
    End
_03E9:
    BufferPlayerName 0
    Message msg_0390_R36_00001
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _04BC
    ApplyMovement LOCALID_PLAYER, _078E
    GoTo _04D7
_0412:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 40
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 42
    SetPartyMonRibbon VAR_0x8002, RIBBON_CARELESS
    PlayFanfare 20
    @ HGSS data: .byte 217, 7, 53, 0, 97, 0, 2, 0
_043B:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0445:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0567
    ApplyMovement LOCALID_PLAYER, _0794
    GoTo _0460
_0460:
    WaitMovement
    Message msg_0390_R36_00002
    CloseMessage
    ApplyMovement obj_R36_usokky, _079A
    WaitMovement
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_SUDOWOODO, 25, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05CB
    CompleteGetBattleResult VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    CallIf 1, _05D1
    CompleteCheckStaticNotBeaten VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _05D7
    ReleaseAll
    End
_04BC:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05DB
    ApplyMovement LOCALID_PLAYER, _0794
    GoTo _04D7
_04D7:
    WaitMovement
    SetFlag FLAG_HGSS_UNK_0B4
    Message msg_0390_R36_00002
    CloseMessage
    ApplyMovement obj_R36_usokky, _079A
    WaitMovement
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_SUDOWOODO, 25, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05CB
    CompleteGetBattleResult VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _05D7
    CompareVar VAR_MAP_LOCAL_0x01, 4
    CallIf 1, _05D1
    SetFlag FLAG_HGSS_UNK_0B5
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0673
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _07A0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _06DC
_0567:
    ApplyMovement LOCALID_PLAYER, _07A6
    WaitMovement
    Message msg_0390_R36_00002
    CloseMessage
    ApplyMovement obj_R36_usokky, _079A
    WaitMovement
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_SUDOWOODO, 25, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05CB
    CompleteGetBattleResult VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    CallIf 1, _05D1
    CompleteCheckStaticNotBeaten VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _05D7
    ReleaseAll
    End
_05CB:
    BlackOutFromBattle
    ReleaseAll
    End
_05D1:
    SetFlag FLAG_HGSS_CAUGHT_SUDOWOODO
    Return
_05D7:
    ReleaseAll
    End
_05DB:
    ApplyMovement LOCALID_PLAYER, _07A6
    WaitMovement
    SetFlag FLAG_HGSS_UNK_0B4
    Message msg_0390_R36_00002
    CloseMessage
    ApplyMovement obj_R36_usokky, _079A
    WaitMovement
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_SUDOWOODO, 25, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05CB
    CompleteGetBattleResult VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _05D7
    CompareVar VAR_MAP_LOCAL_0x01, 4
    CallIf 1, _05D1
    SetFlag FLAG_HGSS_UNK_0B5
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0673
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _07A0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _06DC
_0673:
    ApplyMovement obj_R36_gsgirl1_2, _07AC
    WaitMovement
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
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _073B
    ApplyMovement obj_R36_gsgirl1_2, _07B6
    WaitMovement
    GoTo _0772
_06DC:
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
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _073B
    ApplyMovement obj_R36_gsgirl1_2, _07B6
    WaitMovement
    GoTo _0772
_073B:
    ApplyMovement obj_R36_gsgirl1_2, _07BC
    WaitMovement
    RemoveObject obj_R36_gsgirl1_2
    SetFlag FLAG_HGSS_HIDE_ROUTE_36_FLOWERSHOP_GIRL
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_FLOWERSHOP_GIRL
    LockAll
    Message msg_0390_R36_00019
    WaitFanfare
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FF0
    ClearFlag FLAG_HGSS_SG_3FEF
    ClearFlag FLAG_HGSS_SG_3FEE
    ClearFlag FLAG_HGSS_SG_3FED
    ReleaseAll
    End
_0772:
    RemoveObject obj_R36_gsgirl1_2
    SetFlag FLAG_HGSS_HIDE_ROUTE_36_FLOWERSHOP_GIRL
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_FLOWERSHOP_GIRL
    ReleaseAll
    End
    .balign 4, 0
_0782:
    FaceNorth
    EndMovement
    .balign 4, 0
_0788:
    WalkOnSpotNormalNorth 3
    EndMovement
    .balign 4, 0
_078E:
    WalkOnSpotSlowWest 4
    EndMovement
    .balign 4, 0
_0794:
    WalkOnSpotSlowSouth 4
    EndMovement
    .balign 4, 0
_079A:
    WalkOnSpotFastNorth 6
    EndMovement
    .balign 4, 0
_07A0:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_07A6:
    WalkOnSpotSlowNorth 4
    EndMovement
    .balign 4, 0
_07AC:
    WalkNormalNorth 3
    FaceEast
    EndMovement
    .balign 4, 0
_07B6:
    WalkNormalWest 10
    EndMovement
    .balign 4, 0
_07BC:
    WalkNormalSouth 2
    WalkNormalWest 10
    EndMovement
    .balign 4, 0
