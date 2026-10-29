#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0618.h"

#define obj_T27R0501_gsgentleman 2
#define obj_T27R0501_dancer 4
#define obj_T27R0501_dancer_2 5
#define obj_T27R0501_dancer_3 6
#define obj_T27R0501_dancer_4 7
#define obj_T27R0501_dancer_5 8
#define obj_T27R0501_rocketm 9
#define obj_T27R0501_dancer_6 10
#define obj_T27R0501_gsbabygirl1 11
#define obj_T27R0501_rocketm_2 12

    ScriptEntry scr_seq_T27R0501_000
    ScriptEntry scr_seq_T27R0501_001
    ScriptEntry scr_seq_T27R0501_002
    ScriptEntry scr_seq_T27R0501_003
    ScriptEntry scr_seq_T27R0501_004
    ScriptEntry scr_seq_T27R0501_005
    ScriptEntry scr_seq_T27R0501_006
    ScriptEntry scr_seq_T27R0501_007
    ScriptEntry scr_seq_T27R0501_008
    ScriptEntry scr_seq_T27R0501_009
    ScriptEntry scr_seq_T27R0501_010
    ScriptEntry scr_seq_T27R0501_011
    ScriptEntry scr_seq_T27R0501_012
    ScriptEntry scr_seq_T27R0501_013
    ScriptEntry scr_seq_T27R0501_014
    ScriptEntry scr_seq_T27R0501_015
    ScriptEntry scr_seq_T27R0501_016
    ScriptEntryEnd
scr_seq_T27R0501_013:
    CompareVar VAR_HGSS_UNK_410C, 1
    GoToIf 2, _046D
    ShowObject obj_T27R0501_rocketm_2
    CompareVar VAR_HGSS_UNK_410C, 0
    GoToIf 5, _04D2
    SetPosition obj_T27R0501_rocketm, 6, 0, 6, DIR_EAST
    SetPosition obj_T27R0501_dancer_3, 8, 0, 6, DIR_WEST
    CompareVar VAR_MAP_LOCAL_0x09, 222
    GoToIf 5, _0512
    SetPosition obj_T27R0501_rocketm, 29, 0, 29, DIR_SOUTH
    ShowObject obj_T27R0501_rocketm
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _053A
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_SOUTH
    GoTo _0559
scr_seq_T27R0501_015:
    LockAll
    Message msg_0618_T27R0501_00000
    CloseMessage
    ApplyMovement obj_T27R0501_rocketm, _1074
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    @ HGSS: ScrCmd_102 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    ApplyMovement 241, _107A
    WaitMovement
    WaitTime 10, VAR_RESULT
    ApplyMovement obj_T27R0501_rocketm, _1080
    WaitMovement
    Message msg_0618_T27R0501_00001
    CloseMessage
    ApplyMovement obj_T27R0501_dancer_3, _1086
    WaitMovement
    Message msg_0618_T27R0501_00002
    CloseMessage
    ApplyMovement obj_T27R0501_rocketm, _108C
    WaitMovement
    Message msg_0618_T27R0501_00003
    CloseMessage
    ApplyMovement obj_T27R0501_dancer_3, _1092
    WaitMovement
    Message msg_0618_T27R0501_00004
    CloseMessage
    ApplyMovement obj_T27R0501_rocketm, _10A0
    WaitMovement
    ApplyMovement obj_T27R0501_rocketm, _10A6
    ApplyMovement 241, _1180
    WaitMovement
    @ HGSS: ScrCmd_103
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_410C, 1
    End
scr_seq_T27R0501_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    Message msg_0618_T27R0501_00005
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x09, 222
    StartTrainerBattle TRAINER_HGSS_TEAM_ROCKET_GRUNT_26, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _058B
    Message msg_0618_T27R0501_00006
    CloseMessage
    GetPlayerDir VAR_0x8004
    CompareVar VAR_0x8004, 0
    GoToIf 5, _0591
    ApplyMovement obj_T27R0501_rocketm_2, _118A
    GoTo _05AC
