#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0582.h"

#define obj_T25GYM0101_gsgirl1 1

    ScriptEntry scr_seq_T25GYM0101_000
    ScriptEntry scr_seq_T25GYM0101_001
    ScriptEntry scr_seq_T25GYM0101_002
    ScriptEntry scr_seq_T25GYM0101_003
    ScriptEntry scr_seq_T25GYM0101_004
    ScriptEntryEnd
scr_seq_T25GYM0101_004:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_WHITNEY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0184
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _018A
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_WHITNEY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0190
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _01AB
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _01C2
scr_seq_T25GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01C4
    GoToIfSet FLAG_HGSS_UNK_0B7, _01DA
    CompareVar VAR_HGSS_UNK_410A, 1
    GoToIf 1, _0245
    Message msg_0582_T25GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_WHITNEY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0268
    SetTrainerFlag TRAINER_HGSS_LASS_CARRIE
    SetTrainerFlag TRAINER_HGSS_LASS_CATHY
    SetTrainerFlag TRAINER_HGSS_BEAUTY_VICTORIA
    SetTrainerFlag TRAINER_HGSS_BEAUTY_SAMANTHA
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetPosition obj_T25GYM0101_gsgirl1, 13, 0, 15, DIR_NORTH
    Message msg_0582_T25GYM0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_410A, 1
    SetFlag FLAG_HGSS_UNK_084
    SetVarFromValue VAR_HGSS_UNK_40DA, 1
    ClearFlag FLAG_HGSS_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_UNLOCKED
    SetFlag FLAG_HGSS_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_LOCKED
    End
scr_seq_T25GYM0101_001:
    LockAll
    ApplyMovement obj_T25GYM0101_gsgirl1, _0334
    WaitMovement
    Message msg_0582_T25GYM0101_00009
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T25GYM0101_gsgirl1, _033E
    ApplyMovement LOCALID_PLAYER, _0348
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetFlag FLAG_HGSS_UNK_0B7
    ReleaseAll
    End
scr_seq_T25GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _026E
    Message msg_0582_T25GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0279
    Message msg_0582_T25GYM0101_00012
    GoTo _0284
_0184:
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    End
_018A:
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    End
_0190:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _028C
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _02A3
_01AB:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _02A5
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _01C2
_01C2:
    End
_01C4:
    GoToIfUnset FLAG_HGSS_GOT_TM45_FROM_WHITNEY, _02BC
    Message msg_0582_T25GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DA:
    Message msg_0582_T25GYM0101_00003
    BufferPlayerName 0
    Message msg_0582_T25GYM0101_00004
    PlayFanfare SEQ_ME_BADGE_sseq
    WaitFanfare
    CompleteGiveBadge BADGE_ID_HGSS_PLAIN
    SetVarFromValue VAR_HGSS_UNK_410A, 2
    ClearFlag FLAG_HGSS_UNK_084
    SetFlag FLAG_HGSS_UNK_998
    Message msg_0582_T25GYM0101_00005
    SetVar VAR_0x8004, ITEM_TM45
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _02F0
    Common_GiveItemQuantity
    Message msg_0582_T25GYM0101_00007
    Message msg_0582_T25GYM0101_00014
    BufferPlayerName 0
    Message msg_0582_T25GYM0101_00015
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_WHITNEY
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_GOT_TM45_FROM_WHITNEY
    ReleaseAll
    End
_0245:
    Message msg_0582_T25GYM0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_410A, 1
    SetFlag FLAG_HGSS_UNK_084
    SetVarFromValue VAR_HGSS_UNK_40DA, 1
    ClearFlag FLAG_HGSS_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_UNLOCKED
    SetFlag FLAG_HGSS_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_LOCKED
    End
_0268:
    BlackOutFromBattle
    ReleaseAll
    End
_026E:
    Message msg_0582_T25GYM0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0279:
    Message msg_0582_T25GYM0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0284:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_028C:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _02FA
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _02A3
_02A3:
    End
_02A5:
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _0311
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _01C2
_02BC:
    SetVar VAR_0x8004, ITEM_TM45
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _02F0
    Common_GiveItemQuantity
    Message msg_0582_T25GYM0101_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_GOT_TM45_FROM_WHITNEY
    ReleaseAll
    End
_02F0:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_02FA:
    CompareVar VAR_MAP_LOCAL_0x00, 20
    GoToIf 5, _0328
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _02A3
_0311:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _032E
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _01C2
_0328:
    GoTo _018A
_032E:
    GoTo _018A
    .balign 4, 0
_0334:
    EmoteExclamationMark
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_033E:
    WalkNormalSouth 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0348:
    Delay8
    WalkNormalNorth
    EndMovement
    .balign 4, 0
