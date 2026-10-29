#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0593.h"


    ScriptEntry scr_seq_T25R1002_000
    ScriptEntry scr_seq_T25R1002_001
    ScriptEntry scr_seq_T25R1002_002
    ScriptEntry scr_seq_T25R1002_003
    ScriptEntry scr_seq_T25R1002_004
    ScriptEntry scr_seq_T25R1002_005
    ScriptEntryEnd
scr_seq_T25R1002_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 3
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_T25R1002_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 4
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_T25R1002_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0070
    Message msg_0593_T25R1002_00001
    GoTo _0073
_0070:
    Message msg_0593_T25R1002_00000
_0073:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1002_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0099
    Message msg_0593_T25R1002_00005
    GoTo _009C
_0099:
    Message msg_0593_T25R1002_00004
_009C:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1002_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _00C2
    Message msg_0593_T25R1002_00003
    GoTo _00C5
_00C2:
    Message msg_0593_T25R1002_00002
_00C5:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1002_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0593_T25R1002_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
