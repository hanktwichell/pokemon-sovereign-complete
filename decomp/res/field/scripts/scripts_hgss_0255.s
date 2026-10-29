#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0402.h"


    ScriptEntry scr_seq_R43R0101_000
    ScriptEntryEnd
scr_seq_R43R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_ROCKET_HIDEOUT_CLEARED, _0024
    Message msg_0402_R43R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0024:
    Message msg_0402_R43R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
