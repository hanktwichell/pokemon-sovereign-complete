#include "macros/scrcmd.inc"
#include "generated/text_banks.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_W21_gsmiddleman1 12

    ScriptEntry scr_seq_W21_000
    ScriptEntry scr_seq_W21_001
    ScriptEntryEnd
scr_seq_W21_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _001B
    ClearFlag FLAG_HGSS_UNK_189
    End
_001B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _003F
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _003F
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_003F:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_W21_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0152
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0166
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00BE
    ApplyMovement LOCALID_PLAYER, _017C
    ApplyMovement obj_W21_gsmiddleman1, _01B0
    GoTo _00F1
_00BE:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _00E1
    ApplyMovement LOCALID_PLAYER, _019C
    ApplyMovement obj_W21_gsmiddleman1, _01B0
    GoTo _00F1
_00E1:
    ApplyMovement LOCALID_PLAYER, _0188
    ApplyMovement obj_W21_gsmiddleman1, _01B0
_00F1:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0118
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _01BC
    WaitMovement
_0118:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 74
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
_0152:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0166:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_017C:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0188:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_019C:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01B0:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01BC:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
