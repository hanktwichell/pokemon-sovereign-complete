#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0335.h"


    ScriptEntry scr_seq_R06R0201_000
    ScriptEntryEnd
scr_seq_R06R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0024
    Message msg_0335_R06R0201_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0024:
    Message msg_0335_R06R0201_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
