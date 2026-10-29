#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0525.h"

#define obj_T10R0401_babyboy1_11 1
#define obj_T10R0401_leag_door2 2
#define obj_T10R0401_leag_door2_2 3
#define obj_T10R0401_leag_door2_3 4

    ScriptEntry scr_seq_T10R0401_000
    ScriptEntry scr_seq_T10R0401_001
    ScriptEntry scr_seq_T10R0401_002
    ScriptEntryEnd
scr_seq_T10R0401_002:
    GoToIfSet FLAG_HGSS_DEFEATED_BRUNO, _0023
    ShowObject obj_T10R0401_leag_door2_2
    ShowObject obj_T10R0401_leag_door2_3
    End
_0023:
    End
scr_seq_T10R0401_000:
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
    ClearFlag FLAG_HGSS_HIDE_BRUNOS_ROOM_RETREAT
    AddObject obj_T10R0401_babyboy1_11
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    ReleaseAll
    End
    .balign 4, 0
_0060:
    WalkNormalNorth 6
    EndMovement
scr_seq_T10R0401_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_DEFEATED_BRUNO, _00D4
    BufferPlayerName 0
    Message msg_0525_T10R0401_00000
    CloseMessage
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 0, _009E
    @ HGSS: TrainerBattle TRAINER_ELITE_FOUR_BRUNO_BRUNO_2, 0, 0, 0
    GoTo _00A6
_009E:
    @ HGSS: TrainerBattle TRAINER_ELITE_FOUR_BRUNO_BRUNO, 0, 0, 0
_00A6:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00DF
    SetFlag FLAG_HGSS_DEFEATED_BRUNO
    Message msg_0525_T10R0401_00001
    CloseMessage
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    RemoveObject obj_T10R0401_leag_door2
    RemoveObject obj_T10R0401_leag_door2_2
    RemoveObject obj_T10R0401_leag_door2_3
    ReleaseAll
    End
_00D4:
    Message msg_0525_T10R0401_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00DF:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
