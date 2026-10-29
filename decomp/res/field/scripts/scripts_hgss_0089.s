#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0112.h"

#define obj_D35R0102_aji_peru 0
#define obj_D35R0102_rocketm 1
#define obj_D35R0102_aji_peru_2 2
#define obj_D35R0102_aji_peru_3 3
#define obj_D35R0102_aji_peru_4 4
#define obj_D35R0102_aji_peru_5 5

    ScriptEntry scr_seq_D35R0102_000
    ScriptEntry scr_seq_D35R0102_001
    ScriptEntry scr_seq_D35R0102_002
    ScriptEntry scr_seq_D35R0102_003
    ScriptEntry scr_seq_D35R0102_004
    ScriptEntry scr_seq_D35R0102_005
    ScriptEntry scr_seq_D35R0102_006
    ScriptEntry scr_seq_D35R0102_007
    ScriptEntry scr_seq_D35R0102_008
    ScriptEntry scr_seq_D35R0102_009
    ScriptEntry scr_seq_D35R0102_010
    ScriptEntry scr_seq_D35R0102_011
    ScriptEntry scr_seq_D35R0102_012
    ScriptEntry scr_seq_D35R0102_013
    ScriptEntry scr_seq_D35R0102_014
    ScriptEntry scr_seq_D35R0102_015
    ScriptEntry scr_seq_D35R0102_016
    ScriptEntry scr_seq_D35R0102_017
    ScriptEntry scr_seq_D35R0102_018
    ScriptEntry scr_seq_D35R0102_019
    ScriptEntry scr_seq_D35R0102_020
    ScriptEntry scr_seq_D35R0102_021
    ScriptEntry scr_seq_D35R0102_022
    ScriptEntry scr_seq_D35R0102_023
    ScriptEntry scr_seq_D35R0102_024
    ScriptEntry scr_seq_D35R0102_025
    ScriptEntry scr_seq_D35R0102_026
    ScriptEntry scr_seq_D35R0102_027
    ScriptEntry scr_seq_D35R0102_028
    ScriptEntry scr_seq_D35R0102_029
    ScriptEntry scr_seq_D35R0102_030
    ScriptEntry scr_seq_D35R0102_031
    ScriptEntry scr_seq_D35R0102_032
    ScriptEntryEnd
scr_seq_D35R0102_032:
    End
scr_seq_D35R0102_031:
    CompareVar VAR_HGSS_UNK_40AC, 4
    GoToIf 1, _00BE
    CompareVar VAR_HGSS_UNK_40AC, 5
    GoToIf 1, _00BE
    CompareVar VAR_HGSS_UNK_40AC, 6
    GoToIf 1, _00BE
    CompareVar VAR_HGSS_UNK_40AC, 7
    GoToIf 1, _00BE
    End
_00BE:
    SetVarFromValue VAR_HGSS_UNK_40AC, 8
    SetVarFromValue VAR_HGSS_UNK_40A9, 2
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_1
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_MURKROW_2
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_2
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_3
    End
scr_seq_D35R0102_030:
    CompareVar VAR_HGSS_UNK_40AC, 9
    CallIf 4, _025D
    CompareVar VAR_HGSS_UNK_40AD, 2
    GoToIf 5, _0108
    SetPosition obj_D35R0102_aji_peru, 44, 0, 3, DIR_WEST
    GoTo _0133
_0108:
    CompareVar VAR_HGSS_UNK_40AD, 1
    GoToIf 5, _0127
    SetPosition obj_D35R0102_aji_peru, 44, 0, 3, DIR_SOUTH
    GoTo _0133
_0127:
    SetPosition obj_D35R0102_aji_peru, 44, 0, 3, DIR_NORTH
_0133:
    CompareVar VAR_HGSS_UNK_40AE, 2
    GoToIf 5, _0152
    SetPosition obj_D35R0102_aji_peru_2, 18, 0, 3, DIR_WEST
    GoTo _017D
_0152:
    CompareVar VAR_HGSS_UNK_40AE, 1
    GoToIf 5, _0171
    SetPosition obj_D35R0102_aji_peru_2, 18, 0, 3, DIR_SOUTH
    GoTo _017D
