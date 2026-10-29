#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0135.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D47R0101_counterm_3 2
#define obj_D47R0101_counterm_5 4
#define obj_D47R0101_gsgentleman 5

    ScriptEntry scr_seq_D47R0101_000
    ScriptEntry scr_seq_D47R0101_001
    ScriptEntry scr_seq_D47R0101_002
    ScriptEntry scr_seq_D47R0101_003
    ScriptEntry scr_seq_D47R0101_004
    ScriptEntry scr_seq_D47R0101_005
    ScriptEntry scr_seq_D47R0101_006
    ScriptEntry scr_seq_D47R0101_007
    ScriptEntry scr_seq_D47R0101_008
    ScriptEntry scr_seq_D47R0101_009
    ScriptEntry scr_seq_D47R0101_010
    ScriptEntry scr_seq_D47R0101_011
    ScriptEntryEnd
scr_seq_D47R0101_006:
    LockAll
    ApplyMovement obj_D47R0101_counterm_3, _01EC
    ApplyMovement obj_D47R0101_counterm_5, _01EC
    WaitMovement
    Message msg_0135_D47R0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0062
    @ HGSS: SafariZoneAction 1, 0
_0062:
    CloseMessage
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00BD
    ApplyMovement LOCALID_PLAYER, _01B4
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_EXTERIOR, 79, 100, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockObject LOCALID_COMPLETE_FOLLOWER
    @ HGSS: ScrCmd_606
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0200
    WaitMovement
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ReleaseAll
    End
_00BD:
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _00E2
    SetVarFromValue VAR_MAP_LOCAL_0x02, 5
    SetVarFromValue VAR_MAP_LOCAL_0x03, 5
    GoTo _00EE
_00E2:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 19
    SetVarFromValue VAR_MAP_LOCAL_0x03, 5
_00EE:
    ApplyMovement LOCALID_PLAYER, _01DC
    WaitMovement
    @ HGSS: ScrCmd_307 0, 0, VAR_TEMP_x4002, VAR_TEMP_x4003, 77
    Call _08AF
    ApplyMovement LOCALID_PLAYER, _01BC
    ApplyMovement obj_D47R0101_counterm_3, _01F4
    ApplyMovement obj_D47R0101_counterm_5, _01F4
    WaitMovement
    Call _08B7
    SetVarFromValue VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 0
    Message msg_0135_D47R0101_00008
    Message msg_0135_D47R0101_00009
    WaitButton
    CloseMessage
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
scr_seq_D47R0101_007:
    LockAll
    ApplyMovement LOCALID_PLAYER, _01E4
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0172
    SetVarFromValue VAR_MAP_LOCAL_0x02, 5
    SetVarFromValue VAR_MAP_LOCAL_0x03, 5
    GoTo _017E
_0172:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 19
    SetVarFromValue VAR_MAP_LOCAL_0x03, 5
_017E:
    @ HGSS: ScrCmd_307 0, 0, VAR_TEMP_x4002, VAR_TEMP_x4003, 77
    Call _08AF
    ApplyMovement LOCALID_PLAYER, _01BC
    WaitMovement
    Call _08B7
    SetVarFromValue VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 0
    Message msg_0135_D47R0101_00009
    WaitButton
    CloseMessage
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
    .balign 4, 0
_01B4:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_01BC:
    WalkNormalSouth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01CC:
    WalkNormalSouth 4
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01DC:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_01E4:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_01EC:
    FaceEast
    EndMovement
    .balign 4, 0
_01F4:
    Delay8
    FaceSouth
    EndMovement
    .balign 4, 0
_0200:
    FaceNorth
    EndMovement
scr_seq_D47R0101_008:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D47R0101_gsgentleman, _0310
    ApplyMovement LOCALID_PLAYER, _03B8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0135_D47R0101_00029
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _025B
_024A:
    Message msg_0135_D47R0101_00030
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4057, 2
    ReleaseAll
    End
_025B:
    Message msg_0135_D47R0101_00031
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _025B
    GoTo _024A
scr_seq_D47R0101_009:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D47R0101_gsgentleman, _0310
    ApplyMovement LOCALID_PLAYER, _03B8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0135_D47R0101_00034
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D47R0101_gsgentleman, _0324
    ApplyMovement LOCALID_PLAYER, _03C8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0135_D47R0101_00035
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D47R0101_gsgentleman, _0334
    ApplyMovement LOCALID_PLAYER, _03D8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0135_D47R0101_00036
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4057, 5
    ClearFlag FLAG_HGSS_HIDE_SAFARI_ZONE_WORKERS
    ReleaseAll
    End
    .balign 4, 0
