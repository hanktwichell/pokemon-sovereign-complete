#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0137.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D49_thlonowner 0
#define obj_D49_tsure_poke_static_poliwrath 1
#define obj_D49_gsboy2 2
#define obj_D49_tsure_poke_static_oddish 8
#define obj_D49_gsmiddleman1 16
#define obj_D49_gsmiddleman1_2 17
#define obj_D49_shopm1_2 18

    ScriptEntry scr_seq_D49_000
    ScriptEntry scr_seq_D49_001
    ScriptEntry scr_seq_D49_002
    ScriptEntry scr_seq_D49_003
    ScriptEntry scr_seq_D49_004
    ScriptEntry scr_seq_D49_005
    ScriptEntry scr_seq_D49_006
    ScriptEntry scr_seq_D49_007
    ScriptEntry scr_seq_D49_008
    ScriptEntry scr_seq_D49_009
    ScriptEntry scr_seq_D49_010
    ScriptEntry scr_seq_D49_011
    ScriptEntry scr_seq_D49_012
    ScriptEntry scr_seq_D49_013
    ScriptEntry scr_seq_D49_014
    ScriptEntry scr_seq_D49_015
    ScriptEntry scr_seq_D49_016
    ScriptEntry scr_seq_D49_017
    ScriptEntry scr_seq_D49_018
    ScriptEntry scr_seq_D49_019
    ScriptEntry scr_seq_D49_020
    ScriptEntry scr_seq_D49_021
    ScriptEntry scr_seq_D49_022
    ScriptEntry scr_seq_D49_023
    ScriptEntryEnd
scr_seq_D49_018:
    GoToIfUnset FLAG_HGSS_UNK_189, _0073
    ClearFlag FLAG_HGSS_UNK_189
    End
_0073:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _00C2
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _00C2
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _00C2
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _00CC
    CompareVar VAR_HGSS_UNK_40DB, 0
    GoToIf 1, _00CC
    SetFlag FLAG_HGSS_HIDE_CAMERON
    ClearFlag FLAG_HGSS_UNK_27F
    End
_00C2:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    End
_00CC:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    End
scr_seq_D49_000:
    LockAll
    ReleaseObject obj_D49_tsure_poke_static_oddish
    ReleaseObject obj_D49_gsboy2
    ApplyMovement obj_D49_thlonowner, _0414
    WaitMovement
    Message msg_0137_D49_00000
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 40
    GoToIf 5, _011A
    ApplyMovement obj_D49_thlonowner, _043C
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _04A8
    GoTo _01D9
_011A:
    CompareVar VAR_MAP_LOCAL_0x00, 41
    GoToIf 5, _013D
    ApplyMovement obj_D49_thlonowner, _044C
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _04BC
    GoTo _01D9
_013D:
    CompareVar VAR_MAP_LOCAL_0x00, 42
    GoToIf 5, _0160
    ApplyMovement obj_D49_thlonowner, _045C
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _04D0
    GoTo _01D9
_0160:
    CompareVar VAR_MAP_LOCAL_0x00, 43
    GoToIf 5, _0183
    ApplyMovement obj_D49_thlonowner, _0464
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _04DC
    GoTo _01D9
_0183:
    CompareVar VAR_MAP_LOCAL_0x00, 44
    GoToIf 5, _01A6
    ApplyMovement obj_D49_thlonowner, _0474
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _04F0
    GoTo _01D9
_01A6:
    CompareVar VAR_MAP_LOCAL_0x00, 39
    GoToIf 5, _01C9
    ApplyMovement obj_D49_thlonowner, _042C
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _0494
    GoTo _01D9
_01C9:
    ApplyMovement obj_D49_thlonowner, _0484
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _0504
_01D9:
    WaitMovement
    Message msg_0137_D49_00006
    CloseMessage
    ApplyMovement obj_D49_thlonowner, _0424
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _0424
    WaitMovement
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _020C
    Message msg_0137_D49_00005
    GoTo _0218
