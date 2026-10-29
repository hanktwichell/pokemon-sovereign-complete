#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0377.h"

#define obj_R30R0201_gsgentleman 0
#define obj_R30R0201_ookido 1

    ScriptEntry scr_seq_R30R0201_000
    ScriptEntry scr_seq_R30R0201_001
    ScriptEntry scr_seq_R30R0201_002
    ScriptEntry scr_seq_R30R0201_003
    ScriptEntryEnd
scr_seq_R30R0201_003:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 1
    GoToIf 1, _0021
    End
_0021:
    SetPosition obj_R30R0201_gsgentleman, 5, 0, 6, DIR_EAST
    End
scr_seq_R30R0201_001:
    LockAll
    ApplyMovement obj_R30R0201_gsgentleman, _03AC
    WaitMovement
    ApplyMovement obj_R30R0201_ookido, _041C
    ApplyMovement obj_R30R0201_gsgentleman, _03B4
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0377_R30R0201_00000, msg_0377_R30R0201_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R30R0201_gsgentleman, _03C4
    ApplyMovement LOCALID_PLAYER, _0404
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_R30R0201_gsgentleman, _03E4
    WaitMovement
    Message msg_0377_R30R0201_00002
    SetVar VAR_0x8004, ITEM_MYSTERY_EGG
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0377_R30R0201_00003
    Message msg_0377_R30R0201_00004
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    StopMusic
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    HealParty
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _02E8
    End
scr_seq_R30R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 4
    GoToIf 4, _00F1
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    GoToIf 4, _02CD
_00F1:
    GoToIfSet FLAG_HGSS_EXCHANGED_RED_SCALE, _019F
    GoToIfSet FLAG_HGSS_GOT_RED_SCALE, _012A
    CompareVar VAR_HGSS_SCENE_MR_POKEMONS_HOUSE, 2
    GoToIf 4, _011F
    Message msg_0377_R30R0201_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_011F:
    Message msg_0377_R30R0201_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_012A:
    BufferPlayerName 0
    MessageGendered msg_0377_R30R0201_00016, msg_0377_R30R0201_00017
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0189
    SetVar VAR_0x8004, ITEM_EXP_SHARE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0194
    Common_GiveItemQuantity
    CloseMessage
    SetFlag FLAG_HGSS_EXCHANGED_RED_SCALE
    SetVar VAR_0x8004, ITEM_RED_SCALE
    SetVar VAR_0x8005, 1
    RemoveItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    ReleaseAll
    End
_0189:
    Message msg_0377_R30R0201_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0194:
    Message msg_0377_R30R0201_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_019F:
    GoToIfUnset FLAG_HGSS_UNK_107, _011F
    Message msg_0377_R30R0201_00007
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _01CE
    ApplyMovement obj_R30R0201_gsgentleman, _01F8
    GoTo _01F1
_01CE:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _01E9
    ApplyMovement obj_R30R0201_gsgentleman, _020C
    GoTo _01F1
_01E9:
    ApplyMovement obj_R30R0201_gsgentleman, _0220
_01F1:
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_01F8:
    FaceSouth 3
    FaceWest 3
    FaceNorth 3
    FaceEast 3
    EndMovement
    .balign 4, 0
_020C:
    FaceSouth 3
    FaceEast 3
    FaceNorth 3
    FaceWest 3
    EndMovement
    .balign 4, 0
_0220:
    FaceEast 3
    FaceNorth 3
    FaceWest 3
    FaceSouth 3
    EndMovement
scr_seq_R30R0201_002:
    LockAll
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    ApplyMovement obj_R30R0201_gsgentleman, _03AC
    WaitMovement
    ApplyMovement obj_R30R0201_gsgentleman, _02D8
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0377_R30R0201_00021, msg_0377_R30R0201_00022
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R30R0201_gsgentleman, _03C4
    ApplyMovement LOCALID_PLAYER, _0404
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0377_R30R0201_00023
    CloseMessage
    ApplyMovement obj_R30R0201_gsgentleman, _03E4
    WaitMovement
    BufferPlayerName 0
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _02B0
    SetVarFromValue VAR_0x8004, 535
    GoTo _02B6
_02B0:
    SetVarFromValue VAR_0x8004, 534
_02B6:
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    Message msg_0377_R30R0201_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02CD:
    Message msg_0377_R30R0201_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_02D8:
    WalkNormalSouth
    WalkNormalWest
    WalkNormalSouth
    EndMovement
_02E8:
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_R30R0201_ookido, _0424
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0414
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0377_R30R0201_00008, msg_0377_R30R0201_00009
    CloseMessage
    ApplyMovement obj_R30R0201_ookido, _0438
    WaitMovement
    Message msg_0377_R30R0201_00010
    CloseMessage
    ApplyMovement obj_R30R0201_ookido, _0444
    WaitMovement
    Message msg_0377_R30R0201_00011
    BufferPlayerName 0
    Message msg_0377_R30R0201_00012
    GivePokedex
    SetFlag FLAG_HGSS_GOT_POKEDEX
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: ScrCmd_573
    MessageGendered msg_0377_R30R0201_00013, msg_0377_R30R0201_00014
    CloseMessage
    BufferPlayerName 0
    Message msg_0377_R30R0201_00015
    @ HGSS: RegisterGearNumber PHONE_CONTACT_PROF__OAK
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    CloseMessage
    ApplyMovement obj_R30R0201_ookido, _0450
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_R30R0201_ookido
    WaitSE SEQ_SE_DP_DOOR_sseq
    FadeOutBGM 0, 30
    StopMusic
    @ HGSS: ResetBGM
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_MR_POKEMONS_HOUSE, 1
    @ HGSS: SetSpawn SPAWN_CHERRYGROVE
    SetFlag FLAG_HGSS_HIDE_MR_POKEMONS_HOUSE_OAK
    SetFlag FLAG_HGSS_HIDE_COMM_CLUB_CLOSED_LADIES
    ClearFlag FLAG_HGSS_HIDE_COMM_CLUB_RECEPTIONISTS
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_RIVAL
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 3
    ClearFlag FLAG_HGSS_HIDE_CHERRYGROVE_RIVAL
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 3
    ClearFlag FLAG_HGSS_HIDE_ELMS_LAB_OFFICER
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_OW, 2
    End
    .balign 4, 0
_03AC:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03B4:
    WalkFastSouth
    WalkFastWest 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03C4:
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03D4:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_03E4:
    WalkFastWest 3
    WalkFastNorth
    Delay8
    WalkOnSpotSlowerNorth
    WalkSlowSouth
    WalkSlowEast 3
    WalkOnSpotSlowSouth
    EndMovement
    .balign 4, 0
_0404:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0414:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_041C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0424:
    WalkSlowSouth
    WalkSlowWest 4
    WalkSlowNorth 2
    WalkOnSpotSlowEast
    EndMovement
    .balign 4, 0
_0438:
    WalkSlowSouth
    WalkOnSpotSlowEast
    EndMovement
    .balign 4, 0
_0444:
    WalkSlowNorth
    WalkOnSpotSlowEast
    EndMovement
    .balign 4, 0
_0450:
    WalkSlowSouth 3
    Delay8
    EndMovement
    .balign 4, 0
