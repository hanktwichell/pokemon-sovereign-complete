#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0146.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D51R0201_champion 0

    ScriptEntry scr_seq_D51R0201_000
    ScriptEntry scr_seq_D51R0201_001
    ScriptEntry scr_seq_D51R0201_002
    ScriptEntry scr_seq_D51R0201_003
    ScriptEntry scr_seq_D51R0201_004
    ScriptEntry scr_seq_D51R0201_005
    ScriptEntry scr_seq_D51R0201_006
    ScriptEntry scr_seq_D51R0201_007
    ScriptEntryEnd
scr_seq_D51R0201_002:
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 7
    GoToIf 1, _0065
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 8
    GoToIf 1, _0065
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 9
    GoToIf 1, _0065
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 12
    GoToIf 1, _0065
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 1, _0065
    End
_0065:
    @ HGSS: MystriStageGymmickInit
    End
scr_seq_D51R0201_007:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00C4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    ReleaseAll
    End
scr_seq_D51R0201_006:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00C4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 4
    ReleaseAll
    End
    .balign 4, 0
_00C4:
    WalkNormalSouth 2
    EndMovement
scr_seq_D51R0201_000:
    End
scr_seq_D51R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 8
    GoToIf 1, _0165
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x05
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_MOVIE_GIFT, VAR_TEMP_x4005, VAR_TEMP_x4006
    CompareVar VAR_MAP_LOCAL_0x06, 1
    GoToIf 1, _011A
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_HALL_OF_ORIGIN, VAR_TEMP_x4005, VAR_TEMP_x4007
    CompareVar VAR_MAP_LOCAL_0x07, 1
    GoToIf 1, _011A
    Message msg_0146_D51R0201_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
_011A:
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 1, _0154
    Message msg_0146_D51R0201_00000
    CloseMessage
    GetPartyCount VAR_0x8004
    CompareVar VAR_0x8004, 2
    GoToIf 4, _0154
    ApplyMovement obj_D51R0201_champion, _02CC
    WaitMovement
    Message msg_0146_D51R0201_00006
    CloseMessage
    GoTo _0170
    End
_0154:
    Message msg_0146_D51R0201_00002
    WaitButton
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    ReleaseAll
    End
_0165:
    Message msg_0146_D51R0201_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0170:
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 8
    SetVarFromValue VAR_HGSS_UNK_4104, 1
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _019B
    ApplyMovement obj_D51R0201_champion, _02B4
    GoTo _01BE
_019B:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _01B6
    ApplyMovement obj_D51R0201_champion, _02BC
    GoTo _01BE
_01B6:
    ApplyMovement obj_D51R0201_champion, _02C4
_01BE:
    WaitMovement
    Message msg_0146_D51R0201_00004
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _01EA
    ApplyMovement obj_D51R0201_champion, _02D4
    GoTo _01F2
_01EA:
    ApplyMovement obj_D51R0201_champion, _02E0
_01F2:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0217
    ApplyMovement LOCALID_PLAYER, _0390
    ApplyMovement obj_D51R0201_champion, _0308
    GoTo _024A
_0217:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _023A
    ApplyMovement LOCALID_PLAYER, _03A0
    ApplyMovement obj_D51R0201_champion, _0308
    GoTo _024A
_023A:
    ApplyMovement LOCALID_PLAYER, _03B4
    ApplyMovement obj_D51R0201_champion, _02EC
_024A:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0146_D51R0201_00005
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _0324
    WaitMovement
    Message msg_0146_D51R0201_00007
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _0334
    WaitMovement
    Message msg_0146_D51R0201_00008
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _0348
    WaitMovement
    Message msg_0146_D51R0201_00009
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _0364
    WaitMovement
    Message msg_0146_D51R0201_00010
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _0370
    ApplyMovement LOCALID_PLAYER, _03C8
    WaitMovement
    Message msg_0146_D51R0201_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_02B4:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02BC:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_02C4:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_02CC:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_02D4:
    WalkNormalWest
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_02E0:
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_02EC:
    Delay16
    WalkNormalEast
    WalkNormalNorth 3
    WalkNormalEast
    WalkNormalNorth 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0308:
    Delay16
    WalkNormalWest
    WalkNormalNorth 3
    WalkNormalEast
    WalkNormalNorth 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0324:
    WalkNormalEast 3
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0334:
    WalkNormalSouth
    WalkNormalWest 8
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0348:
    WalkNormalNorth 3
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast 2
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0364:
    WalkNormalSouth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0370:
    WalkNormalEast
    WalkNormalSouth 6
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0384:
    WalkOnSpotNormalSouth
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0390:
    WalkNormalNorth 6
    Delay16
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_03A0:
    WalkNormalEast
    WalkNormalNorth 5
    Delay16
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_03B4:
    WalkNormalWest
    WalkNormalNorth 5
    Delay16
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_03C8:
    Delay8 2
    WalkOnSpotNormalEast
    Delay8 3
    WalkOnSpotNormalEast
    EndMovement
