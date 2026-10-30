#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0363.h"

#define obj_R25_gsleader11 8
#define obj_R25_gsman1 9
#define obj_R25_tsure_poke_static_suicune 12
#define obj_R25_minaki 13
#define obj_R25_minaki_2 14
#define obj_R25_gsleader11_2 15

    ScriptEntry scr_seq_R25_000
    ScriptEntry scr_seq_R25_001
    ScriptEntry scr_seq_R25_002
    ScriptEntry scr_seq_R25_003
    ScriptEntry scr_seq_R25_004
    ScriptEntry scr_seq_R25_005
    ScriptEntry scr_seq_R25_006
    ScriptEntry scr_seq_R25_007
    ScriptEntry scr_seq_R25_008
    ScriptEntry scr_seq_R25_009
    ScriptEntryEnd
scr_seq_R25_003:
    GoToIfUnset FLAG_HGSS_UNK_189, _0258
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_R25_008:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _02DB
    End
scr_seq_R25_000:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _02E9
    ApplyMovement obj_R25_gsleader11, _07EA
    ApplyMovement obj_R25_gsman1, _07FC
    ApplyMovement LOCALID_PLAYER, _0816
    GoTo _0314
scr_seq_R25_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0341
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _03C5
    Message msg_0363_R25_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03CE
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0411
    End
scr_seq_R25_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_NUGGET_FROM_ACE_TRAINER_M_KEVIN, _0422
    Message msg_0363_R25_00011
    SetVar VAR_0x8004, ITEM_NUGGET
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _042D
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_NUGGET_FROM_ACE_TRAINER_M_KEVIN
    Message msg_0363_R25_00013
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_ACE_TRAINER_M_KEVIN, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0437
    Message msg_0363_R25_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R25_004:
    LockAll
    SetFlag FLAG_HGSS_HIDE_ROUTE_14_EUSINE_2
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE
    AddObject obj_R25_minaki
    ApplyMovement LOCALID_PLAYER, _0820
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_R25_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_R25_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_R25_tsure_poke_static_suicune
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _043D
    ApplyMovement LOCALID_PLAYER, _0826
    GoTo _0458
scr_seq_R25_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0363_R25_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R25_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0363_R25_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R25_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_R25_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_R25_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_R25_tsure_poke_static_suicune
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_SUICUNE, 40, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04A6
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _04AC
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _04B0
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _04B6
    BufferPlayerName 0
    Message msg_0363_R25_00018
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FA0
    GoToIfSet FLAG_HGSS_HIDE_ROUTE_25_EUSINE_2, _04DF
    GoTo _04FF
scr_seq_R25_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0363_R25_00015, VAR_RESULT
    Common_HandleSignpostInput
    End
_0258:
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 2
    GoToIf 5, _0523
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE_2
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0591
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 1
    GoToIf 1, _0591
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 2
    GoToIf 1, _0591
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0597
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _059D
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _05B8
    ClearFlag FLAG_HGSS_UNK_2CD
    GoTo _05CF
_02DB:
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_SUICUNE
    RemoveObject obj_R25_tsure_poke_static_suicune
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_02E9:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _05D1
    ApplyMovement obj_R25_gsleader11, _07EA
    ApplyMovement obj_R25_gsman1, _0830
    ApplyMovement LOCALID_PLAYER, _0816
    GoTo _0314
_0314:
    WaitMovement
    StopMusic
    PlayMusic SEQ_GS_EYE_K_SHOUJO_sseq
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _0616
    ApplyMovement obj_R25_gsleader11, _084A
    ApplyMovement LOCALID_PLAYER, _0854
    GoTo _0639
_0341:
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0663
    @ HGSS: ScrCmd_733 11, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0663
    Message msg_0363_R25_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _066E
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0679
    Message msg_0363_R25_00007
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 84
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0363_R25_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03C5:
    Message msg_0363_R25_00005
    GoTo _0684
