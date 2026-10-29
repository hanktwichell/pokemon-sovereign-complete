#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0122.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D39R0101_gsmiddleman1 1
#define obj_D39R0101_dancer 2
#define obj_D39R0101_gsmiddleman1_2 5

    ScriptEntry scr_seq_D39R0101_000
    ScriptEntry scr_seq_D39R0101_001
    ScriptEntry scr_seq_D39R0101_002
    ScriptEntry scr_seq_D39R0101_003
    ScriptEntry scr_seq_D39R0101_004
    ScriptEntryEnd
scr_seq_D39R0101_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _0144
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D39R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4100, 1
    GoToIf 1, _0168
    GoToIfSet FLAG_HGSS_HIDE_ITEMBALL_D39R0101_HM07, _0173
    Message msg_0122_D39R0101_00001
    CloseMessage
    ApplyMovement obj_D39R0101_gsmiddleman1, _03E2
    WaitMovement
    ReleaseAll
    End
scr_seq_D39R0101_004:
    LockAll
    GoToIfSet FLAG_HGSS_HIDE_ITEMBALL_D39R0101_HM07, _0184
    ApplyMovement obj_D39R0101_gsmiddleman1, _03E8
    ApplyMovement LOCALID_PLAYER, _03F2
    WaitMovement
    Message msg_0122_D39R0101_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D39R0101_gsmiddleman1, _03E2
    ApplyMovement LOCALID_PLAYER, _03FC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
scr_seq_D39R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01A7
    GoTo _01B9
scr_seq_D39R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E3
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01F7
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _020B
    ApplyMovement LOCALID_PLAYER, _0402
    ApplyMovement obj_D39R0101_gsmiddleman1_2, _0418
    GoTo _0226
_0144:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0287
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0287
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0168:
    Message msg_0122_D39R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0173:
    SetVarFromValue VAR_HGSS_UNK_4100, 1
    Message msg_0122_D39R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0184:
    ApplyMovement obj_D39R0101_gsmiddleman1, _03E8
    ApplyMovement LOCALID_PLAYER, _03F2
    WaitMovement
    Message msg_0122_D39R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4100, 1
    End
_01A7:
    BufferPlayerName 0
    Message msg_0122_D39R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    Common_FadeToDefaultMusic
    End
_01B9:
    BufferPlayerName 0
    Message msg_0122_D39R0101_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _028D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02ED
    End
_01E3:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01F7:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_020B:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0314
    ApplyMovement LOCALID_PLAYER, _0422
    GoTo _0226
_0226:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0337
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _042C
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 43
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
_0287:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
_028D:
    PlaySE SEQ_SE_DP_WALL_HIT_sseq
    Message msg_0122_D39R0101_00005
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement obj_D39R0101_dancer, _043A
    ApplyMovement 241, _0458
    WaitMovement
    Message msg_0122_D39R0101_00007
    CloseMessage
    ApplyMovement obj_D39R0101_dancer, _045E
    WaitMovement
    RemoveObject obj_D39R0101_dancer
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    Common_FadeToDefaultMusic
    SetFlag FLAG_HGSS_UNK_239
    SetVarFromValue VAR_HGSS_UNK_40E8, 1
    ApplyMovement 241, _0464
    WaitMovement
    RestoreCamera
    ReleaseAll
    End
_02ED:
    Message msg_0122_D39R0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _028D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02ED
    End
_0314:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0371
    ApplyMovement LOCALID_PLAYER, _046A
    ApplyMovement obj_D39R0101_gsmiddleman1_2, _0418
    GoTo _0226
_0337:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 43
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
_0371:
    ApplyMovement LOCALID_PLAYER, _047C
    ApplyMovement obj_D39R0101_gsmiddleman1_2, _0418
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0337
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _042C
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 43
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
_03E2:
    FaceSouth
    EndMovement
    .balign 4, 0
_03E8:
    FaceNorth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03F2:
    Delay8 2
    FaceSouth
    EndMovement
    .balign 4, 0
_03FC:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0402:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0418:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0422:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_042C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_043A:
    PauseAnimation 0
    WalkFastSouth 5
    ResumeAnimation 0
    WalkNormalSouth 2
    WalkOnSpotNormalSouth
    Delay8
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_0458:
    WalkFastSouth 4
    EndMovement
    .balign 4, 0
_045E:
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_0464:
    WalkFastNorth 4
    EndMovement
    .balign 4, 0
_046A:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_047C:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
