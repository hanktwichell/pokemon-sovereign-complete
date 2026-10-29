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
    ScriptEntryEnd
scr_seq_T08GYM0101_000:
    @ HGSS: FuchsiaGymInit
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_JANINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00EF
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JANINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00AF
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _006D
    GoTo _00E9
_0067:
    GoTo _0073
_006D:
    GoTo _0075
_0073:
    End
_0075:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0090
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    GoTo _00AD
_0090:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _00A7
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    GoTo _00AD
_00A7:
    GoTo _00E9
_00AD:
    End
_00AF:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _00CA
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    GoTo _00E7
_00CA:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _00E1
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    GoTo _00E7
_00E1:
    GoTo _00E9
_00E7:
    End
_00E9:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    End
_00EF:
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_JANINE
    End
scr_seq_T08GYM0101_008:
    CompareVar VAR_MAP_LOCAL_0x0B, 111
    GoToIf 5, _012E
    @ HGSS: CallIfNotDefeated TRAINER_LASS_LINDA, _0130
    @ HGSS: CallIfNotDefeated TRAINER_CAMPER_BARRY, _0142
    @ HGSS: CallIfNotDefeated TRAINER_LASS_ALICE, _0154
    @ HGSS: CallIfNotDefeated TRAINER_PICNICKER_CINDY, _0166
_012E:
    End
_0130:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_REVEALED
    AddObject obj_T08GYM0101_gsgirl1
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_4
    Return
_0142:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_REVEALED
    AddObject obj_T08GYM0101_campboy_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_3
    Return
_0154:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_REVEALED
    AddObject obj_T08GYM0101_gsgirl1_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_5
    Return
_0166:
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_REVEALED
    AddObject obj_T08GYM0101_picnicgirl_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_2
    Return
scr_seq_T08GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfDefeated TRAINER_NONE, _0277
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01AA
    ApplyMovement obj_T08GYM0101_gsleader13_4, _0620
    GoTo _01E8
_01AA:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01C5
    ApplyMovement obj_T08GYM0101_gsleader13_4, _05E4
    GoTo _01E8
_01C5:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _01E0
    ApplyMovement obj_T08GYM0101_gsleader13_4, _0604
    GoTo _01E8
_01E0:
    ApplyMovement obj_T08GYM0101_gsleader13_4, _0638
_01E8:
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_REVEALED
    AddObject obj_T08GYM0101_gsgirl1
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_4
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0215
    ApplyMovement obj_T08GYM0101_gsgirl1, _0698
    GoTo _0253
_0215:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0230
    ApplyMovement obj_T08GYM0101_gsgirl1, _065C
    GoTo _0253
_0230:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _024B
    ApplyMovement obj_T08GYM0101_gsgirl1, _0680
    GoTo _0253
_024B:
    ApplyMovement obj_T08GYM0101_gsgirl1, _06B4
_0253:
    WaitMovement
    Message msg_0514_T08GYM0101_00007
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LASS_LINDA, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0282
    SetTrainerFlag TRAINER_NONE
_0277:
    Message msg_0514_T08GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0282:
    BlackOutFromBattle
    ReleaseAll
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_REVEALED
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_LINDA_DISGUISED
    End
scr_seq_T08GYM0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfDefeated TRAINER_NONE, _038F
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02C2
    ApplyMovement obj_T08GYM0101_gsleader13_3, _0620
    GoTo _0300
_02C2:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02DD
    ApplyMovement obj_T08GYM0101_gsleader13_3, _05E4
    GoTo _0300
_02DD:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _02F8
    ApplyMovement obj_T08GYM0101_gsleader13_3, _0604
    GoTo _0300
_02F8:
    ApplyMovement obj_T08GYM0101_gsleader13_3, _0638
_0300:
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_REVEALED
    AddObject obj_T08GYM0101_campboy_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_3
    CompareVar VAR_RESULT, 0
    GoToIf 5, _032D
    ApplyMovement obj_T08GYM0101_campboy_2, _0698
    GoTo _036B
_032D:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0348
    ApplyMovement obj_T08GYM0101_campboy_2, _065C
    GoTo _036B
_0348:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0363
    ApplyMovement obj_T08GYM0101_campboy_2, _0680
    GoTo _036B
_0363:
    ApplyMovement obj_T08GYM0101_campboy_2, _06B4
_036B:
    WaitMovement
    Message msg_0514_T08GYM0101_00009
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_CAMPER_BARRY, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _039A
    SetTrainerFlag TRAINER_NONE
