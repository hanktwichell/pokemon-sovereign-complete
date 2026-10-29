#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0531.h"


    ScriptEntry scr_seq_T11GYM0101_000
    ScriptEntry scr_seq_T11GYM0101_001
    ScriptEntry scr_seq_T11GYM0101_002
    ScriptEntry scr_seq_T11GYM0101_003
    ScriptEntry scr_seq_T11GYM0101_004
    ScriptEntryEnd
scr_seq_T11GYM0101_004:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_SABRINA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0089
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_SABRINA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _006C
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0055
    GoTo _0083
_0055:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0083
    SetFlag FLAG_HGSS_HIDE_SAFFRON_GYM_SABRINA
    End
_006C:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0083
    SetFlag FLAG_HGSS_HIDE_SAFFRON_GYM_SABRINA
    End
_0083:
    ClearFlag FLAG_HGSS_HIDE_SAFFRON_GYM_SABRINA
    End
_0089:
    SetFlag FLAG_HGSS_HIDE_SAFFRON_GYM_SABRINA
    End
scr_seq_T11GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0140
    Message msg_0531_T11GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_SABRINA_SABRINA, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0156
    AddVar VAR_HGSS_UNK_4135, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetFlag FLAG_HGSS_UNK_998
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    Message msg_0531_T11GYM0101_00001
    BufferPlayerName 0
    Message msg_0531_T11GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0531_T11GYM0101_00003
    GoTo _0102
_0102:
    SetVar VAR_0x8004, ITEM_TM48
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0136
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM48_FROM_SABRINA
    Message msg_0531_T11GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0136:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0140:
    GoToIfUnset FLAG_HGSS_GOT_TM48_FROM_SABRINA, _0102
    Message msg_0531_T11GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0156:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0182
    Message msg_0531_T11GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0182:
    Message msg_0531_T11GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T11GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01B4
    Message msg_0531_T11GYM0101_00008
    GoTo _01B7
_01B4:
    Message msg_0531_T11GYM0101_00009
_01B7:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T11GYM0101_003:
    LockAll
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _01FC
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFFRON_GYM, 15, 23, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_01FC:
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
