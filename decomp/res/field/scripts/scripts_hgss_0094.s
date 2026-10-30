#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0117.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D37R0102_rocketm 8
#define obj_D37R0102_gsmiddleman1 10
#define obj_D37R0102_babyboy1_8 11
#define obj_D37R0102_dancer 12

    ScriptEntry scr_seq_D37R0102_000
    ScriptEntry scr_seq_D37R0102_001
    ScriptEntry scr_seq_D37R0102_002
    ScriptEntry scr_seq_D37R0102_003
    ScriptEntry scr_seq_D37R0102_004
    ScriptEntry scr_seq_D37R0102_005
    ScriptEntry scr_seq_D37R0102_006
    ScriptEntry scr_seq_D37R0102_007
    ScriptEntry scr_seq_D37R0102_008
    ScriptEntry scr_seq_D37R0102_009
    ScriptEntry scr_seq_D37R0102_010
    ScriptEntry scr_seq_D37R0102_011
    ScriptEntry scr_seq_D37R0102_012
    ScriptEntry scr_seq_D37R0102_013
    ScriptEntry scr_seq_D37R0102_014
    ScriptEntry scr_seq_D37R0102_015
    ScriptEntry scr_seq_D37R0102_016
    ScriptEntry scr_seq_D37R0102_017
    ScriptEntry scr_seq_D37R0102_018
    ScriptEntry scr_seq_D37R0102_019
    ScriptEntry scr_seq_D37R0102_020
    ScriptEntry scr_seq_D37R0102_021
    ScriptEntry scr_seq_D37R0102_022
    ScriptEntry scr_seq_D37R0102_023
    ScriptEntryEnd
scr_seq_D37R0102_008:
    SetFlag FLAG_HGSS_UNK_1B0
    SetFlag FLAG_HGSS_UNK_1B1
    SetFlag FLAG_HGSS_UNK_1B2
    SetFlag FLAG_HGSS_UNK_1B3
    SetFlag FLAG_HGSS_UNK_1B4
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 1, _0144
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 1, _0144
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 1, _0144
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _00C0
    ClearFlag FLAG_HGSS_UNK_1B1
    ClearFlag FLAG_HGSS_UNK_1B3
    GoTo _0131
_00C0:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00D7
    ClearFlag FLAG_HGSS_UNK_1B2
    GoTo _0131
_00D7:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _00EE
    ClearFlag FLAG_HGSS_UNK_1B3
    GoTo _0131
_00EE:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0105
    ClearFlag FLAG_HGSS_UNK_1B2
    GoTo _0131
_0105:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _011C
    ClearFlag FLAG_HGSS_UNK_1B3
    GoTo _0131
_011C:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0131
    ClearFlag FLAG_HGSS_UNK_1B1
    ClearFlag FLAG_HGSS_UNK_1B2
_0131:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    CallIf 1, _0161
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    End
_0144:
    CompareVar VAR_HGSS_UNK_409F, 1
    GoToIf 5, _015B
    SetFlag FLAG_HGSS_UNK_1B4
    GoTo _015F
_015B:
    ClearFlag FLAG_HGSS_UNK_1B4
_015F:
    End
_0161:
    GetHour VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 4, _017C
    SetFlag FLAG_HGSS_UNK_1B0
    GoTo _0197
_017C:
    CompareVar VAR_MAP_LOCAL_0x01, 9
    GoToIf 3, _0193
    SetFlag FLAG_HGSS_UNK_1B0
    GoTo _0197
_0193:
    ClearFlag FLAG_HGSS_UNK_1B0
_0197:
    Return
scr_seq_D37R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetFlag FLAG_HGSS_SPECIAL_MART_BITTER
    Message msg_0117_D37R0102_00000
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 8
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ClearFlag FLAG_HGSS_SPECIAL_MART_BITTER
    ReleaseAll
    End
scr_seq_D37R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_DAILY_GOT_HAIRCUT, _0331
    ShowMoney 20, 2
    Message msg_0117_D37R0102_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01F5
    GoTo _030C
    End
