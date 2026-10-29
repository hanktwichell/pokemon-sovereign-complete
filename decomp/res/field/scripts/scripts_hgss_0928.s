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
    GoToIf 2, _0057
    ShowObject obj_T27R0501_rocketm_2
_0057:
    CompareVar VAR_HGSS_UNK_410C, 0
    GoToIf 5, _007C
    SetPosition obj_T27R0501_rocketm, 6, 0, 6, DIR_EAST
    SetPosition obj_T27R0501_dancer_3, 8, 0, 6, DIR_WEST
_007C:
    CompareVar VAR_MAP_LOCAL_0x09, 222
    GoToIf 5, _0110
    SetPosition obj_T27R0501_rocketm, 29, 0, 29, DIR_SOUTH
    ShowObject obj_T27R0501_rocketm
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _00BC
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_SOUTH
    GoTo _0106
_00BC:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _00DB
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_NORTH
    GoTo _0106
_00DB:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00FA
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_EAST
    GoTo _0106
_00FA:
    SetPosition obj_T27R0501_rocketm_2, 7, 0, 6, DIR_WEST
_0106:
    @ HGSS: ScrCmd_374 obj_T27R0501_rocketm_2
    SetVarFromValue VAR_MAP_LOCAL_0x09, 0
_0110:
    CompareVar VAR_MAP_LOCAL_0x0A, 10
    GoToIf 1, _0136
    CompareVar VAR_HGSS_UNK_410C, 3
    GoToIf 5, _0136
    SetPosition obj_T27R0501_dancer_3, 7, 0, 6, DIR_SOUTH
_0136:
    End
scr_seq_T27R0501_015:
    LockAll
    Message msg_0618_T27R0501_00000
    CloseMessage
    ApplyMovement obj_T27R0501_rocketm, _01CC
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    @ HGSS: ScrCmd_102 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    ApplyMovement 241, _01D4
    WaitMovement
    WaitTime 10, VAR_RESULT
    ApplyMovement obj_T27R0501_rocketm, _01F0
    WaitMovement
    Message msg_0618_T27R0501_00001
    CloseMessage
    ApplyMovement obj_T27R0501_dancer_3, _01F8
    WaitMovement
    Message msg_0618_T27R0501_00002
    CloseMessage
    ApplyMovement obj_T27R0501_rocketm, _0200
    WaitMovement
    Message msg_0618_T27R0501_00003
    CloseMessage
    ApplyMovement obj_T27R0501_dancer_3, _0208
    WaitMovement
    Message msg_0618_T27R0501_00004
    CloseMessage
    ApplyMovement obj_T27R0501_rocketm, _0218
    WaitMovement
    ApplyMovement obj_T27R0501_rocketm, _0220
    ApplyMovement 241, _01DC
    WaitMovement
    @ HGSS: ScrCmd_103
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_410C, 1
    End
    .balign 4, 0
_01CC:
    FaceEast
    EndMovement
    .balign 4, 0
_01D4:
    WalkSlightlyFastNorth 9
    EndMovement
    .balign 4, 0
_01DC:
    Delay32
    WalkSlightlyFastSouth 9
    EndMovement
    .balign 4, 0
_01E8:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_01F0:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_01F8:
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_0200:
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_0208:
    LockDir
    WalkNormalEast 2
    UnlockDir
    EndMovement
    .balign 4, 0
_0218:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0220:
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
scr_seq_T27R0501_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    Message msg_0618_T27R0501_00005
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x09, 222
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_26, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _040C
    Message msg_0618_T27R0501_00006
    CloseMessage
    GetPlayerDir VAR_0x8004
    CompareVar VAR_0x8004, 0
    GoToIf 5, _0354
    ApplyMovement obj_T27R0501_rocketm_2, _0414
    GoTo _0392
_0354:
    CompareVar VAR_0x8004, 1
    GoToIf 5, _036F
    ApplyMovement obj_T27R0501_rocketm_2, _0424
    GoTo _0392
_036F:
    CompareVar VAR_0x8004, 2
    GoToIf 5, _038A
    ApplyMovement obj_T27R0501_rocketm_2, _0434
    GoTo _0392
_038A:
    ApplyMovement obj_T27R0501_rocketm_2, _0444
