#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0263.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_P01R0307_gsbabygirl1 0
#define obj_P01R0307_seaman_2 1

    ScriptEntry scr_seq_P01R0307_000
    ScriptEntry scr_seq_P01R0307_001
    ScriptEntry scr_seq_P01R0307_002
    ScriptEntry scr_seq_P01R0307_003
    ScriptEntryEnd
scr_seq_P01R0307_002:
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 4
    GoToIf 5, _0029
    ClearFlag FLAG_HGSS_UNK_219
    GoTo _002D
_0029:
    SetFlag FLAG_HGSS_UNK_219
_002D:
    End
scr_seq_P01R0307_001:
    LockAll
    SetFlag FLAG_HGSS_UNK_0ED
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 19
    GoToIf 1, _0088
    ApplyMovement obj_P01R0307_seaman_2, _00C4
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _006B
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0114
_006B:
    ApplyMovement LOCALID_PLAYER, _0104
    WaitMovement
    Message msg_0263_P01R0307_00000
    CloseMessage
    ApplyMovement obj_P01R0307_seaman_2, _00D4
    WaitMovement
    ReleaseAll
    End
_0088:
    ApplyMovement obj_P01R0307_seaman_2, _00E4
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _00A5
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0114
_00A5:
    ApplyMovement LOCALID_PLAYER, _0104
    WaitMovement
    Message msg_0263_P01R0307_00000
    CloseMessage
    ApplyMovement obj_P01R0307_seaman_2, _00F4
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_00C4:
    FaceNorth 2
    WalkNormalNorth
    FaceWest 2
    EndMovement
    .balign 4, 0
_00D4:
    FaceSouth 2
    WalkNormalSouth
    FaceWest 2
    EndMovement
    .balign 4, 0
_00E4:
    FaceSouth 2
    WalkNormalSouth
    FaceWest 2
    EndMovement
    .balign 4, 0
_00F4:
    FaceNorth 2
    WalkNormalNorth
    FaceWest 2
    EndMovement
    .balign 4, 0
_0104:
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
    .balign 4, 0
_0114:
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
scr_seq_P01R0307_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 3
    GoToIf 4, _0148
    Message msg_0263_P01R0307_00001
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_0ED
    ReleaseAll
    End
_0148:
    Message msg_0263_P01R0307_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_P01R0307_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement obj_P01R0307_gsbabygirl1, _020C
    WaitMovement
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0180
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
_0180:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01A7
    ApplyMovement LOCALID_PLAYER, _0218
    ApplyMovement obj_P01R0307_gsbabygirl1, _0238
    GoTo _01B7
_01A7:
    ApplyMovement LOCALID_PLAYER, _0228
    ApplyMovement obj_P01R0307_gsbabygirl1, _0244
_01B7:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _01D0
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
_01D0:
    Message msg_0263_P01R0307_00006
    CloseMessage
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 5
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SS_AQUA_1F_NORTHWEST_ROOMS, 9, 10, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_020C:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0218:
    LockDir
    WalkSlowNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_0228:
    LockDir
    WalkSlowEast 2
    UnlockDir
    EndMovement
    .balign 4, 0
_0238:
    FaceNorth 2
    WalkSlowNorth
    EndMovement
    .balign 4, 0
_0244:
    FaceEast 2
    WalkSlowEast 2
    EndMovement
    .balign 4, 0
