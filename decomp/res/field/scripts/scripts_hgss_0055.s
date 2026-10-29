#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0086.h"

#define obj_D24R0218_suit 0

    ScriptEntry scr_seq_D24R0218_000
    ScriptEntry scr_seq_D24R0218_001
    ScriptEntry scr_seq_D24R0218_002
    ScriptEntry scr_seq_D24R0218_003
    ScriptEntry scr_seq_D24R0218_004
    ScriptEntry scr_seq_D24R0218_005
    ScriptEntry scr_seq_D24R0218_006
    ScriptEntryEnd
scr_seq_D24R0218_004:
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 10
    GoToIf 1, _0035
    GoTo _0095
_0035:
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x05
    CompareVar VAR_HGSS_UNK_4102, 1
    GoToIf 1, _0059
    CompareVar VAR_HGSS_UNK_4102, 2
    GoToIf 1, _0077
    GoTo _0095
_0059:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    CompareVar VAR_MAP_LOCAL_0x07, 1
    CallIf 1, _0097
    End
_0077:
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
    CompareVar VAR_MAP_LOCAL_0x06, 1
    CallIf 1, _0097
    End
_0095:
    End
_0097:
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 11
    Return
scr_seq_D24R0218_001:
    LockAll
    ApplyMovement obj_D24R0218_suit, _0178
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _01C4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0086_D24R0218_00001
    CloseMessage
    ApplyMovement obj_D24R0218_suit, _0184
    WaitMovement
    Message msg_0086_D24R0218_00002
    CloseMessage
    FadeOutBGM 0, 30
    FadeScreen 6, 6, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 1, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement obj_D24R0218_suit, _01AC
    WaitMovement
    Message msg_0086_D24R0218_00003
    CloseMessage
    FadeScreen 6, 6, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 1, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 3
    SetFlag FLAG_HGSS_HIDE_ALPH_OUTSIDE_ARCEUS_EVENT_SUIT
    SetFlag FLAG_HGSS_HIDE_ALPH_MAIN_CHAMBER_ARCEUS_EVENT_PEOPLE
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SINJOH_RUINS_MYSTRI_STAGE, 16, 24, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0178:
    WalkNormalWest 4
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0184:
    EmoteExclamationMark
    Delay8
    WalkFastNorth 3
    WalkOnSpotNormalNorth
    WalkFastWest 2
    WalkOnSpotNormalNorth
    LockDir
    WalkSlowWest
    UnlockDir
    EndMovement
    .balign 4, 0
_01AC:
    WalkOnSpotNormalEast
    Delay8
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01C4:
    WalkNormalWest 4
    EndMovement
scr_seq_D24R0218_002:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D24R0218_suit, _0230
    ApplyMovement LOCALID_PLAYER, _0260
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_PLAYER, _0258
    WaitMovement
    Message msg_0086_D24R0218_00004
    CloseMessage
    ApplyMovement obj_D24R0218_suit, _0248
    WaitMovement
    Message msg_0086_D24R0218_00005
    CloseMessage
    ApplyMovement obj_D24R0218_suit, _0250
    WaitMovement
    RemoveObject obj_D24R0218_suit
    SetFlag FLAG_HGSS_HIDE_ALPH_MAIN_CHAMBER_ARCEUS_EVENT_PEOPLE
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 10
    ReleaseAll
    End
    .balign 4, 0
_0230:
    Delay8
    WalkOnSpotNormalWest
    EmoteExclamationMark
    Delay8
    WalkFastWest 3
    EndMovement
    .balign 4, 0
_0248:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0250:
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
_0258:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0260:
    WalkNormalEast
    EndMovement
scr_seq_D24R0218_003:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0324
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    FadeScreen 6, 6, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 1, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement LOCALID_PLAYER, _0330
    WaitMovement
    FadeScreen 6, 6, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 1, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 12
    SetVarFromValue VAR_HGSS_UNK_4104, 1
    SetFlag FLAG_HGSS_HIDE_SINJOH_MYSTRI_SHRINE_CYNTHIA
    SetFlag FLAG_HGSS_UNK_2DD
    SetFlag FLAG_HGSS_UNK_2DB
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SINJOH_RUINS_MYSTRI_STAGE, 16, 24, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0324:
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0330:
    WalkOnSpotNormalEast
    Delay8
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_D24R0218_006:
    LockAll
    ApplyMovement LOCALID_PLAYER, _038C
    @ HGSS: ScrCmd_374 obj_player
    WaitMovement
    CompleteScreenShake 0, 1, 1, 8
    SetVarFromValue VAR_HGSS_UNK_40CE, 0
    ReleaseAll
    End
scr_seq_D24R0218_005:
    CompareVar VAR_HGSS_UNK_40CE, 1
    GoToIf 5, _0387
    ShowObject LOCALID_PLAYER
_0387:
    End
    .balign 4, 0
_038C:
    WarpIn
    EndMovement
scr_seq_D24R0218_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0086_D24R0218_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
