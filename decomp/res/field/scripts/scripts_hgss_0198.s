#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0347.h"


    ScriptEntry scr_seq_R11R0101_000
    ScriptEntry scr_seq_R11R0101_001
    ScriptEntryEnd
scr_seq_R11R0101_000:
    SetVarFromValue VAR_HGSS_UNK_4085, 0
    End
scr_seq_R11R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SNORLAX_MEET, _0030
    Message msg_0347_R11R0101_00000
_0028:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0030:
    Message msg_0347_R11R0101_00001
    GoTo _0028
    .balign 4, 0
