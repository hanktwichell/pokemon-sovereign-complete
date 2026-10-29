#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0632.h"


    ScriptEntry scr_seq_T30PC0101_000
    ScriptEntry scr_seq_T30PC0101_001
    ScriptEntry scr_seq_T30PC0101_002
    ScriptEntry scr_seq_T30PC0101_003
    ScriptEntry scr_seq_T30PC0101_004
    ScriptEntryEnd
scr_seq_T30PC0101_000:
    SetVarFromValue VAR_0x8007, 3
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T30PC0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F85, _0096
    Message msg_0632_T30PC0101_00000
    SetVar VAR_0x8004, ITEM_DRAGON_SCALE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F85
    Message msg_0632_T30PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30PC0101_002:
    NPCMessage msg_0632_T30PC0101_00001
    End
scr_seq_T30PC0101_003:
    NPCMessage msg_0632_T30PC0101_00002
    End
scr_seq_T30PC0101_004:
    PlayCry SPECIES_HORSEA, 0
    NPCMessage msg_0632_T30PC0101_00007
    End
_0096:
    Message msg_0632_T30PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
