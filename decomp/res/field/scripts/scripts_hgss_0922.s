#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0614.h"

#define obj_T27GYM0101_gsoldman1 6

    ScriptEntry scr_seq_T27GYM0101_000
    ScriptEntry scr_seq_T27GYM0101_001
    ScriptEntry scr_seq_T27GYM0101_002
    ScriptEntry scr_seq_T27GYM0101_003
    ScriptEntry scr_seq_T27GYM0101_004
    ScriptEntry scr_seq_T27GYM0101_005
    ScriptEntryEnd
scr_seq_T27GYM0101_000:
    @ HGSS: EcruteakGymInit
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00AC
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _00A6
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0085
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0068
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    GoTo _0083
_0068:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _007F
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    GoTo _0083
_007F:
    ClearFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
_0083:
    End
_0085:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _00A0
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    GoTo _00A4
_00A0:
    ClearFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
_00A4:
    End
_00A6:
    ClearFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    End
_00AC:
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_GYM_MORTY
    End
scr_seq_T27GYM0101_004:
    LockAll
    ApplyMovement obj_T27GYM0101_gsoldman1, _0108
    WaitMovement
    Message msg_0614_T27GYM0101_00009
    CloseMessage
    ApplyMovement obj_T27GYM0101_gsoldman1, _0118
    ApplyMovement LOCALID_PLAYER, _0128
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4079, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ECRUTEAK, 376, 182, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0108:
    EmoteExclamationMark
    WalkNormalSouth 3
    Delay8
    EndMovement
    .balign 4, 0
_0118:
    WalkSlowSouth
    LockDir
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0128:
    Delay8
    WalkNormalSouth
    Delay8
    EndMovement
scr_seq_T27GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01D9
    Message msg_0614_T27GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_MORTY_MORTY, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01EF
    Message msg_0614_T27GYM0101_00001
    AddVar VAR_HGSS_MIDGAME_BADGES, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetFlag FLAG_HGSS_UNK_998
    BufferPlayerName 0
    Message msg_0614_T27GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0614_T27GYM0101_00003
    GoTo _019B
_019B:
    SetVar VAR_0x8004, ITEM_TM30
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01CF
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM30_FROM_MORTY
    Message msg_0614_T27GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01CF:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_01D9:
    GoToIfUnset FLAG_HGSS_GOT_TM30_FROM_MORTY, _019B
    Message msg_0614_T27GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01EF:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T27GYM0101_002:
    LockAll
    PlaySE SEQ_SE_DP_GYURU_sseq
    ApplyMovement LOCALID_PLAYER, _0230
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ECRUTEAK_GYM, 16, 49, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0230:
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
scr_seq_T27GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _029E
    Message msg_0614_T27GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_029E:
    BufferPlayerName 0
    Message msg_0614_T27GYM0101_00008
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
    GoToIf 5, _02D3
    Message msg_0614_T27GYM0101_00010
    GoTo _02D6
_02D3:
    Message msg_0614_T27GYM0101_00011
_02D6:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
