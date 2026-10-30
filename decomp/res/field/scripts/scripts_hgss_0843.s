#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0543.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T20R0101_doctor 0
#define obj_T20R0101_policeman 1
#define obj_T20R0101_assistantm 2
#define obj_T20R0101_var_1 3

    ScriptEntry scr_seq_T20R0101_000
    ScriptEntry scr_seq_T20R0101_001
    ScriptEntry scr_seq_T20R0101_002
    ScriptEntry scr_seq_T20R0101_003
    ScriptEntry scr_seq_T20R0101_004
    ScriptEntry scr_seq_T20R0101_005
    ScriptEntry scr_seq_T20R0101_006
    ScriptEntry scr_seq_T20R0101_007
    ScriptEntry scr_seq_T20R0101_008
    ScriptEntry scr_seq_T20R0101_009
    ScriptEntry scr_seq_T20R0101_010
    ScriptEntry scr_seq_T20R0101_011
    ScriptEntry scr_seq_T20R0101_012
    ScriptEntry scr_seq_T20R0101_013
    ScriptEntry scr_seq_T20R0101_014
    ScriptEntry scr_seq_T20R0101_015
    ScriptEntryEnd
scr_seq_T20R0101_010:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    GoToIfSet FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE, _058F
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 0
    GoToIf 5, _05A1
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_SOUTH
    GoTo _05C0
scr_seq_T20R0101_011:
    LockAll
    GoToIfSet FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE, _05D6
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _05FB
    ApplyMovement LOCALID_PLAYER, _1214
    GoTo _0616
scr_seq_T20R0101_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_STARTER, _0668
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteStartJohtoStarterScene
    CompleteGetChosenStarter VAR_HGSS_PLAYER_STARTER
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GivePokemon VAR_HGSS_PLAYER_STARTER, 5, ITEM_NONE, VAR_RESULT
    SetFlag FLAG_HGSS_GOT_STARTER
    @ HGSS: ScrCmd_605 3, 2
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
    GetPartyMonSpecies 0, VAR_MAP_LOCAL_0x01
    SetVar VAR_HGSS_PLAYER_STARTER, VAR_MAP_LOCAL_0x01
    BufferPlayerName 0
    BufferPartyMonSpecies 1, 0
    Message msg_0543_T20R0101_00007
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    BufferPartyMonSpecies 1, 0
    Message msg_0543_T20R0101_00008
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    CallIf 1, _0689
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _1222
    ApplyMovement obj_T20R0101_doctor, _1230
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0543_T20R0101_00010
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1236
    WaitMovement
    Message msg_0543_T20R0101_00011
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _123C
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00012, msg_0543_T20R0101_00013
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 1
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 1
    ClearFlag FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE
    ReleaseAll
    End
scr_seq_T20R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_SS_TICKET_FROM_ELM, _06CC
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _074E
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0778
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 172
    GoToIf 5, _0778
    GetPartyMonForm2 VAR_MAP_LOCAL_0x00, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07BF
    GoToIfSet FLAG_HGSS_UNK_072, _0864
    GoToIfSet FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG, _08C7
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 9
    GoToIf 4, _0864
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 0
    GoToIf 5, _0901
    Message msg_0543_T20R0101_00005
    WaitButton
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1246
    WaitMovement
    GoTo _091F
scr_seq_T20R0101_003:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0923
    ApplyMovement obj_T20R0101_assistantm, _124C
    GoTo _093E
scr_seq_T20R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40FC, 3
    GoToIf 1, _09A0
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 0
    GoToIf 5, _09AB
    Message msg_0543_T20R0101_00018
    GoTo _09C1
