#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0523.h"

#define obj_T10R0201_babyboy1_11 1
#define obj_T10R0201_leag_door2 2
#define obj_T10R0201_stop 3
#define obj_T10R0201_stop_2 4

    ScriptEntry scr_seq_T10R0201_000
    ScriptEntry scr_seq_T10R0201_001
    ScriptEntry scr_seq_T10R0201_002
    ScriptEntryEnd
scr_seq_T10R0201_002:
    GoToIfSet FLAG_HGSS_DEFEATED_WILL, _0023
    ShowObject obj_T10R0201_stop
    ShowObject obj_T10R0201_stop_2
    End
_0023:
    End
scr_seq_T10R0201_000:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0060
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_HIDE_WILLS_ROOM_RETREAT
    AddObject obj_T10R0201_babyboy1_11
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    ReleaseAll
    End
    .balign 4, 0
_0060:
    WalkNormalNorth 6
    EndMovement
scr_seq_T10R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_DEFEATED_WILL, _00D1
    Message msg_0523_T10R0201_00000
    CloseMessage
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 0, _009B
    @ HGSS: TrainerBattle TRAINER_ELITE_FOUR_WILL_WILL_2, 0, 0, 0
    GoTo _00A3
_009B:
    @ HGSS: TrainerBattle TRAINER_ELITE_FOUR_WILL_WILL, 0, 0, 0
_00A3:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00DC
    SetFlag FLAG_HGSS_DEFEATED_WILL
    Message msg_0523_T10R0201_00001
    CloseMessage
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    RemoveObject obj_T10R0201_leag_door2
    RemoveObject obj_T10R0201_stop
    RemoveObject obj_T10R0201_stop_2
    ReleaseAll
    End
_00D1:
    Message msg_0523_T10R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00DC:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
