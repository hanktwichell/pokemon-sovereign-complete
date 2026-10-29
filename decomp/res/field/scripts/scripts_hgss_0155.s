#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0258.h"

#define obj_P01R0104_seaman_2 0

    ScriptEntry scr_seq_P01R0104_000
    ScriptEntry scr_seq_P01R0104_001
    ScriptEntry scr_seq_P01R0104_002
    ScriptEntry scr_seq_P01R0104_003
    ScriptEntryEnd
scr_seq_P01R0104_003:
    GoToIfSet FLAG_HGSS_UNK_168, _0021
    SetFlag FLAG_HGSS_UNK_998
_0021:
    @ HGSS: ScrCmd_804 2
    SetFlag FLAG_HGSS_UNK_168
    SetFlag FLAG_HGSS_SYS_FLYPOINT_VERMILION
    @ HGSS: ScrCmd_582 MAP_VERMILION, 1309, 340
    End
scr_seq_P01R0104_002:
    CompareVar VAR_HGSS_BOAT_DIRECTION, 1
    GoToIf 1, _0045
    End
_0045:
    SetPosition obj_P01R0104_seaman_2, 24, 0, 19, DIR_WEST
    End
scr_seq_P01R0104_001:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0090
    WaitMovement
    ApplyMovement obj_P01R0104_seaman_2, _0098
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_BOAT_DIRECTION, 0
    ClearFlag FLAG_HGSS_RECEIVED_PLATE_FROM_AQUA_CAPTAIN_THIS_TRIP
    ReleaseAll
    End
    .balign 4, 0
_0090:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0098:
    WalkNormalWest
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_P01R0104_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BOAT_ARRIVED, _0144
    Message msg_0258_P01R0104_00000
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00EF
    ApplyMovement obj_P01R0104_seaman_2, _0150
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0180
    GoTo _0126
_00EF:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0114
    ApplyMovement obj_P01R0104_seaman_2, _0160
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0190
    GoTo _0126
_0114:
    ApplyMovement obj_P01R0104_seaman_2, _0170
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _01A0
_0126:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    @ HGSS: ScrCmd_723 1, 0, 307, 24, 19
    ReleaseAll
    End
_0144:
    Message msg_0258_P01R0104_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0150:
    FaceWest
    WalkNormalWest
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0160:
    FaceEast
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0170:
    FaceEast
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0180:
    WalkNormalWest
    FaceNorth
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0190:
    WalkNormalEast
    FaceNorth
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_01A0:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
