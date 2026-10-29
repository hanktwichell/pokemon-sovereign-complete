#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0072.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D24R0101_gsmiddleman1 8
#define obj_D24R0101_suit 9

    ScriptEntry scr_seq_D24R0101_000
    ScriptEntry scr_seq_D24R0101_001
    ScriptEntry scr_seq_D24R0101_002
    ScriptEntry scr_seq_D24R0101_003
    ScriptEntry scr_seq_D24R0101_004
    ScriptEntry scr_seq_D24R0101_005
    ScriptEntry scr_seq_D24R0101_006
    ScriptEntry scr_seq_D24R0101_007
    ScriptEntryEnd
scr_seq_D24R0101_006:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _005E
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _0080
_003C:
    SetWarpEventPos 11, 418, 284
    SetWarpEventPos 12, 419, 284
    SetWarpEventPos 13, 418, 284
    SetWarpEventPos 14, 419, 284
    End
_005E:
    SetWarpEventPos 8, 418, 284
    SetWarpEventPos 9, 419, 284
    SetWarpEventPos 11, 418, 284
    SetWarpEventPos 12, 419, 284
    End
_0080:
    SetWarpEventPos 8, 418, 284
    SetWarpEventPos 9, 419, 284
    SetWarpEventPos 13, 418, 284
    SetWarpEventPos 14, 419, 284
    End
scr_seq_D24R0101_005:
    GoToIfUnset FLAG_HGSS_UNK_189, _00B3
    ClearFlag FLAG_HGSS_UNK_189
    End
_00B3:
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 9
    GoToIf 4, _00C6
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 1
_00C6:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0104
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _010E
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _010E
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _010E
_0104:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0112
_010E:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
_0112:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _005E
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _0080
    GoTo _003C
    End
scr_seq_D24R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0239
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _024D
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01AD
    ApplyMovement LOCALID_PLAYER, _0264
    ApplyMovement obj_D24R0101_gsmiddleman1, _029C
    GoTo _01D8
_01AD:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01C8
    ApplyMovement LOCALID_PLAYER, _027C
    GoTo _01D8
_01C8:
    ApplyMovement LOCALID_PLAYER, _0288
    ApplyMovement obj_D24R0101_gsmiddleman1, _029C
_01D8:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01FF
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02A8
    WaitMovement
_01FF:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 3
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
_0239:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_024D:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0264:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_027C:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0288:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_029C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_02A8:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_D24R0101_007:
    LockAll
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x05
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_MOVIE_GIFT, VAR_TEMP_x4005, VAR_TEMP_x4006
    CompareVar VAR_MAP_LOCAL_0x06, 0
    GoToIf 1, _02DA
    GoTo _02EE
_02DA:
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_HALL_OF_ORIGIN, VAR_TEMP_x4005, VAR_TEMP_x4007
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 1, _0530
_02EE:
    @ HGSS: PlayerOnBikeCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0530
    @ HGSS: ScrCmd_307 13, 8, 25, 29, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ClearFlag FLAG_HGSS_HIDE_ALPH_OUTSIDE_ARCEUS_EVENT_SUIT
    AddObject obj_D24R0101_suit
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    ApplyMovement obj_D24R0101_suit, _0534
    ApplyMovement LOCALID_PLAYER, _05C4
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _0350
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _05DC
    GoTo _0373
_0350:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _036B
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _05F4
    GoTo _0373
_036B:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0604
_0373:
    WaitMovement
    Message msg_0072_D24R0101_00001
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _054C
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _039D
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0614
    GoTo _03C0
_039D:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _03B8
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0624
    GoTo _03C0
_03B8:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0630
_03C0:
    WaitMovement
    Message msg_0072_D24R0101_00002
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _03E2
    ApplyMovement obj_D24R0101_suit, _0554
    GoTo _03EA
_03E2:
    ApplyMovement obj_D24R0101_suit, _0570
_03EA:
    WaitMovement
    Message msg_0072_D24R0101_00003
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _0584
    WaitMovement
    Message msg_0072_D24R0101_00004
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _05A4
    WaitMovement
    Message msg_0072_D24R0101_00005
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _05B4
    WaitMovement
    Message msg_0072_D24R0101_00006
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 2
    SetFlag FLAG_HGSS_HIDE_ALPH_OUTSIDE_ARCEUS_EVENT_SUIT
    ClearFlag FLAG_HGSS_HIDE_ALPH_MAIN_CHAMBER_ARCEUS_EVENT_PEOPLE
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 5, _0467
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _0530
_0467:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 5, _049E
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _0530
_049E:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 8
    GoToIf 5, _04D5
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _0530
_04D5:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 9
    GoToIf 5, _050C
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _0530
_050C:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0530:
    ReleaseAll
    End
    .balign 4, 0
_0534:
    Delay4
    WalkFastSouth 3
    LockDir
    WalkFasterNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_054C:
    WalkFastSouth
    EndMovement
    .balign 4, 0
_0554:
    WalkOnSpotFastWest
    EmoteExclamationMark
    Delay8
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_0570:
    EmoteExclamationMark
    Delay8
    WalkNormalEast
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_0584:
    WalkNormalEast
    WalkNormalWest 2
    Delay8
    WalkNormalEast 2
    WalkOnSpotFastEast
    WalkNormalWest
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_05A4:
    EmoteExclamationMark
    Delay8
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_05B4:
    WalkNormalWest
    WalkNormalSouth
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_05C4:
    LockDir
    JumpFarSouth
    WalkFastSouth 2
    UnlockDir
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05DC:
    LockDir
    WalkFastWest
    UnlockDir
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05F4:
    JumpOnSpotFastWest
    Delay8 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0604:
    LockDir
    WalkFastSouth 5
    UnlockDir
    EndMovement
    .balign 4, 0
_0614:
    WalkNormalSouth 3
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0624:
    WalkNormalSouth 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0630:
    Delay8 2
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth
    EndMovement
scr_seq_D24R0101_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0072_D24R0101_00010, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D24R0101_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0072_D24R0101_00009, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D24R0101_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0072_D24R0101_00007, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D24R0101_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0072_D24R0101_00008, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
