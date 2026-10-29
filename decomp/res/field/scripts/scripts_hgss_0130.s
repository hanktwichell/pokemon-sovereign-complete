#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0145.h"

#define obj_D51R0101_mount_2 0

    ScriptEntry scr_seq_D51R0101_000
    ScriptEntry scr_seq_D51R0101_001
    ScriptEntry scr_seq_D51R0101_002
    ScriptEntry scr_seq_D51R0101_003
    ScriptEntry scr_seq_D51R0101_004
    ScriptEntryEnd
scr_seq_D51R0101_002:
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 5
    GoToIf 1, _0104
    End
scr_seq_D51R0101_000:
    LockAll
    ApplyMovement obj_D51R0101_mount_2, _0112
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0128
    WaitMovement
    Message msg_0145_D51R0101_00000
    CloseMessage
    ApplyMovement obj_D51R0101_mount_2, _012E
    WaitMovement
    Message msg_0145_D51R0101_00001
    CloseMessage
    ApplyMovement obj_D51R0101_mount_2, _0138
    WaitMovement
    SetPosition obj_D51R0101_mount_2, 13, 1, 28, DIR_NORTH
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 5
    ReleaseAll
    End
scr_seq_D51R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0145_D51R0101_00002
    CloseMessage
    ApplyMovement obj_D51R0101_mount_2, _0146
    WaitMovement
    LoadDoorAnimation 0, 0, 20, 25, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_D51R0101_mount_2, _0150
    WaitMovement
    RemoveObject obj_D51R0101_mount_2
    SetFlag FLAG_HGSS_UNK_2DB
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 6
    ReleaseAll
    End
scr_seq_D51R0101_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0145_D51R0101_00007, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D51R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0145_D51R0101_00008
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _0156
    WaitMovement
    RemoveObject obj_D51R0101_mount_2
    SetVar VAR_0x8004, ITEM_ICICLE_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_0104:
    SetPosition obj_D51R0101_mount_2, 13, 1, 28, DIR_NORTH
    End
    .balign 4, 0
_0112:
    WalkOnSpotNormalNorth
    EmoteExclamationMark
    Delay8
    WalkNormalNorth 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0128:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_012E:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0138:
    WalkNormalSouth 4
    WalkNormalWest
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_0146:
    WalkNormalEast 7
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0150:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0156:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
