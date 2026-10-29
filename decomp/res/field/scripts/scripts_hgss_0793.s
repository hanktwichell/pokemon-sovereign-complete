#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0498.h"


    ScriptEntry scr_seq_T07R0105_000
    ScriptEntry scr_seq_T07R0105_001
    ScriptEntry scr_seq_T07R0105_002
    ScriptEntry scr_seq_T07R0105_003
    ScriptEntry scr_seq_T07R0105_004
    ScriptEntry scr_seq_T07R0105_005
    ScriptEntryEnd
scr_seq_T07R0105_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 22
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T07R0105_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 23
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T07R0105_002:
    NPCMessage msg_0498_T07R0105_00000
    End
scr_seq_T07R0105_003:
    NPCMessage msg_0498_T07R0105_00001
    End
scr_seq_T07R0105_004:
    NPCMessage msg_0498_T07R0105_00002
    End
scr_seq_T07R0105_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0498_T07R0105_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
