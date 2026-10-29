#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0326.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_R03_000
    ScriptEntry scr_seq_R03_001
    ScriptEntry scr_seq_R03_002
    ScriptEntry scr_seq_R03_003
    ScriptEntry scr_seq_R03_004
    ScriptEntry scr_seq_R03_005
    ScriptEntry scr_seq_R03_006
    ScriptEntry scr_seq_R03_007
    ScriptEntryEnd
scr_seq_R03_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_517 SPECIES_DEOXYS, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _021A
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 386
    GoToIf 1, _0225
    @ HGSS: ScrCmd_518 3
    GoTo _0273
scr_seq_R03_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_517 SPECIES_DEOXYS, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _021A
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 386
    GoToIf 1, _0282
    @ HGSS: ScrCmd_518 2
    GoTo _02D0
scr_seq_R03_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_517 SPECIES_DEOXYS, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _021A
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 386
    GoToIf 1, _02DF
    @ HGSS: ScrCmd_518 1
    GoTo _0345
scr_seq_R03_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_517 SPECIES_DEOXYS, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _021A
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 386
    GoToIf 1, _0354
    @ HGSS: ScrCmd_518 0
    GoTo _03BE
scr_seq_R03_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0326_R03_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R03_005:
    NPCMessage msg_0326_R03_00006
    End
scr_seq_R03_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    AddObject 20
    BufferPlayerName 0
    BufferPartyMonSpecies 1, 0
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03D1
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03FC
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0433
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06C6
    WaitMovement
    Message msg_0326_R03_00007
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _045E
    GetTimeOfDay VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 0, _045E
    GoTo _0469
scr_seq_R03_007:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0497
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0497
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0497
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    AddObject 20
    BufferPlayerName 0
    BufferPartyMonSpecies 1, 0
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06C6
    WaitMovement
    Message msg_0326_R03_00007
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _045E
    GetTimeOfDay VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 0, _045E
    GoTo _0499
_021A:
    Message msg_0326_R03_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0225:
    @ HGSS: ScrCmd_518 3
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_ROUTE_3, VAR_0x8006, VAR_0x8007, VAR_RESULT
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04F9
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0514
    @ HGSS: ScrCmd_605 0, 1
    GoTo _0543
_0273:
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00002
    GoTo _056E
_0282:
    @ HGSS: ScrCmd_518 2
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_ROUTE_3, VAR_0x8006, VAR_0x8007, VAR_RESULT
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0578
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0593
    @ HGSS: ScrCmd_605 0, 1
    GoTo _05AA
_02D0:
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00003
    GoTo _056E
_02DF:
    @ HGSS: ScrCmd_518 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_ROUTE_3, VAR_0x8006, VAR_0x8007, VAR_RESULT
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05D5
    @ HGSS: ScrCmd_605 2, 3
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00004
    GoTo _056E
_0345:
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00004
    GoTo _056E
_0354:
    @ HGSS: ScrCmd_518 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_ROUTE_3, VAR_0x8006, VAR_0x8007, VAR_RESULT
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05F0
    @ HGSS: ScrCmd_605 3, 2
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00005
    WaitButton
    WaitCry
    CloseMessage
    ReleaseAll
    End
_03BE:
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00005
    WaitButton
    WaitCry
    CloseMessage
    ReleaseAll
    End
_03D1:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06F0
    WaitMovement
    Message msg_0326_R03_00007
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _045E
    Message msg_0326_R03_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03FC:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _071A
    WaitMovement
    Message msg_0326_R03_00007
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _045E
    GetTimeOfDay VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _045E
    GoTo _0499
_0433:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0744
    WaitMovement
    Message msg_0326_R03_00007
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _045E
    Message msg_0326_R03_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_045E:
    Message msg_0326_R03_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0469:
    CloseMessage
    PlayCry SPECIES_DEOXYS, 0
    SetPosition 20, 1097, 0, 107, DIR_NORTH
    WaitCry
    ApplyMovement 20, _076E
    WaitMovement
    PlayCry SPECIES_DEOXYS, 0
    WaitCry
    GoTo _060F
_0497:
    End
_0499:
    CloseMessage
    PlayCry SPECIES_DEOXYS, 0
    SetPosition 20, 1097, 0, 107, DIR_NORTH
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0774
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _077A
    WaitMovement
    ApplyMovement 20, _0780
    WaitMovement
    PlayCry SPECIES_DEOXYS, 0
    WaitCry
    ApplyMovement 20, _0786
    WaitMovement
    GoTo _060F
_04F9:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00002
    GoTo _056E
_0514:
    @ HGSS: ScrCmd_605 3, 2
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00002
    GoTo _056E
_0543:
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry 1410, 0
    Message msg_0326_R03_00002
    GoTo _056E
_056E:
    WaitButton
    WaitCry
    CloseMessage
    ReleaseAll
    End
_0578:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00003
    GoTo _056E
_0593:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0674
    @ HGSS: ScrCmd_605 0, 1
    GoTo _05AA
_05AA:
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00003
    GoTo _056E
_05D5:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00004
    GoTo _056E
_05F0:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00005
    WaitButton
    WaitCry
    CloseMessage
    ReleaseAll
    End
_060F:
    CompleteStartWildBattle SPECIES_DEOXYS, 60, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06A3
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 20
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _06A9
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 1, _06B8
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _06A9
    ReleaseAll
    End
_0674:
    @ HGSS: ScrCmd_605 3, 2
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00003
    GoTo _056E
_06A3:
    BlackOutFromBattle
    ReleaseAll
    End
_06A9:
    Message msg_0326_R03_00009
    ClearFlag FLAG_HGSS_SG_3FB4
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06B8:
    SetFlag FLAG_HGSS_SG_3F8C
    SetVarFromValue VAR_HGSS_SG_6132, 2
    ReleaseAll
    End
    .balign 4, 0
_06C6:
    EmoteExclamationMark
    JumpOnSpotFastEast 2
    FaceSouth 2
    WalkOnSpotNormalSouth
    FaceWest 2
    WalkOnSpotNormalWest
    FaceNorth 2
    WalkOnSpotNormalNorth
    FaceEast 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_06F0:
    EmoteExclamationMark
    JumpOnSpotFastNorth 2
    FaceWest 2
    WalkOnSpotNormalWest
    FaceSouth 2
    WalkOnSpotNormalSouth
    FaceEast 2
    WalkOnSpotNormalEast
    FaceNorth 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_071A:
    EmoteExclamationMark
    JumpOnSpotFastSouth 2
    FaceWest 2
    WalkOnSpotNormalWest
    FaceNorth 2
    WalkOnSpotNormalNorth
    FaceEast 2
    WalkOnSpotNormalEast
    FaceSouth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0744:
    EmoteExclamationMark
    JumpOnSpotFastWest 2
    FaceNorth 2
    WalkOnSpotNormalNorth
    FaceEast 2
    WalkOnSpotNormalEast
    FaceSouth 2
    WalkOnSpotNormalSouth
    FaceWest 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_076E:
    WalkFastSouth 9
    EndMovement
    .balign 4, 0
_0774:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_077A:
    FaceNorth
    EndMovement
    .balign 4, 0
_0780:
    WalkFastSouth 5
    EndMovement
    .balign 4, 0
_0786:
    WalkFastSouth 3
    EndMovement
    .balign 4, 0
