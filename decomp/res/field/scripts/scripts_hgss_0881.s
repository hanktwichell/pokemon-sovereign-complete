#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0577.h"

#define obj_T24R0501_sunglasses 0

    ScriptEntry scr_seq_T24R0501_000
    ScriptEntryEnd
scr_seq_T24R0501_000:
    GoToIfSet FLAG_HGSS_GOT_SECRETPOTION, _0024
    CompareVar VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 1
    GoToIf 1, _0051
    GoTo _0024
_0024:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetFlag FLAG_HGSS_SPECIAL_MART_PHARMACY
    Message msg_0577_T24R0501_00003
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 11
    @ HGSS: CallStd std_special_mart
    ApplyMovement obj_T24R0501_sunglasses, _00A8
    WaitMovement
    ClearFlag FLAG_HGSS_SPECIAL_MART_PHARMACY
    ReleaseAll
    End
_0051:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0577_T24R0501_00000
    WaitABPress
    SetVar VAR_0x8004, ITEM_SECRETPOTION
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _009C
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_SECRETPOTION
    Message msg_0577_T24R0501_00002
    WaitABPress
    CloseMessage
    ApplyMovement obj_T24R0501_sunglasses, _00A8
    WaitMovement
    ReleaseAll
    End
_009C:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_00A8:
    FaceNorth
    EndMovement
    .balign 4, 0
