#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0384.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R34_gswoman3 5
#define obj_R34_gswoman3_2 6
#define obj_R34_gswoman3_3 7
#define obj_R34_gsoldman1 10
#define obj_R34_var_1 11
#define obj_R34_tsure_poke_static_marill 12
#define obj_R34_gsmiddleman1_2 15

    ScriptEntry scr_seq_R34_000
    ScriptEntry scr_seq_R34_001
    ScriptEntry scr_seq_R34_002
    ScriptEntry scr_seq_R34_003
    ScriptEntry scr_seq_R34_004
    ScriptEntry scr_seq_R34_005
    ScriptEntry scr_seq_R34_006
    ScriptEntry scr_seq_R34_007
    ScriptEntry scr_seq_R34_008
    ScriptEntry scr_seq_R34_009
    ScriptEntry scr_seq_R34_010
    ScriptEntry scr_seq_R34_011
    ScriptEntry scr_seq_R34_012
    ScriptEntryEnd
scr_seq_R34_000:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    @ HGSS: CheckDaycareEgg VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0057
    @ HGSS: SetObjectMovementType obj_R34_gsoldman1, 16
    GoTo _005D
_0057:
    @ HGSS: SetObjectMovementType obj_R34_gsoldman1, 15
_005D:
    GoToIfUnset FLAG_HGSS_UNK_189, _006E
    ClearFlag FLAG_HGSS_UNK_189
    End
_006E:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _009F
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _00A9
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _00A9
_009F:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _00AD
_00A9:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
_00AD:
    @ HGSS: ScrCmd_379 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _00D5
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _00D5
    ClearFlag FLAG_HGSS_UNK_1D1
    SetFlag FLAG_HGSS_UNK_1D2
    End
_00D5:
    ClearFlag FLAG_HGSS_UNK_1D2
    SetFlag FLAG_HGSS_UNK_1D1
    End
scr_seq_R34_001:
    LockAll
    ApplyMovement obj_R34_gsoldman1, _0130
    ApplyMovement LOCALID_PLAYER, _0140
    WaitMovement
    Message msg_0384_R34_00046
    BufferPlayerName 0
    @ HGSS: RegisterGearNumber PHONE_CONTACT_DAY_C_MAN
    Message msg_0384_R34_00047
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_DAY_C_LADY
    Message msg_0384_R34_00048
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0384_R34_00049
    CloseMessage
    ApplyMovement obj_R34_gsoldman1, _014C
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_408E, 3
    ReleaseAll
    End
    .balign 4, 0
_0130:
    EmoteExclamationMark
    WalkNormalSouth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0140:
    Delay8 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_014C:
    WalkNormalWest 2
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_R34_003:
    LockAll
    MessageGendered msg_0384_R34_00036, msg_0384_R34_00041
    CloseMessage
    ApplyMovement obj_R34_gsoldman1, _0510
    WaitMovement
    Common_SetCounterpartBGM
    ApplyMovement obj_R34_var_1, _049C
    ApplyMovement obj_R34_tsure_poke_static_marill, _04B0
    WaitMovement
    ApplyMovement obj_R34_gsoldman1, _0500
    WaitMovement
    MessageGendered msg_0384_R34_00037, msg_0384_R34_00042
    CloseMessage
    ApplyMovement obj_R34_var_1, _04F8
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    BufferPlayerName 0
    CompareVar VAR_0x8004, 368
    GoToIf 5, _01D4
    ApplyMovement obj_R34_var_1, _04C0
    ApplyMovement obj_R34_tsure_poke_static_marill, _04CC
    ApplyMovement obj_R34_gsoldman1, _0494
    GoTo _0207
_01D4:
    CompareVar VAR_0x8004, 369
    GoToIf 5, _01FF
    ApplyMovement obj_R34_var_1, _04C0
    ApplyMovement obj_R34_tsure_poke_static_marill, _04CC
    ApplyMovement obj_R34_gsoldman1, _0494
    GoTo _0207
_01FF:
    ApplyMovement obj_R34_var_1, _0518
_0207:
    WaitMovement
    MessageGendered msg_0384_R34_00038, msg_0384_R34_00043
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8004, 363
    GoToIf 5, _0234
    ApplyMovement LOCALID_PLAYER, _0528
    GoTo _02C3
_0234:
    CompareVar VAR_0x8004, 364
    GoToIf 5, _024F
    ApplyMovement LOCALID_PLAYER, _0534
    GoTo _02C3
_024F:
    CompareVar VAR_0x8004, 365
    GoToIf 5, _026A
    ApplyMovement LOCALID_PLAYER, _053C
    GoTo _02C3
