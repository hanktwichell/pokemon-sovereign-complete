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
    GoToIf 1, _018E
    End
scr_seq_R30R0201_001:
    LockAll
    BufferPlayerName 0
    ApplyMovement obj_R30R0201_gsgentleman, _03AA
    WaitMovement
    ApplyMovement obj_R30R0201_ookido, _03B0
    ApplyMovement obj_R30R0201_gsgentleman, _03B6
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0377_R30R0201_00000, msg_0377_R30R0201_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R30R0201_gsgentleman, _03C4
    ApplyMovement LOCALID_PLAYER, _03D2
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_R30R0201_gsgentleman, _03E0
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
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _019C
scr_seq_R30R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 4
    GoToIf 4, _025F
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    GoToIf 4, _028D
    GoToIfSet FLAG_HGSS_EXCHANGED_RED_SCALE, _0298
    GoToIfSet FLAG_HGSS_GOT_RED_SCALE, _02C7
    CompareVar VAR_HGSS_SCENE_MR_POKEMONS_HOUSE, 2
    GoToIf 4, _0326
    Message msg_0377_R30R0201_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R30R0201_002:
    LockAll
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    ApplyMovement obj_R30R0201_gsgentleman, _03AA
    WaitMovement
    ApplyMovement obj_R30R0201_gsgentleman, _03FE
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0377_R30R0201_00021, msg_0377_R30R0201_00022
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R30R0201_gsgentleman, _03C4
    ApplyMovement LOCALID_PLAYER, _03D2
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0377_R30R0201_00023
    CloseMessage
    ApplyMovement obj_R30R0201_gsgentleman, _03E0
    WaitMovement
    BufferPlayerName 0
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0331
    SetVarFromValue VAR_0x8004, 534
    GoTo _034E
_018E:
    SetPosition obj_R30R0201_gsgentleman, 5, 0, 6, DIR_EAST
    End
_019C:
    PlayMusic SEQ_GS_OHKIDO_sseq
    ApplyMovement obj_R30R0201_ookido, _040C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _041E
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0377_R30R0201_00008, msg_0377_R30R0201_00009
    CloseMessage
    ApplyMovement obj_R30R0201_ookido, _0424
    WaitMovement
    Message msg_0377_R30R0201_00010
    CloseMessage
    ApplyMovement obj_R30R0201_ookido, _042E
    WaitMovement
    Message msg_0377_R30R0201_00011
    BufferPlayerName 0
    Message msg_0377_R30R0201_00012
    GivePokedex
    SetFlag FLAG_HGSS_GOT_POKEDEX
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    @ HGSS: ScrCmd_573
    MessageGendered msg_0377_R30R0201_00013, msg_0377_R30R0201_00014
    CloseMessage
    BufferPlayerName 0
    Message msg_0377_R30R0201_00015
    @ HGSS: RegisterGearNumber PHONE_CONTACT_PROF__OAK
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CloseMessage
    ApplyMovement obj_R30R0201_ookido, _0438
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_R30R0201_ookido
    WaitSE SEQ_SE_DP_DOOR_sseq
    FadeOutBGM 0, 30
    StopMusic
    PlayDefaultMusic
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
_025F:
    GoToIfSet FLAG_HGSS_EXCHANGED_RED_SCALE, _0298
    GoToIfSet FLAG_HGSS_GOT_RED_SCALE, _02C7
    CompareVar VAR_HGSS_SCENE_MR_POKEMONS_HOUSE, 2
    GoToIf 4, _0326
    Message msg_0377_R30R0201_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_028D:
    Message msg_0377_R30R0201_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0298:
    GoToIfUnset FLAG_HGSS_UNK_107, _0326
    Message msg_0377_R30R0201_00007
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0365
    ApplyMovement obj_R30R0201_gsgentleman, _0442
    GoTo _0380
_02C7:
    BufferPlayerName 0
    MessageGendered msg_0377_R30R0201_00016, msg_0377_R30R0201_00017
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0386
    SetVar VAR_0x8004, ITEM_LUCKY_EGG
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0391
    Common_GiveItemQuantity
    CloseMessage
    SetFlag FLAG_HGSS_EXCHANGED_RED_SCALE
    SetVar VAR_0x8004, ITEM_RED_SCALE
    SetVar VAR_0x8005, 1
    RemoveItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    ReleaseAll
    End
_0326:
    Message msg_0377_R30R0201_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0331:
    SetVar VAR_0x8004, ITEM_RED_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    Message msg_0377_R30R0201_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_034E:
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    Message msg_0377_R30R0201_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0365:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _039C
    ApplyMovement obj_R30R0201_gsgentleman, _0454
    GoTo _0380
_0380:
    WaitMovement
    ReleaseAll
    End
_0386:
    Message msg_0377_R30R0201_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0391:
    Message msg_0377_R30R0201_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_039C:
    ApplyMovement obj_R30R0201_gsgentleman, _0466
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_03AA:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03B0:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_03B6:
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
_03D2:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_03E0:
    WalkFastWest 3
    WalkFastNorth
    Delay8
    WalkOnSpotSlowerNorth
    WalkSlowSouth
    WalkSlowEast 3
    WalkOnSpotSlowSouth
    EndMovement
    .balign 4, 0
_03FE:
    WalkNormalSouth
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_040C:
    WalkSlowSouth
    WalkSlowWest 4
    WalkSlowNorth 2
    WalkOnSpotSlowEast
    EndMovement
    .balign 4, 0
_041E:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0424:
    WalkSlowSouth
    WalkOnSpotSlowEast
    EndMovement
    .balign 4, 0
_042E:
    WalkSlowNorth
    WalkOnSpotSlowEast
    EndMovement
    .balign 4, 0
_0438:
    WalkSlowSouth 3
    Delay8
    EndMovement
    .balign 4, 0
_0442:
    FaceSouth 3
    FaceWest 3
    FaceNorth 3
    FaceEast 3
    EndMovement
    .balign 4, 0
_0454:
    FaceSouth 3
    FaceEast 3
    FaceNorth 3
    FaceWest 3
    EndMovement
    .balign 4, 0
_0466:
    FaceEast 3
    FaceNorth 3
    FaceWest 3
    FaceSouth 3
    EndMovement
    .balign 4, 0
