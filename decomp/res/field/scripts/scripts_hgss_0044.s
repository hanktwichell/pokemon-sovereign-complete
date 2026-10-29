#include "macros/scrcmd.inc"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_D24R0207_000
    ScriptEntry scr_seq_D24R0207_001
    ScriptEntry scr_seq_D24R0207_002
    ScriptEntryEnd
scr_seq_D24R0207_000:
    ApplyMovement LOCALID_PLAYER, _0068
    @ HGSS: ScrCmd_374 obj_player
    WaitMovement
    CompleteScreenShake 0, 1, 1, 8
    SetVarFromValue VAR_HGSS_UNK_40D5, 0
    CompareVar VAR_HGSS_UNK_40EF, 1
    GoToIf 1, _004D
    SetVarFromValue VAR_HGSS_UNK_40EF, 1
    AddVar VAR_HGSS_UNK_40F1, 1
_004D:
    End
scr_seq_D24R0207_001:
    CompareVar VAR_HGSS_UNK_40D5, 1
    GoToIf 5, _0064
    ShowObject LOCALID_PLAYER
_0064:
    End
    .balign 4, 0
_0068:
    WarpIn
    EndMovement
scr_seq_D24R0207_002:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    SetFlag FLAG_HGSS_UNK_111
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _009E
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0103
    End
_009E:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00BD
    ApplyMovement LOCALID_PLAYER, _021C
    GoTo _00FB
_00BD:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00D8
    ApplyMovement LOCALID_PLAYER, _0238
    GoTo _00FB
_00D8:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _00F3
    ApplyMovement LOCALID_PLAYER, _0254
    GoTo _00FB
_00F3:
    ApplyMovement LOCALID_PLAYER, _0270
_00FB:
    WaitMovement
    GoTo _0182
_0103:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _012A
    ApplyMovement LOCALID_PLAYER, _021C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0228
    GoTo _0180
_012A:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _014D
    ApplyMovement LOCALID_PLAYER, _0238
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0244
    GoTo _0180
_014D:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0170
    ApplyMovement LOCALID_PLAYER, _0254
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0260
    GoTo _0180
_0170:
    ApplyMovement LOCALID_PLAYER, _0270
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _027C
_0180:
    WaitMovement
_0182:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _01C8
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _01F2
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 5, 42, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01C4:
    ReleaseAll
    End
_01C8:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 5, 42, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01C4
_01F2:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 5, 42, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01C4
    .balign 4, 0
_021C:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0228:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_0238:
    WalkOnSpotFasterSouth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0244:
    Delay4 3
    WalkFasterSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_0254:
    WalkOnSpotFasterWest 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0260:
    Delay4 3
    WalkFasterWest
    SetInvisible
    EndMovement
    .balign 4, 0
_0270:
    WalkOnSpotFasterEast 4
    SetInvisible
    EndMovement
    .balign 4, 0
_027C:
    Delay4 3
    WalkFasterEast
    SetInvisible
    EndMovement
    .balign 4, 0
