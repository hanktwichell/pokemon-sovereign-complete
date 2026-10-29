#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0612.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T27_gsrivel 6
#define obj_T27_gsmiddleman1 8

    ScriptEntry scr_seq_T27_000
    ScriptEntry scr_seq_T27_001
    ScriptEntry scr_seq_T27_002
    ScriptEntry scr_seq_T27_003
    ScriptEntry scr_seq_T27_004
    ScriptEntry scr_seq_T27_005
    ScriptEntry scr_seq_T27_006
    ScriptEntry scr_seq_T27_007
    ScriptEntry scr_seq_T27_008
    ScriptEntry scr_seq_T27_009
    ScriptEntry scr_seq_T27_010
    ScriptEntry scr_seq_T27_011
    ScriptEntry scr_seq_T27_012
    ScriptEntry scr_seq_T27_013
    ScriptEntry scr_seq_T27_014
    ScriptEntry scr_seq_T27_015
    ScriptEntry scr_seq_T27_016
    ScriptEntryEnd
scr_seq_T27_000:
    End
scr_seq_T27_015:
    GoToIfUnset FLAG_HGSS_UNK_189, _0059
    ClearFlag FLAG_HGSS_UNK_189
    End
_0059:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0074
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0078
_0074:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_0078:
    End
scr_seq_T27_012:
    LockAll
    @ HGSS: ScrCmd_307 11, 5, 25, 23, 1
    @ HGSS: ScrCmd_310 1
    @ HGSS: ScrCmd_308 1
    ApplyMovement LOCALID_PLAYER, _00D0
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00B6
    @ HGSS: ScrCmd_606
    GoTo _00B8
_00B6:
    @ HGSS: ScrCmd_607
_00B8:
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    SetVarFromValue VAR_HGSS_UNK_4079, 0
    @ HGSS: ScrCmd_311 1
    @ HGSS: ScrCmd_308 1
    @ HGSS: ScrCmd_309 1
    ReleaseAll
    End
    .balign 4, 0
_00D0:
    WalkFastSouth 2
    Delay8
    EndMovement
scr_seq_T27_005:
    LockAll
    ClearFlag FLAG_HGSS_HIDE_ECRUTEAK_RIVAL
    AddObject obj_T27_gsrivel
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T27_gsrivel, _019C
    ApplyMovement LOCALID_PLAYER, _01B0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    Message msg_0612_T27_00016
    WaitTime 30, VAR_RESULT
    BufferRivalName 1
    Message msg_0612_T27_00017
    CloseMessage
    ApplyMovement obj_T27_gsrivel, _01C4
    WaitMovement
    BufferPlayerName 0
    BufferRivalName 1
    Message msg_0612_T27_00018
    CloseMessage
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T27_gsrivel, _01D4
    ApplyMovement LOCALID_PLAYER, _01B0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T27_gsrivel, _01E0
    ApplyMovement LOCALID_PLAYER, _01F0
    WaitMovement
    RemoveObject obj_T27_gsrivel
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_RIVAL
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4079, 4
    SetVarFromValue VAR_HGSS_UNK_410C, 4
    ClearFlag FLAG_HGSS_HIDE_DANCE_STUDIO_KIMONO_GIRLS
    SetFlag FLAG_HGSS_UNK_241
    End
    .balign 4, 0
_0194:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_019C:
    LockDir
    WalkFastSouth
    WalkOnSpotFastNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_01B0:
    FaceNorth
    LockDir
    WalkFastSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_01C4:
    EmoteExclamationMark
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01D4:
    WalkFastSouth
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_01E0:
    WalkSlowWest 3
    Delay8 3
    WalkFastWest 6
    EndMovement
    .balign 4, 0
_01F0:
    Delay8 3
    WalkOnSpotNormalWest
    EndMovement
scr_seq_T27_013:
    NPCMessage msg_0612_T27_00019
    End
scr_seq_T27_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0314
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0328
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0288
    ApplyMovement LOCALID_PLAYER, _033C
    ApplyMovement obj_T27_gsmiddleman1, _0374
    GoTo _02B3
_0288:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02A3
    ApplyMovement LOCALID_PLAYER, _0354
    GoTo _02B3
_02A3:
    ApplyMovement LOCALID_PLAYER, _0360
    ApplyMovement obj_T27_gsmiddleman1, _0374
_02B3:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02DA
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0380
    WaitMovement
_02DA:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 19
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
_0314:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0328:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_033C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0354:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0360:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0374:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0380:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T27_001:
    DrawSignpostInstantMessage msg_0612_T27_00011, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0612_T27_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0612_T27_00013, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0612_T27_00014, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_016:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0612_T27_00015, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_96A, _0417
    Message msg_0612_T27_00008
    GoTo _041A
_0417:
    Message msg_0612_T27_00009
_041A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0440
    Message msg_0612_T27_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0440:
    Message msg_0612_T27_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_410C, 2
    GoToIf 2, _0469
    Message msg_0612_T27_00002
    GoTo _046C
_0469:
    Message msg_0612_T27_00003
_046C:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _04A8
    CompareVar VAR_HGSS_UNK_40A1, 0
    GoToIf 5, _049D
    Message msg_0612_T27_00005
    GoTo _04A0
_049D:
    Message msg_0612_T27_00006
_04A0:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04A8:
    Message msg_0612_T27_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27_007:
    NPCMessage msg_0612_T27_00010
    End
scr_seq_T27_011:
    NPCMessage msg_0612_T27_00004
    End
    .balign 4, 0