_03CE:
    BufferPlayerName 0
    Message msg_0363_R25_00002
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_MISTY
    Message msg_0363_R25_00003
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_2CD
    RemoveObject obj_R25_gsleader11_2
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0411:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0363_R25_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0422:
    Message msg_0363_R25_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_042D:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0437:
    BlackOutFromBattle
    ReleaseAll
    End
_043D:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _06A8
    ApplyMovement LOCALID_PLAYER, _085E
    GoTo _0458
_0458:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_R25_minaki, _0870
    ApplyMovement LOCALID_PLAYER, _0882
    WaitMovement
    Message msg_0363_R25_00016
    CloseMessage
    ApplyMovement obj_R25_minaki, _088C
    ApplyMovement LOCALID_PLAYER, _0896
    WaitMovement
    Message msg_0363_R25_00017
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_25, 2
    ReleaseAll
    End
_04A6:
    BlackOutFromBattle
    ReleaseAll
    End
_04AC:
    ReleaseAll
    End
_04B0:
    SetFlag FLAG_HGSS_CAUGHT_SUICUNE
    Return
_04B6:
    WaitTime 20, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _08A0
    WaitMovement
    BufferPlayerName 0
    Message msg_0363_R25_00019
    CloseMessage
    GoToIfSet FLAG_HGSS_HIDE_ROUTE_25_EUSINE_2, _04DF
    GoTo _04FF
_04DF:
    ApplyMovement LOCALID_PLAYER, _08A6
    ApplyMovement obj_R25_minaki, _08B0
    WaitMovement
    RemoveObject obj_R25_minaki
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE
    GoTo _06FE
_04FF:
    ApplyMovement LOCALID_PLAYER, _08A6
    ApplyMovement obj_R25_minaki_2, _08B0
    WaitMovement
    RemoveObject obj_R25_minaki_2
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE_2
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_25, 3
    ReleaseAll
    End
_0523:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0591
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 1
    GoToIf 1, _0591
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 2
    GoToIf 1, _0591
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0597
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _059D
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _05B8
    ClearFlag FLAG_HGSS_UNK_2CD
    GoTo _05CF
_0591:
    SetFlag FLAG_HGSS_UNK_2CD
    End
_0597:
    SetFlag FLAG_HGSS_UNK_2CD
    End
_059D:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _0708
    ClearFlag FLAG_HGSS_UNK_2CD
    GoTo _071F
_05B8:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _0721
    ClearFlag FLAG_HGSS_UNK_2CD
    GoTo _05CF
_05CF:
    End
_05D1:
    ApplyMovement obj_R25_gsleader11, _07EA
    ApplyMovement obj_R25_gsman1, _08B6
    ApplyMovement LOCALID_PLAYER, _08D0
    WaitMovement
    StopMusic
    PlayMusic SEQ_GS_EYE_K_SHOUJO_sseq
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _0616
    ApplyMovement obj_R25_gsleader11, _084A
    ApplyMovement LOCALID_PLAYER, _0854
    GoTo _0639
_0616:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _0727
    ApplyMovement obj_R25_gsleader11, _08EA
    ApplyMovement LOCALID_PLAYER, _0854
    GoTo _0639
_0639:
    WaitMovement
    Message msg_0363_R25_00000
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _0761
    ApplyMovement obj_R25_gsleader11, _08F4
    ApplyMovement LOCALID_PLAYER, _08FE
    GoTo _0784
_0663:
    Message msg_0363_R25_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_066E:
    Message msg_0363_R25_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0679:
    Message msg_0363_R25_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0684:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03CE
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0411
    End
_06A8:
    ApplyMovement LOCALID_PLAYER, _0910
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_R25_minaki, _0870
    ApplyMovement LOCALID_PLAYER, _0882
    WaitMovement
    Message msg_0363_R25_00016
    CloseMessage
    ApplyMovement obj_R25_minaki, _088C
    ApplyMovement LOCALID_PLAYER, _0896
    WaitMovement
    Message msg_0363_R25_00017
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_25, 2
    ReleaseAll
    End
_06FE:
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_25, 3
    ReleaseAll
    End
_0708:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _07AC
    ClearFlag FLAG_HGSS_UNK_2CD
    GoTo _071F
