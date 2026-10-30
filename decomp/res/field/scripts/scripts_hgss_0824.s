#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0527.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T10R0601_wataru 0
#define obj_T10R0601_ookido 1
#define obj_T10R0601_kurumi 2
#define obj_T10R0601_babyboy1_11 3
#define obj_T10R0601_leag_door2 4

    ScriptEntry scr_seq_T10R0601_000
    ScriptEntry scr_seq_T10R0601_001
    ScriptEntry scr_seq_T10R0601_002
    ScriptEntryEnd
scr_seq_T10R0601_001:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _05B6
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_UNK_210
    AddObject obj_T10R0601_babyboy1_11
    SetVarFromValue VAR_HGSS_UNK_40C8, 1
    ReleaseAll
    End
scr_seq_T10R0601_002:
    SetFlag FLAG_HGSS_UNK_210
    SetVarFromValue VAR_HGSS_UNK_40C8, 0
    End
scr_seq_T10R0601_000:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0081
    ApplyMovement LOCALID_PLAYER, _05BC
    GoTo _009C
_0081:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _00D6
    ApplyMovement LOCALID_PLAYER, _05CA
    GoTo _009C
_009C:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T10R0601_wataru, _05D0
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00000, msg_0527_T10R0601_00001
    CloseMessage
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 0, _0118
    StartTrainerBattle TRAINER_HGSS_CHAMPION_LANCE_2, 0
    GoTo _01AC
_00D6:
    ApplyMovement LOCALID_PLAYER, _05D6
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T10R0601_wataru, _05D0
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00000, msg_0527_T10R0601_00001
    CloseMessage
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 0, _0118
    StartTrainerBattle TRAINER_HGSS_CHAMPION_LANCE_2, 0
    GoTo _01AC
_0118:
    StartTrainerBattle TRAINER_HGSS_CHAMPION_LANCE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0238
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00002, msg_0527_T10R0601_00003
    CloseMessage
    WaitTime 10, VAR_0x8004
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    RemoveObject obj_T10R0601_leag_door2
    SetPosition obj_T10R0601_kurumi, 6, 0, 20, DIR_NORTH
    SetPosition obj_T10R0601_ookido, 6, 0, 17, DIR_NORTH
    WaitTime 30, VAR_0x8004
    StopMusic
    PlayMusic SEQ_GS_EYE_J_SHOUJO_sseq
    ApplyMovement obj_T10R0601_wataru, _05E4
    ApplyMovement LOCALID_PLAYER, _05FA
    WaitMovement
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _023E
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _032D
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0610
    GoTo _0348
_01AC:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0238
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00002, msg_0527_T10R0601_00003
    CloseMessage
    WaitTime 10, VAR_0x8004
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    RemoveObject obj_T10R0601_leag_door2
    SetPosition obj_T10R0601_kurumi, 6, 0, 20, DIR_NORTH
    SetPosition obj_T10R0601_ookido, 6, 0, 17, DIR_NORTH
    WaitTime 30, VAR_0x8004
    StopMusic
    PlayMusic SEQ_GS_EYE_J_SHOUJO_sseq
    ApplyMovement obj_T10R0601_wataru, _05E4
    ApplyMovement LOCALID_PLAYER, _05FA
    WaitMovement
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _023E
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _032D
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0610
    GoTo _0348
_0238:
    BlackOutFromBattle
    ReleaseAll
    End
_023E:
    ApplyMovement obj_T10R0601_kurumi, _061E
    WaitMovement
    Message msg_0527_T10R0601_00005
    CloseMessage
    ApplyMovement obj_T10R0601_ookido, _062C
    ApplyMovement obj_T10R0601_kurumi, _0632
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00006, msg_0527_T10R0601_00007
    CloseMessage
    ApplyMovement obj_T10R0601_kurumi, _0640
    WaitMovement
    Message msg_0527_T10R0601_00008
    ApplyMovement obj_T10R0601_wataru, _0646
    ApplyMovement LOCALID_PLAYER, _0654
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00009, msg_0527_T10R0601_00010
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T10R0601_wataru, _065E
    ApplyMovement LOCALID_PLAYER, _066C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0439
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _067A
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T10R0601_kurumi, _0680
    WaitMovement
    Message msg_0527_T10R0601_00011
    ApplyMovement obj_T10R0601_kurumi, _068E
    WaitMovement
    WaitABPress
    CloseMessage
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0495
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_PORT_OAK
    SetVarFromValue VAR_HGSS_UNK_411A, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_HALL_OF_FAME, 6, 22, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_032D:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _04BD
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06A4
    GoTo _0348
