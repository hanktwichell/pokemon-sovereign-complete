#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0536.h"


    ScriptEntry scr_seq_T11R0602_000
    ScriptEntryEnd
scr_seq_T11R0602_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0088
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFFRON_MAGNET_TRAIN_STATION_1F, 3, 3, DIR_EAST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    @ HGSS: ScrCmd_606
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0094
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0536_T11R0602_00000
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00A0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
    .balign 4, 0
_0088:
    WalkNormalSouth 3
    WalkNormalEast 7
    EndMovement
    .balign 4, 0
_0094:
    WalkNormalEast 11
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_00A0:
    WalkNormalSouth 2
    EndMovement
_00A8:
    End
    .balign 4, 0
