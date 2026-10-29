#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0076.h"

#define obj_D24R0205_gswoman1 0
#define obj_D24R0205_gsbigman 1
#define obj_D24R0205_gsoldman1 2
#define obj_D24R0205_gsassistantm 3
#define obj_D24R0205_gsassistantm_2 4
#define obj_D24R0205_gsassistantm_3 5
#define obj_D24R0205_gsassistantm_4 6
#define obj_D24R0205_suit 7

    ScriptEntry scr_seq_D24R0205_000
    ScriptEntry scr_seq_D24R0205_001
    ScriptEntry scr_seq_D24R0205_002
    ScriptEntry scr_seq_D24R0205_003
    ScriptEntry scr_seq_D24R0205_004
    ScriptEntry scr_seq_D24R0205_005
    ScriptEntry scr_seq_D24R0205_006
    ScriptEntry scr_seq_D24R0205_007
    ScriptEntry scr_seq_D24R0205_008
    ScriptEntry scr_seq_D24R0205_009
    ScriptEntryEnd
scr_seq_D24R0205_008:
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 10
    GoToIf 1, _003D
    GoTo _009D
_003D:
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x05
    CompareVar VAR_HGSS_UNK_4102, 1
    GoToIf 1, _0061
    CompareVar VAR_HGSS_UNK_4102, 2
    GoToIf 1, _007F
    GoTo _009D
_0061:
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_HALL_OF_ORIGIN, VAR_TEMP_x4005, VAR_TEMP_x4007
    CompareVar VAR_MAP_LOCAL_0x07, 1
    CallIf 1, _009F
    @ HGSS: NopVar490 VAR_TEMP_x4005
    @ HGSS: NopVar490 VAR_TEMP_x4007
    End
_007F:
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_MOVIE_GIFT, VAR_TEMP_x4005, VAR_TEMP_x4006
    CompareVar VAR_MAP_LOCAL_0x06, 1
    CallIf 1, _009F
    @ HGSS: NopVar490 VAR_TEMP_x4005
    @ HGSS: NopVar490 VAR_TEMP_x4006
    End
_009D:
    End
_009F:
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 11
    Return
scr_seq_D24R0205_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _018C
    @ HGSS: ScrCmd_374 obj_player
    WaitMovement
    @ HGSS: ScreenShake 0, 1, 1, 8
    GoToIfSet FLAG_HGSS_UNK_111, _016F
    GoToIfSet FLAG_HGSS_GOT_UNOWN_REPORT, _016F
    WaitTime 5, VAR_RESULT
    ApplyMovement obj_D24R0205_gsassistantm, _0194
    ApplyMovement obj_D24R0205_gsassistantm_2, _0194
    ApplyMovement obj_D24R0205_gsassistantm_3, _01B8
    ApplyMovement obj_D24R0205_gsassistantm_4, _01B8
    WaitMovement
    Message msg_0076_D24R0205_00000
    SetVar VAR_0x8004, ITEM_UNOWN_REPORT
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ApplyMovement obj_D24R0205_gsassistantm, _01A8
    ApplyMovement obj_D24R0205_gsassistantm_2, _01B0
    ApplyMovement obj_D24R0205_gsassistantm_3, _01CC
    ApplyMovement obj_D24R0205_gsassistantm_4, _01CC
    WaitMovement
    RemoveObject obj_D24R0205_gsassistantm
    RemoveObject obj_D24R0205_gsassistantm_2
    RemoveObject obj_D24R0205_gsassistantm_3
    RemoveObject obj_D24R0205_gsassistantm_4
    RemoveObject obj_D24R0205_gsbigman
    RemoveObject obj_D24R0205_gswoman1
    RemoveObject obj_D24R0205_gsoldman1
    SetFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_ASSISTANTS
    SetFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_TOURISTS
    SetFlag FLAG_HGSS_GOT_UNOWN_REPORT
    Message msg_0076_D24R0205_00001
    WaitButton
    CloseMessage
_016F:
    SetVarFromValue VAR_HGSS_UNK_40CE, 0
    ReleaseAll
    End
scr_seq_D24R0205_001:
    CompareVar VAR_HGSS_UNK_40CE, 1
    GoToIf 5, _018A
    ShowObject LOCALID_PLAYER
_018A:
    End
    .balign 4, 0
_018C:
    WarpIn
    EndMovement
    .balign 4, 0
_0194:
    FaceEast
    EmoteExclamationMark
    WalkNormalEast 5
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_01A8:
    WalkNormalWest 10
    EndMovement
    .balign 4, 0
_01B0:
    WalkNormalNorth 10
    EndMovement
    .balign 4, 0
_01B8:
    FaceWest
    EmoteExclamationMark
    WalkNormalWest 5
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_01CC:
    WalkNormalEast 10
    EndMovement
scr_seq_D24R0205_006:
    LockAll
    ApplyMovement obj_D24R0205_suit, _02B0
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _02FC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0076_D24R0205_00006
    CloseMessage
    ApplyMovement obj_D24R0205_suit, _02BC
    WaitMovement
    Message msg_0076_D24R0205_00007
    CloseMessage
    FadeOutBGM 0, 30
    FadeScreen 6, 6, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 1, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement obj_D24R0205_suit, _02E4
    WaitMovement
    Message msg_0076_D24R0205_00008
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
_02B0:
    WalkNormalWest 4
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_02BC:
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
_02E4:
    WalkOnSpotNormalEast
    Delay8
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02FC:
    WalkNormalWest 4
    EndMovement
scr_seq_D24R0205_007:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D24R0205_suit, _0368
    ApplyMovement LOCALID_PLAYER, _0398
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_PLAYER, _0390
    WaitMovement
    Message msg_0076_D24R0205_00009
    CloseMessage
    ApplyMovement obj_D24R0205_suit, _0380
    WaitMovement
    Message msg_0076_D24R0205_00010
    CloseMessage
    ApplyMovement obj_D24R0205_suit, _0388
    WaitMovement
    RemoveObject obj_D24R0205_suit
    SetFlag FLAG_HGSS_HIDE_ALPH_MAIN_CHAMBER_ARCEUS_EVENT_PEOPLE
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 10
    ReleaseAll
    End
    .balign 4, 0
_0368:
    Delay8
    WalkOnSpotNormalWest
    EmoteExclamationMark
    Delay8
    WalkFastWest 3
    EndMovement
    .balign 4, 0
_0380:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0388:
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
_0390:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0398:
    WalkNormalEast
    EndMovement
scr_seq_D24R0205_009:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _045C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    FadeScreen 6, 6, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 1, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement LOCALID_PLAYER, _0468
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
_045C:
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0468:
    WalkOnSpotNormalEast
    Delay8
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_D24R0205_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0076_D24R0205_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D24R0205_003:
    NPCMessage msg_0076_D24R0205_00002
    End
scr_seq_D24R0205_004:
    NPCMessage msg_0076_D24R0205_00003
    End
scr_seq_D24R0205_005:
    NPCMessage msg_0076_D24R0205_00004
    End
    .balign 4, 0
