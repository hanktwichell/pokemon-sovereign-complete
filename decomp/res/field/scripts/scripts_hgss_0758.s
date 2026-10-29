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
    ScriptEntry scr_seq_T04_014
    ScriptEntryEnd
scr_seq_T04_012:
    GoToIfUnset FLAG_HGSS_UNK_189, _0219
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T04_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _023D
    Message msg_0467_T04_00000
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
    GoToIf 4, _0248
    CompareVar VAR_HGSS_UNK_411C, 2
    GoToIf 1, _0253
    CompareVar VAR_HGSS_UNK_411C, 1
    GoToIf 1, _025C
    Message msg_0467_T04_00006
    GoTo _0265
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
    GoToIf 1, _026D
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0281
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0295
    ApplyMovement LOCALID_PLAYER, _03EC
    ApplyMovement obj_T04_gsmiddleman1, _0402
    GoTo _02B0
scr_seq_T04_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0467_T04_00019
    WaitButton
    CloseMessage
    GoToIfSet FLAG_HGSS_SG_3FB0, _0311
    Message msg_0467_T04_00021
    ReleaseAll
    End
_0219:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0318
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0318
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_023D:
    Message msg_0467_T04_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0248:
    Message msg_0467_T04_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0253:
    Message msg_0467_T04_00008
    GoTo _0265
_025C:
    Message msg_0467_T04_00007
    GoTo _0265
_0265:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_026D:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0281:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0295:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _031E
    ApplyMovement LOCALID_PLAYER, _040C
    GoTo _02B0
_02B0:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0341
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0416
    WaitMovement
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
_0311:
    Message msg_0467_T04_00020
    ReleaseAll
    End
_0318:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
_031E:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _037B
    ApplyMovement LOCALID_PLAYER, _0424
    ApplyMovement obj_T04_gsmiddleman1, _0402
    GoTo _02B0
_0341:
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
_037B:
    ApplyMovement LOCALID_PLAYER, _0436
    ApplyMovement obj_T04_gsmiddleman1, _0402
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0341
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0416
    WaitMovement
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
    .balign 4, 0
_03EC:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0402:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_040C:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0416:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0424:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0436:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
