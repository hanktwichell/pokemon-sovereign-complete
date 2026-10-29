#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0259.h"

#define obj_P01R0301_seaman_2_2 1
#define obj_P01R0301_gsgentleman 3

    ScriptEntry scr_seq_P01R0301_000
    ScriptEntry scr_seq_P01R0301_001
    ScriptEntry scr_seq_P01R0301_002
    ScriptEntry scr_seq_P01R0301_003
    ScriptEntry scr_seq_P01R0301_004
    ScriptEntry scr_seq_P01R0301_005
    ScriptEntry scr_seq_P01R0301_006
    ScriptEntry scr_seq_P01R0301_007
    ScriptEntry scr_seq_P01R0301_008
    ScriptEntryEnd
scr_seq_P01R0301_007:
    GoToIfUnset FLAG_HGSS_BOAT_ARRIVED, _0031
_0031:
    End
scr_seq_P01R0301_006:
    CompareVar VAR_HGSS_BOAT_DIRECTION, 1
    GoToIf 3, _004F
    CompareVar VAR_HGSS_BOAT_DIRECTION, 2
    GoToIf 4, _0059
    End
_004F:
    SetWarpEventPos 0, 27, 20
    End
_0059:
    SetWarpEventPos 12, 27, 20
    End
scr_seq_P01R0301_008:
    End
scr_seq_P01R0301_005:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _009C
    ApplyMovement obj_P01R0301_seaman_2_2, _00A4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_UNK_40DC, 1
    ReleaseAll
    End
    .balign 4, 0
_009C:
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_00A4:
    LockDir
    WalkSlowWest
    UnlockDir
    FaceEast 2
    Delay16
    WalkSlowEast
    FaceNorth 2
    EndMovement
scr_seq_P01R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_BOAT_DIRECTION, 1
    GoToIf 2, _00E5
    GoTo _00EB
_00DF:
    GoTo _00EB
_00E5:
    GoTo _0138
_00EB:
    GoToIfSet FLAG_HGSS_BOAT_ARRIVED, _0101
    Message msg_0259_P01R0301_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0101:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _012D
    Message msg_0259_P01R0301_00002
    CloseMessage
    ApplyMovement obj_P01R0301_seaman_2_2, _0180
    WaitMovement
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 7
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    ReleaseAll
    End
_012D:
    Message msg_0259_P01R0301_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0138:
    GoToIfSet FLAG_HGSS_BOAT_ARRIVED, _014E
    Message msg_0259_P01R0301_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_014E:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0174
    Message msg_0259_P01R0301_00005
    CloseMessage
    ApplyMovement obj_P01R0301_seaman_2_2, _0180
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    ReleaseAll
    End
_0174:
    Message msg_0259_P01R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0180:
    LockDir
    WalkNormalSouth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
scr_seq_P01R0301_004:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0280
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 22
    GoToIf 5, _01D3
    SetPosition obj_P01R0301_gsgentleman, 31, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    GoTo _023C
_01D3:
    CompareVar VAR_MAP_LOCAL_0x00, 23
    GoToIf 5, _01F2
    SetPosition obj_P01R0301_gsgentleman, 32, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    GoTo _023C
_01F2:
    CompareVar VAR_MAP_LOCAL_0x00, 24
    GoToIf 5, _0211
    SetPosition obj_P01R0301_gsgentleman, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    GoTo _023C
_0211:
    CompareVar VAR_MAP_LOCAL_0x00, 25
    GoToIf 5, _0230
    SetPosition obj_P01R0301_gsgentleman, 34, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    GoTo _023C
_0230:
    SetPosition obj_P01R0301_gsgentleman, 35, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
_023C:
    ApplyMovement obj_P01R0301_gsgentleman, _0288
    ApplyMovement LOCALID_PLAYER, _02A0
    WaitMovement
    ApplyMovement obj_P01R0301_gsgentleman, _02B8
    WaitMovement
    Message msg_0259_P01R0301_00007
    CloseMessage
    ApplyMovement obj_P01R0301_gsgentleman, _02C0
    WaitMovement
    RemoveObject obj_P01R0301_gsgentleman
    SetFlag FLAG_HGSS_UNK_215
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 2
    ReleaseAll
    End
    .balign 4, 0
_0280:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0288:
    WalkFastWest 9
    LockDir
    JumpNearFastEast
    UnlockDir
    Delay16
    EndMovement
    .balign 4, 0
_02A0:
    Delay2 5
    FaceEast 2
    Delay2 5
    JumpOnSpotFastEast
    Delay16
    EndMovement
    .balign 4, 0
_02B8:
    JumpOnSpotFastWest 4
    EndMovement
    .balign 4, 0
_02C0:
    WalkOnSpotFastWest 2
    FaceNorth 2
    WalkFastNorth
    FaceWest 2
    WalkFastWest 10
    EndMovement
scr_seq_P01R0301_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: NopVar490 VAR_SCENE_SS_AQUA
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 7
    GoToIf 0, _02FA
    Message msg_0259_P01R0301_00009
    GoTo _02FD
_02FA:
    Message msg_0259_P01R0301_00008
_02FD:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_P01R0301_002:
    NPCMessage msg_0259_P01R0301_00010
    End
scr_seq_P01R0301_003:
    End
    .balign 4, 0
