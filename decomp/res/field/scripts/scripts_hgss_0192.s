#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0342.h"


    ScriptEntry scr_seq_R10PC0101_000
    ScriptEntry scr_seq_R10PC0101_001
    ScriptEntry scr_seq_R10PC0101_002
    ScriptEntry scr_seq_R10PC0101_003
    ScriptEntry scr_seq_R10PC0101_004
    ScriptEntryEnd
scr_seq_R10PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_R10PC0101_001:
    NPCMessage msg_0342_R10PC0101_00000
    End
scr_seq_R10PC0101_002:
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _008F
    NPCMessage msg_0342_R10PC0101_00001
    End
scr_seq_R10PC0101_003:
    NPCMessage msg_0342_R10PC0101_00003
    End
scr_seq_R10PC0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BLISSEY, 0
    WaitCry
    Message msg_0342_R10PC0101_00004
    SetVar VAR_0x8004, ITEM_TM70
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_008F:
    NPCMessage msg_0342_R10PC0101_00002
    End
    .balign 4, 0
