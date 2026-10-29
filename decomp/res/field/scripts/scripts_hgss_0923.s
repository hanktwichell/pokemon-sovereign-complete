#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0615.h"

#define obj_T27PC0101_masaki 4

    ScriptEntry scr_seq_T27PC0101_000
    ScriptEntry scr_seq_T27PC0101_001
    ScriptEntry scr_seq_T27PC0101_002
    ScriptEntry scr_seq_T27PC0101_003
    ScriptEntry scr_seq_T27PC0101_004
    ScriptEntryEnd
scr_seq_T27PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T27PC0101_001:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T27PC0101_masaki, _0084
    ApplyMovement LOCALID_PLAYER, _00A0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    Message msg_0615_T27PC0101_00000
    Message msg_0615_T27PC0101_00001
    CloseMessage
    ApplyMovement obj_T27PC0101_masaki, _00AC
    ApplyMovement LOCALID_PLAYER, _00C0
    WaitMovement
    RemoveObject obj_T27PC0101_masaki
    SetFlag FLAG_HGSS_UNK_1C5
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_BILL
    SetFlag FLAG_HGSS_SYS_MET_BILL
    SetVarFromValue VAR_HGSS_UNK_410D, 1
    ReleaseAll
    End
    .balign 4, 0
_0084:
    WalkNormalSouth 4
    WalkNormalEast 6
    WalkNormalNorth 2
    Delay4 12
    FaceSouth
    Delay4 4
    EndMovement
    .balign 4, 0
_00A0:
    Delay4 20
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_00AC:
    WalkNormalEast
    WalkNormalSouth 4
    WalkNormalWest
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_00C0:
    Delay4 6
    FaceSouth
    EndMovement
scr_seq_T27PC0101_002:
    NPCMessage msg_0615_T27PC0101_00002
    End
scr_seq_T27PC0101_003:
    NPCMessage msg_0615_T27PC0101_00003
    End
scr_seq_T27PC0101_004:
    NPCMessage msg_0615_T27PC0101_00004
    End
    .balign 4, 0
