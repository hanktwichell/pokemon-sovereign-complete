#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0512.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T08_gsmiddleman1_2 5
#define obj_T08_juggrer 6

    ScriptEntry scr_seq_T08_000
    ScriptEntry scr_seq_T08_001
    ScriptEntry scr_seq_T08_002
    ScriptEntry scr_seq_T08_003
    ScriptEntry scr_seq_T08_004
    ScriptEntry scr_seq_T08_005
    ScriptEntry scr_seq_T08_006
    ScriptEntry scr_seq_T08_007
    ScriptEntry scr_seq_T08_008
    ScriptEntry scr_seq_T08_009
    ScriptEntryEnd
scr_seq_T08_007:
    GoToIfUnset FLAG_HGSS_UNK_189, _003B
    ClearFlag FLAG_HGSS_UNK_189
    End
_003B:
    ClearFlag FLAG_HGSS_UNK_149
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0063
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0063
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0063:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_T08_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _014B
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _015F
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00DA
    ApplyMovement LOCALID_PLAYER, _0174
    GoTo _00EA
_00DA:
    ApplyMovement LOCALID_PLAYER, _0180
    ApplyMovement obj_T08_gsmiddleman1_2, _0194
_00EA:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0111
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _01A0
    WaitMovement
_0111:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 62
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
_014B:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_015F:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0174:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0180:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0194:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01A0:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T08_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Call _0601
    Call _057B
    CompareVar VAR_0x8006, 1
    GoToIf 1, _01E0
    Message msg_0512_T08_00007
    CloseMessage
    Call _0601
    ReleaseAll
    End
_01E0:
    Message msg_0512_T08_00008
_01E3:
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    CompareVar VAR_0x8000, 1
    GoToIf 5, _0202
    AddMenuEntryImm 205, 0
_0202:
    CompareVar VAR_0x8001, 1
    GoToIf 5, _0217
    AddMenuEntryImm 206, 1
_0217:
    CompareVar VAR_0x8002, 1
    GoToIf 5, _022C
    AddMenuEntryImm 207, 2
_022C:
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0241
    AddMenuEntryImm 208, 3
_0241:
    AddMenuEntryImm 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _028D
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0331
    CompareVar VAR_0x8008, 2
    GoToIf 1, _03D5
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0479
    GoTo _051D
_028D:
    Message msg_0512_T08_00011
    SetVar VAR_0x8004, ITEM_PERSIM_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_RAZZ_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_POMEG_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_PERSIM_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_RAZZ_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_POMEG_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_RED_SHARD, 1, VAR_RESULT
    GoTo _053B
_0331:
    Message msg_0512_T08_00012
    SetVar VAR_0x8004, ITEM_BLUK_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_KELPSY_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_CORNN_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_BLUK_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_KELPSY_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_CORNN_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_BLUE_SHARD, 1, VAR_RESULT
    GoTo _053B
_03D5:
    Message msg_0512_T08_00013
    SetVar VAR_0x8004, ITEM_PINAP_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_GREPA_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_NOMEL_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_PINAP_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_GREPA_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_NOMEL_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    GoTo _053B
_0479:
    Message msg_0512_T08_00014
    SetVar VAR_0x8004, ITEM_WEPEAR_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_HONDEW_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_DURIN_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _052C
    SetVar VAR_0x8004, ITEM_WEPEAR_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_HONDEW_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_DURIN_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    GoTo _053B
_051D:
    Message msg_0512_T08_00010
    CloseMessage
    Call _0601
    ReleaseAll
    End
_052C:
    Message msg_0512_T08_00015
    CloseMessage
    Call _0601
    ReleaseAll
    End
_053B:
    SetVarFromValue VAR_0x8000, 0
    SetVarFromValue VAR_0x8001, 0
    SetVarFromValue VAR_0x8002, 0
    SetVarFromValue VAR_0x8003, 0
    SetVarFromValue VAR_0x8006, 0
    Call _057B
    CompareVar VAR_0x8006, 1
    GoToIf 5, _0575
    Message msg_0512_T08_00009
    GoTo _01E3
_0575:
    GoTo _051D
_057B:
    CheckItem ITEM_RED_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _059C
    SetVarFromValue VAR_0x8000, 1
    SetVarFromValue VAR_0x8006, 1
_059C:
    CheckItem ITEM_BLUE_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05BD
    SetVarFromValue VAR_0x8001, 1
    SetVarFromValue VAR_0x8006, 1
_05BD:
    CheckItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05DE
    SetVarFromValue VAR_0x8002, 1
    SetVarFromValue VAR_0x8006, 1
_05DE:
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05FF
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
_05FF:
    Return
_0601:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0622
    ApplyMovement obj_T08_juggrer, _064C
    WaitMovement
    GoTo _0649
_0622:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _063F
    ApplyMovement obj_T08_juggrer, _0690
    WaitMovement
    GoTo _0649
_063F:
    ApplyMovement obj_T08_juggrer, _06D4
    WaitMovement
_0649:
    Return
    .balign 4, 0
_064C:
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
_0690:
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
_06D4:
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
scr_seq_T08_000:
    NPCMessage msg_0512_T08_00000
    End
scr_seq_T08_001:
    NPCMessage msg_0512_T08_00001
    End
scr_seq_T08_002:
    NPCMessage msg_0512_T08_00002
    End
scr_seq_T08_009:
    DrawSignpostInstantMessage msg_0512_T08_00003, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T08_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0512_T08_00004, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T08_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0512_T08_00005, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T08_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0512_T08_00006, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
