#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0065.h"

#define obj_D23R0101_gsrivel 5
#define obj_D23R0101_rocketm 6
#define obj_D23R0101_gsleader3 7

    ScriptEntry scr_seq_D23R0101_000
    ScriptEntry scr_seq_D23R0101_001
    ScriptEntry scr_seq_D23R0101_002
    ScriptEntry scr_seq_D23R0101_003
    ScriptEntry scr_seq_D23R0101_004
    ScriptEntry scr_seq_D23R0101_005
    ScriptEntry scr_seq_D23R0101_006
    ScriptEntry scr_seq_D23R0101_007
    ScriptEntry scr_seq_D23R0101_008
    ScriptEntry scr_seq_D23R0101_009
    ScriptEntry scr_seq_D23R0101_010
    ScriptEntryEnd
scr_seq_D23R0101_008:
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_6
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 5, _004D
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_6
    GoTo _0085
_004D:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0066
    GoTo _008B
_0060:
    GoTo _0085
_0066:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0081
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_6
    ClearFlag FLAG_HGSS_HIDE_RADIO_TOWER_RIVAL
    GoTo _0085
_0081:
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
_0085:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 0
_008B:
    End
scr_seq_D23R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 5, _00AB
    Message msg_0065_D23R0101_00001
    GoTo _00DA
_00AB:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _00C1
    Message msg_0065_D23R0101_00001
    GoTo _00DA
_00C1:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _00D7
    Message msg_0065_D23R0101_00002
    GoTo _00DA
_00D7:
    Message msg_0065_D23R0101_00000
_00DA:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0065_D23R0101_00014
    ApplyMovement obj_D23R0101_gsleader3, _036C
    WaitMovement
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_RADIO_CARD, _0243
    Message msg_0065_D23R0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0221
    Message msg_0065_D23R0101_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _022E
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0065_D23R0101_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _022E
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0065_D23R0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _022E
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0065_D23R0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _022E
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0065_D23R0101_00008
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _022E
    WaitTime 30, VAR_RESULT
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0065_D23R0101_00009
    BufferPlayerName 0
    Message msg_0065_D23R0101_00010
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    CloseMessage
    @ HGSS: RegisterPokegearCard 2
    SetFlag FLAG_HGSS_GOT_RADIO_CARD
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D23R0101_gsleader3, _0250
    ApplyMovement LOCALID_PLAYER, _0270
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0065_D23R0101_00015
    CloseMessage
    ApplyMovement obj_D23R0101_gsleader3, _0264
    WaitTime 24, VAR_RESULT
    ApplyMovement LOCALID_PLAYER, _036C
    WaitMovement
    RemoveObject obj_D23R0101_gsleader3
    SetFlag FLAG_HGSS_UNK_318
    ReleaseAll
    End
_0221:
    Message msg_0065_D23R0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_022E:
    PlaySE SEQ_SE_DP_BOX03_sseq
    WaitSE SEQ_SE_DP_BOX03_sseq
    Message msg_0065_D23R0101_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0243:
    Message msg_0065_D23R0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0250:
    EmoteExclamationMark
    JumpOnSpotFastWest 2
    WalkSlightlyFastNorth 3
    WalkSlightlyFastWest
    EndMovement
    .balign 4, 0
_0264:
    WalkSlightlyFastNorth
    WalkSlightlyFastWest 10
    EndMovement
    .balign 4, 0
_0270:
    Delay8 6
    WalkSlightlyFastNorth
    FaceEast
    EndMovement
scr_seq_D23R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0065_D23R0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0065_D23R0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 1, _02C2
    Message msg_0065_D23R0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02C2:
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    GoToIf 1, _0316
    Message msg_0065_D23R0101_00019
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _02F5
    ApplyMovement obj_D23R0101_rocketm, _0354
    GoTo _030A
_02F5:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _030A
    ApplyMovement obj_D23R0101_rocketm, _0360
_030A:
    WaitMovement
    ReleaseAll
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    End
_0316:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0333
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 33
    GoTo _0346
_0333:
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0346
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 11
_0346:
    Message msg_0065_D23R0101_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0354:
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0360:
    WalkNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_036C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0374:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_037C:
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_D23R0101_009:
    LockAll
    SetPosition obj_D23R0101_gsrivel, 13, 1, 6, DIR_EAST
    Common_SetRivalBGM
    .short SCRCMD_UNUSED_06A
    .short 6
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _03D0
    ApplyMovement obj_D23R0101_gsrivel, _0670
    CompareVar VAR_MAP_LOCAL_0x0B, 33
    GoToIf 5, _03CA
    ApplyMovement obj_D23R0101_rocketm, _069C
