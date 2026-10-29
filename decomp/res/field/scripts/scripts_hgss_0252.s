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
    ScriptEntryEnd
scr_seq_R42_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _017C
    WaitMovement
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    ClearFlag FLAG_HGSS_HIDE_ROUTE_42_HIKER
    AddObject obj_R42_mount_2_2
    CompareVar VAR_0x8001, 172
    GoToIf 5, _0051
    ApplyMovement obj_R42_mount_2_2, _0198
    GoTo _00AA
_0051:
    CompareVar VAR_0x8001, 173
    GoToIf 5, _006C
    ApplyMovement obj_R42_mount_2_2, _01A4
    GoTo _00AA
_006C:
    CompareVar VAR_0x8001, 174
    GoToIf 5, _0087
    ApplyMovement obj_R42_mount_2_2, _01B0
    GoTo _00AA
_0087:
    CompareVar VAR_0x8001, 175
    GoToIf 5, _00A2
    ApplyMovement obj_R42_mount_2_2, _01BC
    GoTo _00AA
_00A2:
    ApplyMovement obj_R42_mount_2_2, _01C8
_00AA:
    WaitMovement
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0184
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0399_R42_00005
    CloseMessage
    ApplyMovement obj_R42_mount_2_2, _01D4
    WaitMovement
    SetVar VAR_0x8004, ITEM_HM04
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0399_R42_00006
    CloseMessage
    CompareVar VAR_0x8001, 172
    GoToIf 5, _010D
    ApplyMovement obj_R42_mount_2_2, _01DC
    GoTo _0166
_010D:
    CompareVar VAR_0x8001, 173
    GoToIf 5, _0128
    ApplyMovement obj_R42_mount_2_2, _01F0
    GoTo _0166
_0128:
    CompareVar VAR_0x8001, 174
    GoToIf 5, _0143
    ApplyMovement obj_R42_mount_2_2, _0204
    GoTo _0166
_0143:
    CompareVar VAR_0x8001, 175
    GoToIf 5, _015E
    ApplyMovement obj_R42_mount_2_2, _0210
    GoTo _0166
_015E:
    ApplyMovement obj_R42_mount_2_2, _0224
_0166:
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_ROUTE_42_HIKER
    RemoveObject obj_R42_mount_2_2
    SetVarFromValue VAR_HGSS_UNK_4091, 1
    ReleaseAll
    End
    .balign 4, 0
_017C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0184:
    FaceEast
    LockDir
    JumpFarWest
    UnlockDir
    EndMovement
    .balign 4, 0
_0198:
    WalkFastSouth
    WalkFastWest
    EndMovement
    .balign 4, 0
_01A4:
    WalkFastSouth 2
    WalkFastWest
    EndMovement
    .balign 4, 0
_01B0:
    WalkFastSouth 3
    WalkFastWest
    EndMovement
    .balign 4, 0
_01BC:
    WalkFastSouth 4
    WalkFastWest
    EndMovement
    .balign 4, 0
_01C8:
    WalkFastSouth 5
    WalkFastWest
    EndMovement
    .balign 4, 0
_01D4:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_01DC:
    WalkNormalSouth
    WalkNormalWest 5
    WalkNormalSouth 2
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_01F0:
    WalkNormalSouth
    WalkNormalWest 5
    WalkNormalSouth
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0204:
    WalkNormalSouth
    WalkNormalWest 10
    EndMovement
    .balign 4, 0
_0210:
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0224:
    WalkNormalNorth
    WalkNormalWest 10
    EndMovement
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
    ApplyMovement obj_R42_tsure_poke_static_suicune, _02EC
    ApplyMovement LOCALID_PLAYER, _0308
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ClearFlag FLAG_HGSS_HIDE_ROUTE_42_EUSINE
    AddObject obj_R42_minaki
    ApplyMovement obj_R42_minaki, _0324
    WaitMovement
    Message msg_0399_R42_00007
    CloseMessage
    ApplyMovement obj_R42_minaki, _0334
    WaitMovement
    BufferPlayerName 0
    Message msg_0399_R42_00008
    CloseMessage
    ApplyMovement obj_R42_minaki, _0348
    WaitMovement
    Message msg_0399_R42_00009
    CloseMessage
    ApplyMovement obj_R42_minaki, _0340
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
    .balign 4, 0
_02EC:
    Delay4 3
    WalkFasterWest 2
    JumpFarWest
    WalkFasterWest 2
    JumpFarNorth 2
    MoveAction_112 1
    EndMovement
    .balign 4, 0
_0308:
    EmoteExclamationMark
    LockDir
    WalkFastNorth 4
    UnlockDir
    Delay16
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0324:
    WalkNormalEast 4
    WalkNormalNorth 3
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0334:
    WalkNormalNorth
    FaceWest
    EndMovement
    .balign 4, 0
_0340:
    WalkNormalEast 9
    EndMovement
    .balign 4, 0
_0348:
    WalkNormalEast
    EndMovement
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
    .balign 4, 0
