#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0104.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D32R0102_gsmiddleman1 0
#define obj_D32R0102_gsmiddleman1_2 1
#define obj_D32R0102_gsman1 2

    ScriptEntry scr_seq_D32R0102_000
    ScriptEntry scr_seq_D32R0102_001
    ScriptEntry scr_seq_D32R0102_002
    ScriptEntry scr_seq_D32R0102_003
    ScriptEntry scr_seq_D32R0102_004
    ScriptEntry scr_seq_D32R0102_005
    ScriptEntry scr_seq_D32R0102_006
    ScriptEntry scr_seq_D32R0102_007
    ScriptEntry scr_seq_D32R0102_008
    ScriptEntryEnd
scr_seq_D32R0102_002:
    CompareVar VAR_HGSS_UNK_40E5, 2
    GoToIf 1, _0035
    End
_0035:
    SetPosition obj_D32R0102_gsmiddleman1, 17, 1, 25, DIR_WEST
    End
scr_seq_D32R0102_004:
    GoToIfUnset FLAG_HGSS_UNK_189, _0054
    ClearFlag FLAG_HGSS_UNK_189
    End
_0054:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0078
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0078
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0078:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_D32R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40E5, 2
    GoToIf 1, _009E
    Message msg_0104_D32R0102_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_009E:
    Message msg_0104_D32R0102_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0102_001:
    LockAll
    Message msg_0104_D32R0102_00000
    CloseMessage
    SetPosition obj_D32R0102_gsmiddleman1, 14, 1, 36, DIR_NORTH
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8004, 12
    GoToIf 5, _00E7
    ApplyMovement obj_D32R0102_gsmiddleman1, _019C
    ApplyMovement LOCALID_PLAYER, _0224
    GoTo _0183
_00E7:
    CompareVar VAR_0x8004, 13
    GoToIf 5, _010A
    ApplyMovement obj_D32R0102_gsmiddleman1, _01B4
    ApplyMovement LOCALID_PLAYER, _0224
    GoTo _0183
_010A:
    CompareVar VAR_0x8004, 14
    GoToIf 5, _012D
    ApplyMovement obj_D32R0102_gsmiddleman1, _01C8
    ApplyMovement LOCALID_PLAYER, _0224
    GoTo _0183
_012D:
    CompareVar VAR_0x8004, 15
    GoToIf 5, _0150
    ApplyMovement obj_D32R0102_gsmiddleman1, _01E0
    ApplyMovement LOCALID_PLAYER, _0230
    GoTo _0183
_0150:
    CompareVar VAR_0x8004, 16
    GoToIf 5, _0173
    ApplyMovement obj_D32R0102_gsmiddleman1, _01F4
    ApplyMovement LOCALID_PLAYER, _0230
    GoTo _0183
_0173:
    ApplyMovement obj_D32R0102_gsmiddleman1, _020C
    ApplyMovement LOCALID_PLAYER, _0230
_0183:
    WaitMovement
    Message msg_0104_D32R0102_00001
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40E5, 1
    SetFlag FLAG_HGSS_UNK_25B
    End
    .balign 4, 0
_019C:
    WalkFastWest
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_01B4:
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_01C8:
    WalkNormalEast
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_01E0:
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_01F4:
    WalkNormalEast
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_020C:
    WalkFastEast 2
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0224:
    Delay8 5
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0230:
    Delay8 5
    WalkOnSpotNormalWest
    EndMovement
scr_seq_D32R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0364
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0378
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02B5
    ApplyMovement LOCALID_PLAYER, _038C
    ApplyMovement obj_D32R0102_gsmiddleman1_2, _03D8
    GoTo _0303
_02B5:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02D0
    ApplyMovement LOCALID_PLAYER, _03A4
    GoTo _0303
_02D0:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _02F3
    ApplyMovement LOCALID_PLAYER, _03C4
    ApplyMovement obj_D32R0102_gsmiddleman1_2, _03D8
    GoTo _0303
_02F3:
    ApplyMovement LOCALID_PLAYER, _03B0
    ApplyMovement obj_D32R0102_gsmiddleman1_2, _03D8
_0303:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _032A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03E4
    WaitMovement
_032A:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 29
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
_0364:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0378:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_038C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03A4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03B0:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03C4:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03D8:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03E4:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_D32R0102_005:
    GoToIfSet FLAG_HGSS_UNK_150, _0421
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0104_D32R0102_00004
    ApplyMovement obj_D32R0102_gsman1, _043C
    WaitMovement
    Message msg_0104_D32R0102_00005
    CloseMessage
    SetFlag FLAG_HGSS_UNK_150
    GoTo _042E
_0421:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0104_D32R0102_00006
    CloseMessage
_042E:
    ApplyMovement obj_D32R0102_gsman1, _0444
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_043C:
    FaceSouth
    EndMovement
    .balign 4, 0
_0444:
    FaceNorth
    EndMovement
scr_seq_D32R0102_006:
    NPCMessage msg_0104_D32R0102_00007
    End
scr_seq_D32R0102_007:
    NPCMessage msg_0104_D32R0102_00008
    End
scr_seq_D32R0102_008:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0104_D32R0102_00009, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
