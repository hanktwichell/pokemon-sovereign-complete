#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0115.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D36R0101_tsure_poke_static_farfetchd 0
#define obj_D36R0101_gsbigman 1
#define obj_D36R0101_tsure_poke_static_farfetchd_2 2
#define obj_D36R0101_gsboy1 3
#define obj_D36R0101_gsfighter 4
#define obj_D36R0101_dancer 12
#define obj_D36R0101_gsmiddleman1 13
#define obj_D36R0101_tsure_poke_static_pichu_spiky 14
#define obj_D36R0101_gsoldman1 15
#define obj_D36R0101_var_1 16
#define obj_D36R0101_tsure_poke_static_marill 17
#define STICKS_ACTIVE 1
#define STICKS_INACTIVE 2

#define FARFETCHD_X_COORD                   VAR_MAP_LOCAL_0x00
#define FARFETCHD_Z_COORD                   VAR_MAP_LOCAL_0x01
#define FARFETCHD1_BLIND_SPOT               VAR_MAP_LOCAL_0x02
#define FARFETCHD2_BLIND_SPOT               VAR_MAP_LOCAL_0x03
#define FARFETCHD1_BOTTOM_RIGHT_FACING_UP   VAR_MAP_LOCAL_0x04
    ScriptEntry scr_seq_D36R0101_000
    ScriptEntry scr_seq_D36R0101_farfetchd1
    ScriptEntry scr_seq_D36R0101_002
    ScriptEntry scr_seq_D36R0101_farfetchd1_sticks1
    ScriptEntry scr_seq_D36R0101_farfetchd1_sticks2
    ScriptEntry scr_seq_D36R0101_farfetchd2
    ScriptEntry scr_seq_D36R0101_farfetchd2_sticks1
    ScriptEntry scr_seq_D36R0101_farfetchd2_sticks2
    ScriptEntry scr_seq_D36R0101_farfetchd2_sticks3
    ScriptEntry scr_seq_D36R0101_farfetchd2_sticks4
    ScriptEntry scr_seq_D36R0101_010
    ScriptEntry scr_seq_D36R0101_011
    ScriptEntry scr_seq_D36R0101_012
    ScriptEntry scr_seq_D36R0101_013
    ScriptEntry scr_seq_D36R0101_014
    ScriptEntry scr_seq_D36R0101_015
    ScriptEntry scr_seq_D36R0101_016
    ScriptEntry scr_seq_D36R0101_017
    ScriptEntry scr_seq_D36R0101_018
    ScriptEntry scr_seq_D36R0101_019
    ScriptEntry scr_seq_D36R0101_020
    ScriptEntry scr_seq_D36R0101_021
    ScriptEntry scr_seq_D36R0101_022
    ScriptEntryEnd
scr_seq_D36R0101_000:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    GoToIfUnset FLAG_HGSS_UNK_189, _0077
    ClearFlag FLAG_HGSS_UNK_189
    GoTo _00C3
_0077:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _00B5
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _00BF
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _00BF
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _00BF
_00B5:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _00C3
_00BF:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
_00C3:
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _00D0
    End
_00D0:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_ACTIVE
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    SetVarFromValue FARFETCHD1_BLIND_SPOT, FALSE
    SetVarFromValue FARFETCHD2_BLIND_SPOT, FALSE
    SetVarFromValue FARFETCHD1_BOTTOM_RIGHT_FACING_UP, FALSE
    GoToIfSet FLAG_HGSS_FOUND_FIRST_FARFETCHD, _0124
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _0145
    End
_0124:
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _0137
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_INACTIVE
    End
_0137:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
    End
_0145:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
    End
scr_seq_D36R0101_021:
    CompareVar VAR_HGSS_UNK_412B, 1
    CallIf 1, _016F
    CompareVar VAR_HGSS_UNK_40FE, 4
    CallIf 1, _0189
    End
_016F:
    SetPosition obj_D36R0101_gsoldman1, 15, 0, 58, DIR_SOUTH
    SetPosition obj_D36R0101_tsure_poke_static_pichu_spiky, 15, 0, 59, DIR_EAST
    Return
_0189:
    SetPosition obj_D36R0101_var_1, 15, 0, 58, DIR_SOUTH
    SetPosition obj_D36R0101_tsure_poke_static_marill, 11, 0, 58, DIR_EAST
    Return
scr_seq_D36R0101_farfetchd1:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_X_COORD, 25
    GoToIf 5, _01C4
    GoTo _farfetchd1_left
_01BE:
    GoTo _farfetchd1_left
_01C4:
    CompareVar FARFETCHD_X_COORD, 32
    GoToIf 5, _farfetchd1_left
    GoTo _farfetchd1_right
_farfetchd1_left:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 52
    GoToIf 5, _01F8
    GoTo _farfetchd1_top_left
_01F2:
    GoTo _farfetchd1_right
_01F8:
    CompareVar FARFETCHD_Z_COORD, 62
    GoToIf 5, _farfetchd1_right
    GoTo _farfetchd1_bottom_left
_farfetchd1_right:
    SetVarFromValue FARFETCHD1_BLIND_SPOT, FALSE
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 52
    GoToIf 5, _0232
    GoTo _farfetchd1_top_right
_022C:
    GoTo _farfetchd1_top_left
_0232:
    CompareVar FARFETCHD_Z_COORD, 62
    GoToIf 5, _farfetchd1_top_left
    GoTo _farfetchd1_bottom_right
_farfetchd1_top_left:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue FARFETCHD1_BLIND_SPOT, FALSE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_NORTH
    GoToIf 5, _0272
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _farfetchd1_run_right
    GoTo _0293
_0272:
    CompareVar VAR_RESULT, DIR_WEST
    GoToIf 5, _0293
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _farfetchd_run_down
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_ACTIVE
_0293:
    WaitMovement
    ReleaseAll
    End
_farfetchd1_bottom_left:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_WEST
    GoToIf 5, _02B6
    GoTo _farfetchd1_bottom_left_flee_up
_02B0:
    GoTo _farfetchd1_bottom_left_flee_up
_02B6:
    CompareVar VAR_RESULT, DIR_SOUTH
    GoToIf 5, _farfetchd1_bottom_left_flee_up
    GoTo _farfetchd1_bottom_left_flee_right
