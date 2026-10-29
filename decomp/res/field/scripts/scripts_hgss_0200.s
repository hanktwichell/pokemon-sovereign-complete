#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0349.h"


    ScriptEntry scr_seq_R12R0101_000
    ScriptEntryEnd
scr_seq_R12R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_SUPER_ROD, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _004C
    Message msg_0349_R12R0101_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0057
    Message msg_0349_R12R0101_00001
    SetVar VAR_0x8004, ITEM_SUPER_ROD
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
_004C:
    Message msg_0349_R12R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0057:
    Message msg_0349_R12R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