_0310:
    FaceSouth
    EmoteExclamationMark
    Delay16
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0324:
    WalkNormalNorth 2
    WalkNormalEast 3
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0334:
    WalkNormalSouth 2
    WalkNormalWest 2
    WalkNormalSouth
    EmoteExclamationMark
    FaceNorth
    EndMovement
    .balign 4, 0
_034C:
    WalkNormalWest 2
    WalkNormalNorth 4
    WalkNormalEast 4
    FaceSouth
    EndMovement
    .balign 4, 0
_0360:
    WalkNormalNorth 4
    WalkNormalEast 2
    FaceSouth
    EndMovement
    .balign 4, 0
_0370:
    WalkNormalSouth 2
    WalkNormalEast
    WalkNormalSouth 2
    FaceWest
    EndMovement
    .balign 4, 0
_0384:
    WalkNormalEast
    Delay16
    FaceWest
    EndMovement
    .balign 4, 0
_0394:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_039C:
    FaceSouth
    Delay16
    FaceWest
    EndMovement
    .balign 4, 0
_03AC:
    FaceSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03B8:
    Delay16
    WalkNormalNorth 3
    FaceEast
    EndMovement
    .balign 4, 0
_03C8:
    WalkNormalNorth 2
    WalkNormalEast 4
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_03D8:
    FaceSouth
    EndMovement
    .balign 4, 0
_03E0:
    Delay16
    FaceNorth
    Delay16
    WalkNormalSouth
    FaceNorth
    EndMovement
    .balign 4, 0
_03F8:
    WalkNormalEast
    FaceNorth
    EndMovement
    .balign 4, 0
_0404:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_040C:
    Delay16 3
    FaceEast
    EndMovement
    .balign 4, 0
_0418:
    FaceNorth
    EndMovement
    .balign 4, 0
_0420:
    WalkNormalNorth 3
    FaceEast
    EndMovement
scr_seq_D47R0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_183, _0599
    CompareVar VAR_HGSS_UNK_4057, 2
    GoToIf 1, _049D
    CompareVar VAR_HGSS_UNK_4057, 3
    GoToIf 1, _048B
    CompareVar VAR_HGSS_UNK_4057, 5
    GoToIf 1, _04CB
    CompareVar VAR_HGSS_UNK_4057, 6
    GoToIf 1, _0494
    CompareVar VAR_HGSS_UNK_4057, 7
    GoToIf 1, _058F
    Message msg_0135_D47R0101_00042
    GoTo _0587
    End
_048B:
    Message msg_0135_D47R0101_00042
    GoTo _0587
_0494:
    Message msg_0135_D47R0101_00040
    GoTo _0587
_049D:
    @ HGSS: CheckSafariZoneChallengeCompleted 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04B8
    Message msg_0135_D47R0101_00033
    GoTo _04C3
_04B8:
    Message msg_0135_D47R0101_00032
    SetVarFromValue VAR_HGSS_UNK_4057, 3
    @ HGSS: UpdateSafariZoneIGT
_04C3:
    GoTo _0587
    End
_04CB:
    @ HGSS: CheckSafariZoneChallengeCompleted 1, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _057E
    Message msg_0135_D47R0101_00037
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0515
    ApplyMovement obj_D47R0101_gsgentleman, _034C
    ApplyMovement LOCALID_PLAYER, _03E0
    WaitMovement
    GoTo _054C
_0515:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _053A
    ApplyMovement obj_D47R0101_gsgentleman, _0360
    ApplyMovement LOCALID_PLAYER, _03F8
    WaitMovement
    GoTo _054C
_053A:
    ApplyMovement obj_D47R0101_gsgentleman, _0360
    ApplyMovement LOCALID_PLAYER, _0404
    WaitMovement
_054C:
    Message msg_0135_D47R0101_00038
    CloseMessage
    ApplyMovement obj_D47R0101_gsgentleman, _0370
    ApplyMovement LOCALID_PLAYER, _040C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0135_D47R0101_00039
    SetVarFromValue VAR_HGSS_UNK_4057, 6
    @ HGSS: UpdateSafariZoneIGT
    GoTo _0587
_057E:
    Message msg_0135_D47R0101_00041
    GoTo _0587
_0587:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_058F:
    SetFlag FLAG_HGSS_UNK_183
    Message msg_0135_D47R0101_00043
    Message msg_0135_D47R0101_00044
