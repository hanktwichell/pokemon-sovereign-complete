#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0624.h"


    ScriptEntry scr_seq_T28PC0101_000
    ScriptEntry scr_seq_T28PC0101_001
    ScriptEntry scr_seq_T28PC0101_002
    ScriptEntry scr_seq_T28PC0101_003
    ScriptEntry scr_seq_T28PC0101_004
    ScriptEntry scr_seq_T28PC0101_005
    ScriptEntryEnd
scr_seq_T28PC0101_000:
    SetVarFromValue VAR_0x8007, 2
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T28PC0101_001:
    NPCMessage msg_0624_T28PC0101_00000
    End
scr_seq_T28PC0101_002:
    NPCMessage msg_0624_T28PC0101_00001
    End
scr_seq_T28PC0101_003:
    NPCMessage msg_0624_T28PC0101_00002
    End
scr_seq_T28PC0101_004:
    PlayCry SPECIES_POLIWHIRL, 0
    NPCMessage msg_0624_T28PC0101_00003
    End
scr_seq_T28PC0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F7D, _00AE
    MessageGendered msg_0624_T28PC0101_00004, msg_0624_T28PC0101_00005
    SetVar VAR_0x8004, ITEM_KINGS_ROCK
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0624_T28PC0101_00006
    SetFlag FLAG_HGSS_SG_3F7D
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00AE:
    Message msg_0624_T28PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
