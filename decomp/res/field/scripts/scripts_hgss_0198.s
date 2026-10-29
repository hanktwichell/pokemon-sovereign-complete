#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0347.h"


    ScriptEntry scr_seq_R11R0101_000
    ScriptEntry scr_seq_R11R0101_001
    ScriptEntryEnd
scr_seq_R11R0101_000:
    SetVarFromValue VAR_HGSS_UNK_4085, 0
    End
scr_seq_R11R0101_001:
    NPCMessage msg_0347_R11R0101_00001
    End
    Message msg_0347_R11R0101_00001
    GoTo _002E
_002E:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
