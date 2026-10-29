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
    GoToIf 1, _0188
    End
scr_seq_D32R0102_004:
    GoToIfUnset FLAG_HGSS_UNK_189, _0196
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D32R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40E5, 2
    GoToIf 1, _01BA
    Message msg_0104_D32R0102_00002
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
    GoToIf 5, _01C5
    ApplyMovement obj_D32R0102_gsmiddleman1, _0430
    ApplyMovement LOCALID_PLAYER, _0446
    GoTo _01E8
scr_seq_D32R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01FF
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0213
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0227
    ApplyMovement LOCALID_PLAYER, _0450
    ApplyMovement obj_D32R0102_gsmiddleman1_2, _0466
    GoTo _0242
scr_seq_D32R0102_005:
    GoToIfSet FLAG_HGSS_UNK_150, _02A3
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0104_D32R0102_00004
    BufferPlayerName 0
    ApplyMovement obj_D32R0102_gsman1, _0470
    WaitMovement
    Message msg_0104_D32R0102_00005
    CloseMessage
    SetFlag FLAG_HGSS_UNK_150
    GoTo _02BE
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
_0188:
    SetPosition obj_D32R0102_gsmiddleman1, 17, 1, 25, DIR_WEST
    End
_0196:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _02CC
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _02CC
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_01BA:
    Message msg_0104_D32R0102_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01C5:
    CompareVar VAR_0x8004, 13
    GoToIf 5, _02D2
    ApplyMovement obj_D32R0102_gsmiddleman1, _0476
    ApplyMovement LOCALID_PLAYER, _0446
    GoTo _01E8
_01E8:
    WaitMovement
    Message msg_0104_D32R0102_00001
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40E5, 1
    SetFlag FLAG_HGSS_UNK_25B
    End
_01FF:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0213:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0227:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02F5
    ApplyMovement LOCALID_PLAYER, _0488
    GoTo _0242
_0242:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0318
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0492
    WaitMovement
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
_02A3:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0104_D32R0102_00006
    CloseMessage
    ApplyMovement obj_D32R0102_gsman1, _04A0
    WaitMovement
    ReleaseAll
    End
_02BE:
    ApplyMovement obj_D32R0102_gsman1, _04A0
    WaitMovement
    ReleaseAll
    End
_02CC:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
_02D2:
    CompareVar VAR_0x8004, 14
    GoToIf 5, _0352
    ApplyMovement obj_D32R0102_gsmiddleman1, _04A6
    ApplyMovement LOCALID_PLAYER, _0446
    GoTo _01E8
_02F5:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0375
    ApplyMovement LOCALID_PLAYER, _04BC
    ApplyMovement obj_D32R0102_gsmiddleman1_2, _0466
    GoTo _0242
_0318:
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
_0352:
    CompareVar VAR_0x8004, 15
    GoToIf 5, _03E6
    ApplyMovement obj_D32R0102_gsmiddleman1, _04CE
    ApplyMovement LOCALID_PLAYER, _04E0
    GoTo _01E8
_0375:
    ApplyMovement LOCALID_PLAYER, _04EA
    ApplyMovement obj_D32R0102_gsmiddleman1_2, _0466
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0318
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0492
    WaitMovement
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
_03E6:
    CompareVar VAR_0x8004, 16
    GoToIf 5, _0409
    ApplyMovement obj_D32R0102_gsmiddleman1, _04FC
    ApplyMovement LOCALID_PLAYER, _04E0
    GoTo _01E8
_0409:
    ApplyMovement obj_D32R0102_gsmiddleman1, _0512
    ApplyMovement LOCALID_PLAYER, _04E0
    WaitMovement
    Message msg_0104_D32R0102_00001
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40E5, 1
    SetFlag FLAG_HGSS_UNK_25B
    End
    .balign 4, 0
_0430:
    WalkFastWest
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0446:
    Delay8 5
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0450:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0466:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0470:
    FaceSouth
    EndMovement
    .balign 4, 0
_0476:
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0488:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0492:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_04A0:
    FaceNorth
    EndMovement
    .balign 4, 0
_04A6:
    WalkNormalEast
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_04BC:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04CE:
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_04E0:
    Delay8 5
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_04EA:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04FC:
    WalkNormalEast
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0512:
    WalkFastEast 2
    WalkFastNorth 5
    WalkSlightlyFastNorth 2
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