_0599:
    Message msg_0135_D47R0101_00045
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0683
_05AF:
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 463, 0
    AddMenuEntryImm 464, 1
    AddMenuEntryImm 465, 2
    AddMenuEntryImm 466, 3
    AddMenuEntryImm 467, 4
    AddMenuEntryImm 468, 5
    AddMenuEntryImm 469, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _064D
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0656
    CompareVar VAR_0x8008, 2
    GoToIf 1, _065F
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0668
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0671
    CompareVar VAR_0x8008, 5
    GoToIf 1, _067A
    GoTo _0683
    End
_064D:
    Message msg_0135_D47R0101_00047
    GoTo _05AF
_0656:
    Message msg_0135_D47R0101_00048
    GoTo _05AF
_065F:
    Message msg_0135_D47R0101_00049
    GoTo _05AF
_0668:
    Message msg_0135_D47R0101_00050
    GoTo _05AF
_0671:
    Message msg_0135_D47R0101_00051
    GoTo _05AF
_067A:
    Message msg_0135_D47R0101_00052
    GoTo _05AF
_0683:
    Message msg_0135_D47R0101_00053
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4057, 6
    GoToIf 0, _06AE
    Message msg_0135_D47R0101_00015
    GoTo _06B1
_06AE:
    Message msg_0135_D47R0101_00014
_06B1:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06E7
    SetVarFromValue VAR_0x8004, 30
    BufferNumber 1, VAR_0x8004
    SetVarFromValue VAR_0x8005, 1000
    BufferNumber 2, VAR_0x8005
    Message msg_0135_D47R0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06E7:
    Message msg_0135_D47R0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4057, 7
    GoToIf 1, _0899
_0707:
    CompareVar VAR_HGSS_UNK_4057, 6
    GoToIf 0, _0728
    SetVarFromValue VAR_RESULT, 500
    BufferNumber 1, VAR_RESULT
    Message msg_0135_D47R0101_00001
    GoTo _0736
_0728:
    SetVarFromValue VAR_RESULT, 500
    BufferNumber 1, VAR_RESULT
    Message msg_0135_D47R0101_00000
_0736:
    @ HGSS: ShowMoneyBox 20, 2
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0846
    @ HGSS: CountPCEmptySpace VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0773
    GetPartyCount VAR_0x8004
    CompareVar VAR_0x8004, 6
    GoToIf 1, _0853
_0773:
    CheckMoney VAR_RESULT, 500
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0876
    SetVarFromValue VAR_RESULT, 500
    BufferNumber 1, VAR_RESULT
    Message msg_0135_D47R0101_00002
    PlaySE SEQ_SE_DP_REGI_sseq
    RemoveMoney 500
    @ HGSS: UpdateMoneyBox
    Message msg_0135_D47R0101_00004
    BufferPlayerName 0
    SetVarFromValue VAR_RESULT, 30
    BufferNumber 1, VAR_RESULT
    Message msg_0135_D47R0101_00005
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0135_D47R0101_00006
    CloseMessage
    HideMoney
    @ HGSS: ScrCmd_600
    ApplyMovement LOCALID_PLAYER, _08C4
    WaitMovement
    @ HGSS: ScrCmd_307 0, 0, 5, 5, 77
    Call _08AF
    ApplyMovement LOCALID_PLAYER, _08D0
    WaitMovement
    Call _08B7
    SetVarFromValue VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 1
    @ HGSS: SafariZoneAction 0, 0
    @ HGSS: SetDynamicWarp MAP_SAFARI_ZONE_ENTRANCE_INTERIOR, 1, 5, 2, 1
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_EXTERIOR, 79, 100, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockObject LOCALID_COMPLETE_FOLLOWER
    @ HGSS: ScrCmd_606
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0200
    WaitMovement
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ReleaseAll
    End
_0846:
    HideMoney
    Message msg_0135_D47R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0853:
    HideMoney
    CompareVar VAR_HGSS_UNK_4057, 6
    GoToIf 0, _086B
    Message msg_0135_D47R0101_00013
    GoTo _086E
_086B:
    Message msg_0135_D47R0101_00012
_086E:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0876:
    HideMoney
    CompareVar VAR_HGSS_UNK_4057, 6
    GoToIf 0, _088E
    Message msg_0135_D47R0101_00011
    GoTo _0891
_088E:
    Message msg_0135_D47R0101_00010
_0891:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0899:
    GoToIfSet FLAG_HGSS_UNK_183, _0707
    Message msg_0135_D47R0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_08AF:
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    Return
_08B7:
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    Return
    .balign 4, 0
_08C4:
    WalkNormalEast
    FaceNorth
    EndMovement
    .balign 4, 0
