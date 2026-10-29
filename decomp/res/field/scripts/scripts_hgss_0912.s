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
    PokeMartCommon
    ReleaseAll
    End
scr_seq_T26FS0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 17
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T26FS0101_001:
    NPCMessage msg_0605_T26FS0101_00000
    End
scr_seq_T26FS0101_002:
    NPCMessage msg_0605_T26FS0101_00001
    End
    .balign 4, 0
