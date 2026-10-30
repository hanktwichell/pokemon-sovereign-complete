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
    GoToIfUnset FLAG_HGSS_UNK_189, _0127
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D44R0102_000:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _08CE
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 26
    GoToIf 5, _0143
    ApplyMovement obj_D44R0102_gsleader8, _08D4
    GoTo _015E
scr_seq_D44R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0E2, _01E2
    BufferPlayerName 0
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_0E2
    ReleaseAll
    End
scr_seq_D44R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_CLAIR, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01F0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _0251
    Message msg_0129_D44R0102_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _025A
    CompareVar VAR_RESULT, 1
    GoToIf 4, _029D
    End
scr_seq_D44R0102_004:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D44R0102_gsrivel_2, _08DA
    CompareVar VAR_MAP_LOCAL_0x00, 24
    GoToIf 5, _02AE
    ApplyMovement LOCALID_PLAYER, _08E4
    GoTo _03B0
scr_seq_D44R0102_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0129_D44R0102_00006, VAR_RESULT
    Common_HandleSignpostInput
    End
_0127:
    CompareVar VAR_HGSS_UNK_40FC, 2
    GoToIf 4, _04AA
    CompareVar VAR_HGSS_UNK_40FC, 1
    CallIf 1, _04C5
    End
_0143:
    CompareVar VAR_MAP_LOCAL_0x00, 27
    GoToIf 5, _04E2
    ApplyMovement obj_D44R0102_gsleader8, _08EE
    GoTo _015E
_015E:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0129_D44R0102_00000
    Message msg_0129_D44R0102_00001
    SetVar VAR_0x8004, ITEM_TM59
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0556
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM59_FROM_CLAIR
    Message msg_0129_D44R0102_00003
    Message msg_0129_D44R0102_00005
    Message msg_0129_D44R0102_00035
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0129_D44R0102_00036
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_CLAIR
    WaitButton
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 26
    GoToIf 5, _0561
    ApplyMovement obj_D44R0102_gsleader8, _08F4
    ApplyMovement LOCALID_PLAYER, _0902
    GoTo _0584
_01E2:
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01F0:
    Message msg_0129_D44R0102_00029
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0594
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _059F
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
_0251:
    Message msg_0129_D44R0102_00013
    GoTo _05AA
_025A:
    BufferPlayerName 0
    Message msg_0129_D44R0102_00010
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
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
_029D:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0129_D44R0102_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02AE:
    ApplyMovement LOCALID_PLAYER, _0908
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Common_SetRivalBGM
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00014
    CloseMessage
    SetPosition obj_D44R0102_wataru, 28, 0, 34, DIR_SOUTH
    SetPosition obj_D44R0102_gsleader8_2, 28, 0, 33, DIR_SOUTH
    Common_FadeToDefaultMusic2
    ApplyMovement obj_D44R0102_gsrivel_2, _08DA
    ApplyMovement LOCALID_PLAYER, _091A
    ApplyMovement obj_D44R0102_wataru, _0938
    ApplyMovement obj_D44R0102_gsleader8_2, _0946
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0958
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0129_D44R0102_00015, msg_0129_D44R0102_00016
    ApplyMovement obj_D44R0102_gsrivel_2, _096A
    WaitMovement
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00017
    Message msg_0129_D44R0102_00018
    ApplyMovement obj_D44R0102_gsrivel_2, _0970
    WaitMovement
    BufferPlayerName 0
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00019
    MessageGendered msg_0129_D44R0102_00020, msg_0129_D44R0102_00021
    ApplyMovement obj_D44R0102_gsleader8_2, _0976
    WaitMovement
    Message msg_0129_D44R0102_00022
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00023
    ApplyMovement obj_D44R0102_gsrivel_2, _097C
    ApplyMovement obj_D44R0102_gsleader8_2, _098E
    ApplyMovement LOCALID_PLAYER, _0998
    WaitMovement
    BufferPlayerName 0
    Message msg_0129_D44R0102_00024
    CloseMessage
    ApplyMovement obj_D44R0102_gsrivel_2, _09A2
    ApplyMovement LOCALID_PLAYER, _09A2
    ApplyMovement obj_D44R0102_gsleader8_2, _0976
    WaitMovement
    CompareVar VAR_OBJ_GFX_ID_0, 1048
    GoToIf 5, _05CE
    StartTagBattle TRAINER_HGSS_PARTNER_RIVAL_2, TRAINER_HGSS_CHAMPION_LANCE_3, TRAINER_HGSS_LEADER_CLAIR_CLAIR_3
    GoTo _05EA
