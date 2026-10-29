#include "macros/scrcmd.inc"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_D39R0102_000
    ScriptEntry scr_seq_D39R0102_001
    ScriptEntry scr_seq_D39R0102_002
    ScriptEntry scr_seq_D39R0102_003
    ScriptEntryEnd
scr_seq_D39R0102_000:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 12
    SetVarFromValue VAR_MAP_LOCAL_0x01, 12
    GoTo _0062
    End
scr_seq_D39R0102_001:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 10
    SetVarFromValue VAR_MAP_LOCAL_0x01, 21
    GoTo _0062
    End
scr_seq_D39R0102_002:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 20
    SetVarFromValue VAR_MAP_LOCAL_0x01, 10
    GoTo _0062
    End
scr_seq_D39R0102_003:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 21
    SetVarFromValue VAR_MAP_LOCAL_0x01, 23
    GoTo _0062
    End
_0062:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40AB, 1
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0093
    ApplyMovement LOCALID_PLAYER, _0118
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0124
    GoTo _00E9
_0093:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00B6
    ApplyMovement LOCALID_PLAYER, _0134
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0140
    GoTo _00E9
_00B6:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _00D9
    ApplyMovement LOCALID_PLAYER, _0150
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _015C
    GoTo _00E9
_00D9:
    ApplyMovement LOCALID_PLAYER, _016C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0178
_00E9:
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ICE_PATH_B2F, VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0118:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0124:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_0134:
    WalkOnSpotFasterSouth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0140:
    Delay4 3
    WalkFasterSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_0150:
    WalkOnSpotFasterWest 4
    SetInvisible
    EndMovement
    .balign 4, 0
_015C:
    Delay4 3
    WalkFasterWest
    SetInvisible
    EndMovement
    .balign 4, 0
_016C:
    WalkOnSpotFasterEast 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0178:
    Delay4 3
    WalkFasterEast
    SetInvisible
    EndMovement
    .balign 4, 0