scr_seq_D51R0201_004:
    LockAll
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 0, _0430
    CompareVar VAR_HGSS_UNK_4103, 1
    GoToIf 1, _0545
    Call _0550
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 1, _0633
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    GoToIf 1, _061D
    CompareVar VAR_MAP_LOCAL_0x0A, 3
    GoToIf 1, _0628
    Message msg_0146_D51R0201_00027
    GoTo _0433
_0430:
    Message msg_0146_D51R0201_00013
_0433:
    @ HGSS: ScrCmd_820 1
    SetVarFromValue VAR_MAP_LOCAL_0x09, SPECIES_DIALGA
    GoTo _0514
    End
scr_seq_D51R0201_003:
    LockAll
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 0, _0498
    CompareVar VAR_HGSS_UNK_4103, 2
    GoToIf 1, _0545
    Call _0550
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 1, _0633
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    GoToIf 1, _061D
    CompareVar VAR_MAP_LOCAL_0x0A, 3
    GoToIf 1, _0628
    Message msg_0146_D51R0201_00028
    GoTo _049B
_0498:
    Message msg_0146_D51R0201_00014
_049B:
    @ HGSS: ScrCmd_820 2
    SetVarFromValue VAR_MAP_LOCAL_0x09, SPECIES_PALKIA
    GoTo _0514
    End
scr_seq_D51R0201_005:
    LockAll
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 0, _0500
    CompareVar VAR_HGSS_UNK_4103, 3
    GoToIf 1, _0545
    Call _0550
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 1, _0633
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    GoToIf 1, _061D
    CompareVar VAR_MAP_LOCAL_0x0A, 3
    GoToIf 1, _0628
    Message msg_0146_D51R0201_00029
    GoTo _0503
_0500:
    Message msg_0146_D51R0201_00015
_0503:
    @ HGSS: ScrCmd_820 3
    SetVarFromValue VAR_MAP_LOCAL_0x09, 487
    GoTo _0514
    End
_0514:
    @ HGSS: NopVar490 VAR_TEMP_x4009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _063E
    CompareVar VAR_RESULT, 1
    GoToIf 4, _053C
    End
_053C:
    CloseMessage
    @ HGSS: ScrCmd_820 0
    ReleaseAll
    End
_0545:
    Message msg_0146_D51R0201_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0550:
    GetPartyCount VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 1, _056D
    @ HGSS: NopVar490 VAR_TEMP_x4008
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 2
    Return
_056D:
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    CompareVar VAR_HGSS_UNK_4102, 1
    GoToIf 5, _05B2
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_HALL_OF_ORIGIN, VAR_TEMP_x4000, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0605
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_MOVIE_GIFT, VAR_TEMP_x4000, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _060D
    GoTo _0615
_05A6:
    GoTo _05F9
_05B2:
    CompareVar VAR_HGSS_UNK_4102, 2
    GoToIf 5, _05F3
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_MOVIE_GIFT, VAR_TEMP_x4000, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0605
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_HALL_OF_ORIGIN, VAR_TEMP_x4000, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _060D
    GoTo _0615
_05ED:
    GoTo _05F9
_05F3:
    GoTo _0615
_05F9:
    @ HGSS: NopVar490 VAR_TEMP_x4007
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 2
    Return
_0605:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    Return
_060D:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 3
    Return
_0615:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 0
    Return
_061D:
    Message msg_0146_D51R0201_00031
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0628:
    Message msg_0146_D51R0201_00033
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0633:
    Message msg_0146_D51R0201_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_063E:
    CloseMessage
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 5, _0659
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 14
    GoTo _065F
_0659:
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 9
_065F:
    @ HGSS: ScrCmd_820 0
    SetVarFromValue VAR_HGSS_UNK_4104, 0
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    @ HGSS: ScrCmd_102 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x09, SPECIES_DIALGA
    GoToIf 5, _0691
    GoTo _06B0
_068B:
    GoTo _06B0
_0691:
    CompareVar VAR_MAP_LOCAL_0x09, SPECIES_PALKIA
    GoToIf 5, _06AA
    GoTo _0731
