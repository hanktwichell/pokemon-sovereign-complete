#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0556.h"

#define obj_T22_gsbigman 2
#define obj_T22_dancer 7
#define obj_T22_juggrer 10

    ScriptEntry scr_seq_T22_000
    ScriptEntry scr_seq_T22_001
    ScriptEntry scr_seq_T22_002
    ScriptEntry scr_seq_T22_003
    ScriptEntry scr_seq_T22_004
    ScriptEntry scr_seq_T22_005
    ScriptEntry scr_seq_T22_006
    ScriptEntry scr_seq_T22_007
    ScriptEntry scr_seq_T22_008
    ScriptEntry scr_seq_T22_009
    ScriptEntry scr_seq_T22_010
    ScriptEntry scr_seq_T22_011
    ScriptEntry scr_seq_T22_012
    ScriptEntry scr_seq_T22_013
    ScriptEntry scr_seq_T22_014
    ScriptEntryEnd
scr_seq_T22_000:
    SetFlag FLAG_HGSS_GOT_PICK_UP_EGG_CALL_FROM_ELM
    SetVar VAR_0x8004, PHONE_CONTACT_PROF__ELM
    SetVar VAR_0x8005, 2
    SetVar VAR_0x8006, 1
    CallCommonScript 0x813
    SetVarFromValue VAR_HGSS_SCENE_VIOLET_CITY_OW, 2
    ClearFlag FLAG_HGSS_HIDE_VIOLET_SHOP_LAB_AIDE
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_AIDE
    End
scr_seq_T22_004:
    LockAll
    StopMusic
    SetBGM SEQ_GS_E_MAIKO_THEME_sseq
    ApplyMovement obj_T22_dancer, _0C2A
    WaitMovement
    Message msg_0556_T22_00013
    CloseMessage
    ApplyMovement obj_T22_dancer, _0C38
    WaitMovement
    Message msg_0556_T22_00014
    CloseMessage
    ApplyMovement obj_T22_dancer, _0C3E
    WaitMovement
    Message msg_0556_T22_00015
    CloseMessage
    ApplyMovement obj_T22_dancer, _0C4C
    WaitMovement
    Message msg_0556_T22_00016
    CloseMessage
    ApplyMovement obj_T22_dancer, _0C8E
    WaitMovement
    Common_FadeToDefaultMusic
    RemoveObject obj_T22_dancer
    SetFlag FLAG_HGSS_HIDE_VIOLET_KIMONO_GIRL
    BufferPlayerName 0
    SetPosition 13, 479, 0, 258, DIR_SOUTH
    PlaySE SEQ_SE_DP_DOOR_CLOSE_sseq
    WaitSE SEQ_SE_DP_DOOR_CLOSE_sseq
    ApplyMovement LOCALID_PLAYER, _0CA2
    ApplyMovement 13, _0C9C
    WaitMovement
    BufferPlayerName 0
    Message msg_0556_T22_00029
    CompletePhoneRegister PHONE_CONTACT_FALKNER
    BufferPlayerName 0
    Message msg_0556_T22_00030
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    Message msg_0556_T22_00031
    WaitButton
    CloseMessage
    ApplyMovement 13, _1052
    WaitMovement
    RemoveObject 13
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_VIOLET_CITY_OW, 4
    End
scr_seq_T22_005:
    NPCMessage msg_0556_T22_00026
    End
scr_seq_T22_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0241
    ApplyMovement obj_T22_gsbigman, _0CA8
    GoTo _025C
scr_seq_T22_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Call _0285
    Call _02A6
    CompareVar VAR_0x8006, 1
    GoToIf 1, _032C
    Message msg_0556_T22_00017
    CloseMessage
    Call _0285
    ReleaseAll
    End
scr_seq_T22_002:
    End
scr_seq_T22_006:
    NPCMessage msg_0556_T22_00027
    End
scr_seq_T22_007:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0556_T22_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T22_008:
    DrawSignpostInstantMessage msg_0556_T22_00009, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T22_009:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0556_T22_00010, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T22_010:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0556_T22_00011, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T22_011:
    NPCMessage msg_0556_T22_00005
    End
scr_seq_T22_012:
    NPCMessage msg_0556_T22_00006
    End
scr_seq_T22_013:
    NPCMessage msg_0556_T22_00007
    End
scr_seq_T22_014:
    NPCMessage msg_0556_T22_00008
    End
_0241:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _03D9
    ApplyMovement obj_T22_gsbigman, _0CCA
    GoTo _025C
