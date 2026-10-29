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
    @ HGSS: PhoneCall PHONE_CONTACT_PROF__ELM, 2, 1
    SetVarFromValue VAR_HGSS_SCENE_VIOLET_CITY_OW, 2
    ClearFlag FLAG_HGSS_HIDE_VIOLET_SHOP_LAB_AIDE
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_AIDE
    End
scr_seq_T22_004:
    LockAll
    ApplyMovement obj_T22_dancer, _00CC
    WaitMovement
    Message msg_0556_T22_00013
    CloseMessage
    ApplyMovement obj_T22_dancer, _00DC
    WaitMovement
    Message msg_0556_T22_00014
    CloseMessage
    ApplyMovement obj_T22_dancer, _00E4
    WaitMovement
    Message msg_0556_T22_00015
    CloseMessage
    ApplyMovement obj_T22_dancer, _0104
    WaitMovement
    Message msg_0556_T22_00016
    CloseMessage
    ApplyMovement obj_T22_dancer, _00F4
    WaitMovement
    Common_FadeToDefaultMusic
    RemoveObject obj_T22_dancer
    SetFlag FLAG_HGSS_HIDE_VIOLET_KIMONO_GIRL
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_VIOLET_CITY_OW, 4
    End
    .balign 4, 0
_00CC:
    EmoteExclamationMark
    WalkNormalWest 5
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_00DC:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_00E4:
    LockDir
    WalkSlowSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_00F4:
    WalkNormalSouth 2
    WalkNormalWest
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
_0104:
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
scr_seq_T22_005:
    NPCMessage msg_0556_T22_00026
    End
scr_seq_T22_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0182
    ApplyMovement obj_T22_gsbigman, _0388
    GoTo _01C0
_0182:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _019D
    ApplyMovement obj_T22_gsbigman, _03AC
    GoTo _01C0
_019D:
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01B8
    ApplyMovement obj_T22_gsbigman, _03D0
    GoTo _01C0
_01B8:
    ApplyMovement obj_T22_gsbigman, _03F4
_01C0:
    WaitMovement
    Message msg_0556_T22_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01E9
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01F4
    End
_01E9:
    Message msg_0556_T22_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01F4:
    Message msg_0556_T22_00003
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0218
    ApplyMovement obj_T22_gsbigman, _0418
    GoTo _0256
_0218:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0233
    ApplyMovement obj_T22_gsbigman, _0440
    GoTo _0256
_0233:
    CompareVar VAR_RESULT, 0
    GoToIf 5, _024E
    ApplyMovement obj_T22_gsbigman, _0460
    GoTo _0256
_024E:
    ApplyMovement obj_T22_gsbigman, _0484
_0256:
    WaitMovement
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _028B
    CompareVar VAR_RESULT, 3
    GoToIf 1, _02B9
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02E7
    GoTo _0315
    End
_028B:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T22_gsbigman, _04B0
    ApplyMovement LOCALID_PLAYER, _05FC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0343
    End
_02B9:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T22_gsbigman, _04B0
    ApplyMovement LOCALID_PLAYER, _061C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0343
    End
_02E7:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T22_gsbigman, _04FC
    ApplyMovement LOCALID_PLAYER, _063C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0343
    End
_0315:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T22_gsbigman, _04B0
    ApplyMovement LOCALID_PLAYER, _0670
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0343
    End
_0343:
    Message msg_0556_T22_00004
    CloseMessage
    ApplyMovement obj_T22_gsbigman, _05EC
    WaitMovement
    @ HGSS: ScrCmd_307 15, 8, 15, 1, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_T22_gsbigman, _05F4
    WaitMovement
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    RemoveObject obj_T22_gsbigman
    SetFlag FLAG_HGSS_UNK_19A
    ClearFlag FLAG_HGSS_HIDE_EARL_IN_SCHOOL
    ReleaseAll
    End
    .balign 4, 0
