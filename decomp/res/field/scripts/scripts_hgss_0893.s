#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0587.h"

#define obj_T25R0501_policeman 0

    ScriptEntry scr_seq_T25R0501_000
    ScriptEntry scr_seq_T25R0501_001
    ScriptEntry scr_seq_T25R0501_002
    ScriptEntry scr_seq_T25R0501_003
    ScriptEntry scr_seq_T25R0501_004
    ScriptEntry scr_seq_T25R0501_005
    ScriptEntry scr_seq_T25R0501_006
    ScriptEntry scr_seq_T25R0501_007
    ScriptEntryEnd
scr_seq_T25R0501_006:
    @ HGSS: ScrCmd_582 MAP_GOLDENROD, 348, 350
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0037
    End
_0037:
    SetVarFromValue VAR_HGSS_UNK_410B, 0
    End
scr_seq_T25R0501_005:
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _004C
    End
_004C:
    SetPosition obj_T25R0501_policeman, 4, 0, 6, DIR_EAST
    End
scr_seq_T25R0501_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0078
    Message msg_0587_T25R0501_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0078:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0096
    Message msg_0587_T25R0501_00005
    WaitButton
    CloseMessage
    GoTo _00A5
_0096:
    Message msg_0587_T25R0501_00007
    CloseMessage
    ApplyMovement obj_T25R0501_policeman, _00AC
    WaitMovement
_00A5:
    ReleaseAll
    End
    .balign 4, 0
_00AC:
    FaceEast
    EndMovement
scr_seq_T25R0501_001:
    LockAll
    ApplyMovement LOCALID_PLAYER, _013C
    WaitMovement
    GoToIfSet FLAG_HGSS_UNK_123, _0118
    Message msg_0587_T25R0501_00001
    CloseMessage
    SetFlag FLAG_HGSS_UNK_123
_00D6:
    WaitTime 50, VAR_0x8004
    CheckItem ITEM_PASS, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0123
    Message msg_0587_T25R0501_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0144
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_0118:
    Message msg_0587_T25R0501_00003
    CloseMessage
    GoTo _00D6
_0123:
    Message msg_0587_T25R0501_00004
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_410B, 1
    SetVarFromValue VAR_HGSS_UNK_411E, 1
    ReleaseAll
    End
    .balign 4, 0
_013C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0144:
    WalkNormalSouth 2
    EndMovement
scr_seq_T25R0501_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0587_T25R0501_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0501_002:
    End
scr_seq_T25R0501_003:
    End
scr_seq_T25R0501_004:
    End
    .balign 4, 0
