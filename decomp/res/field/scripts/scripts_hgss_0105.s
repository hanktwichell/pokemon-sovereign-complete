#include "macros/scrcmd.inc"
#include "generated/text_banks.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D41R0101_gsmiddleman1 1

    ScriptEntry scr_seq_D41R0101_000
    ScriptEntry scr_seq_D41R0101_001
    ScriptEntryEnd
scr_seq_D41R0101_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _001B
    ClearFlag FLAG_HGSS_UNK_189
    End
_001B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0036
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _003A
_0036:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_003A:
    End
scr_seq_D41R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0164
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0178
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00B5
    ApplyMovement LOCALID_PLAYER, _018C
    ApplyMovement obj_D41R0101_gsmiddleman1, _01D8
    GoTo _0103
_00B5:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00D0
    ApplyMovement LOCALID_PLAYER, _01A4
    GoTo _0103
_00D0:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _00F3
    ApplyMovement LOCALID_PLAYER, _01C4
    ApplyMovement obj_D41R0101_gsmiddleman1, _01D8
    GoTo _0103
_00F3:
    ApplyMovement LOCALID_PLAYER, _01B0
    ApplyMovement obj_D41R0101_gsmiddleman1, _01D8
_0103:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _012A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _01E4
    WaitMovement
_012A:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 78
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
_0164:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0178:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_018C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01A4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01B0:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01C4:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01D8:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01E4:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
