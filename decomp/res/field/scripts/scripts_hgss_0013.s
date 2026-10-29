#include "macros/scrcmd.inc"
#include "generated/text_banks.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D11R0102_gsmiddleman1 8

    ScriptEntry scr_seq_D11R0102_000
    ScriptEntry scr_seq_D11R0102_001
    ScriptEntryEnd
scr_seq_D11R0102_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _001B
    ClearFlag FLAG_HGSS_UNK_189
    End
_001B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _003F
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _003F
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_003F:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_D11R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _014A
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _015E
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00BE
    ApplyMovement LOCALID_PLAYER, _0174
    ApplyMovement obj_D11R0102_gsmiddleman1, _01AC
    GoTo _00E9
_00BE:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00D9
    ApplyMovement LOCALID_PLAYER, _018C
    GoTo _00E9
_00D9:
    ApplyMovement LOCALID_PLAYER, _0198
    ApplyMovement obj_D11R0102_gsmiddleman1, _01AC
_00E9:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0110
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _01B8
    WaitMovement
_0110:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 75
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
_014A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_015E:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0174:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_018C:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0198:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01AC:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01B8:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
