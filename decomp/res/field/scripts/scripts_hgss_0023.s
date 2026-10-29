#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0060.h"

#define obj_D18R0101_gsrivel 0
#define obj_D18R0101_minaki 1

    ScriptEntry scr_seq_D18R0101_000
    ScriptEntry scr_seq_D18R0101_001
    ScriptEntry scr_seq_D18R0101_002
    ScriptEntry scr_seq_D18R0101_003
    ScriptEntryEnd
scr_seq_D18R0101_003:
    LockAll
    Common_SetRivalBGM
    ApplyMovement obj_D18R0101_gsrivel, _00D0
    WaitMovement
    BufferRivalName 0
    Message msg_0060_D18R0101_00000
    CloseMessage
    @ HGSS: GetStarterChoice VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 5, _004B
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_8, 0, 0, 0
    GoTo _006E
_004B:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _0066
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_11, 0, 0, 0
    GoTo _006E
_0066:
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_4, 0, 0, 0
_006E:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00C7
    Common_SetRivalBGM
    BufferRivalName 0
    Message msg_0060_D18R0101_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00E8
    ApplyMovement obj_D18R0101_gsrivel, _00F8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    RemoveObject obj_D18R0101_gsrivel
    Common_FadeToDefaultMusic2
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_1F_RIVAL
    SetVarFromValue VAR_HGSS_UNK_40A6, 1
    ReleaseAll
    End
_00C7:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_00D0:
    FaceSouth
    EmoteExclamationMark
    WalkNormalSouth 4
    WalkNormalWest
    FaceSouth
    EndMovement
    .balign 4, 0
_00E8:
    WalkNormalSouth 2
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_00F8:
    WalkNormalSouth 3
    WalkNormalWest
    WalkNormalSouth
    WalkNormalWest 3
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalSouth 3
    EndMovement
scr_seq_D18R0101_000:
    LockAll
    ApplyMovement obj_D18R0101_minaki, _0158
    WaitMovement
    BufferPlayerName 0
    Message msg_0060_D18R0101_00002
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_UNK_40A2, 1
    ReleaseAll
    End
scr_seq_D18R0101_001:
    NPCMessage msg_0060_D18R0101_00003
    End
    .balign 4, 0
_0158:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 3
    EndMovement
scr_seq_D18R0101_002:
    NPCMessage msg_0060_D18R0101_00004
    End
    .balign 4, 0
