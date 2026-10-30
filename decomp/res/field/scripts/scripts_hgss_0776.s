#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0483.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T06_gsmiddleman1_2 14
#define obj_T06_tsure_poke_static_suicune 15
#define obj_T06_minaki 16
#define obj_T06_minaki_2 17
#define obj_T06_daigo 18

    ScriptEntry scr_seq_T06_000
    ScriptEntry scr_seq_T06_001
    ScriptEntry scr_seq_T06_002
    ScriptEntry scr_seq_T06_003
    ScriptEntry scr_seq_T06_004
    ScriptEntry scr_seq_T06_005
    ScriptEntry scr_seq_T06_006
    ScriptEntry scr_seq_T06_007
    ScriptEntry scr_seq_T06_008
    ScriptEntry scr_seq_T06_009
    ScriptEntry scr_seq_T06_010
    ScriptEntry scr_seq_T06_011
    ScriptEntry scr_seq_T06_012
    ScriptEntry scr_seq_T06_013
    ScriptEntry scr_seq_T06_014
    ScriptEntry scr_seq_T06_015
    ScriptEntry scr_seq_T06_016
    ScriptEntryEnd
scr_seq_T06_009:
    GoToIfUnset FLAG_HGSS_UNK_189, _0315
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T06_013:
    LockAll
    BufferPlayerName 0
    BufferPlayerName 0
    ApplyMovement obj_T06_daigo, _0A40
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0A52
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0483_T06_00016
    CloseMessage
    ApplyMovement obj_T06_daigo, _0A60
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x04, 7
    CompareVar VAR_MAP_LOCAL_0x04, 8
    GoToIf 1, _0330
    DrawPokemonPreview SPECIES_LATIAS, 1
    Message msg_0483_T06_00017
    CloseMessage
    ActivateRoamingPokemon ROAMING_SLOT_LATIAS
    RemovePokemonPreview
    ApplyMovement obj_T06_daigo, _0A60
    WaitMovement
    Message msg_0483_T06_00019
    CloseMessage
    ApplyMovement obj_T06_daigo, _0A60
    WaitMovement
    Message msg_0483_T06_00021
    CloseMessage
    GoTo _0364
scr_seq_T06_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_PP_MAX_FROM_VERMILLION_CITY_MAN, _0393
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 4, _039E
    CompareVar VAR_HGSS_UNK_4135, 5
    GoToIf 4, _03D5
    CompareVar VAR_HGSS_UNK_4135, 1
    GoToIf 4, _03E0
    Message msg_0483_T06_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T06_011:
    LockAll
    ClearFlag FLAG_HGSS_HIDE_VERMILION_EUSINE
    AddObject obj_T06_minaki
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 1334
    GoToIf 5, _03EB
    GoTo _0450
scr_seq_T06_012:
    LockAll
    ClearFlag FLAG_HGSS_HIDE_VERMILION_EUSINE_2
    AddObject obj_T06_minaki_2
    ApplyMovement LOCALID_PLAYER, _0A66
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_T06_tsure_poke_static_suicune
    CompleteObjectSway obj_T06_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_T06_tsure_poke_static_suicune
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 1324
    GoToIf 5, _04DA
    ApplyMovement obj_T06_minaki_2, _0A6C
    ApplyMovement LOCALID_PLAYER, _0A7E
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0A88
    GoTo _0505
scr_seq_T06_001:
    NPCMessage msg_0483_T06_00000
    End
scr_seq_T06_002:
    NPCMessage msg_0483_T06_00003
    End
scr_seq_T06_003:
    NPCMessage msg_0483_T06_00001
    End
scr_seq_T06_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MAKUHITA, 0
    Message msg_0483_T06_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T06_005:
    DrawSignpostInstantMessage msg_0483_T06_00010, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T06_006:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0483_T06_00011, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T06_007:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0483_T06_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T06_008:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0483_T06_00013, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T06_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0574
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0588
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _059C
    ApplyMovement LOCALID_PLAYER, _0A92
    GoTo _05BF
scr_seq_T06_014:
    NPCMessage msg_0483_T06_00024
    End
scr_seq_T06_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0483_T06_00026
    WaitButton
    CloseMessage
    CheckItem ITEM_SOUL_DEW, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0620
    ReleaseAll
    End
scr_seq_T06_016:
    BufferPlayerName 0
    End
