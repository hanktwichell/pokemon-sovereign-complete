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
    GoToIf 1, _0229
    CompareVar VAR_HGSS_UNK_40FE, 3
    GoToIf 1, _022B
    CompareVar VAR_HGSS_UNK_40FE, 2
    GoToIf 1, _024B
    End
scr_seq_D45R0102_001:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _048D
    ApplyMovement obj_D45R0102_var_1, _0497
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _049D
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D45R0102_sakaki, _04A7
    WaitMovement
    Message msg_0131_D45R0102_00000
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _0497
    WaitMovement
    MessageGendered msg_0131_D45R0102_00008, msg_0131_D45R0102_00007
    CloseMessage
    ApplyMovement obj_D45R0102_sakaki, _04B5
    WaitMovement
    Message msg_0131_D45R0102_00001
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _04BB
    WaitMovement
    MessageGendered msg_0131_D45R0102_00010, msg_0131_D45R0102_00009
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _04C5
    WaitMovement
    MessageGendered msg_0131_D45R0102_00012, msg_0131_D45R0102_00011
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _04CF
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0131_D45R0102_00014, msg_0131_D45R0102_00013
    CloseMessage
    StopMusic
    PlaySE SEQ_SE_PL_FR03_sseq
    PlayMusic SEQ_GS_SENKYO_sseq
    Message msg_0131_D45R0102_00002
    StopSE SEQ_SE_PL_FR03_sseq
    CloseMessage
    ApplyMovement obj_D45R0102_sakaki, _04B5
    WaitMovement
    Message msg_0131_D45R0102_00003
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_40FE, 3
    StartTrainerBattle TRAINER_HGSS_ROCKET_BOSS_GIOVANNI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0265
    SetVarFromValue VAR_HGSS_UNK_40FE, 4
    ApplyMovement obj_D45R0102_sakaki, _04D5
    WaitMovement
    Message msg_0131_D45R0102_00004
    CloseMessage
    ApplyMovement obj_D45R0102_sakaki, _04E7
    WaitMovement
    RemoveObject obj_D45R0102_sakaki
    SetFlag FLAG_HGSS_HIDE_TOHJO_FALLS_GIOVANNI
    ApplyMovement LOCALID_PLAYER, _04F5
    ApplyMovement obj_D45R0102_var_1, _04F5
    WaitMovement
    FadeOutBGM 0, 30
    StopMusic
    PlaySE SEQ_SE_PL_FR03_sseq
    Message msg_0131_D45R0102_00005
    StopSE SEQ_SE_PL_FR03_sseq
    CloseMessage
    ApplyMovement obj_D45R0102_var_1, _04FF
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0131_D45R0102_00016, msg_0131_D45R0102_00015
    CloseMessage
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x02
    GetPartyMonSpecies VAR_MAP_LOCAL_0x02, VAR_RESULT
    CompareVar VAR_RESULT, 251
    CallIf 5, _02D5
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0505
    WaitMovement
    FadeScreen 6, 6, 0, COLOR_WHITE
    WaitFadeScreen
    WaitTime 15, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement LOCALID_PLAYER, _04C5
    WaitMovement
    ApplyMovement obj_D45R0102_var_1, _050B
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 5, _0317
    MessageGendered msg_0131_D45R0102_00027, msg_0131_D45R0102_00026
    CloseMessage
    GoTo _0343
scr_seq_D45R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_SG_3F64, _0475
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0374
    CompareVar VAR_HGSS_UNK_40FE, 4
    GoToIf 4, _0369
    Message msg_0131_D45R0102_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0229:
    End
_022B:
    SetPosition obj_D45R0102_sakaki, 6, 1, 6, DIR_SOUTH
    SetPosition obj_D45R0102_var_1, 5, 1, 7, DIR_NORTH
    ShowObject LOCALID_COMPLETE_FOLLOWER
    CompleteFollowerReturn
    End
