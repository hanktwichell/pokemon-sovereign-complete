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
    GoToIf 1, _01C9
    End
scr_seq_P01R0101_002:
    LockAll
    ApplyMovement obj_P01R0101_ookido, _0324
    WaitMovement
    StopMusic
    PlayMusic SEQ_GS_OHKIDO_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_P01R0101_ookido, _032A
    ApplyMovement LOCALID_PLAYER, _033C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0255_P01R0101_00009, msg_0255_P01R0101_00010
    CloseMessage
    ApplyMovement obj_P01R0101_ookido, _034A
    WaitMovement
    GetSetNationalDexEnabled 1, VAR_RESULT
    BufferPlayerName 0
    Message msg_0255_P01R0101_00011
    @ HGSS: EnableMassOutbreaks
    SetVar VAR_0x8004, ITEM_LOCK_CAPSULE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0255_P01R0101_00012
    CloseMessage
    ApplyMovement obj_P01R0101_ookido, _0358
    WaitMovement
    Message msg_0255_P01R0101_00013
    CloseMessage
    ApplyMovement obj_P01R0101_ookido, _035E
    WaitMovement
    RemoveObject obj_P01R0101_ookido
    SetFlag FLAG_HGSS_HIDE_OLIVINE_PORT_OAK
    SetVarFromValue VAR_HGSS_UNK_411A, 0
    FadeOutBGM 0, 30
    StopMusic
    PlayDefaultMusic
    ReleaseAll
    CompareVar VAR_HGSS_UNK_40D3, 1
    CallIf 1, _01D1
    @ HGSS: EnableMassOutbreaks
    End
scr_seq_P01R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _01D7
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _01E2
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _01ED
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 7
    GoToIf 4, _0223
    Message msg_0255_P01R0101_00001
    CloseMessage
    CheckItem ITEM_SS_TICKET, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _023A
    ApplyMovement LOCALID_PLAYER, _036C
    WaitMovement
    BufferPlayerName 0
    Message msg_0255_P01R0101_00004
    CloseMessage
    ApplyMovement obj_P01R0101_seaman_2, _0376
    WaitMovement
    Message msg_0255_P01R0101_00005
    CloseMessage
    ApplyMovement obj_P01R0101_seaman_2, _037C
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _039A
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
scr_seq_P01R0101_003:
    NPCMessage msg_0255_P01R0101_00014
    End
scr_seq_P01R0101_004:
    NPCMessage msg_0255_P01R0101_00015
    End
_01C9:
    SetObjectEventDir obj_P01R0101_seaman_2, DIR_SOUTH
    End
_01D1:
    ClearFlag FLAG_HGSS_HIDE_POKEATHLON_SUPREME_CUP_RECEPTIONIST
    Return
_01D7:
    Message msg_0255_P01R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01E2:
    Message msg_0255_P01R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01ED:
    ApplyMovement obj_P01R0101_seaman_2, _03A0
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _03BE
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_P01R0101_seaman_2, _03C8
    WaitMovement
    ReleaseAll
    End
_0223:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0261
    GoTo _0274
_023A:
    ApplyMovement LOCALID_PLAYER, _03DA
    WaitMovement
    BufferPlayerName 0
    Message msg_0255_P01R0101_00002
    CloseMessage
    ApplyMovement obj_P01R0101_seaman_2, _0376
    WaitMovement
    Message msg_0255_P01R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0261:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _027F
    GoTo _0292
_0274:
    Message msg_0255_P01R0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_027F:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _02E5
    GoTo _0274
_0292:
    Message msg_0255_P01R0101_00007
    CloseMessage
    ApplyMovement obj_P01R0101_seaman_2, _037C
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _039A
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
_02E5:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _02F8
    GoTo _0274
_02F8:
    CompareVar VAR_RESULT, 4
    GoToIf 5, _030B
    GoTo _0274
_030B:
    CompareVar VAR_RESULT, 5
    GoToIf 5, _031E
    GoTo _0292
_031E:
    GoTo _0274
    .balign 4, 0
_0324:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_032A:
    Delay8
    WalkNormalWest 3
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_033C:
    Delay8 3
    WalkNormalSouth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_034A:
    WalkOnSpotNormalWest
    Delay8 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0358:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_035E:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_036C:
    WalkOnSpotNormalEast
    FaceSouth 2
    EndMovement
    .balign 4, 0
_0376:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_037C:
    LockDir
    WalkNormalSouth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_039A:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_03A0:
    LockDir
    WalkNormalNorth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_03BE:
    Delay8
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_03C8:
    WalkNormalWest
    FaceSouth 2
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03DA:
    JumpOnSpotFastWest
    JumpOnSpotFastEast
    FaceSouth 2
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
