#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0114.h"

#define obj_D35R0104_wataru 5
#define obj_D35R0104_tsure_poke_static_dragonite 6
#define obj_D35R0104_gsrivel 7
#define obj_D35R0104_rkanbum2 8
#define obj_D35R0104_tsure_poke_static_murkrow 9
#define obj_D35R0104_babyboy1_9 10
#define obj_D35R0104_babyboy1_9_2 11
#define obj_D35R0104_tsure_poke_static_murkrow_2 16
#define obj_D35R0104_sakaki 18

    ScriptEntry scr_seq_D35R0104_000
    ScriptEntry scr_seq_D35R0104_001
    ScriptEntry scr_seq_D35R0104_002
    ScriptEntry scr_seq_D35R0104_003
    ScriptEntry scr_seq_D35R0104_004
    ScriptEntry scr_seq_D35R0104_005
    ScriptEntry scr_seq_D35R0104_006
    ScriptEntry scr_seq_D35R0104_007
    ScriptEntry scr_seq_D35R0104_008
    ScriptEntryEnd
scr_seq_D35R0104_006:
    GoToIfNotDefeated TRAINER_HGSS_TEAM_ROCKET_F_GRUNT_5, _004F
    GoToIfNotDefeated TRAINER_HGSS_TEAM_ROCKET_GRUNT_19, _004F
    CompareVar VAR_HGSS_UNK_40AC, 3
    GoToIf 4, _004F
    SetVarFromValue VAR_HGSS_UNK_40AC, 2
_004F:
    End
scr_seq_D35R0104_008:
    CompareVar VAR_HGSS_UNK_40AC, 4
    GoToIf 4, _0060
    End
_0060:
    SetPosition obj_D35R0104_babyboy1_9, 22, 0, 15, DIR_NORTH
    SetPosition obj_D35R0104_babyboy1_9_2, 22, 0, 15, DIR_NORTH
    End
scr_seq_D35R0104_001:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00EC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D35R0104_wataru, _00F4
    WaitMovement
    ApplyMovement obj_D35R0104_wataru, _00FC
    ApplyMovement obj_D35R0104_tsure_poke_static_dragonite, _010C
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0114_D35R0104_00000, msg_0114_D35R0104_00001
    CloseMessage
    ApplyMovement obj_D35R0104_wataru, _0124
    ApplyMovement obj_D35R0104_tsure_poke_static_dragonite, _012C
    WaitMovement
    RemoveObject obj_D35R0104_wataru
    RemoveObject obj_D35R0104_tsure_poke_static_dragonite
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_LANCE
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40AC, 1
    End
    .balign 4, 0
_00EC:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_00F4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_00FC:
    WalkOnSpotNormalSouth
    WalkNormalSouth 3
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_010C:
    Delay8
    Delay2
    WalkNormalWest
    WalkNormalSouth 3
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0124:
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_012C:
    Delay2
    WalkNormalEast
    WalkNormalWest 9
    EndMovement
scr_seq_D35R0104_007:
    LockAll
    ApplyMovement obj_D35R0104_tsure_poke_static_murkrow_2, _018C
    WaitMovement
    Message msg_0114_D35R0104_00010
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D35R0104_tsure_poke_static_murkrow_2, _0194
    ApplyMovement LOCALID_PLAYER, _01A4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_UNK_40AC, 6
    RemoveObject obj_D35R0104_tsure_poke_static_murkrow_2
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_MURKROW_2
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_2
    ReleaseAll
    End
    .balign 4, 0
_018C:
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_0194:
    FaceSouth
    JumpOnSpotFastSouth
    WalkFastSouth 10
    EndMovement
    .balign 4, 0
_01A4:
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_D35R0104_000:
    NPCMessage msg_0114_D35R0104_00002
    End
scr_seq_D35R0104_002:
    LockAll
    ApplyMovement LOCALID_PLAYER, _00F4
    WaitMovement
    Common_SetRivalBGM
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_RIVAL
    AddObject obj_D35R0104_gsrivel
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 17
    GoToIf 5, _01FE
    ApplyMovement obj_D35R0104_gsrivel, _0290
    GoTo _0221
_01FE:
    CompareVar VAR_MAP_LOCAL_0x01, 18
    GoToIf 5, _0219
    ApplyMovement obj_D35R0104_gsrivel, _029C
    GoTo _0221
_0219:
    ApplyMovement obj_D35R0104_gsrivel, _02A8
_0221:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _02B4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferRivalName 0
    Message msg_0114_D35R0104_00003
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D35R0104_gsrivel, _02BC
    ApplyMovement LOCALID_PLAYER, _02C4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D35R0104_gsrivel, _02D8
    WaitMovement
    Common_FadeToDefaultMusic2
    RemoveObject obj_D35R0104_gsrivel
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_RIVAL
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40AC, 3
    End
    .balign 4, 0
