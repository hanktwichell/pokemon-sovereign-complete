#include "macros/scrcmd.inc"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_R36R0201_000
    ScriptEntry scr_seq_R36R0201_001
    ScriptEntry scr_seq_R36R0201_002
    ScriptEntryEnd
scr_seq_R36R0201_000:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_HGSS_UNK_4118, 1
    GoToIf 5, _002D
    ClearFlag FLAG_HGSS_UNK_1C4
    SetFlag FLAG_HGSS_UNK_1C3
    GoTo _0086
_002D:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0048
    ClearFlag FLAG_HGSS_UNK_1C4
    SetFlag FLAG_HGSS_UNK_1C3
    GoTo _0086
_0048:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0063
    ClearFlag FLAG_HGSS_UNK_1C4
    SetFlag FLAG_HGSS_UNK_1C3
    GoTo _0086
_0063:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _007E
    ClearFlag FLAG_HGSS_UNK_1C4
    SetFlag FLAG_HGSS_UNK_1C3
    GoTo _0086
_007E:
    ClearFlag FLAG_HGSS_UNK_1C3
    SetFlag FLAG_HGSS_UNK_1C4
_0086:
    End
scr_seq_R36R0201_002:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0120
    WaitMovement
    CallCommonScript 11006
    CompareVar VAR_HGSS_UNK_4118, 1
    GoToIf 5, _011A
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0128
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NATIONAL_PARK_BUG_CATCHING_CONTEST, 75, 39, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockObject LOCALID_COMPLETE_FOLLOWER
    CompleteFollowerIsTooTall VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _010A
    CompleteFollowerReturn
    GoTo _010C
_010A:
    CompleteFollowerReturn
_010C:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0130
    WaitMovement
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
_011A:
    ReleaseAll
    End
    .balign 4, 0
_0120:
    FaceNorth
    EndMovement
    .balign 4, 0
_0128:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0130:
    FaceWest
    EndMovement
scr_seq_R36R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CallCommonScript 11005
    CompareVar VAR_HGSS_UNK_4118, 1
    GoToIf 5, _0231
    GoToIfSet FLAG_HGSS_UNK_1C4, _01BA
    GetPlayerDir VAR_RESULT
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0185
    ApplyMovement LOCALID_PLAYER, _0238
    GoTo _01A8
_0185:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _01A0
    ApplyMovement LOCALID_PLAYER, _0240
    GoTo _01A8
_01A0:
    ApplyMovement LOCALID_PLAYER, _024C
_01A8:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _01DC
_01BA:
    GetPlayerDir VAR_RESULT
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _025C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
_01DC:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NATIONAL_PARK_BUG_CATCHING_CONTEST, 75, 39, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockObject LOCALID_COMPLETE_FOLLOWER
    CompleteFollowerIsTooTall VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0221
    CompleteFollowerReturn
    GoTo _0223
_0221:
    CompleteFollowerReturn
_0223:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0130
    WaitMovement
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
_0231:
    ReleaseAll
    End
    .balign 4, 0
_0238:
    FaceWest
    EndMovement
    .balign 4, 0
_0240:
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_024C:
    WalkNormalEast
    WalkNormalSouth 2
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_025C:
    WalkNormalSouth
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
