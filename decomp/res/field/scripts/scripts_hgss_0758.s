#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0467.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T04_gsmiddleman1 6

    ScriptEntry scr_seq_T04_000
    ScriptEntry scr_seq_T04_001
    ScriptEntry scr_seq_T04_002
    ScriptEntry scr_seq_T04_003
    ScriptEntry scr_seq_T04_004
    ScriptEntry scr_seq_T04_005
    ScriptEntry scr_seq_T04_006
    ScriptEntry scr_seq_T04_007
    ScriptEntry scr_seq_T04_008
    ScriptEntry scr_seq_T04_009
    ScriptEntry scr_seq_T04_010
    ScriptEntry scr_seq_T04_011
    ScriptEntry scr_seq_T04_012
    ScriptEntry scr_seq_T04_013
    ScriptEntryEnd
scr_seq_T04_012:
    GoToIfUnset FLAG_HGSS_UNK_189, _004B
    ClearFlag FLAG_HGSS_UNK_189
    End
_004B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _006F
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _006F
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_006F:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_T04_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0093
    Message msg_0467_T04_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0093:
    Message msg_0467_T04_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T04_001:
    NPCMessage msg_0467_T04_00002
    End
scr_seq_T04_002:
    NPCMessage msg_0467_T04_00005
    End
scr_seq_T04_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0467_T04_00003
    PlayCry SPECIES_SLOWBRO, 0
    WaitCry
    Message msg_0467_T04_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T04_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROUTE_24_ROCKET, 3
    GoToIf 4, _012C
    CompareVar VAR_HGSS_UNK_411C, 2
    GoToIf 1, _0123
    CompareVar VAR_HGSS_UNK_411C, 1
    GoToIf 1, _011A
    Message msg_0467_T04_00006
    GoTo _012F
_011A:
    Message msg_0467_T04_00007
    GoTo _012F
_0123:
    Message msg_0467_T04_00008
    GoTo _012F
_012C:
    Message msg_0467_T04_00009
_012F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T04_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0467_T04_00010
    Message msg_0467_T04_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T04_013:
    NPCMessage msg_0467_T04_00012
    End
scr_seq_T04_006:
    DrawSignpostInstantMessage msg_0467_T04_00013, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T04_007:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0467_T04_00014, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T04_008:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0467_T04_00015, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T04_009:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0467_T04_00016, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T04_010:
    DrawSignpostInstantMessage msg_0467_T04_00017, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T04_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02F5
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0309
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0246
    ApplyMovement LOCALID_PLAYER, _0320
    ApplyMovement obj_T04_gsmiddleman1, _036C
    GoTo _0294
_0246:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0261
    ApplyMovement LOCALID_PLAYER, _0338
    GoTo _0294
_0261:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0284
    ApplyMovement LOCALID_PLAYER, _0358
    ApplyMovement obj_T04_gsmiddleman1, _036C
    GoTo _0294
_0284:
    ApplyMovement LOCALID_PLAYER, _0344
    ApplyMovement obj_T04_gsmiddleman1, _036C
_0294:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02BB
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0378
    WaitMovement
_02BB:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 55
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
_02F5:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0309:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0320:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0338:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0344:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0358:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_036C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0378:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
