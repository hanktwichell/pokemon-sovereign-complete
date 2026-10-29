#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0592.h"


    ScriptEntry scr_seq_T25R1001_000
    ScriptEntry scr_seq_T25R1001_001
    ScriptEntry scr_seq_T25R1001_002
    ScriptEntry scr_seq_T25R1001_003
    ScriptEntry scr_seq_T25R1001_004
    ScriptEntryEnd
scr_seq_T25R1001_000:
    NPCMessage msg_0592_T25R1001_00000
    End
scr_seq_T25R1001_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0047
    Message msg_0592_T25R1001_00002
    GoTo _004A
_0047:
    Message msg_0592_T25R1001_00001
_004A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1001_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0070
    Message msg_0592_T25R1001_00004
    GoTo _0073
_0070:
    Message msg_0592_T25R1001_00003
_0073:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1001_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0099
    Message msg_0592_T25R1001_00006
    GoTo _009C
_0099:
    Message msg_0592_T25R1001_00005
_009C:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1001_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0592_T25R1001_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
