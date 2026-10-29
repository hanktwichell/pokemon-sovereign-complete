#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0102.h"


    ScriptEntry scr_seq_D32PC0101_000
    ScriptEntry scr_seq_D32PC0101_001
    ScriptEntry scr_seq_D32PC0101_002
    ScriptEntry scr_seq_D32PC0101_003
    ScriptEntry scr_seq_D32PC0101_004
    ScriptEntryEnd
scr_seq_D32PC0101_004:
    SetVarFromValue VAR_HGSS_UNK_40E5, 2
    End
scr_seq_D32PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_D32PC0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F7C, _0085
    Message msg_0102_D32PC0101_00003
    SetVar VAR_0x8004, ITEM_MACHO_BRACE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0102_D32PC0101_00004
    SetFlag FLAG_HGSS_SG_3F7C
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32PC0101_002:
    NPCMessage msg_0102_D32PC0101_00001
    End
scr_seq_D32PC0101_003:
    NPCMessage msg_0102_D32PC0101_00002
    End
_0085:
    Message msg_0102_D32PC0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
