#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0255.h"

#define obj_P01R0101_seaman_2 0
#define obj_P01R0101_ookido 1

    ScriptEntry scr_seq_P01R0101_000
    ScriptEntry scr_seq_P01R0101_001
    ScriptEntry scr_seq_P01R0101_002
    ScriptEntry scr_seq_P01R0101_003
    ScriptEntry scr_seq_P01R0101_004
    ScriptEntryEnd
scr_seq_P01R0101_001:
    @ HGSS: ScrCmd_445 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 330
    GoToIf 1, _0029
    End
_0029:
    @ HGSS: SetObjectFacing obj_P01R0101_seaman_2, DIR_SOUTH
    End
scr_seq_P01R0101_002:
    LockAll
    ApplyMovement obj_P01R0101_ookido, _00E4
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_P01R0101_ookido, _00EC
    ApplyMovement LOCALID_PLAYER, _0100
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0255_P01R0101_00009, msg_0255_P01R0101_00010
    CloseMessage
    ApplyMovement obj_P01R0101_ookido, _0110
    WaitMovement
    @ HGSS: NatDexFlagAction 1, VAR_SPECIAL_RESULT
    BufferPlayerName 0
    PlayFanfare SEQ_FANFA4_sseq
    Message msg_0255_P01R0101_00011
    WaitFanfare
    @ HGSS: EnableMassOutbreaks
    Message msg_0255_P01R0101_00012
    CloseMessage
    ApplyMovement obj_P01R0101_ookido, _0120
    WaitMovement
    Message msg_0255_P01R0101_00013
    CloseMessage
    ApplyMovement obj_P01R0101_ookido, _0128
    WaitMovement
    RemoveObject obj_P01R0101_ookido
    SetFlag FLAG_HGSS_HIDE_OLIVINE_PORT_OAK
    SetVarFromValue VAR_HGSS_UNK_411A, 0
    FadeOutBGM 0, 30
    StopMusic
    @ HGSS: ResetBGM
    ReleaseAll
    CompareVar VAR_HGSS_UNK_40D3, 1
    CallIf 1, _00DE
    @ HGSS: EnableMassOutbreaks
    End
_00DE:
    ClearFlag FLAG_HGSS_HIDE_POKEATHLON_SUPREME_CUP_RECEPTIONIST
    Return
    .balign 4, 0
_00E4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_00EC:
    Delay8
    WalkNormalWest 3
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0100:
    Delay8 3
    WalkNormalSouth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0110:
    WalkOnSpotNormalWest
    Delay8 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0120:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0128:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth
    EndMovement
scr_seq_P01R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _0361
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _0356
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _0320
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 7
    GoToIf 4, _01FB
    Message msg_0255_P01R0101_00001
    CloseMessage
    CheckItem ITEM_SS_TICKET, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02F9
    ApplyMovement LOCALID_PLAYER, _036C
    WaitMovement
    BufferPlayerName 0
    Message msg_0255_P01R0101_00004
    CloseMessage
    ApplyMovement obj_P01R0101_seaman_2, _03F4
    WaitMovement
    Message msg_0255_P01R0101_00005
    CloseMessage
    ApplyMovement obj_P01R0101_seaman_2, _038C
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _03AC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    SetVarFromValue VAR_HGSS_BOAT_DIRECTION, 1
    SetVarFromValue VAR_HGSS_UNK_40DC, 0
    ClearFlag FLAG_HGSS_BOAT_ARRIVED
    SetFlag FLAG_HGSS_UNK_22C
    SetFlag FLAG_HGSS_UNK_22B
    ReleaseAll
    End
_01FB:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0218
    GoTo _02EE
_0212:
    GoTo _029B
_0218:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0231
    GoTo _029B
_022B:
    GoTo _029B
_0231:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _024A
    GoTo _02EE
_0244:
    GoTo _029B
_024A:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0263
    GoTo _02EE
_025D:
    GoTo _029B
_0263:
    CompareVar VAR_RESULT, 4
    GoToIf 5, _027C
    GoTo _02EE
_0276:
    GoTo _029B
_027C:
    CompareVar VAR_RESULT, 5
    GoToIf 5, _0295
    GoTo _029B
_028F:
    GoTo _029B
_0295:
    GoTo _02EE
_029B:
    Message msg_0255_P01R0101_00007
    CloseMessage
    ApplyMovement obj_P01R0101_seaman_2, _038C
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _03AC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    SetVarFromValue VAR_HGSS_BOAT_DIRECTION, 1
    SetVarFromValue VAR_HGSS_UNK_40DC, 0
    ClearFlag FLAG_HGSS_BOAT_ARRIVED
    SetFlag FLAG_HGSS_UNK_22A
    ClearFlag FLAG_HGSS_UNK_22B
    SetFlag FLAG_HGSS_UNK_22C
    ReleaseAll
    End
_02EE:
    Message msg_0255_P01R0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02F9:
    ApplyMovement LOCALID_PLAYER, _0378
    WaitMovement
    BufferPlayerName 0
    Message msg_0255_P01R0101_00002
    CloseMessage
    ApplyMovement obj_P01R0101_seaman_2, _03F4
    WaitMovement
    Message msg_0255_P01R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0320:
    ApplyMovement obj_P01R0101_seaman_2, _03B4
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _03D4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_P01R0101_seaman_2, _03E0
    WaitMovement
    ReleaseAll
    End
_0356:
    Message msg_0255_P01R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0361:
    Message msg_0255_P01R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_036C:
    WalkOnSpotNormalEast
    FaceSouth 2
    EndMovement
    .balign 4, 0
_0378:
    JumpOnSpotFastWest
    JumpOnSpotFastEast
    FaceSouth 2
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_038C:
    LockDir
    WalkNormalSouth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_03AC:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_03B4:
    LockDir
    WalkNormalNorth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_03D4:
    Delay8
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_03E0:
    WalkNormalWest
    FaceSouth 2
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03F4:
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_P01R0101_003:
    NPCMessage msg_0255_P01R0101_00014
    End
scr_seq_P01R0101_004:
    NPCMessage msg_0255_P01R0101_00015
    End
    .balign 4, 0
