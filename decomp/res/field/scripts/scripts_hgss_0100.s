#include "macros/scrcmd.inc"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_D39R0102_000
    ScriptEntry scr_seq_D39R0102_001
    ScriptEntry scr_seq_D39R0102_002
    ScriptEntry scr_seq_D39R0102_003
    ScriptEntry scr_seq_D39R0102_004
    ScriptEntryEnd
scr_seq_D39R0102_000:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 12
    SetVarFromValue VAR_MAP_LOCAL_0x01, 12
    GoTo _0063
scr_seq_D39R0102_001:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 10
    SetVarFromValue VAR_MAP_LOCAL_0x01, 21
    GoTo _0063
scr_seq_D39R0102_002:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 20
    SetVarFromValue VAR_MAP_LOCAL_0x01, 10
    GoTo _0063
scr_seq_D39R0102_003:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 21
    SetVarFromValue VAR_MAP_LOCAL_0x01, 23
    GoTo _0063
scr_seq_D39R0102_004:
    BufferPlayerName 0
    End
_0063:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40AB, 1
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0094
    ApplyMovement LOCALID_PLAYER, _0146
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0150
    GoTo _00B7
_0094:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00E5
    ApplyMovement LOCALID_PLAYER, _015E
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0168
    GoTo _00B7
_00B7:
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ICE_PATH_B2F, VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_00E5:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0108
    ApplyMovement LOCALID_PLAYER, _0176
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0180
    GoTo _00B7
_0108:
    ApplyMovement LOCALID_PLAYER, _018E
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0198
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ICE_PATH_B2F, VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0146:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0150:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_015E:
    WalkOnSpotFasterSouth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0168:
    Delay4 3
    WalkFasterSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_0176:
    WalkOnSpotFasterWest 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0180:
    Delay4 3
    WalkFasterWest
    SetInvisible
    EndMovement
    .balign 4, 0
_018E:
    WalkOnSpotFasterEast 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0198:
    Delay4 3
    WalkFasterEast
    SetInvisible
    EndMovement
    .balign 4, 0
