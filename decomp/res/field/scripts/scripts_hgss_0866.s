#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0564.h"

#define obj_D36R0101_gsboy1 3
#define obj_D36R0101_monstarball_4 9
#define obj_D36R0101_dancer 12
#define obj_D36R0101_gsmiddleman1 13

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
    ScriptEntry scr_seq_T23_017
    ScriptEntry scr_seq_T23_018
    ScriptEntry scr_seq_T23_019
    ScriptEntryEnd
scr_seq_T23_004:
    CompareVar VAR_HGSS_UNK_4080, 0
    GoToIf 5, _031F
    SetFlag FLAG_HGSS_UNK_19F
    ClearFlag FLAG_HGSS_AZALEA_ROCKET_HARASSING_CIVILIAN
    ClearFlag FLAG_HGSS_AZALEA_HARASSED_CIVILIAN
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
    ApplyMovement LOCALID_PLAYER, _0580
    WaitMovement
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 1
    Common_SetRivalBGM
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 462
    GoToIf 5, _0321
    SetPosition obj_D36R0101_monstarball_4, 404, 0, 463, DIR_WEST
    ApplyMovement obj_D36R0101_monstarball_4, _0586
    ApplyMovement LOCALID_PLAYER, _0590
    GoTo _0350
scr_seq_T23_003:
    LockAll
    ApplyMovement obj_D36R0101_dancer, _05A2
    WaitMovement
    Message msg_0564_T23_00016
    PlaySE SEQ_SE_DP_WALL_HIT_sseq
    Message msg_0564_T23_00017
    CloseMessage
    ApplyMovement obj_D36R0101_gsmiddleman1, _05A8
    WaitMovement
    SetPosition obj_D36R0101_gsmiddleman1, 23, 0, 16, DIR_EAST
    ApplyMovement obj_D36R0101_dancer, _05C2
    WaitMovement
    RemoveObject obj_D36R0101_gsmiddleman1
    SetFlag FLAG_HGSS_AZALEA_HARASSED_CIVILIAN
    SetFlag FLAG_HGSS_AZALEA_ROCKET_HARASSING_CIVILIAN
    ClearFlag FLAG_HGSS_UNK_19F
    SetVarFromValue VAR_HGSS_UNK_4080, 1
    ReleaseAll
    End
scr_seq_T23_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _0379
    Message msg_0564_T23_00018
    GoTo _0384
scr_seq_T23_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _038C
    Message msg_0564_T23_00005
    GoTo _0384
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
scr_seq_T23_017:
    End
scr_seq_T23_018:
    CheckItem ITEM_ODD_KEYSTONE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _031F
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0564_T23_00020
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0395
    BufferPlayerName 0
    Message msg_0564_T23_00021
    CloseMessage
    BufferPlayerName 0
    ApplyMovement obj_D36R0101_gsboy1, _05CC
    WaitMovement
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    WaitSE SEQ_SE_DP_WALL_HIT2_sseq
    ApplyMovement obj_D36R0101_gsboy1, _05CC
    WaitMovement
    PlayCry SPECIES_SPIRITOMB, 6
    Message msg_0564_T23_00023
    WaitCry
    CloseMessage
    RemoveItem ITEM_ODD_KEYSTONE, 1, VAR_RESULT
    CompleteStartWildBattle SPECIES_SPIRITOMB, 20, 0
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _039B
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _03A1
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _03A1
    ReleaseAll
    End
scr_seq_T23_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F75, _0575
    Message msg_0564_T23_00024
    SetVar VAR_0x8004, ITEM_TM46
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0564_T23_00025
    SetFlag FLAG_HGSS_SG_3F75
    WaitButton
    CloseMessage
    ReleaseAll
    End
_031F:
    End
_0321:
    CompareVar VAR_0x8005, 463
    GoToIf 5, _03AC
    SetPosition obj_D36R0101_monstarball_4, 404, 0, 464, DIR_WEST
    ApplyMovement obj_D36R0101_monstarball_4, _0586
    ApplyMovement LOCALID_PLAYER, _0590
    GoTo _0350
