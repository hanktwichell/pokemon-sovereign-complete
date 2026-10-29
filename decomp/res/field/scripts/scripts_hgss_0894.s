#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0588.h"


    ScriptEntry scr_seq_T25R0502_000
    ScriptEntryEnd
scr_seq_T25R0502_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _008C
    WaitMovement
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_GOLDENROD_MAGNET_TRAIN_STATION_1F, 3, 3, DIR_EAST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    @ HGSS: ScrCmd_606
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0098
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0588_T25R0502_00000
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00A4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
    .balign 4, 0
_008C:
    WalkNormalSouth 3
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0098:
    WalkNormalEast 3
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_00A4:
    WalkNormalSouth 2
    EndMovement
    End
    .balign 4, 0