_farfetchd1_bottom_left_flee_up:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_INACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _farfetchd_run_up
    WaitMovement
    GoToIfSet FLAG_HGSS_UNK_126, _02FD
    Message msg_0115_D36R0101_00036
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_126
_02FD:
    ReleaseAll
    End
_farfetchd1_bottom_left_flee_right:
    CompareVar FARFETCHD1_BLIND_SPOT, TRUE
    GoToIf 1, _farfetchd1_bottom_left_caught
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_INACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _farfetchd1_run_right
    WaitMovement
    GoToIfSet FLAG_HGSS_UNK_126, _0342
    Message msg_0115_D36R0101_00036
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_126
_0342:
    ReleaseAll
    End
_farfetchd1_bottom_left_caught:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_FARFETCHD, 0
    Message msg_0115_D36R0101_00003
    CloseMessage
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _walk_in_place_face_down
    WaitMovement
    RemoveObject obj_D36R0101_tsure_poke_static_farfetchd
    Message msg_0115_D36R0101_00037
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_INACTIVE
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_1_LOST
    SetFlag FLAG_HGSS_FOUND_FIRST_FARFETCHD
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _1207
    ClearFlag FLAG_HGSS_HIDE_FARFETCHD_1_FOUND
    WaitTime 20, VAR_0x8004
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 15, 65, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 5, VAR_0x8004
    Message msg_0115_D36R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_farfetchd1_top_right:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_EAST
    GoToIf 5, _0403
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _farfetchd_run_down
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_ACTIVE
    SetVarFromValue FARFETCHD1_BOTTOM_RIGHT_FACING_UP, TRUE
    GoTo _0424
_0403:
    CompareVar VAR_RESULT, DIR_NORTH
    GoToIf 5, _0424
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _farfetchd1_run_left
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_INACTIVE
_0424:
    WaitMovement
    ReleaseAll
    End
_farfetchd1_bottom_right:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue FARFETCHD1_BOTTOM_RIGHT_FACING_UP, FALSE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_EAST
    GoToIf 5, _0463
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _farfetchd_run_up
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_INACTIVE
    GoTo _0484
_0463:
    CompareVar VAR_RESULT, DIR_SOUTH
    GoToIf 5, _0484
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _farfetchd1_run_left
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_INACTIVE
_0484:
    WaitMovement
    ReleaseAll
    End
scr_seq_D36R0101_farfetchd1_sticks1:
    LockAll
    CompareVar FARFETCHD1_BOTTOM_RIGHT_FACING_UP, TRUE
    GoToIf 1, _farfetchd1_look_left
    SetVarFromValue FARFETCHD1_BLIND_SPOT, TRUE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_ACTIVE
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_X_COORD, 25
    GoToIf 5, _04CE
    GoTo _sticks1_farfetchd1_left
_04B8:
    GoTo _sticks1_farfetchd1_left
_04CE:
    CompareVar FARFETCHD_X_COORD, 32
    GoToIf 5, _sticks1_farfetchd1_left
    GoTo _sticks1_farfetchd1_right
_sticks1_farfetchd1_left:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 52
    GoToIf 5, _0502
    GoTo _sticks1_farfetchd1_top_left
_04FC:
    GoTo _sticks1_farfetchd1_right
_0502:
    CompareVar FARFETCHD_Z_COORD, 62
    GoToIf 5, _sticks1_farfetchd1_right
    GoTo _sticks1_farfetchd1_bottom_left
_sticks1_farfetchd1_right:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 52
    GoToIf 5, _0536
    GoTo _sticks1_farfetchd1_top_right
_0530:
    GoTo _sticks1_farfetchd1_top_left
_0536:
    CompareVar FARFETCHD_Z_COORD, 62
    GoToIf 5, _sticks1_farfetchd1_top_left
    GoTo _sticks1_farfetchd1_bottom_right
_sticks1_farfetchd1_top_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _exclaim_face_down
    WaitMovement
    ReleaseAll
    End
_sticks1_farfetchd1_bottom_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _exclaim_face_down
    WaitMovement
    GoToIfSet FLAG_HGSS_FARFETCHD_NOTICED_YOU, _skip_farfetchd_noticed_msg
    Message msg_0115_D36R0101_00035
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_FARFETCHD_NOTICED_YOU
_skip_farfetchd_noticed_msg:
    ReleaseAll
    End
_sticks1_farfetchd1_top_right:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _exclaim_face_down
    WaitMovement
    ReleaseAll
    End
_sticks1_farfetchd1_bottom_right:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _exclaim_face_left
    WaitMovement
    ReleaseAll
    End
scr_seq_D36R0101_farfetchd1_sticks2:
    LockAll
    CompareVar FARFETCHD1_BOTTOM_RIGHT_FACING_UP, TRUE
    GoToIf 1, _farfetchd1_look_left
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_INACTIVE
    SetVarFromValue FARFETCHD1_BLIND_SPOT, FALSE
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_X_COORD, 25
    GoToIf 5, _05DB
    GoTo _sticks2_farfetchd1_left
_05D5:
    GoTo _sticks2_farfetchd1_left
_05DB:
    CompareVar FARFETCHD_X_COORD, 32
    GoToIf 5, _sticks2_farfetchd1_left
    GoTo _sticks2_farfetchd1_right
_sticks2_farfetchd1_left:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 52
    GoToIf 5, _060F
    GoTo _sticks2_farfetchd1_top_left
_0609:
    GoTo _sticks2_farfetchd1_right
_060F:
    CompareVar FARFETCHD_Z_COORD, 62
    GoToIf 5, _sticks2_farfetchd1_right
    GoTo _sticks2_farfetchd1_bottom_left
_sticks2_farfetchd1_right:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 52
    GoToIf 5, _0643
    GoTo _sticks2_farfetchd1_top_right
_063D:
    GoTo _sticks2_farfetchd1_top_left
_0643:
    CompareVar FARFETCHD_Z_COORD, 62
    GoToIf 5, _sticks2_farfetchd1_top_left
    GoTo _sticks2_farfetchd1_bottom_right
_sticks2_farfetchd1_top_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _exclaim_face_down
    WaitMovement
    ReleaseAll
    End
_sticks2_farfetchd1_bottom_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _exclaim_face_right
    WaitMovement
    ReleaseAll
    End
_sticks2_farfetchd1_top_right:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _exclaim_face_down
    WaitMovement
    ReleaseAll
    End
_sticks2_farfetchd1_bottom_right:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _exclaim_face_left
    WaitMovement
    ReleaseAll
    End