_08D0:
    WalkNormalNorth 4
    EndMovement
scr_seq_D47R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4057, 0
    GoToIf 1, _09DC
    CompareVar VAR_HGSS_UNK_4057, 1
    GoToIf 1, _09DC
    CompareVar VAR_HGSS_UNK_4057, 2
    GoToIf 1, _09DC
    CompareVar VAR_HGSS_UNK_4057, 3
    GoToIf 1, _09DC
    Message msg_0135_D47R0101_00019
_0919:
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 457, 0
    AddMenuEntryImm 458, 1
    AddMenuEntryImm 459, 2
    AddMenuEntryImm 460, 3
    AddMenuEntryImm 461, 4
    AddMenuEntryImm 462, 5
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _09A2
    CompareVar VAR_0x8008, 1
    GoToIf 1, _09AB
    CompareVar VAR_0x8008, 2
    GoToIf 1, _09B4
    CompareVar VAR_0x8008, 3
    GoToIf 1, _09BD
    CompareVar VAR_0x8008, 4
    GoToIf 1, _09C6
    GoTo _09CF
    End
_09A2:
    Message msg_0135_D47R0101_00020
    GoTo _0919
_09AB:
    Message msg_0135_D47R0101_00021
    GoTo _0919
_09B4:
    Message msg_0135_D47R0101_00022
    GoTo _0919
_09BD:
    Message msg_0135_D47R0101_00023
    GoTo _0919
_09C6:
    Message msg_0135_D47R0101_00024
    GoTo _0919
_09CF:
    Message msg_0135_D47R0101_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_09DC:
    Message msg_0135_D47R0101_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4057, 7
    GoToIf 1, _0C21
_09FC:
    @ HGSS: ScrCmd_247
    @ HGSS: NatDexFlagAction 2, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0DF2
    CompareVar VAR_HGSS_UNK_4057, 6
    GoToIf 0, _0A26
    Message msg_0135_D47R0101_00065
    GoTo _0A29
_0A26:
    Message msg_0135_D47R0101_00066
_0A29:
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0BFC
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A5D
    GoTo _0C16
    End
_0A5D:
    Message msg_0135_D47R0101_00071
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 14, 0
    AddMenuEntryImm 15, 1
    AddMenuEntryImm 5, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0AAC
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0B2F
    GoTo _0BFC
    End
_0AAC:
    Message msg_0135_D47R0101_00086
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A5D
    SetVarFromValue VAR_0x8004, 39
    SetVarFromValue VAR_0x8005, 0
    @ HGSS: ScrCmd_226 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B05
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0B11
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0B20
    GoTo _0BB2
    End
_0B05:
    @ HGSS: ScrCmd_283
    GoTo _0A5D
    End
_0B11:
    @ HGSS: ScrCmd_283
    Message msg_0135_D47R0101_00087
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0B20:
    @ HGSS: ScrCmd_283
    Message msg_0135_D47R0101_00085
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0B2F:
    Message msg_0135_D47R0101_00086
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A5D
    SetVarFromValue VAR_0x8004, 39
    SetVarFromValue VAR_0x8005, 0
    @ HGSS: ScrCmd_227 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B88
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0B94
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0BA3
    GoTo _0BB2
    End
_0B88:
    @ HGSS: ScrCmd_283
    GoTo _0A5D
    End
_0B94:
    @ HGSS: ScrCmd_283
    Message msg_0135_D47R0101_00087
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0BA3:
    @ HGSS: ScrCmd_283
    Message msg_0135_D47R0101_00085
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0BB2:
    SetVarFromValue VAR_HGSS_UNK_4133, 1
    Message msg_0135_D47R0101_00081
    @ HGSS: ScrCmd_257 96
    @ HGSS: ScrCmd_822
    @ HGSS: ScrCmd_283
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    @ HGSS: ScrCmd_823 VAR_TEMP_x4000
    Message msg_0135_D47R0101_00082
    Message msg_0135_D47R0101_00088
    @ HGSS: AddWaitingIcon
    @ HGSS: SaveGameNormal VAR_SPECIAL_RESULT
    @ HGSS: RemoveWaitingIcon
    BufferPlayerName 0
    Message msg_0135_D47R0101_00089
    PlaySE SEQ_SE_DP_SAVE_sseq
    WaitSE SEQ_SE_DP_SAVE_sseq
    Message msg_0135_D47R0101_00083
    SetVarFromValue VAR_HGSS_UNK_4133, 0
    CloseMessage
    ReleaseAll
    End
