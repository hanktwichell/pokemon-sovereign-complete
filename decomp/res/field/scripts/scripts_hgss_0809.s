#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0514.h"

#define obj_T08GYM0101_picnicgirl_2 0
#define obj_T08GYM0101_gsgirl1 1
#define obj_T08GYM0101_gsgirl1_2 4
#define obj_T08GYM0101_campboy_2 5
#define obj_T08GYM0101_gsleader13_2 6
#define obj_T08GYM0101_gsleader13_3 7
#define obj_T08GYM0101_gsleader13_4 8
#define obj_T08GYM0101_gsleader13_5 9

    ScriptEntry scr_seq_T08GYM0101_000
    ScriptEntry scr_seq_T08GYM0101_001
    ScriptEntry scr_seq_T08GYM0101_002
    ScriptEntry scr_seq_T08GYM0101_003
    ScriptEntry scr_seq_T08GYM0101_004
    ScriptEntry scr_seq_T08GYM0101_005
    ScriptEntry scr_seq_T08GYM0101_006
    ScriptEntry scr_seq_T08GYM0101_007
    ScriptEntry scr_seq_T08GYM0101_008
    ScriptEntry scr_seq_T08GYM0101_009
    ScriptEntryEnd
scr_seq_T08GYM0101_000:
    @ HGSS: FuchsiaGymInit
    CompletePhoneGetRematch PHONE_CONTACT_JANINE, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0245
    CompletePhoneCheckRegistered PHONE_CONTACT_JANINE, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _024B
    CompleteCheckBadge BADGE_ID_HGSS_SOUL, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0266
    GoTo _026C
scr_seq_T08GYM0101_008:
    CompareVar VAR_MAP_LOCAL_0x0B, 111
    GoToIf 5, _0272
    CheckTrainerFlag TRAINER_HGSS_LASS_LINDA
    CallIf 0, _0274
    CheckTrainerFlag TRAINER_HGSS_CAMPER_BARRY
    CallIf 0, _0286
    CheckTrainerFlag TRAINER_HGSS_LASS_ALICE
    CallIf 0, _0298
    CheckTrainerFlag TRAINER_HGSS_PICNICKER_CINDY
    CallIf 0, _02AA
    End
scr_seq_T08GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfDefeated TRAINER_HGSS_LASS_LINDA, _02BC
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02C7
    ApplyMovement obj_T08GYM0101_gsleader13_4, _08E2
    GoTo _02E2
scr_seq_T08GYM0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfDefeated TRAINER_HGSS_CAMPER_BARRY, _030F
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _031A
    ApplyMovement obj_T08GYM0101_gsleader13_3, _08E2
    GoTo _0335
scr_seq_T08GYM0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfDefeated TRAINER_HGSS_LASS_ALICE, _0362
    Message msg_0514_T08GYM0101_00011
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _036D
    ApplyMovement obj_T08GYM0101_gsleader13_5, _08E2
    GoTo _0388
scr_seq_T08GYM0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfDefeated TRAINER_HGSS_PICNICKER_CINDY, _03B5
    Message msg_0514_T08GYM0101_00014
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03C0
    ApplyMovement obj_T08GYM0101_gsleader13_2, _08E2
    GoTo _03DB
scr_seq_T08GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_SOUL, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0408
    Message msg_0514_T08GYM0101_00000
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 111
    StartTrainerBattle TRAINER_HGSS_LEADER_JANINE_JANINE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _041E
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
    CompleteGiveBadge BADGE_ID_HGSS_SOUL
    AddVar VAR_HGSS_UNK_4135, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_HGSS_PICNICKER_CINDY
    SetTrainerFlag TRAINER_HGSS_CAMPER_BARRY
    SetTrainerFlag TRAINER_HGSS_LASS_LINDA
    SetTrainerFlag TRAINER_HGSS_LASS_ALICE
    Message msg_0514_T08GYM0101_00001
    BufferPlayerName 0
    Message msg_0514_T08GYM0101_00002
    PlayFanfare SEQ_ME_BADGE_sseq
    WaitFanfare
    Message msg_0514_T08GYM0101_00003
    GoTo _0424
scr_seq_T08GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_SOUL, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0479
    Message msg_0514_T08GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08GYM0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_SOUL, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0484
    Message msg_0514_T08GYM0101_00017
    GoTo _048F
scr_seq_T08GYM0101_009:
    BufferPlayerName 0
    End
