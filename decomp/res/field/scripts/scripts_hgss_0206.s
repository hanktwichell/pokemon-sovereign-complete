#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0355.h"


    ScriptEntry scr_seq_R16R0101_000
    ScriptEntry scr_seq_R16R0101_001
    ScriptEntryEnd
scr_seq_R16R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_ABA, _0068
    @ HGSS: ScrCmd_540 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _007E
    Message msg_0355_R16R0101_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0073
    @ HGSS: ScrCmd_538 VAR_SPECIAL_RESULT, 0
    CompareVar VAR_RESULT, 65535
    GoToIf 1, _007E
    SetFlag FLAG_HGSS_UNK_ABA
    Message msg_0355_R16R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0068:
    Message msg_0355_R16R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0073:
    Message msg_0355_R16R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_007E:
    Message msg_0355_R16R0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R16R0101_000:
    NPCMessage msg_0355_R16R0101_00000
    End
    .balign 4, 0