_01F5:
    CheckMoney VAR_RESULT, 500
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0324
    Message msg_0117_D37R0102_00011
    WaitABPress
    CloseMessage
    HideMoney
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0319
    SetVarFromVar VAR_0x8005, VAR_RESULT
    GetPartyMonSpecies VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0319
    ShowMoney 20, 2
    RemoveMoney 500
    UpdateMoneyDisplay
    Message msg_0117_D37R0102_00012
    WaitABPress
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_WHITE
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HideMoney
    FadeScreen 6, 1, 1, COLOR_WHITE
    WaitFadeScreen
    Message msg_0117_D37R0102_00013
    WaitABPress
    SetFlag FLAG_HGSS_DAILY_GOT_HAIRCUT
    Call _04C8
    GetRandom VAR_RESULT, 100
    CompareVar VAR_RESULT, 40
    GoToIf 4, _02F6
    CompareVar VAR_RESULT, 10
    GoToIf 4, _02E0
    CompareVar VAR_RESULT, 0
    GoToIf 4, _02CA
_02CA:
    IncreasePartyMonFriendship 1, VAR_0x8005
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0117_D37R0102_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02E0:
    IncreasePartyMonFriendship 5, VAR_0x8005
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0117_D37R0102_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02F6:
    IncreasePartyMonFriendship 10, VAR_0x8005
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0117_D37R0102_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_030C:
    Message msg_0117_D37R0102_00014
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_0319:
    Message msg_0117_D37R0102_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0324:
    Message msg_0117_D37R0102_00015
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_0331:
    Message msg_0117_D37R0102_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D37R0102_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_DAILY_GOT_HAIRCUT, _04BD
    ShowMoney 20, 2
    Message msg_0117_D37R0102_00017
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0375
    GoTo _0498
    End
_0375:
    CheckMoney VAR_RESULT, 300
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04B0
    Message msg_0117_D37R0102_00018
    WaitABPress
    CloseMessage
    HideMoney
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _04A5
    SetVarFromVar VAR_0x8005, VAR_RESULT
    GetPartyMonSpecies VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04A5
    ShowMoney 20, 2
    RemoveMoney 300
    UpdateMoneyDisplay
    Message msg_0117_D37R0102_00019
    WaitABPress
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_WHITE
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HideMoney
    FadeScreen 6, 1, 1, COLOR_WHITE
    WaitFadeScreen
    Message msg_0117_D37R0102_00020
    WaitABPress
    SetFlag FLAG_HGSS_DAILY_GOT_HAIRCUT
    GetRandom VAR_RESULT, 100
    CompareVar VAR_RESULT, 40
    GoToIf 4, _0444
    CompareVar VAR_RESULT, 10
    GoToIf 4, _0460
    CompareVar VAR_RESULT, 0
    GoToIf 4, _047C
_0444:
    Call _04C8
    IncreasePartyMonFriendship 1, VAR_0x8005
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0117_D37R0102_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0460:
    Call _04C8
    IncreasePartyMonFriendship 5, VAR_0x8005
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0117_D37R0102_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_047C:
    Call _04D8
    IncreasePartyMonFriendship 10, VAR_0x8005
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0117_D37R0102_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0498:
    Message msg_0117_D37R0102_00021
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_04A5:
    Message msg_0117_D37R0102_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04B0:
    Message msg_0117_D37R0102_00022
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_04BD:
    Message msg_0117_D37R0102_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04C8:
    @ HGSS: MonAddContestValue VAR_SPECIAL_x8005, 1, 16
    @ HGSS: MonAddContestValue VAR_SPECIAL_x8005, 5, 11
    Return
_04D8:
    @ HGSS: MonAddContestValue VAR_SPECIAL_x8005, 1, 24
    @ HGSS: MonAddContestValue VAR_SPECIAL_x8005, 5, 18
    Return
scr_seq_D37R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_AB7, _0895
    ShowMoney 20, 2
    Message msg_0117_D37R0102_00001
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    SetVarFromValue VAR_MAP_LOCAL_0x05, 0
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
_0522:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 445, 0
    AddMenuEntry 446, 1
    AddMenuEntry 447, 2
    AddMenuEntry 448, 3
    AddMenuEntry 449, 4
    AddMenuEntry 450, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _05AB
    CompareVar VAR_0x8008, 1
    GoToIf 1, _05D0
    CompareVar VAR_0x8008, 2
    GoToIf 1, _05F5
    CompareVar VAR_0x8008, 3
    GoToIf 1, _061A
    CompareVar VAR_0x8008, 4
    GoToIf 1, _063F
    GoTo _0886
