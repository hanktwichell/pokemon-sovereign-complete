#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0563.h"


    ScriptEntry scr_seq_T22R0701_000
    ScriptEntry scr_seq_T22R0701_001
    ScriptEntryEnd
scr_seq_T22R0701_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_HIDE_ROUTE_36_SUDOWOODO, _0026
    Message msg_0563_T22R0701_00000
    GoTo _0029
_0026:
    Message msg_0563_T22R0701_00001
_0029:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T22R0701_001:
    NPCMessage msg_0563_T22R0701_00002
    End
    .balign 4, 0
