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
    ScriptEntry scr_seq_D24R0101_008
    ScriptEntryEnd
scr_seq_D24R0101_006:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _0167
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _0189
    SetWarpEventPos 11, 418, 284
    SetWarpEventPos 12, 419, 284
    SetWarpEventPos 13, 418, 284
    SetWarpEventPos 14, 419, 284
    End
scr_seq_D24R0101_005:
    GoToIfUnset FLAG_HGSS_UNK_189, _01AB
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D24R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0206
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021A
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _022E
    ApplyMovement LOCALID_PLAYER, _0796
    ApplyMovement obj_D24R0101_gsmiddleman1, _07AC
    GoTo _0249
scr_seq_D24R0101_007:
    LockAll
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x05
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
    CompareVar VAR_MAP_LOCAL_0x06, 0
    GoToIf 1, _02AA
    GoTo _0320
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
scr_seq_D24R0101_008:
    BufferPlayerName 0
    End
_0167:
    SetWarpEventPos 8, 418, 284
    SetWarpEventPos 9, 419, 284
    SetWarpEventPos 11, 418, 284
    SetWarpEventPos 12, 419, 284
    End
_0189:
    SetWarpEventPos 8, 418, 284
    SetWarpEventPos 9, 419, 284
    SetWarpEventPos 13, 418, 284
    SetWarpEventPos 14, 419, 284
    End
_01AB:
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 9
    GoToIf 4, _0382
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 1
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _03CA
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _03D4
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _03D4
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _03D4
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _03F8
_0206:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_021A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_022E:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0418
    ApplyMovement LOCALID_PLAYER, _07B6
    GoTo _0249
_0249:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0489
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _07C0
    WaitMovement
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
_02AA:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 1, _04C3
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04C3
    LoadDoorAnimation 13, 8, 25, 29, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ClearFlag FLAG_HGSS_HIDE_ALPH_OUTSIDE_ARCEUS_EVENT_SUIT
    AddObject obj_D24R0101_suit
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    ApplyMovement obj_D24R0101_suit, _07CE
    ApplyMovement LOCALID_PLAYER, _07E4
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _04C7
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _07FA
    GoTo _04E2
_0320:
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04C3
    LoadDoorAnimation 13, 8, 25, 29, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ClearFlag FLAG_HGSS_HIDE_ALPH_OUTSIDE_ARCEUS_EVENT_SUIT
    AddObject obj_D24R0101_suit
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    ApplyMovement obj_D24R0101_suit, _07CE
    ApplyMovement LOCALID_PLAYER, _07E4
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _04C7
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _07FA
    GoTo _04E2
_0382:
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _03CA
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _03D4
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _03D4
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _03D4
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _03F8
_03CA:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _03F8
_03D4:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _0167
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _0189
    GoTo _050C
_03F8:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _0167
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _0189
    GoTo _050C
_0418:
    ApplyMovement LOCALID_PLAYER, _0810
    ApplyMovement obj_D24R0101_gsmiddleman1, _07AC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0489
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _07C0
    WaitMovement
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
_0489:
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
_04C3:
    ReleaseAll
    End
_04C7:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _052E
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0822
    GoTo _04E2
_04E2:
    WaitMovement
    Message msg_0072_D24R0101_00001
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _0830
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _0560
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0836
    GoTo _057B
_050C:
    SetWarpEventPos 11, 418, 284
    SetWarpEventPos 12, 419, 284
    SetWarpEventPos 13, 418, 284
    SetWarpEventPos 14, 419, 284
    End
_052E:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0844
    WaitMovement
    Message msg_0072_D24R0101_00001
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _0830
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _0560
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0836
    GoTo _057B
_0560:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _059D
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0852
    GoTo _057B
_057B:
    WaitMovement
    Message msg_0072_D24R0101_00002
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _05C7
    ApplyMovement obj_D24R0101_suit, _085C
    GoTo _064C
_059D:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0876
    WaitMovement
    Message msg_0072_D24R0101_00002
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _05C7
    ApplyMovement obj_D24R0101_suit, _085C
    GoTo _064C
_05C7:
    ApplyMovement obj_D24R0101_suit, _0888
    WaitMovement
    Message msg_0072_D24R0101_00003
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _089A
    WaitMovement
    Message msg_0072_D24R0101_00004
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _08B8
    WaitMovement
    Message msg_0072_D24R0101_00005
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _08C6
    WaitMovement
    Message msg_0072_D24R0101_00006
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 2
    SetFlag FLAG_HGSS_HIDE_ALPH_OUTSIDE_ARCEUS_EVENT_SUIT
    ClearFlag FLAG_HGSS_HIDE_ALPH_MAIN_CHAMBER_ARCEUS_EVENT_PEOPLE
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 5, _06C9
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _04C3
_064C:
    WaitMovement
    Message msg_0072_D24R0101_00003
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _089A
    WaitMovement
    Message msg_0072_D24R0101_00004
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _08B8
    WaitMovement
    Message msg_0072_D24R0101_00005
    CloseMessage
    ApplyMovement obj_D24R0101_suit, _08C6
    WaitMovement
    Message msg_0072_D24R0101_00006
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 2
    SetFlag FLAG_HGSS_HIDE_ALPH_OUTSIDE_ARCEUS_EVENT_SUIT
    ClearFlag FLAG_HGSS_HIDE_ALPH_MAIN_CHAMBER_ARCEUS_EVENT_PEOPLE
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 5, _06C9
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _04C3
_06C9:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 5, _0700
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _04C3
_0700:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 8
    GoToIf 5, _0737
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _04C3
_0737:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 9
    GoToIf 5, _076E
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _04C3
_076E:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 15, 24, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0796:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_07AC:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07B6:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_07C0:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_07CE:
    Delay4
    WalkFastSouth 3
    LockDir
    WalkFasterNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_07E4:
    LockDir
    JumpFarSouth
    WalkFastSouth 2
    UnlockDir
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07FA:
    LockDir
    WalkFastWest
    UnlockDir
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0810:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0822:
    JumpOnSpotFastWest
    Delay8 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0830:
    WalkFastSouth
    EndMovement
    .balign 4, 0
_0836:
    WalkNormalSouth 3
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0844:
    LockDir
    WalkFastSouth 5
    UnlockDir
    EndMovement
    .balign 4, 0
_0852:
    WalkNormalSouth 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_085C:
    WalkOnSpotFastWest
    EmoteExclamationMark
    Delay8
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_0876:
    Delay8 2
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0888:
    EmoteExclamationMark
    Delay8
    WalkNormalEast
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_089A:
    WalkNormalEast
    WalkNormalWest 2
    Delay8
    WalkNormalEast 2
    WalkOnSpotFastEast
    WalkNormalWest
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_08B8:
    EmoteExclamationMark
    Delay8
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_08C6:
    WalkNormalWest
    WalkNormalSouth
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
