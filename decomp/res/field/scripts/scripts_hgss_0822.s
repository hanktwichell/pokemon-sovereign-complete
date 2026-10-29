#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0525.h"

#define obj_T10R0401_leag_door2_2 3
#define obj_T10R0401_leag_door2_3 4

    ScriptEntry scr_seq_T10R0401_000
    ScriptEntry scr_seq_T10R0401_001
    ScriptEntry scr_seq_T10R0401_002
    ScriptEntry scr_seq_T10R0401_003
    ScriptEntryEnd
scr_seq_T10R0401_002:
    GoToIfSet FLAG_HGSS_DEFEATED_BRUNO, _00ED
    ShowObject obj_T10R0401_leag_door2_2
    ShowObject obj_T10R0401_leag_door2_3
    End
scr_seq_T10R0401_000:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    ReleaseAll
    End
scr_seq_T10R0401_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_DEFEATED_BRUNO, _00EF
    BufferPlayerName 0
    Message msg_0525_T10R0401_00000
    CloseMessage
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 0, _00FA
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_BRUNO_BRUNO_2, 0
    GoTo _0120
scr_seq_T10R0401_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_KADABRA, 0
    Message msg_0525_T10R0401_00003
    WaitCry
    Message msg_0525_T10R0401_00004
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 5, 0
    AddMenuEntry 6, 1
    AddMenuEntry 7, 2
    AddMenuEntry 8, 3
    ShowMenu
    PlayCry SPECIES_KADABRA, 0
    Message msg_0525_T10R0401_00003
    WaitCry
    CloseMessage
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _013E
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0178
    CompareVar VAR_0x8008, 2
    GoToIf 1, _01B2
    ReleaseAll
    End
_00ED:
    End
_00EF:
    Message msg_0525_T10R0401_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00FA:
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_BRUNO_BRUNO, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01EC
    SetFlag FLAG_HGSS_DEFEATED_BRUNO
    Message msg_0525_T10R0401_00001
    CloseMessage
    ReleaseAll
    End
_0120:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01EC
    SetFlag FLAG_HGSS_DEFEATED_BRUNO
    Message msg_0525_T10R0401_00001
    CloseMessage
    ReleaseAll
    End
_013E:
    CompleteFollowerPutAway
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _01F2
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_WILL_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteFollowerReturn
    ReleaseAll
    End
_0178:
    CompleteFollowerPutAway
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _01F2
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_KOGA_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteFollowerReturn
    ReleaseAll
    End
_01B2:
    CompleteFollowerPutAway
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _01F2
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_KAREN_ROOM, 6, 15, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteFollowerReturn
    ReleaseAll
    End
_01EC:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_01F2:
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
