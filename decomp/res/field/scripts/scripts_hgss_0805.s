#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0510.h"

#define obj_T07R0701_gswoman1 1
#define obj_T07R0701_gsbigman 2
#define obj_T07R0701_leader4 3
#define obj_T07R0701_gsbigman_2 4
#define obj_T07R0701_gsbigman_3 5

    ScriptEntry scr_seq_T07R0701_000
    ScriptEntry scr_seq_T07R0701_001
    ScriptEntry scr_seq_T07R0701_002
    ScriptEntry scr_seq_T07R0701_003
    ScriptEntry scr_seq_T07R0701_004
    ScriptEntry scr_seq_T07R0701_005
    ScriptEntry scr_seq_T07R0701_006
    ScriptEntryEnd
scr_seq_T07R0701_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0510_T07R0701_00006
    CloseMessage
    ApplyMovement obj_T07R0701_leader4, _003C
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_003C:
    WalkOnSpotNormalEast
    EndMovement
scr_seq_T07R0701_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0074
    Message msg_0510_T07R0701_00004
    CloseMessage
    ApplyMovement obj_T07R0701_gswoman1, _00D8
    WaitMovement
    ReleaseAll
    End
_0074:
    Message msg_0510_T07R0701_00005
    CloseMessage
    ApplyMovement obj_T07R0701_gswoman1, _00D8
    WaitMovement
    ReleaseAll
    End
scr_seq_T07R0701_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0510_T07R0701_00001
    CloseMessage
    ApplyMovement obj_T07R0701_gsbigman_3, _00E0
    WaitMovement
    ReleaseAll
    End
scr_seq_T07R0701_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0510_T07R0701_00002
    CloseMessage
    ApplyMovement obj_T07R0701_gsbigman_2, _00E0
    WaitMovement
    ReleaseAll
    End
scr_seq_T07R0701_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0510_T07R0701_00003
    CloseMessage
    ApplyMovement obj_T07R0701_gsbigman, _00D8
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_00D8:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_00E0:
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_T07R0701_000:
    NPCMessage msg_0510_T07R0701_00000
    End
scr_seq_T07R0701_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0510_T07R0701_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
