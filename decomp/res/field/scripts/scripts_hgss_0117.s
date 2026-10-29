#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0134.h"


    ScriptEntry scr_seq_D47PC0101_000
    ScriptEntry scr_seq_D47PC0101_001
    ScriptEntry scr_seq_D47PC0101_002
    ScriptEntryEnd
scr_seq_D47PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_D47PC0101_001:
    NPCMessage msg_0134_D47PC0101_00000
    End
scr_seq_D47PC0101_002:
    NPCMessage msg_0134_D47PC0101_00001
    End
    .balign 4, 0