_020C:
    GetFirstNonEggInParty VAR_0x8000
    BufferPartyMonSpecies 1, VAR_0x8000
    Message msg_0137_D49_00001
_0218:
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x00, 40
    GoToIf 5, _024F
    ApplyMovement obj_D49_thlonowner, _0528
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _05A0
    ApplyMovement LOCALID_PLAYER, _0658
    GoTo _033E
_024F:
    CompareVar VAR_MAP_LOCAL_0x00, 41
    GoToIf 5, _027A
    ApplyMovement obj_D49_thlonowner, _0538
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _05BC
    ApplyMovement LOCALID_PLAYER, _066C
    GoTo _033E
_027A:
    CompareVar VAR_MAP_LOCAL_0x00, 42
    GoToIf 5, _02A5
    ApplyMovement obj_D49_thlonowner, _0548
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _05D8
    ApplyMovement LOCALID_PLAYER, _0680
    GoTo _033E
_02A5:
    CompareVar VAR_MAP_LOCAL_0x00, 43
    GoToIf 5, _02D0
    ApplyMovement obj_D49_thlonowner, _0554
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _05F0
    ApplyMovement LOCALID_PLAYER, _068C
    GoTo _033E
_02D0:
    CompareVar VAR_MAP_LOCAL_0x00, 44
    GoToIf 5, _02FB
    ApplyMovement obj_D49_thlonowner, _0564
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _060C
    ApplyMovement LOCALID_PLAYER, _06A0
    GoTo _033E
_02FB:
    CompareVar VAR_MAP_LOCAL_0x00, 39
    GoToIf 5, _0326
    ApplyMovement obj_D49_thlonowner, _0518
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _0584
    ApplyMovement LOCALID_PLAYER, _0644
    GoTo _033E
_0326:
    ApplyMovement obj_D49_thlonowner, _0574
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _0628
    ApplyMovement LOCALID_PLAYER, _06B4
_033E:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0137_D49_00002
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _0400
    WaitMovement
    Message msg_0137_D49_00003
    CloseMessage
    ApplyMovement 241, _0408
    WaitMovement
    RestoreCamera
    Message msg_0137_D49_00004
    CloseMessage
    ApplyMovement obj_D49_thlonowner, _06C8
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _06D0
    WaitMovement
    LoadDoorAnimation 1, 0, 10, 22, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_D49_thlonowner, _06DC
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _06E4
    WaitMovement
    RemoveObject obj_D49_thlonowner
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _041C
    WaitMovement
    PlayCry SPECIES_POLIWRATH, 0
    WaitCry
    ApplyMovement obj_D49_tsure_poke_static_poliwrath, _06E4
    WaitMovement
    RemoveObject obj_D49_tsure_poke_static_poliwrath
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40DB, 1
    SetFlag FLAG_HGSS_UNK_225
    SetFlag FLAG_HGSS_UNK_982
    End
    .balign 4, 0
_0400:
    WalkNormalNorth 10
    EndMovement
    .balign 4, 0
_0408:
    Delay32
    WalkSlightlyFastSouth 10
    EndMovement
    .balign 4, 0
_0414:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_041C:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0424:
    WalkFastSouth
    EndMovement
    .balign 4, 0
_042C:
    WalkSlightlyFastSouth 2
    WalkSlightlyFastWest 3
    WalkSlightlyFastSouth
    EndMovement
    .balign 4, 0
_043C:
    WalkSlightlyFastSouth 2
    WalkSlightlyFastWest 2
    WalkSlightlyFastSouth
    EndMovement
    .balign 4, 0
_044C:
    WalkSlightlyFastSouth 2
    WalkSlightlyFastWest
    WalkSlightlyFastSouth
    EndMovement
    .balign 4, 0
_045C:
    WalkSlightlyFastSouth 3
    EndMovement
    .balign 4, 0
_0464:
    WalkSlightlyFastSouth 2
    WalkSlightlyFastEast
    WalkSlightlyFastSouth
    EndMovement
    .balign 4, 0
