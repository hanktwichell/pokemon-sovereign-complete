#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0119.h"

#define obj_D37R0104_gate0_left 6
#define obj_D37R0104_gate0_right 7
#define obj_D37R0104_gate1_left 8
#define obj_D37R0104_gate1_right 9
#define obj_D37R0104_gate2_top 10
#define obj_D37R0104_gate2_bottom 11
#define obj_D37R0104_gate3_top 12
#define obj_D37R0104_gate3_bottom 13
#define obj_D37R0104_gate4_left 14
#define obj_D37R0104_gate4_right 15
#define obj_D37R0104_gate5_left 16
#define obj_D37R0104_gate5_right 17
#define obj_D37R0104_gate6_left 18
#define obj_D37R0104_gate6_right 19
#define obj_D37R0104_gate7_top 20
#define obj_D37R0104_gate7_bottom 21
#define obj_D37R0104_gate8_top 22
#define obj_D37R0104_gate8_bottom 23
#define obj_D37R0104_gate9_top 24
#define obj_D37R0104_gate9_bottom 25
#define obj_D37R0104_purplegate_left 26
#define obj_D37R0104_purplegate_right 27
#define obj_D37R0104_gsrivel 28
#define obj_D37R0104_stop 29
#define obj_D37R0104_stop_2 30
#define obj_D37R0104_stop_3 31
#define obj_D37R0104_stop_4 32
#define obj_D37R0104_stop_5 33
#define obj_D37R0104_stop_6 34

    ScriptEntry scr_seq_D37R0104_000
    ScriptEntry scr_seq_D37R0104_001
    ScriptEntry scr_seq_D37R0104_002
    ScriptEntry scr_seq_D37R0104_003
    ScriptEntry scr_seq_D37R0104_004
    ScriptEntry scr_seq_D37R0104_005
    ScriptEntry scr_seq_D37R0104_006
    ScriptEntryEnd
scr_seq_D37R0104_006:
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0033
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
_0033:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    SetVarFromValue VAR_MAP_LOCAL_0x05, 0
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    SetVarFromValue VAR_MAP_LOCAL_0x08, 0
    SetVarFromValue VAR_MAP_LOCAL_0x09, 1
    End
scr_seq_D37R0104_005:
    ShowObject obj_D37R0104_stop_3
    ShowObject obj_D37R0104_stop_2
    ShowObject obj_D37R0104_stop
    ShowObject obj_D37R0104_stop_4
    ShowObject obj_D37R0104_stop_5
    ShowObject obj_D37R0104_stop_6
    GoToIfSet FLAG_HGSS_OPENED_GOLDENROD_PURPLE_GATE, _0096
    End
_0096:
    SetPosition obj_D37R0104_purplegate_left, 18, 0, 14, DIR_NORTH
    SetPosition obj_D37R0104_purplegate_right, 24, 0, 14, DIR_NORTH
    SetPosition obj_D37R0104_stop_6, 24, 0, 14, DIR_NORTH
    End
scr_seq_D37R0104_002:
    LockAll
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00F5
    ApplyMovement obj_D37R0104_gate1_left, _05CC
    ApplyMovement obj_D37R0104_gate1_right, _05D4
    ApplyMovement obj_D37R0104_stop_2, _060C
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    GoTo _0113
_00F5:
    ApplyMovement obj_D37R0104_gate1_left, _05DC
    ApplyMovement obj_D37R0104_gate1_right, _05E4
    ApplyMovement obj_D37R0104_stop_2, _0614
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
_0113:
    CompareVar VAR_MAP_LOCAL_0x03, 0
    GoToIf 5, _013C
    ApplyMovement obj_D37R0104_gate3_top, _05EC
    ApplyMovement obj_D37R0104_gate3_bottom, _05F4
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    GoTo _0152
_013C:
    ApplyMovement obj_D37R0104_gate3_top, _05FC
    ApplyMovement obj_D37R0104_gate3_bottom, _0604
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
_0152:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0183
    ApplyMovement obj_D37R0104_gate5_left, _05CC
    ApplyMovement obj_D37R0104_gate5_right, _05D4
    ApplyMovement obj_D37R0104_stop_4, _060C
    SetVarFromValue VAR_MAP_LOCAL_0x05, 1
    GoTo _01A1
_0183:
    ApplyMovement obj_D37R0104_gate5_left, _05DC
    ApplyMovement obj_D37R0104_gate5_right, _05E4
    ApplyMovement obj_D37R0104_stop_4, _0614
    SetVarFromValue VAR_MAP_LOCAL_0x05, 0
