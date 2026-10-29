#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0057.h"

#define obj_D17R0101_bozu 0

    ScriptEntry scr_seq_D17R0101_000
    ScriptEntry scr_seq_D17R0101_001
    ScriptEntry scr_seq_D17R0101_002
    ScriptEntry scr_seq_D17R0101_003
    ScriptEntryEnd
scr_seq_D17R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_CAUGHT_HO_OH, _00A0
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 8
    GoToIf 1, _00AB
    GoToIfSet FLAG_HGSS_UNK_108, _00B6
    GoToIfSet FLAG_HGSS_UNK_105, _00C1
    Message msg_0057_D17R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D17R0101_001:
    LockAll
    GetPlayerDir VAR_MAP_LOCAL_0x0A
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _00CC
    ApplyMovement obj_D17R0101_bozu, _03A2
    GoTo _0126
scr_seq_D17R0101_002:
    WaitTime 30, VAR_RESULT
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _0178
    ApplyMovement obj_D17R0101_bozu, _03A8
    GoTo _018B
scr_seq_D17R0101_003:
    BufferPlayerName 0
    End
_00A0:
    Message msg_0057_D17R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00AB:
    Message msg_0057_D17R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B6:
    Message msg_0057_D17R0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00C1:
    Message msg_0057_D17R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00CC:
    ApplyMovement obj_D17R0101_bozu, _03B6
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    CallIf 1, _0196
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    CallIf 1, _01B1
    GoToIfSet FLAG_HGSS_UNK_093, _01CC
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _01DF
    ApplyMovement LOCALID_PLAYER, _03C0
    GoTo _0215
_0126:
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    CallIf 1, _0196
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    CallIf 1, _01B1
    GoToIfSet FLAG_HGSS_UNK_093, _01CC
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _01DF
    ApplyMovement LOCALID_PLAYER, _03C0
    GoTo _0215
_0178:
    ApplyMovement obj_D17R0101_bozu, _03CE
    WaitMovement
    Message msg_0057_D17R0101_00003
    WaitButton
    CloseMessage
    End
_018B:
    WaitMovement
    Message msg_0057_D17R0101_00003
    WaitButton
    CloseMessage
    End
_0196:
    CompareVar VAR_0x8004, 7
    GoToIf 5, _023B
    ApplyMovement obj_D17R0101_bozu, _03DC
    GoTo _0256
_01B1:
    CompareVar VAR_0x8005, 7
    GoToIf 5, _025A
    ApplyMovement obj_D17R0101_bozu, _03EA
    GoTo _0275
_01CC:
    Message msg_0057_D17R0101_00002
    CloseMessage
    @ HGSS: ShowLegendaryWing 0
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40F3, 1
    End
_01DF:
    ApplyMovement obj_D17R0101_bozu, _03F8
    ApplyMovement LOCALID_PLAYER, _03F8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0279
    Message msg_0057_D17R0101_00000
    GoTo _02A2
_0215:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0279
    Message msg_0057_D17R0101_00000
    GoTo _02A2
_023B:
    CompareVar VAR_0x8004, 8
    GoToIf 5, _02C8
    ApplyMovement obj_D17R0101_bozu, _0406
    GoTo _0256
_0256:
    WaitMovement
    Return
_025A:
    CompareVar VAR_0x8005, 8
    GoToIf 5, _02D4
    ApplyMovement obj_D17R0101_bozu, _040C
    GoTo _0275
_0275:
    WaitMovement
    Return
_0279:
    Message msg_0057_D17R0101_00001
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    CallIf 1, _02EF
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    CallIf 1, _030A
    ReleaseAll
    End
_02A2:
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    CallIf 1, _02EF
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    CallIf 1, _030A
    ReleaseAll
    End
_02C8:
    ApplyMovement obj_D17R0101_bozu, _0412
    WaitMovement
    Return
_02D4:
    CompareVar VAR_0x8005, 9
    GoToIf 5, _0325
    ApplyMovement obj_D17R0101_bozu, _0420
    GoTo _0275
_02EF:
    CompareVar VAR_0x8004, 7
    GoToIf 5, _0331
    ApplyMovement obj_D17R0101_bozu, _042A
    GoTo _034C
_030A:
    CompareVar VAR_0x8005, 7
    GoToIf 5, _0350
    ApplyMovement obj_D17R0101_bozu, _043C
    GoTo _036B
_0325:
    ApplyMovement obj_D17R0101_bozu, _0446
    WaitMovement
    Return
_0331:
    CompareVar VAR_0x8004, 8
    GoToIf 5, _036F
    ApplyMovement obj_D17R0101_bozu, _0450
    GoTo _034C
_034C:
    WaitMovement
    Return
_0350:
    CompareVar VAR_0x8005, 8
    GoToIf 5, _037B
    ApplyMovement obj_D17R0101_bozu, _045A
    GoTo _036B
_036B:
    WaitMovement
    Return
_036F:
    ApplyMovement obj_D17R0101_bozu, _0464
    WaitMovement
    Return
_037B:
    CompareVar VAR_0x8005, 9
    GoToIf 5, _0396
    ApplyMovement obj_D17R0101_bozu, _0476
    GoTo _036B
_0396:
    ApplyMovement obj_D17R0101_bozu, _0484
    WaitMovement
    Return
    .balign 4, 0
_03A2:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03A8:
    LockDir
    WalkSlowerNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_03B6:
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03C0:
    LockDir
    WalkNormalSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_03CE:
    LockDir
    WalkSlowerWest
    UnlockDir
    EndMovement
    .balign 4, 0
_03DC:
    WalkNormalSouth 2
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_03EA:
    WalkNormalNorth
    WalkNormalEast 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_03F8:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_0406:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_040C:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0412:
    WalkNormalSouth 2
    WalkNormalEast
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0420:
    WalkNormalSouth
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_042A:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_043C:
    WalkNormalWest 4
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0446:
    WalkNormalSouth 2
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0450:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_045A:
    WalkNormalWest 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0464:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0476:
    WalkNormalWest 4
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0484:
    WalkNormalWest 4
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
