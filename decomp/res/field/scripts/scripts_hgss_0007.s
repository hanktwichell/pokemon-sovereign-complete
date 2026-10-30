#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0049.h"

#define obj_D02R0101_gsrivel 0

    ScriptEntry scr_seq_D02R0101_000
    ScriptEntryEnd
scr_seq_D02R0101_000:
    Common_SetRivalBGM
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D02R0101_gsrivel, _00D0
    ApplyMovement LOCALID_PLAYER, _00DC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    CompleteBufferHGSSRivalName 1
    Message msg_0049_D02R0101_00000
    CloseMessage
    SetVarFromVar VAR_RESULT, VAR_HGSS_PLAYER_STARTER
    CompareVar VAR_RESULT, 152
    GoToIf 5, _005A
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_15, 0
    GoTo _007D
_005A:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _0075
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_16, 0
    GoTo _007D
_0075:
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_14, 0
_007D:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00C9
    Common_SetRivalBGM
    BufferPlayerName 0
    CompleteBufferHGSSRivalName 1
    Message msg_0049_D02R0101_00001
    CloseMessage
    ApplyMovement obj_D02R0101_gsrivel, _00E8
    WaitMovement
    RemoveObject obj_D02R0101_gsrivel
    Common_FadeToDefaultMusic2
    SetFlag FLAG_HGSS_UNK_25C
    ClearFlag FLAG_HGSS_HIDE_DRAGONS_DEN_RIVAL
    SetVarFromValue VAR_HGSS_UNK_40FC, 1
    SetVarFromValue VAR_HGSS_UNK_40F5, 1
    SetFlag FLAG_HGSS_UNK_0E3
    End
_00C9:
    BlackOutFromBattle
    End
    .balign 4, 0
_00D0:
    EmoteExclamationMark
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_00DC:
    Delay8 4
    WalkNormalEast
    EndMovement
    .balign 4, 0
_00E8:
    WalkFastEast 5
    WalkFastSouth 9
    EndMovement
    End
    .balign 4, 0
