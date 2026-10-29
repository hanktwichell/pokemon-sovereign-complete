#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0501.h"


    ScriptEntry scr_seq_T07R0201_000
    ScriptEntry scr_seq_T07R0201_001
    ScriptEntry scr_seq_T07R0201_002
    ScriptEntry scr_seq_T07R0201_003
    ScriptEntry scr_seq_T07R0201_004
    ScriptEntry scr_seq_T07R0201_005
    ScriptEntryEnd
scr_seq_T07R0201_005:
    SetVarFromValue VAR_HGSS_UNK_4125, 0
    End
scr_seq_T07R0201_000:
    NPCMessage msg_0501_T07R0201_00000
    End
scr_seq_T07R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MEOWTH, 0
    Message msg_0501_T07R0201_00001
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0201_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_CLEFAIRY, 0
    Message msg_0501_T07R0201_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0201_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_NIDORAN_F, 0
    Message msg_0501_T07R0201_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0201_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0501_T07R0201_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
