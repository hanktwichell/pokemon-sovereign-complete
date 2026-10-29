#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0090.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D26R0101_gsmiddleman1 1

    ScriptEntry scr_seq_D26R0101_000
    ScriptEntry scr_seq_D26R0101_001
    ScriptEntry scr_seq_D26R0101_002
    ScriptEntryEnd
scr_seq_D26R0101_002:
    GoToIfUnset FLAG_HGSS_UNK_189, _001F
    ClearFlag FLAG_HGSS_UNK_189
    End
_001F:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _005D
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0063
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0063
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0063
_005D:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0063:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_D26R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0090_D26R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D26R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0184
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0198
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00F0
    ApplyMovement LOCALID_PLAYER, _01AC
    GoTo _0123
_00F0:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0113
    ApplyMovement LOCALID_PLAYER, _01CC
    ApplyMovement obj_D26R0101_gsmiddleman1, _01E0
    GoTo _0123
_0113:
    ApplyMovement LOCALID_PLAYER, _01B8
    ApplyMovement obj_D26R0101_gsmiddleman1, _01E0
_0123:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _014A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _01EC
    WaitMovement
_014A:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 6
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
_0184:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0198:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01AC:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01B8:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01CC:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01E0:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01EC:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