_03CA:
    GoTo _03FA
_03D0:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _03FA
    ApplyMovement obj_D23R0101_gsrivel, _067C
    CompareVar VAR_MAP_LOCAL_0x0B, 11
    GoToIf 5, _03FA
    ApplyMovement obj_D23R0101_rocketm, _06A8
_03FA:
    WaitMovement
    BufferRivalName 1
    Message msg_0065_D23R0101_00021
    CloseMessage
    ApplyMovement obj_D23R0101_gsrivel, _0664
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _0431
    ApplyMovement obj_D23R0101_gsrivel, _0684
    ApplyMovement obj_D23R0101_rocketm, _06B4
    GoTo _044E
_0431:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _044E
    ApplyMovement obj_D23R0101_gsrivel, _0690
    ApplyMovement obj_D23R0101_rocketm, _06C8
_044E:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _046B
    ApplyMovement LOCALID_PLAYER, _06E4
    GoTo _0480
_046B:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _0480
    ApplyMovement LOCALID_PLAYER, _06EC
_0480:
    WaitMovement
    BufferPlayerName 0
    BufferRivalName 1
    Message msg_0065_D23R0101_00022
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _04A8
    ApplyMovement LOCALID_PLAYER, _06FC
    GoTo _04BD
_04A8:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _04BD
    ApplyMovement LOCALID_PLAYER, _07BC
_04BD:
    WaitTime 50, VAR_RESULT
    @ HGSS: SetAvatarBits PLAYER_TRANSITION_WALKING
    @ HGSS: UpdateAvatarState
    @ HGSS: RocketCostumeFlagAction 0
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _04E9
    ApplyMovement obj_D23R0101_rocketm, _0874
    GoTo _04FE
_04E9:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _04FE
    ApplyMovement obj_D23R0101_rocketm, _0890
_04FE:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _0523
    ApplyMovement obj_D23R0101_rocketm, _08AC
    ApplyMovement obj_D23R0101_gsrivel, _08BC
    GoTo _0540
_0523:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _0540
    ApplyMovement obj_D23R0101_rocketm, _08B4
    ApplyMovement obj_D23R0101_gsrivel, _08D4
_0540:
    WaitMovement
    Message msg_0065_D23R0101_00023
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_GRUNT_3, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0655
    Message msg_0065_D23R0101_00024
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _0592
    ApplyMovement obj_D23R0101_rocketm, _08EC
    ApplyMovement LOCALID_PLAYER, _0900
    GoTo _05AF
_0592:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _05AF
    ApplyMovement obj_D23R0101_rocketm, _08F4
    ApplyMovement LOCALID_PLAYER, _0914
_05AF:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    RemoveObject obj_D23R0101_rocketm
    Common_SetRivalBGM
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _05DE
    ApplyMovement obj_D23R0101_gsrivel, _0928
    GoTo _05F3
_05DE:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _05F3
    ApplyMovement obj_D23R0101_gsrivel, _0930
_05F3:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 5, _0610
    ApplyMovement LOCALID_PLAYER, _06DC
    GoTo _0625
_0610:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _0625
    ApplyMovement LOCALID_PLAYER, _06F4
_0625:
    WaitMovement
    BufferRivalName 1
    Message msg_0065_D23R0101_00025
    CloseMessage
    ApplyMovement obj_D23R0101_gsrivel, _0938
    WaitMovement
    RemoveObject obj_D23R0101_gsrivel
    Common_FadeToDefaultMusic2
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    SetFlag FLAG_HGSS_HIDE_RADIO_TOWER_RIVAL
    SetVarFromValue VAR_HGSS_UNK_409F, 1
    End
_0655:
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0664:
    Delay16
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0670:
    WalkFastEast 9
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_067C:
    WalkFastEast 9
    EndMovement
    .balign 4, 0
_0684:
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0690:
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_069C:
    Delay4 9
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06A8:
    Delay4 9
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_06B4:
    FaceEast
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
    .balign 4, 0
_06C8:
    FaceNorth
    LockDir
    WalkNormalSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_06DC:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_06E4:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_06EC:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_06F4:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06FC:
    Delay4
    FaceEast
    Delay4
    FaceSouth
    Delay4
    FaceWest
    Delay4
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    Delay1
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
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
    Delay2
    FaceEast
    Delay4
    FaceSouth
    Delay4
    FaceWest
    EndMovement
    .balign 4, 0
_07BC:
    Delay4
    FaceWest
    Delay4
    FaceNorth
    Delay4
    FaceEast
    Delay4
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
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
    Delay2
    FaceNorth
    Delay4
    FaceEast
    Delay4
    FaceSouth
    EndMovement
    .balign 4, 0