_05AB:
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 1, _086B
    SetVarFromValue VAR_0x8004, ITEM_NUGGET
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 4500
    GoTo _0664
_05D0:
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 1, _086B
    SetVarFromValue VAR_0x8004, ITEM_PEARL
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 650
    GoTo _0664
_05F5:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 1, _086B
    SetVarFromValue VAR_0x8004, ITEM_BIG_PEARL
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 3500
    GoTo _0664
_061A:
    CompareVar VAR_MAP_LOCAL_0x06, 1
    GoToIf 1, _086B
    SetVarFromValue VAR_0x8004, ITEM_STARDUST
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 900
    GoTo _0664
_063F:
    CompareVar VAR_MAP_LOCAL_0x07, 1
    GoToIf 1, _086B
    SetVarFromValue VAR_0x8004, ITEM_STAR_PIECE
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 4600
    GoTo _0664
_0664:
    BufferItemName 0, VAR_0x8004
    BufferNumber 1, VAR_0x8006
    Message msg_0117_D37R0102_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _068A
    CloseMessage
    GoTo _0522
_068A:
    CompareVar VAR_0x8004, 92
    GoToIf 5, _06CD
    CheckMoney VAR_RESULT, 4500
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0874
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _087D
    RemoveMoney 4500
    GoTo _07C6
_06CD:
    CompareVar VAR_0x8004, 88
    GoToIf 5, _0710
    CheckMoney VAR_RESULT, 650
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0874
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _087D
    RemoveMoney 650
    GoTo _07C6
_0710:
    CompareVar VAR_0x8004, 89
    GoToIf 5, _0753
    CheckMoney VAR_RESULT, 3500
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0874
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _087D
    RemoveMoney 3500
    GoTo _07C6
_0753:
    CompareVar VAR_0x8004, 90
    GoToIf 5, _0796
    CheckMoney VAR_RESULT, 900
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0874
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _087D
    RemoveMoney 900
    GoTo _07C6
_0796:
    CheckMoney VAR_RESULT, 4600
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0874
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _087D
    RemoveMoney 4600
_07C6:
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0117_D37R0102_00003
    Message msg_0117_D37R0102_00004
    AddItem VAR_0x8004, 1, VAR_RESULT
    CompareVar VAR_0x8004, 92
    GoToIf 5, _0803
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    GoTo _0861
_0803:
    CompareVar VAR_0x8004, 88
    GoToIf 5, _081C
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    GoTo _0861
_081C:
    CompareVar VAR_0x8004, 89
    GoToIf 5, _0835
    SetVarFromValue VAR_MAP_LOCAL_0x05, 1
    GoTo _0861
_0835:
    CompareVar VAR_0x8004, 90
    GoToIf 5, _084E
    SetVarFromValue VAR_MAP_LOCAL_0x06, 1
    GoTo _0861
_084E:
    CompareVar VAR_0x8004, 91
    GoToIf 5, _0861
    SetVarFromValue VAR_MAP_LOCAL_0x07, 1
_0861:
    SetFlag FLAG_HGSS_UNK_AB7
    GoTo _0522
_086B:
    Message msg_0117_D37R0102_00005
    GoTo _0522
_0874:
    Message msg_0117_D37R0102_00006
    GoTo _0522
_087D:
    Message msg_0117_D37R0102_00007
    GoTo _0522
_0886:
    HideMoney
    Message msg_0117_D37R0102_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0895:
    Message msg_0117_D37R0102_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D37R0102_004:
    LockAll
    ApplyMovement obj_D37R0102_rocketm, _0AC4
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 7
    GoToIf 5, _08CF
    ApplyMovement obj_D37R0102_rocketm, _0ACC
    GoTo _096B
_08CF:
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _08EA
    ApplyMovement obj_D37R0102_rocketm, _0AD4
    GoTo _096B
_08EA:
    CompareVar VAR_MAP_LOCAL_0x01, 9
    GoToIf 5, _0905
    ApplyMovement obj_D37R0102_rocketm, _0ADC
    GoTo _096B
_0905:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _0920
    ApplyMovement obj_D37R0102_rocketm, _0AE4
    GoTo _096B
_0920:
    CompareVar VAR_MAP_LOCAL_0x01, 11
    GoToIf 5, _093B
    ApplyMovement obj_D37R0102_rocketm, _0AEC
    GoTo _096B