scr_seq_T20R0101_002:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _125A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T20R0101_policeman, _1264
    WaitMovement
    Message msg_0543_T20R0101_00023
    CloseMessage
    ClearFlag FLAG_HGSS_HIDE_ELMS_LAB_FRIEND
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    AddObject obj_T20R0101_var_1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    Common_SetCounterpartBGM
    ApplyMovement obj_T20R0101_var_1, _126A
    ApplyMovement obj_T20R0101_policeman, _1278
    WaitMovement
    MessageGendered msg_0543_T20R0101_00024, msg_0543_T20R0101_00025
    CloseMessage
    ApplyMovement obj_T20R0101_policeman, _1282
    WaitMovement
    Message msg_0543_T20R0101_00026
    CloseMessage
    Common_FadeToDefaultMusic
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteNameHGSSRival VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 1
    GoToIf 1, _09C9
    ApplyMovement obj_T20R0101_policeman, _1264
    WaitMovement
    CompleteBufferHGSSRivalName 1
    Message msg_0543_T20R0101_00027
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B1E
    CloseMessage
    Message msg_0543_T20R0101_00028
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _12AC
    ApplyMovement obj_T20R0101_policeman, _12C6
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20R0101_policeman
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T20R0101_var_1, _12E4
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00030, msg_0543_T20R0101_00031
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _12F2
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20R0101_var_1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_OFFICER
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_FRIEND
    SetFlag FLAG_HGSS_GAVE_RIVAL_NAME_TO_OFFICER
    ApplyMovement LOCALID_PLAYER, _1304
    WaitMovement
    ApplyMovement obj_T20R0101_doctor, _130A
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00032, msg_0543_T20R0101_00033
    CloseMessage
    Message msg_0543_T20R0101_00034
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    SetVar VAR_0x8004, ITEM_MYSTERY_EGG
    SetVar VAR_0x8005, 1
    RemoveItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    ApplyMovement obj_T20R0101_doctor, _1310
    WaitMovement
    Message msg_0543_T20R0101_00035
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1322
    WaitMovement
    MessageGendered msg_0543_T20R0101_00036, msg_0543_T20R0101_00037
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1328
    WaitMovement
    MessageGendered msg_0543_T20R0101_00038, msg_0543_T20R0101_00039
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _133A
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_ROUTE_30_BATTLERS
    ClearFlag FLAG_HGSS_HIDE_ROUTE_30_YOUNGSTER_JOEY
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 4
    SetVarFromValue VAR_HGSS_UNK_408B, 1
    ClearFlag FLAG_HGSS_HIDE_ROUTE_29_FRIEND
    ClearFlag FLAG_HGSS_HIDE_ROUTE_29_MARILL
    SetVarFromValue VAR_HGSS_SCENE_MR_POKEMONS_HOUSE, 2
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 3
    ClearFlag FLAG_HGSS_HIDE_CHERRYGROVE_MART_SPECIAL_CLERK
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_PHONE_CALL, 1
    ReleaseAll
    End
scr_seq_T20R0101_014:
    LockAll
    ApplyMovement obj_T20R0101_var_1, _1340
    WaitMovement
    ApplyMovement obj_T20R0101_var_1, _134A
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00058, msg_0543_T20R0101_00059
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _1354
    ApplyMovement obj_T20R0101_var_1, _135A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T20R0101_doctor, _130A
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00060, msg_0543_T20R0101_00061
    SetVarFromValue VAR_0x8004, ITEM_MASTER_BALL
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0B29
    Common_MessageBagIsFull
    GoTo _0BAF
scr_seq_T20R0101_004:
    End
scr_seq_T20R0101_005:
    BufferPlayerName 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00093
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_006:
    BufferPlayerName 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00094
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_007:
    BufferPlayerName 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00095
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_008:
    BufferPlayerName 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00096
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00097
    WaitButton
    CloseMessage
    GoToIfUnset FLAG_HGSS_SG_3FAA, _0C31
    ReleaseAll
    End
scr_seq_T20R0101_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_GOT_STARTER, _0C48
    Message msg_0543_T20R0101_00092
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0C53
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    HealParty
    WaitForTransition
    ReturnToField
    WaitFanfare
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T20R0101_015:
    LockAll
    ApplyMovement obj_T20R0101_assistantm, _136C
    WaitMovement
    BufferPlayerName 0
    Message msg_0543_T20R0101_00056
    CloseMessage
    ApplyMovement obj_T20R0101_assistantm, _1376
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40FC, 3
    ReleaseAll
    End
_058F:
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_EAST
    GoTo _05C0
_05A1:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 3
    GoToIf 5, _0C57
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_SOUTH
    GoTo _05C0
_05C0:
    CompletePlaceStarterBalls
    End
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_EAST
    GoTo _05C0
_05D6:
    ApplyMovement obj_T20R0101_doctor, _1384
    WaitMovement
    Message msg_0543_T20R0101_00006
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1246
    ApplyMovement LOCALID_PLAYER, _1392
    WaitMovement
    ReleaseAll
    End
_05FB:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0C92
    ApplyMovement LOCALID_PLAYER, _1398
    GoTo _0616
