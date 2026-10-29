#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0145.h"

#define obj_D51R0101_mount_2 0

    ScriptEntry scr_seq_D51R0101_000
    ScriptEntry scr_seq_D51R0101_001
    ScriptEntry scr_seq_D51R0101_002
    ScriptEntry scr_seq_D51R0101_003
    ScriptEntryEnd
scr_seq_D51R0101_002:
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 5
    GoToIf 1, _0021
    End
_0021:
    SetPosition obj_D51R0101_mount_2, 13, 1, 28, DIR_NORTH
    End
scr_seq_D51R0101_000:
    LockAll
    ApplyMovement obj_D51R0101_mount_2, _007C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0094
    WaitMovement
    Message msg_0145_D51R0101_00000
    CloseMessage
    ApplyMovement obj_D51R0101_mount_2, _009C
    WaitMovement
    Message msg_0145_D51R0101_00001
    CloseMessage
    ApplyMovement obj_D51R0101_mount_2, _00A8
    WaitMovement
    SetPosition obj_D51R0101_mount_2, 13, 1, 28, DIR_NORTH
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 5
    ReleaseAll
    End
    .balign 4, 0
_007C:
    WalkOnSpotNormalNorth
    EmoteExclamationMark
    Delay8
    WalkNormalNorth 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0094:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_009C:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_00A8:
    WalkNormalSouth 4
    WalkNormalWest
    WalkNormalSouth 4
    EndMovement
scr_seq_D51R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0145_D51R0101_00002
    CloseMessage
    ApplyMovement obj_D51R0101_mount_2, _0108
    WaitMovement
    @ HGSS: ScrCmd_307 0, 0, 20, 25, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_D51R0101_mount_2, _0114
    WaitMovement
    RemoveObject obj_D51R0101_mount_2
    SetFlag FLAG_HGSS_UNK_2DB
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 6
    ReleaseAll
    End
    .balign 4, 0
_0108:
    WalkNormalEast 7
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0114:
    WalkNormalNorth
    EndMovement
scr_seq_D51R0101_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0145_D51R0101_00007, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
