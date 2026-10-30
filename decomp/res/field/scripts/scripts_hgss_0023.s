#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0060.h"

#define obj_D18R0101_gsrivel 0
#define obj_D18R0101_minaki 1

    ScriptEntry scr_seq_D18R0101_000
    ScriptEntry scr_seq_D18R0101_001
    ScriptEntry scr_seq_D18R0101_002
    ScriptEntry scr_seq_D18R0101_003
    ScriptEntry scr_seq_D18R0101_004
    ScriptEntryEnd
scr_seq_D18R0101_003:
    LockAll
    Common_SetRivalBGM
    ApplyMovement obj_D18R0101_gsrivel, _01F0
    WaitMovement
    CompleteBufferHGSSRivalName 0
    Message msg_0060_D18R0101_00000
    CloseMessage
    SetVarFromVar VAR_RESULT, VAR_HGSS_PLAYER_STARTER
    CompareVar VAR_RESULT, 152
    GoToIf 5, _0115
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_8, 0
    GoTo _0130
    LockAll
    ApplyMovement obj_D18R0101_minaki, _0208
    WaitMovement
    BufferPlayerName 0
    Message msg_0060_D18R0101_00002
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_UNK_40A2, 1
    ReleaseAll
    End
scr_seq_D18R0101_000:
    LockAll
    ApplyMovement obj_D18R0101_minaki, _0208
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
scr_seq_D18R0101_002:
    NPCMessage msg_0060_D18R0101_00004
    End
scr_seq_D18R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MAGMAR, 0
    WaitCry
    CompleteStartWildBattle SPECIES_MAGMAR, 33, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01EA
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 14
    SetFlag FLAG_HGSS_SG_3FE9
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0115:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _0189
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_11, 0
    GoTo _0130
_0130:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01EA
    Common_SetRivalBGM
    CompleteBufferHGSSRivalName 0
    Message msg_0060_D18R0101_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0218
    ApplyMovement obj_D18R0101_gsrivel, _0228
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
_0189:
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_4, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01EA
    Common_SetRivalBGM
    CompleteBufferHGSSRivalName 0
    Message msg_0060_D18R0101_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0218
    ApplyMovement obj_D18R0101_gsrivel, _0228
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
_01EA:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_01F0:
    FaceSouth
    EmoteExclamationMark
    WalkNormalSouth 4
    WalkNormalWest
    FaceSouth
    EndMovement
    .balign 4, 0
_0208:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0218:
    WalkNormalSouth 2
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_0228:
    WalkNormalSouth 3
    WalkNormalWest
    WalkNormalSouth
    WalkNormalWest 3
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
