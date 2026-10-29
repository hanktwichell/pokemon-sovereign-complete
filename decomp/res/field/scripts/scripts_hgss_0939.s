#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0627.h"

#define obj_T29R0101_gsbigman 0

    ScriptEntry scr_seq_T29R0101_000
    ScriptEntryEnd
scr_seq_T29R0101_000:
    GoToIfSet FLAG_HGSS_GOT_TM10_FROM_LAKE_OF_RAGE_MAN, _005A
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0627_T29R0101_00000
    SetVar VAR_0x8004, ITEM_TM10
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _006B
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM10_FROM_LAKE_OF_RAGE_MAN
    Message msg_0627_T29R0101_00002
    WaitButton
    CloseMessage
    ApplyMovement obj_T29R0101_gsbigman, _0078
    WaitMovement
    ReleaseAll
    End
_005A:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0627_T29R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_006B:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0078:
    FaceEast
    EndMovement
    .balign 4, 0
