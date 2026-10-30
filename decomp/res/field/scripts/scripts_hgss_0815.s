#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0519.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T09_gsleader16 0
#define obj_T09_gsleader15 1
#define obj_T09_monstarball 2

    ScriptEntry scr_seq_T09_000
    ScriptEntry scr_seq_T09_001
    ScriptEntry scr_seq_T09_002
    ScriptEntry scr_seq_T09_003
    ScriptEntry scr_seq_T09_004
    ScriptEntry scr_seq_T09_005
    ScriptEntry scr_seq_T09_006
    ScriptEntry scr_seq_T09_007
    ScriptEntry scr_seq_T09_008
    ScriptEntry scr_seq_T09_009
    ScriptEntry scr_seq_T09_010
    ScriptEntryEnd
scr_seq_T09_003:
    GoToIfUnset FLAG_HGSS_UNK_189, _0289
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T09_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06F4
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_HGSS_UNK_40FD, 0
    GoToIf 5, _029A
    GoToIfSet FLAG_HGSS_UNK_128, _02FB
    SetFlag FLAG_HGSS_UNK_128
    Message msg_0519_T09_00000
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0318
    ApplyMovement obj_T09_gsleader16, _06FA
    GoTo _0342
scr_seq_T09_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompletePhoneCheckRegistered PHONE_CONTACT_BLAINE, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0364
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 4, _03C5
    Message msg_0519_T09_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03CE
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0411
    End
scr_seq_T09_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0519_T09_00020, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T09_002:
    DrawSignpostInstantMessage msg_0519_T09_00021, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T09_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0519_T09_00022
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _0710
    WaitMovement
    ReleaseAll
    End
scr_seq_T09_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_HEATRAN, 6
    ReleaseObject 3
    @ HGSS: ScrCmd_523 3, 2, 90, 5, 0
    LockObject 3
    Message msg_0519_T09_00023
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_HEATRAN, 70, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0422
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 3
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0428
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 1, _0437
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _0428
    ReleaseAll
    End
scr_seq_T09_007:
    LockAll
    RemoveObject obj_T09_monstarball
    SetFlag FLAG_HGSS_HIDE_ITEMBALL_T09_MAGMARIZER
    SetVar VAR_0x8004, ITEM_MAGMA_STONE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    PlayCry SPECIES_HEATRAN, 0
    WaitCry
    FadeScreen 11, 5, 0, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_SG_3FC2
    AddObject 3
    ApplyMovement 3, _06F4
    WaitCry
    FadeScreen 11, 5, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T09_008:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _0447
    End
scr_seq_T09_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MOLTRES, 0
    WaitCry
    CompleteStartWildBattle SPECIES_MOLTRES, 60, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 4
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0422
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0455
    CompareVar VAR_MAP_LOCAL_0x02, 5
    CallIf 1, _0455
    ReleaseAll
    End
scr_seq_T09_010:
    BufferPlayerName 0
    End
_0289:
    GoToIfSet FLAG_HGSS_UNK_129, _0464
    SetFlag FLAG_HGSS_UNK_27D
    End
_029A:
    Message msg_0519_T09_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04A3
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04AE
    Message msg_0519_T09_00006
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 92
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0519_T09_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02FB:
    CompareVar VAR_HGSS_UNK_4135, 7
    GoToIf 4, _04B9
    BufferNumber 0, VAR_HGSS_UNK_4135
    Message msg_0519_T09_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0318:
    ApplyMovement obj_T09_gsleader16, _0716
    WaitMovement
    Message msg_0519_T09_00001
    CompareVar VAR_HGSS_UNK_4135, 7
    GoToIf 4, _04B9
    BufferNumber 0, VAR_HGSS_UNK_4135
    Message msg_0519_T09_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0342:
    WaitMovement
    Message msg_0519_T09_00001
    CompareVar VAR_HGSS_UNK_4135, 7
    GoToIf 4, _04B9
    BufferNumber 0, VAR_HGSS_UNK_4135
    Message msg_0519_T09_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0364:
    Message msg_0519_T09_00015
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04F4
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04FF
    Message msg_0519_T09_00016
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 85
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0519_T09_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03C5:
    Message msg_0519_T09_00014
    GoTo _050A
_03CE:
    BufferPlayerName 0
    Message msg_0519_T09_00011
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_BLAINE
    Message msg_0519_T09_00012
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_27D
    RemoveObject obj_T09_gsleader15
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0411:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    Message msg_0519_T09_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0422:
    BlackOutFromBattle
    ReleaseAll
    End
_0428:
    Message msg_0519_T09_00024
    ClearFlag FLAG_HGSS_SG_3FC2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0437:
    ClearFlag FLAG_HGSS_SG_3FB7
    SetFlag FLAG_HGSS_SG_3FB6
    SetFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    ReleaseAll
    End