_01A1:
    CompareVar VAR_MAP_LOCAL_0x06, 0
    GoToIf 5, _01D2
    ApplyMovement obj_D37R0104_gate6_left, _05CC
    ApplyMovement obj_D37R0104_gate6_right, _05D4
    ApplyMovement obj_D37R0104_stop_5, _060C
    SetVarFromValue VAR_MAP_LOCAL_0x06, 1
    GoTo _01F0
_01D2:
    ApplyMovement obj_D37R0104_gate6_left, _05DC
    ApplyMovement obj_D37R0104_gate6_right, _05E4
    ApplyMovement obj_D37R0104_stop_5, _0614
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
_01F0:
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _0219
    ApplyMovement obj_D37R0104_gate7_top, _05EC
    ApplyMovement obj_D37R0104_gate7_bottom, _05F4
    SetVarFromValue VAR_MAP_LOCAL_0x07, 1
    GoTo _022F
_0219:
    ApplyMovement obj_D37R0104_gate7_top, _05FC
    ApplyMovement obj_D37R0104_gate7_bottom, _0604
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
_022F:
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _0258
    ApplyMovement obj_D37R0104_gate8_top, _05EC
    ApplyMovement obj_D37R0104_gate8_bottom, _05F4
    SetVarFromValue VAR_MAP_LOCAL_0x08, 1
    GoTo _026E
_0258:
    ApplyMovement obj_D37R0104_gate8_top, _05FC
    ApplyMovement obj_D37R0104_gate8_bottom, _0604
    SetVarFromValue VAR_MAP_LOCAL_0x08, 0
_026E:
    WaitMovement
    ReleaseAll
    End
scr_seq_D37R0104_001:
    LockAll
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _02AD
    ApplyMovement obj_D37R0104_gate0_left, _05CC
    ApplyMovement obj_D37R0104_gate0_right, _05D4
    ApplyMovement obj_D37R0104_stop_3, _060C
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    GoTo _02CB
_02AD:
    ApplyMovement obj_D37R0104_gate0_left, _05DC
    ApplyMovement obj_D37R0104_gate0_right, _05E4
    ApplyMovement obj_D37R0104_stop_3, _0614
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
_02CB:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _02F4
    ApplyMovement obj_D37R0104_gate2_top, _05EC
    ApplyMovement obj_D37R0104_gate2_bottom, _05F4
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    GoTo _030A
_02F4:
    ApplyMovement obj_D37R0104_gate2_top, _05FC
    ApplyMovement obj_D37R0104_gate2_bottom, _0604
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
_030A:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    GoToIf 5, _033B
    ApplyMovement obj_D37R0104_gate4_left, _05CC
    ApplyMovement obj_D37R0104_gate4_right, _05D4
    ApplyMovement obj_D37R0104_stop, _060C
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    GoTo _0359
_033B:
    ApplyMovement obj_D37R0104_gate4_left, _05DC
    ApplyMovement obj_D37R0104_gate4_right, _05E4
    ApplyMovement obj_D37R0104_stop, _0614
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
_0359:
    CompareVar VAR_MAP_LOCAL_0x06, 0
    GoToIf 5, _038A
    ApplyMovement obj_D37R0104_gate6_left, _05CC
    ApplyMovement obj_D37R0104_gate6_right, _05D4
    ApplyMovement obj_D37R0104_stop_5, _060C
    SetVarFromValue VAR_MAP_LOCAL_0x06, 1
    GoTo _03A8
_038A:
    ApplyMovement obj_D37R0104_gate6_left, _05DC
    ApplyMovement obj_D37R0104_gate6_right, _05E4
    ApplyMovement obj_D37R0104_stop_5, _0614
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
_03A8:
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _03D1
    ApplyMovement obj_D37R0104_gate8_top, _05EC
    ApplyMovement obj_D37R0104_gate8_bottom, _05F4
    SetVarFromValue VAR_MAP_LOCAL_0x08, 1
    GoTo _03E7
_03D1:
    ApplyMovement obj_D37R0104_gate8_top, _05FC
    ApplyMovement obj_D37R0104_gate8_bottom, _0604
    SetVarFromValue VAR_MAP_LOCAL_0x08, 0
_03E7:
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 5, _0410
    ApplyMovement obj_D37R0104_gate9_top, _05EC
    ApplyMovement obj_D37R0104_gate9_bottom, _05F4
    SetVarFromValue VAR_MAP_LOCAL_0x09, 1
    GoTo _0426
_0410:
    ApplyMovement obj_D37R0104_gate9_top, _05FC
    ApplyMovement obj_D37R0104_gate9_bottom, _0604
    SetVarFromValue VAR_MAP_LOCAL_0x09, 0
