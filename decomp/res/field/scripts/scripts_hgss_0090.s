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
    ScriptEntry scr_seq_D35R0103_015
    ScriptEntryEnd
scr_seq_D35R0103_002:
    @ HGSS: ScrCmd_710
    CompareVar VAR_HGSS_UNK_40A9, 3
    GoToIf 4, _040C
    End
scr_seq_D35R0103_007:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _0440
    End
scr_seq_D35R0103_000:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0BC6
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0113_D35R0103_00000
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
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00001, msg_0113_D35R0103_00002
    CloseMessage
    ApplyMovement obj_D35R0103_wataru, _0BD0
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0BD6
    WaitMovement
    RemoveObject obj_D35R0103_wataru
    RemoveObject obj_D35R0103_tsure_poke_static_dragonite
    SetFlag FLAG_HGSS_UNK_1E5
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40A9, 1
    End
scr_seq_D35R0103_013:
    LockAll
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow, _0BE0
    WaitMovement
    Message msg_0113_D35R0103_00024
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow, _0BE6
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
scr_seq_D35R0103_014:
    LockAll
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_2, _0BF4
    WaitMovement
    Message msg_0113_D35R0103_00025
    CloseMessage
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_2, _0BFA
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40AC, 7
    RemoveObject obj_D35R0103_tsure_poke_static_murkrow_2
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_2
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_3
    AddObject obj_D35R0103_tsure_poke_static_murkrow_3
    ReleaseAll
    End
scr_seq_D35R0103_011:
    LockAll
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_3, _0C08
    WaitMovement
    Message msg_0113_D35R0103_00026
    CloseMessage
    Message msg_0113_D35R0103_00027
    CloseMessage
    PlaySE SEQ_SE_DP_DOOR10_sseq
    ApplyMovement obj_D35R0103_babyboy1_9, _0C0E
    ApplyMovement obj_D35R0103_babyboy1_9_2, _0C14
    WaitMovement
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8001, 24
    GoToIf 5, _0475
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_3, _0C1E
    GoTo _04A3
scr_seq_D35R0103_012:
    GoTo _04C9
scr_seq_D35R0103_001:
    CompareVar VAR_HGSS_UNK_40AC, 8
    GoToIf 4, _0518
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_UNK_0D3, _051A
    BufferPlayerName 0
    Message msg_0113_D35R0103_00021
    CloseMessage
    PlaySE SEQ_SE_DP_DOOR10_sseq
    ApplyMovement obj_D35R0103_babyboy1_9, _0C0E
    ApplyMovement obj_D35R0103_babyboy1_9_2, _0C14
    WaitMovement
    ReleaseAll
    End
scr_seq_D35R0103_003:
    LockAll
    Message msg_0113_D35R0103_00003
    ApplyMovement LOCALID_PLAYER, _0C3C
    WaitMovement
    CloseMessage
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_ARIANA
    AddObject obj_D35R0103_rkanbuw
    AddObject obj_D35R0103_rocketm_4
    SetPosition obj_D35R0103_rkanbuw, 32, 1, 30, DIR_EAST
    SetPosition obj_D35R0103_rocketm_4, 30, 1, 30, DIR_NORTH
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 30
    GoToIf 5, _0525
    ApplyMovement LOCALID_PLAYER, _0C42
    GoTo _0717
scr_seq_D35R0103_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_ELECTRODE, 37, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0901
    CompleteCheckStaticNotBeaten VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0907
    SetFlag FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_1
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_2, _0907
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_3, _0907
    GoTo _090B
scr_seq_D35R0103_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 2
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_ELECTRODE, 37, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0901
    CompleteCheckStaticNotBeaten VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0936
    SetFlag FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_2
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_1, _0936
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_3, _0936
    GoTo _090B
scr_seq_D35R0103_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 3
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_ELECTRODE, 37, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0901
    CompleteCheckStaticNotBeaten VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _093A
    SetFlag FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_3
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_1, _093A
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_2, _093A
    GoTo _090B
