#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0609.h"


    ScriptEntry scr_seq_T26R0501_000
    ScriptEntry scr_seq_T26R0501_001
    ScriptEntry scr_seq_T26R0501_002
    ScriptEntryEnd
scr_seq_T26R0501_000:
    NPCMessage msg_0609_T26R0501_00000
    End
scr_seq_T26R0501_001:
    NPCMessage msg_0609_T26R0501_00001
    End
scr_seq_T26R0501_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_UNK_AB9, _0050
    Message msg_0609_T26R0501_00004
    GoTo _00E3
_0050:
    Message msg_0609_T26R0501_00002
    CheckItem ITEM_SEAL_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0071
    Message msg_0609_T26R0501_00005
    GoTo _00E3
_0071:
    CompleteGiveRandomSeal VAR_0x8000, VAR_0x8001, VAR_0x8002
    CompareVar VAR_0x8000, 0
    GoToIf 5, _008F
    Message msg_0609_T26R0501_00003
    GoTo _00E3
_008F:
    SetFlag FLAG_HGSS_UNK_AB9
    BufferBallSealName 0, VAR_0x8000
    Message msg_0609_T26R0501_00006
    PlayFanfare SEQ_ME_ITEM_sseq
    Message msg_0609_T26R0501_00011
    WaitFanfare
    CompareVar VAR_0x8001, 0
    GoToIf 1, _00EB
    BufferBallSealName 0, VAR_0x8001
    Message msg_0609_T26R0501_00007
    PlayFanfare SEQ_ME_ITEM_sseq
    Message msg_0609_T26R0501_00011
    WaitFanfare
    CompareVar VAR_0x8002, 0
    GoToIf 1, _00EB
    BufferBallSealName 0, VAR_0x8002
    Message msg_0609_T26R0501_00008
    PlayFanfare SEQ_ME_ITEM_sseq
    Message msg_0609_T26R0501_00011
    WaitFanfare
    Message msg_0609_T26R0501_00009
_00E3:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00EB:
    Message msg_0609_T26R0501_00010
    GoTo _00E3
    End
    .balign 4, 0
