#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0468.h"


    ScriptEntry scr_seq_T04FS0101_000
    ScriptEntry scr_seq_T04FS0101_001
    ScriptEntry scr_seq_T04FS0101_002
    ScriptEntry scr_seq_T04FS0101_003
    ScriptEntryEnd
scr_seq_T04FS0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 1
    PokeMartCommon
    ReleaseAll
    End
scr_seq_T04FS0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 15
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T04FS0101_002:
    NPCMessage msg_0468_T04FS0101_00000
    End
scr_seq_T04FS0101_003:
    NPCMessage msg_0468_T04FS0101_00001
    End
    .balign 4, 0