_0388:
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
_03AC:
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
_03D0:
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
_03F4:
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
_0418:
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
_0440:
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0460:
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
_0484:
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
_04B0:
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
_04FC:
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
_05EC:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_05F4:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_05FC:
    Delay8
    RunWest
    RunSouth 8
    WalkOnSpotNormalEast
    Delay4
    RunEast 21
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_061C:
    Delay8
    RunEast
    RunSouth 8
    WalkOnSpotNormalEast
    Delay4
    RunEast 21
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_063C:
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
_0670:
    Delay8
    RunSouth 9
    WalkOnSpotNormalEast
    Delay4
    RunEast 21
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_T22_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Call _0ADD
    Call _0A57
    CompareVar VAR_0x8006, 1
    GoToIf 1, _06BC
    Message msg_0556_T22_00017
    CloseMessage
    Call _0ADD
    ReleaseAll
    End
_06BC:
    Message msg_0556_T22_00018
_06BF:
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    CompareVar VAR_0x8000, 1
    GoToIf 5, _06DE
    AddMenuEntryImm 205, 0
_06DE:
    CompareVar VAR_0x8001, 1
    GoToIf 5, _06F3
    AddMenuEntryImm 206, 1
_06F3:
    CompareVar VAR_0x8002, 1
    GoToIf 5, _0708
    AddMenuEntryImm 207, 2
_0708:
    CompareVar VAR_0x8003, 1
    GoToIf 5, _071D
    AddMenuEntryImm 208, 3
_071D:
    AddMenuEntryImm 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0769
    CompareVar VAR_0x8008, 1
    GoToIf 1, _080D
    CompareVar VAR_0x8008, 2
    GoToIf 1, _08B1
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0955
    GoTo _09F9
_0769:
    Message msg_0556_T22_00021
    SetVar VAR_0x8004, ITEM_CHERI_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
    SetVar VAR_0x8004, ITEM_PECHA_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
    SetVar VAR_0x8004, ITEM_LEPPA_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
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
    GoTo _0A17
_080D:
    Message msg_0556_T22_00022
    SetVar VAR_0x8004, ITEM_ORAN_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
    SetVar VAR_0x8004, ITEM_CHESTO_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
    SetVar VAR_0x8004, ITEM_WIKI_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
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
    GoTo _0A17
_08B1:
    Message msg_0556_T22_00023
    SetVar VAR_0x8004, ITEM_ASPEAR_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
    SetVar VAR_0x8004, ITEM_SITRUS_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
    SetVar VAR_0x8004, ITEM_IAPAPA_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
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
    GoTo _0A17
_0955:
    Message msg_0556_T22_00024
    SetVar VAR_0x8004, ITEM_RAWST_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
    SetVar VAR_0x8004, ITEM_LUM_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
    SetVar VAR_0x8004, ITEM_AGUAV_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A08
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
    GoTo _0A17
_09F9:
    Message msg_0556_T22_00020
    CloseMessage
    Call _0ADD
    ReleaseAll
    End
_0A08:
    Message msg_0556_T22_00025
    CloseMessage
    Call _0ADD
    ReleaseAll
    End
_0A17:
    SetVarFromValue VAR_0x8000, 0
    SetVarFromValue VAR_0x8001, 0
    SetVarFromValue VAR_0x8002, 0
    SetVarFromValue VAR_0x8003, 0
    SetVarFromValue VAR_0x8006, 0
    Call _0A57
    CompareVar VAR_0x8006, 1
    GoToIf 5, _0A51
    Message msg_0556_T22_00019
    GoTo _06BF
_0A51:
    GoTo _09F9
_0A57:
    CheckItem ITEM_RED_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0A78
    SetVarFromValue VAR_0x8000, 1
    SetVarFromValue VAR_0x8006, 1
_0A78:
    CheckItem ITEM_BLUE_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0A99
    SetVarFromValue VAR_0x8001, 1
    SetVarFromValue VAR_0x8006, 1
_0A99:
    CheckItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0ABA
    SetVarFromValue VAR_0x8002, 1
    SetVarFromValue VAR_0x8006, 1
_0ABA:
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0ADB
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
_0ADB:
    Return
_0ADD:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0AFE
    ApplyMovement obj_T22_juggrer, _0B28
    WaitMovement
    GoTo _0B25
_0AFE:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0B1B
    ApplyMovement obj_T22_juggrer, _0B6C
    WaitMovement
    GoTo _0B25
_0B1B:
    ApplyMovement obj_T22_juggrer, _0BB0
    WaitMovement
_0B25:
    Return
    .balign 4, 0
_0B28:
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
_0B6C:
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
_0BB0:
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
    .balign 4, 0