_farfetchd1_look_left:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_INACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _exclaim_face_left
    WaitMovement
    ReleaseAll
    End
scr_seq_D36R0101_farfetchd2:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_X_COORD, 41
    GoToIf 5, _06C9
    GoTo _farfetchd2_left
_06C3:
    GoTo _farfetchd2_left
_06C9:
    CompareVar FARFETCHD_X_COORD, 49
    GoToIf 5, _farfetchd2_left
    GoTo _farfetchd2_right
_farfetchd2_left:
    SetVarFromValue FARFETCHD2_BLIND_SPOT, FALSE
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0703
    GoTo _farfetchd_top_left
_06FD:
    GoTo _farfetchd2_right
_0703:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _farfetchd2_right
    GoTo _farfetchd2_bottom_left
_farfetchd2_right:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0737
    GoTo _farfetchd2_top_right
_0731:
    GoTo _farfetchd_top_left
_0737:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _farfetchd_top_left
    GoTo _farfetchd2_bottom_right
_farfetchd_top_left:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_NORTH
    GoToIf 5, _farfetchd2_top_left_flee_down
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _farfetchd2_run_right
    WaitMovement
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
    GoTo _07BA
_farfetchd2_top_left_flee_down:
    CompareVar VAR_RESULT, DIR_WEST
    GoToIf 5, _07BA
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _farfetchd_run_down
    WaitMovement
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
_07BA:
    GoToIfSet FLAG_HGSS_UNK_126, _07D0
    Message msg_0115_D36R0101_00036
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_126
_07D0:
    ReleaseAll
    End
_farfetchd2_bottom_left:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_SOUTH
    GoToIf 5, _farfetchd2_bottom_left_flee_up
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _farfetchd2_run_right
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
    GoTo _0840
_farfetchd2_bottom_left_flee_up:
    CompareVar VAR_RESULT, DIR_WEST
    GoToIf 5, _0840
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _farfetchd_run_up
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_ACTIVE
_0840:
    WaitMovement
    ReleaseAll
    End
_farfetchd2_top_right:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_NORTH
    GoToIf 5, _0863
    GoTo _farfetchd2_top_right_flee_left
_085D:
    GoTo _farfetchd2_top_right_flee_left
_0863:
    CompareVar VAR_RESULT, DIR_EAST
    GoToIf 5, _farfetchd2_top_right_flee_left
    GoTo _farfetchd2_top_right_flee_down
_farfetchd2_top_right_flee_left:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _farfetchd2_run_left
    WaitMovement
    ReleaseAll
    End
_farfetchd2_top_right_flee_down:
    CompareVar FARFETCHD2_BLIND_SPOT, TRUE
    GoToIf 1, _farfetchd2_top_right_caught
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _farfetchd_run_down
    WaitMovement
    ReleaseAll
    End
_farfetchd2_top_right_caught:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_FARFETCHD, 0
    Message msg_0115_D36R0101_00003
    CloseMessage
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _walk_in_place_face_right
    WaitMovement
    RemoveObject obj_D36R0101_tsure_poke_static_farfetchd_2
    Message msg_0115_D36R0101_00037
    WaitButton
    CloseMessage
    CallIfUnset FLAG_HGSS_FOUND_FIRST_FARFETCHD, _097A
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_2_LOST
    SetFlag FLAG_HGSS_FOUND_SECOND_FARFETCHD
    GoToIfSet FLAG_HGSS_FOUND_FIRST_FARFETCHD, _1207
    ClearFlag FLAG_HGSS_HIDE_FARFETCHD_1_FOUND
    WaitTime 20, VAR_0x8004
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 15, 65, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 5, VAR_0x8004
    Message msg_0115_D36R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_097A:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_ACTIVE
    Return
_farfetchd2_bottom_right:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue FARFETCHD2_BLIND_SPOT, FALSE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_EAST
    GoToIf 5, _farfetchd2_bottom_right_flee_left
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _farfetchd_run_up
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_ACTIVE
    GoTo _09F4
_farfetchd2_bottom_right_flee_left:
    CompareVar VAR_RESULT, DIR_SOUTH
    GoToIf 5, _09F4
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _farfetchd2_run_left
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
_09F4:
    WaitMovement
    ReleaseAll
    End
scr_seq_D36R0101_farfetchd2_sticks1:
    LockAll
    SetVarFromValue FARFETCHD2_BLIND_SPOT, FALSE
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_X_COORD, 41
    GoToIf 5, _0A25
    GoTo _sticks1_farfetchd2_left
_0A1F:
    GoTo _sticks1_farfetchd2_left
_0A25:
    CompareVar FARFETCHD_X_COORD, 49
    GoToIf 5, _sticks1_farfetchd2_left
    GoTo _sticks1_farfetchd2_right
_sticks1_farfetchd2_left:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0A59
    GoTo _sticks1_farfetchd2_top_left
_0A53:
    GoTo _sticks1_farfetchd2_right
_0A59:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _sticks1_farfetchd2_right
    GoTo _sticks1_farfetchd2_bottom_left
_sticks1_farfetchd2_right:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0A8D
    GoTo _sticks1_farfetchd2_top_right
_0A87:
    GoTo _sticks1_farfetchd2_top_left
_0A8D:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _sticks1_farfetchd2_top_left
    GoTo _sticks1_farfetchd2_bottom_right
_sticks1_farfetchd2_top_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_right
    WaitMovement
    ReleaseAll
    End
_sticks1_farfetchd2_bottom_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_up
    WaitMovement
    ReleaseAll
    End
_sticks1_farfetchd2_top_right:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_ACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_up
    WaitMovement
    ReleaseAll
    End
_sticks1_farfetchd2_bottom_right:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_up
    WaitMovement
    ReleaseAll
    End
scr_seq_D36R0101_farfetchd2_sticks2:
    LockAll
    SetVarFromValue FARFETCHD2_BLIND_SPOT, TRUE
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_X_COORD, 41
    GoToIf 5, _0B1B
    GoTo _sticks2_farfetchd2_left
_0B15:
    GoTo _sticks2_farfetchd2_left
_0B1B:
    CompareVar FARFETCHD_X_COORD, 49
    GoToIf 5, _sticks2_farfetchd2_left
    GoTo _sticks2_farfetchd2_right
_sticks2_farfetchd2_left:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0B4F
    GoTo _sticks2_farfetchd2_top_left