_06A4:
    GoTo _06B0
_06AA:
    GoTo _07B2
_06B0:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _06D3
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0BE4
    ApplyMovement 241, _0C28
    GoTo _0729
_06D3:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _06F6
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0BF4
    ApplyMovement 241, _0C28
    GoTo _0729
_06F6:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _0719
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C08
    ApplyMovement 241, _0C28
    GoTo _0729
_0719:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C18
    ApplyMovement 241, _0C28
_0729:
    WaitMovement
    GoTo _0833
_0731:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0754
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C34
    ApplyMovement 241, _0C78
    GoTo _07AA
_0754:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _0777
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C44
    ApplyMovement 241, _0C78
    GoTo _07AA
_0777:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _079A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C54
    ApplyMovement 241, _0C78
    GoTo _07AA
_079A:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C68
    ApplyMovement 241, _0C78
_07AA:
    WaitMovement
    GoTo _0833
_07B2:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _07D5
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C84
    ApplyMovement 241, _0CC4
    GoTo _082B
_07D5:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _07F8
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C90
    ApplyMovement 241, _0CC4
    GoTo _082B
_07F8:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _081B
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0CA0
    ApplyMovement 241, _0CC4
    GoTo _082B
_081B:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0CB0
    ApplyMovement 241, _0CC4
_082B:
    WaitMovement
    GoTo _0833
_0833:
    FadeOutBGM 0, 30
    @ HGSS: UnownCircle
    @ HGSS: Cinematic 2
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 14
    GoToIf 1, _086E
    ReleaseObject obj_D51R0201_champion
    SetPosition obj_D51R0201_champion, 16, 1, 28, DIR_NORTH
    WaitTime 5, VAR_RESULT
    LockObject obj_D51R0201_champion
_086E:
    CompareVar VAR_MAP_LOCAL_0x09, SPECIES_DIALGA
    GoToIf 5, _0889
    ApplyMovement LOCALID_PLAYER, _0CCC
    GoTo _08AC
_0889:
    CompareVar VAR_MAP_LOCAL_0x09, SPECIES_PALKIA
    GoToIf 5, _08A4
    ApplyMovement LOCALID_PLAYER, _0CD8
    GoTo _08AC
_08A4:
    ApplyMovement LOCALID_PLAYER, _0CE4
_08AC:
    WaitTime 150, VAR_RESULT
    FadeScreen 6, 30, 1, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    @ HGSS: ScrCmd_102 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    @ HGSS: NopVar490 VAR_SPECIAL_x8004
    @ HGSS: NopVar490 VAR_SPECIAL_x8005
    ApplyMovement 241, _0CF0
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x09, SPECIES_DIALGA
    GoToIf 5, _08F6
    @ HGSS: ScrCmd_817 0
    GoTo _090F
_08F6:
    CompareVar VAR_MAP_LOCAL_0x09, SPECIES_PALKIA
    GoToIf 5, _090C
    @ HGSS: ScrCmd_817 1
    GoTo _090F
_090C:
    @ HGSS: ScrCmd_817 2
_090F:
    ApplyMovement LOCALID_PLAYER, _0D0C
    WaitMovement
    @ HGSS: ScrCmd_819
    WaitTime 2, VAR_RESULT
    Message msg_0146_D51R0201_00025
    @ HGSS: NopVar490 VAR_TEMP_x4009
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x09, 0, 0
    Message msg_0146_D51R0201_00026
    WaitFanfare
    CloseMessage
    ApplyMovement 241, _0CF8
    WaitMovement
    @ HGSS: ScrCmd_103
    @ HGSS: ResetBGM
    @ HGSS: NopVar490 VAR_TEMP_x4009
    CompareVar VAR_MAP_LOCAL_0x09, SPECIES_DIALGA
    GoToIf 5, _097B
    @ HGSS: GiveMon SPECIES_DIALGA, 1, ITEM_ADAMANT_ORB, 0, 0, VAR_SPECIAL_RESULT
    SetVarFromValue VAR_HGSS_UNK_4103, 1
    GoTo _09B6
_097B:
    CompareVar VAR_MAP_LOCAL_0x09, SPECIES_PALKIA
    GoToIf 5, _09A2
    @ HGSS: GiveMon SPECIES_PALKIA, 1, ITEM_LUSTROUS_ORB, 0, 0, VAR_SPECIAL_RESULT
    SetVarFromValue VAR_HGSS_UNK_4103, 2
    GoTo _09B6
