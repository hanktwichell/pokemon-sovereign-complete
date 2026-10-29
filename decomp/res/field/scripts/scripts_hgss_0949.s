#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0636.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T31_gsmiddleman1 1

    ScriptEntry scr_seq_T31_000
    ScriptEntry scr_seq_T31_001
    ScriptEntry scr_seq_T31_002
    ScriptEntryEnd
scr_seq_T31_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _001F
    ClearFlag FLAG_HGSS_UNK_189
    End
_001F:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0043
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0043
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0043:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_T31_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0171
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0185
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00C2
    ApplyMovement LOCALID_PLAYER, _019C
    ApplyMovement obj_T31_gsmiddleman1, _01E8
    GoTo _0110
_00C2:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00DD
    ApplyMovement LOCALID_PLAYER, _01B4
    GoTo _0110
_00DD:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0100
    ApplyMovement LOCALID_PLAYER, _01D4
    ApplyMovement obj_T31_gsmiddleman1, _01E8
    GoTo _0110
_0100:
    ApplyMovement LOCALID_PLAYER, _01C0
    ApplyMovement obj_T31_gsmiddleman1, _01E8
_0110:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0137
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _01F4
    WaitMovement
_0137:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 77
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
_0171:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0185:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_019C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01B4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01C0:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01D4:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01E8:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01F4:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T31_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0636_T31_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