_0B49:
    GoTo _sticks2_farfetchd2_right
_0B4F:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _sticks2_farfetchd2_right
    GoTo _sticks2_farfetchd2_bottom_left
_sticks2_farfetchd2_right:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0B83
    GoTo _sticks2_farfetchd2_top_right
_0B7D:
    GoTo _sticks2_farfetchd2_top_left
_0B83:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _sticks2_farfetchd2_top_left
    GoTo _sticks2_farfetchd2_bottom_right
_sticks2_farfetchd2_top_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_right
    WaitMovement
    ReleaseAll
    End
_sticks2_farfetchd2_bottom_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_right
    WaitMovement
    ReleaseAll
    End
_sticks2_farfetchd2_top_right:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_ACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_right
    WaitMovement
    ReleaseAll
    End
_sticks2_farfetchd2_bottom_right:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_up
    WaitMovement
    ReleaseAll
    End
scr_seq_D36R0101_farfetchd2_sticks3:
    LockAll
    SetVarFromValue FARFETCHD2_BLIND_SPOT, FALSE
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_X_COORD, 41
    GoToIf 5, _0C11
    GoTo _sticks3_farfetchd2_left
_0C0B:
    GoTo _sticks3_farfetchd2_left
_0C11:
    CompareVar FARFETCHD_X_COORD, 49
    GoToIf 5, _sticks3_farfetchd2_left
    GoTo _sticks3_farfetchd2_right
_sticks3_farfetchd2_left:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0C45
    GoTo _sticks3_farfetchd2_top_left
_0C3F:
    GoTo _sticks3_farfetchd2_right
_0C45:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _sticks3_farfetchd2_right
    GoTo _sticks3_farfetchd2_bottom_left
_sticks3_farfetchd2_right:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0C79
    GoTo _sticks3_farfetchd2_top_right
_0C73:
    GoTo _sticks3_farfetchd2_top_left
_0C79:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _sticks3_farfetchd2_top_left
    GoTo _sticks3_farfetchd2_bottom_right
_sticks3_farfetchd2_top_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_down
    WaitMovement
    ReleaseAll
    End
_sticks3_farfetchd2_bottom_left:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_right
    WaitMovement
    ReleaseAll
    End
_sticks3_farfetchd2_top_right:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_down
    WaitMovement
    ReleaseAll
    End
_sticks3_farfetchd2_bottom_right:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, STICKS_INACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_left
    WaitMovement
    ReleaseAll
    End
scr_seq_D36R0101_farfetchd2_sticks4:
    LockAll
    SetVarFromValue FARFETCHD2_BLIND_SPOT, FALSE
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_X_COORD, 41
    GoToIf 5, _0CFB
    GoTo _sticks4_farfetchd2_left
_0CF5:
    GoTo _sticks4_farfetchd2_left
_0CFB:
    CompareVar FARFETCHD_X_COORD, 49
    GoToIf 5, _sticks4_farfetchd2_left
    GoTo _sticks4_farfetchd2_right
_sticks4_farfetchd2_left:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0D2F
    GoTo _sticks4_farfetchd2_top_left
_0D29:
    GoTo _sticks4_farfetchd2_right
_0D2F:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _sticks4_farfetchd2_right
    GoTo _sticks4_farfetchd2_bottom_left
_sticks4_farfetchd2_right:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short FARFETCHD_X_COORD
    .short FARFETCHD_Z_COORD
    CompareVar FARFETCHD_Z_COORD, 54
    GoToIf 5, _0D63
    GoTo _sticks4_farfetchd2_top_right
_0D5D:
    GoTo _sticks4_farfetchd2_top_left
_0D63:
    CompareVar FARFETCHD_Z_COORD, 64
    GoToIf 5, _sticks4_farfetchd2_top_left
    GoTo _sticks4_farfetchd2_bottom_right
_sticks4_farfetchd2_top_left:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_right
    WaitMovement
    ReleaseAll
    End
_sticks4_farfetchd2_bottom_left:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_up
    WaitMovement
    ReleaseAll
    End
_sticks4_farfetchd2_top_right:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_INACTIVE
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_left
    WaitMovement
    ReleaseAll
    End
_sticks4_farfetchd2_bottom_right:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _exclaim_face_up
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_exclaim_face_down:
    FaceSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_exclaim_face_up:
    FaceNorth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_exclaim_face_left:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_exclaim_face_right:
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_farfetchd_run_up:
    EmoteExclamationMark
    WalkFastNorth 10
    FaceSouth
    EndMovement
    .balign 4, 0
_farfetchd_run_down:
    EmoteExclamationMark
    WalkFastSouth 10
    FaceNorth
    EndMovement
    .balign 4, 0
_farfetchd1_run_right:
    EmoteExclamationMark
    WalkFastEast 7
    FaceWest
    EndMovement
    .balign 4, 0
_farfetchd1_run_left:
    EmoteExclamationMark
    WalkFastWest 7
    FaceEast
    EndMovement
    .balign 4, 0
_farfetchd2_run_right:
    EmoteExclamationMark
    WalkFastEast 8
    FaceWest
    EndMovement
    .balign 4, 0
_farfetchd2_run_left:
    EmoteExclamationMark
    WalkFastWest 8
    FaceEast
    EndMovement
    .balign 4, 0
_walk_in_place_face_down:
    WalkOnSpotFastSouth 5
    EndMovement
    .balign 4, 0
_walk_in_place_face_right:
    WalkOnSpotFastEast 5
    EndMovement
scr_seq_D36R0101_016:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0EC4
    WaitMovement
    ApplyMovement obj_D36R0101_gsbigman, _0ED0
    WaitMovement
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    @ HGSS: ScreenShake 0, 2, 10, 5
    ApplyMovement obj_D36R0101_gsbigman, _0ED8
    WaitMovement
    ApplyMovement obj_D36R0101_gsbigman, _0ED0
    WaitMovement
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    @ HGSS: ScreenShake 0, 2, 10, 5
    ApplyMovement obj_D36R0101_gsbigman, _0ED8
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40EA, 1
    ReleaseAll
    End
    .balign 4, 0
_0EC4:
    EmoteExclamationMark
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0ED0:
    JumpNearFastNorth
    EndMovement
    .balign 4, 0
_0ED8:
    LockDir
    WalkSlowSouth
    UnlockDir
    EndMovement
scr_seq_D36R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0115_D36R0101_00011
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _1086
    Message msg_0115_D36R0101_00014
    CloseMessage
