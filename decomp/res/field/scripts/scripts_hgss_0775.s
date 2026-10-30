#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0482.h"


    ScriptEntry scr_seq_T05R0701_000
    ScriptEntry scr_seq_T05R0701_001
    ScriptEntry scr_seq_T05R0701_002
    ScriptEntry scr_seq_T05R0701_003
    ScriptEntry scr_seq_T05R0701_004
    ScriptEntry scr_seq_T05R0701_005
    ScriptEntry scr_seq_T05R0701_006
    ScriptEntryEnd
scr_seq_T05R0701_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_EXPN_CARD, _0069
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0047
    Message msg_0482_T05R0701_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0047:
    BufferPlayerName 0
    MessageGendered msg_0482_T05R0701_00004, msg_0482_T05R0701_00005
    Message msg_0482_T05R0701_00006
    PlayFanfare SEQ_ME_KEYITEM_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_GOT_EXPN_CARD
    GoToIfSet FLAG_HGSS_GOT_RADIO_CARD, _0069
    @ HGSS: RegisterPokegearCard 2
_0069:
    Message msg_0482_T05R0701_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T05R0701_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_EXPN_CARD, _0092
    Message msg_0482_T05R0701_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0092:
    Message msg_0482_T05R0701_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T05R0701_000:
    NPCMessage msg_0482_T05R0701_00000
    End
scr_seq_T05R0701_001:
    NPCMessage msg_0482_T05R0701_00001
    End
scr_seq_T05R0701_002:
    NPCMessage msg_0482_T05R0701_00002
    End
scr_seq_T05R0701_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0482_T05R0701_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T05R0701_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0482_T05R0701_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
