#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0614.h"

#define obj_T27GYM0101_gsoldman1 6

    ScriptEntry scr_seq_T27GYM0101_000
    ScriptEntry scr_seq_T27GYM0101_001
    ScriptEntry scr_seq_T27GYM0101_002
    ScriptEntry scr_seq_T27GYM0101_003
    ScriptEntry scr_seq_T27GYM0101_004
    ScriptEntry scr_seq_T27GYM0101_005
    ScriptEntry scr_seq_T27GYM0101_006
    ScriptEntryEnd
scr_seq_T27GYM0101_000:
    @ HGSS: EcruteakGymInit
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _01AE
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _01B4
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01BA
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _01D5
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    GoTo _01EC
scr_seq_T27GYM0101_004:
    LockAll
    ApplyMovement obj_T27GYM0101_gsoldman1, _0290
    WaitMovement
    Message msg_0614_T27GYM0101_00009
    CloseMessage
    ApplyMovement obj_T27GYM0101_gsoldman1, _029E
    ApplyMovement LOCALID_PLAYER, _02AC
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4079, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ECRUTEAK, 376, 182, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T27GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01EE
    Message msg_0614_T27GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_MORTY_MORTY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0204
    Message msg_0614_T27GYM0101_00001
    AddVar VAR_HGSS_MIDGAME_BADGES, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetFlag FLAG_HGSS_UNK_998
    BufferPlayerName 0
    Message msg_0614_T27GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0614_T27GYM0101_00003
    GoTo _020A
scr_seq_T27GYM0101_002:
    LockAll
    PlaySE SEQ_SE_DP_GYURU_sseq
    ApplyMovement LOCALID_PLAYER, _02BA
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ECRUTEAK_GYM, 16, 49, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T27GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0257
    Message msg_0614_T27GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27GYM0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0265
    Message msg_0614_T27GYM0101_00010
    GoTo _0270
scr_seq_T27GYM0101_006:
    BufferPlayerName 0
    End
_01AE:
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    End
_01B4:
    ClearFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    End
_01BA:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0278
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    GoTo _027E
_01D5:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0280
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    GoTo _01EC
_01EC:
    End
_01EE:
    GoToIfUnset FLAG_HGSS_GOT_TM30_FROM_MORTY, _020A
    Message msg_0614_T27GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0204:
    BlackOutFromBattle
    ReleaseAll
    End
_020A:
    SetVar VAR_0x8004, ITEM_TM30
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0286
    Common_GiveItemQuantity
    SetVarFromValue VAR_HGSS_SG_61A7, 2
    SetFlag FLAG_HGSS_GOT_TM30_FROM_MORTY
    Message msg_0614_T27GYM0101_00005
    Message msg_0614_T27GYM0101_00012
    BufferPlayerName 0
    Message msg_0614_T27GYM0101_00013
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_MORTY
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0257:
    BufferPlayerName 0
    Message msg_0614_T27GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0265:
    Message msg_0614_T27GYM0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0270:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0278:
    ClearFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    End
_027E:
    End
_0280:
    ClearFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    End
_0286:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0290:
    EmoteExclamationMark
    WalkNormalSouth 3
    Delay8
    EndMovement
    .balign 4, 0
_029E:
    WalkSlowSouth
    LockDir
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_02AC:
    Delay8
    WalkNormalSouth
    Delay8
    EndMovement
    .balign 4, 0
_02BA:
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