_0171:
    SetPosition obj_D35R0102_aji_peru_2, 18, 0, 3, DIR_NORTH
_017D:
    CompareVar VAR_HGSS_UNK_40AF, 2
    GoToIf 5, _019C
    SetPosition obj_D35R0102_aji_peru_3, 44, 0, 10, DIR_WEST
    GoTo _01C7
_019C:
    CompareVar VAR_HGSS_UNK_40AF, 1
    GoToIf 5, _01BB
    SetPosition obj_D35R0102_aji_peru_3, 44, 0, 10, DIR_SOUTH
    GoTo _01C7
_01BB:
    SetPosition obj_D35R0102_aji_peru_3, 44, 0, 10, DIR_NORTH
_01C7:
    CompareVar VAR_HGSS_UNK_40B0, 2
    GoToIf 5, _01E6
    SetPosition obj_D35R0102_aji_peru_4, 44, 0, 28, DIR_WEST
    GoTo _0211
_01E6:
    CompareVar VAR_HGSS_UNK_40B0, 1
    GoToIf 5, _0205
    SetPosition obj_D35R0102_aji_peru_4, 44, 0, 28, DIR_SOUTH
    GoTo _0211
_0205:
    SetPosition obj_D35R0102_aji_peru_4, 44, 0, 28, DIR_NORTH
_0211:
    CompareVar VAR_HGSS_UNK_40B1, 2
    GoToIf 5, _0230
    SetPosition obj_D35R0102_aji_peru_5, 18, 0, 28, DIR_WEST
    GoTo _025B
_0230:
    CompareVar VAR_HGSS_UNK_40B1, 1
    GoToIf 5, _024F
    SetPosition obj_D35R0102_aji_peru_5, 18, 0, 28, DIR_SOUTH
    GoTo _025B
_024F:
    SetPosition obj_D35R0102_aji_peru_5, 18, 0, 28, DIR_NORTH
_025B:
    End
_025D:
    SetVarFromValue VAR_HGSS_UNK_40AD, 2
    SetVarFromValue VAR_HGSS_UNK_40AE, 2
    SetVarFromValue VAR_HGSS_UNK_40AF, 2
    SetVarFromValue VAR_HGSS_UNK_40B0, 2
    SetVarFromValue VAR_HGSS_UNK_40B1, 2
    Return
scr_seq_D35R0102_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0428
    WaitMovement
    ApplyMovement obj_D35R0102_aji_peru, _0454
    WaitMovement
    @ HGSS: ScrCmd_709
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 5, _02C4
    AddVar VAR_MAP_LOCAL_0x01, 1
    GoTo _02D0
_02BE:
    GoTo _02D0
_02C4:
    SubVar VAR_MAP_LOCAL_0x01, 1
    GoTo _036C
_02D0:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 33, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _0460
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0478
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _0490
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_EAST
    ApplyMovement obj_D35R0102_rocketm, _0460
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _0490
    WaitMovement
    GoTo _0402
_036C:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 33, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _046C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0484
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _0490
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_EAST
    ApplyMovement obj_D35R0102_rocketm, _046C
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _0490
    WaitMovement
_0402:
    SetPosition obj_D35R0102_rocketm, 37, 0, 0, DIR_WEST
    SetFlag FLAG_HGSS_UNK_1E8
    SetVarFromValue VAR_HGSS_UNK_40AD, 2
    ApplyMovement obj_D35R0102_aji_peru, _049C
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0428:
    EmoteExclamationMark
    Delay8 2
    FaceEast 2
    Delay8
    FaceWest 2
    Delay8
    FaceEast 2
    Delay8
    FaceNorth 2
    Delay8
    EndMovement
    .balign 4, 0
_0454:
    EmoteExclamationMark
    Delay8 2
    EndMovement
    .balign 4, 0
_0460:
    WalkFasterEast 11
    FaceNorth 2
    EndMovement
    .balign 4, 0
_046C:
    WalkFasterEast 11
    FaceSouth 2
    EndMovement
    .balign 4, 0
_0478:
    FaceSouth 2
    Delay8 2
    EndMovement
    .balign 4, 0
_0484:
    FaceNorth 2
    Delay8 2
    EndMovement
    .balign 4, 0
