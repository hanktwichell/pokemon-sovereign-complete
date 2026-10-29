#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0531.h"


    ScriptEntry scr_seq_T11GYM0101_000
    ScriptEntry scr_seq_T11GYM0101_001
    ScriptEntry scr_seq_T11GYM0101_002
    ScriptEntry scr_seq_T11GYM0101_003
    ScriptEntry scr_seq_T11GYM0101_004
    ScriptEntry scr_seq_T11GYM0101_005
    ScriptEntryEnd
scr_seq_T11GYM0101_004:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_SABRINA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0166
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_SABRINA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _016C
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0183
    GoTo _019A
scr_seq_T11GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01A0
    Message msg_0531_T11GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_SABRINA_SABRINA, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01B6
    SetFlag FLAG_HGSS_UNK_265
    SetFlag FLAG_HGSS_HIDE_ROUTE_19_WORKMEN_CLOSED
    ClearFlag FLAG_HGSS_HIDE_ROUTE_19_WORKMEN_OPEN
    AddVar VAR_HGSS_UNK_4135, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetFlag FLAG_HGSS_UNK_998
    SetTrainerFlag TRAINER_HGSS_PSYCHIC_M_FRANKLIN
    SetTrainerFlag TRAINER_HGSS_PSYCHIC_M_JARED
    SetTrainerFlag TRAINER_HGSS_MEDIUM_REBECCA
    SetTrainerFlag TRAINER_HGSS_MEDIUM_DARCY
    Message msg_0531_T11GYM0101_00001
    BufferPlayerName 0
    Message msg_0531_T11GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0531_T11GYM0101_00003
    GoTo _01BC
scr_seq_T11GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0206
    Message msg_0531_T11GYM0101_00006
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
    GoToIf 5, _0211
    Message msg_0531_T11GYM0101_00008
    GoTo _021C
scr_seq_T11GYM0101_003:
    LockAll
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement LOCALID_PLAYER, _022E
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFFRON_GYM, 15, 23, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11GYM0101_005:
    BufferPlayerName 0
    End
_0166:
    SetFlag FLAG_HGSS_HIDE_SAFFRON_GYM_SABRINA
    End
_016C:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _019A
    SetFlag FLAG_HGSS_HIDE_SAFFRON_GYM_SABRINA
    End
_0183:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _019A
    SetFlag FLAG_HGSS_HIDE_SAFFRON_GYM_SABRINA
    End
_019A:
    ClearFlag FLAG_HGSS_HIDE_SAFFRON_GYM_SABRINA
    End
_01A0:
    GoToIfUnset FLAG_HGSS_GOT_TM48_FROM_SABRINA, _01BC
    Message msg_0531_T11GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01B6:
    BlackOutFromBattle
    ReleaseAll
    End
_01BC:
    SetVar VAR_0x8004, ITEM_TM48
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0224
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM48_FROM_SABRINA
    Message msg_0531_T11GYM0101_00004
    Message msg_0531_T11GYM0101_00010
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0531_T11GYM0101_00011
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_SABRINA
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0206:
    Message msg_0531_T11GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0211:
    Message msg_0531_T11GYM0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_021C:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0224:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_022E:
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
