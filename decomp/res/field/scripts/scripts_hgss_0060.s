#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0091.h"

#define obj_D26R0102_rocketm 1
#define obj_D26R0102_rocketm_2 2
#define obj_D26R0102_rocketw 3
#define obj_D26R0102_rkanbum3 4
#define obj_D26R0102_gantetsu 7
#define STICKS_ACTIVE 1

    ScriptEntry scr_seq_D26R0102_000
    ScriptEntry scr_seq_D26R0102_001
    ScriptEntry scr_seq_D26R0102_002
    ScriptEntryEnd
scr_seq_D26R0102_000:
    NPCMessage msg_0091_D26R0102_00005
    End
scr_seq_D26R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0091_D26R0102_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0047
    CloseMessage
    ReleaseAll
    End
_0047:
    BufferPlayerName 0
    Message msg_0091_D26R0102_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D26R0102_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0091_D26R0102_00001
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_EXECUTIVE_PROTON_PROTON, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0193
    Message msg_0091_D26R0102_00002
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_D26R0102_rocketm
    RemoveObject obj_D26R0102_rocketm_2
    RemoveObject obj_D26R0102_rocketw
    RemoveObject obj_D26R0102_rkanbum3
    SetFlag FLAG_HGSS_UNK_1A9
    WaitTime 20, VAR_0x8004
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetPosition obj_D26R0102_gantetsu, 36, 0, 7, DIR_WEST
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00F7
    ApplyMovement obj_D26R0102_gantetsu, _019C
    ApplyMovement LOCALID_PLAYER, _01C0
    GoTo _0107
_00F7:
    ApplyMovement obj_D26R0102_gantetsu, _019C
    ApplyMovement LOCALID_PLAYER, _01DC
_0107:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    Message msg_0091_D26R0102_00000
    CloseMessage
    ClearFlag FLAG_HGSS_UNK_19E
    ClearFlag FLAG_HGSS_HIDE_AZALEA_SLOWPOKES
    SetFlag FLAG_HGSS_BEAT_AZALEA_ROCKETS
    SetVarFromValue VAR_HGSS_UNK_4075, 1
    SetVarFromValue VAR_HGSS_UNK_4080, 2
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, STICKS_ACTIVE
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, STICKS_ACTIVE
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_AZALEA_KURT_HOUSE, 4, 5, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_1AA
    SetFlag FLAG_HGSS_UNK_1D5
    SetFlag FLAG_HGSS_UNK_1AC
    ClearFlag FLAG_HGSS_HIDE_ILEX_APPRENTICE
    ClearFlag FLAG_HGSS_HIDE_FARFETCHD_1_LOST
    ClearFlag FLAG_HGSS_HIDE_FARFETCHD_2_LOST
    SetVarFromValue VAR_HGSS_UNK_40F4, 1
    ReleaseAll
    End
_0193:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_019C:
    WalkNormalWest 2
    WalkNormalSouth 2
    WalkNormalWest 3
    WalkNormalNorth 2
    Delay4 4
    WalkNormalWest
    WalkNormalNorth 3
    FaceWest
    EndMovement
    .balign 4, 0
_01C0:
    WalkNormalEast 2
    FaceNorth
    Delay8 6
    FaceSouth
    Delay8 5
    FaceEast
    EndMovement
    .balign 4, 0
_01DC:
    WalkNormalSouth
    WalkNormalEast
    FaceNorth
    Delay8 6
    FaceSouth
    Delay8 5
    FaceEast
    EndMovement
    .balign 4, 0