_0348:
    WaitMovement
    ApplyMovement obj_T10R0601_kurumi, _061E
    WaitMovement
    Message msg_0527_T10R0601_00005
    CloseMessage
    ApplyMovement obj_T10R0601_ookido, _062C
    ApplyMovement obj_T10R0601_kurumi, _0632
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00006, msg_0527_T10R0601_00007
    CloseMessage
    ApplyMovement obj_T10R0601_kurumi, _0640
    WaitMovement
    Message msg_0527_T10R0601_00008
    ApplyMovement obj_T10R0601_wataru, _0646
    ApplyMovement LOCALID_PLAYER, _0654
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00009, msg_0527_T10R0601_00010
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T10R0601_wataru, _065E
    ApplyMovement LOCALID_PLAYER, _066C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0439
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _067A
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T10R0601_kurumi, _0680
    WaitMovement
    Message msg_0527_T10R0601_00011
    ApplyMovement obj_T10R0601_kurumi, _068E
    WaitMovement
    WaitABPress
    CloseMessage
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0495
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_PORT_OAK
    SetVarFromValue VAR_HGSS_UNK_411A, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_HALL_OF_FAME, 6, 22, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0439:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T10R0601_kurumi, _0680
    WaitMovement
    Message msg_0527_T10R0601_00011
    ApplyMovement obj_T10R0601_kurumi, _068E
    WaitMovement
    WaitABPress
    CloseMessage
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0495
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_PORT_OAK
    SetVarFromValue VAR_HGSS_UNK_411A, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_HALL_OF_FAME, 6, 22, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0495:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_HALL_OF_FAME, 6, 22, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_04BD:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06BA
    WaitMovement
    ApplyMovement obj_T10R0601_kurumi, _061E
    WaitMovement
    Message msg_0527_T10R0601_00005
    CloseMessage
    ApplyMovement obj_T10R0601_ookido, _062C
    ApplyMovement obj_T10R0601_kurumi, _0632
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00006, msg_0527_T10R0601_00007
    CloseMessage
    ApplyMovement obj_T10R0601_kurumi, _0640
    WaitMovement
    Message msg_0527_T10R0601_00008
    ApplyMovement obj_T10R0601_wataru, _0646
    ApplyMovement LOCALID_PLAYER, _0654
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00009, msg_0527_T10R0601_00010
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T10R0601_wataru, _065E
    ApplyMovement LOCALID_PLAYER, _066C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0439
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _067A
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T10R0601_kurumi, _0680
    WaitMovement
    Message msg_0527_T10R0601_00011
    ApplyMovement obj_T10R0601_kurumi, _068E
    WaitMovement
    WaitABPress
    CloseMessage
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0495
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_PORT_OAK
    SetVarFromValue VAR_HGSS_UNK_411A, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_HALL_OF_FAME, 6, 22, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_05B6:
    WalkNormalNorth 6
    EndMovement
    .balign 4, 0
_05BC:
    WalkNormalNorth 2
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05CA:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_05D0:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05D6:
    WalkNormalNorth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05E4:
    FaceSouth
    EmoteExclamationMark 0
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_05FA:
    FaceSouth
    Delay8 4
    LockDir
    WalkNormalNorth 2
    UnlockDir
    EndMovement
    .balign 4, 0
_0610:
    WalkFastNorth 3
    WalkFastEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_061E:
    WalkFastNorth 12
    FaceSouth
    WalkOnSpotFastSouth 3
    EndMovement
    .balign 4, 0
_062C:
    WalkNormalNorth 8
    EndMovement
    .balign 4, 0
_0632:
    Delay8 6
    WalkNormalWest
    FaceNorth
    EndMovement
    .balign 4, 0
_0640:
    WalkOnSpotFastNorth 4
    EndMovement
    .balign 4, 0
_0646:
    WalkNormalNorth 2
    WalkNormalWest
    FaceSouth
    EndMovement
    .balign 4, 0
_0654:
    Delay8 3
    FaceNorth
    EndMovement
    .balign 4, 0
_065E:
    Delay4
    WalkNormalNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_066C:
    WalkNormalNorth 2
    WalkNormalNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_067A:
    SetInvisible
    EndMovement
    .balign 4, 0
_0680:
    WalkFastNorth 4
    EmoteExclamationMark 0
    Delay8 2
    EndMovement
    .balign 4, 0
_068E:
    WalkFastEast
    WalkFastWest 2
    WalkFastEast 2
    WalkFastWest
    FaceNorth
    EndMovement
    .balign 4, 0
_06A4:
    WalkFastNorth 2
    WalkFastWest
    WalkFastNorth 2
    WalkFastEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06BA:
    WalkFastNorth
    WalkFastEast
    WalkFastNorth 2
    WalkFastWest 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
