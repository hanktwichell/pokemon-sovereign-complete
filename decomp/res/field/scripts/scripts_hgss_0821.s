#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0524.h"

#define obj_T10R0301_stop 3
#define obj_T10R0301_stop_2 4

    ScriptEntry scr_seq_T10R0301_000
    ScriptEntry scr_seq_T10R0301_001
    ScriptEntry scr_seq_T10R0301_002
    ScriptEntry scr_seq_T10R0301_003
    ScriptEntry scr_seq_T10R0301_004
    ScriptEntryEnd
scr_seq_T10R0301_002:
    GoToIfSet FLAG_HGSS_DEFEATED_KOGA, _00F3
    ShowObject obj_T10R0301_stop
    ShowObject obj_T10R0301_stop_2
    End
scr_seq_T10R0301_000:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    ReleaseAll
    End
scr_seq_T10R0301_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_DEFEATED_KOGA, _00F5
    Message msg_0524_T10R0301_00000
    CloseMessage
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 0, _0100
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_KOGA_KOGA_2, 0
    GoTo _0126
scr_seq_T10R0301_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_KADABRA, 0
    Message msg_0524_T10R0301_00003
    WaitCry
    Message msg_0524_T10R0301_00004
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 5, 0
    AddMenuEntry 6, 1
    AddMenuEntry 7, 2
    AddMenuEntry 8, 3
    ShowMenu
    PlayCry SPECIES_KADABRA, 0
    Message msg_0524_T10R0301_00003
    WaitCry
    CloseMessage
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0144
    CompareVar VAR_0x8008, 1
    GoToIf 1, _017E
    CompareVar VAR_0x8008, 2
    GoToIf 1, _01B8
    ReleaseAll
    End
scr_seq_T10R0301_004:
    BufferPlayerName 0
    End
_00F3:
    End
_00F5:
    Message msg_0524_T10R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0100:
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_KOGA_KOGA, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01F2
    SetFlag FLAG_HGSS_DEFEATED_KOGA
    Message msg_0524_T10R0301_00001
    CloseMessage
    ReleaseAll
    End
_0126:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01F2
    SetFlag FLAG_HGSS_DEFEATED_KOGA
    Message msg_0524_T10R0301_00001
    CloseMessage
    ReleaseAll
    End
_0144:
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _01F8
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_WILL_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_017E:
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _01F8
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_BRUNO_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_01B8:
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _01F8
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_KAREN_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_01F2:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_01F8:
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
