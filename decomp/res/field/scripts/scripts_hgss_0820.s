#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0523.h"

#define obj_T10R0201_babyboy1_11 1
#define obj_T10R0201_stop 3
#define obj_T10R0201_stop_2 4

    ScriptEntry scr_seq_T10R0201_000
    ScriptEntry scr_seq_T10R0201_001
    ScriptEntry scr_seq_T10R0201_002
    ScriptEntry scr_seq_T10R0201_003
    ScriptEntryEnd
scr_seq_T10R0201_002:
    GoToIfSet FLAG_HGSS_DEFEATED_WILL, _0123
    ShowObject obj_T10R0201_stop
    ShowObject obj_T10R0201_stop_2
    End
scr_seq_T10R0201_000:
    LockAll
    GoToIfSet FLAG_HGSS_SG_3FDB, _0125
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0232
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_HIDE_WILLS_ROOM_RETREAT
    AddObject obj_T10R0201_babyboy1_11
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    SetFlag FLAG_HGSS_SG_3FDB
    ReleaseAll
    End
scr_seq_T10R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_DEFEATED_WILL, _012F
    Message msg_0523_T10R0201_00000
    CloseMessage
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 0, _013A
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_WILL_WILL_2, 0
    GoTo _0160
scr_seq_T10R0201_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_KADABRA, 0
    Message msg_0523_T10R0201_00003
    WaitCry
    Message msg_0523_T10R0201_00004
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 5, 0
    AddMenuEntry 6, 1
    AddMenuEntry 7, 2
    AddMenuEntry 8, 3
    ShowMenu
    PlayCry SPECIES_KADABRA, 0
    Message msg_0523_T10R0201_00003
    WaitCry
    CloseMessage
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _017E
    CompareVar VAR_0x8008, 1
    GoToIf 1, _01B8
    CompareVar VAR_0x8008, 2
    GoToIf 1, _01F2
    ReleaseAll
    End
_0123:
    End
_0125:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    ReleaseAll
    End
_012F:
    Message msg_0523_T10R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013A:
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_WILL_WILL, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _022C
    SetFlag FLAG_HGSS_DEFEATED_WILL
    Message msg_0523_T10R0201_00001
    CloseMessage
    ReleaseAll
    End
_0160:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _022C
    SetFlag FLAG_HGSS_DEFEATED_WILL
    Message msg_0523_T10R0201_00001
    CloseMessage
    ReleaseAll
    End
_017E:
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _0238
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_KOGA_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_01B8:
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _0238
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_BRUNO_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_01F2:
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _0238
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_KAREN_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_022C:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0232:
    WalkNormalNorth 6
    EndMovement
    .balign 4, 0
_0238:
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