_026A:
    CompareVar VAR_0x8004, 366
    GoToIf 5, _0285
    ApplyMovement LOCALID_PLAYER, _0548
    GoTo _02C3
_0285:
    CompareVar VAR_0x8004, 367
    GoToIf 5, _02A0
    ApplyMovement LOCALID_PLAYER, _0554
    GoTo _02C3
_02A0:
    CompareVar VAR_0x8004, 368
    GoToIf 5, _02BB
    ApplyMovement LOCALID_PLAYER, _0560
    GoTo _02C3
_02BB:
    ApplyMovement LOCALID_PLAYER, _056C
_02C3:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_0x8004, 368
    GoToIf 5, _02EA
    ApplyMovement obj_R34_var_1, _0510
    GoTo _030D
_02EA:
    CompareVar VAR_0x8004, 369
    GoToIf 5, _0305
    ApplyMovement obj_R34_var_1, _0510
    GoTo _030D
_0305:
    ApplyMovement obj_R34_var_1, _0508
_030D:
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0384_R34_00039, msg_0384_R34_00044
    CloseMessage
    CompareVar VAR_0x8004, 368
    GoToIf 5, _033B
    ApplyMovement obj_R34_var_1, _04D4
    ApplyMovement obj_R34_tsure_poke_static_marill, _04E8
    GoTo _036E
_033B:
    CompareVar VAR_0x8004, 369
    GoToIf 5, _035E
    ApplyMovement obj_R34_var_1, _04D4
    ApplyMovement obj_R34_tsure_poke_static_marill, _04E8
    GoTo _036E
_035E:
    ApplyMovement obj_R34_var_1, _04E0
    ApplyMovement obj_R34_tsure_poke_static_marill, _04F0
_036E:
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0384_R34_00040, msg_0384_R34_00045
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8004, 368
    GoToIf 5, _03AE
    ApplyMovement obj_R34_var_1, _0578
    ApplyMovement obj_R34_tsure_poke_static_marill, _0590
    ApplyMovement LOCALID_PLAYER, _05A4
    GoTo _03F1
_03AE:
    CompareVar VAR_0x8004, 369
    GoToIf 5, _03D9
    ApplyMovement obj_R34_var_1, _0578
    ApplyMovement obj_R34_tsure_poke_static_marill, _0590
    ApplyMovement LOCALID_PLAYER, _05A4
    GoTo _03F1
_03D9:
    ApplyMovement obj_R34_var_1, _0584
    ApplyMovement obj_R34_tsure_poke_static_marill, _0598
    ApplyMovement LOCALID_PLAYER, _05B4
_03F1:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    @ HGSS: ScrCmd_307 11, 12, 16, 26, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_R34_var_1, _05C4
    ApplyMovement obj_R34_tsure_poke_static_marill, _05D0
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _05E0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0455
    @ HGSS: ScrCmd_600
_0455:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    WaitFadeScreen
    @ HGSS: ScrCmd_309 77
    SetVarFromValue VAR_HGSS_UNK_408E, 1
    Warp MAP_HEADER_HGSS_ROUTE_34_DAYCARE, 3, 12, DIR_NORTH
    @ HGSS: ScrCmd_582 MAP_ROUTE_34, 368, 411
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0494:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_049C:
    WalkNormalSouth 6
    WalkNormalEast 3
    WalkNormalSouth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_04B0:
    WalkNormalSouth 7
    WalkNormalEast 3
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_04C0:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_04CC:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_04D4:
    WalkNormalEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04E0:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_04E8:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_04F0:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_04F8:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0500:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0508:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0510:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0518:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0520:
    SetInvisible
    EndMovement
    .balign 4, 0
_0528:
    WalkNormalEast
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0534:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_053C:
    WalkNormalWest
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0548:
    WalkNormalWest 2
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0554:
    WalkNormalWest 3
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0560:
    WalkNormalWest 3
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_056C:
    WalkNormalWest 4
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0578:
    WalkNormalEast 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0584:
    WalkNormalEast 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0590:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0598:
    WalkNormalSouth
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_05A4:
    Delay8
    WalkNormalEast 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05B4:
    Delay8
    WalkNormalEast 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05C4:
    WalkNormalNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_05D0:
    WalkNormalEast
    WalkNormalNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_05E0:
    WalkNormalNorth 2
    SetInvisible
    EndMovement
scr_seq_R34_002:
    NPCMessage msg_0384_R34_00018
    End
scr_seq_R34_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0727
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _073B
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0678
    ApplyMovement LOCALID_PLAYER, _0750
    ApplyMovement obj_R34_gsmiddleman1_2, _079C
    GoTo _06C6
