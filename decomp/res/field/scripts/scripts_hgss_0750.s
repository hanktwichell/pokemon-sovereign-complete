#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0460.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T03_gswoman3 1
#define obj_T03_gsmiddleman1 7
#define obj_T03_daigo 8
#define obj_T03_tsure_poke_static_latios 9
#define obj_T03_tsure_poke_static_latias 10

    ScriptEntry scr_seq_T03_000
    ScriptEntry scr_seq_T03_001
    ScriptEntry scr_seq_T03_002
    ScriptEntry scr_seq_T03_003
    ScriptEntry scr_seq_T03_004
    ScriptEntry scr_seq_T03_005
    ScriptEntry scr_seq_T03_006
    ScriptEntry scr_seq_T03_007
    ScriptEntry scr_seq_T03_008
    ScriptEntry scr_seq_T03_009
    ScriptEntry scr_seq_T03_010
    ScriptEntry scr_seq_T03_011
    ScriptEntry scr_seq_T03_012
    ScriptEntry scr_seq_T03_013
    ScriptEntry scr_seq_T03_014
    ScriptEntry scr_seq_T03_015
    ScriptEntryEnd
scr_seq_T03_008:
    GoToIfUnset FLAG_HGSS_UNK_189, _02AD
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T03_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _02B3
    GoToIfSet FLAG_HGSS_UNK_094, _02F4
    GoTo _02FF
scr_seq_T03_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0335
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0349
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _035D
    ApplyMovement LOCALID_PLAYER, _086A
    GoTo _0380
scr_seq_T03_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0460_T03_00000
    GiveEgg SPECIES_PHIONE, 12
    GiveEgg SPECIES_PHIONE, 8
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03_002:
    NPCMessage msg_0460_T03_00001
    End
scr_seq_T03_003:
    DrawSignpostInstantMessage msg_0460_T03_00020, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T03_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0460_T03_00021, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T03_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0460_T03_00022, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T03_006:
    DrawSignpostInstantMessage msg_0460_T03_00023, SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T03_011:
    CompareVar VAR_HGSS_UNK_4083, 2
    GoToIf 1, _03E1
    End
scr_seq_T03_013:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _03EF
    End
scr_seq_T03_012:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0874
    WaitMovement
    ApplyMovement obj_T03_daigo, _087E
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0419
    Message msg_0460_T03_00006
    GoTo _0454
scr_seq_T03_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _048C
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0490
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 381
    PlayCry VAR_MAP_LOCAL_0x0A, 0
    Message msg_0460_T03_00010
    GoTo _0508
scr_seq_T03_009:
    NPCMessage msg_0460_T03_00019
    End
scr_seq_T03_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_LATIAS, 0
    Message msg_0460_T03_00006
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_LATIAS, 50, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02F4
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_T03_gswoman3
    SetFlag FLAG_HGSS_SG_3FDD
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T03_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0460_T03_00025
    CloseMessage
    BufferPlayerName 0
    ApplyMovement LOCALID_PLAYER, _08EA
    WaitMovement
    RemoveObject 11
    SetVar VAR_0x8004, ITEM_STONE_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0460_T03_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02AD:
    GoTo _0571
_02B3:
    GoToIfSet FLAG_HGSS_UNK_093, _02F4
    Message msg_0460_T03_00002
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _059E
    SetVarFromValue VAR_0x8004, ITEM_SILVER_WING
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    SetFlag FLAG_HGSS_UNK_094
    ClearFlag FLAG_HGSS_HIDE_WHIRL_ISLAND_LUGIA
    SetFlag FLAG_HGSS_HIDE_WHIRL_ISLANDS_BOTTOM_KIMONO_GIRLS
    GoTo _05C0
_02F4:
    Message msg_0460_T03_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02FF:
    Message msg_0460_T03_00002
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _059E
    SetVarFromValue VAR_0x8004, ITEM_SILVER_WING
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    SetFlag FLAG_HGSS_UNK_094
    ClearFlag FLAG_HGSS_HIDE_WHIRL_ISLAND_LUGIA
    SetFlag FLAG_HGSS_HIDE_WHIRL_ISLANDS_BOTTOM_KIMONO_GIRLS
    GoTo _05C0
_0335:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0349:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_035D:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _05C6
    ApplyMovement LOCALID_PLAYER, _0884
    ApplyMovement obj_T03_gsmiddleman1, _0896
    GoTo _0380
_0380:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0637
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _08A0
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 66
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E1:
    SetPosition obj_T03_daigo, 1047, 6, 81, DIR_WEST
    End
_03EF:
    GoToIfSet FLAG_HGSS_SG_3FFF, _0490
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0671
    SetFlag FLAG_HGSS_HIDE_PEWTER_CITY_LATIOS
    RemoveObject obj_T03_tsure_poke_static_latios
    GoTo _067B
_0419:
    Message msg_0460_T03_00007
    CloseMessage
    ApplyMovement obj_T03_daigo, _08AE
    ApplyMovement LOCALID_PLAYER, _08AE
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0681
    Message msg_0460_T03_00008
    GoTo _0692
_0454:
    CloseMessage
    ApplyMovement obj_T03_daigo, _08AE
    ApplyMovement LOCALID_PLAYER, _08AE
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0681
    Message msg_0460_T03_00008
    GoTo _0692
