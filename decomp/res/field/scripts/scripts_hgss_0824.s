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
    ApplyMovement LOCALID_PLAYER, _0048
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
    .balign 4, 0
_0048:
    WalkNormalNorth 6
    EndMovement
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
    GoToIf 5, _008B
    ApplyMovement LOCALID_PLAYER, _0298
    GoTo _00AE
_008B:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _00A6
    ApplyMovement LOCALID_PLAYER, _02A8
    GoTo _00AE
_00A6:
    ApplyMovement LOCALID_PLAYER, _02B0
_00AE:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T10R0601_wataru, _02C0
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00000, msg_0527_T10R0601_00001
    CloseMessage
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 0, _00E8
    @ HGSS: TrainerBattle TRAINER_CHAMPION_LANCE_2, 0, 0, 0
    GoTo _00F0
_00E8:
    @ HGSS: TrainerBattle TRAINER_CHAMPION_LANCE, 0, 0, 0
_00F0:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0290
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
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T10R0601_wataru, _02C8
    ApplyMovement LOCALID_PLAYER, _02E0
    WaitMovement
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A1
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _017C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02F8
    GoTo _019F
_017C:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0197
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0308
    GoTo _019F
_0197:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0320
_019F:
    WaitMovement
_01A1:
    ApplyMovement obj_T10R0601_kurumi, _0338
    WaitMovement
    Message msg_0527_T10R0601_00005
    CloseMessage
    ApplyMovement obj_T10R0601_ookido, _0348
    ApplyMovement obj_T10R0601_kurumi, _0350
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00006, msg_0527_T10R0601_00007
    CloseMessage
    ApplyMovement obj_T10R0601_kurumi, _0360
    WaitMovement
    Message msg_0527_T10R0601_00008
    ApplyMovement obj_T10R0601_wataru, _0368
    ApplyMovement LOCALID_PLAYER, _0378
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0527_T10R0601_00009, msg_0527_T10R0601_00010
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T10R0601_wataru, _0384
    ApplyMovement LOCALID_PLAYER, _0394
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0234
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03A4
    WaitMovement
_0234:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T10R0601_kurumi, _03AC
    WaitMovement
    Message msg_0527_T10R0601_00011
    ApplyMovement obj_T10R0601_kurumi, _03BC
    WaitMovement
    WaitABPress
    CloseMessage
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0268
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_PORT_OAK
    SetVarFromValue VAR_HGSS_UNK_411A, 1
_0268:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_POKEMON_LEAGUE_HALL_OF_FAME, 6, 22, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0290:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0298:
    WalkNormalNorth 2
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_02A8:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_02B0:
    WalkNormalNorth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_02C0:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02C8:
    FaceSouth
    EmoteExclamationMark 0
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_02E0:
    FaceSouth
    Delay8 4
    LockDir
    WalkNormalNorth 2
    UnlockDir
    EndMovement
    .balign 4, 0
_02F8:
    WalkFastNorth 3
    WalkFastEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0308:
    WalkFastNorth 2
    WalkFastWest
    WalkFastNorth 2
    WalkFastEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0320:
    WalkFastNorth
    WalkFastEast
    WalkFastNorth 2
    WalkFastWest 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0338:
    WalkFastNorth 12
    FaceSouth
    WalkOnSpotFastSouth 3
    EndMovement
    .balign 4, 0
_0348:
    WalkNormalNorth 8
    EndMovement
    .balign 4, 0
_0350:
    Delay8 6
    WalkNormalWest
    FaceNorth
    EndMovement
    .balign 4, 0
_0360:
    WalkOnSpotFastNorth 4
    EndMovement
    .balign 4, 0
_0368:
    WalkNormalNorth 2
    WalkNormalWest
    FaceSouth
    EndMovement
    .balign 4, 0
_0378:
    Delay8 3
    FaceNorth
    EndMovement
    .balign 4, 0
_0384:
    Delay4
    WalkNormalNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_0394:
    WalkNormalNorth 2
    WalkNormalNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_03A4:
    SetInvisible
    EndMovement
    .balign 4, 0
_03AC:
    WalkFastNorth 4
    EmoteExclamationMark 0
    Delay8 2
    EndMovement
    .balign 4, 0
_03BC:
    WalkFastEast
    WalkFastWest 2
    WalkFastEast 2
    WalkFastWest
    FaceNorth
    EndMovement
    .balign 4, 0