_0BFC:
    Message msg_0135_D47R0101_00085
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C09:
    Message msg_0135_D47R0101_00085
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C16:
    Message msg_0135_D47R0101_00085
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C21:
    GoToIfSet FLAG_HGSS_UNK_183, _09FC
    Message msg_0135_D47R0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4057, 7
    GoToIf 1, _0DFD
_0C4C:
    @ HGSS: ScrCmd_247
    @ HGSS: NatDexFlagAction 2, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0DF2
    @ HGSS: ScrCmd_824 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0C84
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    @ HGSS: ScrCmd_823 VAR_TEMP_x4000
    Message msg_0135_D47R0101_00054
    GoTo _0C8F
_0C84:
    Message msg_0135_D47R0101_00060
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C8F:
    @ HGSS: ShowMoneyBox 20, 2
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0D9F
    @ HGSS: CountPCEmptySpace VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0CCC
    GetPartyCount VAR_0x8004
    CompareVar VAR_0x8004, 6
    GoToIf 1, _0DAC
_0CCC:
    CheckMoney VAR_RESULT, 500
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0DCF
    SetVarFromValue VAR_RESULT, 500
    BufferNumber 1, VAR_RESULT
    Message msg_0135_D47R0101_00055
    PlaySE SEQ_SE_DP_REGI_sseq
    RemoveMoney 500
    @ HGSS: UpdateMoneyBox
    Message msg_0135_D47R0101_00057
    BufferPlayerName 0
    SetVarFromValue VAR_RESULT, 30
    BufferNumber 1, VAR_RESULT
    Message msg_0135_D47R0101_00058
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0135_D47R0101_00059
    CloseMessage
    HideMoney
    @ HGSS: ScrCmd_600
    ApplyMovement LOCALID_PLAYER, _08C4
    WaitMovement
    @ HGSS: ScrCmd_307 0, 0, 19, 5, 77
    Call _08AF
    ApplyMovement LOCALID_PLAYER, _08D0
    WaitMovement
    Call _08B7
    SetVarFromValue VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 3
    @ HGSS: SafariZoneAction 0, 1
    @ HGSS: SetDynamicWarp MAP_SAFARI_ZONE_ENTRANCE_INTERIOR, 2, 19, 2, 1
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_EXTERIOR, 79, 100, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockObject LOCALID_COMPLETE_FOLLOWER
    @ HGSS: ScrCmd_606
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0200
    WaitMovement
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ReleaseAll
    End
_0D9F:
    HideMoney
    Message msg_0135_D47R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DAC:
    HideMoney
    CompareVar VAR_HGSS_UNK_4057, 6
    GoToIf 0, _0DC4
    Message msg_0135_D47R0101_00013
    GoTo _0DC7
_0DC4:
    Message msg_0135_D47R0101_00012
_0DC7:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DCF:
    HideMoney
    CompareVar VAR_HGSS_UNK_4057, 6
    GoToIf 0, _0DE7
    Message msg_0135_D47R0101_00011
    GoTo _0DEA
_0DE7:
    Message msg_0135_D47R0101_00010
_0DEA:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DF2:
    Message msg_0135_D47R0101_00084
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DFD:
    GoToIfSet FLAG_HGSS_UNK_183, _0C4C
    Message msg_0135_D47R0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47R0101_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_247
    @ HGSS: NatDexFlagAction 2, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0E73
    CompareVar VAR_HGSS_UNK_4057, 6
    GoToIf 0, _0E45
    Message msg_0135_D47R0101_00093
    GoTo _0E48
_0E45:
    Message msg_0135_D47R0101_00094
_0E48:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0E68
    Message msg_0135_D47R0101_00095
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0E68:
    Message msg_0135_D47R0101_00096
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0E73:
    Message msg_0135_D47R0101_00092
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4057, 0
    GoToIf 1, _0EF1
    CompareVar VAR_HGSS_UNK_4057, 1
    GoToIf 1, _0EF1
    CompareVar VAR_HGSS_UNK_4057, 2
    GoToIf 1, _0EF1
    CompareVar VAR_HGSS_UNK_4057, 3
    GoToIf 1, _0EF1
    BufferPlayerName 0
    Message msg_0135_D47R0101_00027
    CloseMessage
    ClearFlag FLAG_HGSS_UNK_99D
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_716
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoToIfSet FLAG_HGSS_UNK_99D, _0EFC
    ReleaseAll
    End
_0EF1:
    Message msg_0135_D47R0101_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0EFC:
    @ HGSS: ScreenShake 0, 2, 10, 6
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    Message msg_0135_D47R0101_00091
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
