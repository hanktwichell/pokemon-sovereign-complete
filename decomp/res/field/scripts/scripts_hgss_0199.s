#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0348.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R12_gsmiddleman1 13
#define obj_R12_kabigon 15
#define obj_R12_gsbabyboy1 16
#define obj_R12_gsbabyboy1_2 17
#define obj_R12_gsbabyboy1_3 18

    ScriptEntry scr_seq_R12_000
    ScriptEntry scr_seq_R12_001
    ScriptEntry scr_seq_R12_002
    ScriptEntry scr_seq_R12_003
    ScriptEntry scr_seq_R12_004
    ScriptEntry scr_seq_R12_005
    ScriptEntryEnd
scr_seq_R12_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _002B
    ClearFlag FLAG_HGSS_UNK_189
    End
_002B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _004F
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _004F
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_004F:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_R12_004:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _006D
    GoToIfSet FLAG_HGSS_SNORLAX_MEET, _0087
    End
_006D:
    SetFlag FLAG_HGSS_HIDE_ROUTE_12_SNORLAX
    RemoveObject obj_R12_kabigon
    RemoveObject obj_R12_gsbabyboy1
    RemoveObject obj_R12_gsbabyboy1_2
    RemoveObject obj_R12_gsbabyboy1_3
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_0087:
    End
scr_seq_R12_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01B1
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01C5
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0102
    ApplyMovement LOCALID_PLAYER, _01DC
    ApplyMovement obj_R12_gsmiddleman1, _0228
    GoTo _0150
_0102:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _011D
    ApplyMovement LOCALID_PLAYER, _01F4
    GoTo _0150
_011D:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0140
    ApplyMovement LOCALID_PLAYER, _0214
    ApplyMovement obj_R12_gsmiddleman1, _0228
    GoTo _0150
_0140:
    ApplyMovement LOCALID_PLAYER, _0200
    ApplyMovement obj_R12_gsmiddleman1, _0228
_0150:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0177
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0234
    WaitMovement
_0177:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 59
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
_01B1:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01C5:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01DC:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01F4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0200:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0214:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0228:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0234:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_R12_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: RadioMusicIsPlaying 5, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0268
    Message msg_0348_R12_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0268:
    PlayCry SPECIES_SNORLAX, 0
    Message msg_0348_R12_00003
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_SNORLAX, 50, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02AE
    CompleteGetBattleResult VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 4
    CallIf 1, _02B4
    SetFlag FLAG_HGSS_SNORLAX_MEET
    ReleaseAll
    End
_02AE:
    BlackOutFromBattle
    ReleaseAll
    End
_02B4:
    SetFlag FLAG_HGSS_CAUGHT_SNORLAX
    Return
    ReleaseAll
    End
scr_seq_R12_002:
    DrawSignpostInstantMessage msg_0348_R12_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R12_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0348_R12_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
