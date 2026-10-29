#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0063.h"


    ScriptEntry scr_seq_D22R0102_000
    ScriptEntry scr_seq_D22R0102_001
    ScriptEntry scr_seq_D22R0102_002
    ScriptEntry scr_seq_D22R0102_003
    ScriptEntry scr_seq_D22R0102_004
    ScriptEntry scr_seq_D22R0102_005
    ScriptEntry scr_seq_D22R0102_006
    ScriptEntry scr_seq_D22R0102_007
    ScriptEntry scr_seq_D22R0102_008
    ScriptEntry scr_seq_D22R0102_009
    ScriptEntry scr_seq_D22R0102_010
    ScriptEntry scr_seq_D22R0102_011
    ScriptEntry scr_seq_D22R0102_012
    ScriptEntry scr_seq_D22R0102_013
    ScriptEntryEnd
scr_seq_D22R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0102_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0063_D22R0102_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D22R0102_001:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0063_D22R0102_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D22R0102_002:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0063_D22R0102_00002, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D22R0102_013:
    GoToIfSet FLAG_HGSS_SG_3F96, _0151
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0063_D22R0102_00033
    SetVar VAR_0x8004, ITEM_INSECT_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    SetFlag FLAG_HGSS_SG_3F96
    ReleaseAll
    End
_0151:
    End
    .balign 4, 0
