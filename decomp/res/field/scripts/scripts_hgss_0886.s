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
    GoToIf 5, _0106
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _0100
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_WHITNEY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00AF
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _0062
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _00AD
_0062:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _0079
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _00AD
_0079:
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _0090
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _00AD
_0090:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _00A7
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _00AD
_00A7:
    GoTo _0100
_00AD:
    End
_00AF:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _00CA
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _00FE
_00CA:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _00E1
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _00FE
_00E1:
    CompareVar VAR_MAP_LOCAL_0x00, 20
    GoToIf 5, _00F8
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    GoTo _00FE
_00F8:
    GoTo _0100
_00FE:
    End
_0100:
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    End
_0106:
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_GYM_WHITNEY
    End
scr_seq_T25GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0202
    GoToIfSet FLAG_HGSS_UNK_0B7, _01A0
    CompareVar VAR_HGSS_UNK_410A, 1
    GoToIf 1, _017D
    Message msg_0582_T25GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_WHITNEY, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0218
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetPosition obj_T25GYM0101_gsgirl1, 13, 0, 15, DIR_NORTH
_017D:
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
_01A0:
    Message msg_0582_T25GYM0101_00003
    BufferPlayerName 0
    Message msg_0582_T25GYM0101_00004
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_UNK_410A, 2
    ClearFlag FLAG_HGSS_UNK_084
    SetFlag FLAG_HGSS_UNK_998
    Message msg_0582_T25GYM0101_00005
_01C4:
    SetVar VAR_0x8004, ITEM_TM45
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01F8
    Common_GiveItemQuantity
    Message msg_0582_T25GYM0101_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_GOT_TM45_FROM_WHITNEY
    ReleaseAll
    End
_01F8:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0202:
    GoToIfUnset FLAG_HGSS_GOT_TM45_FROM_WHITNEY, _01C4
    Message msg_0582_T25GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0218:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T25GYM0101_001:
    LockAll
    ApplyMovement obj_T25GYM0101_gsgirl1, _0260
    WaitMovement
    Message msg_0582_T25GYM0101_00009
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T25GYM0101_gsgirl1, _026C
    ApplyMovement LOCALID_PLAYER, _0278
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetFlag FLAG_HGSS_UNK_0B7
    ReleaseAll
    End
    .balign 4, 0
_0260:
    EmoteExclamationMark
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_026C:
    WalkNormalSouth 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0278:
    Delay8
    WalkNormalNorth
    EndMovement
scr_seq_T25GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02AA
    Message msg_0582_T25GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02AA:
    Message msg_0582_T25GYM0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02DC
    Message msg_0582_T25GYM0101_00012
    GoTo _02DF
_02DC:
    Message msg_0582_T25GYM0101_00013
_02DF:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