_0678:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0693
    ApplyMovement LOCALID_PLAYER, _0768
    GoTo _06C6
_0693:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _06B6
    ApplyMovement LOCALID_PLAYER, _0788
    ApplyMovement obj_R34_gsmiddleman1_2, _079C
    GoTo _06C6
_06B6:
    ApplyMovement LOCALID_PLAYER, _0774
    ApplyMovement obj_R34_gsmiddleman1_2, _079C
_06C6:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _06ED
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _07A8
    WaitMovement
_06ED:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 9
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0727:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_073B:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0750:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0768:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0774:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0788:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_079C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07A8:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_R34_004:
    LockAll
    @ HGSS: CountAliveMons VAR_TEMP_x4003, 6
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 5, _07DB
    GoTo _07E1
_07D5:
    GoTo _07E1
_07DB:
    GoTo _087D
_07E1:
    ApplyMovement obj_R34_gswoman3, _0918
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0944
    WaitMovement
    Message msg_0384_R34_00019
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_ACE_TRAINER_F_IRENE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0912
    ApplyMovement obj_R34_gswoman3, _094C
    WaitMovement
    Message msg_0384_R34_00021
    CloseMessage
    ApplyMovement obj_R34_gswoman3_2, _0924
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _093C
    WaitMovement
    Message msg_0384_R34_00024
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_ACE_TRAINER_F_JENN, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0912
    ApplyMovement obj_R34_gswoman3_2, _0954
    WaitMovement
    Message msg_0384_R34_00026
    WaitButton
    CloseMessage
    GoTo _0908
    End
_087D:
    ApplyMovement obj_R34_gswoman3, _0918
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0944
    WaitMovement
    Message msg_0384_R34_00019
    CloseMessage
    ApplyMovement obj_R34_gswoman3_2, _0924
    PlayMusic SEQ_TOWN01_D_sseq
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _093C
    WaitMovement
    Message msg_0384_R34_00024
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_ACE_TRAINER_F_JENN, 120, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0912
    ApplyMovement obj_R34_gswoman3, _094C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0944
    WaitMovement
    Message msg_0384_R34_00021
    CloseMessage
    ApplyMovement obj_R34_gswoman3_2, _0954
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _093C
    WaitMovement
    Message msg_0384_R34_00026
    WaitButton
    CloseMessage
_0908:
    SetVarFromValue VAR_HGSS_UNK_4097, 1
    ReleaseAll
    End
_0912:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0918:
    EmoteExclamationMark
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_0924:
    EmoteExclamationMark
    WalkNormalEast 4
    EndMovement
    .balign 4, 0
_0930:
    EmoteExclamationMark
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_093C:
    FaceWest
    EndMovement
    .balign 4, 0
_0944:
    FaceEast
    EndMovement
    .balign 4, 0
_094C:
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_0954:
    JumpOnSpotFastEast 2
    EndMovement
scr_seq_R34_005:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x04, 777
    ApplyMovement obj_R34_gswoman3_3, _0930
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    WaitMovement
    Message msg_0384_R34_00028
    CloseMessage
    StopMusic
    @ HGSS: TrainerBattle TRAINER_ACE_TRAINER_F_KATE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0912
    SetVarFromValue VAR_HGSS_UNK_4097, 2
_09A0:
    Message msg_0384_R34_00030
    SetVar VAR_0x8004, ITEM_POWER_HERB
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _09EE
    Common_GiveItemQuantity
    SetVarFromValue VAR_HGSS_UNK_4097, 3
    Message msg_0384_R34_00032
    WaitButton
    CloseMessage
_09D5:
    CompareVar VAR_MAP_LOCAL_0x04, 777
    GoToIf 5, _09EA
    ReleaseAll
    GoTo _09EC
_09EA:
    ReleaseAll
_09EC:
    End
_09EE:
    Common_MessageBagIsFull
    CloseMessage
    GoTo _09D5
    End
scr_seq_R34_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4097, 1
    GoToIf 5, _0A1A
    Message msg_0384_R34_00022
    GoTo _0A1D
_0A1A:
    Message msg_0384_R34_00023
_0A1D:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R34_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4097, 1
    GoToIf 5, _0A43
    Message msg_0384_R34_00026
    GoTo _0A46
_0A43:
    Message msg_0384_R34_00027
_0A46:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R34_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x04, 555
    CompareVar VAR_HGSS_UNK_4097, 2
    GoToIf 1, _09A0
    Message msg_0384_R34_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R34_009:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0384_R34_00034, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R34_010:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0384_R34_00035, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R34_011:
    DrawSignpostInstantMessage msg_0384_R34_00033, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