_0350:
    WaitMovement
    BufferRivalName 0
    Message msg_0564_T23_00001
    CloseMessage
    GetPlayerStarterSpecies VAR_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 5, _03DB
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_7, 0
    GoTo _03F6
_0379:
    Message msg_0564_T23_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0384:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_038C:
    Message msg_0564_T23_00006
    GoTo _0384
_0395:
    CloseMessage
    ReleaseAll
    End
_039B:
    BlackOutFromBattle
    ReleaseAll
    End
_03A1:
    Message msg_0564_T23_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03AC:
    CompareVar VAR_0x8005, 464
    GoToIf 5, _043A
    SetPosition obj_D36R0101_monstarball_4, 404, 0, 463, DIR_WEST
    ApplyMovement obj_D36R0101_monstarball_4, _05D6
    ApplyMovement LOCALID_PLAYER, _05E0
    GoTo _0350
_03DB:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _0469
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_10, 0
    GoTo _03F6
_03F6:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04B5
    Common_SetRivalBGM
    BufferRivalName 0
    Message msg_0564_T23_00002
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4075, 2
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 462
    GoToIf 5, _04BB
    ApplyMovement obj_D36R0101_monstarball_4, _05F2
    GoTo _04D6
_043A:
    CompareVar VAR_0x8005, 465
    GoToIf 5, _04E4
    SetPosition obj_D36R0101_monstarball_4, 404, 0, 464, DIR_WEST
    ApplyMovement obj_D36R0101_monstarball_4, _05D6
    ApplyMovement LOCALID_PLAYER, _05E0
    GoTo _0350
_0469:
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04B5
    Common_SetRivalBGM
    BufferRivalName 0
    Message msg_0564_T23_00002
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4075, 2
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 462
    GoToIf 5, _04BB
    ApplyMovement obj_D36R0101_monstarball_4, _05F2
    GoTo _04D6
_04B5:
    BlackOutFromBattle
    ReleaseAll
    End
_04BB:
    CompareVar VAR_0x8005, 463
    GoToIf 5, _0529
    ApplyMovement obj_D36R0101_monstarball_4, _05F8
    GoTo _04D6
_04D6:
    WaitMovement
    RemoveObject obj_D36R0101_monstarball_4
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
_04E4:
    SetPosition obj_D36R0101_monstarball_4, 404, 0, 465, DIR_WEST
    ApplyMovement obj_D36R0101_monstarball_4, _05D6
    ApplyMovement LOCALID_PLAYER, _05E0
    WaitMovement
    BufferRivalName 0
    Message msg_0564_T23_00001
    CloseMessage
    GetPlayerStarterSpecies VAR_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 5, _03DB
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_7, 0
    GoTo _03F6
_0529:
    CompareVar VAR_0x8005, 464
    GoToIf 5, _0544
    ApplyMovement obj_D36R0101_monstarball_4, _05F2
    GoTo _04D6
_0544:
    CompareVar VAR_0x8005, 465
    GoToIf 5, _055F
    ApplyMovement obj_D36R0101_monstarball_4, _05F8
    GoTo _04D6
_055F:
    ApplyMovement obj_D36R0101_monstarball_4, _0606
    WaitMovement
    RemoveObject obj_D36R0101_monstarball_4
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
_0575:
    Message msg_0564_T23_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0580:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0586:
    WalkNormalWest 9
    FaceNorth
    EndMovement
    .balign 4, 0
_0590:
    FaceEast
    Delay4 6
    Delay8 7
    FaceSouth
    EndMovement
    .balign 4, 0
_05A2:
    WalkOnSpotNormalWest 2
    EndMovement
    .balign 4, 0
_05A8:
    LockDir
    WalkFasterWest
    Delay8 2
    WalkSlowWest 2
    UnlockDir
    WalkFastWest 9
    EndMovement
    .balign 4, 0
_05C2:
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05CC:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05D6:
    WalkNormalWest 9
    FaceSouth
    EndMovement
    .balign 4, 0
_05E0:
    FaceEast
    Delay4 6
    Delay8 7
    FaceNorth
    EndMovement
    .balign 4, 0
_05F2:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_05F8:
    WalkNormalWest
    WalkNormalNorth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0606:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
