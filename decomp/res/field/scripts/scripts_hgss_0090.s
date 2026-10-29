#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0113.h"

#define obj_D35R0103_wataru 0
#define obj_D35R0103_tsure_poke_static_dragonite 1
#define obj_D35R0103_rocketm 2
#define obj_D35R0103_rocketm_2 3
#define obj_D35R0103_rocketm_3 4
#define obj_D35R0103_babyboy1_9 5
#define obj_D35R0103_babyboy1_9_2 6
#define obj_D35R0103_rocketm_4 7
#define obj_D35R0103_rkanbuw 8
#define obj_D35R0103_tsure_poke_static_electrode 9
#define obj_D35R0103_tsure_poke_static_electrode_2 10
#define obj_D35R0103_tsure_poke_static_electrode_3 11
#define obj_D35R0103_tsure_poke_static_electrode_4 12
#define obj_D35R0103_tsure_poke_static_electrode_5 13
#define obj_D35R0103_tsure_poke_static_electrode_6 14
#define obj_D35R0103_tsure_poke_static_murkrow 16
#define obj_D35R0103_tsure_poke_static_murkrow_2 17
#define obj_D35R0103_tsure_poke_static_murkrow_3 18

    ScriptEntry scr_seq_D35R0103_000
    ScriptEntry scr_seq_D35R0103_001
    ScriptEntry scr_seq_D35R0103_002
    ScriptEntry scr_seq_D35R0103_003
    ScriptEntry scr_seq_D35R0103_004
    ScriptEntry scr_seq_D35R0103_005
    ScriptEntry scr_seq_D35R0103_006
    ScriptEntry scr_seq_D35R0103_007
    ScriptEntry scr_seq_D35R0103_008
    ScriptEntry scr_seq_D35R0103_009
    ScriptEntry scr_seq_D35R0103_010
    ScriptEntry scr_seq_D35R0103_011
    ScriptEntry scr_seq_D35R0103_012
    ScriptEntry scr_seq_D35R0103_013
    ScriptEntry scr_seq_D35R0103_014
    ScriptEntryEnd
scr_seq_D35R0103_002:
    @ HGSS: ScrCmd_710
    CompareVar VAR_HGSS_UNK_40A9, 3
    GoToIf 4, _004F
    End
_004F:
    SetPosition obj_D35R0103_babyboy1_9, 29, 0, 22, DIR_NORTH
    SetPosition obj_D35R0103_babyboy1_9_2, 29, 0, 22, DIR_NORTH
    CompareVar VAR_HGSS_UNK_40AC, 10
    GoToIf 4, _00B0
    CompareVar VAR_HGSS_UNK_40A9, 4
    GoToIf 4, _0083
    End
_0083:
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _00B0
    SetVarFromValue VAR_MAP_LOCAL_0x07, 77
    SetPosition obj_D35R0103_wataru, 39, 0, 18, DIR_NORTH
    SetPosition obj_D35R0103_tsure_poke_static_dragonite, 40, 0, 18, DIR_NORTH
    End
_00B0:
    End
scr_seq_D35R0103_007:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _00BF
    End
_00BF:
    @ HGSS: StaticWildWonOrCaughtCheck VAR_TEMP_x4000, 1
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0127
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    GoToIf 5, _00F4
    SetFlag FLAG_HGSS_UNK_96B
    RemoveObject obj_D35R0103_tsure_poke_static_electrode
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_4
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_ELECTRODE_1_AND_4
    GoTo _0127
_00F4:
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    GoToIf 5, _0117
    SetFlag FLAG_HGSS_UNK_96C
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_2
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_5
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_ELECTRODE_2_AND_5
    GoTo _0127
_0117:
    SetFlag FLAG_HGSS_UNK_96D
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_3
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_6
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_ELECTRODE_3_AND_6
_0127:
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_D35R0103_000:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _01AC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0113_D35R0103_00000
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
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00001, msg_0113_D35R0103_00002
    CloseMessage
    ApplyMovement obj_D35R0103_wataru, _01B8
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _01C0
    WaitMovement
    RemoveObject obj_D35R0103_wataru
    RemoveObject obj_D35R0103_tsure_poke_static_dragonite
    SetFlag FLAG_HGSS_UNK_1E5
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40A9, 1
    End
    .balign 4, 0
_01AC:
    WalkNormalEast 5
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_01B8:
    WalkNormalEast 11
    EndMovement
    .balign 4, 0
_01C0:
    Delay2
    WalkNormalEast 11
    EndMovement
