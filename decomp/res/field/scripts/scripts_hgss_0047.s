#include "macros/scrcmd.inc"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_D24R0210_000
    ScriptEntry scr_seq_D24R0210_001
    ScriptEntry scr_seq_D24R0210_002
    ScriptEntryEnd
scr_seq_D24R0210_000:
    ApplyMovement LOCALID_PLAYER, _0064
    @ HGSS: ScrCmd_374 obj_player
    WaitMovement
    @ HGSS: ScreenShake 0, 1, 1, 8
    SetVarFromValue VAR_HGSS_UNK_40D1, 0
    CompareVar VAR_HGSS_UNK_40EE, 1
    GoToIf 1, _004D
    SetVarFromValue VAR_HGSS_UNK_40EE, 1
    AddVar VAR_HGSS_UNK_40F1, 1
_004D:
    End
scr_seq_D24R0210_001:
    CompareVar VAR_HGSS_UNK_40D1, 1
    GoToIf 5, _0060
    ShowObject LOCALID_PLAYER
_0060:
    End
    .balign 4, 0
_0064:
    WarpIn
    EndMovement
scr_seq_D24R0210_002:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    SetFlag FLAG_HGSS_UNK_111
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _009A
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00FF
    End
_009A:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00B9
    ApplyMovement LOCALID_PLAYER, _0218
    GoTo _00F7
_00B9:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00D4
    ApplyMovement LOCALID_PLAYER, _0234
    GoTo _00F7
_00D4:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _00EF
    ApplyMovement LOCALID_PLAYER, _0250
    GoTo _00F7
_00EF:
    ApplyMovement LOCALID_PLAYER, _026C
_00F7:
    WaitMovement
    GoTo _017E
_00FF:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0126
    ApplyMovement LOCALID_PLAYER, _0218
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0224
    GoTo _017C
_0126:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0149
    ApplyMovement LOCALID_PLAYER, _0234
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0240
    GoTo _017C
_0149:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _016C
    ApplyMovement LOCALID_PLAYER, _0250
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _025C
    GoTo _017C
_016C:
    ApplyMovement LOCALID_PLAYER, _026C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0278
_017C:
    WaitMovement
_017E:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _01C4
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _01EE
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 25, 42, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01C0:
    ReleaseAll
    End
_01C4:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 25, 42, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01C0
_01EE:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 25, 42, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01C0
    .balign 4, 0
_0218:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0224:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_0234:
    WalkOnSpotFasterSouth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0240:
    Delay4 3
    WalkFasterSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_0250:
    WalkOnSpotFasterWest 4
    SetInvisible
    EndMovement
    .balign 4, 0
_025C:
    Delay4 3
    WalkFasterWest
    SetInvisible
    EndMovement
    .balign 4, 0
_026C:
    WalkOnSpotFasterEast 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0278:
    Delay4 3
    WalkFasterEast
    SetInvisible
    EndMovement
    .balign 4, 0