_0245:
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    End
_024B:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _0497
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    GoTo _04AE
_0266:
    GoTo _04B0
_026C:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    End
_0272:
    End
_0274:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_REVEALED
    AddObject obj_T08GYM0101_gsgirl1
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_4
    Return
_0286:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_REVEALED
    AddObject obj_T08GYM0101_campboy_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_3
    Return
_0298:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_REVEALED
    AddObject obj_T08GYM0101_gsgirl1_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_5
    Return
_02AA:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_REVEALED
    AddObject obj_T08GYM0101_picnicgirl_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_2
    Return
_02BC:
    Message msg_0514_T08GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02C7:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04CB
    ApplyMovement obj_T08GYM0101_gsleader13_4, _08F8
    GoTo _02E2
_02E2:
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_REVEALED
    AddObject obj_T08GYM0101_gsgirl1
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_4
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04E6
    ApplyMovement obj_T08GYM0101_gsgirl1, _0916
    GoTo _0501
_030F:
    Message msg_0514_T08GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_031A:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0530
    ApplyMovement obj_T08GYM0101_gsleader13_3, _08F8
    GoTo _0335
_0335:
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_REVEALED
    AddObject obj_T08GYM0101_campboy_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_3
    CompareVar VAR_RESULT, 0
    GoToIf 5, _054B
    ApplyMovement obj_T08GYM0101_campboy_2, _0916
    GoTo _0566
_0362:
    Message msg_0514_T08GYM0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_036D:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0595
    ApplyMovement obj_T08GYM0101_gsleader13_5, _08F8
    GoTo _0388
_0388:
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_REVEALED
    AddObject obj_T08GYM0101_gsgirl1_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_5
    CompareVar VAR_RESULT, 0
    GoToIf 5, _05B0
    ApplyMovement obj_T08GYM0101_gsgirl1_2, _0916
    GoTo _05CB
_03B5:
    Message msg_0514_T08GYM0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03C0:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05FA
    ApplyMovement obj_T08GYM0101_gsleader13_2, _08F8
    GoTo _03DB
_03DB:
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_REVEALED
    AddObject obj_T08GYM0101_picnicgirl_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_2
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0615
    ApplyMovement obj_T08GYM0101_picnicgirl_2, _0916
    GoTo _0630
_0408:
    GoToIfUnset FLAG_HGSS_GOT_TM84_FROM_JANINE, _0424
    Message msg_0514_T08GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_041E:
    BlackOutFromBattle
    ReleaseAll
    End
_0424:
    SetVar VAR_0x8004, ITEM_TM84
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _065F
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM84_FROM_JANINE
    GoToIfUnset FLAG_HGSS_GOT_TM84_FROM_JANINE, _0424
    Message msg_0514_T08GYM0101_00004
    Message msg_0514_T08GYM0101_00019
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0514_T08GYM0101_00020
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_JANINE
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0479:
    Message msg_0514_T08GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0484:
    Message msg_0514_T08GYM0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_048F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0497:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _0669
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    GoTo _04AE
_04AE:
    End
_04B0:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _066F
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    GoTo _0686
_04CB:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0688
    ApplyMovement obj_T08GYM0101_gsleader13_4, _0930
    GoTo _02E2
_04E6:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _06BD
    ApplyMovement obj_T08GYM0101_gsgirl1, _094A
    GoTo _0501
_0501:
    WaitMovement
    Message msg_0514_T08GYM0101_00007
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LASS_LINDA, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06D8
    SetTrainerFlag TRAINER_HGSS_LASS_LINDA
    Message msg_0514_T08GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0530:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _06E6
    ApplyMovement obj_T08GYM0101_gsleader13_3, _0930
    GoTo _0335
_054B:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _071B
    ApplyMovement obj_T08GYM0101_campboy_2, _094A
    GoTo _0566
_0566:
    WaitMovement
    Message msg_0514_T08GYM0101_00009
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_CAMPER_BARRY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0736
    SetTrainerFlag TRAINER_HGSS_CAMPER_BARRY
    Message msg_0514_T08GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0595:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0744
    ApplyMovement obj_T08GYM0101_gsleader13_5, _0930
    GoTo _0388
_05B0:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0779
    ApplyMovement obj_T08GYM0101_gsgirl1_2, _094A
    GoTo _05CB
_05CB:
    WaitMovement
    Message msg_0514_T08GYM0101_00012
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LASS_ALICE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0794
    SetTrainerFlag TRAINER_HGSS_LASS_ALICE
    Message msg_0514_T08GYM0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05FA:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _07A2
    ApplyMovement obj_T08GYM0101_gsleader13_2, _0930
    GoTo _03DB
