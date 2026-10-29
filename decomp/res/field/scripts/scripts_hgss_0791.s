#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0496.h"


    ScriptEntry scr_seq_T07R0103_000
    ScriptEntry scr_seq_T07R0103_001
    ScriptEntry scr_seq_T07R0103_002
    ScriptEntry scr_seq_T07R0103_003
    ScriptEntry scr_seq_T07R0103_004
    ScriptEntry scr_seq_T07R0103_005
    ScriptEntryEnd
scr_seq_T07R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 20
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T07R0103_001:
    NPCMessage msg_0496_T07R0103_00000
    End
scr_seq_T07R0103_002:
    NPCMessage msg_0496_T07R0103_00001
    End
scr_seq_T07R0103_003:
    NPCMessage msg_0496_T07R0103_00002
    End
scr_seq_T07R0103_004:
    NPCMessage msg_0496_T07R0103_00003
    End
scr_seq_T07R0103_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0496_T07R0103_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