_0490:
    FaceWest 2
    WalkFasterWest 10
    EndMovement
    .balign 4, 0
_049C:
    FaceWest
    EndMovement
    .balign 4, 0
_04A4:
    FaceSouth
    EndMovement
    .balign 4, 0
_04AC:
    FaceNorth
    EndMovement
scr_seq_D35R0102_005:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0428
    WaitMovement
    ApplyMovement obj_D35R0102_aji_peru_2, _0454
    WaitMovement
    @ HGSS: ScrCmd_709
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 5, _04F7
    AddVar VAR_MAP_LOCAL_0x01, 1
    GoTo _0503
_04F1:
    GoTo _0503
_04F7:
    SubVar VAR_MAP_LOCAL_0x01, 1
    GoTo _05A9
_0503:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 27, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 27, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _0668
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0478
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06C8
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 27, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _0668
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0478
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06C8
    WaitMovement
    GoTo _0649
_05A9:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 27, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 27, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _0674
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0484
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06C8
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 27, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _0674
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0484
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06C8
    WaitMovement
_0649:
    RemoveObject obj_D35R0102_rocketm
    SetFlag FLAG_HGSS_UNK_1E8
    SetVarFromValue VAR_HGSS_UNK_40AE, 2
    ApplyMovement obj_D35R0102_aji_peru_2, _049C
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0668:
    WalkFasterWest 9
    FaceNorth 2
    EndMovement
    .balign 4, 0
_0674:
    WalkFasterWest 9
    FaceSouth 2
    EndMovement
    .balign 4, 0
_0680:
    WalkFasterEast 11
    FaceNorth 2
    EndMovement
    .balign 4, 0
_068C:
    WalkFasterEast 11
    FaceSouth 2
    EndMovement
    .balign 4, 0
_0698:
    WalkFasterEast 11
    FaceNorth 2
    EndMovement
    .balign 4, 0
_06A4:
    WalkFasterEast 11
    FaceSouth 2
    EndMovement
    .balign 4, 0
_06B0:
    WalkFasterWest 9
    FaceNorth 2
    EndMovement
    .balign 4, 0
_06BC:
    WalkFasterWest 9
    FaceSouth 2
    EndMovement
    .balign 4, 0
_06C8:
    FaceEast 2
    WalkFasterEast 10
    EndMovement
    .balign 4, 0
_06D4:
    FaceWest 2
    WalkFasterWest 10
    EndMovement
    .balign 4, 0
_06E0:
    FaceWest 2
    WalkFasterWest 10
    EndMovement
    .balign 4, 0
_06EC:
    FaceEast 2
    WalkFasterEast 10
    EndMovement
scr_seq_D35R0102_006:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0428
    WaitMovement
    ApplyMovement obj_D35R0102_aji_peru_3, _0454
    WaitMovement
    @ HGSS: ScrCmd_709
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 11
    GoToIf 5, _073B
    AddVar VAR_MAP_LOCAL_0x01, 1
    GoTo _0747
_0735:
    GoTo _0747
_073B:
    SubVar VAR_MAP_LOCAL_0x01, 1
    GoTo _07ED
_0747:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 33, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _0680
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0478
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06D4
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _0680
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0478
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06D4
    WaitMovement
    GoTo _088D
_07ED:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 33, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _068C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0484
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06D4
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _068C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0484
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06D4
    WaitMovement
_088D:
    RemoveObject obj_D35R0102_rocketm
    SetFlag FLAG_HGSS_UNK_1E8
    SetVarFromValue VAR_HGSS_UNK_40AF, 2
    ApplyMovement obj_D35R0102_aji_peru_3, _049C
    WaitMovement
    ReleaseAll
    End
scr_seq_D35R0102_007:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0428
    WaitMovement
    ApplyMovement obj_D35R0102_aji_peru_4, _0454
    WaitMovement
    @ HGSS: ScrCmd_709
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 29
    GoToIf 5, _08EC
    AddVar VAR_MAP_LOCAL_0x01, 1
    GoTo _08F8
_08E6:
    GoTo _08F8
_08EC:
    SubVar VAR_MAP_LOCAL_0x01, 1
    GoTo _099E
