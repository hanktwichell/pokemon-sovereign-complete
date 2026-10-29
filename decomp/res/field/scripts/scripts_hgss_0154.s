#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0257.h"

#define obj_P01R0103_seaman_2 0

    ScriptEntry scr_seq_P01R0103_000
    ScriptEntry scr_seq_P01R0103_001
    ScriptEntry scr_seq_P01R0103_002
    ScriptEntryEnd
scr_seq_P01R0103_001:
    @ HGSS: ScrCmd_445 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 387
    GoToIf 1, _0021
    End
_0021:
    @ HGSS: SetObjectFacing obj_P01R0103_seaman_2, DIR_SOUTH
    End
scr_seq_P01R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _014D
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _0158
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _006C
    GoTo _00EF
_0066:
    GoTo _00EF
_006C:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0085
    GoTo _0142
_007F:
    GoTo _00EF
_0085:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _009E
    GoTo _0142
_0098:
    GoTo _00EF
_009E:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _00B7
    GoTo _00EF
_00B1:
    GoTo _00EF
_00B7:
    CompareVar VAR_RESULT, 4
    GoToIf 5, _00D0
    GoTo _0142
_00CA:
    GoTo _00EF
_00D0:
    CompareVar VAR_RESULT, 5
    GoToIf 5, _00E9
    GoTo _0142
_00E3:
    GoTo _00EF
_00E9:
    GoTo _0142
_00EF:
    Message msg_0257_P01R0103_00000
    CloseMessage
    ApplyMovement obj_P01R0103_seaman_2, _0190
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _01B0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    SetVarFromValue VAR_HGSS_BOAT_DIRECTION, 2
    SetVarFromValue VAR_HGSS_UNK_40DC, 0
    ClearFlag FLAG_HGSS_BOAT_ARRIVED
    SetFlag FLAG_HGSS_UNK_22A
    ClearFlag FLAG_HGSS_UNK_22C
    SetFlag FLAG_HGSS_UNK_22B
    ReleaseAll
    End
_0142:
    Message msg_0257_P01R0103_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_014D:
    Message msg_0257_P01R0103_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0158:
    ApplyMovement obj_P01R0103_seaman_2, _01B8
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _01D8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_P01R0103_seaman_2, _01E4
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0190:
    LockDir
    WalkNormalSouth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_01B0:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_01B8:
    LockDir
    WalkNormalNorth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_01D8:
    Delay8
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_01E4:
    WalkNormalWest
    FaceSouth 2
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_P01R0103_002:
    NPCMessage msg_0257_P01R0103_00003
    End
    .balign 4, 0