scr_seq_T27R0501_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_410C, 1
    GoToIf 1, _05CE
    CompareVar VAR_MAP_LOCAL_0x0A, 10
    GoToIf 1, _05D9
    Message msg_0618_T27R0501_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_011:
    LockAll
    ApplyMovement obj_T27R0501_gsgentleman, _1198
    WaitMovement
    Message msg_0618_T27R0501_00026
    SetVar VAR_0x8004, ITEM_HM03
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _05E7
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HM03
    SetVarFromValue VAR_HGSS_UNK_410C, 3
    SetVarFromValue VAR_HGSS_UNK_4090, 1
    Message msg_0618_T27R0501_00028
    CloseMessage
    ApplyMovement obj_T27R0501_gsgentleman, _11A6
    WaitMovement
    ReleaseAll
    End
scr_seq_T27R0501_012:
    LockAll
    ApplyMovement obj_T27R0501_gsgentleman, _11B8
    WaitMovement
    Message msg_0618_T27R0501_00026
    SetVar VAR_0x8004, ITEM_HM03
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _05E7
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HM03
    SetVarFromValue VAR_HGSS_UNK_4090, 1
    SetVarFromValue VAR_HGSS_UNK_410C, 3
    Message msg_0618_T27R0501_00028
    CloseMessage
    ApplyMovement obj_T27R0501_gsgentleman, _11C6
    WaitMovement
    ReleaseAll
    End
scr_seq_T27R0501_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_HM03, _05F1
    Message msg_0618_T27R0501_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_PSYDUCK, 0
    Message msg_0618_T27R0501_00030
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x0A, 10
    GoToIf 1, _05FC
    CompareVar VAR_HGSS_UNK_410C, 1
    GoToIf 1, _0607
    Message msg_0618_T27R0501_00031
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x0A, 10
    GoToIf 1, _061D
    CompareVar VAR_HGSS_UNK_410C, 1
    GoToIf 1, _0628
    Message msg_0618_T27R0501_00036
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_010:
    NPCMessage msg_0618_T27R0501_00039
    End
scr_seq_T27R0501_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _0633
    GoToIfSet FLAG_HGSS_UNK_109, _0633
    Message msg_0618_T27R0501_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _063E
    GoToIfSet FLAG_HGSS_UNK_109, _063E
    Message msg_0618_T27R0501_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_0x8000, 77
    GoToIfSet FLAG_HGSS_UNK_108, _0649
    GoToIfSet FLAG_HGSS_UNK_109, _0649
    Message msg_0618_T27R0501_00013
    ShowYesNoMenu VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 1, _065B
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    CallIf 5, _066A
    GoTo _068F
scr_seq_T27R0501_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _0863
    GoToIfSet FLAG_HGSS_UNK_109, _0863
    Message msg_0618_T27R0501_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _086E
    GoToIfSet FLAG_HGSS_UNK_109, _086E
    Message msg_0618_T27R0501_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_016:
    LockAll
    SetVarFromValue VAR_0x8000, 11
    SetVarFromValue VAR_HGSS_UNK_410C, 5
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _11D8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0879
    Message msg_0618_T27R0501_00011
    GoTo _0A67
_046D:
    CompareVar VAR_HGSS_UNK_410C, 0
    GoToIf 5, _04D2
    SetPosition obj_T27R0501_rocketm, 6, 0, 6, DIR_EAST
    SetPosition obj_T27R0501_dancer_3, 8, 0, 6, DIR_WEST
    CompareVar VAR_MAP_LOCAL_0x09, 222
    GoToIf 5, _0512
    SetPosition obj_T27R0501_rocketm, 29, 0, 29, DIR_SOUTH
    ShowObject obj_T27R0501_rocketm
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _053A
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_SOUTH
    GoTo _0559
