#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0129.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D44R0102_gsleader8 0
#define obj_D44R0102_gsrivel_2 9
#define obj_D44R0102_var_1 10
#define obj_D44R0102_wataru 11
#define obj_D44R0102_gsleader8_2 12

    ScriptEntry scr_seq_D44R0102_000
    ScriptEntry scr_seq_D44R0102_001
    ScriptEntry scr_seq_D44R0102_002
    ScriptEntry scr_seq_D44R0102_003
    ScriptEntry scr_seq_D44R0102_004
    ScriptEntry scr_seq_D44R0102_005
    ScriptEntryEnd
scr_seq_D44R0102_002:
    GoToIfUnset FLAG_HGSS_UNK_189, _002B
    ClearFlag FLAG_HGSS_UNK_189
    End
_002B:
    CompareVar VAR_HGSS_UNK_40FC, 2
    GoToIf 4, _0047
    CompareVar VAR_HGSS_UNK_40FC, 1
    CallIf 1, _015E
    End
_0047:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0062
    ClearFlag FLAG_HGSS_HIDE_CHAMPIONS_ROOM_RETREAT
    GoTo _007D
_0062:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0079
    ClearFlag FLAG_HGSS_HIDE_CHAMPIONS_ROOM_RETREAT
    GoTo _007D
_0079:
    SetFlag FLAG_HGSS_HIDE_CHAMPIONS_ROOM_RETREAT
_007D:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_CLAIR, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00F6
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _00AB
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _00F4
_00AB:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _00C2
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _00F4
_00C2:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _00D9
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _00F4
_00D9:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _00F0
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _00F4
_00F0:
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
_00F4:
    End
_00F6:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_CLAIR, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0158
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0124
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _0156
_0124:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _013B
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _0156
_013B:
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _0152
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _0156
_0152:
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
_0156:
    End
_0158:
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    End
_015E:
    @ HGSS: GetStarterChoice VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 152
    GoToIf 5, _017B
    SetVarFromValue VAR_OBJ_GFX_ID_0, 1048
    GoTo _019A
_017B:
    CompareVar VAR_MAP_LOCAL_0x00, 155
    GoToIf 5, _0194
    SetVarFromValue VAR_OBJ_GFX_ID_0, 1049
    GoTo _019A
_0194:
    SetVarFromValue VAR_OBJ_GFX_ID_0, 1047
_019A:
    Return
scr_seq_D44R0102_000:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _02C0
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 26
    GoToIf 5, _01D5
    ApplyMovement obj_D44R0102_gsleader8, _02C8
    GoTo _01F8
_01D5:
    CompareVar VAR_MAP_LOCAL_0x00, 27
    GoToIf 5, _01F0
    ApplyMovement obj_D44R0102_gsleader8, _02D0
    GoTo _01F8
_01F0:
    ApplyMovement obj_D44R0102_gsleader8, _02D8
_01F8:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0129_D44R0102_00000
    Message msg_0129_D44R0102_00001
    SetVar VAR_0x8004, ITEM_TM59
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _02A7
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM59_FROM_CLAIR
    Message msg_0129_D44R0102_00003
_0236:
    Message msg_0129_D44R0102_00005
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 26
    GoToIf 5, _0264
    ApplyMovement obj_D44R0102_gsleader8, _02E0
    ApplyMovement LOCALID_PLAYER, _0310
    GoTo _0297
_0264:
    CompareVar VAR_MAP_LOCAL_0x00, 27
    GoToIf 5, _0287
    ApplyMovement obj_D44R0102_gsleader8, _02F0
    ApplyMovement LOCALID_PLAYER, _0310
    GoTo _0297
_0287:
    ApplyMovement obj_D44R0102_gsleader8, _0300
    ApplyMovement LOCALID_PLAYER, _0310
_0297:
    WaitMovement
    RemoveObject obj_D44R0102_gsleader8
    SetVarFromValue VAR_HGSS_UNK_40C4, 2
    ReleaseAll
    End
_02A7:
    Message msg_0129_D44R0102_00004
    CloseMessage
    GoTo _0236
    End
    .balign 4, 0
_02B4:
    EmoteExclamationMark
    FaceWest
    EndMovement
    .balign 4, 0
_02C0:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_02C8:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_02D0:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_02D8:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_02E0:
    WalkNormalNorth
    WalkNormalEast 3
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_02F0:
    WalkNormalNorth
    WalkNormalEast 2
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_0300:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_0310:
    FaceNorth
    EndMovement
scr_seq_D44R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0E2, _0340
    BufferPlayerName 0
    BufferRivalName 1
    Message msg_0129_D44R0102_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_0E2
    ReleaseAll
    End
_0340:
    BufferRivalName 1
    Message msg_0129_D44R0102_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D44R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_CLAIR, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _03FC
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _03F1
    Message msg_0129_D44R0102_00009
_0379:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _039D
    CompareVar VAR_RESULT, 1
    GoToIf 4, _03E0
    End
_039D:
    BufferPlayerName 0
    Message msg_0129_D44R0102_00010
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_CLAIR
    Message msg_0129_D44R0102_00011
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    RemoveObject obj_D44R0102_gsleader8
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_03E0:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0129_D44R0102_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03F1:
    Message msg_0129_D44R0102_00013
    GoTo _0379
    End
_03FC:
    Message msg_0129_D44R0102_00029
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _045D
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0468
    Message msg_0129_D44R0102_00030
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 83
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0129_D44R0102_00031
    WaitButton
    CloseMessage
    ReleaseAll
    End
