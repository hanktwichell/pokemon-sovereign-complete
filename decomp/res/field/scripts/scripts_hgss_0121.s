#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0136.h"

#define obj_D48R0101_middlewoman1_2 2
#define obj_D48R0101_gsleader5 3

    ScriptEntry scr_seq_D48R0101_000
    ScriptEntry scr_seq_D48R0101_001
    ScriptEntry scr_seq_D48R0101_002
    ScriptEntry scr_seq_D48R0101_003
    ScriptEntry scr_seq_D48R0101_004
    ScriptEntry scr_seq_D48R0101_005
    ScriptEntry scr_seq_D48R0101_006
    ScriptEntry scr_seq_D48R0101_007
    ScriptEntry scr_seq_D48R0101_008
    ScriptEntry scr_seq_D48R0101_009
    ScriptEntry scr_seq_D48R0101_010
    ScriptEntry scr_seq_D48R0101_011
    ScriptEntry scr_seq_D48R0101_012
    ScriptEntry scr_seq_D48R0101_013
    ScriptEntry scr_seq_D48R0101_014
    ScriptEntryEnd
scr_seq_D48R0101_005:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    GoToIf 1, _0286
    SetFlag FLAG_HGSS_HIDE_CLIFFS_EDGE_GATE_CHUCK
    End
scr_seq_D48R0101_006:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    GoToIf 1, _028C
    End
scr_seq_D48R0101_004:
    LockAll
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _02AB
    ApplyMovement obj_D48R0101_gsleader5, _043C
    GoTo _02D8
scr_seq_D48R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_SG_3FE8, _02FD
    CompareVar VAR_HGSS_UNK_40EB, 1
    GoToIf 1, _0310
    GoToIfSet FLAG_HGSS_UNK_0F5, _031B
    Message msg_0136_D48R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D48R0101_001:
    NPCMessage msg_0136_D48R0101_00005
    End
scr_seq_D48R0101_002:
    NPCMessage msg_0136_D48R0101_00006
    End
scr_seq_D48R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0F5, _033E
    Message msg_0136_D48R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D48R0101_007:
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement 4, _0452
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0458
    Message msg_0136_D48R0101_00012
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_BEAUTY_MICKEY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0349
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    Message msg_0136_D48R0101_00013
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_61A4, 2
    ReleaseAll
    End
scr_seq_D48R0101_008:
    NPCMessage msg_0136_D48R0101_00013
    End
scr_seq_D48R0101_009:
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement 5, _0452
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _045E
    Message msg_0136_D48R0101_00015
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_BEAUTY_MICKEY_3, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0349
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    Message msg_0136_D48R0101_00016
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_61A3, 2
    ReleaseAll
    End
scr_seq_D48R0101_010:
    NPCMessage msg_0136_D48R0101_00016
    End
scr_seq_D48R0101_011:
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement 6, _0452
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _045E
    Message msg_0136_D48R0101_00017
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_TEAM_ROCKET_MICKEY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0349
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    Message msg_0136_D48R0101_00018
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_61A2, 2
    ReleaseAll
    End
scr_seq_D48R0101_012:
    NPCMessage msg_0136_D48R0101_00018
    End
scr_seq_D48R0101_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0136_D48R0101_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D48R0101_014:
    LockAll
    BufferPlayerName 0
    ApplyMovement obj_D48R0101_middlewoman1_2, _0452
    WaitMovement
    Message msg_0136_D48R0101_00020
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _04C8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_0286:
    ClearFlag FLAG_HGSS_HIDE_CLIFFS_EDGE_GATE_CHUCK
    End
_028C:
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 1, _034F
    SetPosition obj_D48R0101_gsleader5, 19, 0, 40, DIR_SOUTH
    End
_02AB:
    ApplyMovement obj_D48R0101_gsleader5, _0464
    WaitMovement
    BufferPlayerName 0
    Message msg_0136_D48R0101_00007
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _0351
    ApplyMovement obj_D48R0101_gsleader5, _047A
    GoTo _037B
_02D8:
    WaitMovement
    BufferPlayerName 0
    Message msg_0136_D48R0101_00007
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _0351
    ApplyMovement obj_D48R0101_gsleader5, _047A
    GoTo _037B
_02FD:
    NPCMessage msg_0136_D48R0101_00014
    End
_0310:
    Message msg_0136_D48R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_031B:
    Message msg_0136_D48R0101_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _039D
    Message msg_0136_D48R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_033E:
    Message msg_0136_D48R0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0349:
    BlackOutFromBattle
    ReleaseAll
    End
_034F:
    End
_0351:
    ApplyMovement obj_D48R0101_gsleader5, _0484
    WaitMovement
    Message msg_0136_D48R0101_00008
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _03A8
    ApplyMovement obj_D48R0101_gsleader5, _048E
    GoTo _03DA
_037B:
    WaitMovement
    Message msg_0136_D48R0101_00008
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _03A8
    ApplyMovement obj_D48R0101_gsleader5, _048E
    GoTo _03DA
_039D:
    Message msg_0136_D48R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03A8:
    ApplyMovement obj_D48R0101_gsleader5, _0494
    WaitMovement
    Message msg_0136_D48R0101_00009
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _0404
    ApplyMovement LOCALID_PLAYER, _049A
    ApplyMovement obj_D48R0101_gsleader5, _04AC
    GoTo _0424
_03DA:
    WaitMovement
    Message msg_0136_D48R0101_00009
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _0404
    ApplyMovement LOCALID_PLAYER, _049A
    ApplyMovement obj_D48R0101_gsleader5, _04AC
    GoTo _0424
_0404:
    ApplyMovement obj_D48R0101_gsleader5, _04B6
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_CLIFFS_EDGE_GATE_CHUCK
    RemoveObject obj_D48R0101_gsleader5
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 3
    ReleaseAll
    End
_0424:
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_CLIFFS_EDGE_GATE_CHUCK
    RemoveObject obj_D48R0101_gsleader5
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 3
    ReleaseAll
    End
    .balign 4, 0
_043C:
    WalkOnSpotNormalEast
    Delay8
    WalkNormalEast 2
    WalkNormalSouth
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0452:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0458:
    FaceNorth
    EndMovement
    .balign 4, 0
_045E:
    FaceEast
    EndMovement
    .balign 4, 0
_0464:
    WalkOnSpotNormalSouth
    Delay8
    WalkNormalSouth 3
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_047A:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0484:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_048E:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0494:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_049A:
    LockDir
    WalkNormalNorth
    UnlockDir
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04AC:
    Delay8
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_04B6:
    Delay8
    WalkNormalNorth 4
    WalkNormalEast 2
    WalkNormalNorth 9
    EndMovement
    .balign 4, 0
_04C8:
    WalkNormalEast
    EndMovement
    .balign 4, 0