_0392:
    WaitMovement
    Message msg_0618_T27R0501_00007
    CloseMessage
    CompareVar VAR_0x8004, 0
    GoToIf 5, _03B4
    ApplyMovement obj_T27R0501_rocketm_2, _0454
    GoTo _03F2
_03B4:
    CompareVar VAR_0x8004, 1
    GoToIf 5, _03CF
    ApplyMovement obj_T27R0501_rocketm_2, _0460
    GoTo _03F2
_03CF:
    CompareVar VAR_0x8004, 2
    GoToIf 5, _03EA
    ApplyMovement obj_T27R0501_rocketm_2, _046C
    GoTo _03F2
_03EA:
    ApplyMovement obj_T27R0501_rocketm_2, _0478
_03F2:
    WaitMovement
    RemoveObject obj_T27R0501_rocketm_2
    SetFlag FLAG_HGSS_UNK_23A
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_410C, 2
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 10
    End
_040C:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0414:
    LockDir
    WalkNormalNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_0424:
    LockDir
    WalkNormalSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_0434:
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
    .balign 4, 0
_0444:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_0454:
    WalkFastWest 4
    WalkFastSouth 12
    EndMovement
    .balign 4, 0
_0460:
    WalkFastWest 4
    WalkFastSouth 10
    EndMovement
    .balign 4, 0
_046C:
    WalkFastWest 3
    WalkFastSouth 10
    EndMovement
    .balign 4, 0
_0478:
    WalkFastSouth
    WalkFastEast 3
    WalkFastSouth 9
    EndMovement
scr_seq_T27R0501_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_410C, 1
    GoToIf 1, _04B5
    CompareVar VAR_MAP_LOCAL_0x0A, 10
    GoToIf 1, _04C0
    Message msg_0618_T27R0501_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04B5:
    Message msg_0618_T27R0501_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04C0:
    BufferPlayerName 0
    Message msg_0618_T27R0501_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_011:
    LockAll
    ApplyMovement obj_T27R0501_gsgentleman, _05B4
    WaitMovement
    Message msg_0618_T27R0501_00026
    SetVar VAR_0x8004, ITEM_HM03
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _05A9
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HM03
    SetVarFromValue VAR_HGSS_UNK_410C, 3
    SetVarFromValue VAR_HGSS_UNK_4090, 1
    Message msg_0618_T27R0501_00028
    CloseMessage
    ApplyMovement obj_T27R0501_gsgentleman, _05C4
    WaitMovement
    ReleaseAll
    End
scr_seq_T27R0501_012:
    LockAll
    ApplyMovement obj_T27R0501_gsgentleman, _05D8
    WaitMovement
    Message msg_0618_T27R0501_00026
    SetVar VAR_0x8004, ITEM_HM03
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _05A9
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HM03
    SetVarFromValue VAR_HGSS_UNK_4090, 1
    SetVarFromValue VAR_HGSS_UNK_410C, 3
    Message msg_0618_T27R0501_00028
    CloseMessage
    ApplyMovement obj_T27R0501_gsgentleman, _05E8
    WaitMovement
    ReleaseAll
    End
scr_seq_T27R0501_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_HM03, _059E
    Message msg_0618_T27R0501_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_059E:
    Message msg_0618_T27R0501_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05A9:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_05B4:
    WalkNormalNorth
    WalkNormalWest 5
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_05C4:
    WalkNormalSouth 2
    WalkNormalEast 5
    WalkNormalSouth
    FaceNorth
    EndMovement
    .balign 4, 0
_05D8:
    WalkNormalNorth
    WalkNormalEast 3
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_05E8:
    WalkNormalSouth 2
    WalkNormalWest 3
    WalkNormalSouth
    FaceNorth
    EndMovement
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
    GoToIf 1, _0644
    CompareVar VAR_HGSS_UNK_410C, 1
    GoToIf 1, _064F
    Message msg_0618_T27R0501_00031
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0644:
    Message msg_0618_T27R0501_00033
    WaitButton
    CloseMessage
    ReleaseAll
    End
_064F:
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _0665
    Message msg_0618_T27R0501_00032
    GoTo _067E
_0665:
    CompareVar VAR_MAP_LOCAL_0x0B, 1
    GoToIf 5, _067B
    Message msg_0618_T27R0501_00034
    GoTo _067E
_067B:
    Message msg_0618_T27R0501_00035
