#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0057.h"

#define obj_D17R0101_bozu 0

    ScriptEntry scr_seq_D17R0101_000
    ScriptEntry scr_seq_D17R0101_001
    ScriptEntry scr_seq_D17R0101_002
    ScriptEntryEnd
scr_seq_D17R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_CAUGHT_HO_OH, _0053
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 8
    GoToIf 1, _0048
    GoToIfSet FLAG_HGSS_UNK_108, _005E
    GoToIfSet FLAG_HGSS_UNK_105, _0069
_0048:
    Message msg_0057_D17R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0053:
    Message msg_0057_D17R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_005E:
    Message msg_0057_D17R0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0069:
    Message msg_0057_D17R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D17R0101_001:
    LockAll
    GetPlayerDir VAR_MAP_LOCAL_0x0A
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _0097
    ApplyMovement obj_D17R0101_bozu, _02D8
    GoTo _009F
_0097:
    ApplyMovement obj_D17R0101_bozu, _02E0
_009F:
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    CallIf 1, _0150
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    CallIf 1, _0192
    GoToIfSet FLAG_HGSS_UNK_093, _028E
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _00F1
    ApplyMovement LOCALID_PLAYER, _0344
    GoTo _0101
_00F1:
    ApplyMovement obj_D17R0101_bozu, _0354
    ApplyMovement LOCALID_PLAYER, _0354
_0101:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0127
    Message msg_0057_D17R0101_00000
    GoTo _012A
_0127:
    Message msg_0057_D17R0101_00001
_012A:
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    CallIf 1, _01EF
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    CallIf 1, _0231
    ReleaseAll
    End
_0150:
    CompareVar VAR_0x8004, 7
    GoToIf 5, _016B
    ApplyMovement obj_D17R0101_bozu, _02EC
    GoTo _018E
_016B:
    CompareVar VAR_0x8004, 8
    GoToIf 5, _0186
    ApplyMovement obj_D17R0101_bozu, _02FC
    GoTo _018E
_0186:
    ApplyMovement obj_D17R0101_bozu, _0304
_018E:
    WaitMovement
    Return
_0192:
    CompareVar VAR_0x8005, 7
    GoToIf 5, _01AD
    ApplyMovement obj_D17R0101_bozu, _0314
    GoTo _01EB
_01AD:
    CompareVar VAR_0x8005, 8
    GoToIf 5, _01C8
    ApplyMovement obj_D17R0101_bozu, _0324
    GoTo _01EB
_01C8:
    CompareVar VAR_0x8005, 9
    GoToIf 5, _01E3
    ApplyMovement obj_D17R0101_bozu, _032C
    GoTo _01EB
_01E3:
    ApplyMovement obj_D17R0101_bozu, _0338
_01EB:
    WaitMovement
    Return
_01EF:
    CompareVar VAR_0x8004, 7
    GoToIf 5, _020A
    ApplyMovement obj_D17R0101_bozu, _0364
    GoTo _022D
_020A:
    CompareVar VAR_0x8004, 8
    GoToIf 5, _0225
    ApplyMovement obj_D17R0101_bozu, _0378
    GoTo _022D
_0225:
    ApplyMovement obj_D17R0101_bozu, _0384
_022D:
    WaitMovement
    Return
_0231:
    CompareVar VAR_0x8005, 7
    GoToIf 5, _024C
    ApplyMovement obj_D17R0101_bozu, _0398
    GoTo _028A
_024C:
    CompareVar VAR_0x8005, 8
    GoToIf 5, _0267
    ApplyMovement obj_D17R0101_bozu, _03A4
    GoTo _028A
_0267:
    CompareVar VAR_0x8005, 9
    GoToIf 5, _0282
    ApplyMovement obj_D17R0101_bozu, _03B0
    GoTo _028A
_0282:
    ApplyMovement obj_D17R0101_bozu, _03C0
_028A:
    WaitMovement
    Return
_028E:
    Message msg_0057_D17R0101_00002
    CloseMessage
    @ HGSS: ShowLegendaryWing 0
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40F3, 1
    End
scr_seq_D17R0101_002:
    WaitTime 30, VAR_RESULT
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _02C2
    ApplyMovement obj_D17R0101_bozu, _03D0
    GoTo _02CA
_02C2:
    ApplyMovement obj_D17R0101_bozu, _03E0
_02CA:
    WaitMovement
    Message msg_0057_D17R0101_00003
    WaitButton
    CloseMessage
    End
    .balign 4, 0
_02D8:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_02E0:
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_02EC:
    WalkNormalSouth 2
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_02FC:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0304:
    WalkNormalSouth 2
    WalkNormalEast
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0314:
    WalkNormalNorth
    WalkNormalEast 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0324:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_032C:
    WalkNormalSouth
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0338:
    WalkNormalSouth 2
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0344:
    LockDir
    WalkNormalSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_0354:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_0364:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0378:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0384:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0398:
    WalkNormalWest 4
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_03A4:
    WalkNormalWest 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03B0:
    WalkNormalWest 4
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03C0:
    WalkNormalWest 4
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03D0:
    LockDir
    WalkSlowerNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_03E0:
    LockDir
    WalkSlowerWest
    UnlockDir
    EndMovement
    .balign 4, 0