scr_seq_D35R0103_013:
    LockAll
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow, _0214
    WaitMovement
    Message msg_0113_D35R0103_00024
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow, _021C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_UNK_40AC, 5
    RemoveObject obj_D35R0103_tsure_poke_static_murkrow
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_1
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_MURKROW_2
    ReleaseAll
    End
    .balign 4, 0
_0214:
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_021C:
    FaceEast
    JumpOnSpotFastEast
    WalkFastEast 5
    EndMovement
    .balign 4, 0
_022C:
    Delay8
    WalkNormalEast 3
    EndMovement
scr_seq_D35R0103_014:
    LockAll
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_2, _0270
    WaitMovement
    Message msg_0113_D35R0103_00025
    CloseMessage
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_2, _0278
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40AC, 7
    RemoveObject obj_D35R0103_tsure_poke_static_murkrow_2
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_2
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_3
    AddObject obj_D35R0103_tsure_poke_static_murkrow_3
    ReleaseAll
    End
    .balign 4, 0
_0270:
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_0278:
    FaceWest
    JumpOnSpotFastWest
    WalkFastWest 10
    EndMovement
scr_seq_D35R0103_011:
    LockAll
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_3, _0308
    WaitMovement
    Message msg_0113_D35R0103_00026
    CloseMessage
    Message msg_0113_D35R0103_00027
    CloseMessage
    PlaySE SEQ_SE_DP_DOOR10_sseq
    ApplyMovement obj_D35R0103_babyboy1_9, _03B0
    ApplyMovement obj_D35R0103_babyboy1_9_2, _03B8
    WaitMovement
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8001, 24
    GoToIf 5, _02D7
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_3, _0324
    GoTo _02DF
_02D7:
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_3, _0310
_02DF:
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40AC, 8
    RemoveObject obj_D35R0103_tsure_poke_static_murkrow_3
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_3
    SetVarFromValue VAR_HGSS_UNK_40A9, 3
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_1
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_MURKROW_2
    SetFlag FLAG_HGSS_UNK_0D3
    ReleaseAll
    End
    .balign 4, 0
_0308:
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_0310:
    JumpOnSpotFastNorth 2
    FaceWest
    Delay8
    WalkFastWest 12
    EndMovement
    .balign 4, 0
_0324:
    JumpOnSpotFastNorth 2
    FaceWest
    Delay8
    WalkFastWest 2
    JumpOnSpotFastWest 2
    WalkFastSouth
    WalkFastWest 10
    EndMovement
scr_seq_D35R0103_012:
    GoTo scr_seq_D35R0103_011
    End
    .balign 4, 0
_034C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0354:
    WalkFastWest 9
    WalkFastNorth 5
    EndMovement
scr_seq_D35R0103_001:
    CompareVar VAR_HGSS_UNK_40AC, 8
    GoToIf 4, _03A0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_UNK_0D3, _03A2
    BufferPlayerName 0
    Message msg_0113_D35R0103_00021
    CloseMessage
    PlaySE SEQ_SE_DP_DOOR10_sseq
    ApplyMovement obj_D35R0103_babyboy1_9, _03B0
    ApplyMovement obj_D35R0103_babyboy1_9_2, _03B8
    WaitMovement
    ReleaseAll
_03A0:
    End
_03A2:
    Message msg_0113_D35R0103_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_03B0:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_03B8:
    Delay8
    WalkNormalWest
    EndMovement
scr_seq_D35R0103_003:
    LockAll
    Message msg_0113_D35R0103_00003
    ApplyMovement LOCALID_PLAYER, _0630
    WaitMovement
    CloseMessage
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_ARIANA
    AddObject obj_D35R0103_rkanbuw
    AddObject obj_D35R0103_rocketm_4
    SetPosition obj_D35R0103_rkanbuw, 32, 1, 30, DIR_EAST
    SetPosition obj_D35R0103_rocketm_4, 30, 1, 30, DIR_NORTH
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 30
    GoToIf 5, _042E
    ApplyMovement LOCALID_PLAYER, _065C
    GoTo _0436
_042E:
    ApplyMovement LOCALID_PLAYER, _0668
