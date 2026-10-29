#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0478.h"


    ScriptEntry scr_seq_T05R0201_000
    ScriptEntry scr_seq_T05R0201_001
    ScriptEntry scr_seq_T05R0201_002
    ScriptEntry scr_seq_T05R0201_003
    ScriptEntry scr_seq_T05R0201_004
    ScriptEntryEnd
scr_seq_T05R0201_000:
    NPCMessage msg_0478_T05R0201_00000
    End
scr_seq_T05R0201_001:
    NPCMessage msg_0478_T05R0201_00001
    End
scr_seq_T05R0201_002:
    PlayCry SPECIES_PSYDUCK, 0
    NPCMessage msg_0478_T05R0201_00002
    WaitCry
    End
scr_seq_T05R0201_003:
    PlayCry SPECIES_NIDORINO, 0
    NPCMessage msg_0478_T05R0201_00003
    WaitCry
    End
scr_seq_T05R0201_004:
    PlayCry SPECIES_PIDGEY, 0
    NPCMessage msg_0478_T05R0201_00004
    WaitCry
    End
    .balign 4, 0