_0F0B:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: PartySelectUI
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _1093
    GetPartyMonSpecies VAR_RESULT, VAR_0x8005
    @ HGSS: SetOrCopyVar VAR_SPECIAL_x8006, VAR_SPECIAL_RESULT
    CompareVar VAR_0x8005, 0
    GoToIf 1, _10A0
    @ HGSS: MonHasMove VAR_SPECIAL_RESULT, MOVE_HEADBUTT, VAR_SPECIAL_x8006
    CompareVar VAR_RESULT, 1
    GoToIf 1, _10E1
    @ HGSS: ScrCmd_656 VAR_SPECIAL_x8006, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F84
    Message msg_0115_D36R0101_00016
    CloseMessage
    GoTo _0F0B
_0F84:
    @ HGSS: CountMonMoves VAR_SPECIAL_x8002, VAR_SPECIAL_x8006
    CompareVar VAR_0x8002, 3
    GoToIf 3, _1041
_0F99:
    BufferPartyMonNickname 0, VAR_0x8006
    Message msg_0115_D36R0101_00017
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _10C7
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: PokemonSummaryScreen 1, VAR_SPECIAL_x8006, 29
    @ HGSS: GetMoveSelection 1, VAR_SPECIAL_x8001
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8001, 4
    GoToIf 1, _10AB
    @ HGSS: BufferPartyMonMoveName 1, VAR_SPECIAL_x8006, VAR_SPECIAL_x8001
    Message msg_0115_D36R0101_00018
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _10C7
    @ HGSS: SetMonMove VAR_SPECIAL_x8006, VAR_SPECIAL_x8001, MOVE_HEADBUTT
    Message msg_0115_D36R0101_00020
    PlaySE SEQ_SE_DP_KON_sseq
    WaitSE SEQ_SE_DP_KON_sseq
    WaitTime 30, VAR_RESULT
    Message msg_0115_D36R0101_00024
    WaitTime 32, VAR_RESULT
    Message msg_0115_D36R0101_00025
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    WaitTime 16, VAR_RESULT
    PlayCry VAR_0x8005, 0
    GoTo _1079
_1041:
    BufferPartyMonNickname 0, VAR_0x8006
    @ HGSS: SetMonMove VAR_SPECIAL_x8006, VAR_SPECIAL_x8002, MOVE_HEADBUTT
    Message msg_0115_D36R0101_00021
    WaitTime 30, VAR_RESULT
    Message msg_0115_D36R0101_00026
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    WaitTime 32, VAR_RESULT
    PlayCry VAR_0x8005, 0
    Message msg_0115_D36R0101_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1079:
    Message msg_0115_D36R0101_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1086:
    Message msg_0115_D36R0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1093:
    Message msg_0115_D36R0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_10A0:
    Message msg_0115_D36R0101_00015
    CloseMessage
    GoTo _0F0B
_10AB:
    Message msg_0115_D36R0101_00019
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F99
    GoTo _1086
_10C7:
    Message msg_0115_D36R0101_00019
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F99
    GoTo _1086
_10E1:
    BufferPartyMonSpecies 0, VAR_0x8006
    Message msg_0115_D36R0101_00023
    CloseMessage
    GoTo _0F0B
    End
scr_seq_D36R0101_010:
    GoToIfSet FLAG_HGSS_FOUND_FIRST_FARFETCHD, _1104
    GoTo _1115
_1104:
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _1126
    GoTo _1139
_1115:
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _1139
    GoTo _114C
_1126:
    NPCMessage msg_0115_D36R0101_00002
    End
_1139:
    NPCMessage msg_0115_D36R0101_00001
    End
_114C:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0115_D36R0101_00000
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_40F4, 0
    ReleaseAll
    End
scr_seq_D36R0101_017:
    LockAll
    ApplyMovement obj_D36R0101_gsboy1, _118C
    ApplyMovement LOCALID_PLAYER, _1194
    WaitMovement
    Message msg_0115_D36R0101_00000
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_40F4, 0
    ReleaseAll
    End
    .balign 4, 0
_118C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_1194:
    Delay8 2
    FaceNorth
    EndMovement
scr_seq_D36R0101_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_HM01, _11F2
    Message msg_0115_D36R0101_00006
    SetVar VAR_0x8004, ITEM_HM01
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _11FD
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HM01
    ClearFlag FLAG_HGSS_UNK_1AE
    ClearFlag FLAG_HGSS_UNK_1AC
    Message msg_0115_D36R0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_11F2:
    Message msg_0115_D36R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_11FD:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_1207:
    ClearFlag FLAG_HGSS_HIDE_ILEX_CUT_MASTER
    AddObject obj_D36R0101_gsfighter
    ClearFlag FLAG_HGSS_HIDE_FARFETCHD_2_FOUND
    WaitTime 20, VAR_0x8004
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 15, 65, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 5, VAR_0x8004
    Message msg_0115_D36R0101_00002
    WaitButton
    CloseMessage
    ApplyMovement obj_D36R0101_gsfighter, _12EC
    ApplyMovement LOCALID_PLAYER, _12F8
    WaitMovement
    GoToIfSet FLAG_HGSS_GOT_HM01, _12BE
    Message msg_0115_D36R0101_00006
    SetVar VAR_0x8004, ITEM_HM01
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _12C9
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_HIDE_ILEX_CUT_MASTER
    SetFlag FLAG_HGSS_HIDE_ILEX_APPRENTICE
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_1_LOST
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_2_LOST
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_1_FOUND
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_2_FOUND
    SetFlag FLAG_HGSS_GOT_HM01
    ClearFlag FLAG_HGSS_UNK_1AE
    ClearFlag FLAG_HGSS_UNK_1AC
    Message msg_0115_D36R0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_12BE:
    Message msg_0115_D36R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_12C9:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_D36R0101_014:
    PlayCry SPECIES_FARFETCHD, 0
    NPCMessage msg_0115_D36R0101_00004
    End
    .balign 4, 0
_12EC:
    WalkNormalNorth 10
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_12F8:
    Delay8 12
    FaceWest
    EndMovement
scr_seq_D36R0101_015:
    LockAll
    ApplyMovement obj_D36R0101_dancer, _1478
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8004, 40
    GoToIf 5, _1337
    ApplyMovement obj_D36R0101_dancer, _1484
    GoTo _133F