_0874:
    Delay16
    FaceEast
    LockDir
    WalkFastWest 2
    UnlockDir
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0890:
    Delay16
    FaceNorth
    LockDir
    WalkFastSouth 2
    UnlockDir
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_08AC:
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_08B4:
    WalkFastNorth 3
    EndMovement
    .balign 4, 0
_08BC:
    Delay4
    FaceNorth
    LockDir
    WalkFastSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_08D4:
    Delay4
    FaceEast
    LockDir
    WalkFastWest
    UnlockDir
    EndMovement
    .balign 4, 0
_08EC:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_08F4:
    WalkNormalNorth
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0900:
    FaceNorth
    LockDir
    WalkNormalSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_0914:
    FaceEast
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
    .balign 4, 0
_0928:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0930:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0938:
    WalkNormalWest 9
    EndMovement
scr_seq_D23R0101_006:
    NPCMessage msg_0065_D23R0101_00026
    End
scr_seq_D23R0101_007:
    NPCMessage msg_0065_D23R0101_00027
    End
scr_seq_D23R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4136, 0
    GoToIf 5, _0B86
    GoToIfSet FLAG_HGSS_UNK_AA6, _09CF
    GoToIfSet FLAG_HGSS_UNK_AA5, _09AF
    Message msg_0065_D23R0101_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09E5
    GoTo _09DA
_09AF:
    Message msg_0065_D23R0101_00045
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09E5
    GoTo _09DA
    End
_09CF:
    Message msg_0065_D23R0101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_09DA:
    Message msg_0065_D23R0101_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_09E5:
    SetFlag FLAG_HGSS_UNK_AA5
    Message msg_0065_D23R0101_00031
    @ HGSS: LotoIDGet VAR_SPECIAL_x8000
    @ HGSS: BufferIntEx 0, VAR_SPECIAL_x8000, 2, 5
    Message msg_0065_D23R0101_00032
    @ HGSS: LotoIDSearch VAR_SPECIAL_x8001, VAR_SPECIAL_x8002, VAR_SPECIAL_x8003, VAR_SPECIAL_x8000
    CompareVar VAR_0x8002, 0
    GoToIf 1, _0A24
    CompareVar VAR_0x8003, 0
    GoToIf 1, _0A2F
    GoTo _0A3D
_0A24:
    Message msg_0065_D23R0101_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0A2F:
    BufferPartyMonNickname 0, VAR_0x8001
    Message msg_0065_D23R0101_00033
    GoTo _0A4B
_0A3D:
    @ HGSS: BufferBoxMonNick 0, VAR_SPECIAL_x8001
    Message msg_0065_D23R0101_00034
    GoTo _0A4B
_0A4B:
    SetVar VAR_0x8008, VAR_0x8002
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0A94
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0A9F
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0AA8
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0AB1
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0ABA
    End
_0A94:
    Message msg_0065_D23R0101_00036
    GoTo _0AC3
    End
_0A9F:
    Message msg_0065_D23R0101_00038
    GoTo _0AC3
_0AA8:
    Message msg_0065_D23R0101_00039
    GoTo _0AC3
_0AB1:
    Message msg_0065_D23R0101_00040
    GoTo _0AC3
_0ABA:
    Message msg_0065_D23R0101_00041
    GoTo _0AC3
_0AC3:
    SetVar VAR_0x8008, VAR_0x8002
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0B0C
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0B1A
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0B26
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0B32
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0B3E
    End
_0B0C:
    SetVarFromValue VAR_0x8003, 2
    GoTo _0B4A
    End
_0B1A:
    SetVarFromValue VAR_0x8003, 51
    GoTo _0B4A
_0B26:
    SetVarFromValue VAR_0x8003, 216
    GoTo _0B4A
_0B32:
    SetVarFromValue VAR_0x8003, 29
    GoTo _0B4A
_0B3E:
    SetVarFromValue VAR_0x8003, 1
    GoTo _0B4A
_0B4A:
    SetVar VAR_0x8004, VAR_0x8003
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B75
    Common_GiveItemQuantity
    GoTo _0B98
_0B75:
    SetVarFromVar VAR_HGSS_UNK_4136, VAR_0x8002
    Message msg_0065_D23R0101_00042
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0B86:
    BufferPlayerName 0
    Message msg_0065_D23R0101_00043
    SetVarFromVar VAR_0x8002, VAR_HGSS_UNK_4136
    GoTo _0AC3
_0B98:
    SetVarFromValue VAR_HGSS_UNK_4136, 0
    SetFlag FLAG_HGSS_UNK_AA6
    Message msg_0065_D23R0101_00044
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
