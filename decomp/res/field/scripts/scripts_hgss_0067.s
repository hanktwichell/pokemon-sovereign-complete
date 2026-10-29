#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0095.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_D27R0108_000
    ScriptEntryEnd
scr_seq_D27R0108_000:
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
    ApplyMovement LOCALID_PLAYER, _00F4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0100
    WaitMovement
    GoTo _0062
_0058:
    ApplyMovement LOCALID_PLAYER, _00F4
    WaitMovement
_0062:
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0088
    CompareVar VAR_0x8008, 1
    GoToIf 1, _00A5
    End
_0088:
    Message msg_0095_D27R0108_00000
    CloseMessage
    SetSpecialLocation MAP_HEADER_HGSS_OLIVINE_LIGHTHOUSE_LIGHT_ROOM, 1, 5, 3, 1
    SetVarFromValue VAR_0x8004, 0
    GoTo _00C2
_00A5:
    Message msg_0095_D27R0108_00001
    CloseMessage
    SetSpecialLocation MAP_HEADER_HGSS_OLIVINE_LIGHTHOUSE_1F, 1, 5, 3, 1
    SetVarFromValue VAR_0x8004, 1
    GoTo _00C2
_00C2:
    WaitSE SE_CONFIRM_sseq_3
    PlayElevatorAnimation VAR_0x8004, 5
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _00E2
    Message msg_0095_D27R0108_00002
    GoTo _00E5
_00E2:
    Message msg_0095_D27R0108_00003
_00E5:
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4125, 1
    ReleaseAll
    End
    .balign 4, 0
_00F4:
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0100:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
