#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0472.h"


    ScriptEntry scr_seq_T04R0201_000
    ScriptEntry scr_seq_T04R0201_001
    ScriptEntry scr_seq_T04R0201_002
    ScriptEntryEnd
scr_seq_T04R0201_000:
    NPCMessage msg_0472_T04R0201_00000
    End
scr_seq_T04R0201_001:
    NPCMessage msg_0472_T04R0201_00001
    End
scr_seq_T04R0201_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_DIGLETT, 0
    Message msg_0472_T04R0201_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