scr_seq_D35R0103_008:
    LockAll
    Message msg_0113_D35R0103_00014
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0C4C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
scr_seq_D35R0103_009:
    LockAll
    ApplyMovement obj_D35R0103_wataru, _0C52
    WaitMovement
    Message msg_0113_D35R0103_00014
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0C4C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
scr_seq_D35R0103_010:
    ReleaseAll
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_1, _093E
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_2, _093E
    GoToIfUnset FLAG_HGSS_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_3, _093E
    Message msg_0113_D35R0103_00023
    CloseMessage
    ReleaseAll
    End
scr_seq_D35R0103_015:
    BufferPlayerName 0
    End
_040C:
    SetPosition obj_D35R0103_babyboy1_9, 29, 0, 22, DIR_NORTH
    SetPosition obj_D35R0103_babyboy1_9_2, 29, 0, 22, DIR_NORTH
    CompareVar VAR_HGSS_UNK_40AC, 10
    GoToIf 4, _0947
    CompareVar VAR_HGSS_UNK_40A9, 4
    GoToIf 4, _0949
    End
_0440:
    @ HGSS: StaticWildWonOrCaughtCheck VAR_MAP_LOCAL_0x00, 1
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0976
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    GoToIf 5, _097C
    SetFlag FLAG_HGSS_UNK_96B
    RemoveObject obj_D35R0103_tsure_poke_static_electrode
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_4
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_ELECTRODE_1_AND_4
    GoTo _0976
_0475:
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_3, _0C5C
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
_04A3:
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
_04C9:
    LockAll
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_3, _0C08
    WaitMovement
    Message msg_0113_D35R0103_00026
    CloseMessage
    Message msg_0113_D35R0103_00027
    CloseMessage
    PlaySE SEQ_SE_DP_DOOR10_sseq
    ApplyMovement obj_D35R0103_babyboy1_9, _0C0E
    ApplyMovement obj_D35R0103_babyboy1_9_2, _0C14
    WaitMovement
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8001, 24
    GoToIf 5, _0475
    ApplyMovement obj_D35R0103_tsure_poke_static_murkrow_3, _0C1E
    GoTo _04A3
_0518:
    End
