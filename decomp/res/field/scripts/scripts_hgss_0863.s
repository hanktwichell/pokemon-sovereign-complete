#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0561.h"


    ScriptEntry scr_seq_T22R0401_000
    ScriptEntry scr_seq_T22R0401_001
    ScriptEntry scr_seq_T22R0401_002
    ScriptEntry scr_seq_T22R0401_003
    ScriptEntryEnd
scr_seq_T22R0401_000:
    End
scr_seq_T22R0401_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_PIDGEY, 0
    Message msg_0561_T22R0401_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T22R0401_001:
    NPCMessage msg_0561_T22R0401_00000
    End
scr_seq_T22R0401_002:
    NPCMessage msg_0561_T22R0401_00001
    End
    .balign 4, 0