_0447:
    SetFlag FLAG_HGSS_HIDE_MT_SILVER_CAVE_MOLTRES
    RemoveObject obj_T09_gsleader16
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_0455:
    Message msg_0519_T09_00025
    ClearFlag FLAG_HGSS_SG_3FB7
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0464:
    SetFlag FLAG_HGSS_UNK_25A
    CompletePhoneGetRematch PHONE_CONTACT_BLUE, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _052E
    CompareVar VAR_HGSS_UNK_40FD, 0
    GoToIf 1, _052E
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 5, _055A
    ClearFlag FLAG_HGSS_UNK_25A
    GoTo _052E
_04A3:
    Message msg_0519_T09_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04AE:
    Message msg_0519_T09_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04B9:
    Message msg_0519_T09_00002
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    .short SCRCMD_UNUSED_06A
    .short LOCALID_COMPLETE_FOLLOWER
    .short VAR_0x8004
    .short VAR_0x8005
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _058A
    CompareVar VAR_0x8004, 1035
    GoToIf 5, _05BC
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _072C
    WaitMovement
    GoTo _05C2
_04F4:
    Message msg_0519_T09_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04FF:
    Message msg_0519_T09_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_050A:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03CE
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0411
    End
_052E:
    CompletePhoneCheckRegistered PHONE_CONTACT_BLAINE, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _05DD
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _060B
    GoTo _0626
_055A:
    SetFlag FLAG_HGSS_UNK_25A
    CompletePhoneCheckRegistered PHONE_CONTACT_BLAINE, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _05DD
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _060B
    GoTo _0626
_058A:
    CompareVar VAR_0x8005, 495
    GoToIf 5, _05C2
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _073A
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _062C
    ApplyMovement obj_T09_gsleader16, _0748
    GoTo _0666
_05BC:
    GoTo _05C2
_05C2:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _062C
    ApplyMovement obj_T09_gsleader16, _0748
    GoTo _0666
_05DD:
    CompletePhoneGetRematch PHONE_CONTACT_BLAINE, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0626
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 5, _0698
    ClearFlag FLAG_HGSS_UNK_27D
    GoTo _069E
_060B:
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _06A0
    ClearFlag FLAG_HGSS_UNK_27D
    GoTo _06A6
_0626:
    SetFlag FLAG_HGSS_UNK_27D
    End
_062C:
    ApplyMovement obj_T09_gsleader16, _0752
    WaitMovement
    Message msg_0519_T09_00003
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _06A8
    ApplyMovement obj_T09_gsleader16, _075C
    ApplyMovement LOCALID_PLAYER, _076A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _076A
    GoTo _06DA
_0666:
    WaitMovement
    Message msg_0519_T09_00003
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _06A8
    ApplyMovement obj_T09_gsleader16, _075C
    ApplyMovement LOCALID_PLAYER, _076A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _076A
    GoTo _06DA
_0698:
    GoTo _0626
_069E:
    End
_06A0:
    GoTo _0626
_06A6:
    End
_06A8:
    ApplyMovement obj_T09_gsleader16, _0770
    ApplyMovement LOCALID_PLAYER, _076A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _076A
    WaitMovement
    RemoveObject obj_T09_gsleader16
    SetFlag FLAG_HGSS_UNK_25A
    SetFlag FLAG_HGSS_UNK_129
    SetFlag FLAG_HGSS_HIDE_VIRIDIAN_CITY_OLD_MAN_OUTSIDE_GYM_LOCKED
    ClearFlag FLAG_HGSS_HIDE_VIRIDIAN_CITY_OLD_MAN_OUTSIDE_GYM_UNLOCKED
    ReleaseAll
    End
_06DA:
    WaitMovement
    RemoveObject obj_T09_gsleader16
    SetFlag FLAG_HGSS_UNK_25A
    SetFlag FLAG_HGSS_UNK_129
    SetFlag FLAG_HGSS_HIDE_VIRIDIAN_CITY_OLD_MAN_OUTSIDE_GYM_LOCKED
    ClearFlag FLAG_HGSS_HIDE_VIRIDIAN_CITY_OLD_MAN_OUTSIDE_GYM_UNLOCKED
    ReleaseAll
    End
    .balign 4, 0
_06F4:
    Delay1
    EndMovement
    .balign 4, 0
_06FA:
    WalkOnSpotNormalEast
    Delay8 2
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0710:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0716:
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalEast
    Delay8 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_072C:
    WalkNormalSouth
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_073A:
    WalkNormalWest
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0748:
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0752:
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_075C:
    WalkNormalSouth 2
    WalkNormalWest 2
    WalkNormalSouth 8
    EndMovement
    .balign 4, 0
_076A:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0770:
    WalkNormalSouth
    WalkNormalSouth 2
    WalkNormalWest 2
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
