#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0526.h"

#define obj_T10R0501_leag_door2_2 3
#define obj_T10R0501_leag_door2_3 4

    ScriptEntry scr_seq_T10R0501_000
    ScriptEntry scr_seq_T10R0501_001
    ScriptEntry scr_seq_T10R0501_002
    ScriptEntry scr_seq_T10R0501_003
    ScriptEntryEnd
scr_seq_T10R0501_002:
    GoToIfSet FLAG_HGSS_DEFEATED_KAREN, _00FA
    ShowObject obj_T10R0501_leag_door2_2
    ShowObject obj_T10R0501_leag_door2_3
    End
scr_seq_T10R0501_000:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    ReleaseAll
    End
scr_seq_T10R0501_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_DEFEATED_KAREN, _00FC
    BufferPlayerName 0
    Message msg_0526_T10R0501_00000
    CloseMessage
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 0, _0107
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_KAREN_KAREN_2, 0
    GoTo _012D
scr_seq_T10R0501_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ALAKAZAM, 0
    Message msg_0526_T10R0501_00003
    WaitCry
    Message msg_0526_T10R0501_00004
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 5, 0
    AddMenuEntry 6, 1
    AddMenuEntry 7, 2
    AddMenuEntry 9, 3
    ShowMenu
    PlayCry SPECIES_ALAKAZAM, 0
    Message msg_0526_T10R0501_00003
    WaitCry
    CloseMessage
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _014B
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0185
    CompareVar VAR_0x8008, 2
    GoToIf 1, _01BF
    CompareVar VAR_0x8008, 3
    GoToIf 1, _01F9
    ReleaseAll
    End
_00FA:
    End
_00FC:
    Message msg_0526_T10R0501_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0107:
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_KAREN_KAREN, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _025F
    SetFlag FLAG_HGSS_DEFEATED_KAREN
    Message msg_0526_T10R0501_00001
    CloseMessage
    ReleaseAll
    End
_012D:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _025F
    SetFlag FLAG_HGSS_DEFEATED_KAREN
    Message msg_0526_T10R0501_00001
    CloseMessage
    ReleaseAll
    End
_014B:
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _0270
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_WILL_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_0185:
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _0270
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_KOGA_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_01BF:
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _0270
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_BRUNO_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_01F9:
    GoToIfUnset FLAG_HGSS_DEFEATED_WILL, _0265
    GoToIfUnset FLAG_HGSS_DEFEATED_KOGA, _0265
    GoToIfUnset FLAG_HGSS_DEFEATED_BRUNO, _0265
    GoToIfUnset FLAG_HGSS_DEFEATED_KAREN, _0265
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _0270
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_LANCE_ROOM, 6, 28, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_025F:
    BlackOutFromBattle
    ReleaseAll
    End
_0265:
    Message msg_0526_T10R0501_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0270:
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