_04D2:
    CompareVar VAR_MAP_LOCAL_0x09, 222
    GoToIf 5, _0512
    SetPosition obj_T27R0501_rocketm, 29, 0, 29, DIR_SOUTH
    ShowObject obj_T27R0501_rocketm
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _053A
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_SOUTH
    GoTo _0559
_0512:
    CompareVar VAR_MAP_LOCAL_0x0A, 10
    GoToIf 1, _0C52
    CompareVar VAR_HGSS_UNK_410C, 3
    GoToIf 5, _0C52
    SetPosition obj_T27R0501_dancer_3, 7, 0, 6, DIR_SOUTH
    End
_053A:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0C54
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_NORTH
    GoTo _0559
_0559:
    @ HGSS: ScrCmd_374 obj_T27R0501_rocketm_2
    SetVarFromValue VAR_MAP_LOCAL_0x09, 0
    CompareVar VAR_MAP_LOCAL_0x0A, 10
    GoToIf 1, _0C52
    CompareVar VAR_HGSS_UNK_410C, 3
    GoToIf 5, _0C52
    SetPosition obj_T27R0501_dancer_3, 7, 0, 6, DIR_SOUTH
    End
_058B:
    BlackOutFromBattle
    ReleaseAll
    End
_0591:
    CompareVar VAR_0x8004, 1
    GoToIf 5, _0C73
    ApplyMovement obj_T27R0501_rocketm_2, _11EE
    GoTo _05AC
_05AC:
    WaitMovement
    Message msg_0618_T27R0501_00007
    CloseMessage
    CompareVar VAR_0x8004, 0
    GoToIf 5, _0C8E
    ApplyMovement obj_T27R0501_rocketm_2, _11FC
    GoTo _0CA9
_05CE:
    Message msg_0618_T27R0501_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05D9:
    BufferPlayerName 0
    Message msg_0618_T27R0501_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05E7:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_05F1:
    Message msg_0618_T27R0501_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05FC:
    Message msg_0618_T27R0501_00033
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0607:
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _0CC3
    Message msg_0618_T27R0501_00032
    GoTo _0CD9
_061D:
    Message msg_0618_T27R0501_00038
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0628:
    Message msg_0618_T27R0501_00037
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0633:
    Message msg_0618_T27R0501_00040
    WaitButton
    CloseMessage
    ReleaseAll
    End
_063E:
    Message msg_0618_T27R0501_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0649:
    BufferPlayerName 0
    Message msg_0618_T27R0501_00042
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_107
    ReleaseAll
    End
_065B:
    Message msg_0618_T27R0501_00014
    WaitButton
    CloseMessage
    Call _0CF8
    End
_066A:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0D0D
    ApplyMovement LOCALID_PLAYER, _1206
    GoTo _0D28
_068F:
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_6, _1218
    WaitMovement
    Message msg_0618_T27R0501_00045
    CloseMessage
    WaitTime 10, VAR_RESULT
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_ZUKI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_6, _1256
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer, _1260
    WaitMovement
    Message msg_0618_T27R0501_00015
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_NAOKO, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer, _128E
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement 13, _140C
    WaitMovement
    Message msg_0618_T27R0501_00046
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_TEAM_ROCKET_MICKEY_4, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement 13, _143A
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement 14, _1448
    WaitMovement
    Message msg_0618_T27R0501_00047
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_TEAM_ROCKET_MICKEY_5, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement 14, _1476
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_5, _1298
    WaitMovement
    Message msg_0618_T27R0501_00016
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_MIKI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_5, _12C6
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_2, _12D0
    WaitMovement
    Message msg_0618_T27R0501_00017
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_SAYO, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_2, _12FA
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_4, _1308
    WaitMovement
    Message msg_0618_T27R0501_00018
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_KUNI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_4, _1332
    WaitMovement
    ApplyMovement obj_T27R0501_dancer_6, _1340
    WaitMovement
    Message msg_0618_T27R0501_00020
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0D48
    SetVar VAR_0x8004, ITEM_CLEAR_BELL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_103
    GoTo _0DA6
