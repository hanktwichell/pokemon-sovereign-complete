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
    @ HGSS: BlackthornGymInit
    SetVarFromValue VAR_HGSS_UNK_4120, 0
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_CLAIR, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _010C
    CompareVar VAR_HGSS_UNK_40FC, 2
    GoToIf 4, _0044
    End
_0044:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_CLAIR, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00BD
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0072
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _00BB
_0072:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0089
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _00BB
_0089:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _00A0
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _00BB
_00A0:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _00B7
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _00BB
_00B7:
    ClearFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
_00BB:
    End
_00BD:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _00D8
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _010A
_00D8:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _00EF
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _010A
_00EF:
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _0106
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    GoTo _010A
_0106:
    ClearFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
_010A:
    End
_010C:
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_CLAIR
    End
scr_seq_T30GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0EA, _018E
    GoToIfSet FLAG_HGSS_UNK_0D1, _017D
    Message msg_0631_T30GYM0101_00003
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_CLAIR_CLAIR, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0188
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetFlag FLAG_HGSS_UNK_0D1
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_DEN_GUARD_INFRONT
    ClearFlag FLAG_HGSS_HIDE_BLACKTHRON_DEN_GUARD_ASIDE
    Message msg_0631_T30GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_017D:
    Message msg_0631_T30GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0188:
    BlackOutFromBattle
    ReleaseAll
    End
_018E:
    GoToIfSet FLAG_HGSS_GOT_TM59_FROM_CLAIR, _01C8
    Message msg_0631_T30GYM0101_00006
    SetVar VAR_0x8004, ITEM_TM59
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01D3
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM59_FROM_CLAIR
    Message msg_0631_T30GYM0101_00007
_01C8:
    Message msg_0631_T30GYM0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01D3:
    Message msg_0631_T30GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30GYM0101_002:
    LockAll
    PlaySE SEQ_SE_DP_GYURU_sseq
    ApplyMovement LOCALID_PLAYER, _0218
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BLACKTHORN_GYM, 8, 83, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0218:
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
scr_seq_T30GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0D1, _0291
    Message msg_0631_T30GYM0101_00000
    @ HGSS: ScrCmd_600
    @ HGSS: SetFollowMonInhibitState 1
    @ HGSS: ScrCmd_607
    @ HGSS: ScrCmd_109 253, 56
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0291:
    Message msg_0631_T30GYM0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30GYM0101_004:
    LockAll
    GoToIfSet FLAG_HGSS_UNK_138, _0352
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _02D4
    ApplyMovement obj_T30GYM0101_sunglasses, _0370
    ApplyMovement LOCALID_PLAYER, _039C
    GoTo _0307
_02D4:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _02F7
    ApplyMovement obj_T30GYM0101_sunglasses, _0380
    ApplyMovement LOCALID_PLAYER, _03A8
    GoTo _0307
_02F7:
    ApplyMovement obj_T30GYM0101_sunglasses, _0390
    ApplyMovement LOCALID_PLAYER, _03B4
_0307:
    WaitMovement
    Message msg_0631_T30GYM0101_00002
    CloseMessage
    SetFlag FLAG_HGSS_UNK_138
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _032D
    ApplyMovement obj_T30GYM0101_sunglasses, _03C0
    GoTo _0350
_032D:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _0348
    ApplyMovement obj_T30GYM0101_sunglasses, _03CC
    GoTo _0350
_0348:
    ApplyMovement obj_T30GYM0101_sunglasses, _03D8
_0350:
    WaitMovement
_0352:
    @ HGSS: ScrCmd_600
    @ HGSS: SetFollowMonInhibitState 1
    @ HGSS: ScrCmd_607
    @ HGSS: ScrCmd_109 253, 56
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    SetVarFromValue VAR_HGSS_UNK_4120, 1
    ReleaseAll
    End
    .balign 4, 0
_0370:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0380:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0390:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_039C:
    Delay8 5
    FaceEast
    EndMovement
    .balign 4, 0
_03A8:
    Delay8 4
    FaceEast
    EndMovement
    .balign 4, 0
_03B4:
    Delay8 2
    FaceEast
    EndMovement
    .balign 4, 0
_03C0:
    WalkNormalEast 2
    FaceSouth
    EndMovement
    .balign 4, 0
_03CC:
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
_03D8:
    FaceSouth
    EndMovement
scr_seq_T30GYM0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0407
    Message msg_0631_T30GYM0101_00010
    GoTo _040A
_0407:
    Message msg_0631_T30GYM0101_00011
_040A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
