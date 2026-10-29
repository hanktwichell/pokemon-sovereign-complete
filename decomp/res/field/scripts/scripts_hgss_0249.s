#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0396.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R39_gsgentleman 8
#define obj_R39_gsmiddleman1_2 11

    ScriptEntry scr_seq_R39_000
    ScriptEntry scr_seq_R39_001
    ScriptEntry scr_seq_R39_002
    ScriptEntry scr_seq_R39_003
    ScriptEntry scr_seq_R39_004
    ScriptEntry scr_seq_R39_005
    ScriptEntry scr_seq_R39_006
    ScriptEntry scr_seq_R39_007
    ScriptEntryEnd
scr_seq_R39_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _0033
    ClearFlag FLAG_HGSS_UNK_189
    End
_0033:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _005B
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _005B
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _005F
_005B:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
_005F:
    @ HGSS: ScrCmd_379 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0087
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0087
    ClearFlag FLAG_HGSS_UNK_226
    GoTo _008B
_0087:
    SetFlag FLAG_HGSS_UNK_226
_008B:
    GoToIfUnset FLAG_HGSS_TRADE_LT_SURGE_PIKACHU, _00E3
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00E3
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _00C4
    ClearFlag FLAG_HGSS_HIDE_ROUTE_39_LT_SURGE
    GoTo _00E1
_00C4:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _00DB
    ClearFlag FLAG_HGSS_HIDE_ROUTE_39_LT_SURGE
    GoTo _00E1
_00DB:
    GoTo _00E3
_00E1:
    End
_00E3:
    SetFlag FLAG_HGSS_HIDE_ROUTE_39_LT_SURGE
    End
scr_seq_R39_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MILTANK, 0
    Message msg_0396_R39_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R39_002:
    LockAll
    ApplyMovement obj_R39_gsgentleman, _0208
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 171
    GoToIf 5, _0133
    ApplyMovement obj_R39_gsgentleman, _0214
    GoTo _0156
_0133:
    CompareVar VAR_MAP_LOCAL_0x01, 172
    GoToIf 5, _014E
    ApplyMovement obj_R39_gsgentleman, _0220
    GoTo _0156
_014E:
    ApplyMovement obj_R39_gsgentleman, _0228
_0156:
    WaitMovement
    Message msg_0396_R39_00004
    Message msg_0396_R39_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E3
_0173:
    Message msg_0396_R39_00006
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BAOBA
    BufferPlayerName 0
    Message msg_0396_R39_00008
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0396_R39_00009
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 171
    GoToIf 5, _01AC
    ApplyMovement obj_R39_gsgentleman, _0234
    GoTo _01CF
_01AC:
    CompareVar VAR_MAP_LOCAL_0x01, 172
    GoToIf 5, _01C7
    ApplyMovement obj_R39_gsgentleman, _0244
    GoTo _01CF
_01C7:
    ApplyMovement obj_R39_gsgentleman, _0254
_01CF:
    WaitMovement
    RemoveObject obj_R39_gsgentleman
    SetFlag FLAG_HGSS_UNK_228
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_408F, 1
    End
_01E3:
    Message msg_0396_R39_00007
    Message msg_0396_R39_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E3
    GoTo _0173
    End
    .balign 4, 0
_0208:
    EmoteExclamationMark
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0214:
    WalkNormalNorth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0220:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0228:
    WalkNormalSouth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0234:
    WalkNormalSouth
    WalkNormalWest 2
    WalkNormalSouth 9
    EndMovement
    .balign 4, 0
_0244:
    WalkNormalSouth
    WalkNormalWest 2
    WalkNormalSouth 8
    EndMovement
    .balign 4, 0
_0254:
    WalkNormalSouth
    WalkNormalWest 2
    WalkNormalSouth 7
    EndMovement
scr_seq_R39_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _038C
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03A0
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02DD
    ApplyMovement LOCALID_PLAYER, _03B4
    ApplyMovement obj_R39_gsmiddleman1_2, _0400
    GoTo _032B
_02DD:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02F8
    ApplyMovement LOCALID_PLAYER, _03CC
    GoTo _032B
_02F8:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _031B
    ApplyMovement LOCALID_PLAYER, _03EC
    ApplyMovement obj_R39_gsmiddleman1_2, _0400
    GoTo _032B
_031B:
    ApplyMovement LOCALID_PLAYER, _03D8
    ApplyMovement obj_R39_gsmiddleman1_2, _0400
_032B:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0352
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _040C
    WaitMovement
_0352:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 28
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
_038C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03A0:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_03B4:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03CC:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03D8:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03EC:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0400:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_040C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_R39_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0396_R39_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0485
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0490
    Message msg_0396_R39_00011
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 80
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0396_R39_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0485:
    Message msg_0396_R39_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0490:
    Message msg_0396_R39_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R39_003:
    DrawSignpostInstantMessage msg_0396_R39_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R39_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0396_R39_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R39_005:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0396_R39_00002, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