_0863:
    Message msg_0618_T27R0501_00043
    WaitButton
    CloseMessage
    ReleaseAll
    End
_086E:
    Message msg_0618_T27R0501_00044
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0879:
    Message msg_0618_T27R0501_00012
    ShowYesNoMenu VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 1, _065B
    CloseMessage
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_6, _1218
    WaitMovement
    Message msg_0618_T27R0501_00045
    CloseMessage
    WaitTime 10, VAR_RESULT
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_ZUKI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_6, _1256
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer, _1260
    WaitMovement
    Message msg_0618_T27R0501_00015
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_NAOKO, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer, _128E
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement 13, _140C
    WaitMovement
    Message msg_0618_T27R0501_00046
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_TEAM_ROCKET_MICKEY_4, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement 13, _143A
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement 14, _1448
    WaitMovement
    Message msg_0618_T27R0501_00047
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_TEAM_ROCKET_MICKEY_5, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement 14, _1476
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_5, _1298
    WaitMovement
    Message msg_0618_T27R0501_00016
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_MIKI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_5, _12C6
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_2, _12D0
    WaitMovement
    Message msg_0618_T27R0501_00017
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_SAYO, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_2, _12FA
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_4, _1308
    WaitMovement
    Message msg_0618_T27R0501_00018
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_KUNI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_4, _1332
    WaitMovement
    ApplyMovement obj_T27R0501_dancer_6, _1340
    WaitMovement
    Message msg_0618_T27R0501_00020
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0D48
    SetVar VAR_0x8004, ITEM_CLEAR_BELL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_103
    GoTo _0DA6
_0A67:
    ShowYesNoMenu VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 1, _065B
    CloseMessage
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_6, _1218
    WaitMovement
    Message msg_0618_T27R0501_00045
    CloseMessage
    WaitTime 10, VAR_RESULT
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_ZUKI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_6, _1256
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer, _1260
    WaitMovement
    Message msg_0618_T27R0501_00015
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_NAOKO, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer, _128E
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement 13, _140C
    WaitMovement
    Message msg_0618_T27R0501_00046
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_TEAM_ROCKET_MICKEY_4, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement 13, _143A
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement 14, _1448
    WaitMovement
    Message msg_0618_T27R0501_00047
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_TEAM_ROCKET_MICKEY_5, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement 14, _1476
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_5, _1298
    WaitMovement
    Message msg_0618_T27R0501_00016
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_MIKI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_5, _12C6
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_2, _12D0
    WaitMovement
    Message msg_0618_T27R0501_00017
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_SAYO, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_2, _12FA
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_4, _1308
    WaitMovement
    Message msg_0618_T27R0501_00018
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_KUNI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3E
    ApplyMovement obj_T27R0501_dancer_4, _1332
    WaitMovement
    ApplyMovement obj_T27R0501_dancer_6, _1340
    WaitMovement
    Message msg_0618_T27R0501_00020
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0D48
    SetVar VAR_0x8004, ITEM_CLEAR_BELL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_103
    GoTo _0DA6
_0C52:
    End
_0C54:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0DF0
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_EAST
    GoTo _0559
_0C73:
    CompareVar VAR_0x8004, 2
    GoToIf 5, _0E2E
    ApplyMovement obj_T27R0501_rocketm_2, _1346
    GoTo _05AC
_0C8E:
    CompareVar VAR_0x8004, 1
    GoToIf 5, _0E58
    ApplyMovement obj_T27R0501_rocketm_2, _1354
    GoTo _0CA9
_0CA9:
    WaitMovement
    RemoveObject obj_T27R0501_rocketm_2
    SetFlag FLAG_HGSS_UNK_23A
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_410C, 2
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 10
    End
_0CC3:
    CompareVar VAR_MAP_LOCAL_0x0B, 1
    GoToIf 5, _0E73
    Message msg_0618_T27R0501_00034
    GoTo _0CD9
