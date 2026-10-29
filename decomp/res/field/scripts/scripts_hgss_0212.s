#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0360.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R22_gsmiddleman1 0
#define obj_R22_sakaki 1
#define obj_R22_gsrivel 2
#define obj_R22_var_1 3

    ScriptEntry scr_seq_R22_000
    ScriptEntry scr_seq_R22_001
    ScriptEntry scr_seq_R22_002
    ScriptEntry scr_seq_R22_003
    ScriptEntry scr_seq_R22_004
    ScriptEntryEnd
scr_seq_R22_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _0027
    ClearFlag FLAG_HGSS_UNK_189
    End
_0027:
    CompareVar VAR_HGSS_UNK_40FE, 1
    GoToIf 1, _005E
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0058
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0058
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0058:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
_005E:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_R22_004:
    CompareVar VAR_HGSS_UNK_40FE, 1
    GoToIf 1, _0073
    End
_0073:
    SetPosition obj_R22_sakaki, 947, 1, 266, DIR_WEST
    SetPosition obj_R22_gsrivel, 950, 1, 266, DIR_WEST
    SetPosition obj_R22_var_1, 952, 1, 280, DIR_EAST
    End
scr_seq_R22_003:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _037C
    WaitMovement
    ApplyMovement obj_R22_var_1, _02CC
    WaitMovement
    MessageGendered msg_0360_R22_00012, msg_0360_R22_00011
    CloseMessage
    ApplyMovement obj_R22_var_1, _02E0
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0360_R22_00014, msg_0360_R22_00013
    CloseMessage
    ApplyMovement obj_R22_var_1, _02FC
    WaitMovement
    MessageGendered msg_0360_R22_00016, msg_0360_R22_00015
    CloseMessage
    ApplyMovement obj_R22_var_1, _0304
    ApplyMovement LOCALID_PLAYER, _03D0
    WaitMovement
    MessageGendered msg_0360_R22_00018, msg_0360_R22_00017
    CloseMessage
    ApplyMovement obj_R22_var_1, _0338
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0360_R22_00020, msg_0360_R22_00019
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _03A0
    ApplyMovement obj_R22_var_1, _0310
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    @ HGSS: ScrCmd_102 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    ApplyMovement 241, _03DC
    WaitMovement
    FadeOutBGM 0, 30
    ApplyMovement obj_R22_gsrivel, _03F4
    WaitMovement
    BufferRivalName 0
    Message msg_0360_R22_00002
    CloseMessage
    ApplyMovement obj_R22_sakaki, _0438
    WaitMovement
    Message msg_0360_R22_00008
    CloseMessage
    ApplyMovement obj_R22_gsrivel, _03FC
    WaitMovement
    BufferRivalName 0
    Message msg_0360_R22_00003
    CloseMessage
    ApplyMovement obj_R22_sakaki, _0444
    WaitMovement
    Message msg_0360_R22_00009
    CloseMessage
    ApplyMovement obj_R22_gsrivel, _03F4
    WaitMovement
    BufferRivalName 0
    Message msg_0360_R22_00004
    CloseMessage
    ApplyMovement obj_R22_sakaki, _044C
    WaitMovement
    Message msg_0360_R22_00010
    CloseMessage
    ApplyMovement obj_R22_sakaki, _0454
    WaitMovement
    ApplyMovement obj_R22_gsrivel, _03F4
    WaitMovement
    BufferRivalName 0
    Message msg_0360_R22_00005
    CloseMessage
    ApplyMovement obj_R22_gsrivel, _03F4
    WaitMovement
    Message msg_0360_R22_00006
    CloseMessage
    Common_SetRivalBGM
    ApplyMovement 241, _03E8
    ApplyMovement obj_R22_gsrivel, _0404
    WaitMovement
    @ HGSS: ScrCmd_103
    BufferRivalName 0
    Message msg_0360_R22_00007
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R22_gsrivel, _0420
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    ApplyMovement LOCALID_PLAYER, _03B0
    ApplyMovement obj_R22_var_1, _03D0
    WaitMovement
    ApplyMovement obj_R22_gsrivel, _042C
    ApplyMovement LOCALID_PLAYER, _03D0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    RemoveObject obj_R22_sakaki
    RemoveObject obj_R22_gsrivel
    SetFlag FLAG_HGSS_HIDE_ROUTE_22_GIOVANNI_RIVAL
    Common_FadeToDefaultMusic2
    MessageGendered msg_0360_R22_00022, msg_0360_R22_00021
    CloseMessage
    FadeOutBGM 20, 30
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0350
    WaitMovement
    FadeScreen 6, 6, 0, COLOR_WHITE
    WaitFadeScreen
    WaitTime 15, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement LOCALID_PLAYER, _03C4
    ApplyMovement obj_R22_var_1, _0320
    WaitMovement
    MessageGendered msg_0360_R22_00024, msg_0360_R22_00023
    CloseMessage
    @ HGSS: ScrCmd_810
    SetVarFromValue VAR_HGSS_UNK_40FE, 2
    ClearFlag FLAG_HGSS_HIDE_TOHJO_FALLS_GIOVANNI
    ClearFlag FLAG_HGSS_HIDE_TOHJO_FALLS_FRIEND
    Warp MAP_HEADER_HGSS_TOHJO_FALLS_HIDDEN_ROOM, 6, 8, DIR_SOUTH
    FadeScreen 6, 15, 1, COLOR_WHITE
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_02CC:
    EmoteExclamationMark
    Delay8
    WalkOnSpotNormalEast
    Delay16
    EndMovement
    .balign 4, 0