_045D:
    Message msg_0129_D44R0102_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0468:
    Message msg_0129_D44R0102_00033
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D44R0102_004:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D44R0102_gsrivel_2, _0674
    CompareVar VAR_MAP_LOCAL_0x00, 24
    GoToIf 5, _04AA
    ApplyMovement LOCALID_PLAYER, _0688
    GoTo _04B2
_04AA:
    ApplyMovement LOCALID_PLAYER, _0694
_04B2:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Common_SetRivalBGM
    BufferRivalName 1
    Message msg_0129_D44R0102_00014
    CloseMessage
    SetPosition obj_D44R0102_wataru, 28, 0, 34, DIR_SOUTH
    SetPosition obj_D44R0102_gsleader8_2, 28, 0, 33, DIR_SOUTH
    Common_FadeToDefaultMusic2
    ApplyMovement obj_D44R0102_gsrivel_2, _0674
    ApplyMovement LOCALID_PLAYER, _06A8
    ApplyMovement obj_D44R0102_wataru, _06E4
    ApplyMovement obj_D44R0102_gsleader8_2, _0704
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06C8
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0129_D44R0102_00015, msg_0129_D44R0102_00016
    ApplyMovement obj_D44R0102_gsrivel_2, _0680
    WaitMovement
    BufferRivalName 1
    Message msg_0129_D44R0102_00017
    Message msg_0129_D44R0102_00018
    ApplyMovement obj_D44R0102_gsrivel_2, _073C
    WaitMovement
    BufferPlayerName 0
    BufferRivalName 1
    Message msg_0129_D44R0102_00019
    MessageGendered msg_0129_D44R0102_00020, msg_0129_D44R0102_00021
    ApplyMovement obj_D44R0102_gsleader8_2, _0718
    WaitMovement
    Message msg_0129_D44R0102_00022
    BufferRivalName 1
    Message msg_0129_D44R0102_00023
    ApplyMovement obj_D44R0102_gsrivel_2, _0744
    ApplyMovement obj_D44R0102_gsleader8_2, _0758
    ApplyMovement LOCALID_PLAYER, _0764
    WaitMovement
    BufferPlayerName 0
    Message msg_0129_D44R0102_00024
    CloseMessage
    ApplyMovement obj_D44R0102_gsrivel_2, _0770
    ApplyMovement LOCALID_PLAYER, _0770
    ApplyMovement obj_D44R0102_gsleader8_2, _0718
    WaitMovement
    CompareVar VAR_OBJ_GFX_ID_0, 1048
    GoToIf 5, _05AC
    @ HGSS: MultiBattle TRAINER_PARTNER_RIVAL_2, TRAINER_CHAMPION_LANCE_3, TRAINER_LEADER_CLAIR_CLAIR_3, 1
    GoTo _05D1
_05AC:
    CompareVar VAR_OBJ_GFX_ID_0, 1049
    GoToIf 5, _05C8
    @ HGSS: MultiBattle TRAINER_PARTNER_RIVAL_3, TRAINER_CHAMPION_LANCE_3, TRAINER_LEADER_CLAIR_CLAIR_3, 1
    GoTo _05D1
_05C8:
    @ HGSS: MultiBattle TRAINER_PARTNER_RIVAL_1, TRAINER_CHAMPION_LANCE_3, TRAINER_LEADER_CLAIR_CLAIR_3, 1
_05D1:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _066C
    BufferPlayerName 0
    MessageGendered msg_0129_D44R0102_00025, msg_0129_D44R0102_00026
    CloseMessage
    ApplyMovement obj_D44R0102_wataru, _06F4
    WaitMovement
    RemoveObject obj_D44R0102_wataru
    BufferPlayerName 0
    Message msg_0129_D44R0102_00027
    CloseMessage
    ApplyMovement obj_D44R0102_gsleader8_2, _0720
    WaitMovement
    RemoveObject obj_D44R0102_gsleader8_2
    ApplyMovement obj_D44R0102_gsrivel_2, _0778
    ApplyMovement LOCALID_PLAYER, _0780
    WaitMovement
    BufferPlayerName 0
    BufferRivalName 1
    Message msg_0129_D44R0102_00028
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_D44R0102_gsrivel_2
    RemoveObject obj_D44R0102_var_1
    WaitTime 20, VAR_0x8004
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06DC
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40FC, 2
    SetVarFromValue VAR_HGSS_UNK_4119, 1
    ReleaseAll
    End
_066C:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0674:
    FaceNorth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0680:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0688:
    Delay16 2
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0694:
    Delay16
    WalkNormalSouth
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_06A8:
    Delay16
    FaceNorth
    EmoteExclamationMark
    Delay16 2
    WalkNormalEast
    WalkNormalSouth 2
    FaceNorth
    EndMovement
    .balign 4, 0
_06C8:
    Delay16 4
    WalkFastEast
    WalkFastSouth 5
    FaceNorth
    EndMovement
    .balign 4, 0
_06DC:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_06E4:
    WalkNormalSouth 7
    WalkNormalWest 3
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_06F4:
    WalkNormalNorth 4
    WalkNormalEast 3
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_0704:
    Delay8
    WalkNormalSouth 7
    WalkNormalWest 4
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_0718:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0720:
    LockDir
    WalkSlowNorth
    UnlockDir
    WalkFastNorth 2
    WalkFastEast 4
    WalkFastNorth 7
    EndMovement
    .balign 4, 0
_073C:
    WalkOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_0744:
    WalkFasterNorth
    Delay8
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0758:
    LockDir
    WalkFasterNorth 2
    EndMovement
    .balign 4, 0
_0764:
    Delay16 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0770:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0778:
    FaceEast
    EndMovement
    .balign 4, 0
_0780:
    FaceWest
    EndMovement
scr_seq_D44R0102_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0129_D44R0102_00006, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