_051A:
    Message msg_0113_D35R0103_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0525:
    ApplyMovement LOCALID_PLAYER, _0C6E
    ApplyMovement obj_D35R0103_rkanbuw, _0C80
    ApplyMovement obj_D35R0103_rocketm_4, _0C8E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D35R0103_rkanbuw, _0C98
    WaitMovement
    Message msg_0113_D35R0103_00004
    CloseMessage
    ClearFlag FLAG_HGSS_UNK_1E5
    AddObject obj_D35R0103_wataru
    AddObject obj_D35R0103_tsure_poke_static_dragonite
    SetPosition obj_D35R0103_wataru, 20, 1, 25, DIR_EAST
    SetPosition obj_D35R0103_tsure_poke_static_dragonite, 19, 1, 25, DIR_NORTH
    ApplyMovement obj_D35R0103_wataru, _0C9E
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0CA4
    WaitMovement
    Message msg_0113_D35R0103_00005
    CloseMessage
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0CAE
    PlayCry SPECIES_DRAGONITE, 0
    WaitCry
    ApplyMovement obj_D35R0103_rkanbuw, _0C98
    WaitMovement
    Message msg_0113_D35R0103_00006
    CloseMessage
    ApplyMovement obj_D35R0103_rkanbuw, _0CB4
    ApplyMovement obj_D35R0103_rocketm_4, _0CBA
    WaitMovement
    StartTagBattle TRAINER_HGSS_PKMN_TRAINER_LANCE_LANCE, TRAINER_HGSS_EXECUTIVE_ARIANA_ARIANA_2, TRAINER_HGSS_TEAM_ROCKET_GRUNT_25
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _099F
    Message msg_0113_D35R0103_00008
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetPosition obj_D35R0103_wataru, 28, 1, 24, DIR_SOUTH
    SetPosition obj_D35R0103_tsure_poke_static_dragonite, 27, 1, 24, DIR_EAST
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0CC0
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
    ApplyMovement obj_D35R0103_wataru, _0CD2
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0CD8
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00010, msg_0113_D35R0103_00011
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0CE2
    ApplyMovement obj_D35R0103_wataru, _0CEC
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0D16
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlayCry SPECIES_DRAGONITE, 0
    WaitCry
    ApplyMovement obj_D35R0103_wataru, _0D34
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0D42
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00012, msg_0113_D35R0103_00013
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0D4C
    ApplyMovement obj_D35R0103_wataru, _0D5E
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0D64
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
_0717:
    ApplyMovement obj_D35R0103_rkanbuw, _0C80
    ApplyMovement obj_D35R0103_rocketm_4, _0C8E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D35R0103_rkanbuw, _0C98
    WaitMovement
    Message msg_0113_D35R0103_00004
    CloseMessage
    ClearFlag FLAG_HGSS_UNK_1E5
    AddObject obj_D35R0103_wataru
    AddObject obj_D35R0103_tsure_poke_static_dragonite
    SetPosition obj_D35R0103_wataru, 20, 1, 25, DIR_EAST
    SetPosition obj_D35R0103_tsure_poke_static_dragonite, 19, 1, 25, DIR_NORTH
    ApplyMovement obj_D35R0103_wataru, _0C9E
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0CA4
    WaitMovement
    Message msg_0113_D35R0103_00005
    CloseMessage
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0CAE
    PlayCry SPECIES_DRAGONITE, 0
    WaitCry
    ApplyMovement obj_D35R0103_rkanbuw, _0C98
    WaitMovement
    Message msg_0113_D35R0103_00006
    CloseMessage
    ApplyMovement obj_D35R0103_rkanbuw, _0CB4
    ApplyMovement obj_D35R0103_rocketm_4, _0CBA
    WaitMovement
    StartTagBattle TRAINER_HGSS_PKMN_TRAINER_LANCE_LANCE, TRAINER_HGSS_EXECUTIVE_ARIANA_ARIANA_2, TRAINER_HGSS_TEAM_ROCKET_GRUNT_25
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _099F
    Message msg_0113_D35R0103_00008
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetPosition obj_D35R0103_wataru, 28, 1, 24, DIR_SOUTH
    SetPosition obj_D35R0103_tsure_poke_static_dragonite, 27, 1, 24, DIR_EAST
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0CC0
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
    ApplyMovement obj_D35R0103_wataru, _0CD2
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0CD8
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00010, msg_0113_D35R0103_00011
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0CE2
    ApplyMovement obj_D35R0103_wataru, _0CEC
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0D16
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlayCry SPECIES_DRAGONITE, 0
    WaitCry
    ApplyMovement obj_D35R0103_wataru, _0D34
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0D42
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00012, msg_0113_D35R0103_00013
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0D4C
    ApplyMovement obj_D35R0103_wataru, _0D5E
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0D64
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
_0901:
    BlackOutFromBattle
    ReleaseAll
    End
_0907:
    ReleaseAll
    End
_090B:
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 16
    GoToIf 5, _09AD
    ApplyMovement LOCALID_PLAYER, _0D72
    GoTo _09C8
_0936:
    ReleaseAll
    End
_093A:
    ReleaseAll
    End
_093E:
    Message msg_0113_D35R0103_00022
    CloseMessage
    ReleaseAll
    End
_0947:
    End
_0949:
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _0947
    SetVarFromValue VAR_MAP_LOCAL_0x07, 77
    SetPosition obj_D35R0103_wataru, 39, 0, 18, DIR_NORTH
    SetPosition obj_D35R0103_tsure_poke_static_dragonite, 40, 0, 18, DIR_NORTH
    End
_0976:
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_097C:
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    GoToIf 5, _0AB8
    SetFlag FLAG_HGSS_UNK_96C
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_2
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_5
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_ELECTRODE_2_AND_5
    GoTo _0976
_099F:
    BlackOutFromBattle
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_ARIANA
    SetFlag FLAG_HGSS_UNK_1E5
    ReleaseAll
    End
_09AD:
    CompareVar VAR_MAP_LOCAL_0x01, 14
    GoToIf 5, _0ACE
    ApplyMovement LOCALID_PLAYER, _0D7C
    GoTo _09C8
