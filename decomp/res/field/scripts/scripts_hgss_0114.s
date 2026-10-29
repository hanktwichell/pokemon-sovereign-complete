#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0131.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D45R0102_sakaki 4
#define obj_D45R0102_var_1 5

    ScriptEntry scr_seq_D45R0102_000
    ScriptEntry scr_seq_D45R0102_001
    ScriptEntry scr_seq_D45R0102_002
    ScriptEntry scr_seq_D45R0102_003
    ScriptEntryEnd
scr_seq_D45R0102_002:
    End
scr_seq_D45R0102_000:
    CompareVar VAR_HGSS_UNK_40FE, 4
    GoToIf 1, _0077
    CompareVar VAR_HGSS_UNK_40FE, 3
    GoToIf 1, _0057
    CompareVar VAR_HGSS_UNK_40FE, 2
    GoToIf 1, _003D
    End
_003D:
    SetPosition obj_D45R0102_sakaki, 6, 1, 4, DIR_NORTH
    SetPosition obj_D45R0102_var_1, 5, 1, 8, DIR_SOUTH
    End
_0057:
    SetPosition obj_D45R0102_sakaki, 6, 1, 6, DIR_SOUTH
    SetPosition obj_D45R0102_var_1, 5, 1, 7, DIR_NORTH
    ShowObject LOCALID_COMPLETE_FOLLOWER
    @ HGSS: ScrCmd_606
    End
_0077:
    End
scr_seq_D45R0102_001:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0374
    ApplyMovement obj_D45R0102_var_1, _03AC
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0398
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D45R0102_sakaki, _031C
    WaitMovement
    Message msg_0131_D45R0102_00000
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _03AC
    WaitMovement
    MessageGendered msg_0131_D45R0102_00008, msg_0131_D45R0102_00007
    CloseMessage
    ApplyMovement obj_D45R0102_sakaki, _032C
    WaitMovement
    Message msg_0131_D45R0102_00001
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _03B4
    WaitMovement
    MessageGendered msg_0131_D45R0102_00010, msg_0131_D45R0102_00009
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _038C
    WaitMovement
    MessageGendered msg_0131_D45R0102_00012, msg_0131_D45R0102_00011
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _03DC
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0131_D45R0102_00014, msg_0131_D45R0102_00013
    CloseMessage
    StopMusic
    PlaySE SEQ_SE_PL_FR03_sseq
    Message msg_0131_D45R0102_00002
    StopSE SEQ_SE_PL_FR03_sseq
    CloseMessage
    ApplyMovement obj_D45R0102_sakaki, _032C
    WaitMovement
    Message msg_0131_D45R0102_00003
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_40FE, 3
    @ HGSS: TrainerBattle TRAINER_ROCKET_BOSS_GIOVANNI, 0, 1, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0250
    SetVarFromValue VAR_HGSS_UNK_40FE, 4
    ApplyMovement obj_D45R0102_sakaki, _033C
    WaitMovement
    Message msg_0131_D45R0102_00004
    CloseMessage
    ApplyMovement obj_D45R0102_sakaki, _0350
    WaitMovement
    RemoveObject obj_D45R0102_sakaki
    SetFlag FLAG_HGSS_HIDE_TOHJO_FALLS_GIOVANNI
    ApplyMovement LOCALID_PLAYER, _0380
    ApplyMovement obj_D45R0102_var_1, _0380
    WaitMovement
    FadeOutBGM 0, 30
    StopMusic
    PlaySE SEQ_SE_PL_FR03_sseq
    Message msg_0131_D45R0102_00005
    StopSE SEQ_SE_PL_FR03_sseq
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _03D4
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0131_D45R0102_00016, msg_0131_D45R0102_00015
    CloseMessage
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x02
    GetPartyMonSpecies VAR_MAP_LOCAL_0x02, VAR_RESULT
    CompareVar VAR_RESULT, 251
    CallIf 5, _02C0
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03A4
    WaitMovement
    FadeScreen 6, 6, 0, COLOR_WHITE
    WaitFadeScreen
    WaitTime 15, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement LOCALID_PLAYER, _038C
    WaitMovement
    ApplyMovement obj_D45R0102_var_1, _03C0
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 5, _0224
    MessageGendered msg_0131_D45R0102_00027, msg_0131_D45R0102_00026
    CloseMessage
    GoTo _022A
_0224:
    MessageGendered msg_0131_D45R0102_00018, msg_0131_D45R0102_00017
    CloseMessage
_022A:
    @ HGSS: ScrCmd_810
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 16, 57, DIR_SOUTH
    FadeScreen 6, 15, 1, COLOR_WHITE
    WaitFadeScreen
    ReleaseAll
    End
_0250:
    Message msg_0131_D45R0102_00006
    CloseMessage
    ApplyMovement obj_D45R0102_sakaki, _0360
    FadeScreen 6, 6, 0, COLOR_WHITE
    WaitFadeScreen
    WaitTime 15, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_WHITE
    WaitFadeScreen
    WaitMovement
    RemoveObject obj_D45R0102_sakaki
    SetFlag FLAG_HGSS_HIDE_TOHJO_FALLS_GIOVANNI
    Message msg_0131_D45R0102_00019
    CloseMessage
    @ HGSS: ScrCmd_810
    SetFlag FLAG_HGSS_UNK_178
    SetVarFromValue VAR_HGSS_UNK_40FE, 0
    SetFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 16, 57, DIR_SOUTH
    FadeScreen 6, 15, 1, COLOR_WHITE
    WaitFadeScreen
    ReleaseAll
    End
_02C0:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    ApplyMovement obj_D45R0102_var_1, _0304
    WaitMovement
    MessageGendered msg_0131_D45R0102_00023, msg_0131_D45R0102_00022
    CloseMessage
    MessageGendered msg_0131_D45R0102_00025, msg_0131_D45R0102_00024
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Return
    .balign 4, 0
_0304:
    WalkOnSpotNormalEast
    EmoteExclamationMark
    Delay8
    WalkFastEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_031C:
    EmoteExclamationMark
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_032C:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0334:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_033C:
    LockDir
    WalkSlowNorth
    UnlockDir
    WalkSlowEast 2
    EndMovement
    .balign 4, 0
_0350:
    WalkNormalSouth 4
    WalkNormalWest 2
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0360:
    WalkSlowEast 2
    WalkSlowSouth 3
    WalkSlowWest 2
    WalkSlowSouth 2
    EndMovement
    .balign 4, 0
_0374:
    WalkOnSpotNormalNorth
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0380:
    Delay8 3
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_038C:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0398:
    WalkNormalEast
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_03A4:
    JumpOnSpotFastSouth
    EndMovement
    .balign 4, 0
_03AC:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03B4:
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_03C0:
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalEast
    Delay8
    EndMovement
    .balign 4, 0
_03D4:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_03DC:
    WalkOnSpotFastEast 4
    EndMovement
scr_seq_D45R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40FE, 4
    GoToIf 4, _0404
    Message msg_0131_D45R0102_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0404:
    Message msg_0131_D45R0102_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