_093B:
    CompareVar VAR_MAP_LOCAL_0x01, 12
    GoToIf 5, _0956
    ApplyMovement obj_D37R0102_rocketm, _0AF4
    GoTo _096B
_0956:
    CompareVar VAR_MAP_LOCAL_0x01, 13
    GoToIf 5, _096B
    ApplyMovement obj_D37R0102_rocketm, _0AFC
_096B:
    WaitMovement
    Message msg_0117_D37R0102_00036
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 7
    GoToIf 5, _09A5
    ApplyMovement obj_D37R0102_rocketm, _0B04
    ApplyMovement LOCALID_PLAYER, _0B70
    GoTo _0A71
_09A5:
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _09C8
    ApplyMovement obj_D37R0102_rocketm, _0B10
    ApplyMovement LOCALID_PLAYER, _0B7C
    GoTo _0A71
_09C8:
    CompareVar VAR_MAP_LOCAL_0x01, 9
    GoToIf 5, _09EB
    ApplyMovement obj_D37R0102_rocketm, _0B20
    ApplyMovement LOCALID_PLAYER, _0B88
    GoTo _0A71
_09EB:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _0A0E
    ApplyMovement obj_D37R0102_rocketm, _0B30
    ApplyMovement LOCALID_PLAYER, _0B94
    GoTo _0A71
_0A0E:
    CompareVar VAR_MAP_LOCAL_0x01, 11
    GoToIf 5, _0A31
    ApplyMovement obj_D37R0102_rocketm, _0B40
    ApplyMovement LOCALID_PLAYER, _0BA0
    GoTo _0A71
_0A31:
    CompareVar VAR_MAP_LOCAL_0x01, 12
    GoToIf 5, _0A54
    ApplyMovement obj_D37R0102_rocketm, _0B50
    ApplyMovement LOCALID_PLAYER, _0BAC
    GoTo _0A71
_0A54:
    CompareVar VAR_MAP_LOCAL_0x01, 13
    GoToIf 5, _0A71
    ApplyMovement obj_D37R0102_rocketm, _0B60
    ApplyMovement LOCALID_PLAYER, _0BB8
_0A71:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: SetAvatarBits PLAYER_TRANSITION_ROCKET
    @ HGSS: UpdateAvatarState
    @ HGSS: RocketCostumeFlagAction 1
    PlaySE SEQ_SE_DP_CARD2_sseq
    WaitTime 24, VAR_RESULT
    PlaySE SEQ_SE_DP_CARD2_sseq
    WaitSE SEQ_SE_DP_CARD2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    Message msg_0117_D37R0102_00037
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0AC4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0ACC:
    Delay2
    EndMovement
    .balign 4, 0
_0AD4:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0ADC:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0AE4:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0AEC:
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_0AF4:
    WalkNormalSouth 5
    EndMovement
    .balign 4, 0
_0AFC:
    WalkNormalSouth 6
    EndMovement
    .balign 4, 0
_0B04:
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B10:
    WalkNormalNorth
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B20:
    WalkNormalNorth 2
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B30:
    WalkNormalNorth 3
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B40:
    WalkNormalNorth 4
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B50:
    WalkNormalNorth 5
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B60:
    WalkNormalNorth 6
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B70:
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0B7C:
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0B88:
    WalkNormalNorth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0B94:
    WalkNormalNorth 4
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0BA0:
    WalkNormalNorth 5
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0BAC:
    WalkNormalNorth 6
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0BB8:
    WalkNormalNorth 7
    WalkOnSpotNormalEast
    EndMovement
scr_seq_D37R0102_009:
    NPCMessage msg_0117_D37R0102_00037
    End
scr_seq_D37R0102_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_0x8007, 0
    CallIfUnset FLAG_HGSS_UNK_08C, _0C0E
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 1, _0C16
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    GoToIf 4, _0C1F
    ReleaseAll
    End
_0C0E:
    SetVarFromValue VAR_0x8007, 1
    Return
_0C16:
    Message msg_0117_D37R0102_00039
    GoTo _0C58
_0C1F:
    Message msg_0117_D37R0102_00049
    GoTo _0C58
_0C28:
    Message msg_0117_D37R0102_00041
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4F
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0CA0
    End
_0C4F:
    Message msg_0117_D37R0102_00044
    GoTo _0C7C
_0C58:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C28
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0DDA
    End
_0C7C:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0CA0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0DDA
    End