_09C8:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D35R0103_wataru, _0D86
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0D8C
    WaitMovement
    Message msg_0113_D35R0103_00015
    SetVar VAR_0x8004, ITEM_HM05
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0113_D35R0103_00017
    CloseMessage
    ApplyMovement obj_D35R0103_wataru, _0D96
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00018, msg_0113_D35R0103_00019
    CloseMessage
    ApplyMovement obj_D35R0103_wataru, _0D9C
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0DA6
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
_0AB8:
    SetFlag FLAG_HGSS_UNK_96D
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_3
    RemoveObject obj_D35R0103_tsure_poke_static_electrode_6
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_ELECTRODE_3_AND_6
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_0ACE:
    ApplyMovement LOCALID_PLAYER, _0DB8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D35R0103_wataru, _0D86
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0D8C
    WaitMovement
    Message msg_0113_D35R0103_00015
    SetVar VAR_0x8004, ITEM_HM05
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0113_D35R0103_00017
    CloseMessage
    ApplyMovement obj_D35R0103_wataru, _0D96
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0113_D35R0103_00018, msg_0113_D35R0103_00019
    CloseMessage
    ApplyMovement obj_D35R0103_wataru, _0D9C
    ApplyMovement obj_D35R0103_tsure_poke_static_dragonite, _0DA6
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
_0BC6:
    WalkNormalEast 5
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_0BD0:
    WalkNormalEast 11
    EndMovement
    .balign 4, 0
_0BD6:
    Delay2
    WalkNormalEast 11
    EndMovement
    .balign 4, 0
_0BE0:
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_0BE6:
    FaceEast
    JumpOnSpotFastEast
    WalkFastEast 5
    EndMovement
    .balign 4, 0
_0BF4:
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_0BFA:
    FaceWest
    JumpOnSpotFastWest
    WalkFastWest 10
    EndMovement
    .balign 4, 0
_0C08:
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_0C0E:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0C14:
    Delay8
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0C1E:
    JumpOnSpotFastNorth 2
    FaceWest
    Delay8
    WalkFastWest 2
    JumpOnSpotFastWest 2
    WalkFastSouth
    WalkFastWest 10
    EndMovement
    .balign 4, 0
_0C3C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0C42:
    WalkNormalSouth 5
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0C4C:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0C52:
    EmoteExclamationMark
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0C5C:
    JumpOnSpotFastNorth 2
    FaceWest
    Delay8
    WalkFastWest 12
    EndMovement
    .balign 4, 0
_0C6E:
    WalkNormalSouth 2
    WalkNormalWest
    WalkNormalSouth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0C80:
    Delay8
    WalkFastNorth 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0C8E:
    Delay8 2
    WalkFastNorth 3
    EndMovement
    .balign 4, 0
_0C98:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0C9E:
    WalkFastEast 10
    EndMovement
    .balign 4, 0
_0CA4:
    Delay4
    WalkFastEast 10
    EndMovement
    .balign 4, 0
_0CAE:
    JumpOnSpotFastEast
    EndMovement
    .balign 4, 0
_0CB4:
    WalkFastWest
    EndMovement
    .balign 4, 0
_0CBA:
    WalkFastNorth
    EndMovement
    .balign 4, 0
_0CC0:
    WalkFastNorth 2
    WalkFastEast
    WalkFastSouth 2
    FaceWest
    EndMovement
    .balign 4, 0
_0CD2:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0CD8:
    Delay2
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0CE2:
    Delay8 4
    WalkNormalNorth 5
    EndMovement
    .balign 4, 0
_0CEC:
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
_0D16:
    Delay2
    WalkNormalEast
    WalkNormalNorth 5
    WalkNormalEast 8
    WalkNormalNorth
    Delay8 4
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_0D34:
    WalkNormalWest 2
    WalkOnSpotNormalSouth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0D42:
    Delay4
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0D4C:
    Delay2
    Delay8
    WalkNormalNorth
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0D5E:
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0D64:
    Delay2
    WalkNormalWest
    WalkNormalEast 5
    EndMovement
    .balign 4, 0
_0D72:
    WalkNormalSouth 2
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
_0D7C:
    WalkNormalSouth 4
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
_0D86:
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0D8C:
    Delay2
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0D96:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0D9C:
    WalkFastSouth 6
    WalkFastWest 12
    EndMovement
    .balign 4, 0
_0DA6:
    Delay4
    WalkFastWest
    WalkFastSouth 6
    WalkFastWest 12
    EndMovement
    .balign 4, 0
_0DB8:
    WalkNormalSouth 6
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
