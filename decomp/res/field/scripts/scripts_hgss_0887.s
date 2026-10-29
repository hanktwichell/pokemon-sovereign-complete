#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0583.h"


    ScriptEntry scr_seq_T25PC0101_000
    ScriptEntry scr_seq_T25PC0101_001
    ScriptEntry scr_seq_T25PC0101_002
    ScriptEntry scr_seq_T25PC0101_003
    ScriptEntryEnd
scr_seq_T25PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T25PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _003C
    Message msg_0583_T25PC0101_00003
    GoTo _003F
_003C:
    Message msg_0583_T25PC0101_00002
_003F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25PC0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0065
    Message msg_0583_T25PC0101_00005
    GoTo _0068
_0065:
    Message msg_0583_T25PC0101_00004
_0068:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25PC0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _008E
    Message msg_0583_T25PC0101_00001
    GoTo _0091
_008E:
    Message msg_0583_T25PC0101_00000
_0091:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