_0CA0:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0CC0
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0CCC
    End
_0CC0:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    GoTo _0D17
_0CCC:
    Message msg_0117_D37R0102_00042
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_MAP_LOCAL_0x02
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 255
    GoToIf 1, _0DDA
    GetPartyMonSpecies VAR_MAP_LOCAL_0x02, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0DE5
    GoTo _0D17
_0D17:
    Message msg_0117_D37R0102_00043
    CloseMessage
    GetPlayerDir VAR_0x8006
    CompareVar VAR_0x8006, 0
    GoToIf 1, _0D49
    CompareVar VAR_0x8006, 2
    GoToIf 1, _0D4F
    CompareVar VAR_0x8006, 3
    GoToIf 1, _0D55
    End
_0D49:
    GoTo _0D5B
_0D4F:
    GoTo _0D5B
_0D55:
    GoTo _0D5B
_0D5B:
    SetFlag FLAG_HGSS_UNK_08C
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_154 VAR_TEMP_x4002, VAR_SPECIAL_x8005, VAR_SPECIAL_x8007
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8006, 0
    GoToIf 1, _0DAA
    CompareVar VAR_0x8006, 2
    GoToIf 1, _0DB0
    CompareVar VAR_0x8006, 3
    GoToIf 1, _0DB6
    End
_0DAA:
    GoTo _0DBC
_0DB0:
    GoTo _0DBC
_0DB6:
    GoTo _0DBC
_0DBC:
    CompareVar VAR_0x8005, 0
    GoToIf 1, _0E40
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    Message msg_0117_D37R0102_00045
    CloseMessage
    GoTo _0DEE
_0DDA:
    Message msg_0117_D37R0102_00040
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DE5:
    Message msg_0117_D37R0102_00051
    GoTo _0CCC
_0DEE:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_492 0, VAR_SPECIAL_RESULT, VAR_SPECIAL_x8004
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0E35
    @ HGSS: ScrCmd_256 VAR_SPECIAL_x8004
    @ HGSS: ScrCmd_494 0, VAR_SPECIAL_x8004
    Message msg_0117_D37R0102_00046
    Message msg_0117_D37R0102_00052
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0E35:
    Message msg_0117_D37R0102_00047
    CloseMessage
    GoTo _0DEE
_0E40:
    Message msg_0117_D37R0102_00048
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
    WalkSlowNorth 2
    EndMovement
    .balign 4, 0
    WalkSlowWest
    WalkSlowNorth
    EndMovement
    .balign 4, 0
    WalkSlowEast
    WalkSlowNorth
    EndMovement
    .balign 4, 0
    FaceSouth
    EndMovement
    .balign 4, 0
    WalkSlowSouth 2
    FaceNorth
    EndMovement
    .balign 4, 0
    WalkNormalWest
    FaceEast
    EndMovement
    .balign 4, 0
    WalkNormalWest
    FaceEast
    EndMovement
    .balign 4, 0
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
    WalkNormalWest
    FaceSouth
    EndMovement
    .balign 4, 0
    FaceEast
    EndMovement
    .balign 4, 0
    FaceSouth
    EndMovement
    End
scr_seq_D37R0102_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0117_D37R0102_00029
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0F05
    Message msg_0117_D37R0102_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0F05:
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0FDA
    Message msg_0117_D37R0102_00030
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: SetAvatarBits PLAYER_TRANSITION_ROCKET
    @ HGSS: UpdateAvatarState
    @ HGSS: RocketCostumeFlagAction 1
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0FE8
    ApplyMovement obj_D37R0102_gsmiddleman1, _1000
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0F79
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0FF8
    LockObject LOCALID_COMPLETE_FOLLOWER
    WaitMovement
_0F79:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0117_D37R0102_00031
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 10
    LockAll
    @ HGSS: SetAvatarBits PLAYER_TRANSITION_WALKING
    @ HGSS: UpdateAvatarState
    @ HGSS: RocketCostumeFlagAction 0
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _1010
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0117_D37R0102_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0FDA:
    Message msg_0117_D37R0102_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0FE8:
    WalkFasterNorth 3
    WalkFasterWest 2
    FaceSouth
    EndMovement
    .balign 4, 0
_0FF8:
    FaceSouth
    EndMovement
    .balign 4, 0
_1000:
    WalkFasterSouth 2
    WalkFasterWest 4
    FaceNorth
    EndMovement
    .balign 4, 0