_03B0:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Common_SetRivalBGM
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00014
    CloseMessage
    SetPosition obj_D44R0102_wataru, 28, 0, 34, DIR_SOUTH
    SetPosition obj_D44R0102_gsleader8_2, 28, 0, 33, DIR_SOUTH
    Common_FadeToDefaultMusic2
    ApplyMovement obj_D44R0102_gsrivel_2, _08DA
    ApplyMovement LOCALID_PLAYER, _091A
    ApplyMovement obj_D44R0102_wataru, _0938
    ApplyMovement obj_D44R0102_gsleader8_2, _0946
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0958
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0129_D44R0102_00015, msg_0129_D44R0102_00016
    ApplyMovement obj_D44R0102_gsrivel_2, _096A
    WaitMovement
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00017
    Message msg_0129_D44R0102_00018
    ApplyMovement obj_D44R0102_gsrivel_2, _0970
    WaitMovement
    BufferPlayerName 0
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00019
    MessageGendered msg_0129_D44R0102_00020, msg_0129_D44R0102_00021
    ApplyMovement obj_D44R0102_gsleader8_2, _0976
    WaitMovement
    Message msg_0129_D44R0102_00022
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00023
    ApplyMovement obj_D44R0102_gsrivel_2, _097C
    ApplyMovement obj_D44R0102_gsleader8_2, _098E
    ApplyMovement LOCALID_PLAYER, _0998
    WaitMovement
    BufferPlayerName 0
    Message msg_0129_D44R0102_00024
    CloseMessage
    ApplyMovement obj_D44R0102_gsrivel_2, _09A2
    ApplyMovement LOCALID_PLAYER, _09A2
    ApplyMovement obj_D44R0102_gsleader8_2, _0976
    WaitMovement
    CompareVar VAR_OBJ_GFX_ID_0, 1048
    GoToIf 5, _05CE
    StartTagBattle TRAINER_HGSS_PARTNER_RIVAL_2, TRAINER_HGSS_CHAMPION_LANCE_3, TRAINER_HGSS_LEADER_CLAIR_CLAIR_3
    GoTo _05EA
_04AA:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0685
    ClearFlag FLAG_HGSS_HIDE_CHAMPIONS_ROOM_RETREAT
    GoTo _069C
_04C5:
    SetVarFromVar VAR_MAP_LOCAL_0x00, VAR_HGSS_PLAYER_STARTER
    CompareVar VAR_MAP_LOCAL_0x00, 152
    GoToIf 5, _06CA
    SetVarFromValue VAR_OBJ_GFX_ID_0, 1048
    GoTo _06E3
_04E2:
    ApplyMovement obj_D44R0102_gsleader8, _09AE
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0129_D44R0102_00000
    Message msg_0129_D44R0102_00001
    SetVar VAR_0x8004, ITEM_TM59
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0556
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM59_FROM_CLAIR
    Message msg_0129_D44R0102_00003
    Message msg_0129_D44R0102_00005
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 26
    GoToIf 5, _0561
    ApplyMovement obj_D44R0102_gsleader8, _08F4
    ApplyMovement LOCALID_PLAYER, _0902
    GoTo _0584
_0556:
    Message msg_0129_D44R0102_00004
    CloseMessage
    GoTo _06E5
_0561:
    CompareVar VAR_MAP_LOCAL_0x00, 27
    GoToIf 5, _0713
    ApplyMovement obj_D44R0102_gsleader8, _09BC
    ApplyMovement LOCALID_PLAYER, _0902
    GoTo _0584
_0584:
    WaitMovement
    RemoveObject obj_D44R0102_gsleader8
    SetVarFromValue VAR_HGSS_UNK_40C4, 2
    ReleaseAll
    End
_0594:
    Message msg_0129_D44R0102_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_059F:
    Message msg_0129_D44R0102_00033
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05AA:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _025A
    CompareVar VAR_RESULT, 1
    GoToIf 4, _029D
    End
_05CE:
    CompareVar VAR_OBJ_GFX_ID_0, 1049
    GoToIf 5, _0733
    StartTagBattle TRAINER_HGSS_PARTNER_RIVAL_3, TRAINER_HGSS_CHAMPION_LANCE_3, TRAINER_HGSS_LEADER_CLAIR_CLAIR_3
    GoTo _05EA
_05EA:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07D7
    BufferPlayerName 0
    MessageGendered msg_0129_D44R0102_00025, msg_0129_D44R0102_00026
    CloseMessage
    ApplyMovement obj_D44R0102_wataru, _09BC
    WaitMovement
    RemoveObject obj_D44R0102_wataru
    BufferPlayerName 0
    Message msg_0129_D44R0102_00027
    CloseMessage
    ApplyMovement obj_D44R0102_gsleader8_2, _09CA
    WaitMovement
    RemoveObject obj_D44R0102_gsleader8_2
    ApplyMovement obj_D44R0102_gsrivel_2, _09E4
    ApplyMovement LOCALID_PLAYER, _09EA
    WaitMovement
    BufferPlayerName 0
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00028
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_D44R0102_gsrivel_2
    RemoveObject obj_D44R0102_var_1
    WaitTime 20, VAR_0x8004
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _09F0
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40FC, 2
    SetVarFromValue VAR_HGSS_UNK_4119, 1
    ReleaseAll
    End
