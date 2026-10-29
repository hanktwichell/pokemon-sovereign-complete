#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0564.h"

#define STICKS_ACTIVE 1
#define obj_T23_gsrivel 9
#define obj_T23_rocketm_3 12
#define obj_T23_gsmiddleman1_2 13

    ScriptEntry scr_seq_T23_000
    ScriptEntry scr_seq_T23_001
    ScriptEntry scr_seq_T23_002
    ScriptEntry scr_seq_T23_003
    ScriptEntry scr_seq_T23_004
    ScriptEntry scr_seq_T23_005
    ScriptEntry scr_seq_T23_006
    ScriptEntry scr_seq_T23_007
    ScriptEntry scr_seq_T23_008
    ScriptEntry scr_seq_T23_009
    ScriptEntry scr_seq_T23_010
    ScriptEntry scr_seq_T23_011
    ScriptEntry scr_seq_T23_012
    ScriptEntry scr_seq_T23_013
    ScriptEntry scr_seq_T23_014
    ScriptEntry scr_seq_T23_015
    ScriptEntry scr_seq_T23_016
    ScriptEntryEnd
scr_seq_T23_004:
    CompareVar VAR_HGSS_UNK_4080, 0
    GoToIf 5, _005F
    SetFlag FLAG_HGSS_UNK_19F
    ClearFlag FLAG_HGSS_AZALEA_ROCKET_HARASSING_CIVILIAN
    ClearFlag FLAG_HGSS_AZALEA_HARASSED_CIVILIAN
_005F:
    End
scr_seq_T23_000:
scr_seq_T23_005:
    NPCMessage msg_0564_T23_00003
    End
scr_seq_T23_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0564_T23_00009
    PlayCry SPECIES_SLOWPOKE, 0
    Message msg_0564_T23_00010
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T23_002:
    LockAll
    FadeOutBGM 0, 3
    ApplyMovement LOCALID_PLAYER, _02A4
    WaitMovement
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, STICKS_ACTIVE
    Common_SetRivalBGM
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 462
    GoToIf 5, _00E5
    SetPosition obj_T23_gsrivel, 404, 0, 463, DIR_WEST
    ApplyMovement obj_T23_gsrivel, _028C
    ApplyMovement LOCALID_PLAYER, _02AC
    GoTo _018E
_00E5:
    CompareVar VAR_0x8005, 463
    GoToIf 5, _0114
    SetPosition obj_T23_gsrivel, 404, 0, 464, DIR_WEST
    ApplyMovement obj_T23_gsrivel, _028C
    ApplyMovement LOCALID_PLAYER, _02AC
    GoTo _018E
_0114:
    CompareVar VAR_0x8005, 464
    GoToIf 5, _0143
    SetPosition obj_T23_gsrivel, 404, 0, 463, DIR_WEST
    ApplyMovement obj_T23_gsrivel, _0298
    ApplyMovement LOCALID_PLAYER, _02C0
    GoTo _018E
_0143:
    CompareVar VAR_0x8005, 465
    GoToIf 5, _0172
    SetPosition obj_T23_gsrivel, 404, 0, 464, DIR_WEST
    ApplyMovement obj_T23_gsrivel, _0298
    ApplyMovement LOCALID_PLAYER, _02C0
    GoTo _018E
_0172:
    SetPosition obj_T23_gsrivel, 404, 0, 465, DIR_WEST
    ApplyMovement obj_T23_gsrivel, _0298
    ApplyMovement LOCALID_PLAYER, _02C0
_018E:
    WaitMovement
    BufferRivalName 0
    Message msg_0564_T23_00001
    CloseMessage
    @ HGSS: GetStarterChoice VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 5, _01B7
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_7, 0, 0, 0
    GoTo _01DA
_01B7:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _01D2
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_10, 0, 0, 0
    GoTo _01DA
_01D2:
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER, 0, 0, 0
_01DA:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0285
    Common_SetRivalBGM
    BufferRivalName 0
    Message msg_0564_T23_00002
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4075, 2
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 462
    GoToIf 5, _021E
    ApplyMovement obj_T23_gsrivel, _02D4
    GoTo _0277
_021E:
    CompareVar VAR_0x8005, 463
    GoToIf 5, _0239
    ApplyMovement obj_T23_gsrivel, _02DC
    GoTo _0277
_0239:
    CompareVar VAR_0x8005, 464
    GoToIf 5, _0254
    ApplyMovement obj_T23_gsrivel, _02D4
    GoTo _0277
_0254:
    CompareVar VAR_0x8005, 465
    GoToIf 5, _026F
    ApplyMovement obj_T23_gsrivel, _02DC
    GoTo _0277
_026F:
    ApplyMovement obj_T23_gsrivel, _02EC
_0277:
    WaitMovement
    RemoveObject obj_T23_gsrivel
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
_0285:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_028C:
    WalkNormalWest 9
    FaceNorth
    EndMovement
    .balign 4, 0
_0298:
    WalkNormalWest 9
    FaceSouth
    EndMovement
    .balign 4, 0
_02A4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_02AC:
    FaceEast
    Delay4 6
    Delay8 7
    FaceSouth
    EndMovement
    .balign 4, 0
_02C0:
    FaceEast
    Delay4 6
    Delay8 7
    FaceNorth
    EndMovement
    .balign 4, 0
_02D4:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_02DC:
    WalkNormalWest
    WalkNormalNorth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_02EC:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 2
    EndMovement
scr_seq_T23_003:
    LockAll
    ApplyMovement obj_T23_rocketm_3, _0350
    WaitMovement
    Message msg_0564_T23_00016
    PlaySE SEQ_SE_DP_WALL_HIT_sseq
    Message msg_0564_T23_00017
    CloseMessage
    ApplyMovement obj_T23_gsmiddleman1_2, _0358
    WaitMovement
    SetPosition obj_T23_gsmiddleman1_2, 23, 0, 16, DIR_EAST
    ApplyMovement obj_T23_rocketm_3, _0374
    WaitMovement
    RemoveObject obj_T23_gsmiddleman1_2
    SetFlag FLAG_HGSS_AZALEA_HARASSED_CIVILIAN
    SetFlag FLAG_HGSS_AZALEA_ROCKET_HARASSING_CIVILIAN
    ClearFlag FLAG_HGSS_UNK_19F
    SetVarFromValue VAR_HGSS_UNK_4080, 1
    ReleaseAll
    End
    .balign 4, 0
_0350:
    WalkOnSpotNormalWest 2
    EndMovement
    .balign 4, 0
_0358:
    LockDir
    WalkFasterWest
    Delay8 2
    WalkSlowWest 2
    UnlockDir
    WalkFastWest 9
    EndMovement
    .balign 4, 0
_0374:
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_T23_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _039C
    Message msg_0564_T23_00018
    GoTo _039F
_039C:
    Message msg_0564_T23_00019
_039F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T23_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _03C3
    Message msg_0564_T23_00005
    GoTo _039F
_03C3:
    Message msg_0564_T23_00006
    GoTo _039F
scr_seq_T23_008:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0564_T23_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T23_009:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0564_T23_00013, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T23_010:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0564_T23_00015, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T23_011:
    DrawSignpostInstantMessage msg_0564_T23_00011, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T23_012:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0564_T23_00014, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T23_013:
    DrawSignpostInstantMessage msg_0564_T23_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T23_014:
    NPCMessage msg_0564_T23_00004
    End
scr_seq_T23_015:
    NPCMessage msg_0564_T23_00007
    End
scr_seq_T23_016:
    NPCMessage msg_0564_T23_00008
    End
    .balign 4, 0