_0436:
    ApplyMovement obj_D35R0103_rkanbuw, _0638
    ApplyMovement obj_D35R0103_rocketm_4, _0650
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D35R0103_rkanbuw, _0648
    WaitMovement
    Message msg_0113_D35R0103_00004
    CloseMessage
    ClearFlag FLAG_HGSS_UNK_1E5
    AddObject obj_D35R0103_wataru
    AddObject obj_D35R0103_tsure_poke_static_dragonite
    SetPosition obj_D35R0103_wataru, 20, 1, 25, DIR_EAST
    SetPosition obj_D35R0103_tsure_poke_static_dragonite, 19, 1, 25, DIR_NORTH
    ApplyMovement obj_D35R0103_wataru, _067C
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0684
    WaitMovement
    Message msg_0113_D35R0103_00005
    CloseMessage
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0690
    PlayCry SPECIES_DRAGONITE, 0
    WaitCry
    ApplyMovement obj_D35R0103_rkanbuw, _0648
    WaitMovement
    Message msg_0113_D35R0103_00006
    CloseMessage
    ApplyMovement obj_D35R0103_rkanbuw, _0698
    ApplyMovement obj_D35R0103_rocketm_4, _06A0
    WaitMovement
    @ HGSS: MultiBattle TRAINER_PKMN_TRAINER_LANCE_LANCE, TRAINER_EXECUTIVE_ARIANA_ARIANA_2, TRAINER_TEAM_ROCKET_GRUNT_25, 1
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0620
    Message msg_0113_D35R0103_00008
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetPosition obj_D35R0103_wataru, 28, 1, 24, DIR_SOUTH
    SetPosition obj_D35R0103_tsure_poke_static_dragonite, 27, 1, 24, DIR_EAST
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _06A8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    RemoveObject obj_D35R0103_rkanbuw
    RemoveObject obj_D35R0103_rocketm_4
    RemoveObject obj_D35R0103_rocketm_2
    RemoveObject obj_D35R0103_rocketm_3
    RemoveObject obj_D35R0103_rocketm
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_ARIANA
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_SHOP_SHADY_SALESMAN
    SetFlag FLAG_HGSS_UNK_1E8
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement obj_D35R0103_wataru, _06BC
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _06C4
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00010, msg_0113_D35R0103_00011
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0738
    ApplyMovement obj_D35R0103_wataru, _06D0
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _070C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlayCry SPECIES_DRAGONITE, 0
    WaitCry
    ApplyMovement obj_D35R0103_wataru, _06FC
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _072C
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00012, msg_0113_D35R0103_00013
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0744
    ApplyMovement obj_D35R0103_wataru, _0758
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0760
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetPosition obj_D35R0103_wataru, 39, 0, 18, DIR_NORTH
    SetPosition obj_D35R0103_tsure_poke_static_dragonite, 40, 0, 18, DIR_NORTH
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40AC, 9
    SetVarFromValue VAR_HGSS_UNK_40A9, 4
    SetFlag FLAG_HGSS_UNK_998
    End
_0620:
    BlackOutFromBattle
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_ARIANA
    SetFlag FLAG_HGSS_UNK_1E5
    ReleaseAll
    End
    .balign 4, 0
_0630:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0638:
    Delay8
    WalkFastNorth 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0648:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0650:
    Delay8 2
    WalkFastNorth 3
    EndMovement
    .balign 4, 0
_065C:
    WalkNormalSouth 5
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0668:
    WalkNormalSouth 2
    WalkNormalWest
    WalkNormalSouth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_067C:
    WalkFastEast 10
    EndMovement
    .balign 4, 0
_0684:
    Delay4
    WalkFastEast 10
    EndMovement
    .balign 4, 0
_0690:
    JumpOnSpotFastEast
    EndMovement
    .balign 4, 0
_0698:
    WalkFastWest
    EndMovement
    .balign 4, 0
_06A0:
    WalkFastNorth
    EndMovement
    .balign 4, 0
_06A8:
    WalkFastNorth 2
    WalkFastEast
    WalkFastSouth 2
    FaceWest
    EndMovement
    .balign 4, 0
_06BC:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_06C4:
    Delay2
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_06D0:
    WalkNormalNorth 6
    Delay8 2
    WalkNormalWest 2
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalEast
    WalkNormalEast 5
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_06FC:
    WalkNormalWest 2
    WalkOnSpotNormalSouth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_070C:
    Delay2
    WalkNormalEast
    WalkNormalNorth 5
    WalkNormalEast 8
    WalkNormalNorth
    Delay8 4
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_072C:
    Delay4
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0738:
    Delay8 4
    WalkNormalNorth 5
    EndMovement
    .balign 4, 0
_0744:
    Delay2
    Delay8
    WalkNormalNorth
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0758:
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0760:
    Delay2
    WalkNormalWest
    WalkNormalEast 5
    EndMovement