_0616:
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00000, msg_0543_T20R0101_00001
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1246
    WaitMovement
    WaitTime 15, VAR_0x8004
    ApplyMovement obj_T20R0101_doctor, _139E
    WaitMovement
    Message msg_0543_T20R0101_00002
    Message msg_0543_T20R0101_00003
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _13AC
    WaitMovement
    Message msg_0543_T20R0101_00004
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1246
    WaitMovement
    SetFlag FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE
    ReleaseAll
    End
_0668:
    GoToIfSet FLAG_HGSS_GOT_TM51_FROM_FALKNER, _0CAD
    GoToIfSet FLAG_HGSS_MET_PASSERBY_BOY, _0CB8
    Message msg_0543_T20R0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0689:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen 0, VAR_MAP_LOCAL_0x00
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    BufferPartyMonNickname 1, 0
    Message msg_0543_T20R0101_00009
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0689
    Return
_06CC:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0778
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 172
    GoToIf 5, _0778
    GetPartyMonForm2 VAR_MAP_LOCAL_0x00, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07BF
    GoToIfSet FLAG_HGSS_UNK_072, _0864
    GoToIfSet FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG, _08C7
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 9
    GoToIf 4, _0864
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 0
    GoToIf 5, _0901
    Message msg_0543_T20R0101_00005
    WaitButton
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1246
    WaitMovement
    GoTo _091F
_074E:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00071, msg_0543_T20R0101_00072
    SetVarFromValue VAR_0x8004, ITEM_SS_TICKET
    SetVarFromValue VAR_0x8005, 1
    SetFlag FLAG_HGSS_GOT_SS_TICKET_FROM_ELM
    Common_GiveItemQuantity
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00073, msg_0543_T20R0101_00074
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0778:
    GoToIfSet FLAG_HGSS_UNK_072, _0864
    GoToIfSet FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG, _08C7
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 9
    GoToIf 4, _0864
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 0
    GoToIf 5, _0901
    Message msg_0543_T20R0101_00005
    WaitButton
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1246
    WaitMovement
    GoTo _091F
_07BF:
    CompareVar VAR_MAP_LOCAL_0x06, 1
    GoToIf 1, _0CC3
    CompareVar VAR_HGSS_UNK_412F, 2
    GoToIf 4, _0CD4
    CompareVar VAR_HGSS_UNK_412F, 1
    GoToIf 1, _0CDF
    Call _0CF8
    ApplyMovement obj_T20R0101_doctor, _13B2
    WaitMovement
    Message msg_0543_T20R0101_00075
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _13B8
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _13C6
    WaitMovement
    Message msg_0543_T20R0101_00076
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _13B2
    WaitMovement
    Message msg_0543_T20R0101_00077
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _13D4
    WaitMovement
    Message msg_0543_T20R0101_00078
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _13DE
    WaitMovement
    Message msg_0543_T20R0101_00079
    CloseMessage
    .short SCRCMD_UNUSED_06A
    .short obj_T20R0101_doctor
    .short VAR_0x8006
    .short VAR_0x8007
    CompareVar VAR_0x8006, 4
    GoToIf 5, _0D3C
    ApplyMovement obj_T20R0101_doctor, _13EC
    GoTo _0D68
_0864:
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_MAP_LOCAL_0x03
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 1, _0D8C
    GoToIfSet FLAG_HGSS_GOT_SS_TICKET_FROM_ELM, _0D9B
    GoToIfSet FLAG_HGSS_UNK_108, _0DAA
    GoToIfSet FLAG_HGSS_UNK_109, _0DAA
    CompleteCheckBadge BADGE_ID_HGSS_RISING, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0DB5
    CompareVar VAR_MAP_LOCAL_0x0F, 1
    GoToIf 1, _0DC0
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00098, msg_0543_T20R0101_00099
    WaitButton
    CloseMessage
    ReleaseAll
    End
_08C7:
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    @ HGSS: UnsetPhoneCallTrigger CALL_TRIGGER_ELM_EGG_HATCHED
    CompareVar VAR_MAP_LOCAL_0x01, 175
    GoToIf 1, _0DCC
    CompareVar VAR_MAP_LOCAL_0x01, 176
    GoToIf 1, _0DCC
    CompareVar VAR_MAP_LOCAL_0x01, 468
    GoToIf 1, _0DCC
    GoTo _0E02
_0901:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 2
    GoToIf 2, _0E15
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00012, msg_0543_T20R0101_00013
    WaitButton
    CloseMessage
    GoTo _091F
