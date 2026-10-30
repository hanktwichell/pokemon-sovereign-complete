#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0631.h"

#define obj_T30GYM0101_sunglasses 6

    ScriptEntry scr_seq_T30GYM0101_000
    ScriptEntry scr_seq_T30GYM0101_001
    ScriptEntry scr_seq_T30GYM0101_002
    ScriptEntry scr_seq_T30GYM0101_003
    ScriptEntry scr_seq_T30GYM0101_004
    ScriptEntry scr_seq_T30GYM0101_005
    ScriptEntryEnd
scr_seq_T30GYM0101_001:
    CompleteBlackthornGymInit
    SetVarFromValue VAR_HGSS_UNK_4120, 0
    CompletePhoneGetRematch PHONE_CONTACT_CLAIR, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0179
    CompareVar VAR_HGSS_UNK_40FC, 2
    GoToIf 4, _017F
    End
scr_seq_T30GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0EA, _01AD
    GoToIfSet FLAG_HGSS_UNK_0D1, _0208
    Message msg_0631_T30GYM0101_00003
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_CLAIR_CLAIR, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0213
    SetTrainerFlag TRAINER_HGSS_ACE_TRAINER_M_PAULO
    SetTrainerFlag TRAINER_HGSS_ACE_TRAINER_M_CODY
    SetTrainerFlag TRAINER_HGSS_ACE_TRAINER_M_MIKE
    SetTrainerFlag TRAINER_HGSS_ACE_TRAINER_F_FRAN
    SetTrainerFlag TRAINER_HGSS_ACE_TRAINER_F_LOLA
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetFlag FLAG_HGSS_UNK_0D1
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_DEN_GUARD_INFRONT
    ClearFlag FLAG_HGSS_HIDE_BLACKTHRON_DEN_GUARD_ASIDE
    Message msg_0631_T30GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30GYM0101_002:
    LockAll
    PlaySE SEQ_SE_DP_GYURU_sseq
    ApplyMovement LOCALID_PLAYER, _03E8
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BLACKTHORN_GYM, 8, 83, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T30GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0D1, _0219
    Message msg_0631_T30GYM0101_00000
    CompleteFollowerPutAway
    @ HGSS: SetFollowMonInhibitState 1
    CompleteFollowerReturn
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30GYM0101_004:
    LockAll
    GoToIfSet FLAG_HGSS_UNK_138, _0224
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _0241
    ApplyMovement obj_T30GYM0101_sunglasses, _042E
    ApplyMovement LOCALID_PLAYER, _043C
    GoTo _0264
scr_seq_T30GYM0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_RISING, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _028A
    Message msg_0631_T30GYM0101_00010
    GoTo _0295
_0179:
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    End
_017F:
    CompletePhoneCheckRegistered PHONE_CONTACT_CLAIR, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _029D
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _02B8
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _02CF
_01AD:
    GoToIfSet FLAG_HGSS_GOT_TM59_FROM_CLAIR, _02D1
    Message msg_0631_T30GYM0101_00006
    SetVar VAR_0x8004, ITEM_TM59
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _02DC
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM59_FROM_CLAIR
    Message msg_0631_T30GYM0101_00007
    Message msg_0631_T30GYM0101_00009
    Message msg_0631_T30GYM0101_00012
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0631_T30GYM0101_00013
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_CLAIR
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0208:
    Message msg_0631_T30GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0213:
    BlackOutFromBattle
    ReleaseAll
    End
_0219:
    Message msg_0631_T30GYM0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0224:
    CompleteFollowerPutAway
    @ HGSS: SetFollowMonInhibitState 1
    CompleteFollowerReturn
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    ReleaseAll
    End
_0241:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _02E7
    ApplyMovement obj_T30GYM0101_sunglasses, _0446
    ApplyMovement LOCALID_PLAYER, _0454
    GoTo _0264
_0264:
    WaitMovement
    Message msg_0631_T30GYM0101_00002
    CloseMessage
    SetFlag FLAG_HGSS_UNK_138
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _031D
    ApplyMovement obj_T30GYM0101_sunglasses, _045E
    GoTo _0338
_028A:
    Message msg_0631_T30GYM0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0295:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_029D:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0357
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _036E
_02B8:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0370
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _02CF
_02CF:
    End
_02D1:
    Message msg_0631_T30GYM0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02DC:
    Message msg_0631_T30GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02E7:
    ApplyMovement obj_T30GYM0101_sunglasses, _0468
    ApplyMovement LOCALID_PLAYER, _0472
    WaitMovement
    Message msg_0631_T30GYM0101_00002
    CloseMessage
    SetFlag FLAG_HGSS_UNK_138
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _031D
    ApplyMovement obj_T30GYM0101_sunglasses, _045E
    GoTo _0338
_031D:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _0387
    ApplyMovement obj_T30GYM0101_sunglasses, _047C
    GoTo _0338
_0338:
    WaitMovement
    CompleteFollowerPutAway
    @ HGSS: SetFollowMonInhibitState 1
    CompleteFollowerReturn
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    ReleaseAll
    End
_0357:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _03AE
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _036E
_036E:
    End
_0370:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _03C5
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _02CF
_0387:
    ApplyMovement obj_T30GYM0101_sunglasses, _0486
    WaitMovement
    CompleteFollowerPutAway
    @ HGSS: SetFollowMonInhibitState 1
    CompleteFollowerReturn
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    ReleaseAll
    End
_03AE:
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _03DC
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _036E
_03C5:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _03E2
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _02CF
_03DC:
    ClearFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    End
_03E2:
    ClearFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    End
    .balign 4, 0
_03E8:
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast
    SetInvisible 0
    EndMovement
    .balign 4, 0
_042E:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_043C:
    Delay8 5
    FaceEast
    EndMovement
    .balign 4, 0
_0446:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0454:
    Delay8 4
    FaceEast
    EndMovement
    .balign 4, 0
_045E:
    WalkNormalEast 2
    FaceSouth
    EndMovement
    .balign 4, 0
_0468:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0472:
    Delay8 2
    FaceEast
    EndMovement
    .balign 4, 0
_047C:
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0486:
    FaceSouth
    EndMovement
    .balign 4, 0