_08F8:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 33, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _0698
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0478
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06E0
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _0698
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0478
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06E0
    WaitMovement
    GoTo _0A3E
_099E:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 33, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _06A4
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0484
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06E0
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _06A4
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0484
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06E0
    WaitMovement
_0A3E:
    RemoveObject obj_D35R0102_rocketm
    SetVarFromValue VAR_HGSS_UNK_40B0, 2
    ApplyMovement obj_D35R0102_aji_peru_4, _049C
    WaitMovement
    ReleaseAll
    End
scr_seq_D35R0102_008:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0428
    WaitMovement
    ApplyMovement obj_D35R0102_aji_peru_5, _0454
    WaitMovement
    @ HGSS: ScrCmd_709
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 29
    GoToIf 5, _0A99
    AddVar VAR_MAP_LOCAL_0x01, 1
    GoTo _0AA5
_0A93:
    GoTo _0AA5
_0A99:
    SubVar VAR_MAP_LOCAL_0x01, 1
    GoTo _0B4B
_0AA5:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 27, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 27, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _06B0
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0478
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06EC
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 27, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _06B0
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0478
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06EC
    WaitMovement
    GoTo _0BEB
_0B4B:
    @ HGSS: MovePerson obj_D35R0102_rocketm, 27, 0
    ClearFlag FLAG_HGSS_UNK_1E8
    AddObject obj_D35R0102_rocketm
    SetPosition obj_D35R0102_rocketm, 27, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _06BC
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0484
    WaitMovement
    Message msg_0112_D35R0102_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_20, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06EC
    WaitMovement
    SetPosition obj_D35R0102_rocketm, 27, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_D35R0102_rocketm, _06BC
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0484
    WaitMovement
    Message msg_0112_D35R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_21, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    ApplyMovement obj_D35R0102_rocketm, _06EC
    WaitMovement
_0BEB:
    RemoveObject obj_D35R0102_rocketm
    SetVarFromValue VAR_HGSS_UNK_40B1, 2
    ApplyMovement obj_D35R0102_aji_peru_5, _049C
    WaitMovement
    ReleaseAll
    End
_0C03:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_D35R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CompareVar VAR_HGSS_UNK_40AD, 0
    GoToIf 5, _0C2B
    Message msg_0112_D35R0102_00002
    GoTo _0C4A
_0C25:
    GoTo _0C4A
_0C2B:
    CompareVar VAR_HGSS_UNK_40AD, 1
    GoToIf 5, _0C47
    Message msg_0112_D35R0102_00003
    GoTo _0C4A
_0C41:
    GoTo _0C4A
_0C47:
    Message msg_0112_D35R0102_00004
_0C4A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D35R0102_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CompareVar VAR_HGSS_UNK_40AE, 0
    GoToIf 5, _0C74
    Message msg_0112_D35R0102_00002
    GoTo _0C4A
_0C6E:
    GoTo _0C93
_0C74:
    CompareVar VAR_HGSS_UNK_40AE, 1
    GoToIf 5, _0C90
    Message msg_0112_D35R0102_00003
    GoTo _0C4A
_0C8A:
    GoTo _0C93
_0C90:
    Message msg_0112_D35R0102_00004
_0C93:
    GoTo _0C4A
scr_seq_D35R0102_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CompareVar VAR_HGSS_UNK_40AF, 0
    GoToIf 5, _0CBB
    Message msg_0112_D35R0102_00002
    GoTo _0C4A
_0CB5:
    GoTo _0CDA
_0CBB:
    CompareVar VAR_HGSS_UNK_40AF, 1
    GoToIf 5, _0CD7
    Message msg_0112_D35R0102_00003
    GoTo _0C4A
_0CD1:
    GoTo _0CDA
_0CD7:
    Message msg_0112_D35R0102_00004
_0CDA:
    GoTo _0C4A
scr_seq_D35R0102_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CompareVar VAR_HGSS_UNK_40B0, 0
    GoToIf 5, _0D02
    Message msg_0112_D35R0102_00002
    GoTo _0C4A
_0CFC:
    GoTo _0D21
_0D02:
    CompareVar VAR_HGSS_UNK_40B0, 1
    GoToIf 5, _0D1E
    Message msg_0112_D35R0102_00003
    GoTo _0C4A
