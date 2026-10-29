#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0399.h"

#define obj_R42_mount_2_2 10
#define obj_R42_tsure_poke_static_suicune 11
#define obj_R42_minaki 12

    ScriptEntry scr_seq_R42_000
    ScriptEntry scr_seq_R42_001
    ScriptEntry scr_seq_R42_002
    ScriptEntry scr_seq_R42_003
    ScriptEntry scr_seq_R42_004
    ScriptEntry scr_seq_R42_005
    ScriptEntry scr_seq_R42_006
    ScriptEntryEnd
scr_seq_R42_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _030C
    WaitMovement
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    ClearFlag FLAG_HGSS_HIDE_ROUTE_42_HIKER
    AddObject obj_R42_mount_2_2
    CompareVar VAR_0x8001, 172
    GoToIf 5, _016C
    ApplyMovement obj_R42_mount_2_2, _0312
    GoTo _0187
scr_seq_R42_001:
    LockAll
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_R42_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_R42_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_R42_tsure_poke_static_suicune
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R42_tsure_poke_static_suicune, _031C
    ApplyMovement LOCALID_PLAYER, _0336
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ClearFlag FLAG_HGSS_HIDE_ROUTE_42_EUSINE
    AddObject obj_R42_minaki
    ApplyMovement obj_R42_minaki, _0350
    WaitMovement
    Message msg_0399_R42_00007
    CloseMessage
    ApplyMovement obj_R42_minaki, _035E
    WaitMovement
    BufferPlayerName 0
    Message msg_0399_R42_00008
    CloseMessage
    ApplyMovement obj_R42_minaki, _0368
    WaitMovement
    Message msg_0399_R42_00009
    CloseMessage
    ApplyMovement obj_R42_minaki, _036E
    WaitMovement
    Common_FadeToDefaultMusic
    RemoveObject obj_R42_tsure_poke_static_suicune
    RemoveObject obj_R42_minaki
    SetFlag FLAG_HGSS_HIDE_ROUTE_42_SUICUNE
    SetFlag FLAG_HGSS_HIDE_ROUTE_42_EUSINE
    SetVarFromValue VAR_HGSS_UNK_4092, 0
    SetVarFromValue VAR_HGSS_UNK_4070, 1
    SetVarFromValue VAR_HGSS_UNK_4071, 1
    ClearFlag FLAG_HGSS_HIDE_VERMILION_SUICUNE
    ReleaseAll
    End
scr_seq_R42_002:
    DrawSignpostInstantMessage msg_0399_R42_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R42_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0399_R42_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R42_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0399_R42_00002, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R42_005:
    DrawSignpostInstantMessage msg_0399_R42_00003, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R42_006:
    BufferPlayerName 0
    End
_016C:
    CompareVar VAR_0x8001, 173
    GoToIf 5, _01EA
    ApplyMovement obj_R42_mount_2_2, _0374
    GoTo _0187
_0187:
    WaitMovement
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _037E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0399_R42_00005
    CloseMessage
    ApplyMovement obj_R42_mount_2_2, _0390
    WaitMovement
    SetVar VAR_0x8004, ITEM_HM04
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0399_R42_00006
    CloseMessage
    CompareVar VAR_0x8001, 172
    GoToIf 5, _0205
    ApplyMovement obj_R42_mount_2_2, _0396
    GoTo _0220
_01EA:
    CompareVar VAR_0x8001, 174
    GoToIf 5, _0234
    ApplyMovement obj_R42_mount_2_2, _03A8
    GoTo _0187
_0205:
    CompareVar VAR_0x8001, 173
    GoToIf 5, _024F
    ApplyMovement obj_R42_mount_2_2, _03B2
    GoTo _0220
_0220:
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_ROUTE_42_HIKER
    RemoveObject obj_R42_mount_2_2
    SetVarFromValue VAR_HGSS_UNK_4091, 1
    ReleaseAll
    End
_0234:
    CompareVar VAR_0x8001, 175
    GoToIf 5, _026A
    ApplyMovement obj_R42_mount_2_2, _03C4
    GoTo _0187
_024F:
    CompareVar VAR_0x8001, 174
    GoToIf 5, _02D5
    ApplyMovement obj_R42_mount_2_2, _03CE
    GoTo _0220
_026A:
    ApplyMovement obj_R42_mount_2_2, _03D8
    WaitMovement
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _037E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0399_R42_00005
    CloseMessage
    ApplyMovement obj_R42_mount_2_2, _0390
    WaitMovement
    SetVar VAR_0x8004, ITEM_HM04
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0399_R42_00006
    CloseMessage
    CompareVar VAR_0x8001, 172
    GoToIf 5, _0205
    ApplyMovement obj_R42_mount_2_2, _0396
    GoTo _0220
_02D5:
    CompareVar VAR_0x8001, 175
    GoToIf 5, _02F0
    ApplyMovement obj_R42_mount_2_2, _03E2
    GoTo _0220
_02F0:
    ApplyMovement obj_R42_mount_2_2, _03F4
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_ROUTE_42_HIKER
    RemoveObject obj_R42_mount_2_2
    SetVarFromValue VAR_HGSS_UNK_4091, 1
    ReleaseAll
    End
    .balign 4, 0
_030C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0312:
    WalkFastSouth
    WalkFastWest
    EndMovement
    .balign 4, 0
_031C:
    Delay4 3
    WalkFasterWest 2
    JumpFarWest
    WalkFasterWest 2
    JumpFarNorth 2
    MoveAction_112
    EndMovement
    .balign 4, 0
_0336:
    EmoteExclamationMark
    LockDir
    WalkFastNorth 4
    UnlockDir
    Delay16
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0350:
    WalkNormalEast 4
    WalkNormalNorth 3
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_035E:
    WalkNormalNorth
    FaceWest
    EndMovement
    .balign 4, 0
_0368:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_036E:
    WalkNormalEast 9
    EndMovement
    .balign 4, 0
_0374:
    WalkFastSouth 2
    WalkFastWest
    EndMovement
    .balign 4, 0
_037E:
    FaceEast
    LockDir
    JumpFarWest
    UnlockDir
    EndMovement
    .balign 4, 0
_0390:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0396:
    WalkNormalSouth
    WalkNormalWest 5
    WalkNormalSouth 2
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_03A8:
    WalkFastSouth 3
    WalkFastWest
    EndMovement
    .balign 4, 0
_03B2:
    WalkNormalSouth
    WalkNormalWest 5
    WalkNormalSouth
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_03C4:
    WalkFastSouth 4
    WalkFastWest
    EndMovement
    .balign 4, 0
_03CE:
    WalkNormalSouth
    WalkNormalWest 10
    EndMovement
    .balign 4, 0
_03D8:
    WalkFastSouth 5
    WalkFastWest
    EndMovement
    .balign 4, 0
_03E2:
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_03F4:
    WalkNormalNorth
    WalkNormalWest 10
    EndMovement
    .balign 4, 0
