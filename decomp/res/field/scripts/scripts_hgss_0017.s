#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0055.h"


    ScriptEntry scr_seq_D15R0102_000
    ScriptEntry scr_seq_D15R0102_001
    ScriptEntry scr_seq_D15R0102_002
    ScriptEntry scr_seq_D15R0102_003
    ScriptEntryEnd
scr_seq_D15R0102_000:
    End
scr_seq_D15R0102_001:
    NPCMessage msg_0055_D15R0102_00000
    End
scr_seq_D15R0102_002:
    NPCMessage msg_0055_D15R0102_00001
    End
scr_seq_D15R0102_003:
    LockAll
    RemoveObject 3
    SetFlag FLAG_HGSS_SG_3FFF
    SetVar VAR_0x8004, ITEM_TM70
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
