#include "macros/scrcmd.inc"

#define obj_D31R0202_var_11 0

    ScriptEntry scr_seq_D31R0202_000
    ScriptEntry scr_seq_D31R0202_001
    ScriptEntry scr_seq_D31R0202_002
    ScriptEntry scr_seq_D31R0202_003
    ScriptEntryEnd
scr_seq_D31R0202_000:
    CompareVar VAR_HGSS_UNK_414D, 0
    CallIf 5, _008A
    @ HGSS: ScrCmd_412 43, 0, VAR_TEMP_x400A
    Call _008E
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    CallIf 1, _009E
    CompareVar VAR_MAP_LOCAL_0x0A, 3
    CallIf 1, _009E
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    CallIf 1, _008E
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    CallIf 1, _008E
    CompareVar VAR_MAP_LOCAL_0x0A, 4
    CallIf 1, _0096
    CompareVar VAR_MAP_LOCAL_0x0A, 5
    CallIf 1, _0096
    CompareVar VAR_MAP_LOCAL_0x0A, 6
    CallIf 1, _0096
    End
_008A:
    @ HGSS: ScrCmd_520
    Return
_008E:
    SetVarFromValue VAR_OBJ_GFX_ID_A, 282
    Return
_0096:
    SetVarFromValue VAR_OBJ_GFX_ID_A, 286
    Return
_009E:
    SetVarFromValue VAR_OBJ_GFX_ID_A, 283
    Return
_00A6:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_412 43, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0200
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0200
    WaitForTransition
    @ HGSS: ScrCmd_627 5
    ReturnToField
    Warp MAP_HEADER_HGSS_BATTLE_TOWER, 15, 6, DIR_NORTH
    End
_00E9:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    WaitForTransition
    @ HGSS: ScrCmd_627 6
    ReturnToField
    Warp MAP_HEADER_HGSS_BATTLE_TOWER, 11, 6, DIR_NORTH
    End
_010A:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BATTLE_TOWER_PARTNER_ROOM, 8, 2, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0132:
    Call _018E
    PlayElevatorAnimation VAR_MAP_LOCAL_0x00, 3
    Call _019A
    Return
scr_seq_D31R0202_001:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    Call _0132
    GoTo _00A6
    End
scr_seq_D31R0202_002:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    Call _0132
    GoTo _00E9
    End
scr_seq_D31R0202_003:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    Call _0132
    GoTo _010A
    End
_018E:
    ApplyMovement LOCALID_PLAYER, _01C4
    WaitMovement
    Return
_019A:
    ApplyMovement obj_D31R0202_var_11, _01D0
    ApplyMovement LOCALID_PLAYER, _01EC
    WaitMovement
    Return
    .balign 4, 0
    WalkNormalNorth 2
    FaceEast
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
_01C4:
    WalkNormalNorth 2
    FaceSouth
    EndMovement
    .balign 4, 0
_01D0:
    WalkNormalSouth
    FaceWest
    WalkNormalWest
    FaceSouth
    WalkNormalSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_01EC:
    Delay8 2
    Delay2
    WalkNormalSouth 2
    SetInvisible
    EndMovement
_0200:
    WaitForTransition
    @ HGSS: ScrCmd_627 5
    ReturnToField
    Warp MAP_HEADER_HGSS_BATTLE_TOWER, 19, 6, DIR_NORTH
    End
    .balign 4, 0