_09A2:
    @ HGSS: GiveMon SPECIES_GIRATINA, 1, ITEM_GRISEOUS_ORB, 1, ABILITY_LEVITATE, VAR_SPECIAL_RESULT
    SetVarFromValue VAR_HGSS_UNK_4103, 3
_09B6:
    Message msg_0146_D51R0201_00032
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    @ HGSS: ScrCmd_815 0
    CompareVar VAR_RESULT, 0
    CallIf 1, _0BB2
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 14
    GoToIf 1, _0A4D
    ApplyMovement obj_D51R0201_champion, _0D28
    ApplyMovement LOCALID_PLAYER, _0D00
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0D1C
    WaitMovement
    Message msg_0146_D51R0201_00016
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _0D4C
    WaitMovement
    Message msg_0146_D51R0201_00017
    CloseMessage
    FadeScreen 6, 6, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 1, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement obj_D51R0201_champion, _0D30
    WaitMovement
    Message msg_0146_D51R0201_00018
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _0D44
    WaitMovement
    Message msg_0146_D51R0201_00019
    CloseMessage
_0A4D:
    FadeScreen 6, 6, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 1, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 14
    GoToIf 1, _0AAA
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x05
    @ HGSS: FollowerPokeIsEventTrigger EVENT_ARCEUS_MOVIE_GIFT, VAR_TEMP_x4005, VAR_TEMP_x4006
    CompareVar VAR_MAP_LOCAL_0x06, 1
    GoToIf 5, _0AA0
    SetVarFromValue VAR_HGSS_UNK_4102, 1
    GoTo _0AA6
_0AA0:
    SetVarFromValue VAR_HGSS_UNK_4102, 2
_0AA6:
    ClearFlag FLAG_HGSS_HIDE_ALPH_MAIN_CHAMBER_ARCEUS_EVENT_PEOPLE
_0AAA:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 5, _0AE5
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 9, 24, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _0BAE
_0AE5:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 5, _0B1C
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 9, 24, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _0BAE
_0B1C:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 8
    GoToIf 5, _0B53
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 9, 24, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _0BAE
_0B53:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 9
    GoToIf 5, _0B8A
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 9, 24, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _0BAE
_0B8A:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 9, 24, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0BAE:
    ReleaseAll
    End
_0BB2:
    GetPartyCount VAR_RESULT
    SubVar VAR_RESULT, 1
    SetVarFromValue VAR_MAP_LOCAL_0x08, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_SPECIAL_RESULT, VAR_TEMP_x4008
    @ HGSS: ScrCmd_819
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Return
    .balign 4, 0
_0BE4:
    WalkSlowEast 4
    WalkSlowNorth 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0BF4:
    WalkSlowNorth 2
    WalkSlowEast 5
    WalkSlowNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C08:
    WalkSlowEast 3
    WalkSlowNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C18:
    WalkSlowEast 4
    WalkSlowNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C28:
    WalkSlowEast 4
    WalkSlowNorth 3
    EndMovement
    .balign 4, 0
_0C34:
    WalkSlowWest 4
    WalkSlowNorth 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C44:
    WalkSlowWest 3
    WalkSlowNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C54:
    WalkSlowNorth 2
    WalkSlowWest 5
    WalkSlowNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C68:
    WalkSlowWest 4
    WalkSlowNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C78:
    WalkSlowWest 4
    WalkSlowNorth 3
    EndMovement
    .balign 4, 0
_0C84:
    WalkSlowSouth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C90:
    WalkSlowSouth 4
    WalkSlowEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0CA0:
    WalkSlowSouth 4
    WalkSlowWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0CB0:
    WalkSlowEast
    WalkSlowSouth 5
    WalkSlowWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0CC4:
    WalkSlowSouth 4
    EndMovement
    .balign 4, 0
_0CCC:
    WalkFasterEast 4
    FaceNorth
    EndMovement
    .balign 4, 0
_0CD8:
    WalkFasterWest 4
    FaceNorth
    EndMovement
    .balign 4, 0
_0CE4:
    WalkNormalSouth 7
    FaceNorth
    EndMovement
    .balign 4, 0
_0CF0:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_0CF8:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0D00:
    Delay16 2
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0D0C:
    Delay8
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0D1C:
    Delay16 2
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_0D28:
    WalkNormalNorth 9
    EndMovement
    .balign 4, 0
_0D30:
    FaceEast
    Delay8 3
    FaceWest
    Delay8 3
    EndMovement
    .balign 4, 0
_0D44:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0D4C:
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
