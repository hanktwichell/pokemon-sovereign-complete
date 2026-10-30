#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0566.h"


    ScriptEntry scr_seq_T23GYM0101_000
    ScriptEntry scr_seq_T23GYM0101_001
    ScriptEntryEnd
scr_seq_T23GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_HIVE, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0030
    Message msg_0566_T23GYM0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0030:
    Message msg_0566_T23GYM0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T23GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_HIVE, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0062
    Message msg_0566_T23GYM0101_00002
    GoTo _0065
_0062:
    Message msg_0566_T23GYM0101_00003
_0065:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