_025C:
    WaitMovement
    Message msg_0556_T22_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03F4
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03FF
    End
_0285:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0423
    ApplyMovement obj_T22_juggrer, _0CEC
    WaitMovement
    GoTo _0440
_02A6:
    CheckItem ITEM_RED_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0442
    SetVarFromValue VAR_0x8000, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_BLUE_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04A7
    SetVarFromValue VAR_0x8001, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04EB
    SetVarFromValue VAR_0x8002, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _050E
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
    Return
_032C:
    Message msg_0556_T22_00018
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    CompareVar VAR_0x8000, 1
    GoToIf 5, _0510
    AddMenuEntry 205, 0
    CompareVar VAR_0x8001, 1
    GoToIf 5, _059B
    AddMenuEntry 206, 1
    CompareVar VAR_0x8002, 1
    GoToIf 5, _0611
    AddMenuEntry 207, 2
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0672
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06BE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0762
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0806
    CompareVar VAR_0x8008, 3
    GoToIf 1, _08AA
    GoTo _094E
_03D9:
    CompareVar VAR_RESULT, 0
    GoToIf 5, _095D
    ApplyMovement obj_T22_gsbigman, _0D2E
    GoTo _025C
_03F4:
    Message msg_0556_T22_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03FF:
    Message msg_0556_T22_00003
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _098E
    ApplyMovement obj_T22_gsbigman, _0D50
    GoTo _09A9
_0423:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _09DC
    ApplyMovement obj_T22_juggrer, _0D76
    WaitMovement
    GoTo _0440
_0440:
    Return
_0442:
    CheckItem ITEM_BLUE_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04A7
    SetVarFromValue VAR_0x8001, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04EB
    SetVarFromValue VAR_0x8002, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _050E
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
    Return
_04A7:
    CheckItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04EB
    SetVarFromValue VAR_0x8002, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _050E
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
    Return
_04EB:
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _050E
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
    Return
_050E:
    Return
_0510:
    CompareVar VAR_0x8001, 1
    GoToIf 5, _059B
    AddMenuEntry 206, 1
    CompareVar VAR_0x8002, 1
    GoToIf 5, _0611
    AddMenuEntry 207, 2
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0672
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06BE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0762
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0806
    CompareVar VAR_0x8008, 3
    GoToIf 1, _08AA
    GoTo _094E
_059B:
    CompareVar VAR_0x8002, 1
    GoToIf 5, _0611
    AddMenuEntry 207, 2
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0672
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06BE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0762
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0806
    CompareVar VAR_0x8008, 3
    GoToIf 1, _08AA
    GoTo _094E
_0611:
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0672
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06BE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0762
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0806
    CompareVar VAR_0x8008, 3
    GoToIf 1, _08AA
    GoTo _094E
_0672:
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06BE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0762
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0806
    CompareVar VAR_0x8008, 3
    GoToIf 1, _08AA
    GoTo _094E
_06BE:
    Message msg_0556_T22_00021
    SetVar VAR_0x8004, ITEM_CHERI_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_PECHA_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_LEPPA_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_CHERI_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_PECHA_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_LEPPA_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_RED_SHARD, 1, VAR_RESULT
    GoTo _09F7
_0762:
    Message msg_0556_T22_00022
    SetVar VAR_0x8004, ITEM_ORAN_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_CHESTO_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_WIKI_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_ORAN_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_CHESTO_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_WIKI_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_BLUE_SHARD, 1, VAR_RESULT
    GoTo _09F7
_0806:
    Message msg_0556_T22_00023
    SetVar VAR_0x8004, ITEM_ASPEAR_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_SITRUS_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_IAPAPA_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_ASPEAR_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_SITRUS_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_IAPAPA_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    GoTo _09F7
_08AA:
    Message msg_0556_T22_00024
    SetVar VAR_0x8004, ITEM_RAWST_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_LUM_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_AGUAV_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09E8
    SetVar VAR_0x8004, ITEM_RAWST_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_LUM_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_AGUAV_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    GoTo _09F7
_094E:
    Message msg_0556_T22_00020
    CloseMessage
    Call _0285
    ReleaseAll
    End
_095D:
    ApplyMovement obj_T22_gsbigman, _0DB8
    WaitMovement
    Message msg_0556_T22_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03F4
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03FF
    End
_098E:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0A31
    ApplyMovement obj_T22_gsbigman, _0DDA
    GoTo _09A9
