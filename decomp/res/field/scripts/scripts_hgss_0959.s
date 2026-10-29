#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0741.h"


    ScriptEntry scr_seq_W19R0101_000
    ScriptEntryEnd
scr_seq_W19R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _002C
    Message msg_0741_W19R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_002C:
    Message msg_0741_W19R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