_0474:
    WalkSlightlyFastSouth 2
    WalkSlightlyFastEast 2
    WalkSlightlyFastSouth
    EndMovement
    .balign 4, 0
_0484:
    WalkSlightlyFastSouth 2
    WalkSlightlyFastEast 3
    WalkSlightlyFastSouth
    EndMovement
    .balign 4, 0
_0494:
    WalkSlightlyFastEast
    WalkSlightlyFastSouth 2
    WalkSlightlyFastWest 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04A8:
    WalkSlightlyFastEast
    WalkSlightlyFastSouth 2
    WalkSlightlyFastWest 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04BC:
    WalkSlightlyFastEast
    WalkSlightlyFastSouth 2
    WalkSlightlyFastWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04D0:
    WalkSlightlyFastEast
    WalkSlightlyFastSouth 2
    EndMovement
    .balign 4, 0
_04DC:
    WalkSlightlyFastEast
    WalkSlightlyFastSouth 2
    WalkSlightlyFastEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04F0:
    WalkSlightlyFastEast
    WalkSlightlyFastSouth 2
    WalkSlightlyFastEast 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0504:
    WalkSlightlyFastEast
    WalkSlightlyFastSouth 2
    WalkSlightlyFastEast 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0518:
    WalkNormalEast 3
    WalkNormalNorth 21
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0528:
    WalkNormalEast 2
    WalkNormalNorth 21
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0538:
    WalkNormalEast
    WalkNormalNorth 21
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0548:
    WalkNormalNorth 21
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0554:
    WalkNormalWest
    WalkNormalNorth 21
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0564:
    WalkNormalWest 2
    WalkNormalNorth 21
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0574:
    WalkNormalWest 3
    WalkNormalNorth 21
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0584:
    WalkNormalSouth
    WalkNormalEast 3
    WalkNormalNorth 20
    WalkNormalWest
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05A0:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth 20
    WalkNormalWest
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05BC:
    WalkNormalSouth
    WalkNormalEast
    WalkNormalNorth 20
    WalkNormalWest
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05D8:
    WalkNormalSouth
    WalkNormalNorth 20
    WalkNormalWest
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05F0:
    WalkNormalSouth
    WalkNormalWest
    WalkNormalNorth 20
    WalkNormalWest
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_060C:
    WalkNormalSouth
    WalkNormalWest 2
    WalkNormalNorth 20
    WalkNormalWest
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0628:
    WalkNormalSouth
    WalkNormalWest 3
    WalkNormalNorth 20
    WalkNormalWest
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0644:
    Delay8 2
    WalkNormalNorth
    WalkNormalEast 3
    WalkNormalNorth 19
    EndMovement
    .balign 4, 0
_0658:
    Delay8 2
    WalkNormalNorth
    WalkNormalEast 2
    WalkNormalNorth 19
    EndMovement
    .balign 4, 0
_066C:
    Delay8 2
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 19
    EndMovement
    .balign 4, 0
_0680:
    Delay8 2
    WalkNormalNorth 20
    EndMovement
    .balign 4, 0
_068C:
    Delay8 2
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 19
    EndMovement
    .balign 4, 0
_06A0:
    Delay8 2
    WalkNormalNorth
    WalkNormalWest 2
    WalkNormalNorth 19
    EndMovement
    .balign 4, 0
_06B4:
    Delay8 2
    WalkNormalNorth
    WalkNormalWest 3
    WalkNormalNorth 19
    EndMovement
    .balign 4, 0
_06C8:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_06D0:
    WalkNormalEast
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_06DC:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_06E4:
    WalkNormalNorth
    EndMovement
scr_seq_D49_001:
    NPCMessage msg_0137_D49_00007
    End
scr_seq_D49_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ODDISH, 0
    Message msg_0137_D49_00008
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49_002:
    NPCMessage msg_0137_D49_00009
    End
