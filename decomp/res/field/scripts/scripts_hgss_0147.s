#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0212.h"

#define obj_HIROBA_wifisf 0

    ScriptEntry scr_seq_HIROBA_000
    ScriptEntryEnd
scr_seq_HIROBA_000:
    LockAll
    @ HGSS: Random VAR_SPECIAL_x8000, 5
    SetVar VAR_0x8008, VAR_0x8000
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0059
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0073
    CompareVar VAR_0x8008, 2
    GoToIf 1, _008D
    CompareVar VAR_0x8008, 3
    GoToIf 1, _00A7
    CompareVar VAR_0x8008, 4
    GoToIf 1, _00C1
    End
_0059:
    ApplyMovement LOCALID_PLAYER, _014C
    ApplyMovement obj_HIROBA_wifisf, _01F4
    WaitMovement
    GoTo _00DB
    End
_0073:
    ApplyMovement LOCALID_PLAYER, _0158
    ApplyMovement obj_HIROBA_wifisf, _0204
    WaitMovement
    GoTo _00DB
    End
_008D:
    ApplyMovement LOCALID_PLAYER, _0164
    ApplyMovement obj_HIROBA_wifisf, _0214
    WaitMovement
    GoTo _00DB
    End
_00A7:
    ApplyMovement LOCALID_PLAYER, _0170
    ApplyMovement obj_HIROBA_wifisf, _0224
    WaitMovement
    GoTo _00DB
    End
_00C1:
    ApplyMovement LOCALID_PLAYER, _017C
    ApplyMovement obj_HIROBA_wifisf, _0234
    WaitMovement
    GoTo _00DB
    End
_00DB:
    Message msg_0212_HIROBA_00000
    WaitABPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _0188
    ApplyMovement obj_HIROBA_wifisf, _0244
    WaitMovement
    PlaySE SEQ_SE_DP_TELE2_sseq
    ApplyMovement LOCALID_PLAYER, _01EC
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    Warp VAR_HGSS_UNK_4056, 5, 2, DIR_SOUTH
    @ HGSS: ScrCmd_436
    @ HGSS: ScrCmd_166 VAR_SPECIAL_RESULT
    SetVarFromVar VAR_0x8004, VAR_RESULT
    @ HGSS: ScrCmd_663 VAR_SPECIAL_x8004
    ReturnToField
    SetVarFromValue VAR_HGSS_UNK_4137, 1
    ShowObject LOCALID_PLAYER
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_014C:
    WalkNormalNorth 7
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_0158:
    WalkNormalNorth 7
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0164:
    WalkNormalNorth 7
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_0170:
    WalkNormalNorth 7
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_017C:
    WalkNormalNorth 7
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0188:
    WalkNormalNorth
    FaceWest
    Delay2
    FaceSouth
    Delay2
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    FaceSouth
    Delay2
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    FaceSouth
    Delay2
    FaceEast
    Delay2
    FaceNorth
    EndMovement
    .balign 4, 0
_01EC:
    WarpOut
    EndMovement
    .balign 4, 0
_01F4:
    WalkNormalNorth 6
    WalkNormalWest 12
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0204:
    WalkNormalNorth 6
    WalkNormalWest 10
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0214:
    WalkNormalNorth 6
    WalkNormalWest 8
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0224:
    WalkNormalNorth 6
    WalkNormalWest 6
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0234:
    WalkNormalNorth 6
    WalkNormalWest 4
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0244:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