_091F:
    ReleaseAll
    End
_0923:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0E2F
    ApplyMovement obj_T20R0101_assistantm, _140E
    GoTo _093E
_093E:
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00019, msg_0543_T20R0101_00020
    SetVar VAR_0x8004, ITEM_POTION
    SetVar VAR_0x8005, 5
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0E4A
    SetVarFromValue VAR_0x8004, ITEM_POTION
    SetVarFromValue VAR_0x8005, 5
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 2
    Message msg_0543_T20R0101_00021
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0E54
    ApplyMovement obj_T20R0101_assistantm, _141C
    GoTo _0E6F
_09A0:
    Message msg_0543_T20R0101_00057
    WaitButton
    CloseMessage
    ReleaseAll
    End
_09AB:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 2
    GoToIf 5, _0E75
    Message msg_0543_T20R0101_00022
    GoTo _09C1
_09C1:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_09C9:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteNameHGSSRival VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 1
    GoToIf 1, _09C9
    ApplyMovement obj_T20R0101_policeman, _1264
    WaitMovement
    CompleteBufferHGSSRivalName 1
    Message msg_0543_T20R0101_00027
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B1E
    CloseMessage
    Message msg_0543_T20R0101_00028
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _12AC
    ApplyMovement obj_T20R0101_policeman, _12C6
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20R0101_policeman
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T20R0101_var_1, _12E4
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00030, msg_0543_T20R0101_00031
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _12F2
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20R0101_var_1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_OFFICER
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_FRIEND
    SetFlag FLAG_HGSS_GAVE_RIVAL_NAME_TO_OFFICER
    ApplyMovement LOCALID_PLAYER, _1304
    WaitMovement
    ApplyMovement obj_T20R0101_doctor, _130A
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00032, msg_0543_T20R0101_00033
    CloseMessage
    Message msg_0543_T20R0101_00034
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    SetVar VAR_0x8004, ITEM_MYSTERY_EGG
    SetVar VAR_0x8005, 1
    RemoveItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    ApplyMovement obj_T20R0101_doctor, _1310
    WaitMovement
    Message msg_0543_T20R0101_00035
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1322
    WaitMovement
    MessageGendered msg_0543_T20R0101_00036, msg_0543_T20R0101_00037
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1328
    WaitMovement
    MessageGendered msg_0543_T20R0101_00038, msg_0543_T20R0101_00039
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _133A
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_ROUTE_30_BATTLERS
    ClearFlag FLAG_HGSS_HIDE_ROUTE_30_YOUNGSTER_JOEY
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 4
    SetVarFromValue VAR_HGSS_UNK_408B, 1
    ClearFlag FLAG_HGSS_HIDE_ROUTE_29_FRIEND
    ClearFlag FLAG_HGSS_HIDE_ROUTE_29_MARILL
    SetVarFromValue VAR_HGSS_SCENE_MR_POKEMONS_HOUSE, 2
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 3
    ClearFlag FLAG_HGSS_HIDE_CHERRYGROVE_MART_SPECIAL_CLERK
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_PHONE_CALL, 1
    ReleaseAll
    End
_0B1E:
    Message msg_0543_T20R0101_00029
    CloseMessage
    GoTo _09C9
_0B29:
    Common_GiveItemQuantity
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00062, msg_0543_T20R0101_00063
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00064, msg_0543_T20R0101_00065
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _1426
    ApplyMovement LOCALID_PLAYER, _1430
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00067, msg_0543_T20R0101_00068
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _143A
    WaitMovement
    RemoveObject obj_T20R0101_var_1
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_FRIEND
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T20R0101_doctor, _130A
    ApplyMovement LOCALID_PLAYER, _1448
    WaitMovement
    Message msg_0543_T20R0101_00069
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 9
    SetVarFromValue VAR_HGSS_UNK_4079, 3
    SetFlag FLAG_HGSS_UNK_23B
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND_2
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_EAST_EXIT, 2
    SetVarFromValue VAR_HGSS_UNK_407B, 2
    End
_0BAF:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00062, msg_0543_T20R0101_00063
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00064, msg_0543_T20R0101_00065
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _1426
    ApplyMovement LOCALID_PLAYER, _1430
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00067, msg_0543_T20R0101_00068
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _143A
    WaitMovement
    RemoveObject obj_T20R0101_var_1
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_FRIEND
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T20R0101_doctor, _130A
    ApplyMovement LOCALID_PLAYER, _1448
    WaitMovement
    Message msg_0543_T20R0101_00069
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 9
    SetVarFromValue VAR_HGSS_UNK_4079, 3
    SetFlag FLAG_HGSS_UNK_23B
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND_2
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_EAST_EXIT, 2
    SetVarFromValue VAR_HGSS_UNK_407B, 2
    End
