#include "macros/scrcmd.inc"


    ScriptEntry scr_seq_D32R0103_000
    ScriptEntry scr_seq_D32R0103_001
    ScriptEntry scr_seq_D32R0103_002
    ScriptEntry scr_seq_D32R0103_003
    ScriptEntryEnd
scr_seq_D32R0103_003:
    SetVarFromValue VAR_HGSS_UNK_40E5, 2
    End
scr_seq_D32R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CallCommonScript 11040
    ReleaseAll
    End
scr_seq_D32R0103_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CallCommonScript 11041
    ReleaseAll
    End
scr_seq_D32R0103_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CallCommonScript 11042
    ReleaseAll
    End
    .balign 4, 0
