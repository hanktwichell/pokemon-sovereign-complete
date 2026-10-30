#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0079.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D24R0211_gsassistantm 0
#define obj_D24R0211_gsmiddleman1 1
#define obj_D24R0211_gsmiddleman1_2 2

    ScriptEntry scr_seq_D24R0211_000
    ScriptEntry scr_seq_D24R0211_001
    ScriptEntry scr_seq_D24R0211_002
    ScriptEntry scr_seq_D24R0211_003
    ScriptEntry scr_seq_D24R0211_004
    ScriptEntryEnd
scr_seq_D24R0211_003:
    GoToIfUnset FLAG_HGSS_UNK_189, _0027
    ClearFlag FLAG_HGSS_UNK_189
    End
_0027:
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0065
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _006B
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _006B
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _006B
_0065:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_006B:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_D24R0211_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0079_D24R0211_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D24R0211_001:
    LockAll
    SetPosition obj_D24R0211_gsassistantm, 25, 0, 30, DIR_NORTH
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0120
    ApplyMovement obj_D24R0211_gsassistantm, _0144
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    WaitTime 15, VAR_0x8005
    Message msg_0079_D24R0211_00001
    ApplyMovement obj_D24R0211_gsassistantm, _0160
    WaitMovement
    Message msg_0079_D24R0211_00002
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_RESEARCH_CENTER, 7, 4, DIR_EAST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteSetObjectDir 2, 2
    Message msg_0079_D24R0211_00003
    @ HGSS: ScrCmd_527 4
    Message msg_0079_D24R0211_00005
    BufferPlayerName 0
    Message msg_0079_D24R0211_00006
    PlayFanfare SEQ_ME_LVUP_sseq
    WaitFanfare
    AddVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0120:
    Delay4
    WalkNormalEast
    FaceSouth
    EmoteExclamationMark
    WalkNormalEast
    WalkNormalSouth 2
    WalkNormalWest 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0144:
    Delay8 4
    WalkFastNorth 4
    WalkFastEast
    WalkFastNorth 6
    WalkFastWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0160:
    FaceSouth
    EndMovement
scr_seq_D24R0211_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0290
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02A4
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01E1
    ApplyMovement LOCALID_PLAYER, _02B8
    ApplyMovement obj_D24R0211_gsmiddleman1, _0304
    GoTo _022F
_01E1:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01FC
    ApplyMovement LOCALID_PLAYER, _02D0
    GoTo _022F
_01FC:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _021F
    ApplyMovement LOCALID_PLAYER, _02F0
    ApplyMovement obj_D24R0211_gsmiddleman1, _0304
    GoTo _022F
_021F:
    ApplyMovement LOCALID_PLAYER, _02DC
    ApplyMovement obj_D24R0211_gsmiddleman1, _0304
_022F:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0256
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0310
    WaitMovement
_0256:
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
_0290:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02A4:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_02B8:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02D0:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02DC:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02F0:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0304:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0310:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_D24R0211_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0290
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02A4
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0399
    ApplyMovement LOCALID_PLAYER, _02B8
    ApplyMovement obj_D24R0211_gsmiddleman1_2, _0304
    GoTo _03E7
_0399:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _03B4
    ApplyMovement LOCALID_PLAYER, _02D0
    GoTo _03E7
_03B4:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _03D7
    ApplyMovement LOCALID_PLAYER, _02F0
    ApplyMovement obj_D24R0211_gsmiddleman1_2, _0304
    GoTo _03E7
_03D7:
    ApplyMovement LOCALID_PLAYER, _02DC
    ApplyMovement obj_D24R0211_gsmiddleman1_2, _0304
_03E7:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _040E
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0310
    WaitMovement
_040E:
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
    .balign 4, 0