_071F:
    End
_0721:
    GoTo _0597
_0727:
    ApplyMovement obj_R25_gsleader11, _0922
    ApplyMovement LOCALID_PLAYER, _0854
    WaitMovement
    Message msg_0363_R25_00000
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _0761
    ApplyMovement obj_R25_gsleader11, _08F4
    ApplyMovement LOCALID_PLAYER, _08FE
    GoTo _0784
_0761:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _07B2
    ApplyMovement obj_R25_gsleader11, _092C
    ApplyMovement LOCALID_PLAYER, _08FE
    GoTo _0784
_0784:
    WaitMovement
    RemoveObject obj_R25_gsman1
    RemoveObject obj_R25_gsleader11
    StopMusic
    PlayMusic SEQ_GS_R_12_24_sseq
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_MISTYS_BOYFRIEND
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_MISTY
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    SetVarFromValue VAR_HGSS_UNK_4088, 2
    ReleaseAll
    End
_07AC:
    SetFlag FLAG_HGSS_UNK_2CD
    End
_07B2:
    ApplyMovement obj_R25_gsleader11, _0936
    ApplyMovement LOCALID_PLAYER, _0940
    WaitMovement
    RemoveObject obj_R25_gsman1
    RemoveObject obj_R25_gsleader11
    StopMusic
    PlayMusic SEQ_GS_R_12_24_sseq
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_MISTYS_BOYFRIEND
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_MISTY
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    SetVarFromValue VAR_HGSS_UNK_4088, 2
    ReleaseAll
    End
    .balign 4, 0
_07EA:
    Delay8
    FaceWest
    Delay32 2
    FaceNorth
    EndMovement
    .balign 4, 0
_07FC:
    Delay32
    FaceNorth
    EmoteExclamationMark
    WalkFastNorth 5
    WalkFastWest 5
    WalkFastSouth 8
    EndMovement
    .balign 4, 0
_0816:
    Delay16 6
    FaceSouth
    EndMovement
    .balign 4, 0
_0820:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0826:
    WalkNormalEast 3
    FaceNorth
    EndMovement
    .balign 4, 0
_0830:
    Delay32
    FaceNorth
    EmoteExclamationMark
    WalkFastNorth 5
    WalkFastWest 5
    WalkFastSouth 8
    EndMovement
    .balign 4, 0
_084A:
    WalkNormalNorth 7
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0854:
    Delay16 3
    FaceEast
    EndMovement
    .balign 4, 0
_085E:
    WalkNormalEast
    WalkNormalNorth
    WalkNormalEast 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0870:
    WalkFastEast 8
    WalkNormalEast 3
    WalkSlowerEast
    FaceNorth
    EndMovement
    .balign 4, 0
_0882:
    Delay8 2
    FaceSouth
    EndMovement
    .balign 4, 0
_088C:
    WalkNormalEast
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0896:
    Delay16
    FaceNorth
    EndMovement
    .balign 4, 0
_08A0:
    FaceSouth
    EndMovement
    .balign 4, 0
_08A6:
    Delay8 2
    FaceWest
    EndMovement
    .balign 4, 0
_08B0:
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_08B6:
    Delay32
    FaceNorth
    EmoteExclamationMark
    WalkFastNorth 6
    WalkFastWest 5
    WalkFastSouth 9
    EndMovement
    .balign 4, 0
_08D0:
    Delay16 6
    FaceNorth
    Delay8
    FaceWest
    Delay8
    FaceSouth
    EndMovement
    .balign 4, 0
_08EA:
    WalkNormalNorth 6
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_08F4:
    WalkNormalSouth
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_08FE:
    Delay8
    FaceSouth
    Delay8
    FaceWest
    EndMovement
    .balign 4, 0
_0910:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalEast 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0922:
    WalkNormalNorth 5
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_092C:
    WalkNormalSouth
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_0936:
    WalkNormalNorth
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_0940:
    Delay8
    FaceNorth
    Delay4
    FaceWest
    EndMovement
    .balign 4, 0