_0315:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _06F2
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0709
_0330:
    DrawPokemonPreview SPECIES_LATIOS, 0
    Message msg_0483_T06_00018
    CloseMessage
    ActivateRoamingPokemon ROAMING_SLOT_LATIOS
    RemovePokemonPreview
    ApplyMovement obj_T06_daigo, _0A60
    WaitMovement
    Message msg_0483_T06_00020
    CloseMessage
    ApplyMovement obj_T06_daigo, _0A60
    WaitMovement
    Message msg_0483_T06_00022
    CloseMessage
    GoTo _0364
_0364:
    ApplyMovement obj_T06_daigo, _0A60
    WaitMovement
    Message msg_0483_T06_00023
    CloseMessage
    ApplyMovement obj_T06_daigo, _0A9C
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4130, 2
    RemoveObject obj_T06_daigo
    SetFlag FLAG_HGSS_HIDE_VERMILION_CITY_STEVEN
    ClearFlag FLAG_HGSS_SG_3FBA
    ReleaseAll
    End
_0393:
    Message msg_0483_T06_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_039E:
    Message msg_0483_T06_00007
    SetVar VAR_0x8004, ITEM_PP_MAX
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0711
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_PP_MAX_FROM_VERMILLION_CITY_MAN
    Message msg_0483_T06_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03D5:
    Message msg_0483_T06_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E0:
    Message msg_0483_T06_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03EB:
    ApplyMovement LOCALID_PLAYER, _0A66
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_T06_tsure_poke_static_suicune
    CompleteObjectSway obj_T06_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_T06_tsure_poke_static_suicune
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 331
    GoToIf 5, _071B
    ApplyMovement LOCALID_PLAYER, _0AA2
    ApplyMovement obj_T06_minaki, _0AB0
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0A88
    GoTo _0746
_0450:
    ApplyMovement LOCALID_PLAYER, _0A66
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0ABE
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_T06_tsure_poke_static_suicune
    CompleteObjectSway obj_T06_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_T06_tsure_poke_static_suicune
    WaitCry
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0AC4
    ApplyMovement obj_T06_minaki, _0AE2
    ApplyMovement LOCALID_PLAYER, _0AF0
    WaitMovement
    ApplyMovement obj_T06_minaki, _0AFA
    ApplyMovement LOCALID_PLAYER, _0B00
    WaitMovement
    Message msg_0483_T06_00014
    CloseMessage
    ApplyMovement obj_T06_minaki, _0B06
    WaitMovement
    Message msg_0483_T06_00015
    CloseMessage
    ApplyMovement obj_T06_minaki, _0B0C
    ApplyMovement LOCALID_PLAYER, _0B12
    WaitMovement
    GoTo _07AD
_04DA:
    CompareVar VAR_MAP_LOCAL_0x00, 1325
    GoToIf 5, _07DF
    ApplyMovement obj_T06_minaki_2, _0B18
    ApplyMovement LOCALID_PLAYER, _0B2A
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0B34
    GoTo _0505
_0505:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0483_T06_00014
    CloseMessage
    ApplyMovement obj_T06_minaki_2, _0B3E
    ApplyMovement LOCALID_PLAYER, _0B44
    WaitMovement
    BufferPlayerName 0
    Message msg_0483_T06_00015
    CloseMessage
    ApplyMovement obj_T06_minaki_2, _0B4A
    ApplyMovement LOCALID_PLAYER, _0B54
    WaitMovement
    Common_FadeToDefaultMusic
    RemoveObject obj_T06_minaki_2
    RemoveObject obj_T06_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE_2
    SetFlag FLAG_HGSS_HIDE_VERMILION_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4070, 0
    SetVarFromValue VAR_HGSS_UNK_4071, 0
    ClearFlag FLAG_HGSS_HIDE_ROUTE_14_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4086, 1
    ReleaseAll
    End
_0574:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0588:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_059C:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0866
    ApplyMovement LOCALID_PLAYER, _0B66
    ApplyMovement obj_T06_gsmiddleman1_2, _0B78
    GoTo _05BF