_0290:
    WalkNormalSouth 9
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_029C:
    WalkNormalSouth 10
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_02A8:
    WalkNormalSouth 11
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_02B4:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_02BC:
    WalkFastEast
    EndMovement
    .balign 4, 0
_02C4:
    LockDir
    WalkFastEast
    JumpNearFastEast
    UnlockDir
    EndMovement
    .balign 4, 0
_02D8:
    WalkOnSpotFasterNorth
    WalkOnSpotFasterWest
    Delay8
    WalkNormalWest 2
    WalkNormalNorth 9
    EndMovement
scr_seq_D35R0104_003:
    LockAll
    ApplyMovement LOCALID_PLAYER, _00F4
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 23
    GoToIf 5, _0329
    ApplyMovement LOCALID_PLAYER, _040C
    GoTo _0331
_0329:
    ApplyMovement LOCALID_PLAYER, _041C
_0331:
    ApplyMovement obj_D35R0104_sakaki, _0440
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    Message msg_0114_D35R0104_00004
    CloseMessage
    ApplyMovement obj_D35R0104_sakaki, _044C
    WaitMovement
    Message msg_0114_D35R0104_00005
    CloseMessage
    ApplyMovement obj_D35R0104_sakaki, _0458
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_PETREL
    AddObject obj_D35R0104_rkanbum2
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_GIOVANNI
    RemoveObject obj_D35R0104_sakaki
    ApplyMovement obj_D35R0104_rkanbum2, _047C
    WaitMovement
    Message msg_0114_D35R0104_00006
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_EXECUTIVE_PETREL_PETREL_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0405
    Message msg_0114_D35R0104_00007
    CloseMessage
    ApplyMovement obj_D35R0104_rkanbum2, _04A8
    WaitMovement
    RemoveObject obj_D35R0104_rkanbum2
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_PETREL
    ApplyMovement obj_D35R0104_tsure_poke_static_murkrow, _04E4
    WaitMovement
    Message msg_0114_D35R0104_00008
    CloseMessage
    Message msg_0114_D35R0104_00009
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D35R0104_tsure_poke_static_murkrow, _04F4
    ApplyMovement LOCALID_PLAYER, _042C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_UNK_40AC, 4
    RemoveObject obj_D35R0104_tsure_poke_static_murkrow
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_MURKROW_1
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_1
    ReleaseAll
    End
_0405:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_040C:
    WalkNormalNorth 5
    WalkNormalWest
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_041C:
    WalkNormalNorth 5
    WalkNormalWest 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_042C:
    Delay8 3
    FaceSouth
    Delay8 3
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0440:
    Delay8 4
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_044C:
    EmoteExclamationMark
    Delay8 2
    EndMovement
    .balign 4, 0
_0458:
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    EndMovement
    .balign 4, 0
_047C:
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    EndMovement
    .balign 4, 0
    WalkNormalEast
    EndMovement
    .balign 4, 0
_04A8:
    LockDir
    WalkSlowWest
    UnlockDir
    Delay8
    WalkFastSouth 5
    LockDir
    JumpNearFastNorth
    UnlockDir
    WalkFastSouth
    WalkFastEast 3
    WalkFastSouth 5
    WalkFastWest 7
    WalkFastNorth 12
    WalkFastWest 4
    EndMovement
    .balign 4, 0
_04E4:
    WalkNormalSouth 3
    WalkNormalEast 2
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_04F4:
    FaceSouth
    WalkFastSouth
    WalkFastEast 2
    WalkFastSouth 9
    WalkFastWest 7
    WalkFastNorth 13
    WalkFastWest 5
    EndMovement
scr_seq_D35R0104_004:
    CompareVar VAR_HGSS_UNK_40AC, 4
    GoToIf 4, _055F
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfNotDefeated TRAINER_HGSS_TEAM_ROCKET_F_GRUNT_5, _0561
    GoToIfNotDefeated TRAINER_HGSS_TEAM_ROCKET_GRUNT_19, _0561
    BufferPlayerName 0
    Message msg_0114_D35R0104_00012
    CloseMessage
    PlaySE SEQ_SE_DP_DOOR10_sseq
    ApplyMovement obj_D35R0104_babyboy1_9, _056C
    ApplyMovement obj_D35R0104_babyboy1_9_2, _056C
    WaitMovement
    ReleaseAll
_055F:
    End
_0561:
    Message msg_0114_D35R0104_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_056C:
    WalkNormalWest 3
    EndMovement
scr_seq_D35R0104_005:
    NPCMessage msg_0114_D35R0104_00008
    SetFlag FLAG_HGSS_UNK_0D3
    End
    .balign 4, 0