_0CD9:
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_MAP_LOCAL_0x0B, 2
    GoToIf 4, _0E95
    AddVar VAR_MAP_LOCAL_0x0B, 1
    GoTo _0E9D
_0CF8:
    CompareVar VAR_0x8000, 77
    GoToIf 5, _0E9F
    ReleaseAll
    GoTo _0EA3
_0D0D:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0EA5
    ApplyMovement LOCALID_PLAYER, _135E
    GoTo _0D28
_0D28:
    ApplyMovement obj_T27R0501_dancer_6, _136C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
_0D3E:
    BlackOutFromBattle
    Call _0CF8
    End
_0D48:
    SetVar VAR_0x8004, ITEM_TIDAL_BELL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_104
    CloseMessage
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    CompleteScreenShake 0, 2, 10, 6
    WaitSE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_HIDE_DANCE_STUDIO_LITTLE_GIRL
    AddObject obj_T27R0501_gsbabygirl1
    ApplyMovement obj_T27R0501_gsbabygirl1, _1376
    WaitMovement
    ApplyMovement obj_T27R0501_dancer_6, _1380
    WaitMovement
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0ED0
    Message msg_0618_T27R0501_00021
    GoTo _0EF8
_0DA6:
    CloseMessage
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    CompleteScreenShake 0, 2, 10, 6
    WaitSE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_HIDE_DANCE_STUDIO_LITTLE_GIRL
    AddObject obj_T27R0501_gsbabygirl1
    ApplyMovement obj_T27R0501_gsbabygirl1, _1376
    WaitMovement
    ApplyMovement obj_T27R0501_dancer_6, _1380
    WaitMovement
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0ED0
    Message msg_0618_T27R0501_00021
    GoTo _0EF8
_0DF0:
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_WEST
    @ HGSS: ScrCmd_374 obj_T27R0501_rocketm_2
    SetVarFromValue VAR_MAP_LOCAL_0x09, 0
    CompareVar VAR_MAP_LOCAL_0x0A, 10
    GoToIf 1, _0C52
    CompareVar VAR_HGSS_UNK_410C, 3
    GoToIf 5, _0C52
    SetPosition obj_T27R0501_dancer_3, 7, 0, 6, DIR_SOUTH
    End
_0E2E:
    ApplyMovement obj_T27R0501_rocketm_2, _1386
    WaitMovement
    Message msg_0618_T27R0501_00007
    CloseMessage
    CompareVar VAR_0x8004, 0
    GoToIf 5, _0C8E
    ApplyMovement obj_T27R0501_rocketm_2, _11FC
    GoTo _0CA9
_0E58:
    CompareVar VAR_0x8004, 2
    GoToIf 5, _0F1D
    ApplyMovement obj_T27R0501_rocketm_2, _1394
    GoTo _0CA9
_0E73:
    Message msg_0618_T27R0501_00035
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_MAP_LOCAL_0x0B, 2
    GoToIf 4, _0E95
    AddVar VAR_MAP_LOCAL_0x0B, 1
    GoTo _0E9D
_0E95:
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
    End
_0E9D:
    End
_0E9F:
    ReleaseAll
    Return
_0EA3:
    Return
_0EA5:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0D28
    ApplyMovement LOCALID_PLAYER, _139E
    ApplyMovement obj_T27R0501_dancer_6, _136C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
_0ED0:
    Message msg_0618_T27R0501_00022
    CloseMessage
    ApplyMovement obj_T27R0501_dancer_6, _13AC
    WaitMovement
    BufferPlayerName 0
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0F3F
    Message msg_0618_T27R0501_00023
    GoTo _0FD7
_0EF8:
    CloseMessage
    ApplyMovement obj_T27R0501_dancer_6, _13AC
    WaitMovement
    BufferPlayerName 0
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0F3F
    Message msg_0618_T27R0501_00023
    GoTo _0FD7