_09A9:
    WaitMovement
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0A4C
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0A78
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0AA4
    GoTo _0AD0
_09DC:
    ApplyMovement obj_T22_juggrer, _0DF8
    WaitMovement
    Return
_09E8:
    Message msg_0556_T22_00025
    CloseMessage
    Call _0285
    ReleaseAll
    End
_09F7:
    SetVarFromValue VAR_0x8000, 0
    SetVarFromValue VAR_0x8001, 0
    SetVarFromValue VAR_0x8002, 0
    SetVarFromValue VAR_0x8003, 0
    SetVarFromValue VAR_0x8006, 0
    Call _02A6
    CompareVar VAR_0x8006, 1
    GoToIf 5, _0AFC
    Message msg_0556_T22_00019
    GoTo _0B02
_0A31:
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0BAC
    ApplyMovement obj_T22_gsbigman, _0E3A
    GoTo _09A9
_0A4C:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T22_gsbigman, _0E5C
    ApplyMovement LOCALID_PLAYER, _0EA6
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0BE7
_0A78:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T22_gsbigman, _0E5C
    ApplyMovement LOCALID_PLAYER, _0EC4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0BE7
_0AA4:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T22_gsbigman, _0EE2
    ApplyMovement LOCALID_PLAYER, _0FD0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0BE7
_0AD0:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T22_gsbigman, _0E5C
    ApplyMovement LOCALID_PLAYER, _1002
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0BE7
_0AFC:
    GoTo _094E
_0B02:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    CompareVar VAR_0x8000, 1
    GoToIf 5, _0510
    AddMenuEntry 205, 0
    CompareVar VAR_0x8001, 1
    GoToIf 5, _059B
    AddMenuEntry 206, 1
    CompareVar VAR_0x8002, 1
    GoToIf 5, _0611
    AddMenuEntry 207, 2
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0672
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06BE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0762
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0806
    CompareVar VAR_0x8008, 3
    GoToIf 1, _08AA
    GoTo _094E
_0BAC:
    ApplyMovement obj_T22_gsbigman, _101C
    WaitMovement
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0A4C
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0A78
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0AA4
    GoTo _0AD0
_0BE7:
    Message msg_0556_T22_00004
    CloseMessage
    ApplyMovement obj_T22_gsbigman, _1046
    WaitMovement
    LoadDoorAnimation 15, 8, 15, 1, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_T22_gsbigman, _104C
    WaitMovement
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    RemoveObject obj_T22_gsbigman
    SetFlag FLAG_HGSS_UNK_19A
    ClearFlag FLAG_HGSS_HIDE_EARL_IN_SCHOOL
    ReleaseAll
    End
    .balign 4, 0
_0C2A:
    EmoteExclamationMark
    WalkNormalWest 5
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0C38:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0C3E:
    LockDir
    WalkSlowSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_0C4C:
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    EndMovement
    .balign 4, 0
_0C8E:
    WalkNormalSouth 2
    WalkNormalWest
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
_0C9C:
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0CA2:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0CA8:
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    EndMovement
    .balign 4, 0
_0CCA:
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_0CEC:
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    EndMovement
    .balign 4, 0
_0D2E:
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0D50:
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0D76:
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    EndMovement
    .balign 4, 0
_0DB8:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    EndMovement
    .balign 4, 0
_0DDA:
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0DF8:
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    EndMovement
    .balign 4, 0
_0E3A:
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0E5C:
    WalkFastSouth 8
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    WalkFastEast 21
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    WalkFastNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0EA6:
    Delay8
    RunWest
    RunSouth 8
    WalkOnSpotNormalEast
    Delay4
    RunEast 21
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0EC4:
    Delay8
    RunEast
    RunSouth 8
    WalkOnSpotNormalEast
    Delay4
    RunEast 21
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0EE2:
    WalkFastWest 2
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    WalkFastSouth 3
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    WalkFastEast 2
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    WalkFastSouth 5
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    WalkFastEast 21
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    WalkFastNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0FD0:
    WalkFastSouth
    WalkFastEast
    WalkOnSpotFastWest
    Delay8 2
    WalkOnSpotFastSouth
    Delay8 2
    WalkFastWest
    RunSouth 6
    WalkOnSpotNormalEast
    Delay4
    RunEast 21
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1002:
    Delay8
    RunSouth 9
    WalkOnSpotNormalEast
    Delay4
    RunEast 21
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_101C:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_1046:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_104C:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_1052:
    WalkNormalEast 9
    EndMovement
    .balign 4, 0