_05BF:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _08D7
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0B82
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 50
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
_0620:
    Message msg_0483_T06_00034
    WaitButton
    CloseMessage
    StopMusic
    Message msg_0483_T06_00030
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0911
    FadeScreen 11, 5, 0, COLOR_WHITE
    WaitFadeScreen
    RemoveObject 20
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0919
    SetPosition 22, 1319, 0, 299, DIR_SOUTH
    ApplyMovement 22, _0B90
    PlayCry SPECIES_LATIOS, 0
    WaitCry
    FadeScreen 11, 5, 1, COLOR_WHITE
    WaitFadeScreen
    PlayCry SPECIES_LATIOS, 0
    Message msg_0483_T06_00033
    WaitCry
    CompleteStartWildBattle SPECIES_LATIOS, 40, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _099D
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _09A3
    LockAll
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 22
    SetFlag FLAG_HGSS_SG_3FCA
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _09A9
_06F2:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _09B5
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0709
_0709:
    SetVarFromValue VAR_HGSS_UNK_4085, 0
    End
_0711:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_071B:
    CompareVar VAR_MAP_LOCAL_0x01, 332
    GoToIf 5, _09C1
    ApplyMovement LOCALID_PLAYER, _0B96
    ApplyMovement obj_T06_minaki, _0BA4
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0B34
    GoTo _0746
_0746:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0483_T06_00014
    CloseMessage
    ApplyMovement obj_T06_minaki, _0BB2
    WaitMovement
    BufferPlayerName 0
    Message msg_0483_T06_00015
    CloseMessage
    ApplyMovement obj_T06_minaki, _0B0C
    ApplyMovement LOCALID_PLAYER, _0B12
    WaitMovement
    Common_FadeToDefaultMusic
    RemoveObject obj_T06_minaki
    RemoveObject obj_T06_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE_2
    SetFlag FLAG_HGSS_HIDE_VERMILION_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4070, 0
    SetVarFromValue VAR_HGSS_UNK_4071, 0
    ClearFlag FLAG_HGSS_HIDE_ROUTE_14_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4086, 1
    ReleaseAll
    End
_07AD:
    Common_FadeToDefaultMusic
    RemoveObject obj_T06_minaki
    RemoveObject obj_T06_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE_2
    SetFlag FLAG_HGSS_HIDE_VERMILION_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4070, 0
    SetVarFromValue VAR_HGSS_UNK_4071, 0
    ClearFlag FLAG_HGSS_HIDE_ROUTE_14_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4086, 1
    ReleaseAll
    End
_07DF:
    ApplyMovement obj_T06_minaki_2, _0BB8
    ApplyMovement LOCALID_PLAYER, _0BCA
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0BD4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0483_T06_00014
    CloseMessage
    ApplyMovement obj_T06_minaki_2, _0B3E
    ApplyMovement LOCALID_PLAYER, _0B44
    WaitMovement
    BufferPlayerName 0
    Message msg_0483_T06_00015
    CloseMessage
    ApplyMovement obj_T06_minaki_2, _0B4A
    ApplyMovement LOCALID_PLAYER, _0B54
    WaitMovement
    Common_FadeToDefaultMusic
    RemoveObject obj_T06_minaki_2
    RemoveObject obj_T06_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE_2
    SetFlag FLAG_HGSS_HIDE_VERMILION_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4070, 0
    SetVarFromValue VAR_HGSS_UNK_4071, 0
    ClearFlag FLAG_HGSS_HIDE_ROUTE_14_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4086, 1
    ReleaseAll
    End
_0866:
    ApplyMovement LOCALID_PLAYER, _0BDE
    ApplyMovement obj_T06_gsmiddleman1_2, _0B78
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _08D7
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0B82
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 50
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
_08D7:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 50
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
_0911:
    PlayMusic SEQ_GS_C_KUCHIBA_sseq
    ReleaseAll
    End
_0919:
    SetPosition 21, 1319, 0, 299, DIR_SOUTH
    ApplyMovement 21, _0B90
    PlayCry SPECIES_LATIAS, 0
    WaitCry
    FadeScreen 11, 5, 1, COLOR_WHITE
    WaitFadeScreen
    PlayCry SPECIES_LATIAS, 0
    Message msg_0483_T06_00028
    WaitCry
    CompleteStartWildBattle SPECIES_LATIAS, 40, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _099D
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _09A3
    LockAll
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_SG_3FCA
    RemoveObject 21
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _09A9
_099D:
    BlackOutFromBattle
    ReleaseAll
    End
_09A3:
    SetFlag FLAG_HGSS_SG_3FAF
    Return
