#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0613.h"


    ScriptEntry scr_seq_T27FS0101_000
    ScriptEntry scr_seq_T27FS0101_001
    ScriptEntry scr_seq_T27FS0101_002
    ScriptEntry scr_seq_T27FS0101_003
    ScriptEntry scr_seq_T27FS0101_004
    ScriptEntryEnd
scr_seq_T27FS0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 1
    PokeMartCommon
    ReleaseAll
    End
scr_seq_T27FS0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 9
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T27FS0101_002:
    NPCMessage msg_0613_T27FS0101_00001
    End
scr_seq_T27FS0101_003:
    NPCMessage msg_0613_T27FS0101_00000
    End
scr_seq_T27FS0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F73, _00A9
    Message msg_0613_T27FS0101_00002
    SetVar VAR_0x8004, ITEM_TM61
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F73
    Message msg_0613_T27FS0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A9:
    Message msg_0613_T27FS0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