_0D08:
    GoTo _0D21
_0D1E:
    Message msg_0112_D35R0102_00004
_0D21:
    GoTo _0C4A
scr_seq_D35R0102_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CompareVar VAR_HGSS_UNK_40B1, 0
    GoToIf 5, _0D49
    Message msg_0112_D35R0102_00002
    GoTo _0C4A
_0D43:
    GoTo _0D68
_0D49:
    CompareVar VAR_HGSS_UNK_40B1, 1
    GoToIf 5, _0D65
    Message msg_0112_D35R0102_00003
    GoTo _0C4A
_0D5F:
    GoTo _0D68
_0D65:
    Message msg_0112_D35R0102_00004
_0D68:
    GoTo _0C4A
scr_seq_D35R0102_002:
    End
scr_seq_D35R0102_003:
    End
scr_seq_D35R0102_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40AC, 9
    GoToIf 4, _0F24
    GoToIfSet FLAG_HGSS_UNK_0D6, _0E58
    Message msg_0112_D35R0102_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0DB7
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F1E
_0DB7:
    PlaySE SEQ_SE_DP_DENSI01_sseq
    Message msg_0112_D35R0102_00007
    CloseMessage
    SetFlag FLAG_HGSS_UNK_0D6
    CompareVar VAR_HGSS_UNK_40AD, 2
    GoToIf 4, _0DDF
    SetVarFromValue VAR_HGSS_UNK_40AD, 1
    ApplyMovement obj_D35R0102_aji_peru, _04A4
_0DDF:
    CompareVar VAR_HGSS_UNK_40AE, 2
    GoToIf 4, _0DFA
    SetVarFromValue VAR_HGSS_UNK_40AE, 1
    ApplyMovement obj_D35R0102_aji_peru_2, _04A4
_0DFA:
    CompareVar VAR_HGSS_UNK_40AF, 2
    GoToIf 4, _0E15
    SetVarFromValue VAR_HGSS_UNK_40AF, 1
    ApplyMovement obj_D35R0102_aji_peru_3, _04A4
_0E15:
    CompareVar VAR_HGSS_UNK_40B0, 2
    GoToIf 4, _0E30
    SetVarFromValue VAR_HGSS_UNK_40B0, 1
    ApplyMovement obj_D35R0102_aji_peru_4, _04A4
_0E30:
    CompareVar VAR_HGSS_UNK_40B1, 2
    GoToIf 4, _0E4D
    SetVarFromValue VAR_HGSS_UNK_40B1, 1
    ApplyMovement obj_D35R0102_aji_peru_5, _04A4
    WaitMovement
_0E4D:
    Message msg_0112_D35R0102_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0E58:
    Message msg_0112_D35R0102_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0E7D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F1E
_0E7D:
    PlaySE SEQ_SE_DP_DENSI01_sseq
    Message msg_0112_D35R0102_00007
    CloseMessage
    ClearFlag FLAG_HGSS_UNK_0D6
    CompareVar VAR_HGSS_UNK_40AD, 2
    GoToIf 4, _0EA5
    SetVarFromValue VAR_HGSS_UNK_40AD, 0
    ApplyMovement obj_D35R0102_aji_peru, _04AC
_0EA5:
    CompareVar VAR_HGSS_UNK_40AE, 2
    GoToIf 4, _0EC0
    SetVarFromValue VAR_HGSS_UNK_40AE, 0
    ApplyMovement obj_D35R0102_aji_peru_2, _04AC
_0EC0:
    CompareVar VAR_HGSS_UNK_40AF, 2
    GoToIf 4, _0EDB
    SetVarFromValue VAR_HGSS_UNK_40AF, 0
    ApplyMovement obj_D35R0102_aji_peru_3, _04AC
_0EDB:
    CompareVar VAR_HGSS_UNK_40B0, 2
    GoToIf 4, _0EF6
    SetVarFromValue VAR_HGSS_UNK_40B0, 0
    ApplyMovement obj_D35R0102_aji_peru_4, _04AC
_0EF6:
    CompareVar VAR_HGSS_UNK_40B1, 2
    GoToIf 4, _0F13
    SetVarFromValue VAR_HGSS_UNK_40B1, 0
    ApplyMovement obj_D35R0102_aji_peru_5, _04AC
    WaitMovement
