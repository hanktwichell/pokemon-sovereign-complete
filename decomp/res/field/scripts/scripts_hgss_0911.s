#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0604.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T26_gsrivel 3
#define obj_T26_gsmiddleman1 7

    ScriptEntry scr_seq_T26_000
    ScriptEntry scr_seq_T26_001
    ScriptEntry scr_seq_T26_002
    ScriptEntry scr_seq_T26_003
    ScriptEntry scr_seq_T26_004
    ScriptEntry scr_seq_T26_005
    ScriptEntry scr_seq_T26_006
    ScriptEntry scr_seq_T26_007
    ScriptEntry scr_seq_T26_008
    ScriptEntry scr_seq_T26_009
    ScriptEntry scr_seq_T26_010
    ScriptEntry scr_seq_T26_011
    ScriptEntry scr_seq_T26_012
    ScriptEntry scr_seq_T26_013
    ScriptEntry scr_seq_T26_014
    ScriptEntry scr_seq_T26_015
    ScriptEntryEnd
scr_seq_T26_002:
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    SetFlag FLAG_HGSS_UNK_0C5
    SetFlag FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE
    CompareVar VAR_HGSS_UNK_40F8, 0
    GoToIf 5, _0248
    SetVarFromValue VAR_HGSS_UNK_40F8, 2
    @ HGSS: PhoneCall PHONE_CONTACT_PROF__ELM, 2, 2
    SetVarFromValue VAR_HGSS_MIDGAME_BADGES, 5
    End
scr_seq_T26_003:
    SetFlag FLAG_HGSS_UNK_0F5
    SetVarFromValue VAR_HGSS_UNK_4057, 1
    @ HGSS: PhoneCall PHONE_CONTACT_BAOBA, 2, 0
    SetFlag FLAG_HGSS_UNK_249
    SetVarFromValue VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 3
    End
scr_seq_T26_012:
    GoToIfUnset FLAG_HGSS_UNK_189, _0266
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T26_000:
    End
scr_seq_T26_001:
    LockAll
    FadeOutBGM 0, 3
    LoadDoorAnimation 8, 7, 13, 14, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_RIVAL
    AddObject obj_T26_gsrivel
    ApplyMovement obj_T26_gsrivel, _05B8
    WaitMovement
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    ApplyMovement LOCALID_PLAYER, _05C2
    WaitMovement
    Common_SetRivalBGM
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 239
    GoToIf 5, _0281
    ApplyMovement obj_T26_gsrivel, _05CC
    GoTo _029C
scr_seq_T26_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02D1
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02E5
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02F9
    ApplyMovement LOCALID_PLAYER, _05DA
    ApplyMovement obj_T26_gsmiddleman1, _05F0
    GoTo _0314
scr_seq_T26_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0604_T26_00007, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T26_005:
    DrawSignpostInstantMessage msg_0604_T26_00005, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T26_006:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0604_T26_00006, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T26_007:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0604_T26_00008, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T26_008:
    NPCMessage msg_0604_T26_00001
    End
scr_seq_T26_009:
    NPCMessage msg_0604_T26_00002
    End
scr_seq_T26_010:
    NPCMessage msg_0604_T26_00004
    End
scr_seq_T26_013:
    BufferPlayerName 0
    End
scr_seq_T26_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0604_T26_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T26_015:
    BufferPlayerName 0
    End
_0248:
    @ HGSS: PhoneCall PHONE_CONTACT_PROF__ELM, 2, 2
    SetVarFromValue VAR_HGSS_MIDGAME_BADGES, 5
    End
_0266:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0375
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _038C
_0281:
    CompareVar VAR_MAP_LOCAL_0x01, 240
    GoToIf 5, _038E
    ApplyMovement obj_T26_gsrivel, _05FA
    GoTo _029C
_029C:
    WaitMovement
    CompleteBufferHGSSRivalName 0
    Message msg_0604_T26_00000
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 239
    GoToIf 5, _03A9
    ApplyMovement obj_T26_gsrivel, _060C
    ApplyMovement LOCALID_PLAYER, _061A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _063C
    GoTo _03D4
_02D1:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02E5:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02F9:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _03EC
    ApplyMovement LOCALID_PLAYER, _0656
    GoTo _0314
