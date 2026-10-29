#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0456.h"


    ScriptEntry scr_seq_T02R0201_000
    ScriptEntry scr_seq_T02R0201_001
    ScriptEntry scr_seq_T02R0201_002
    ScriptEntry scr_seq_T02R0201_003
    ScriptEntryEnd
scr_seq_T02R0201_000:
    NPCMessage msg_0456_T02R0201_00000
    End
scr_seq_T02R0201_001:
    NPCMessage msg_0456_T02R0201_00001
    End
scr_seq_T02R0201_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SPEAROW, 0
    Message msg_0456_T02R0201_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T02R0201_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_RATTATA, 0
    Message msg_0456_T02R0201_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