_0426:
    WaitMovement
    ReleaseAll
    End
scr_seq_D37R0104_000:
    LockAll
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _045D
    ApplyMovement obj_D37R0104_gate2_top, _05EC
    ApplyMovement obj_D37R0104_gate2_bottom, _05F4
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    GoTo _0473
_045D:
    ApplyMovement obj_D37R0104_gate2_top, _05FC
    ApplyMovement obj_D37R0104_gate2_bottom, _0604
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
_0473:
    CompareVar VAR_MAP_LOCAL_0x03, 0
    GoToIf 5, _049C
    ApplyMovement obj_D37R0104_gate3_top, _05EC
    ApplyMovement obj_D37R0104_gate3_bottom, _05F4
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    GoTo _04B2
_049C:
    ApplyMovement obj_D37R0104_gate3_top, _05FC
    ApplyMovement obj_D37R0104_gate3_bottom, _0604
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
_04B2:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    GoToIf 5, _04E3
    ApplyMovement obj_D37R0104_gate4_left, _05CC
    ApplyMovement obj_D37R0104_gate4_right, _05D4
    ApplyMovement obj_D37R0104_stop, _060C
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    GoTo _0501
_04E3:
    ApplyMovement obj_D37R0104_gate4_left, _05DC
    ApplyMovement obj_D37R0104_gate4_right, _05E4
    ApplyMovement obj_D37R0104_stop, _0614
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
_0501:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0532
    ApplyMovement obj_D37R0104_gate5_left, _05CC
    ApplyMovement obj_D37R0104_gate5_right, _05D4
    ApplyMovement obj_D37R0104_stop_4, _060C
    SetVarFromValue VAR_MAP_LOCAL_0x05, 1
    GoTo _0550
_0532:
    ApplyMovement obj_D37R0104_gate5_left, _05DC
    ApplyMovement obj_D37R0104_gate5_right, _05E4
    ApplyMovement obj_D37R0104_stop_4, _0614
    SetVarFromValue VAR_MAP_LOCAL_0x05, 0
_0550:
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _0579
    ApplyMovement obj_D37R0104_gate7_top, _05EC
    ApplyMovement obj_D37R0104_gate7_bottom, _05F4
    SetVarFromValue VAR_MAP_LOCAL_0x07, 1
    GoTo _058F
_0579:
    ApplyMovement obj_D37R0104_gate7_top, _05FC
    ApplyMovement obj_D37R0104_gate7_bottom, _0604
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
_058F:
    WaitMovement
    ReleaseAll
    End
scr_seq_D37R0104_003:
    GoToIfSet FLAG_HGSS_OPENED_GOLDENROD_PURPLE_GATE, _05CA
    LockAll
    ApplyMovement obj_D37R0104_purplegate_left, _05DC
    ApplyMovement obj_D37R0104_purplegate_right, _05E4
    ApplyMovement obj_D37R0104_stop_6, _0614
    WaitMovement
    SetFlag FLAG_HGSS_OPENED_GOLDENROD_PURPLE_GATE
    ReleaseAll
    End
_05CA:
    End
    .balign 4, 0
_05CC:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_05D4:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_05DC:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_05E4:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_05EC:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_05F4:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_05FC:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0604:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_060C:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0614:
    WalkNormalWest 2
    EndMovement
scr_seq_D37R0104_004:
    LockAll
    Common_SetRivalBGM
    SetPosition obj_D37R0104_gsrivel, 28, 0, 4, DIR_WEST
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D37R0104_gsrivel, _06E0
    ApplyMovement LOCALID_PLAYER, _06F4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferRivalName 0
    Message msg_0119_D37R0104_00000
    CloseMessage
    GetPlayerStarterSpecies VAR_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 5, _067D
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_18, 0
    GoTo _06A0
_067D:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _0698
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_12, 0
    GoTo _06A0
_0698:
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_17, 0
_06A0:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06D9
    Common_SetRivalBGM
    BufferRivalName 0
    Message msg_0119_D37R0104_00001
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_40A0, 1
    ApplyMovement obj_D37R0104_gsrivel, _0700
    WaitMovement
    RemoveObject obj_D37R0104_gsrivel
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
_06D9:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_06E0:
    Delay4 6
    WalkNormalWest 3
    WalkNormalSouth
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_06F4:
    EmoteExclamationMark
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0700:
    WalkNormalEast 4
    WalkNormalNorth
    WalkNormalEast 4
    EndMovement
    .balign 4, 0
