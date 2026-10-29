#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0394.h"


    ScriptEntry scr_seq_R38_000
    ScriptEntry scr_seq_R38_001
    ScriptEntry scr_seq_R38_002
    ScriptEntry scr_seq_R38_003
    ScriptEntry scr_seq_R38_004
    ScriptEntryEnd
scr_seq_R38_000:
    End
scr_seq_R38_001:
    DrawSignpostInstantMessage msg_0394_R38_00015, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R38_002:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0394_R38_00016, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R38_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ELECTABUZZ, 0
    WaitCry
    CompleteStartWildBattle SPECIES_ELECTABUZZ, 33, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00B0
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 8
    SetFlag FLAG_HGSS_SG_3FEA
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_R38_004:
    LockAll
    RemoveObject 9
    SetFlag FLAG_HGSS_SG_3FD3
    SetVar VAR_0x8004, ITEM_TM24
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_00B0:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
