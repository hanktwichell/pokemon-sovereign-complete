#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0085.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D24R0217_gsmiddleman1 0

    ScriptEntry scr_seq_D24R0217_000
    ScriptEntry scr_seq_D24R0217_001
    ScriptEntry scr_seq_D24R0217_002
    ScriptEntry scr_seq_D24R0217_003
    ScriptEntryEnd
scr_seq_D24R0217_002:
    GoToIfUnset FLAG_HGSS_UNK_189, _0023
    ClearFlag FLAG_HGSS_UNK_189
    End
_0023:
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0061
    GetDayOfWeek VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0067
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 1, _0067
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 1, _0067
_0061:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0067:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_D24R0217_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0085_D24R0217_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D24R0217_001:
    End
scr_seq_D24R0217_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0197
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01AB
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00F9
    ApplyMovement LOCALID_PLAYER, _01C0
    ApplyMovement obj_D24R0217_gsmiddleman1, _020C
    GoTo _0147
_00F9:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0114
    ApplyMovement LOCALID_PLAYER, _01D8
    GoTo _0147
_0114:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0137
    ApplyMovement LOCALID_PLAYER, _01F8
    ApplyMovement obj_D24R0217_gsmiddleman1, _020C
    GoTo _0147
_0137:
    ApplyMovement LOCALID_PLAYER, _01E4
    ApplyMovement obj_D24R0217_gsmiddleman1, _020C
_0147:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0218
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 4
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
_0197:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AB:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01C0:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01D8:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01E4:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01F8:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_020C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0218:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
