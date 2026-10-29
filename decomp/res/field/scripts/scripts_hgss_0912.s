#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0605.h"


    ScriptEntry scr_seq_T26FS0101_000
    ScriptEntry scr_seq_T26FS0101_001
    ScriptEntry scr_seq_T26FS0101_002
    ScriptEntry scr_seq_T26FS0101_003
    ScriptEntryEnd
scr_seq_T26FS0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 1
    @ HGSS: CallStd std_pokemart
    ReleaseAll
    End
scr_seq_T26FS0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 10
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_T26FS0101_001:
    NPCMessage msg_0605_T26FS0101_00000
    End
scr_seq_T26FS0101_002:
    NPCMessage msg_0605_T26FS0101_00001
    End
    .balign 4, 0