_1010:
    WalkFasterSouth 3
    WalkFasterEast 2
    EndMovement
    .balign 4, 0
    WalkFasterNorth 2
    WalkFasterEast 4
    FaceWest
    EndMovement
scr_seq_D37R0102_011:
    LockAll
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 31
    GoToIf 5, _1055
    ApplyMovement obj_D37R0102_dancer, _10B4
    GoTo _105D
_1055:
    ApplyMovement obj_D37R0102_dancer, _10C8
_105D:
    WaitMovement
    Message msg_0117_D37R0102_00055
    CloseMessage
    ApplyMovement obj_D37R0102_dancer, _10E4
    WaitMovement
    Message msg_0117_D37R0102_00056
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 31
    GoToIf 5, _1094
    ApplyMovement obj_D37R0102_dancer, _10F0
    GoTo _109C
_1094:
    ApplyMovement obj_D37R0102_dancer, _1120
_109C:
    WaitMovement
    RemoveObject obj_D37R0102_dancer
    SetFlag FLAG_HGSS_HIDE_UNDERGROUND_KIMONO_GIRL
    Common_FadeToDefaultMusic
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40E7, 3
    End
    .balign 4, 0
_10B4:
    EmoteExclamationMark
    WalkOnSpotNormalWest
    Delay8
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_10C8:
    EmoteExclamationMark
    WalkOnSpotNormalWest
    Delay8
    WalkNormalWest
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_10E4:
    EmoteExclamationMark
    Delay16
    EndMovement
    .balign 4, 0
_10F0:
    WalkNormalSouth
    WalkNormalWest 3
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_1120:
    WalkNormalNorth
    WalkNormalWest 3
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    WalkNormalWest 7
    EndMovement
scr_seq_D37R0102_007:
    NPCMessage msg_0117_D37R0102_00027
    End
scr_seq_D37R0102_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_BASEMENT_KEY, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _1189
    Message msg_0117_D37R0102_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1189:
    BufferPlayerName 0
    Message msg_0117_D37R0102_00028
    CloseMessage
    ApplyMovement obj_D37R0102_babyboy1_8, _11A4
    WaitMovement
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_1C0
    End
    .balign 4, 0
_11A4:
    WalkNormalEast 2
    EndMovement
scr_seq_D37R0102_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 0, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 1, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 1, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 2, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 2, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 3, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 3, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 4, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 4, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 5, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 5, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 6, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 6, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 7, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 7, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_020:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 8, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 8, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_021:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 9, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 9, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D37R0102_022:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_255 10, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _144B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_155 10, VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_144B:
    Message msg_0117_D37R0102_00053
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D37R0102_023:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_830 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1480
    @ HGSS: ScrCmd_832 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _1521
_1480:
    Message msg_0117_D37R0102_00057
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _1530
    CheckMoney VAR_RESULT, 100
    CompareVar VAR_RESULT, 0
    GoToIf 1, _153F
    RemoveMoney 100
    @ HGSS: ScrCmd_553 5, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _154E
    @ HGSS: ScrCmd_831 VAR_SPECIAL_x8004
    @ HGSS: ScrCmd_404 VAR_SPECIAL_x8004, 1, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _155B
    Message msg_0117_D37R0102_00061
    SetVarFromValue VAR_0x8005, 1
    Common_GiveAccessory
_14EB:
    @ HGSS: ScrCmd_832 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _1530
    @ HGSS: ScrCmd_553 95, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _1530
    @ HGSS: ScrCmd_833 VAR_SPECIAL_x8004
    Message msg_0117_D37R0102_00062
    Common_ObtainContestBackdrop
    GoTo _1530
    End
_1521:
    Message msg_0117_D37R0102_00058
    WaitButton
    CloseMessage
    GoTo _1568
    End
_1530:
    Message msg_0117_D37R0102_00059
    WaitButton
    CloseMessage
    GoTo _1568
    End
_153F:
    Message msg_0117_D37R0102_00060
    WaitButton
    CloseMessage
    GoTo _1568
    End
_154E:
    Message msg_0117_D37R0102_00064
    CloseMessage
    GoTo _1530
    End
_155B:
    Message msg_0117_D37R0102_00064
    CloseMessage
    GoTo _14EB
    End
_1568:
    ReleaseAll
    End
    .balign 4, 0