_067E:
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_MAP_LOCAL_0x0B, 2
    GoToIf 4, _069D
    AddVar VAR_MAP_LOCAL_0x0B, 1
    GoTo _06A3
_069D:
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
_06A3:
    End
scr_seq_T27R0501_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x0A, 10
    GoToIf 1, _06D2
    CompareVar VAR_HGSS_UNK_410C, 1
    GoToIf 1, _06DD
    Message msg_0618_T27R0501_00036
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06D2:
    Message msg_0618_T27R0501_00038
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06DD:
    Message msg_0618_T27R0501_00037
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
    GoToIfSet FLAG_HGSS_UNK_108, _0724
    GoToIfSet FLAG_HGSS_UNK_109, _0724
    Message msg_0618_T27R0501_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0724:
    Message msg_0618_T27R0501_00040
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _0758
    GoToIfSet FLAG_HGSS_UNK_109, _0758
    Message msg_0618_T27R0501_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0758:
    Message msg_0618_T27R0501_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_0x8000, 77
    GoToIfSet FLAG_HGSS_UNK_108, _0868
    GoToIfSet FLAG_HGSS_UNK_109, _0868
    Message msg_0618_T27R0501_00013
    ShowYesNoMenu VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 1, _0BD3
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    CallIf 5, _07BA
    GoTo _0944
    End
_07BA:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_RESULT, 1
    GoToIf 5, _07DF
    ApplyMovement LOCALID_PLAYER, _0828
    GoTo _080F
_07DF:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _07FA
    ApplyMovement LOCALID_PLAYER, _083C
    GoTo _080F
_07FA:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _080F
    ApplyMovement LOCALID_PLAYER, _084C
_080F:
    ApplyMovement obj_T27R0501_dancer_6, _085C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
    .balign 4, 0
_0828:
    WalkNormalEast
    WalkNormalSouth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_083C:
    WalkNormalSouth
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_084C:
    WalkNormalSouth
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_085C:
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
_0868:
    BufferPlayerName 0
    Message msg_0618_T27R0501_00042
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_107
    ReleaseAll
    End
scr_seq_T27R0501_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _08A3
    GoToIfSet FLAG_HGSS_UNK_109, _08A3
    Message msg_0618_T27R0501_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_08A3:
    Message msg_0618_T27R0501_00043
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27R0501_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _08D7
    GoToIfSet FLAG_HGSS_UNK_109, _08D7
    Message msg_0618_T27R0501_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_08D7:
    Message msg_0618_T27R0501_00044
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
    ApplyMovement LOCALID_PLAYER, _0BF4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _092A
    Message msg_0618_T27R0501_00011
    GoTo _092D
_092A:
    Message msg_0618_T27R0501_00012
_092D:
    ShowYesNoMenu VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 1, _0BD3
    CloseMessage
_0944:
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_6, _0D74
    WaitMovement
    Message msg_0618_T27R0501_00045
    CloseMessage
    WaitTime 10, VAR_RESULT
    @ HGSS: TrainerBattle TRAINER_KIMONO_GIRL_ZUKI, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0BC9
    ApplyMovement obj_T27R0501_dancer_6, _0C0C
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer, _0C18
    WaitMovement
    Message msg_0618_T27R0501_00015
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_KIMONO_GIRL_NAOKO, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0BC9
    ApplyMovement obj_T27R0501_dancer, _0C48
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_5, _0C54
    WaitMovement
    Message msg_0618_T27R0501_00016
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_KIMONO_GIRL_MIKI, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0BC9
    ApplyMovement obj_T27R0501_dancer_5, _0C84
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_2, _0C90
    WaitMovement
    Message msg_0618_T27R0501_00017
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_KIMONO_GIRL_SAYO, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0BC9
    ApplyMovement obj_T27R0501_dancer_2, _0CBC
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement obj_T27R0501_dancer_4, _0CCC
    WaitMovement
    Message msg_0618_T27R0501_00018
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_KIMONO_GIRL_KUNI, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0BC9
    ApplyMovement obj_T27R0501_dancer_4, _0CF8
    WaitMovement
    ApplyMovement obj_T27R0501_dancer_6, _0D08
    WaitMovement
    Message msg_0618_T27R0501_00020
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0AA4
    SetVar VAR_0x8004, ITEM_CLEAR_BELL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_103
    GoTo _0AB8