_038F:
    Message msg_0514_T08GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_039A:
    BlackOutFromBattle
    ReleaseAll
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_REVEALED
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_CAMPER_BARRY_DISGUISED
    End
scr_seq_T08GYM0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfDefeated TRAINER_NONE, _04AC
    Message msg_0514_T08GYM0101_00011
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03DF
    ApplyMovement obj_T08GYM0101_gsleader13_5, _0620
    GoTo _041D
_03DF:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _03FA
    ApplyMovement obj_T08GYM0101_gsleader13_5, _05E4
    GoTo _041D
_03FA:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0415
    ApplyMovement obj_T08GYM0101_gsleader13_5, _0604
    GoTo _041D
_0415:
    ApplyMovement obj_T08GYM0101_gsleader13_5, _0638
_041D:
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_REVEALED
    AddObject obj_T08GYM0101_gsgirl1_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_5
    CompareVar VAR_RESULT, 0
    GoToIf 5, _044A
    ApplyMovement obj_T08GYM0101_gsgirl1_2, _0698
    GoTo _0488
_044A:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0465
    ApplyMovement obj_T08GYM0101_gsgirl1_2, _065C
    GoTo _0488
_0465:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0480
    ApplyMovement obj_T08GYM0101_gsgirl1_2, _0680
    GoTo _0488
_0480:
    ApplyMovement obj_T08GYM0101_gsgirl1_2, _06B4
_0488:
    WaitMovement
    Message msg_0514_T08GYM0101_00012
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LASS_ALICE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04B7
    SetTrainerFlag TRAINER_NONE
_04AC:
    Message msg_0514_T08GYM0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04B7:
    BlackOutFromBattle
    ReleaseAll
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_REVEALED
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_LASS_ALICE_DISGUISED
    End
scr_seq_T08GYM0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfDefeated TRAINER_NONE, _05C9
    Message msg_0514_T08GYM0101_00014
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04FC
    ApplyMovement obj_T08GYM0101_gsleader13_2, _0620
    GoTo _053A
_04FC:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0517
    ApplyMovement obj_T08GYM0101_gsleader13_2, _05E4
    GoTo _053A
_0517:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0532
    ApplyMovement obj_T08GYM0101_gsleader13_2, _0604
    GoTo _053A
_0532:
    ApplyMovement obj_T08GYM0101_gsleader13_2, _0638
_053A:
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_REVEALED
    AddObject obj_T08GYM0101_picnicgirl_2
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_DISGUISED
    RemoveObject obj_T08GYM0101_gsleader13_2
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0567
    ApplyMovement obj_T08GYM0101_picnicgirl_2, _0698
    GoTo _05A5
_0567:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0582
    ApplyMovement obj_T08GYM0101_picnicgirl_2, _065C
    GoTo _05A5
_0582:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _059D
    ApplyMovement obj_T08GYM0101_picnicgirl_2, _0680
    GoTo _05A5
_059D:
    ApplyMovement obj_T08GYM0101_picnicgirl_2, _06B4
_05A5:
    WaitMovement
    Message msg_0514_T08GYM0101_00015
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_PICNICKER_CINDY, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05D4
    SetTrainerFlag TRAINER_NONE
_05C9:
    Message msg_0514_T08GYM0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05D4:
    BlackOutFromBattle
    ReleaseAll
    SetFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_REVEALED
    ClearFlag FLAG_HGSS_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_DISGUISED
    End
    .balign 4, 0
_05E4:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_0604:
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_0620:
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_0638:
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
_065C:
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
_0680:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    EndMovement
    .balign 4, 0
_0698:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_06B4:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
scr_seq_T08GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0778
    Message msg_0514_T08GYM0101_00000
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 111
    @ HGSS: TrainerBattle TRAINER_LEADER_JANINE_JANINE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _078E
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
    AddVar VAR_HGSS_UNK_4135, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    Message msg_0514_T08GYM0101_00001
    BufferPlayerName 0
    Message msg_0514_T08GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0514_T08GYM0101_00003
    GoTo _074F
_074F:
    SetVar VAR_0x8004, ITEM_TM84
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0794
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM84_FROM_JANINE
_0778:
    GoToIfUnset FLAG_HGSS_GOT_TM84_FROM_JANINE, _074F
    Message msg_0514_T08GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_078E:
    BlackOutFromBattle
    ReleaseAll
    End
_0794:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_T08GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07C4
    Message msg_0514_T08GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_07C4:
    Message msg_0514_T08GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08GYM0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _07F6
    Message msg_0514_T08GYM0101_00017
    GoTo _07F9
_07F6:
    Message msg_0514_T08GYM0101_00018
_07F9:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