_1337:
    ApplyMovement obj_D36R0101_dancer, _1494
_133F:
    WaitMovement
    Message msg_0115_D36R0101_00029
    CloseMessage
    ApplyMovement obj_D36R0101_dancer, _14A4
    WaitMovement
    Message msg_0115_D36R0101_00030
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _1371
    Message msg_0115_D36R0101_00031
    GoTo _1374
_1371:
    Message msg_0115_D36R0101_00032
_1374:
    CloseMessage
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 50
    GoToIf 1, _13D5
    CompareVar VAR_MAP_LOCAL_0x01, 51
    GoToIf 1, _13D5
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_0x8004, 40
    GoToIf 5, _13C1
    ApplyMovement LOCALID_PLAYER, _14E8
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _14FC
    GoTo _13C9
_13C1:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1518
_13C9:
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    GoTo _140A
_13D5:
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_0x8004, 40
    GoToIf 5, _13FC
    ApplyMovement LOCALID_PLAYER, _14E8
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1538
    GoTo _1404
_13FC:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1550
_1404:
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
_140A:
    CompareVar VAR_0x8004, 40
    GoToIf 5, _1425
    ApplyMovement obj_D36R0101_dancer, _156C
    GoTo _142D
_1425:
    ApplyMovement obj_D36R0101_dancer, _1574
_142D:
    WaitMovement
    Message msg_0115_D36R0101_00033
    CloseMessage
    ApplyMovement obj_D36R0101_dancer, _157C
    WaitMovement
    Message msg_0115_D36R0101_00034
    CloseMessage
    ApplyMovement obj_D36R0101_dancer, _159C
    WaitMovement
    RemoveObject obj_D36R0101_dancer
    SetFlag FLAG_HGSS_UNK_23D
    Common_FadeToDefaultMusic
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1584
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40E9, 1
    End
    .balign 4, 0
_1478:
    EmoteExclamationMark
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1484:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_1494:
    WalkNormalSouth
    WalkNormalEast 3
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_14A4:
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    EndMovement
    .balign 4, 0
_14E8:
    FaceWest
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_14FC:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkOnSpotNormalEast
    JumpOnSpotFastEast 3
    EndMovement
    .balign 4, 0
_1518:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkOnSpotNormalEast
    JumpOnSpotFastEast 3
    EndMovement
    .balign 4, 0
_1538:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1550:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_156C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1574:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_157C:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1584:
    WalkNormalEast 3
    WalkNormalSouth 2
    WalkNormalEast
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_159C:
    WalkNormalWest 2
    WalkNormalNorth 2
    WalkNormalWest 6
    EndMovement
scr_seq_D36R0101_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _16D8
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _16EC
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, DIR_NORTH
    GoToIf 5, _1625
    ApplyMovement LOCALID_PLAYER, _1700
    ApplyMovement obj_D36R0101_gsmiddleman1, _174C
    GoTo _1677
_1625:
    CompareVar VAR_RESULT, DIR_SOUTH
    GoToIf 5, _1640
    ApplyMovement LOCALID_PLAYER, _1718
    GoTo _1677
_1640:
    CompareVar VAR_RESULT, DIR_EAST
    GoToIf 5, _1663
    ApplyMovement LOCALID_PLAYER, _1738
    ApplyMovement obj_D36R0101_gsmiddleman1, _174C
    GoTo _1677
_1663:
    ApplyMovement LOCALID_PLAYER, _1724
    ApplyMovement obj_D36R0101_gsmiddleman1, _174C
_1677:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _169E
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1758
    WaitMovement
_169E:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 8
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_16D8:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_16EC:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_1700:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1718:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1724:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1738:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_174C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1758:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_D36R0101_012:
    @ HGSS: PlayerOnBikeCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _1803
    CompareVar VAR_HGSS_UNK_412B, 2
    GoToIf 4, _17C1
    CompareVar VAR_HGSS_UNK_412B, 1
    GoToIf 1, _1803
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    @ HGSS: FollowerPokeIsEventTrigger EVENT_SPIKY_EARED_PICHU, VAR_TEMP_x4000, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _17B7
    GoTo _17C1
_17B1:
    GoTo _17C1
_17B7:
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_SPIKY_EAR_PICHU
    GoTo _1816
_17C1:
    CompareVar VAR_HGSS_UNK_40FE, 4
    GoToIf 4, _1803
    GoToIfUnset FLAG_HGSS_BEAT_RADIO_TOWER_ROCKETS, _1803
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x06
    @ HGSS: FollowerPokeIsEventTrigger EVENT_CELEBI, VAR_TEMP_x4006, VAR_TEMP_x4007
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _17FD
    GoTo _1803
_17F7:
    GoTo _1803
_17FD:
    GoTo _1F48
_1803:
    NPCMessage msg_0115_D36R0101_00028
    End
_1816:
    LockAll
    StopMusic
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_SPIKY_EAR_PICHU
    AddObject obj_D36R0101_tsure_poke_static_pichu_spiky
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1C44
    WaitMovement
    PlayCry SPECIES_PICHU, 0
    WaitCry
    ApplyMovement LOCALID_PLAYER, _1C58
    WaitMovement
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1C64
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _1C8C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0115_D36R0101_00038
    CloseMessage
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1CB4
    WaitMovement
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1CC4
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1CF8
    WaitMovement
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1D08
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1D2C
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_OLD_MAN
    AddObject obj_D36R0101_gsoldman1
    ApplyMovement obj_D36R0101_gsoldman1, _1DE0
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1D48
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1DA4
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _1E88
    WaitMovement
    Message msg_0115_D36R0101_00046
    CloseMessage
    ApplyMovement obj_D36R0101_gsoldman1, _1DF4
    WaitMovement
    Message msg_0115_D36R0101_00047
    CloseMessage
    ApplyMovement obj_D36R0101_gsoldman1, _1E00
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1E10
    ApplyMovement LOCALID_PLAYER, _1ED0
    WaitMovement
    Message msg_0115_D36R0101_00048
    CloseMessage
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1E20
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1E2C
    WaitMovement
    Message msg_0115_D36R0101_00049
    CloseMessage
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1E38
    WaitMovement
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1E40
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1E48
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _1E74
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0115_D36R0101_00039
    PlayCry SPECIES_PICHU, 0
    Message msg_0115_D36R0101_00043
    WaitCry
    CloseMessage
    Call _1987
    CompareVar VAR_0x8004, 1
    CallIf 4, _1AFB
    CompareVar VAR_0x8004, 0
    CallIf 1, _19AC
    ReleaseAll
    End