_0F13:
    Message msg_0112_D35R0102_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0F1E:
    CloseMessage
    ReleaseAll
    End
_0F24:
    Message msg_0112_D35R0102_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D35R0102_013:
    LockAll
    @ HGSS: ScrCmd_708 1
    @ HGSS: RocketTrapBattle SPECIES_KOFFING, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_1, 1
    ReleaseAll
    End
scr_seq_D35R0102_014:
    LockAll
    @ HGSS: ScrCmd_708 0
    @ HGSS: RocketTrapBattle SPECIES_VOLTORB, 23
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_1, 1
    ReleaseAll
    End
scr_seq_D35R0102_015:
    LockAll
    @ HGSS: ScrCmd_708 2
    @ HGSS: RocketTrapBattle SPECIES_GEODUDE, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_1, 1
    ReleaseAll
    End
scr_seq_D35R0102_016:
    LockAll
    @ HGSS: ScrCmd_708 0
    @ HGSS: RocketTrapBattle SPECIES_VOLTORB, 23
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_2, 1
    ReleaseAll
    End
scr_seq_D35R0102_017:
    LockAll
    @ HGSS: ScrCmd_708 2
    @ HGSS: RocketTrapBattle SPECIES_GEODUDE, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_2, 1
    ReleaseAll
    End
scr_seq_D35R0102_018:
    LockAll
    @ HGSS: ScrCmd_708 0
    @ HGSS: RocketTrapBattle SPECIES_VOLTORB, 23
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_3, 1
    ReleaseAll
    End
scr_seq_D35R0102_019:
    LockAll
    @ HGSS: ScrCmd_708 0
    @ HGSS: RocketTrapBattle SPECIES_VOLTORB, 23
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_4, 1
    ReleaseAll
    End
scr_seq_D35R0102_020:
    LockAll
    @ HGSS: ScrCmd_708 1
    @ HGSS: RocketTrapBattle SPECIES_KOFFING, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_2, 1
    ReleaseAll
    End
scr_seq_D35R0102_021:
    LockAll
    @ HGSS: ScrCmd_708 1
    @ HGSS: RocketTrapBattle SPECIES_KOFFING, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_3, 1
    ReleaseAll
    End
scr_seq_D35R0102_022:
    LockAll
    @ HGSS: ScrCmd_708 2
    @ HGSS: RocketTrapBattle SPECIES_GEODUDE, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_3, 1
    ReleaseAll
    End
scr_seq_D35R0102_023:
    LockAll
    @ HGSS: ScrCmd_708 2
    @ HGSS: RocketTrapBattle SPECIES_GEODUDE, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_4, 1
    ReleaseAll
    End
scr_seq_D35R0102_024:
    LockAll
    @ HGSS: ScrCmd_708 1
    @ HGSS: RocketTrapBattle SPECIES_KOFFING, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_4, 1
    ReleaseAll
    End
scr_seq_D35R0102_025:
    LockAll
    @ HGSS: ScrCmd_708 0
    @ HGSS: RocketTrapBattle SPECIES_VOLTORB, 23
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_5, 1
    ReleaseAll
    End
scr_seq_D35R0102_026:
    LockAll
    @ HGSS: ScrCmd_708 0
    @ HGSS: RocketTrapBattle SPECIES_VOLTORB, 23
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_VOLTORB_6, 1
    ReleaseAll
    End
scr_seq_D35R0102_027:
    LockAll
    @ HGSS: ScrCmd_708 1
    @ HGSS: RocketTrapBattle SPECIES_KOFFING, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_KOFFING_5, 1
    ReleaseAll
    End
scr_seq_D35R0102_028:
    LockAll
    @ HGSS: ScrCmd_708 2
    @ HGSS: RocketTrapBattle SPECIES_GEODUDE, 21
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11FF
    SetVarFromValue VAR_HGSS_ROCKET_TRAP_GEODUDE_5, 1
    ReleaseAll
    End
_11FF:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_D35R0102_029:
    LockAll
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 15, VAR_RESULT
    Warp MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B1F, 50, 4, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
