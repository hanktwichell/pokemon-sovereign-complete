#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0452.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T02_gsmiddleman1 6

    ScriptEntry scr_seq_T02_000
    ScriptEntry scr_seq_T02_001
    ScriptEntry scr_seq_T02_002
    ScriptEntry scr_seq_T02_003
    ScriptEntry scr_seq_T02_004
    ScriptEntry scr_seq_T02_005
    ScriptEntry scr_seq_T02_006
    ScriptEntry scr_seq_T02_007
    ScriptEntry scr_seq_T02_008
    ScriptEntry scr_seq_T02_009
    ScriptEntry scr_seq_T02_010
    ScriptEntry scr_seq_T02_011
    ScriptEntryEnd
scr_seq_T02_008:
    GoToIfUnset FLAG_HGSS_UNK_189, _0043
    ClearFlag FLAG_HGSS_UNK_189
    End
_0043:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _005E
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0079
_005E:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0075
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0079
_0075:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_0079:
    GoToIfSet FLAG_HGSS_UNLOCKED_WEST_KANTO, _008E
    SetFlag FLAG_HGSS_UNLOCKED_WEST_KANTO
    SetVarFromValue VAR_HGSS_UNK_4121, 1
_008E:
    End
scr_seq_T02_011:
    SetVar VAR_0x8004, PHONE_CONTACT_PROF__OAK
    SetVar VAR_0x8005, 2
    SetVar VAR_0x8006, 0
    CallCommonScript 0x813
    SetVarFromValue VAR_HGSS_UNK_4096, 2
    End
scr_seq_T02_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0452_T02_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00D7
    Message msg_0452_T02_00001
    GoTo _00DA
_00D7:
    Message msg_0452_T02_00002
_00DA:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T02_001:
    NPCMessage msg_0452_T02_00003
    End
scr_seq_T02_010:
    NPCMessage msg_0452_T02_00004
    End
scr_seq_T02_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TM85_FROM_VIRIDIAN_CITY_MAN, _0147
    Message msg_0452_T02_00005
    SetVar VAR_0x8004, ITEM_TM85
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0152
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM85_FROM_VIRIDIAN_CITY_MAN
_0147:
    Message msg_0452_T02_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0152:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_T02_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0284
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0298
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01D5
    ApplyMovement LOCALID_PLAYER, _02AC
    ApplyMovement obj_T02_gsmiddleman1, _02F8
    GoTo _0223
_01D5:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01F0
    ApplyMovement LOCALID_PLAYER, _02C4
    GoTo _0223
_01F0:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0213
    ApplyMovement LOCALID_PLAYER, _02E4
    ApplyMovement obj_T02_gsmiddleman1, _02F8
    GoTo _0223
_0213:
    ApplyMovement LOCALID_PLAYER, _02D0
    ApplyMovement obj_T02_gsmiddleman1, _02F8
_0223:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _024A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0304
    WaitMovement
_024A:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 69
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
_0284:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0298:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_02AC:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02C4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02D0:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02E4:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02F8:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0304:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T02_003:
    NPCMessage msg_0452_T02_00007
    End
scr_seq_T02_004:
    DrawSignpostInstantMessage msg_0452_T02_00008, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T02_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0452_T02_00009, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T02_006:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0452_T02_00010, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T02_007:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0452_T02_00011, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