_09A9:
    LockAll
    SetFlag FLAG_HGSS_SG_3FCA
    CloseMessage
    ReleaseAll
    End
_09B5:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    SetVarFromValue VAR_HGSS_UNK_4085, 0
    End
_09C1:
    ApplyMovement LOCALID_PLAYER, _0BF0
    ApplyMovement obj_T06_minaki, _0BFE
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0BD4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0483_T06_00014
    CloseMessage
    ApplyMovement obj_T06_minaki, _0BB2
    WaitMovement
    BufferPlayerName 0
    Message msg_0483_T06_00015
    CloseMessage
    ApplyMovement obj_T06_minaki, _0B0C
    ApplyMovement LOCALID_PLAYER, _0B12
    WaitMovement
    Common_FadeToDefaultMusic
    RemoveObject obj_T06_minaki
    RemoveObject obj_T06_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE_2
    SetFlag FLAG_HGSS_HIDE_VERMILION_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4070, 0
    SetVarFromValue VAR_HGSS_UNK_4071, 0
    ClearFlag FLAG_HGSS_HIDE_ROUTE_14_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4086, 1
    ReleaseAll
    End
    .balign 4, 0
_0A40:
    EmoteExclamationMark
    Delay8
    WalkNormalWest 4
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0A52:
    Delay16 4
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0A60:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0A66:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0A6C:
    Delay8
    WalkFastEast 7
    WalkFastNorth 3
    WalkFastEast
    EndMovement
    .balign 4, 0
_0A7E:
    WalkNormalSouth 4
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0A88:
    Delay4 9
    MoveAction_112
    EndMovement
    .balign 4, 0
_0A92:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0A9C:
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
_0AA2:
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0AB0:
    Delay8
    WalkFastSouth 6
    WalkFastEast
    EndMovement
    .balign 4, 0
_0ABE:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0AC4:
    Delay4 4
    WalkFasterSouth 2
    JumpNearFastSouth
    JumpFarSouth
    WalkFasterSouth 2
    JumpNearFastSouth
    JumpFarSouth 2
    EndMovement
    .balign 4, 0
_0AE2:
    Delay4 2
    WalkFastEast
    WalkFastSouth 2
    EndMovement
    .balign 4, 0
_0AF0:
    Delay4 4
    FaceSouth
    EndMovement
    .balign 4, 0
_0AFA:
    JumpOnSpotFastSouth 3
    EndMovement
    .balign 4, 0
_0B00:
    FaceWest
    EndMovement
    .balign 4, 0
_0B06:
    FaceEast
    EndMovement
    .balign 4, 0
_0B0C:
    WalkNormalNorth 8
    EndMovement
    .balign 4, 0
_0B12:
    FaceNorth
    EndMovement
    .balign 4, 0
_0B18:
    Delay8 2
    WalkFastEast 7
    WalkFastNorth 3
    WalkFastEast
    EndMovement
    .balign 4, 0
_0B2A:
    WalkNormalSouth 4
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0B34:
    Delay4 11
    MoveAction_112
    EndMovement
    .balign 4, 0
_0B3E:
    FaceNorth
    EndMovement
    .balign 4, 0
_0B44:
    FaceSouth
    EndMovement
    .balign 4, 0
_0B4A:
    WalkNormalWest 2
    WalkNormalNorth 13
    EndMovement
    .balign 4, 0
_0B54:
    Delay8 2
    FaceWest
    Delay8
    FaceNorth
    EndMovement
    .balign 4, 0
_0B66:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0B78:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0B82:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0B90:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0B96:
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0BA4:
    Delay4 3
    WalkFastSouth 6
    WalkFastEast
    EndMovement
    .balign 4, 0
_0BB2:
    FaceSouth
    EndMovement
    .balign 4, 0
_0BB8:
    Delay8 3
    WalkFastEast 7
    WalkFastNorth 3
    WalkFastEast
    EndMovement
    .balign 4, 0
_0BCA:
    WalkNormalSouth 4
    FaceEast
    EndMovement
    .balign 4, 0
_0BD4:
    Delay4 13
    MoveAction_112
    EndMovement
    .balign 4, 0
_0BDE:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0BF0:
    WalkNormalEast 2
    WalkNormalNorth 4
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0BFE:
    Delay4 5
    WalkFastSouth 6
    WalkFastEast
    EndMovement
    .balign 4, 0
