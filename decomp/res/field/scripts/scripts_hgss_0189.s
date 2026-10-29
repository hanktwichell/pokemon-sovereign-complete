#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0339.h"

#define obj_R08R0201_counterm 0

    ScriptEntry scr_seq_R08R0201_000
    ScriptEntry scr_seq_R08R0201_001
    ScriptEntryEnd
scr_seq_R08R0201_000:
    NPCMessage msg_0339_R08R0201_00000
    End
scr_seq_R08R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement obj_R08R0201_counterm, _0058
    WaitMovement
    Message msg_0339_R08R0201_00001
    WaitButton
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _005E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
    .balign 4, 0
_0058:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_005E:
    WalkNormalEast
    EndMovement
    .balign 4, 0