scr_seq_D49_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MEOWTH, 0
    Message msg_0137_D49_00010
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 12, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 4, _076E
    Message msg_0137_D49_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_076E:
    GoToIfSet FLAG_HGSS_UNK_154, _07CB
    Message msg_0137_D49_00012
    @ HGSS: ScrCmd_724 16, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 1000
    GoToIf 4, _079A
    Message msg_0137_D49_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_079A:
    Message msg_0137_D49_00014
    SetVar VAR_0x8004, ITEM_RARE_CANDY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _07D6
    Common_GiveItemQuantity
    @ HGSS: ScrCmd_725 0, 100
    SetFlag FLAG_HGSS_UNK_154
_07CB:
    Message msg_0137_D49_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_07D6:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_D49_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_PIDGEY, 0
    Message msg_0137_D49_00016
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49_004:
    NPCMessage msg_0137_D49_00017
    End
scr_seq_D49_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SLOWBRO, 0
    Message msg_0137_D49_00018
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49_005:
    NPCMessage msg_0137_D49_00019
    End
scr_seq_D49_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MACHOP, 0
    Message msg_0137_D49_00020
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49_006:
    NPCMessage msg_0137_D49_00021
    End
scr_seq_D49_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SLOWPOKE, 0
    Message msg_0137_D49_00022
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_FARFETCHD, 0
    Message msg_0137_D49_00023
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_PSYDUCK, 0
    Message msg_0137_D49_00024
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_UNK_997, _093E
    Message msg_0137_D49_00025
_08D1:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 326, 0
    AddMenuEntry 327, 1
    AddMenuEntry 157, 2
    ShowMenu
    CompareVar VAR_RESULT, 0
    GoToIf 1, _091D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0928
    GoTo _0933
    CloseMessage
    ReleaseAll
    End
_091D:
    Message msg_0137_D49_00030
    GoTo _08D1
    End
_0928:
    Message msg_0137_D49_00031
    GoTo _08D1
    End
_0933:
    Message msg_0137_D49_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_093E:
    Message msg_0137_D49_00026
    BufferPlayerName 0
    Message msg_0137_D49_00027
    PlayFanfare SEQ_ME_KEYITEM_sseq
    WaitFanfare
    Message msg_0137_D49_00028
    SetFlag FLAG_HGSS_UNK_997
    Message msg_0137_D49_00029
    GoTo _08D1
    End
_095F:
    ApplyMovement obj_D49_shopm1_2, _09D4
    WaitMovement
    Message msg_0137_D49_00039
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _0993
    ApplyMovement LOCALID_PLAYER, _09E0
    GoTo _09B6
_0993:
    CompareVar VAR_MAP_LOCAL_0x07, 1
    GoToIf 5, _09AE
    ApplyMovement LOCALID_PLAYER, _09EC
    GoTo _09B6
_09AE:
    ApplyMovement LOCALID_PLAYER, _09F8
_09B6:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D49_shopm1_2, _0BF4
    WaitMovement
    GoTo _093E
    End
    .balign 4, 0
_09D4:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_09E0:
    WalkNormalEast 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_09EC:
    WalkNormalEast 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_09F8:
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_D49_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    GoToIfUnset FLAG_HGSS_UNK_997, _095F
_0A1D:
    ShowMoney 21, 1
    @ HGSS: ScrCmd_741 VAR_TEMP_x4007, VAR_SPECIAL_x8000, VAR_SPECIAL_x8001, VAR_SPECIAL_x8002
    ApplyMovement obj_D49_shopm1_2, _0BEC
    WaitMovement
    Message msg_0137_D49_00033
_0A3A:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 328, 0
    AddMenuEntry 329, 1
    AddMenuEntry 44, 2
    ShowMenu
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0AD6
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0AF6
    CheckMoney2 VAR_RESULT, VAR_0x8001
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0AEB
    Message msg_0137_D49_00034
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    HideMoney
    @ HGSS: ScrCmd_740 VAR_SPECIAL_x8000, VAR_SPECIAL_x8003
    ReturnToField
    ShowMoney 21, 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8003, 0
    GoToIf 5, _0AD0
    Message msg_0137_D49_00036
    GoTo _0AD9
