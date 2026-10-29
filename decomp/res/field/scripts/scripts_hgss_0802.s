#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0507.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_T07R0207_000
    ScriptEntryEnd
scr_seq_T07R0207_000:
    LockAll
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0058
    CompareVar VAR_RESULT, 1
    GoToIf 1, _002A
    End
_002A:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0170
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _017C
    WaitMovement
    GoTo _0062
_0058:
    ApplyMovement LOCALID_PLAYER, _0170
    WaitMovement
_0062:
    @ HGSS: GetDynamicWarpFloorNo VAR_ELEVATOR_LAST_FLOOR
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0088
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0098
    End
_0088:
    @ HGSS: BufferDeptStoreFloorNo 0, 2
    Call _00A9
    GoTo _00B3
_0098:
    BufferNumber 0, 0
    Call _00A9
    GoTo _00EE
_00A9:
    @ HGSS: ElevatorCurFloorBox 20, 1, VAR_ELEVATOR_LAST_FLOOR, VAR_ELEVATOR_LAST_FLOOR
    Return
_00B3:
    Message msg_0507_T07R0207_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0150
    Message msg_0507_T07R0207_00003
    CloseMessage
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    @ HGSS: SetDynamicWarp MAP_CELADON_CONDOMINIUMS_ROOF, 2, 5, 3, 1
    SetVarFromValue VAR_0x8004, 0
    GoTo _0129
_00EE:
    Message msg_0507_T07R0207_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0150
    Message msg_0507_T07R0207_00004
    CloseMessage
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    @ HGSS: SetDynamicWarp MAP_CELADON_CONDOMINIUMS_2F, 1, 5, 3, 1
    SetVarFromValue VAR_0x8004, 1
    GoTo _0129
_0129:
    WaitSE SE_CONFIRM_sseq_3
    @ HGSS: ElevatorAnim VAR_SPECIAL_x8004, 2
    @ HGSS: GetDynamicWarpFloorNo VAR_ELEVATOR_LAST_FLOOR
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _014D
    Message msg_0507_T07R0207_00006
    GoTo _0150
_014D:
    Message msg_0507_T07R0207_00005
_0150:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    WaitTime 1, VAR_RESULT
    Message msg_0507_T07R0207_00002
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4125, 1
    ReleaseAll
    End
    .balign 4, 0
_0170:
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_017C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
