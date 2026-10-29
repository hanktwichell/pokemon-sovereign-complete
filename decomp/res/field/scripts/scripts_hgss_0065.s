#include "macros/scrcmd.inc"
#include "generated/text_banks.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D27R0106_gsmiddleman1 3

    ScriptEntry scr_seq_D27R0106_000
    ScriptEntry scr_seq_D27R0106_001
    ScriptEntryEnd
scr_seq_D27R0106_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _001B
    ClearFlag FLAG_HGSS_UNK_189
    End
_001B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _003F
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _003F
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_003F:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_D27R0106_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0127
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _013B
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00B6
    ApplyMovement LOCALID_PLAYER, _0150
    GoTo _00C6
_00B6:
    ApplyMovement LOCALID_PLAYER, _015C
    ApplyMovement obj_D27R0106_gsmiddleman1, _0170
_00C6:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00ED
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _017C
    WaitMovement
_00ED:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 27
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0127:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013B:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0150:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_015C:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0170:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_017C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