scr_seq_D35R0103_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_ELECTRODE, 23, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _089C
    @ HGSS: StaticWildWonOrCaughtCheck VAR_TEMP_x4000, 0
    CompareVar VAR_MAP_LOCAL_0x00, TRUE
    GoToIf 1, _07D0
    SetFlag FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_1
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_2, _07D0
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_3, _07D0
    GoTo _08A2
_07D0:
    ReleaseAll
    End
scr_seq_D35R0103_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 2
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_ELECTRODE, 23, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _089C
    @ HGSS: StaticWildWonOrCaughtCheck VAR_TEMP_x4000, 0
    CompareVar VAR_MAP_LOCAL_0x00, TRUE
    GoToIf 1, _0834
    SetFlag FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_2
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_1, _0834
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_3, _0834
    GoTo _08A2
_0834:
    ReleaseAll
    End
scr_seq_D35R0103_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 3
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_ELECTRODE, 23, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _089C
    @ HGSS: StaticWildWonOrCaughtCheck VAR_TEMP_x4000, 0
    CompareVar VAR_MAP_LOCAL_0x00, TRUE
    GoToIf 1, _0898
    SetFlag FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_3
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_1, _0898
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_2, _0898
    GoTo _08A2
_0898:
    ReleaseAll
    End
_089C:
    BlackOutFromBattle
    ReleaseAll
    End
_08A2:
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 16
    GoToIf 5, _08CD
    ApplyMovement LOCALID_PLAYER, _09E0
    GoTo _08F0
_08CD:
    CompareVar VAR_MAP_LOCAL_0x01, 14
    GoToIf 5, _08E8
    ApplyMovement LOCALID_PLAYER, _09EC
    GoTo _08F0
_08E8:
    ApplyMovement LOCALID_PLAYER, _09F8
_08F0:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D35R0103_wataru, _0A04
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0A0C
    WaitMovement
    Message msg_0113_D35R0103_00015
    SetVar VAR_0x8004, ITEM_HM05
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0113_D35R0103_00017
    CloseMessage
    ApplyMovement obj_D35R0103_wataru, _0A18
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00018, msg_0113_D35R0103_00019
    CloseMessage
    ApplyMovement obj_D35R0103_wataru, _0A20
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0A2C
    WaitMovement
    RemoveObject obj_D35R0103_wataru
    RemoveObject obj_D35R0103_tsure_poke_static_dragonite
    SetFlag FLAG_HGSS_UNK_1E5
    ReleaseAll
    SetFlag FLAG_HGSS_ROCKET_HIDEOUT_CLEARED
    ClearFlag FLAG_HGSS_HIDE_ROUTE_43_GATE_GUARD
    SetFlag FLAG_HGSS_HIDE_ROUTE_43_GATE_ROCKETS
    SetFlag FLAG_HGSS_UNK_1F9
    SetVarFromValue VAR_HGSS_UNK_40AC, 10
    SetVarFromValue VAR_HGSS_UNK_410F, 1
    @ HGSS: ScrCmd_530 0, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_1, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_1, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_1, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_2, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_2, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_3, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_4, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_2, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_3, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_3, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_4, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_4, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_5, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_6, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_5, 1
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_5, 1
    End
    .balign 4, 0
_09E0:
    WalkNormalSouth 2
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
_09EC:
    WalkNormalSouth 4
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
_09F8:
    WalkNormalSouth 6
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
_0A04:
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0A0C:
    Delay2
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0A18:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0A20:
    WalkFastSouth 6
    WalkFastWest 12
    EndMovement
    .balign 4, 0
_0A2C:
    Delay4
    WalkFastWest
    WalkFastSouth 6
    WalkFastWest 12
    EndMovement
scr_seq_D35R0103_008:
    LockAll
    Message msg_0113_D35R0103_00014
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0A6C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
    .balign 4, 0
_0A6C:
    WalkNormalWest
    EndMovement
scr_seq_D35R0103_009:
    LockAll
    ApplyMovement obj_D35R0103_wataru, _0AAC
    WaitMovement
    Message msg_0113_D35R0103_00014
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0A6C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
    .balign 4, 0
_0AAC:
    EmoteExclamationMark
    WalkOnSpotNormalWest
    EndMovement
scr_seq_D35R0103_010:
    ReleaseAll
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_1, _0AE4
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_2, _0AE4
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_3, _0AE4
    Message msg_0113_D35R0103_00023
    CloseMessage
    ReleaseAll
    End
_0AE4:
    Message msg_0113_D35R0103_00022
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
