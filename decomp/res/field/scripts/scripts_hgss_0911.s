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
    ScriptEntryEnd
scr_seq_T26_002:
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    SetFlag FLAG_HGSS_UNK_0C5
    SetFlag FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE
    CompareVar VAR_HGSS_UNK_40F8, 0
    GoToIf 5, _0057
    SetVarFromValue VAR_HGSS_UNK_40F8, 2
_0057:
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
    GoToIfUnset FLAG_HGSS_UNK_189, _00B2
    ClearFlag FLAG_HGSS_UNK_189
    End
_00B2:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _00CD
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _00E8
_00CD:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00E4
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _00E8
_00E4:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_00E8:
    End
    .balign 4, 0
_00EC:
    EmoteExclamationMark
    EndMovement
scr_seq_T26_000:
    End
scr_seq_T26_001:
    LockAll
    FadeOutBGM 0, 3
    @ HGSS: ScrCmd_307 8, 7, 13, 14, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_RIVAL
    AddObject obj_T26_gsrivel
    ApplyMovement obj_T26_gsrivel, _02B4
    WaitMovement
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    ApplyMovement LOCALID_PLAYER, _02C0
    WaitMovement
    Common_SetRivalBGM
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 239
    GoToIf 5, _015B
    ApplyMovement obj_T26_gsrivel, _02CC
    GoTo _01C1
_015B:
    CompareVar VAR_MAP_LOCAL_0x01, 240
    GoToIf 5, _0176
    ApplyMovement obj_T26_gsrivel, _02DC
    GoTo _01C1
_0176:
    CompareVar VAR_MAP_LOCAL_0x01, 241
    GoToIf 5, _0191
    ApplyMovement obj_T26_gsrivel, _02F0
    GoTo _01C1
_0191:
    CompareVar VAR_MAP_LOCAL_0x01, 242
    GoToIf 5, _01AC
    ApplyMovement obj_T26_gsrivel, _0304
    GoTo _01C1
_01AC:
    CompareVar VAR_MAP_LOCAL_0x01, 243
    GoToIf 5, _01C1
    ApplyMovement obj_T26_gsrivel, _0318
_01C1:
    WaitMovement
    BufferRivalName 0
    Message msg_0604_T26_00000
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 239
    GoToIf 5, _01F6
    ApplyMovement obj_T26_gsrivel, _032C
    ApplyMovement LOCALID_PLAYER, _037C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03C4
    GoTo _029C
_01F6:
    CompareVar VAR_MAP_LOCAL_0x01, 240
    GoToIf 5, _0221
    ApplyMovement obj_T26_gsrivel, _033C
    ApplyMovement LOCALID_PLAYER, _037C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03C4
    GoTo _029C
_0221:
    CompareVar VAR_MAP_LOCAL_0x01, 241
    GoToIf 5, _024C
    ApplyMovement obj_T26_gsrivel, _034C
    ApplyMovement LOCALID_PLAYER, _037C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03C4
    GoTo _029C
_024C:
    CompareVar VAR_MAP_LOCAL_0x01, 242
    GoToIf 5, _0277
    ApplyMovement obj_T26_gsrivel, _035C
    ApplyMovement LOCALID_PLAYER, _037C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03C4
    GoTo _029C
_0277:
    CompareVar VAR_MAP_LOCAL_0x01, 243
    GoToIf 5, _029C
    ApplyMovement obj_T26_gsrivel, _036C
    ApplyMovement LOCALID_PLAYER, _03A0
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03E0
_029C:
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4078, 1
    RemoveObject obj_T26_gsrivel
    SetFlag FLAG_HGSS_HIDE_OLIVINE_RIVAL
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
    .balign 4, 0
_02B4:
    WalkNormalSouth
    Delay15
    EndMovement
    .balign 4, 0
_02C0:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_02CC:
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_02DC:
    WalkNormalSouth
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_02F0:
    WalkNormalSouth 2
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_0304:
    WalkNormalSouth 3
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_0318:
    WalkNormalSouth 4
    FaceSouth 2
    WalkNormalEast 2
    Delay15
    EndMovement
    .balign 4, 0
_032C:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 10
    EndMovement
    .balign 4, 0
_033C:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 11
    EndMovement
    .balign 4, 0
_034C:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 12
    EndMovement
    .balign 4, 0
_035C:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 13
    EndMovement
    .balign 4, 0
_036C:
    WalkNormalEast 6
    FaceNorth 2
    WalkNormalNorth 14
    EndMovement
    .balign 4, 0
_037C:
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
_03A0:
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
_03C4:
    FaceNorth 2
    LockDir
    WalkSlightlyFastSouth
    UnlockDir
    Delay32 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_03E0:
    FaceSouth 2
    LockDir
    WalkSlightlyFastNorth
    UnlockDir
    EndMovement
scr_seq_T26_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051C
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0530
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _046D
    ApplyMovement LOCALID_PLAYER, _0544
    ApplyMovement obj_T26_gsmiddleman1, _0590
    GoTo _04BB
_046D:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0488
    ApplyMovement LOCALID_PLAYER, _055C
    GoTo _04BB
_0488:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _04AB
    ApplyMovement LOCALID_PLAYER, _057C
    ApplyMovement obj_T26_gsmiddleman1, _0590
    GoTo _04BB
_04AB:
    ApplyMovement LOCALID_PLAYER, _0568
    ApplyMovement obj_T26_gsmiddleman1, _0590
_04BB:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04E2
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _059C
    WaitMovement
_04E2:
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
_051C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0530:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0544:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_055C:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0568:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_057C:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0590:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_059C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
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
    .balign 4, 0
