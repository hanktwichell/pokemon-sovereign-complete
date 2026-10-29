#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0048.h"


    ScriptEntry scr_seq_D02FS0101_000
    ScriptEntry scr_seq_D02FS0101_001
    ScriptEntryEnd
scr_seq_D02FS0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetFlag FLAG_HGSS_SPECIAL_MART_MT_MOON
    Message msg_0048_D02FS0101_00001
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 27
    @ HGSS: CallStd std_special_mart
    ClearFlag FLAG_HGSS_SPECIAL_MART_MT_MOON
    ReleaseAll
    End
scr_seq_D02FS0101_000:
    NPCMessage msg_0048_D02FS0101_00000
    End
    .balign 4, 0