_0C31:
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0E91
    ReleaseAll
    End
_0C48:
    Message msg_0543_T20R0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C53:
    ReleaseAll
    End
_0C57:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 8
    GoToIf 5, _05C0
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_SOUTH
    SetPosition obj_T20R0101_var_1, 7, 0, 12, DIR_EAST
    CompletePlaceStarterBalls
    End
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_EAST
    GoTo _05C0
_0C92:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0EB9
    ApplyMovement LOCALID_PLAYER, _144E
    GoTo _0616
_0CAD:
    Message msg_0543_T20R0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0CB8:
    Message msg_0543_T20R0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0CC3:
    Message msg_0543_T20R0101_00083
    WaitButton
    CloseMessage
    AddVar VAR_MAP_LOCAL_0x06, 1
    ReleaseAll
    End
_0CD4:
    Message msg_0543_T20R0101_00091
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0CDF:
    GetPartyMonFriendship VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 220
    GoToIf 4, _0F20
    GoTo _0778
_0CF8:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00084, msg_0543_T20R0101_00085
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    .short SCRCMD_UNUSED_06A
    .short obj_T20R0101_doctor
    .short VAR_0x8006
    .short VAR_0x8007
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0F65
    ApplyMovement LOCALID_PLAYER, _145C
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1466
    GoTo _0F8A
_0D3C:
    ApplyMovement obj_T20R0101_doctor, _1474
    WaitMovement
    Message msg_0543_T20R0101_00080
    CloseMessage
    CompareVar VAR_0x8006, 4
    GoToIf 5, _0F98
    ApplyMovement obj_T20R0101_doctor, _149E
    WaitMovement
    GoTo _0FBD
_0D68:
    WaitMovement
    Message msg_0543_T20R0101_00080
    CloseMessage
    CompareVar VAR_0x8006, 4
    GoToIf 5, _0F98
    ApplyMovement obj_T20R0101_doctor, _149E
    WaitMovement
    GoTo _0FBD
_0D8C:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00102, msg_0543_T20R0101_00103
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0D9B:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00073, msg_0543_T20R0101_00074
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DAA:
    Message msg_0543_T20R0101_00070
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DB5:
    Message msg_0543_T20R0101_00069
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DC0:
    MessageGendered msg_0543_T20R0101_00100, msg_0543_T20R0101_00101
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DCC:
    ApplyMovement obj_T20R0101_doctor, _14A4
    WaitMovement
    Message msg_0543_T20R0101_00046
    BufferPlayerName 0
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0FD8
    GoToIfUnset FLAG_HGSS_UNK_108, _0FED
    MessageGendered msg_0543_T20R0101_00104, msg_0543_T20R0101_00105
    GoTo _0FF7
_0E02:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00053, msg_0543_T20R0101_00054
    SetVarFromValue VAR_MAP_LOCAL_0x0F, 1
    GoTo _0864
_0E15:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 5
    GoToIf 2, _0FFD
    Message msg_0543_T20R0101_00040
    WaitButton
    CloseMessage
    GoTo _091F
_0E2F:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _101B
    ApplyMovement obj_T20R0101_assistantm, _14AE
    GoTo _093E
_0E4A:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0E54:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _1092
    ApplyMovement obj_T20R0101_assistantm, _14BC
    GoTo _0E6F
_0E6F:
    WaitMovement
    ReleaseAll
    End
_0E75:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 4
    GoToIf 5, _10AD
    Message msg_0543_T20R0101_00041
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 5
    GoTo _09C1
_0E91:
    ApplyMovement LOCALID_PLAYER, _13D4
    WaitMovement
    Message msg_0543_T20R0101_00106
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _10C3
    CloseMessage
    ReleaseAll
    End
_0EB9:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0616
    ApplyMovement LOCALID_PLAYER, _14C6
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00000, msg_0543_T20R0101_00001
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1246
    WaitMovement
    WaitTime 15, VAR_0x8004
    ApplyMovement obj_T20R0101_doctor, _139E
    WaitMovement
    Message msg_0543_T20R0101_00002
    Message msg_0543_T20R0101_00003
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _13AC
    WaitMovement
    Message msg_0543_T20R0101_00004
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _1246
    WaitMovement
    SetFlag FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE
    ReleaseAll
    End