_0314:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _040F
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0660
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 23
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
_0375:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0449
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _038C
_038C:
    End
_038E:
    CompareVar VAR_MAP_LOCAL_0x01, 241
    GoToIf 5, _044F
    ApplyMovement obj_T26_gsrivel, _066E
    GoTo _029C
_03A9:
    CompareVar VAR_MAP_LOCAL_0x01, 240
    GoToIf 5, _046A
    ApplyMovement obj_T26_gsrivel, _0680
    ApplyMovement LOCALID_PLAYER, _061A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _063C
    GoTo _03D4
_03D4:
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4078, 1
    RemoveObject obj_T26_gsrivel
    SetFlag FLAG_HGSS_HIDE_OLIVINE_RIVAL
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
_03EC:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0495
    ApplyMovement LOCALID_PLAYER, _068E
    ApplyMovement obj_T26_gsmiddleman1, _05F0
    GoTo _0314
_040F:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 23
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
_0449:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_044F:
    CompareVar VAR_MAP_LOCAL_0x01, 242
    GoToIf 5, _0506
    ApplyMovement obj_T26_gsrivel, _06A0
    GoTo _029C
_046A:
    CompareVar VAR_MAP_LOCAL_0x01, 241
    GoToIf 5, _0550
    ApplyMovement obj_T26_gsrivel, _06B2
    ApplyMovement LOCALID_PLAYER, _061A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _063C
    GoTo _03D4
_0495:
    ApplyMovement LOCALID_PLAYER, _06C0
    ApplyMovement obj_T26_gsmiddleman1, _05F0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _040F
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0660
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 23
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
_0506:
    CompareVar VAR_MAP_LOCAL_0x01, 243
    GoToIf 5, _029C
    ApplyMovement obj_T26_gsrivel, _06D2
    WaitMovement
    CompleteBufferHGSSRivalName 0
    Message msg_0604_T26_00000
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 239
    GoToIf 5, _03A9
    ApplyMovement obj_T26_gsrivel, _060C
    ApplyMovement LOCALID_PLAYER, _061A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _063C
    GoTo _03D4
_0550:
    CompareVar VAR_MAP_LOCAL_0x01, 242
    GoToIf 5, _057B
    ApplyMovement obj_T26_gsrivel, _06E4
    ApplyMovement LOCALID_PLAYER, _061A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _063C
    GoTo _03D4
_057B:
    CompareVar VAR_MAP_LOCAL_0x01, 243
    GoToIf 5, _03D4
    ApplyMovement obj_T26_gsrivel, _06F2
    ApplyMovement LOCALID_PLAYER, _0700
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0722
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4078, 1
    RemoveObject obj_T26_gsrivel
    SetFlag FLAG_HGSS_HIDE_OLIVINE_RIVAL
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
    .balign 4, 0
_05B8:
    WalkNormalSouth
    Delay15
    EndMovement
    .balign 4, 0
_05C2:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_05CC:
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_05DA:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05F0:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05FA:
    WalkNormalSouth
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_060C:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 10
    EndMovement
    .balign 4, 0
_061A:
    FaceNorth 2
    LockDir
    WalkSlightlyFastSouth
    UnlockDir
    Delay15
    WalkOnSpotNormalEast
    Delay15
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_063C:
    FaceNorth 2
    LockDir
    WalkSlightlyFastSouth
    UnlockDir
    Delay32 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0656:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0660:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_066E:
    WalkNormalSouth 2
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_0680:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 11
    EndMovement
    .balign 4, 0
_068E:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06A0:
    WalkNormalSouth 3
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_06B2:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 12
    EndMovement
    .balign 4, 0
_06C0:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06D2:
    WalkNormalSouth 4
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_06E4:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 13
    EndMovement
    .balign 4, 0
_06F2:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 14
    EndMovement
    .balign 4, 0
_0700:
    FaceSouth 2
    LockDir
    WalkSlightlyFastNorth
    UnlockDir
    Delay15
    WalkOnSpotNormalEast
    Delay15
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0722:
    FaceSouth 2
    LockDir
    WalkSlightlyFastNorth
    UnlockDir
    EndMovement
    .balign 4, 0