_0AD0:
    RemoveMoney2 VAR_0x8001
    UpdateMoneyDisplay
_0AD6:
    Message msg_0137_D49_00035
_0AD9:
    CloseMessage
    HideMoney
    ApplyMovement obj_D49_shopm1_2, _0BF4
    WaitMovement
    ReleaseAll
    End
_0AEB:
    Message msg_0137_D49_00037
    GoTo _0AD9
    End
_0AF6:
    CompareVar VAR_0x8002, 2000
    GoToIf 4, _0B80
    CompareVar VAR_0x8002, 1000
    GoToIf 4, _0B77
    CompareVar VAR_0x8002, 500
    GoToIf 4, _0B6E
    CompareVar VAR_0x8002, 300
    GoToIf 4, _0B65
    CompareVar VAR_0x8002, 200
    GoToIf 4, _0B5C
    CompareVar VAR_0x8002, 100
    GoToIf 4, _0B53
    GoTo _0B4A
_0B4A:
    Message msg_0137_D49_00041
    GoTo _0B89
_0B53:
    Message msg_0137_D49_00042
    GoTo _0B89
_0B5C:
    Message msg_0137_D49_00043
    GoTo _0B89
_0B65:
    Message msg_0137_D49_00044
    GoTo _0B89
_0B6E:
    Message msg_0137_D49_00045
    GoTo _0B89
_0B77:
    Message msg_0137_D49_00046
    GoTo _0B89
_0B80:
    Message msg_0137_D49_00047
    GoTo _0B89
_0B89:
    Message msg_0137_D49_00040
    Message msg_0137_D49_00038
    GoTo _0A3A
    End
scr_seq_D49_020:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x07, 1
    GoToIfUnset FLAG_HGSS_UNK_997, _095F
    GoTo _0A1D
    End
scr_seq_D49_021:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x07, 2
    GoToIfUnset FLAG_HGSS_UNK_997, _095F
    GoTo _0A1D
    End
scr_seq_D49_022:
    NPCMessage msg_0137_D49_00048
    End
    .balign 4, 0
_0BEC:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0BF4:
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_D49_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0E44
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0E58
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0C75
    ApplyMovement LOCALID_PLAYER, _0E6C
    ApplyMovement obj_D49_gsmiddleman1, _0EB8
    GoTo _0CC3
_0C75:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0C90
    ApplyMovement LOCALID_PLAYER, _0E84
    GoTo _0CC3
_0C90:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0CB3
    ApplyMovement LOCALID_PLAYER, _0EA4
    ApplyMovement obj_D49_gsmiddleman1, _0EB8
    GoTo _0CC3
_0CB3:
    ApplyMovement LOCALID_PLAYER, _0E90
    ApplyMovement obj_D49_gsmiddleman1, _0EB8
_0CC3:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0CEA
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0EC4
    WaitMovement
_0CEA:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 13
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
scr_seq_D49_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0E44
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0E58
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0D9D
    ApplyMovement LOCALID_PLAYER, _0E6C
    ApplyMovement obj_D49_gsmiddleman1_2, _0EB8
    GoTo _0DEB
_0D9D:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0DB8
    ApplyMovement LOCALID_PLAYER, _0E84
    GoTo _0DEB
_0DB8:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0DDB
    ApplyMovement LOCALID_PLAYER, _0EA4
    ApplyMovement obj_D49_gsmiddleman1_2, _0EB8
    GoTo _0DEB
_0DDB:
    ApplyMovement LOCALID_PLAYER, _0E90
    ApplyMovement obj_D49_gsmiddleman1_2, _0EB8
_0DEB:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0E12
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0EC4
    WaitMovement
_0E12:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 14
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0E44:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0E58:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0E6C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0E84:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0E90:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0EA4:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0EB8:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0EC4:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_D49_023:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0137_D49_00049, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
