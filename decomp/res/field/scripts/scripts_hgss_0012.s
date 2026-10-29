#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0052.h"

#define obj_D10R0101_mount_2 0

    ScriptEntry scr_seq_D10R0101_000
    ScriptEntry scr_seq_D10R0101_001
    ScriptEntry scr_seq_D10R0101_002
    ScriptEntry scr_seq_D10R0101_003
    ScriptEntry scr_seq_D10R0101_004
    ScriptEntry scr_seq_D10R0101_005
    ScriptEntryEnd
scr_seq_D10R0101_000:
    @ HGSS: PalParkAction 2
    End
scr_seq_D10R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    MessageInstant msg_0052_D10R0101_00006
    WaitTime 30, VAR_RESULT
    MessageInstant msg_0052_D10R0101_00007
    PlaySE SEQ_SE_DP_DECIDE_sseq
    WaitTime 30, VAR_RESULT
    MessageInstant msg_0052_D10R0101_00008
    PlaySE SEQ_SE_DP_DECIDE_sseq
    WaitTime 30, VAR_RESULT
    MessageInstant msg_0052_D10R0101_00009
    PlaySE SEQ_SE_DP_DECIDE_sseq
    WaitTime 30, VAR_RESULT
    MessageInstant msg_0052_D10R0101_00010
    PlaySE SEQ_SE_DP_CON_016_sseq
    WaitTime 30, VAR_RESULT
    @ HGSS: PalParkAction 0
    SetVarFromValue VAR_HGSS_UNK_4124, 1
    CloseMessage
    ReleaseAll
    End
    @ HGSS: PalParkAction 0
    SetVarFromValue VAR_HGSS_UNK_4124, 1
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D10R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlaySE SEQ_SE_DP_PINPON_sseq
    BufferPlayerName 0
    Message msg_0052_D10R0101_00004
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4124, 1
    Call _01D4
    End
scr_seq_D10R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0052_D10R0101_00005
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00D5
    ReleaseAll
    End
_00D5:
    SetVarFromValue VAR_HGSS_UNK_4124, 2
    ReleaseAll
    Call _01D4
    End
scr_seq_D10R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0180
    CloseMessage
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0110
    SetVarFromValue VAR_HGSS_UNK_4124, 2
    ReleaseAll
    Call _01D4
    End
_0110:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0134
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
    .balign 4, 0
_0134:
    WalkNormalNorth
    EndMovement
scr_seq_D10R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Call _0180
    CloseMessage
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0169
    SetVarFromValue VAR_HGSS_UNK_4124, 2
    ReleaseAll
    Call _01D4
    End
_0169:
    ApplyMovement obj_D10R0101_mount_2, _0178
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0178:
    WalkOnSpotNormalWest
    EndMovement
_0180:
    Message msg_0052_D10R0101_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01C9
    GetPlayerGender VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01B9
    BufferPlayerName 0
    Message msg_0052_D10R0101_00002
    WaitButton
    SetVarFromValue VAR_RESULT, 0
    Return
_01B9:
    BufferPlayerName 0
    Message msg_0052_D10R0101_00003
    WaitButton
    SetVarFromValue VAR_RESULT, 0
    Return
_01C9:
    Message msg_0052_D10R0101_00001
    SetVarFromValue VAR_RESULT, 1
    Return
_01D4:
    @ HGSS: PalParkAction 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_FUCHSIA_PAL_PARK_ENTRANCE, 7, 7, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Return
    .balign 4, 0
