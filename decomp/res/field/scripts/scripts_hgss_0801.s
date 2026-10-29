#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0506.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_T07R0206_000
    ScriptEntryEnd
scr_seq_T07R0206_000:
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
    ApplyMovement LOCALID_PLAYER, _0340
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _034C
    WaitMovement
    GoTo _0062
_0058:
    ApplyMovement LOCALID_PLAYER, _0340
    WaitMovement
_0062:
    @ HGSS: GetDynamicWarpFloorNo VAR_ELEVATOR_LAST_FLOOR
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0095
    CompareVar VAR_0x8008, 2
    GoToIf 1, _00A0
    CompareVar VAR_0x8008, 0
    GoToIf 1, _00AA
    End
_0095:
    BufferNumber 0, 0
    GoTo _00B4
_00A0:
    @ HGSS: BufferDeptStoreFloorNo 0, 3
    GoTo _00B4
_00AA:
    @ HGSS: BufferDeptStoreFloorNo 0, 1
    GoTo _00B4
_00B4:
    @ HGSS: ElevatorCurFloorBox 20, 1, VAR_ELEVATOR_LAST_FLOOR, VAR_ELEVATOR_LAST_FLOOR
    Message msg_0506_T07R0206_00000
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 116, 0
    AddMenuEntry 118, 1
    AddMenuEntry 125, 2
    AddMenuEntry 126, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0120
    CompareVar VAR_0x8008, 1
    GoToIf 1, _019B
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0216
    GoTo _0322
_0120:
    WaitTime 1, VAR_RESULT
    @ HGSS: GetDynamicWarpFloorNo VAR_ELEVATOR_LAST_FLOOR
    @ HGSS: SetDynamicWarp MAP_CELADON_CONDOMINIUMS_1F, 2, 5, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 1, _0305
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    CallIf 2, _029C
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    CallIf 0, _0291
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _0176
    SetVarFromValue VAR_0x8005, 2
    GoTo _0189
_0176:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _0189
    SetVarFromValue VAR_0x8005, 3
_0189:
    Call _02A7
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoTo _02BB
_019B:
    WaitTime 1, VAR_RESULT
    @ HGSS: GetDynamicWarpFloorNo VAR_ELEVATOR_LAST_FLOOR
    @ HGSS: SetDynamicWarp MAP_CELADON_CONDOMINIUMS_3F, 0, 5, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 1, _0305
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    CallIf 2, _029C
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    CallIf 0, _0291
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _01F1
    SetVarFromValue VAR_0x8005, 2
    GoTo _0204
_01F1:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _0204
    SetVarFromValue VAR_0x8005, 1
_0204:
    Call _02A7
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoTo _02BB
_0216:
    WaitTime 1, VAR_RESULT
    @ HGSS: GetDynamicWarpFloorNo VAR_ELEVATOR_LAST_FLOOR
    @ HGSS: SetDynamicWarp MAP_CELADON_CONDOMINIUMS_ROOF, 1, 5, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 1, _0305
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    CallIf 2, _029C
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    CallIf 0, _0291
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _026C
    SetVarFromValue VAR_0x8005, 3
    GoTo _027F
_026C:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _027F
    SetVarFromValue VAR_0x8005, 1
_027F:
    Call _02A7
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoTo _02BB
_0291:
    Message msg_0506_T07R0206_00002
    SetVarFromValue VAR_0x8004, 0
    Return
_029C:
    Message msg_0506_T07R0206_00003
    SetVarFromValue VAR_0x8004, 1
    Return
_02A7:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    CloseMessage
    WaitSE SE_CONFIRM_sseq_3
    @ HGSS: ElevatorAnim VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    Return
_02BB:
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 3
    GoToIf 1, _02EA
    CompareVar VAR_0x8008, 2
    GoToIf 1, _02F3
    CompareVar VAR_0x8008, 0
    GoToIf 1, _02FC
    End
_02EA:
    Message msg_0506_T07R0206_00007
    GoTo _032E
_02F3:
    Message msg_0506_T07R0206_00006
    GoTo _032E
_02FC:
    Message msg_0506_T07R0206_00005
    GoTo _032E
_0305:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    WaitTime 1, VAR_RESULT
    Message msg_0506_T07R0206_00004
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4125, 1
    ReleaseAll
    End
_0322:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    WaitTime 1, VAR_RESULT
_032E:
    Message msg_0506_T07R0206_00001
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4125, 1
    ReleaseAll
    End
    .balign 4, 0
_0340:
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_034C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
