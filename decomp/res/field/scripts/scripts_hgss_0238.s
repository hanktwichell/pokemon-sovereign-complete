#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0385.h"

#define obj_R34R0101_var_1 1
#define obj_R34R0101_tsure_poke_static_marill 2

    ScriptEntry scr_seq_R34R0101_000
    ScriptEntry scr_seq_R34R0101_001
    ScriptEntryEnd
scr_seq_R34R0101_001:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R34R0101_var_1, _0140
    ApplyMovement obj_R34R0101_tsure_poke_static_marill, _014C
    ApplyMovement LOCALID_PLAYER, _0158
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0385_R34R0101_00000, msg_0385_R34R0101_00010
    CloseMessage
    MessageGendered msg_0385_R34R0101_00001, msg_0385_R34R0101_00011
    CloseMessage
    ApplyMovement obj_R34R0101_var_1, _0138
    WaitMovement
    MessageGendered msg_0385_R34R0101_00002, msg_0385_R34R0101_00012
    CloseMessage
    MessageGendered msg_0385_R34R0101_00003, msg_0385_R34R0101_00013
    CloseMessage
    ApplyMovement obj_R34R0101_var_1, _0164
    WaitMovement
    MessageGendered msg_0385_R34R0101_00004, msg_0385_R34R0101_00014
    CloseMessage
    ApplyMovement obj_R34R0101_var_1, _016C
    ApplyMovement obj_R34R0101_tsure_poke_static_marill, _0184
    WaitMovement
    MessageGendered msg_0385_R34R0101_00005, msg_0385_R34R0101_00015
    CloseMessage
    ApplyMovement obj_R34R0101_var_1, _0198
    ApplyMovement obj_R34R0101_tsure_poke_static_marill, _01A8
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0190
    WaitMovement
    MessageGendered msg_0385_R34R0101_00006, msg_0385_R34R0101_00016
    CloseMessage
    GetPlayerGender VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00C6
    @ HGSS: RegisterGearNumber PHONE_CONTACT_LYRA
    GoTo _00CA
_00C6:
    @ HGSS: RegisterGearNumber PHONE_CONTACT_ETHAN
_00CA:
    BufferPlayerName 0
    MessageGendered msg_0385_R34R0101_00007, msg_0385_R34R0101_00017
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    ApplyMovement obj_R34R0101_var_1, _01BC
    WaitMovement
    MessageGendered msg_0385_R34R0101_00008, msg_0385_R34R0101_00018
    CloseMessage
    ApplyMovement obj_R34R0101_var_1, _01C4
    ApplyMovement obj_R34R0101_tsure_poke_static_marill, _01CC
    WaitMovement
    MessageGendered msg_0385_R34R0101_00009, msg_0385_R34R0101_00019
    CloseMessage
    ApplyMovement obj_R34R0101_var_1, _01D4
    ApplyMovement obj_R34R0101_tsure_poke_static_marill, _01E8
    ApplyMovement LOCALID_PLAYER, _0204
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_R34R0101_var_1
    RemoveObject obj_R34R0101_tsure_poke_static_marill
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetVarFromValue VAR_HGSS_UNK_408E, 2
    SetFlag FLAG_HGSS_UNK_22D
    ReleaseAll
    End
    .balign 4, 0
_0138:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0140:
    Delay8
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_014C:
    WalkFastNorth 3
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_0158:
    Delay8
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_0164:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_016C:
    WalkNormalWest
    WalkNormalSouth 3
    Delay8
    EmoteExclamationMark
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0184:
    WalkNormalWest 2
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0190:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0198:
    Delay8
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_01A8:
    WalkOnSpotNormalEast
    LockDir
    JumpNearFastWest
    UnlockDir
    EndMovement
    .balign 4, 0
_01BC:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_01C4:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01CC:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01D4:
    WalkNormalSouth 2
    WalkNormalEast
    WalkNormalSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_01E8:
    Delay8
    JumpOnSpotFastNorth 2
    Delay8
    WalkFastSouth 3
    WalkFastEast 2
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_0204:
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_R34R0101_000:
    @ HGSS: UpdateDaycareMonObjects
    End
    .balign 4, 0
