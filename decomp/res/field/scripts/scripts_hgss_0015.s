#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0053.h"

#define obj_D11R0106_assistantm 2
#define obj_D11R0106_assistantm_2 3
#define obj_D11R0106_assistantm_3 4
#define obj_D11R0106_gsassistantm 5
#define obj_D11R0106_gsassistantm_2 6
#define obj_D11R0106_gsassistantm_3 7

    ScriptEntry scr_seq_D11R0106_000
    ScriptEntry scr_seq_D11R0106_001
    ScriptEntry scr_seq_D11R0106_002
    ScriptEntry scr_seq_D11R0106_003
    ScriptEntry scr_seq_D11R0106_004
    ScriptEntry scr_seq_D11R0106_005
    ScriptEntry scr_seq_D11R0106_006
    ScriptEntry scr_seq_D11R0106_007
    ScriptEntry scr_seq_D11R0106_008
    ScriptEntry scr_seq_D11R0106_009
    ScriptEntryEnd
scr_seq_D11R0106_009:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BLAINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00AB
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BLAINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _008A
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0069
    ClearFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    End
_0069:
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _0084
    SetFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    GoTo _0088
_0084:
    ClearFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
_0088:
    End
_008A:
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 5, _00A5
    SetFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    GoTo _00A9
_00A5:
    ClearFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
_00A9:
    End
_00AB:
    SetFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    End
scr_seq_D11R0106_008:
    CallIfSet FLAG_HGSS_UNK_13B, _00D4
    CallIfSet FLAG_HGSS_UNK_13D, _00E2
    CallIfSet FLAG_HGSS_UNK_13E, _00F0
    End
_00D4:
    SetPosition obj_D11R0106_gsassistantm, 21, 0, 14, DIR_WEST
    Return
_00E2:
    SetPosition obj_D11R0106_gsassistantm_3, 9, 0, 13, DIR_NORTH
    Return
_00F0:
    SetPosition obj_D11R0106_assistantm, 15, 0, 16, DIR_SOUTH
    Return
scr_seq_D11R0106_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01B6
    Message msg_0053_D11R0106_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_BLAINE_BLAINE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01CC
    AddVar VAR_HGSS_UNK_4135, 1
    SetFlag FLAG_HGSS_UNK_265
    SetFlag FLAG_HGSS_HIDE_ROUTE_19_WORKMEN_CLOSED
    ClearFlag FLAG_HGSS_HIDE_ROUTE_19_WORKMEN_OPEN
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    SetFlag FLAG_HGSS_UNK_13F
    SetFlag FLAG_HGSS_UNK_140
    SetFlag FLAG_HGSS_UNK_13C
    Message msg_0053_D11R0106_00001
    BufferPlayerName 0
    Message msg_0053_D11R0106_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0053_D11R0106_00003
    GoTo _0175
_0175:
    SetVar VAR_0x8004, ITEM_TM50
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01AC
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM50_FROM_BLAINE
    BufferPlayerName 0
    Message msg_0053_D11R0106_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AC:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_01B6:
    GoToIfUnset FLAG_HGSS_GOT_TM50_FROM_BLAINE, _0175
    Message msg_0053_D11R0106_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01CC:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_D11R0106_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13B, _021A
    Message msg_0053_D11R0106_00006
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_SUPER_NERD_CARY, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01CC
    Message msg_0053_D11R0106_00008
    CloseMessage
    ApplyMovement obj_D11R0106_gsassistantm, _0424
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13B
    ReleaseAll
    End
_021A:
    Message msg_0053_D11R0106_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D11R0106_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13C, _028C
    Message msg_0053_D11R0106_00009
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_SUPER_NERD_WALDO, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01CC
    Message msg_0053_D11R0106_00011
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _027A
    ApplyMovement obj_D11R0106_gsassistantm_2, _043C
    GoTo _0282
_027A:
    ApplyMovement obj_D11R0106_gsassistantm_2, _0430
_0282:
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13C
    ReleaseAll
    End
_028C:
    Message msg_0053_D11R0106_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D11R0106_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13D, _02DF
    Message msg_0053_D11R0106_00012
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_SUPER_NERD_MERLE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01CC
    Message msg_0053_D11R0106_00014
    CloseMessage
    ApplyMovement obj_D11R0106_gsassistantm_3, _0448
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13D
    ReleaseAll
    End
_02DF:
    Message msg_0053_D11R0106_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D11R0106_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13E, _0332
    Message msg_0053_D11R0106_00015
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_SCIENTIST_GS_LOWELL, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01CC
    Message msg_0053_D11R0106_00017
    CloseMessage
    ApplyMovement obj_D11R0106_assistantm, _0454
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13E
    ReleaseAll
    End
_0332:
    Message msg_0053_D11R0106_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D11R0106_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13F, _03A4
    Message msg_0053_D11R0106_00018
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_SCIENTIST_GS_LINDEN, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01CC
    Message msg_0053_D11R0106_00020
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0392
    ApplyMovement obj_D11R0106_assistantm_2, _046C
    GoTo _039A
_0392:
    ApplyMovement obj_D11R0106_assistantm_2, _0460
_039A:
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13F
    ReleaseAll
    End
_03A4:
    Message msg_0053_D11R0106_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D11R0106_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_140, _0416
    Message msg_0053_D11R0106_00021
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_SCIENTIST_GS_DANIEL, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01CC
    Message msg_0053_D11R0106_00023
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0404
    ApplyMovement obj_D11R0106_assistantm_3, _0478
    GoTo _040C
_0404:
    ApplyMovement obj_D11R0106_assistantm_3, _0484
_040C:
    WaitMovement
    SetFlag FLAG_HGSS_UNK_140
    ReleaseAll
    End
_0416:
    Message msg_0053_D11R0106_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0424:
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_0430:
    WalkNormalSouth
    FaceNorth
    EndMovement
    .balign 4, 0
_043C:
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0448:
    WalkNormalSouth
    FaceNorth
    EndMovement
    .balign 4, 0
_0454:
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0460:
    WalkNormalWest
    FaceEast
    EndMovement
    .balign 4, 0
_046C:
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_0478:
    WalkNormalWest
    FaceEast
    EndMovement
    .balign 4, 0
_0484:
    WalkNormalEast
    FaceWest
    EndMovement
scr_seq_D11R0106_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04B6
    Message msg_0053_D11R0106_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04B6:
    Message msg_0053_D11R0106_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
