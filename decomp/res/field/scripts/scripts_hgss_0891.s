#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0585.h"


    ScriptEntry scr_seq_T25R0301_000
    ScriptEntry scr_seq_T25R0301_001
    ScriptEntry scr_seq_T25R0301_002
    ScriptEntryEnd
scr_seq_T25R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8000
    Message msg_0585_T25R0301_00000
    GetPartyMonFriendship VAR_RESULT, VAR_0x8000
    CompareVar VAR_RESULT, 250
    GoToIf 4, _006C
    CompareVar VAR_RESULT, 200
    GoToIf 4, _0077
    CompareVar VAR_RESULT, 150
    GoToIf 4, _0082
    CompareVar VAR_RESULT, 100
    GoToIf 4, _008D
    CompareVar VAR_RESULT, 50
    GoToIf 4, _0098
    GoTo _00A3
    End
_006C:
    Message msg_0585_T25R0301_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0077:
    Message msg_0585_T25R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0082:
    Message msg_0585_T25R0301_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_008D:
    Message msg_0585_T25R0301_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0098:
    Message msg_0585_T25R0301_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A3:
    Message msg_0585_T25R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0301_001:
    NPCMessage msg_0585_T25R0301_00007
    End
scr_seq_T25R0301_002:
    NPCMessage msg_0585_T25R0301_00008
    End
    .balign 4, 0