_024B:
    SetPosition obj_D45R0102_sakaki, 6, 1, 4, DIR_NORTH
    SetPosition obj_D45R0102_var_1, 5, 1, 8, DIR_SOUTH
    End
_0265:
    Message msg_0131_D45R0102_00006
    CloseMessage
    ApplyMovement obj_D45R0102_sakaki, _051D
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
_02D5:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    ApplyMovement obj_D45R0102_var_1, _052F
    WaitMovement
    MessageGendered msg_0131_D45R0102_00023, msg_0131_D45R0102_00022
    CloseMessage
    MessageGendered msg_0131_D45R0102_00025, msg_0131_D45R0102_00024
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Return
_0317:
    MessageGendered msg_0131_D45R0102_00018, msg_0131_D45R0102_00017
    CloseMessage
    @ HGSS: ScrCmd_810
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 16, 57, DIR_SOUTH
    FadeScreen 6, 15, 1, COLOR_WHITE
    WaitFadeScreen
    ReleaseAll
    End
_0343:
    @ HGSS: ScrCmd_810
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 16, 57, DIR_SOUTH
    FadeScreen 6, 15, 1, COLOR_WHITE
    WaitFadeScreen
    ReleaseAll
    End
_0369:
    Message msg_0131_D45R0102_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0374:
    Message msg_0131_D45R0102_00028
    Message msg_0131_D45R0102_00029
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 30, 0
    AddMenuEntry 31, 1
    AddMenuEntry 32, 2
    AddMenuEntry 33, 3
    AddMenuEntry 34, 4
    AddMenuEntry 35, 5
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    SetVarFromValue VAR_0x8004, 149
    GoToIf 1, _0428
    CompareVar VAR_0x8008, 1
    SetVarFromValue VAR_0x8004, 248
    GoToIf 1, _0428
    CompareVar VAR_0x8008, 2
    SetVarFromValue VAR_0x8004, 373
    GoToIf 1, _0428
    CompareVar VAR_0x8008, 3
    SetVarFromValue VAR_0x8004, 376
    GoToIf 1, _0428
    CompareVar VAR_0x8008, 4
    SetVarFromValue VAR_0x8004, 445
    GoToIf 1, _0428
    Message msg_0131_D45R0102_00036
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0428:
    Message msg_0131_D45R0102_00037
    CloseMessage
    CompleteScreenShake 3, 0, 15, 5
    Message msg_0131_D45R0102_00038
    CloseMessage
    PlayCry VAR_0x8004, 0
    WaitCry
    CompleteStartWildBattle VAR_0x8004, 60, 1
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _046F
    SetFlag FLAG_HGSS_SG_3F64
    Message msg_0131_D45R0102_00039
    WaitButton
    CloseMessage
    ReleaseAll
    End
_046F:
    BlackOutFromBattle
    ReleaseAll
    End
_0475:
    CompareVar VAR_HGSS_UNK_40FE, 4
    GoToIf 4, _0369
    Message msg_0131_D45R0102_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_048D:
    WalkOnSpotNormalNorth
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0497:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_049D:
    WalkNormalEast
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_04A7:
    EmoteExclamationMark
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04B5:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_04BB:
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_04C5:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_04CF:
    WalkOnSpotFastEast 4
    EndMovement
    .balign 4, 0
_04D5:
    LockDir
    WalkSlowNorth
    UnlockDir
    WalkSlowEast 2
    EndMovement
    .balign 4, 0
_04E7:
    WalkNormalSouth 4
    WalkNormalWest 2
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_04F5:
    Delay8 3
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_04FF:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0505:
    JumpOnSpotFastSouth
    EndMovement
    .balign 4, 0
_050B:
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalEast
    Delay8
    EndMovement
    .balign 4, 0
_051D:
    WalkSlowEast 2
    WalkSlowSouth 3
    WalkSlowWest 2
    WalkSlowSouth 2
    EndMovement
    .balign 4, 0
_052F:
    WalkOnSpotNormalEast
    EmoteExclamationMark
    Delay8
    WalkFastEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
