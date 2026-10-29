#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0406.h"


    ScriptEntry scr_seq_R46_000
    ScriptEntry scr_seq_R46_001
    ScriptEntry scr_seq_R46_002
    ScriptEntry scr_seq_R46_003
    ScriptEntryEnd
scr_seq_R46_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAVE_RIVAL_NAME_TO_OFFICER, _00BF
    Message msg_0406_R46_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R46_001:
    DrawSignpostInstantMessage msg_0406_R46_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R46_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0406_R46_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R46_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_GLIGAR, 0
    WaitCry
    CompleteStartWildBattle SPECIES_GLIGAR, 15, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00CA
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 7
    SetFlag FLAG_HGSS_SG_3FFB
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockAll
    Message msg_0406_R46_00004
    SetVar VAR_0x8004, ITEM_TM40
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_00BF:
    Message msg_0406_R46_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00CA:
    BlackOutFromBattle
    ReleaseAll
    End
    WaitSE SEQ_PV001_sseq
    @ HGSS data: .byte 254, 0
    .balign 4, 0
