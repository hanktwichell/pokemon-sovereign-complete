#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0633.h"


    ScriptEntry scr_seq_T30R0201_000
    ScriptEntry scr_seq_T30R0201_001
    ScriptEntryEnd
scr_seq_T30R0201_000:
    NPCMessage msg_0633_T30R0201_00000
    End
scr_seq_T30R0201_001:
    PlayCry SPECIES_DRATINI, 0
    NPCMessage msg_0633_T30R0201_00002
    WaitCry
    End
    .balign 4, 0
