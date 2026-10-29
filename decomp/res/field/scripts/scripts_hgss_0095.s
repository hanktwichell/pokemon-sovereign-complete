#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0118.h"

#define obj_D37R0103_tsure_poke_static_machoke 1
#define obj_D37R0103_tsure_poke_static_machoke_2 2
#define obj_D37R0103_tsure_poke_static_machoke_3 3
#define obj_D37R0103_gsfighter_2 4
#define obj_D37R0103_babyboy1_5 5
#define obj_D37R0103_babyboy1_5_2 6
#define obj_D37R0103_babyboy1_5_3 7
#define obj_D37R0103_stop 9
#define obj_D37R0103_stop_2 10
#define obj_D37R0103_stop_3 11
#define obj_D37R0103_stop_4 12
#define obj_D37R0103_stop_5 13
#define obj_D37R0103_stop_6 14
#define obj_D37R0103_stop_7 15
#define obj_D37R0103_stop_8 16
#define obj_D37R0103_stop_9 17

    ScriptEntry scr_seq_D37R0103_000
    ScriptEntry scr_seq_D37R0103_001
    ScriptEntry scr_seq_D37R0103_002
    ScriptEntry scr_seq_D37R0103_003
    ScriptEntry scr_seq_D37R0103_004
    ScriptEntryEnd
scr_seq_D37R0103_003:
    ShowObject obj_D37R0103_stop
    ShowObject obj_D37R0103_stop_2
    ShowObject obj_D37R0103_stop_3
    ShowObject obj_D37R0103_stop_4
    ShowObject obj_D37R0103_stop_5
    ShowObject obj_D37R0103_stop_6
    ShowObject obj_D37R0103_stop_7
    ShowObject obj_D37R0103_stop_8
    ShowObject obj_D37R0103_stop_9
    GoToIfSet FLAG_HGSS_UNK_096, _013A
    GoToIfSet FLAG_HGSS_UNK_097, _0194
    GoToIfSet FLAG_HGSS_UNK_098, _01DD
    End
scr_seq_D37R0103_000:
    GoToIfSet FLAG_HGSS_UNK_096, _021B
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0118_D37R0103_00000
    CloseMessage
    ApplyMovement obj_D37R0103_tsure_poke_static_machoke, _0556
    ApplyMovement obj_D37R0103_babyboy1_5_3, _0556
    ApplyMovement obj_D37R0103_stop, _0556
    ApplyMovement obj_D37R0103_stop_2, _0556
    ApplyMovement obj_D37R0103_stop_3, _0556
    WaitMovement
    SetFlag FLAG_HGSS_UNK_096
    SetMovementType 0, 9
    ReleaseAll
    End
scr_seq_D37R0103_001:
    .short SCRCMD_UNUSED_06A
    .short obj_D37R0103_gsfighter_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 15
    GoToIf 5, _022E
    GoTo _0241
scr_seq_D37R0103_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_MACHOKE, 0
    Message msg_0118_D37R0103_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D37R0103_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement 22, _05AE
    WaitMovement
    Message msg_0118_D37R0103_00003
    WaitButton
    CloseMessage
    PlayCry SPECIES_CLAYDOL, 0
    WaitCry
    CompleteFollowerPutAway
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _055C
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_WHITE
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFFRON_SILPH_CO_ROTOM_ROOM, 5, 9, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_WHITE
    WaitFadeScreen
    CompleteFollowerReturn
    ReleaseAll
    End
_013A:
    GoToIfSet FLAG_HGSS_UNK_097, _0265
    GoToIfSet FLAG_HGSS_UNK_098, _02F0
    SetMovementType 0, 9
    SetPosition obj_D37R0103_tsure_poke_static_machoke, 19, 0, 16, DIR_SOUTH
    SetPosition obj_D37R0103_babyboy1_5_3, 19, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop, 19, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_2, 20, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_3, 20, 0, 18, DIR_NORTH
    End
_0194:
    GoToIfSet FLAG_HGSS_UNK_098, _0370
    SetPosition obj_D37R0103_tsure_poke_static_machoke_2, 3, 0, 14, DIR_WEST
    SetPosition obj_D37R0103_babyboy1_5_2, 1, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_stop_4, 1, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_5, 2, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_6, 2, 0, 14, DIR_NORTH
    End
_01DD:
    SetPosition obj_D37R0103_tsure_poke_static_machoke_3, 7, 0, 17, DIR_EAST
    SetPosition obj_D37R0103_babyboy1_5, 8, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop_7, 8, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_8, 9, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_9, 9, 0, 18, DIR_NORTH
    End
