#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0003.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D41R0101_gsmiddleman1 1

    ScriptEntry scr_seq_D41R0101_000
    ScriptEntry scr_seq_D41R0101_001
    ScriptEntry scr_seq_D41R0101_002
    ScriptEntry scr_seq_D41R0101_003
    ScriptEntryEnd
scr_seq_D41R0101_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _012B
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D41R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0146
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _015A
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _016E
    ApplyMovement LOCALID_PLAYER, _02C4
    ApplyMovement obj_D41R0101_gsmiddleman1, _02DA
    GoTo _0189
scr_seq_D41R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0003_EVERYWHERE_00001
    WaitButton
    CloseMessage
    CheckPartyHasSpecies VAR_RESULT, SPECIES_REGIROCK
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01EA
    CheckPartyHasSpecies VAR_RESULT, SPECIES_REGICE
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01EA
    CheckPartyHasSpecies VAR_RESULT, SPECIES_REGISTEEL
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01EA
    ApplyMovement LOCALID_PLAYER, _02E4
    WaitMovement
    FadeScreen 20, 1, 0, COLOR_WHITE
    WaitFadeScreen
    RemoveObject 2
    FadeScreen 6, 1, 1, COLOR_WHITE
    WaitFadeScreen
    Message msg_0003_EVERYWHERE_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D41R0101_003:
    BufferPlayerName 0
    End
_012B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _01EE
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _01F4
_0146:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_015A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_016E:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01F6
    ApplyMovement LOCALID_PLAYER, _02EA
    GoTo _0189
_0189:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0219
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02F4
    WaitMovement
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
_01EA:
    ReleaseAll
    End
_01EE:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_01F4:
    End
_01F6:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0253
    ApplyMovement LOCALID_PLAYER, _0302
    ApplyMovement obj_D41R0101_gsmiddleman1, _02DA
    GoTo _0189
_0219:
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
_0253:
    ApplyMovement LOCALID_PLAYER, _0314
    ApplyMovement obj_D41R0101_gsmiddleman1, _02DA
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0219
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02F4
    WaitMovement
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
    .balign 4, 0
_02C4:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02DA:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_02E4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_02EA:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02F4:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0302:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0314:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
