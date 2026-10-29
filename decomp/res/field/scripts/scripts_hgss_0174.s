#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0325.h"

#define obj_R02R0501_counterm 0

    ScriptEntry scr_seq_R02R0501_000
    ScriptEntry scr_seq_R02R0501_001
    ScriptEntryEnd
scr_seq_R02R0501_000:
    NPCMessage msg_0325_R02R0501_00000
    End
scr_seq_R02R0501_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement obj_R02R0501_counterm, _007C
    WaitMovement
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _006B
    Message msg_0325_R02R0501_00001
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0082
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_006B:
    Message msg_0325_R02R0501_00002
    SetVarFromValue VAR_HGSS_SG_6134, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_007C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0082:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