_021B:
    NPCMessage msg_0118_D37R0103_00001
    End
_022E:
    CompareVar VAR_MAP_LOCAL_0x01, 16
    GoToIf 5, _03EA
    GoTo _03F0
_0241:
    GoToIfSet FLAG_HGSS_UNK_097, _021B
    @ HGSS: ScrCmd_622 4, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0414
    GoTo _041A
_0265:
    GoToIfSet FLAG_HGSS_UNK_098, _0457
    SetMovementType 0, 9
    SetPosition obj_D37R0103_tsure_poke_static_machoke, 19, 0, 16, DIR_SOUTH
    SetPosition obj_D37R0103_babyboy1_5_3, 19, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop, 19, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_2, 20, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_3, 20, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_2, 3, 0, 14, DIR_WEST
    SetPosition obj_D37R0103_babyboy1_5_2, 1, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_stop_4, 1, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_5, 2, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_6, 2, 0, 14, DIR_NORTH
    End
_02F0:
    SetMovementType 0, 9
    SetPosition obj_D37R0103_tsure_poke_static_machoke, 19, 0, 16, DIR_SOUTH
    SetPosition obj_D37R0103_babyboy1_5_3, 19, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop, 19, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_2, 20, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_3, 20, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_3, 7, 0, 17, DIR_EAST
    SetPosition obj_D37R0103_babyboy1_5, 8, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop_7, 8, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_8, 9, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_9, 9, 0, 18, DIR_NORTH
    End
_0370:
    SetPosition obj_D37R0103_tsure_poke_static_machoke_2, 3, 0, 14, DIR_WEST
    SetPosition obj_D37R0103_babyboy1_5_2, 1, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_stop_4, 1, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_5, 2, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_6, 2, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_3, 7, 0, 17, DIR_EAST
    SetPosition obj_D37R0103_babyboy1_5, 8, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop_7, 8, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_8, 9, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_9, 9, 0, 18, DIR_NORTH
    End
_03EA:
    GoTo _021B
_03F0:
    GoToIfSet FLAG_HGSS_UNK_098, _021B
    @ HGSS: ScrCmd_622 4, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0513
    GoTo _0519
_0414:
    GoTo _021B
_041A:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0118_D37R0103_00000
    CloseMessage
    ApplyMovement obj_D37R0103_tsure_poke_static_machoke_2, _05A2
    ApplyMovement obj_D37R0103_babyboy1_5_2, _05A2
    ApplyMovement obj_D37R0103_stop_4, _05A2
    ApplyMovement obj_D37R0103_stop_5, _05A2
    ApplyMovement obj_D37R0103_stop_6, _05A2
    WaitMovement
    SetFlag FLAG_HGSS_UNK_097
    ReleaseAll
    End
_0457:
    SetMovementType 0, 9
    SetPosition obj_D37R0103_tsure_poke_static_machoke, 19, 0, 16, DIR_SOUTH
    SetPosition obj_D37R0103_babyboy1_5_3, 19, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop, 19, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_2, 20, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_3, 20, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_2, 3, 0, 14, DIR_WEST
    SetPosition obj_D37R0103_babyboy1_5_2, 1, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_stop_4, 1, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_5, 2, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_6, 2, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_3, 7, 0, 17, DIR_EAST
    SetPosition obj_D37R0103_babyboy1_5, 8, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop_7, 8, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_8, 9, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_9, 9, 0, 18, DIR_NORTH
    End
_0513:
    GoTo _021B
_0519:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0118_D37R0103_00000
    CloseMessage
    ApplyMovement obj_D37R0103_tsure_poke_static_machoke_3, _05A8
    ApplyMovement obj_D37R0103_babyboy1_5, _05A8
    ApplyMovement obj_D37R0103_stop_7, _05A8
    ApplyMovement obj_D37R0103_stop_8, _05A8
    ApplyMovement obj_D37R0103_stop_9, _05A8
    WaitMovement
    SetFlag FLAG_HGSS_UNK_098
    ReleaseAll
    End
    .balign 4, 0
_0556:
    WalkSlowSouth 2
    EndMovement
    .balign 4, 0
_055C:
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast
    SetInvisible 0
    EndMovement
    .balign 4, 0
_05A2:
    WalkSlowWest 2
    EndMovement
    .balign 4, 0
_05A8:
    WalkSlowEast 2
    EndMovement
    .balign 4, 0
_05AE:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