_048C:
    ReleaseAll
    End
_0490:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 380
    PlayCry VAR_MAP_LOCAL_0x0A, 0
    Message msg_0460_T03_00011
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle VAR_MAP_LOCAL_0x0A, 40, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteGetBattleResult VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _06A0
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _06A0
    CompleteCheckLastBattleNotBeaten VAR_RESULT, 1
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06A8
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06C2
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _06E1
    Message msg_0460_T03_00012
    GoTo _06F9
_0508:
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle VAR_MAP_LOCAL_0x0A, 40, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteGetBattleResult VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _06A0
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _06A0
    CompleteCheckLastBattleNotBeaten VAR_RESULT, 1
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06A8
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06C2
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _06E1
    Message msg_0460_T03_00012
    GoTo _06F9
_0571:
    CompareVar VAR_HGSS_UNK_4083, 4
    GoToIf 1, _070E
    CompareVar VAR_HGSS_UNK_4083, 2
    GoToIf 1, _0729
    CompareVar VAR_HGSS_UNK_4083, 3
    GoToIf 1, _0729
    GoTo _0748
_059E:
    SetVarFromValue VAR_0x8004, ITEM_RAINBOW_WING
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    SetFlag FLAG_HGSS_UNK_093
    ClearFlag FLAG_HGSS_HIDE_BELL_TOWER_HO_OH
    SetFlag FLAG_HGSS_HIDE_BELL_TOWER_SUMMIT_KIMONO_GIRLS
    CloseMessage
    ReleaseAll
    End
_05C0:
    CloseMessage
    ReleaseAll
    End
_05C6:
    ApplyMovement LOCALID_PLAYER, _08B4
    ApplyMovement obj_T03_gsmiddleman1, _0896
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0637
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _08A0
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 66
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0637:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 66
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0671:
    SetFlag FLAG_HGSS_HIDE_PEWTER_CITY_LATIAS
    RemoveObject obj_T03_tsure_poke_static_latias
    End
_067B:
    GoTo _0508
_0681:
    Message msg_0460_T03_00009
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4083, 3
    ReleaseAll
    End
_0692:
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4083, 3
    ReleaseAll
    End
_06A0:
    BlackOutFromBattle
    GoTo _048C
_06A8:
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _06E1
    Message msg_0460_T03_00012
    GoTo _06F9
_06C2:
    SetVarFromVar VAR_MAP_LOCAL_0x09, VAR_HGSS_UNK_4083
    SetVarFromValue VAR_HGSS_UNK_4083, 5
    CompareVar VAR_MAP_LOCAL_0x09, 4
    GoToIf 1, _048C
    GoTo _076C
_06E1:
    Message msg_0460_T03_00013
    CloseMessage
    CompareVar VAR_HGSS_UNK_4083, 4
    GoToIf 1, _048C
    GoTo _076C
_06F9:
    CloseMessage
    CompareVar VAR_HGSS_UNK_4083, 4
    GoToIf 1, _048C
    GoTo _076C
_070E:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _07D3
    ClearFlag FLAG_HGSS_HIDE_PEWTER_CITY_LATIOS
    GoTo _07D9
_0729:
    ClearFlag FLAG_HGSS_HIDE_PEWTER_CITY_STEVEN
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _07D3
    ClearFlag FLAG_HGSS_HIDE_PEWTER_CITY_LATIOS
    GoTo _07D9
_0748:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _07DB
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _07DB
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_076C:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T03_daigo, _08C6
    ApplyMovement LOCALID_PLAYER, _08D0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _07E1
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _07F2
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _080C
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0817
    Message msg_0460_T03_00016
    GoTo _0828
_07D3:
    ClearFlag FLAG_HGSS_HIDE_PEWTER_CITY_LATIAS
    End
_07D9:
    End
_07DB:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
_07E1:
    Message msg_0460_T03_00018
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4083, 4
    GoTo _0836
_07F2:
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0817
    Message msg_0460_T03_00016
    GoTo _0828
_080C:
    Message msg_0460_T03_00014
    CloseMessage
    GoTo _0836
_0817:
    Message msg_0460_T03_00017
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4083, 4
    GoTo _0836
_0828:
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4083, 4
    GoTo _0836
_0836:
    ApplyMovement obj_T03_daigo, _08DE
    WaitMovement
    Message msg_0460_T03_00015
    CloseMessage
    ApplyMovement obj_T03_daigo, _08E4
    WaitMovement
    RemoveObject obj_T03_daigo
    CompareVar VAR_HGSS_UNK_4130, 4
    CallIf 1, _0864
    ReleaseAll
    End
_0864:
    ClearFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    Return
    .balign 4, 0
_086A:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0874:
    WalkNormalSouth 4
    FaceWest
    EndMovement
    .balign 4, 0
_087E:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0884:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0896:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_08A0:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_08AE:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_08B4:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_08C6:
    WalkNormalSouth 2
    WalkNormalWest
    EndMovement
    .balign 4, 0
_08D0:
    Delay8
    WalkNormalEast 2
    Delay8
    EndMovement
    .balign 4, 0
_08DE:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_08E4:
    WalkNormalEast 8
    EndMovement
    .balign 4, 0
_08EA:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