_0F20:
    Call _0CF8
    MessageGendered msg_0543_T20R0101_00086, msg_0543_T20R0101_00087
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _13D4
    WaitMovement
    Message msg_0543_T20R0101_00088
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _13B8
    WaitMovement
    Message msg_0543_T20R0101_00089
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _13DE
    WaitMovement
    Message msg_0543_T20R0101_00090
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_412F, 2
    ReleaseAll
    End
_0F65:
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _10DD
    ApplyMovement LOCALID_PLAYER, _14D4
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _14E2
    GoTo _0F8A
_0F8A:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
_0F98:
    ApplyMovement obj_T20R0101_doctor, _14F4
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00081, msg_0543_T20R0101_00082
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_412F, 1
    AddVar VAR_MAP_LOCAL_0x06, 1
    ReleaseAll
    End
_0FBD:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00081, msg_0543_T20R0101_00082
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_412F, 1
    AddVar VAR_MAP_LOCAL_0x06, 1
    ReleaseAll
    End
_0FD8:
    GoToIfUnset FLAG_HGSS_UNK_109, _1102
    MessageGendered msg_0543_T20R0101_00104, msg_0543_T20R0101_00105
    GoTo _114B
_0FED:
    MessageGendered msg_0543_T20R0101_00047, msg_0543_T20R0101_00048
    GoTo _114B
_0FF7:
    GoTo _114B
_0FFD:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 6
    GoToIf 5, _1190
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00042, msg_0543_T20R0101_00043
    WaitButton
    CloseMessage
    GoTo _091F
_101B:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _093E
    ApplyMovement obj_T20R0101_assistantm, _1502
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00019, msg_0543_T20R0101_00020
    SetVar VAR_0x8004, ITEM_POTION
    SetVar VAR_0x8005, 5
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0E4A
    SetVarFromValue VAR_0x8004, ITEM_POTION
    SetVarFromValue VAR_0x8005, 5
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 2
    Message msg_0543_T20R0101_00021
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0E54
    ApplyMovement obj_T20R0101_assistantm, _141C
    GoTo _0E6F
_1092:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _119F
    ApplyMovement obj_T20R0101_assistantm, _1510
    GoTo _0E6F
_10AD:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 6
    GoToIf 5, _11BA
    Message msg_0543_T20R0101_00055
    GoTo _09C1
_10C3:
    SetVar VAR_0x8004, ITEM_TOXIC_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3FAA
    CloseMessage
    ReleaseAll
    End
_10DD:
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 5, _11C5
    ApplyMovement LOCALID_PLAYER, _151A
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1528
    GoTo _0F8A
_1102:
    MessageGendered msg_0543_T20R0101_00047, msg_0543_T20R0101_00048
    SetVar VAR_0x8004, ITEM_EVERSTONE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _11EA
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_072
    SetFlag FLAG_HGSS_GOT_EVERSTONE_FROM_ELM
    SetVarFromValue VAR_MAP_LOCAL_0x0F, 0
    Message msg_0543_T20R0101_00049
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00050, msg_0543_T20R0101_00051
    WaitButton
    CloseMessage
    ReleaseAll
    End
_114B:
    SetVar VAR_0x8004, ITEM_EVERSTONE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _11EA
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_072
    SetFlag FLAG_HGSS_GOT_EVERSTONE_FROM_ELM
    SetVarFromValue VAR_MAP_LOCAL_0x0F, 0
    Message msg_0543_T20R0101_00049
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00050, msg_0543_T20R0101_00051
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1190:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00044, msg_0543_T20R0101_00045
    WaitButton
    CloseMessage
    ReleaseAll
    End
_119F:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0E6F
    ApplyMovement obj_T20R0101_assistantm, _152E
    WaitMovement
    ReleaseAll
    End
_11BA:
    Message msg_0543_T20R0101_00055
    WaitButton
    CloseMessage
    ReleaseAll
    End
_11C5:
    CompareVar VAR_0x8006, 4
    GoToIf 5, _11F4
    ApplyMovement LOCALID_PLAYER, _1538
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1528
    GoTo _0F8A
_11EA:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_11F4:
    ApplyMovement LOCALID_PLAYER, _154A
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _14E2
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
    .balign 4, 0
