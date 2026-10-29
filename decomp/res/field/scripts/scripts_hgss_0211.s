#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0359.h"


    ScriptEntry scr_seq_R18R0101_000
    ScriptEntry scr_seq_R18R0101_001
    ScriptEntry scr_seq_R18R0101_002
    ScriptEntry scr_seq_R18R0101_003
    ScriptEntryEnd
scr_seq_R18R0101_001:
    GoToIfSet FLAG_HGSS_UNK_149, _001F
    End
_001F:
    @ HGSS: SetBikeStateLock 1
    End
scr_seq_R18R0101_002:
    LockAll
    @ HGSS: PlayerOnBikeCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _006A
    ApplyMovement LOCALID_PLAYER, _0084
    WaitMovement
    Message msg_0359_R18R0101_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _008C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_006A:
    @ HGSS: SetBikeStateLock 1
    SetVarFromValue VAR_HGSS_UNK_4129, 1
    SetVarFromValue VAR_HGSS_UNK_412A, 1
    SetFlag FLAG_HGSS_UNK_149
    ReleaseAll
    End
    .balign 4, 0
_0084:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_008C:
    WalkNormalEast
    EndMovement
scr_seq_R18R0101_003:
    @ HGSS: SetBikeStateLock 0
    SetVarFromValue VAR_HGSS_UNK_4129, 0
    SetVarFromValue VAR_HGSS_UNK_412A, 0
    ClearFlag FLAG_HGSS_UNK_149
    End
scr_seq_R18R0101_000:
    NPCMessage msg_0359_R18R0101_00000
    End
    .balign 4, 0