_0AA4:
    SetVar VAR_0x8004, ITEM_TIDAL_BELL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_104
_0AB8:
    CloseMessage
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    @ HGSS: ScreenShake 0, 2, 10, 6
    WaitSE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_HIDE_DANCE_STUDIO_LITTLE_GIRL
    AddObject obj_T27R0501_gsbabygirl1
    ApplyMovement obj_T27R0501_gsbabygirl1, _0D10
    WaitMovement
    ApplyMovement obj_T27R0501_dancer_6, _0BEC
    WaitMovement
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0B02
    Message msg_0618_T27R0501_00021
    GoTo _0B05
_0B02:
    Message msg_0618_T27R0501_00022
_0B05:
    CloseMessage
    ApplyMovement obj_T27R0501_dancer_6, _0BE4
    WaitMovement
    BufferPlayerName 0
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0B2A
    Message msg_0618_T27R0501_00023
    GoTo _0B2D
_0B2A:
    Message msg_0618_T27R0501_00024
_0B2D:
    CloseMessage
    ApplyMovement obj_T27R0501_dancer, _0D1C
    ApplyMovement obj_T27R0501_dancer_2, _0D28
    ApplyMovement obj_T27R0501_dancer_6, _0D38
    ApplyMovement obj_T27R0501_dancer_4, _0D48
    ApplyMovement obj_T27R0501_dancer_5, _0D58
    ApplyMovement obj_T27R0501_gsbabygirl1, _0D64
    WaitMovement
    RemoveObject obj_T27R0501_dancer
    RemoveObject obj_T27R0501_dancer_2
    RemoveObject obj_T27R0501_dancer_6
    RemoveObject obj_T27R0501_dancer_4
    RemoveObject obj_T27R0501_dancer_5
    RemoveObject obj_T27R0501_gsbabygirl1
    SetFlag FLAG_HGSS_HIDE_DANCE_STUDIO_KIMONO_GIRLS
    SetFlag FLAG_HGSS_HIDE_DANCE_STUDIO_LITTLE_GIRL
    Call _0BB0
    SetVarFromValue VAR_HGSS_UNK_410C, 6
    SetVarFromValue VAR_HGSS_UNK_40FA, 1
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0BAA
    ClearFlag FLAG_HGSS_HIDE_BELL_TOWER_SUMMIT_KIMONO_GIRLS
    GoTo _0BAE
_0BAA:
    ClearFlag FLAG_HGSS_HIDE_WHIRL_ISLANDS_BOTTOM_KIMONO_GIRLS
_0BAE:
    End
_0BB0:
    CompareVar VAR_0x8000, 77
    GoToIf 5, _0BC5
    ReleaseAll
    GoTo _0BC7
_0BC5:
    ReleaseAll
_0BC7:
    Return
_0BC9:
    BlackOutFromBattle
    Call _0BB0
    End
_0BD3:
    Message msg_0618_T27R0501_00014
    WaitButton
    CloseMessage
    Call _0BB0
    End
    .balign 4, 0
_0BE4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0BEC:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0BF4:
    WalkNormalNorth 5
    WalkNormalWest 4
    WalkNormalNorth 5
    WalkNormalEast 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0C0C:
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C18:
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
_0C48:
    WalkNormalWest 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C54:
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
_0C84:
    WalkNormalEast 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C90:
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
_0CBC:
    WalkNormalWest 3
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0CCC:
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
_0CF8:
    WalkNormalEast 3
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0D08:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0D10:
    WalkFastNorth 10
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_0D1C:
    WalkNormalEast
    WalkNormalSouth 11
    EndMovement
    .balign 4, 0
_0D28:
    Delay8
    WalkNormalWest
    WalkNormalSouth 12
    EndMovement
    .balign 4, 0
_0D38:
    Delay8
    WalkNormalEast 4
    WalkNormalSouth 11
    EndMovement
    .balign 4, 0
_0D48:
    Delay8
    WalkNormalEast
    WalkNormalSouth 12
    EndMovement
    .balign 4, 0
_0D58:
    WalkNormalWest
    WalkNormalSouth 11
    EndMovement
    .balign 4, 0
_0D64:
    Delay8 2
    WalkNormalEast 5
    WalkNormalSouth 11
    EndMovement
    .balign 4, 0
_0D74:
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