_0615:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _07D7
    ApplyMovement obj_T08GYM0101_picnicgirl_2, _094A
    GoTo _0630
_0630:
    WaitMovement
    Message msg_0514_T08GYM0101_00015
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_PICNICKER_CINDY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07F2
    SetTrainerFlag TRAINER_HGSS_PICNICKER_CINDY
    Message msg_0514_T08GYM0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_065F:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0669:
    GoTo _026C
_066F:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _0800
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    GoTo _0686
_0686:
    End
_0688:
    ApplyMovement obj_T08GYM0101_gsleader13_4, _096C
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_REVEALED
    AddObject obj_T08GYM0101_gsgirl1
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_4
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04E6
    ApplyMovement obj_T08GYM0101_gsgirl1, _0916
    GoTo _0501
_06BD:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0806
    ApplyMovement obj_T08GYM0101_gsgirl1, _098E
    GoTo _0501
_06D8:
    BlackOutFromBattle
    ReleaseAll
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_REVEALED
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_DISGUISED
    End
_06E6:
    ApplyMovement obj_T08GYM0101_gsleader13_3, _096C
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_REVEALED
    AddObject obj_T08GYM0101_campboy_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_3
    CompareVar VAR_RESULT, 0
    GoToIf 5, _054B
    ApplyMovement obj_T08GYM0101_campboy_2, _0916
    GoTo _0566
_071B:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _083D
    ApplyMovement obj_T08GYM0101_campboy_2, _098E
    GoTo _0566
_0736:
    BlackOutFromBattle
    ReleaseAll
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_REVEALED
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_DISGUISED
    End
_0744:
    ApplyMovement obj_T08GYM0101_gsleader13_5, _096C
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_REVEALED
    AddObject obj_T08GYM0101_gsgirl1_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_5
    CompareVar VAR_RESULT, 0
    GoToIf 5, _05B0
    ApplyMovement obj_T08GYM0101_gsgirl1_2, _0916
    GoTo _05CB
_0779:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0874
    ApplyMovement obj_T08GYM0101_gsgirl1_2, _098E
    GoTo _05CB
_0794:
    BlackOutFromBattle
    ReleaseAll
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_REVEALED
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_DISGUISED
    End
_07A2:
    ApplyMovement obj_T08GYM0101_gsleader13_2, _096C
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_REVEALED
    AddObject obj_T08GYM0101_picnicgirl_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_2
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0615
    ApplyMovement obj_T08GYM0101_picnicgirl_2, _0916
    GoTo _0630
_07D7:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _08AB
    ApplyMovement obj_T08GYM0101_picnicgirl_2, _098E
    GoTo _0630
_07F2:
    BlackOutFromBattle
    ReleaseAll
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_REVEALED
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_DISGUISED
    End
_0800:
    GoTo _026C
_0806:
    ApplyMovement obj_T08GYM0101_gsgirl1, _09A4
    WaitMovement
    Message msg_0514_T08GYM0101_00007
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LASS_LINDA, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06D8
    SetTrainerFlag TRAINER_HGSS_LASS_LINDA
    Message msg_0514_T08GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_083D:
    ApplyMovement obj_T08GYM0101_campboy_2, _09A4
    WaitMovement
    Message msg_0514_T08GYM0101_00009
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_CAMPER_BARRY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0736
    SetTrainerFlag TRAINER_HGSS_CAMPER_BARRY
    Message msg_0514_T08GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0874:
    ApplyMovement obj_T08GYM0101_gsgirl1_2, _09A4
    WaitMovement
    Message msg_0514_T08GYM0101_00012
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LASS_ALICE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0794
    SetTrainerFlag TRAINER_HGSS_LASS_ALICE
    Message msg_0514_T08GYM0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_08AB:
    ApplyMovement obj_T08GYM0101_picnicgirl_2, _09A4
    WaitMovement
    Message msg_0514_T08GYM0101_00015
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_PICNICKER_CINDY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07F2
    SetTrainerFlag TRAINER_HGSS_PICNICKER_CINDY
    Message msg_0514_T08GYM0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_08E2:
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_08F8:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_0916:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0930:
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_094A:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    EndMovement
    .balign 4, 0
_096C:
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_098E:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    EndMovement
    .balign 4, 0
_09A4:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