_1987:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 0, _19A4
    SetVarFromValue VAR_0x8004, 1
    GoTo _19AA
_19A4:
    SetVarFromValue VAR_0x8004, 0
_19AA:
    Return
_19AC:
    Message msg_0115_D36R0101_00052
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _1EB4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
_19CF:
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _19EE
    ApplyMovement obj_D36R0101_gsoldman1, _1E90
    GoTo _19F6
_19EE:
    ApplyMovement obj_D36R0101_gsoldman1, _1E98
_19F6:
    WaitMovement
    PlayFanfare SEQ_FANFA4_sseq
    BufferPlayerName 0
    Message msg_0115_D36R0101_00044
    WaitFanfare
    Message msg_0115_D36R0101_00053
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1A2C
    ApplyMovement LOCALID_PLAYER, _1ED8
    GoTo _1A34
_1A2C:
    ApplyMovement LOCALID_PLAYER, _1EE4
_1A34:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _1A51
    Common_FadeToDefaultMusic
_1A51:
    @ HGSS: GiveSpikyEarPichu
    RemoveObject obj_D36R0101_tsure_poke_static_pichu_spiky
    SetVarFromValue VAR_HGSS_UNK_412B, 2
    Message msg_0115_D36R0101_00040
    WaitFanfare
    Message msg_0115_D36R0101_00045
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _1AC5
    CloseMessage
    GetPartyCount VAR_MAP_LOCAL_0x09
    SubVar VAR_MAP_LOCAL_0x09, 1
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 0
    @ HGSS: NopVar490 VAR_TEMP_x4009
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_TEMP_x4009, VAR_TEMP_x400A
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    GoToIf 1, _1AC5
    BufferPartyMonNickname 0, VAR_MAP_LOCAL_0x09
    Message msg_0115_D36R0101_00054
_1AC5:
    Message msg_0115_D36R0101_00051
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1AE7
    ApplyMovement obj_D36R0101_gsoldman1, _1E64
    GoTo _1AEF
_1AE7:
    ApplyMovement obj_D36R0101_gsoldman1, _1E50
_1AEF:
    WaitMovement
    RemoveObject obj_D36R0101_gsoldman1
    SetFlag FLAG_HGSS_HIDE_ILEX_FOREST_OLD_MAN
    Return
_1AFB:
    Message msg_0115_D36R0101_00050
    WaitButton
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _1B13
    Common_FadeToDefaultMusic
_1B13:
    SetVarFromValue VAR_HGSS_UNK_412B, 1
    Return
scr_seq_D36R0101_019:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x08, 1
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1B44
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1EF0
    GoTo _1B67
_1B44:
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 5, _1B5F
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1EF8
    GoTo _1B67
_1B5F:
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _1F00
_1B67:
    WaitMovement
    PlayCry SPECIES_PICHU, 0
    Message msg_0115_D36R0101_00043
    WaitCry
    CloseMessage
    Call _1987
    CompareVar VAR_0x8004, 1
    GoToIf 4, _1C36
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1BB2
    ApplyMovement obj_D36R0101_gsoldman1, _1E90
    GoTo _1BD5
_1BB2:
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 5, _1BCD
    ApplyMovement obj_D36R0101_gsoldman1, _1E98
    GoTo _1BD5
_1BCD:
    ApplyMovement obj_D36R0101_gsoldman1, _1EA0
_1BD5:
    WaitMovement
    Message msg_0115_D36R0101_00052
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1BFB
    ApplyMovement LOCALID_PLAYER, _1EA8
    GoTo _1C1E
_1BFB:
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 5, _1C16
    ApplyMovement LOCALID_PLAYER, _1EB4
    GoTo _1C1E
_1C16:
    ApplyMovement LOCALID_PLAYER, _1EC0
_1C1E:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Call _19CF
    GoTo _1C3D
_1C36:
    Message msg_0115_D36R0101_00042
    WaitButton
    CloseMessage
_1C3D:
    ReleaseAll
    End
    .balign 4, 0
_1C44:
    LockDir
    JumpFarEast
    UnlockDir
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_1C58:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_1C64:
    WalkFastSouth 7
    JumpOnSpotFastWest
    WalkFastWest 4
    WalkFastNorth 4
    WalkFastEast 4
    WalkFastSouth 4
    WalkFastWest 2
    FaceNorth
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_1C8C:
    Delay8 3
    FaceSouth
    Delay8
    WalkNormalSouth 2
    WalkOnSpotNormalEast
    Delay16
    WalkOnSpotNormalWest
    Delay16
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1CB4:
    WalkNormalEast
    WalkNormalSouth
    FaceSouth
    EndMovement
    .balign 4, 0
_1CC4:
    LockDir
    JumpNearFastEast
    UnlockDir
    JumpOnSpotFastNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    EndMovement
    .balign 4, 0
_1CF8:
    EmoteExclamationMark
    Delay8
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_1D08:
    LockDir
    JumpNearFastSouth
    UnlockDir
    Delay16
    JumpOnSpotFastWest
    WalkFastWest 7
    WalkFastNorth 13
    WalkNormalEast
    EndMovement
    .balign 4, 0
_1D2C:
    Delay16 2
    WalkFastSouth
    WalkFastWest 6
    JumpOnSpotFastNorth
    WalkFastNorth 13
    WalkFastWest
    EndMovement
    .balign 4, 0
_1D48:
    WalkFastSouth 12
    WalkFastEast 6
    WalkFastNorth 4
    WalkFastWest 3
    WalkFastSouth 4
    WalkFastEast 3
    LockDir
    JumpNearFastWest
    UnlockDir
    FaceSouth 6
    LockDir
    WalkSlowWest
    UnlockDir
    FaceWest 6
    FaceNorth 6
    LockDir
    WalkSlowEast
    UnlockDir
    FaceEast 6
    LockDir
    WalkSlowWest
    UnlockDir
    EndMovement
    .balign 4, 0
_1DA4:
    WalkFastSouth 13
    WalkFastEast 7
    JumpOnSpotFastNorth
    JumpOnSpotFastWest
    Delay8 4
    LockDir
    JumpNearFastEast
    UnlockDir
    FaceSouth 6
    FaceEast 6
    FaceNorth 6
    FaceWest 6
    Delay32
    WalkNormalWest
    EndMovement
    .balign 4, 0