_0685:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _07DD
    ClearFlag FLAG_HGSS_HIDE_CHAMPIONS_ROOM_RETREAT
    GoTo _069C
_069C:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_CLAIR, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _080F
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _083D
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _0854
_06CA:
    CompareVar VAR_MAP_LOCAL_0x00, 155
    GoToIf 5, _0856
    SetVarFromValue VAR_OBJ_GFX_ID_0, 1049
    GoTo _06E3
_06E3:
    Return
_06E5:
    Message msg_0129_D44R0102_00005
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 26
    GoToIf 5, _0561
    ApplyMovement obj_D44R0102_gsleader8, _08F4
    ApplyMovement LOCALID_PLAYER, _0902
    GoTo _0584
_0713:
    ApplyMovement obj_D44R0102_gsleader8, _0A04
    ApplyMovement LOCALID_PLAYER, _0902
    WaitMovement
    RemoveObject obj_D44R0102_gsleader8
    SetVarFromValue VAR_HGSS_UNK_40C4, 2
    ReleaseAll
    End
_0733:
    StartTagBattle TRAINER_HGSS_PARTNER_RIVAL_1, TRAINER_HGSS_CHAMPION_LANCE_3, TRAINER_HGSS_LEADER_CLAIR_CLAIR_3
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07D7
    BufferPlayerName 0
    MessageGendered msg_0129_D44R0102_00025, msg_0129_D44R0102_00026
    CloseMessage
    ApplyMovement obj_D44R0102_wataru, _09CA
    WaitMovement
    RemoveObject obj_D44R0102_wataru
    BufferPlayerName 0
    Message msg_0129_D44R0102_00027
    CloseMessage
    ApplyMovement obj_D44R0102_gsleader8_2, _09E4
    WaitMovement
    RemoveObject obj_D44R0102_gsleader8_2
    ApplyMovement obj_D44R0102_gsrivel_2, _09EA
    ApplyMovement LOCALID_PLAYER, _09F0
    WaitMovement
    BufferPlayerName 0
    CompleteBufferHGSSRivalName 1
    Message msg_0129_D44R0102_00028
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_D44R0102_gsrivel_2
    RemoveObject obj_D44R0102_var_1
    WaitTime 20, VAR_0x8004
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _09F6
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40FC, 2
    SetVarFromValue VAR_HGSS_UNK_4119, 1
    ReleaseAll
    End
_07D7:
    BlackOutFromBattle
    ReleaseAll
    End
_07DD:
    SetFlag FLAG_HGSS_HIDE_CHAMPIONS_ROOM_RETREAT
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_CLAIR, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _080F
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _083D
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _0854
_080F:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_CLAIR, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _085E
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0864
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _087B
_083D:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _087D
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _0854
_0854:
    End
_0856:
    SetVarFromValue VAR_OBJ_GFX_ID_0, 1047
    Return
_085E:
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    End
_0864:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _0894
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _087B
_087B:
    End
_087D:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _08AB
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _0854
_0894:
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _08C2
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _087B
_08AB:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _08C8
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    GoTo _0854
_08C2:
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    End
_08C8:
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    End
    .balign 4, 0
_08CE:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_08D4:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_08DA:
    FaceNorth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_08E4:
    Delay16 2
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_08EE:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_08F4:
    WalkNormalNorth
    WalkNormalEast 3
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_0902:
    FaceNorth
    EndMovement
    .balign 4, 0
_0908:
    Delay16
    WalkNormalSouth
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_091A:
    Delay16
    FaceNorth
    EmoteExclamationMark
    Delay16 2
    WalkNormalEast
    WalkNormalSouth 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0938:
    WalkNormalSouth 7
    WalkNormalWest 3
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0946:
    Delay8
    WalkNormalSouth 7
    WalkNormalWest 4
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_0958:
    Delay16 4
    WalkFastEast
    WalkFastSouth 5
    FaceNorth
    EndMovement
    .balign 4, 0
_096A:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0970:
    WalkOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_0976:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_097C:
    WalkFasterNorth
    Delay8
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_098E:
    LockDir
    WalkFasterNorth 2
    EndMovement
    .balign 4, 0
_0998:
    Delay16 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_09A2:
    WalkOnSpotNormalNorth
    EndMovement
    @ HGSS data: .byte 15
    @ HGSS: LegendCutsceneLugiaArrivesEffectEnd
    .balign 4, 0
    @ HGSS data: .byte 254
    @ HGSS data: .byte 0
    .balign 4, 0
_09AE:
    WalkNormalNorth
    WalkNormalEast 2
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_09BC:
    WalkNormalNorth 4
    WalkNormalEast 3
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_09CA:
    LockDir
    WalkSlowNorth
    UnlockDir
    WalkFastNorth 2
    WalkFastEast 4
    WalkFastNorth 7
    EndMovement
    .balign 4, 0
_09E4:
    FaceEast
    EndMovement
    .balign 4, 0
_09EA:
    FaceWest
    EndMovement
    .balign 4, 0
_09F0:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_09F6:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_0A04:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
