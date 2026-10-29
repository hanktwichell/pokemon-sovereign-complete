#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0539.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_T11R0703_000
    ScriptEntryEnd
scr_seq_T11R0703_000:
    LockAll
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 479
    GoToIf 5, _018C
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0154
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0170
    WaitMovement
    PlayCry SPECIES_ROTOM, 0
    WaitCry
    Message msg_0539_T11R0703_00000
    CloseMessage
    GoTo _0066
    ApplyMovement LOCALID_PLAYER, _0154
    WaitMovement
_0066:
    @ HGSS: GetDynamicWarpFloorNo VAR_ELEVATOR_LAST_FLOOR
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 1
    GoToIf 1, _008C
    CompareVar VAR_0x8008, 0
    GoToIf 1, _00C0
    End
_008C:
    SetVarFromValue VAR_0x8004, 0
    Call _00F4
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFFRON_SILPH_CO_HQ, 3, 3, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_00C0:
    SetVarFromValue VAR_0x8004, 1
    Call _00F4
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFFRON_SILPH_CO_ROTOM_ROOM, 7, 3, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_00F4:
    WaitSE SE_CONFIRM_sseq_3
    @ HGSS: ElevatorAnim VAR_SPECIAL_x8004, 1
_00FE:
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0142
    CompareVar VAR_RESULT, 1
    GoToIf 1, _011E
    End
_011E:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0180
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _014C
_0142:
    ApplyMovement LOCALID_PLAYER, _0180
    WaitMovement
_014C:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    Return
    .balign 4, 0
_0154:
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0160:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0170:
    FaceSouth
    WalkNormalSouth
    JumpOnSpotSlowSouth 3
    EndMovement
    .balign 4, 0
_0180:
    WalkNormalSouth 2
    WalkOnSpotNormalSouth
    EndMovement
_018C:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0154
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01C5
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0160
    WaitMovement
_01C5:
    Message msg_0539_T11R0703_00001
    CloseMessage
    @ HGSS: GetDynamicWarpFloorNo VAR_ELEVATOR_LAST_FLOOR
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 1
    GoToIf 1, _01F0
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0224
    End
_01F0:
    SetVarFromValue VAR_0x8004, 0
    Call _00FE
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFFRON_SILPH_CO_ROTOM_ROOM, 7, 3, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0224:
    SetVarFromValue VAR_0x8004, 1
    Call _00FE
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFFRON_SILPH_CO_HQ, 3, 3, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