_1DE0:
    Delay16 5
    WalkSlowSouth 10
    WalkSlowEast 4
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1DF4:
    WalkOnSpotNormalNorth
    Delay16
    EndMovement
    .balign 4, 0
_1E00:
    WalkOnSpotNormalSouth
    Delay16
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_1E10:
    Delay16
    WalkOnSpotNormalNorth
    Delay16
    EndMovement
    .balign 4, 0
_1E20:
    JumpOnSpotFastNorth
    JumpOnSpotFastEast
    EndMovement
    .balign 4, 0
_1E2C:
    JumpNearFastWest
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_1E38:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1E40:
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_1E48:
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_1E50:
    WalkOnSpotNormalEast
    Delay16
    WalkSlowWest 4
    WalkSlowNorth 10
    EndMovement
    .balign 4, 0
_1E64:
    WalkSlowSouth 2
    WalkSlowWest 4
    WalkSlowNorth 12
    EndMovement
    .balign 4, 0
_1E74:
    EmoteExclamationMark
    Delay8
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1E88:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1E90:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1E98:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1EA0:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1EA8:
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1EB4:
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1EC0:
    WalkNormalEast
    WalkNormalNorth 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1ED0:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1ED8:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1EE4:
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1EF0:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1EF8:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1F00:
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_D36R0101_020:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x08, 1
    Call _1987
    CompareVar VAR_0x8004, 0
    GoToIf 5, _1F35
    Call _1F3F
    GoTo _1F3B
_1F35:
    Call _1AFB
_1F3B:
    ReleaseAll
    End
_1F3F:
    Message msg_0115_D36R0101_00055
    WaitButton
    CloseMessage
    Return
_1F48:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _2038
    WaitMovement
    FadeOutBGM 0, 30
    Common_SetCounterpartBGM
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    AddObject obj_D36R0101_var_1
    AddObject obj_D36R0101_tsure_poke_static_marill
    ApplyMovement obj_D36R0101_var_1, _2054
    ApplyMovement obj_D36R0101_tsure_poke_static_marill, _2060
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _200C
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0115_D36R0101_00057, msg_0115_D36R0101_00056
    CloseMessage
    Common_FadeToDefaultMusic
    FadeScreen 6, 6, 0, COLOR_WHITE
    WaitFadeScreen
    WaitTime 15, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement LOCALID_PLAYER, _2014
    ApplyMovement obj_D36R0101_var_1, _208C
    WaitMovement
    MessageGendered msg_0115_D36R0101_00059, msg_0115_D36R0101_00058
    CloseMessage
    @ HGSS: ScrCmd_810
    SetVarFromValue VAR_HGSS_UNK_40FE, 1
    ClearFlag FLAG_HGSS_HIDE_ROUTE_22_GIOVANNI_RIVAL
    ClearFlag FLAG_HGSS_HIDE_ROUTE_22_FRIEND
    SetFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    Warp MAP_HEADER_HGSS_ROUTE_22, 954, 280, DIR_SOUTH
    FadeScreen 6, 15, 1, COLOR_WHITE
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_200C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_2014:
    EmoteExclamationMark
    Delay8
    WalkOnSpotNormalNorth
    Delay8
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalSouth
    Delay8
    EndMovement
    .balign 4, 0
_2038:
    FaceSouth
    FaceSouth
    JumpFarSouth
    LockDir
    JumpNearFastNorth
    LockDir
    EndMovement
    .balign 4, 0
_2054:
    WalkNormalSouth 11
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_2060:
    WalkNormalSouth 8
    WalkOnSpotNormalEast
    WalkNormalEast
    LockDir
    WalkNormalSouth
    Delay8
    UnlockDir
    WalkOnSpotNormalWest
    Delay8
    WalkNormalWest
    EndMovement
    .balign 4, 0
_208C:
    Delay16
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement
scr_seq_D36R0101_022:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D36R0101_var_1, _2148
    ApplyMovement LOCALID_PLAYER, _21F4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    MessageGendered msg_0115_D36R0101_00061, msg_0115_D36R0101_00060
    CloseMessage
    ApplyMovement obj_D36R0101_tsure_poke_static_marill, _2170
    WaitMovement
    Common_SetCounterpartBGM
    ApplyMovement obj_D36R0101_var_1, _215C
    WaitMovement
    MessageGendered msg_0115_D36R0101_00063, msg_0115_D36R0101_00062
    CloseMessage
    ApplyMovement obj_D36R0101_var_1, _218C
    WaitMovement
    MessageGendered msg_0115_D36R0101_00065, msg_0115_D36R0101_00064
    CloseMessage
    ApplyMovement obj_D36R0101_var_1, _219C
    ApplyMovement obj_D36R0101_tsure_poke_static_marill, _21A4
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0115_D36R0101_00067, msg_0115_D36R0101_00066
    CloseMessage
    ApplyMovement obj_D36R0101_var_1, _21AC
    ApplyMovement obj_D36R0101_tsure_poke_static_marill, _21C4
    WaitMovement
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_UNK_40FE, 5
    RemoveObject obj_D36R0101_var_1
    RemoveObject obj_D36R0101_tsure_poke_static_marill
    SetFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    ReleaseAll
    End
    .balign 4, 0
_2148:
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalEast
    Delay8
    EndMovement
    .balign 4, 0
_215C:
    WalkOnSpotNormalWest
    EmoteExclamationMark
    Delay8
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_2170:
    Delay8
    JumpOnSpotFastEast 2
    LockDir
    JumpNearFastNorth
    JumpNearFastSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_218C:
    WalkNormalWest 3
    Delay16
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_219C:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_21A4:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_21AC:
    WalkNormalWest 4
    WalkNormalNorth 6
    WalkOnSpotNormalSouth
    Delay8 6
    WalkNormalNorth 5
    EndMovement
    .balign 4, 0
_21C4:
    LockDir
    JumpNearFastSouth
    UnlockDir
    WalkOnSpotNormalNorth
    WalkNormalWest 3
    Delay8
    WalkOnSpotNormalEast
    Delay8 4
    WalkOnSpotNormalNorth
    JumpOnSpotFastNorth
    WalkNormalNorth 10
    EndMovement
    .balign 4, 0
_21F4:
    WalkNormalSouth
    Delay8
    EndMovement
scr_seq_D36R0101_013:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0115_D36R0101_00027, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