_0F1D:
    ApplyMovement obj_T27R0501_rocketm_2, _13B2
    WaitMovement
    RemoveObject obj_T27R0501_rocketm_2
    SetFlag FLAG_HGSS_UNK_23A
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_410C, 2
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 10
    End
_0F3F:
    Message msg_0618_T27R0501_00024
    CloseMessage
    ApplyMovement obj_T27R0501_dancer, _13C0
    ApplyMovement obj_T27R0501_dancer_2, _13CA
    ApplyMovement 14, _1484
    ApplyMovement obj_T27R0501_dancer_6, _13D8
    ApplyMovement obj_T27R0501_dancer_4, _13E6
    ApplyMovement obj_T27R0501_dancer_5, _13F4
    ApplyMovement obj_T27R0501_gsbabygirl1, _13FE
    ApplyMovement 13, _1492
    WaitMovement
    RemoveObject obj_T27R0501_dancer
    RemoveObject obj_T27R0501_dancer_2
    RemoveObject obj_T27R0501_dancer_6
    RemoveObject obj_T27R0501_dancer_4
    RemoveObject obj_T27R0501_dancer_5
    RemoveObject obj_T27R0501_gsbabygirl1
    RemoveObject 14
    RemoveObject 13
    SetFlag FLAG_HGSS_HIDE_DANCE_STUDIO_KIMONO_GIRLS
    SetFlag FLAG_HGSS_HIDE_DANCE_STUDIO_LITTLE_GIRL
    Call _0CF8
    SetVarFromValue VAR_HGSS_UNK_410C, 6
    SetVarFromValue VAR_HGSS_UNK_40FA, 1
    CompareVar VAR_RESULT, 7
    GoToIf 5, _106C
    ClearFlag FLAG_HGSS_HIDE_BELL_TOWER_SUMMIT_KIMONO_GIRLS
    GoTo _1072
_0FD7:
    CloseMessage
    ApplyMovement obj_T27R0501_dancer, _13C0
    ApplyMovement obj_T27R0501_dancer_2, _13CA
    ApplyMovement 14, _1484
    ApplyMovement obj_T27R0501_dancer_6, _13D8
    ApplyMovement obj_T27R0501_dancer_4, _13E6
    ApplyMovement obj_T27R0501_dancer_5, _13F4
    ApplyMovement obj_T27R0501_gsbabygirl1, _13FE
    ApplyMovement 13, _1492
    WaitMovement
    RemoveObject obj_T27R0501_dancer
    RemoveObject obj_T27R0501_dancer_2
    RemoveObject obj_T27R0501_dancer_6
    RemoveObject obj_T27R0501_dancer_4
    RemoveObject obj_T27R0501_dancer_5
    RemoveObject obj_T27R0501_gsbabygirl1
    RemoveObject 14
    RemoveObject 13
    SetFlag FLAG_HGSS_HIDE_DANCE_STUDIO_KIMONO_GIRLS
    SetFlag FLAG_HGSS_HIDE_DANCE_STUDIO_LITTLE_GIRL
    Call _0CF8
    SetVarFromValue VAR_HGSS_UNK_410C, 6
    SetVarFromValue VAR_HGSS_UNK_40FA, 1
    CompareVar VAR_RESULT, 7
    GoToIf 5, _106C
    ClearFlag FLAG_HGSS_HIDE_BELL_TOWER_SUMMIT_KIMONO_GIRLS
    GoTo _1072
_106C:
    ClearFlag FLAG_HGSS_HIDE_WHIRL_ISLANDS_BOTTOM_KIMONO_GIRLS
    End
_1072:
    End
    .balign 4, 0
_1074:
    FaceEast
    EndMovement
    .balign 4, 0
_107A:
    WalkSlightlyFastNorth 9
    EndMovement
    .balign 4, 0
_1080:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_1086:
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_108C:
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_1092:
    LockDir
    WalkNormalEast 2
    UnlockDir
    EndMovement
    .balign 4, 0
