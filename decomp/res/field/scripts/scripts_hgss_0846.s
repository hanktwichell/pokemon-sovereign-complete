#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0546.h"


    ScriptEntry scr_seq_T20R0202_000
    ScriptEntry scr_seq_T20R0202_001
    ScriptEntryEnd
scr_seq_T20R0202_000:
    LockAll
    PlaySE SEQ_SE_DP_PC_ON_sseq
    BufferPlayerName 0
    Message msg_0546_T20R0202_00000
    CloseMessage
    @ HGSS: ScrCmd_377 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _004B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_376
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_004B:
    Message msg_0546_T20R0202_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0202_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0546_T20R0202_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
