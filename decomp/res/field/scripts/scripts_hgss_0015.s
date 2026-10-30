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
    ScriptEntry scr_seq_D11R0106_010
    ScriptEntry scr_seq_D11R0106_011
    ScriptEntryEnd
scr_seq_D11R0106_009:
    GoToIfSet FLAG_HGSS_SG_3FB6, _039B
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BLAINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _039D
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BLAINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _03A3
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _03BE
    ClearFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    End
scr_seq_D11R0106_008:
    GoToIfSet FLAG_HGSS_SG_3FB6, _039B
    CallIfSet FLAG_HGSS_UNK_13B, _03D9
    CallIfSet FLAG_HGSS_UNK_13D, _03E7
    CallIfSet FLAG_HGSS_UNK_13E, _03F5
    End
scr_seq_D11R0106_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_VOLCANO, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0403
    Message msg_0053_D11R0106_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_BLAINE_BLAINE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0419
    CompleteGiveBadge BADGE_ID_HGSS_VOLCANO
    AddVar VAR_HGSS_UNK_4135, 1
    SetFlag FLAG_HGSS_UNK_265
    SetFlag FLAG_HGSS_HIDE_ROUTE_19_WORKMEN_CLOSED
    ClearFlag FLAG_HGSS_HIDE_ROUTE_19_WORKMEN_OPEN
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    SetFlag FLAG_HGSS_UNK_13F
    SetFlag FLAG_HGSS_UNK_140
    SetFlag FLAG_HGSS_UNK_13C
    Message msg_0053_D11R0106_00001
    BufferPlayerName 0
    Message msg_0053_D11R0106_00002
    PlayFanfare SEQ_ME_BADGE_sseq
    WaitFanfare
    Message msg_0053_D11R0106_00003
    GoTo _041F
scr_seq_D11R0106_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13B, _046C
    Message msg_0053_D11R0106_00006
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_SUPER_NERD_CARY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0419
    Message msg_0053_D11R0106_00008
    CloseMessage
    ApplyMovement obj_D11R0106_gsassistantm, _0540
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13B
    ReleaseAll
    End
scr_seq_D11R0106_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13C, _0477
    Message msg_0053_D11R0106_00009
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_SUPER_NERD_WALDO, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0419
    Message msg_0053_D11R0106_00011
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0482
    ApplyMovement obj_D11R0106_gsassistantm_2, _054A
    GoTo _0494
scr_seq_D11R0106_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13D, _049E
    Message msg_0053_D11R0106_00012
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_SUPER_NERD_MERLE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0419
    Message msg_0053_D11R0106_00014
    CloseMessage
    ApplyMovement obj_D11R0106_gsassistantm_3, _0554
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13D
    ReleaseAll
    End
scr_seq_D11R0106_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13E, _04A9
    Message msg_0053_D11R0106_00015
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_SCIENTIST_GS_LOWELL, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0419
    Message msg_0053_D11R0106_00017
    CloseMessage
    ApplyMovement obj_D11R0106_assistantm, _055E
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13E
    ReleaseAll
    End
scr_seq_D11R0106_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_13F, _04B4
    Message msg_0053_D11R0106_00018
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_SCIENTIST_GS_LINDEN, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0419
    Message msg_0053_D11R0106_00020
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _04BF
    ApplyMovement obj_D11R0106_assistantm_2, _0568
    GoTo _04D1
scr_seq_D11R0106_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_140, _04DB
    Message msg_0053_D11R0106_00021
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_SCIENTIST_GS_DANIEL, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0419
    Message msg_0053_D11R0106_00023
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _04E6
    ApplyMovement obj_D11R0106_assistantm_3, _0572
    GoTo _04F8
scr_seq_D11R0106_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_VOLCANO, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0502
    Message msg_0053_D11R0106_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D11R0106_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MOLTRES, 0
    WaitCry
    CompleteStartWildBattle SPECIES_MOLTRES, 60, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 8
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0419
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _050D
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 1, _051C
    CompareVar VAR_MAP_LOCAL_0x02, 5
    CallIf 1, _050D
    ReleaseAll
    End
scr_seq_D11R0106_011:
    BufferPlayerName 0
    BufferPlayerName 0
    ReleaseAll
    End
_039B:
    End
_039D:
    SetFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    End
_03A3:
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 5, _0528
    SetFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    GoTo _039B
_03BE:
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _052E
    SetFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    GoTo _0534
_03D9:
    SetPosition obj_D11R0106_gsassistantm, 21, 0, 14, DIR_WEST
    Return
_03E7:
    SetPosition obj_D11R0106_gsassistantm_3, 9, 0, 13, DIR_NORTH
    Return
_03F5:
    SetPosition obj_D11R0106_assistantm, 15, 0, 16, DIR_SOUTH
    Return
_0403:
    GoToIfUnset FLAG_HGSS_GOT_TM50_FROM_BLAINE, _041F
    Message msg_0053_D11R0106_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0419:
    BlackOutFromBattle
    ReleaseAll
    End
_041F:
    SetVar VAR_0x8004, ITEM_TM50
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0536
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM50_FROM_BLAINE
    BufferPlayerName 0
    Message msg_0053_D11R0106_00004
    Message msg_0053_D11R0106_00027
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0053_D11R0106_00028
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BLAINE
    WaitButton
    CloseMessage
    ReleaseAll
    End
_046C:
    Message msg_0053_D11R0106_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0477:
    Message msg_0053_D11R0106_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0482:
    ApplyMovement obj_D11R0106_gsassistantm_2, _057C
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13C
    ReleaseAll
    End
_0494:
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13C
    ReleaseAll
    End
_049E:
    Message msg_0053_D11R0106_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04A9:
    Message msg_0053_D11R0106_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04B4:
    Message msg_0053_D11R0106_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04BF:
    ApplyMovement obj_D11R0106_assistantm_2, _0586
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13F
    ReleaseAll
    End
_04D1:
    WaitMovement
    SetFlag FLAG_HGSS_UNK_13F
    ReleaseAll
    End
_04DB:
    Message msg_0053_D11R0106_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04E6:
    ApplyMovement obj_D11R0106_assistantm_3, _0590
    WaitMovement
    SetFlag FLAG_HGSS_UNK_140
    ReleaseAll
    End
_04F8:
    WaitMovement
    SetFlag FLAG_HGSS_UNK_140
    ReleaseAll
    End
_0502:
    Message msg_0053_D11R0106_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_050D:
    Message msg_0053_D11R0106_00026
    ClearFlag FLAG_HGSS_SG_3FB7
    WaitButton
    CloseMessage
    ReleaseAll
    End
_051C:
    ClearFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    ClearFlag FLAG_HGSS_SG_3FB6
    ReleaseAll
    End
_0528:
    ClearFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    End
_052E:
    ClearFlag FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE
    End
_0534:
    End
_0536:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0540:
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_054A:
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0554:
    WalkNormalSouth
    FaceNorth
    EndMovement
    .balign 4, 0
_055E:
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0568:
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_0572:
    WalkNormalWest
    FaceEast
    EndMovement
    .balign 4, 0
_057C:
    WalkNormalSouth
    FaceNorth
    EndMovement
    .balign 4, 0
_0586:
    WalkNormalWest
    FaceEast
    EndMovement
    .balign 4, 0
_0590:
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