_10A0:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_10A6:
    FaceWest
    Delay1
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    Delay1
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    Delay1
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    Delay1
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    Delay1
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    Delay1
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    FaceWest
    Delay1
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    EndMovement
    .balign 4, 0
_1180:
    Delay32
    WalkSlightlyFastSouth 9
    EndMovement
    .balign 4, 0
_118A:
    LockDir
    WalkNormalNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_1198:
    WalkNormalNorth
    WalkNormalWest 5
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_11A6:
    WalkNormalSouth 2
    WalkNormalEast 5
    WalkNormalSouth
    FaceNorth
    EndMovement
    .balign 4, 0
_11B8:
    WalkNormalNorth
    WalkNormalEast 3
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_11C6:
    WalkNormalSouth 2
    WalkNormalWest 3
    WalkNormalSouth
    FaceNorth
    EndMovement
    .balign 4, 0
_11D8:
    WalkNormalNorth 5
    WalkNormalWest 4
    WalkNormalNorth 5
    WalkNormalEast 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_11EE:
    LockDir
    WalkNormalSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_11FC:
    WalkFastWest 4
    WalkFastSouth 12
    EndMovement
    .balign 4, 0
_1206:
    WalkNormalEast
    WalkNormalSouth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1218:
    FaceWest
    Delay4
    FaceNorth
    Delay4
    FaceEast
    Delay4
    FaceSouth
    Delay4
    FaceWest
    Delay4
    FaceNorth
    Delay4
    FaceEast
    Delay4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1256:
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1260:
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    FaceSouth
    Delay2
    WalkOnSpotNormalEast
    WalkNormalEast 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_128E:
    WalkNormalWest 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1298:
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    WalkOnSpotNormalWest
    WalkNormalWest 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_12C6:
    WalkNormalEast 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_12D0:
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    WalkOnSpotNormalSouth
    WalkNormalSouth
    WalkNormalEast 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_12FA:
    WalkNormalWest 3
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1308:
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    WalkOnSpotNormalSouth
    WalkNormalSouth
    WalkNormalWest 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1332:
    WalkNormalEast 3
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1340:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_1346:
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
    .balign 4, 0
_1354:
    WalkFastWest 4
    WalkFastSouth 10
    EndMovement
    .balign 4, 0
_135E:
    WalkNormalSouth
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_136C:
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1376:
    WalkFastNorth 10
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_1380:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1386:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_1394:
    WalkFastWest 3
    WalkFastSouth 10
    EndMovement
    .balign 4, 0
_139E:
    WalkNormalSouth
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_13AC:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_13B2:
    WalkFastSouth
    WalkFastEast 3
    WalkFastSouth 9
    EndMovement
    .balign 4, 0
_13C0:
    WalkNormalEast
    WalkNormalSouth 11
    EndMovement
    .balign 4, 0
_13CA:
    Delay8
    WalkNormalWest
    WalkNormalSouth 12
    EndMovement
    .balign 4, 0
_13D8:
    Delay8
    WalkNormalEast 4
    WalkNormalSouth 11
    EndMovement
    .balign 4, 0
_13E6:
    Delay8
    WalkNormalEast
    WalkNormalSouth 12
    EndMovement
    .balign 4, 0
_13F4:
    WalkNormalWest
    WalkNormalSouth 11
    EndMovement
    .balign 4, 0
_13FE:
    Delay8 2
    WalkNormalEast 5
    WalkNormalSouth 11
    EndMovement
    .balign 4, 0
_140C:
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    WalkNormalSouth
    WalkNormalEast 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_143A:
    WalkNormalWest 2
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1448:
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    WalkNormalSouth
    WalkNormalWest 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1476:
    WalkNormalEast 2
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1484:
    Delay8
    WalkNormalEast 2
    WalkNormalSouth 12
    EndMovement
    .balign 4, 0
_1492:
    Delay8
    WalkNormalWest 2
    WalkNormalSouth 12
    EndMovement
    @ HGSS data: .byte 254, 0
    .balign 4, 0