_02E0:
    WalkFastNorth 2
    Delay8
    WalkOnSpotNormalWest
    Delay16
    WalkOnSpotNormalEast
    Delay16
    EndMovement
    .balign 4, 0
_02FC:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0304:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0310:
    WalkNormalNorth 2
    WalkNormalWest 2
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0320:
    WalkOnSpotNormalWest
    Delay16
    WalkOnSpotNormalEast
    Delay16
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0338:
    EmoteExclamationMark
    Delay8
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0350:
    FaceSouth
    JumpFarSouth
    LockDir
    JumpNearFastNorth
    LockDir
    EndMovement
    .balign 4, 0
    LockDir
    WalkFastEast 2
    UnlockDir
    FaceWest
    EndMovement
    .balign 4, 0
_037C:
    WalkOnSpotNormalNorth
    WalkNormalNorth
    Delay8
    WalkOnSpotNormalWest
    Delay16
    WalkOnSpotNormalEast
    Delay16
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03A0:
    WalkNormalNorth 5
    WalkNormalWest 2
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_03B0:
    Delay4
    LockDir
    JumpNearFastSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_03C4:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_03D0:
    Delay16
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03DC:
    WalkNormalNorth 5
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_03E8:
    WalkFastEast 2
    WalkFastSouth 4
    EndMovement
    .balign 4, 0
_03F4:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_03FC:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0404:
    Delay32
    WalkFastEast 6
    WalkFastSouth 4
    Delay8
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0420:
    WalkFastSouth 2
    Delay16
    EndMovement
    .balign 4, 0
_042C:
    WalkFastEast
    WalkFastSouth 8
    EndMovement
    .balign 4, 0
_0438:
    WalkOnSpotNormalEast
    Delay8
    EndMovement
    .balign 4, 0
_0444:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_044C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0454:
    WalkNormalWest 6
    EndMovement
scr_seq_R22_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0584
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0598
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04D5
    ApplyMovement LOCALID_PLAYER, _05AC
    ApplyMovement obj_R22_gsmiddleman1, _05F8
    GoTo _0523
_04D5:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04F0
    ApplyMovement LOCALID_PLAYER, _05C4
    GoTo _0523
_04F0:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0513
    ApplyMovement LOCALID_PLAYER, _05E4
    ApplyMovement obj_R22_gsmiddleman1, _05F8
    GoTo _0523
_0513:
    ApplyMovement LOCALID_PLAYER, _05D0
    ApplyMovement obj_R22_gsmiddleman1, _05F8
_0523:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _054A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0604
    WaitMovement
_054A:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 71
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
_0584:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0598:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_05AC:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05C4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05D0:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05E4:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05F8:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0604:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_R22_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0360_R22_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
