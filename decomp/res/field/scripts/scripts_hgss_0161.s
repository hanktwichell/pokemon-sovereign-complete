#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0262.h"

#define obj_P01R0306_gsgentleman 0
#define obj_P01R0306_gsbabygirl1_3 4

    ScriptEntry scr_seq_P01R0306_000
    ScriptEntry scr_seq_P01R0306_001
    ScriptEntry scr_seq_P01R0306_002
    ScriptEntry scr_seq_P01R0306_003
    ScriptEntryEnd
scr_seq_P01R0306_001:
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 7
    GoToIf 4, _003C
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 4
    GoToIf 2, _0036
    SetFlag FLAG_HGSS_UNK_218
    GoTo _003A
_0036:
    ClearFlag FLAG_HGSS_UNK_218
_003A:
    End
_003C:
    SetFlag FLAG_HGSS_UNK_216
    SetFlag FLAG_HGSS_UNK_218
    End
scr_seq_P01R0306_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 3
    GoToIf 2, _006E
    ApplyMovement obj_P01R0306_gsgentleman, _0090
    WaitMovement
    Message msg_0262_P01R0306_00001
    GoTo _0087
_006E:
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 4
    GoToIf 5, _0084
    Message msg_0262_P01R0306_00000
    GoTo _0087
_0084:
    Message msg_0262_P01R0306_00007
_0087:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0090:
    JumpOnSpotFastSouth 2
    EndMovement
scr_seq_P01R0306_003:
    LockAll
    ApplyMovement obj_P01R0306_gsbabygirl1_3, _0110
    WaitMovement
    MessageGendered msg_0262_P01R0306_00002, msg_0262_P01R0306_00003
    CloseMessage
    ApplyMovement obj_P01R0306_gsgentleman, _0118
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0262_P01R0306_00004, msg_0262_P01R0306_00005
    SetVar VAR_0x8004, ITEM_METAL_COAT
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0103
    Common_GiveItemQuantity
_00E2:
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 6
    SetFlag FLAG_HGSS_UNK_22A
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    SetFlag FLAG_HGSS_BOAT_ARRIVED
    Message msg_0262_P01R0306_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0103:
    Common_MessageBagIsFull
    CloseMessage
    GoTo _00E2
    .balign 4, 0
_0110:
    JumpOnSpotFastEast 3
    EndMovement
    .balign 4, 0
_0118:
    WalkSlowSouth
    EndMovement
scr_seq_P01R0306_002:
    NPCMessage msg_0262_P01R0306_00008
    End
    .balign 4, 0