_1214:
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_1222:
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1230:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1236:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_123C:
    Delay16
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1246:
    FaceEast
    EndMovement
    .balign 4, 0
_124C:
    EmoteExclamationMark
    WalkSlightlyFastWest 6
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_125A:
    WalkSlightlyFastNorth 8
    FaceWest
    EndMovement
    .balign 4, 0
_1264:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_126A:
    WalkFastNorth 6
    WalkFastWest
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_1278:
    Delay8 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1282:
    EmoteExclamationMark
    Delay1
    FaceSouth
    Delay8 2
    FaceEast
    Delay8 2
    FaceSouth
    Delay8 2
    FaceEast
    Delay8 2
    EndMovement
    .balign 4, 0
_12AC:
    FaceWest
    LockDir
    WalkNormalEast
    UnlockDir
    Delay32
    FaceSouth
    EndMovement
    .balign 4, 0
_12C6:
    FaceSouth
    Delay4
    WalkNormalSouth 6
    FaceEast
    WalkNormalEast
    FaceSouth
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_12E4:
    WalkNormalWest
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_12F2:
    FaceSouth
    WalkNormalSouth 6
    WalkNormalEast
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_1304:
    FaceNorth
    EndMovement
    .balign 4, 0
_130A:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1310:
    JumpOnSpotFastSouth
    LockDir
    WalkSlightlyFasterNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_1322:
    WalkSlightlyFastSouth
    EndMovement
    .balign 4, 0
_1328:
    FaceNorth
    WalkSlowNorth
    Delay15
    FaceSouth
    EndMovement
    .balign 4, 0
_133A:
    WalkSlightlyFastSouth
    EndMovement
    .balign 4, 0
_1340:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_134A:
    WalkSlightlyFastWest 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1354:
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_135A:
    WalkNormalNorth 5
    WalkNormalEast
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_136C:
    WalkNormalWest 5
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_1376:
    WalkNormalNorth
    WalkNormalEast 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1384:
    FaceSouth
    EmoteExclamationMark
    WalkOnSpotNormalSouth 2
    EndMovement
    .balign 4, 0
_1392:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_1398:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_139E:
    EmoteExclamationMark
    WalkNormalNorth
    Delay16
    EndMovement
    .balign 4, 0
_13AC:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_13B2:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_13B8:
    WalkNormalSouth
    WalkNormalEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_13C6:
    JumpOnSpotFastSouth
    Delay16
    JumpOnSpotFastNorth
    EndMovement
    .balign 4, 0
_13D4:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_13DE:
    WalkNormalNorth
    WalkNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_13EC:
    WalkNormalNorth
    Delay8 2
    LockDir
    WalkSlowEast
    WalkOnSpotNormalNorth
    WalkSlowWest
    UnlockDir
    Delay8 2
    EndMovement
    .balign 4, 0
_140E:
    EmoteExclamationMark
    WalkSlightlyFastWest 5
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_141C:
    WalkSlightlyFastEast 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1426:
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1430:
    Delay8
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_143A:
    WalkSlightlyFastSouth 3
    WalkSlightlyFastWest
    WalkSlightlyFastSouth 4
    EndMovement
    .balign 4, 0
_1448:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_144E:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_145C:
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1466:
    WalkNormalEast
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1474:
    WalkNormalNorth
    WalkNormalWest 2
    WalkOnSpotNormalNorth
    Delay8 2
    LockDir
    WalkSlowEast
    WalkOnSpotNormalNorth
    WalkSlowWest
    UnlockDir
    Delay8 2
    EndMovement
    .balign 4, 0
_149E:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_14A4:
    EmoteExclamationMark
    Delay4
    EndMovement
    .balign 4, 0
_14AE:
    EmoteExclamationMark
    WalkSlightlyFastWest 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_14BC:
    WalkSlightlyFastEast 5
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_14C6:
    WalkNormalNorth 2
    WalkNormalWest 2
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_14D4:
    WalkNormalSouth 2
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_14E2:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_14F4:
    WalkNormalSouth
    WalkNormalEast 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1502:
    EmoteExclamationMark
    WalkSlightlyFastWest 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1510:
    WalkSlightlyFastEast 4
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_151A:
    WalkNormalSouth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1528:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_152E:
    WalkSlightlyFastEast 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1538:
    WalkNormalEast
    WalkNormalSouth 3
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_154A:
    WalkNormalWest
    WalkNormalSouth 3
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
