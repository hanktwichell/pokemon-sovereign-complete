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
    GoToIf 4, _00DC
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 4
    GoToIf 2, _00E6
    SetFlag FLAG_HGSS_UNK_218
    GoTo _00EC
scr_seq_P01R0306_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 3
    GoToIf 2, _00EE
    ApplyMovement obj_P01R0306_gsgentleman, _0144
    WaitMovement
    Message msg_0262_P01R0306_00001
    GoTo _0104
scr_seq_P01R0306_003:
    LockAll
    ApplyMovement obj_P01R0306_gsbabygirl1_3, _014A
    WaitMovement
    MessageGendered msg_0262_P01R0306_00002, msg_0262_P01R0306_00003
    CloseMessage
    ApplyMovement obj_P01R0306_gsgentleman, _0150
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0262_P01R0306_00004, msg_0262_P01R0306_00005
    SetVar VAR_0x8004, ITEM_METAL_COAT
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _010C
    Common_GiveItemQuantity
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
scr_seq_P01R0306_002:
    NPCMessage msg_0262_P01R0306_00008
    End
_00DC:
    SetFlag FLAG_HGSS_UNK_216
    SetFlag FLAG_HGSS_UNK_218
    End
_00E6:
    ClearFlag FLAG_HGSS_UNK_218
    End
_00EC:
    End
_00EE:
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 4
    GoToIf 5, _0118
    Message msg_0262_P01R0306_00000
    GoTo _0104
_0104:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_010C:
    Common_MessageBagIsFull
    CloseMessage
    GoTo _0123
_0118:
    Message msg_0262_P01R0306_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0123:
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
    .balign 4, 0
_0144:
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_014A:
    JumpOnSpotFastEast 3
    EndMovement
    .balign 4, 0
_0150:
    WalkSlowSouth
    EndMovement
    .balign 4, 0
