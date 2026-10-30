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
    ScriptEntry scr_seq_D51R0201_008
    ScriptEntry scr_seq_D51R0201_009
    ScriptEntry scr_seq_D51R0201_010
    ScriptEntry scr_seq_D51R0201_011
    ScriptEntry scr_seq_D51R0201_012
    ScriptEntry scr_seq_D51R0201_013
    ScriptEntry scr_seq_D51R0201_014
    ScriptEntry scr_seq_D51R0201_015
    ScriptEntryEnd
scr_seq_D51R0201_002:
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 7
    GoToIf 1, _05E0
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 8
    GoToIf 1, _05E0
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 9
    GoToIf 1, _05E0
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 12
    GoToIf 1, _05E0
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 1, _05E0
    End
scr_seq_D51R0201_007:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _130E
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
    ApplyMovement LOCALID_PLAYER, _130E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 4
    ReleaseAll
    End
scr_seq_D51R0201_000:
    End
scr_seq_D51R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 8
    GoToIf 1, _05E4
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x05
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
    CompareVar VAR_MAP_LOCAL_0x06, 1
    GoToIf 1, _05EF
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    CompareVar VAR_MAP_LOCAL_0x07, 1
    GoToIf 1, _05EF
    Message msg_0146_D51R0201_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D51R0201_004:
    LockAll
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 0, _0627
    CompareVar VAR_HGSS_UNK_4103, 1
    GoToIf 1, _0639
    Call _0644
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 1, _0661
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    GoToIf 1, _066C
    CompareVar VAR_MAP_LOCAL_0x0A, 3
    GoToIf 1, _0677
    Message msg_0146_D51R0201_00027
    GoTo _0682
scr_seq_D51R0201_003:
    LockAll
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 0, _0691
    CompareVar VAR_HGSS_UNK_4103, 2
    GoToIf 1, _0639
    Call _0644
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 1, _0661
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    GoToIf 1, _066C
    CompareVar VAR_MAP_LOCAL_0x0A, 3
    GoToIf 1, _0677
    Message msg_0146_D51R0201_00028
    GoTo _06A3
scr_seq_D51R0201_005:
    LockAll
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 0, _06B2
    CompareVar VAR_HGSS_UNK_4103, 3
    GoToIf 1, _0639
    Call _0644
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 1, _0661
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    GoToIf 1, _066C
    CompareVar VAR_MAP_LOCAL_0x0A, 3
    GoToIf 1, _0677
    Message msg_0146_D51R0201_00029
    GoTo _06C4
scr_seq_D51R0201_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_UXIE, 6
    ReleaseObject 1
    CompleteObjectSway 1, 2, 90, 2, 0
    LockObject 1
    Message msg_0146_D51R0201_00034
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_UXIE, 50, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06D3
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 1
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _06D9
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _06D9
    ReleaseAll
    End
scr_seq_D51R0201_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MESPRIT, 6
    ReleaseObject 2
    CompleteObjectSway 2, 2, 90, 2, 0
    LockObject 2
    Message msg_0146_D51R0201_00035
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_MESPRIT, 50, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06D3
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 2
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _06E8
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _06E8
    ReleaseAll
    End
scr_seq_D51R0201_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_AZELF, 6
    ReleaseObject 3
    CompleteObjectSway 3, 2, 90, 2, 0
    LockObject 3
    Message msg_0146_D51R0201_00036
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_AZELF, 50, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06D3
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 3
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _06F7
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _06F7
    ReleaseAll
    End
scr_seq_D51R0201_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_DIALGA, 6
    ReleaseObject 5
    CompleteObjectSway 5, 2, 90, 2, 0
    LockObject 5
    Message msg_0146_D51R0201_00037
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_DIALGA, 70, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06D3
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 5
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0706
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _0715
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _0706
    ReleaseAll
    End
scr_seq_D51R0201_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_PALKIA, 6
    ReleaseObject 6
    CompleteObjectSway 6, 2, 90, 2, 0
    LockObject 6
    Message msg_0146_D51R0201_00038
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_PALKIA, 70, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06D3
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 6
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _072C
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _073B
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _072C
    ReleaseAll
    End
scr_seq_D51R0201_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_GIRATINA, 6
    ReleaseObject 7
    CompleteObjectSway 7, 2, 90, 2, 0
    LockObject 7
    Message msg_0146_D51R0201_00039
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_GIRATINA, 70, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06D3
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 7
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0752
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _0761
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _0752
    ReleaseAll
    End
scr_seq_D51R0201_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    ApplyMovement LOCALID_PLAYER, _1314
    WaitMovement
    CompleteFollowerPutAway
    Message msg_0146_D51R0201_00040
    WaitButton
    CloseMessage
    GoToIfUnset FLAG_HGSS_SG_3FCE, _0778
    GoToIfUnset FLAG_HGSS_SG_3FCD, _0778
    GoToIfUnset FLAG_HGSS_SG_3FCC, _0778
    GoToIfUnset FLAG_HGSS_SG_3FC6, _0778
    GoToIfUnset FLAG_HGSS_SG_3FC5, _0778
    GoToIfUnset FLAG_HGSS_SG_3FC4, _0778
    GoToIfSet FLAG_HGSS_SG_3FC3, _078F
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B3A
    CompleteFollowerReturn
    ReleaseAll
    End
scr_seq_D51R0201_015:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _0B9D
    End
_05E0:
    @ HGSS: MystriStageGymmickInit
    End
_05E4:
    Message msg_0146_D51R0201_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05EF:
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 1, _0BAB
    Message msg_0146_D51R0201_00000
    CloseMessage
    GetPartyCount VAR_0x8004
    CompareVar VAR_0x8004, 2
    GoToIf 4, _0BAB
    ApplyMovement obj_D51R0201_champion, _131A
    WaitMovement
    Message msg_0146_D51R0201_00006
    CloseMessage
    GoTo _0BBC
_0627:
    Message msg_0146_D51R0201_00013
    @ HGSS: ScrCmd_820 1
    SetVarFromValue VAR_MAP_LOCAL_0x09, 483
    GoTo _0BE7
_0639:
    Message msg_0146_D51R0201_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0644:
    GetPartyCount VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 1, _0C0F
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 2
    Return
_0661:
    Message msg_0146_D51R0201_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_066C:
    Message msg_0146_D51R0201_00031
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0677:
    Message msg_0146_D51R0201_00033
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0682:
    @ HGSS: ScrCmd_820 1
    SetVarFromValue VAR_MAP_LOCAL_0x09, 483
    GoTo _0BE7
_0691:
    Message msg_0146_D51R0201_00014
    @ HGSS: ScrCmd_820 2
    SetVarFromValue VAR_MAP_LOCAL_0x09, 484
    GoTo _0BE7
_06A3:
    @ HGSS: ScrCmd_820 2
    SetVarFromValue VAR_MAP_LOCAL_0x09, 484
    GoTo _0BE7
_06B2:
    Message msg_0146_D51R0201_00015
    @ HGSS: ScrCmd_820 3
    SetVarFromValue VAR_MAP_LOCAL_0x09, 487
    GoTo _0BE7
_06C4:
    @ HGSS: ScrCmd_820 3
    SetVarFromValue VAR_MAP_LOCAL_0x09, 487
    GoTo _0BE7
_06D3:
    BlackOutFromBattle
    ReleaseAll
    End
_06D9:
    Message msg_0146_D51R0201_00052
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FCE
    ReleaseAll
    End
_06E8:
    Message msg_0146_D51R0201_00051
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FCD
    ReleaseAll
    End
_06F7:
    Message msg_0146_D51R0201_00050
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FCC
    ReleaseAll
    End
_0706:
    Message msg_0146_D51R0201_00045
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FC6
    ReleaseAll
    Return
_0715:
    Message msg_0146_D51R0201_00044
    SetVar VAR_0x8004, ITEM_ADAMANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    Return
_072C:
    Message msg_0146_D51R0201_00046
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FC5
    ReleaseAll
    Return
_073B:
    Message msg_0146_D51R0201_00048
    SetVar VAR_0x8004, ITEM_LUSTROUS_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    Return
_0752:
    Message msg_0146_D51R0201_00047
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FC4
    ReleaseAll
    Return
_0761:
    Message msg_0146_D51R0201_00049
    SetVar VAR_0x8004, ITEM_GRISEOUS_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    Return
_0778:
    @ HGSS: ScrCmd_709
    Message msg_0146_D51R0201_00041
    WaitButton
    CloseMessage
    CompleteFollowerReturn
    ReleaseAll
    End
_078F:
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0146_D51R0201_00053
    CloseMessage
    @ HGSS: ScrCmd_709
    CheckItem ITEM_FLAME_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_SPLASH_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_ZAP_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_MEADOW_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_ICICLE_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_FIST_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_TOXIC_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_EARTH_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_SKY_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_MIND_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_INSECT_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_STONE_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_SPOOKY_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_DRACO_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_DREAD_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckItem ITEM_IRON_PLATE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4E
    CheckNationalDexCompleted VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C5B
    GoToIfUnset FLAG_HGSS_SG_3FC8, _0C68
    GoToIfUnset FLAG_HGSS_SG_3FB0, _0C68
    GoToIfUnset FLAG_HGSS_SG_3FAE, _0C68
    GoToIfUnset FLAG_HGSS_SG_3F8C, _0C68
    GoToIfUnset FLAG_HGSS_SG_3FC0, _0C68
    GoToIfUnset FLAG_HGSS_SG_3FBE, _0C68
    Message msg_0146_D51R0201_00056
    BufferPlayerName 0
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0C75
    CompleteScreenShake 3, 3, 25, 5
    SetVarFromValue VAR_HGSS_SG_6131, 2
    FadeOutBGM 0, 30
    @ HGSS: UnownCircle
    @ HGSS: Cinematic 2
    WaitTime 150, VAR_RESULT
    ApplyMovement LOCALID_PLAYER, _1320
    WaitMovement
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0146_D51R0201_00055
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_WHITE
    WaitFadeScreen
    PlayCry SPECIES_ARCEUS, 6
    SetPosition 8, 16, 1, 12, DIR_SOUTH
    ApplyMovement 8, _132A
    LockAll
    WaitCry
    FadeScreen 6, 1, 1, COLOR_WHITE
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _1330
    WaitMovement
    ReleaseObject 8
    CompleteObjectSway 8, 8, 90, 3, 0
    PlayCry SPECIES_ARCEUS, 6
    WaitCry
    ApplyMovement 8, _1336
    ApplyMovement 241, _133C
    WaitMovement
    PlayCry SPECIES_ARCEUS, 6
    CompleteObjectSway 8, 8, 90, 3, 0
    WaitCry
    ApplyMovement 8, _1342
    ApplyMovement 241, _1348
    WaitMovement
    PlayCry SPECIES_ARCEUS, 6
    CompleteObjectSway 8, 8, 90, 3, 0
    WaitCry
    ApplyMovement 8, _1342
    ApplyMovement 241, _133C
    WaitMovement
    RestoreCamera
    LockObject 8
    PlayCry SPECIES_ARCEUS, 0
    Message msg_0146_D51R0201_00057
    WaitCry
    CompleteStartWildBattle SPECIES_ARCEUS, 100, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C7B
    CloseMessage
    StopMusic
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _0C81
    PlayCry SPECIES_ARCEUS, 6
    WaitCry
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_ARCEUS, 5
    WaitCry
    RemoveObject 8
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0146_D51R0201_00058
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _134E
    WaitMovement
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0146_D51R0201_00063
    Message msg_0146_D51R0201_00064
    WaitButton
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteJohtoClearGame 1
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0B3A:
    @ HGSS: ScrCmd_709
    Message msg_0146_D51R0201_00042
    WaitButton
    CloseMessage
    FadeScreen 11, 5, 0, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_SG_3FC6
    ClearFlag FLAG_HGSS_SG_3FC5
    ClearFlag FLAG_HGSS_SG_3FC4
    AddObject 5
    AddObject 6
    AddObject 7
    PlayCry SPECIES_DIALGA, 0
    WaitCry
    PlayCry SPECIES_PALKIA, 0
    WaitCry
    PlayCry SPECIES_GIRATINA, 0
    WaitCry
    SetFlag FLAG_HGSS_SG_3FC3
    FadeScreen 11, 5, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteFollowerReturn
    ReleaseAll
    End
_0B9D:
    SetFlag FLAG_HGSS_SG_3FC6
    RemoveObject 5
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_0BAB:
    Message msg_0146_D51R0201_00002
    WaitButton
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    ReleaseAll
    End
_0BBC:
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 8
    SetVarFromValue VAR_HGSS_UNK_4104, 1
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0D3F
    ApplyMovement obj_D51R0201_champion, _1354
    GoTo _0D5A
_0BE7:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D86
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0DA1
    End
_0C0F:
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    CompareVar VAR_HGSS_UNK_4102, 1
    GoToIf 5, _0DAA
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0DE5
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0DED
    GoTo _0DF5
_0C4E:
    Message msg_0146_D51R0201_00054
    WaitButton
    CloseMessage
    CompleteFollowerReturn
    ReleaseAll
    End
_0C5B:
    Message msg_0146_D51R0201_00065
    WaitButton
    CloseMessage
    CompleteFollowerReturn
    ReleaseAll
    End
_0C68:
    Message msg_0146_D51R0201_00065
    WaitButton
    CloseMessage
    CompleteFollowerReturn
    ReleaseAll
    End
_0C75:
    CompleteFollowerReturn
    ReleaseAll
    End
_0C7B:
    BlackOutFromBattle
    ReleaseAll
    End
_0C81:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 8
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0146_D51R0201_00059
    CloseMessage
    SetFlag FLAG_HGSS_SG_3F8D
    CompleteScreenShake 3, 3, 15, 5
    ApplyMovement LOCALID_PLAYER, _135A
    Message msg_0146_D51R0201_00060
    WaitMovement
    CloseMessage
    CompleteScreenShake 3, 3, 15, 5
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _1360
    WaitMovement
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0146_D51R0201_00061
    CloseMessage
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    WaitSE SEQ_SE_PL_BOWABOWA_sseq
    Message msg_0146_D51R0201_00062
    PlayFanfare SEQ_ME_HYOUKA6_sseq
    WaitFanfare
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteJohtoClearGame 1
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0D3F:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _0DFD
    ApplyMovement obj_D51R0201_champion, _1366
    GoTo _0D5A
_0D5A:
    WaitMovement
    Message msg_0146_D51R0201_00004
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _0E31
    ApplyMovement obj_D51R0201_champion, _136C
    GoTo _0E5E
_0D86:
    CloseMessage
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 5, _0E83
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 14
    GoTo _0EB5
_0DA1:
    CloseMessage
    @ HGSS: ScrCmd_820 0
    ReleaseAll
    End
_0DAA:
    CompareVar VAR_HGSS_UNK_4102, 2
    GoToIf 5, _0EE1
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0DE5
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0DED
    GoTo _0DF5
_0DE5:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    Return
_0DED:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 3
    Return
_0DF5:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 0
    Return
_0DFD:
    ApplyMovement obj_D51R0201_champion, _1376
    WaitMovement
    Message msg_0146_D51R0201_00004
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _0E31
    ApplyMovement obj_D51R0201_champion, _136C
    GoTo _0E5E
_0E31:
    ApplyMovement obj_D51R0201_champion, _137C
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0EE7
    ApplyMovement LOCALID_PLAYER, _1386
    ApplyMovement obj_D51R0201_champion, _1394
    GoTo _0F0A
_0E5E:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0EE7
    ApplyMovement LOCALID_PLAYER, _1386
    ApplyMovement obj_D51R0201_champion, _1394
    GoTo _0F0A
_0E83:
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 9
    @ HGSS: ScrCmd_820 0
    SetVarFromValue VAR_HGSS_UNK_4104, 0
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x09, 483
    GoToIf 5, _0F74
    GoTo _0F87
_0EB5:
    @ HGSS: ScrCmd_820 0
    SetVarFromValue VAR_HGSS_UNK_4104, 0
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x09, 483
    GoToIf 5, _0F74
    GoTo _0F87
_0EE1:
    GoTo _0DF5
_0EE7:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _0FAA
    ApplyMovement LOCALID_PLAYER, _13AE
    ApplyMovement obj_D51R0201_champion, _1394
    GoTo _0F0A
_0F0A:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0146_D51R0201_00005
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _13C0
    WaitMovement
    Message msg_0146_D51R0201_00007
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _13CE
    WaitMovement
    Message msg_0146_D51R0201_00008
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _13E0
    WaitMovement
    Message msg_0146_D51R0201_00009
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _13FA
    WaitMovement
    Message msg_0146_D51R0201_00010
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _1404
    ApplyMovement LOCALID_PLAYER, _1416
    WaitMovement
    Message msg_0146_D51R0201_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0F74:
    CompareVar VAR_MAP_LOCAL_0x09, 484
    GoToIf 5, _1024
    GoTo _102A
_0F87:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _104D
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1428
    ApplyMovement 241, _1436
    GoTo _1070
_0FAA:
    ApplyMovement LOCALID_PLAYER, _1440
    ApplyMovement obj_D51R0201_champion, _1452
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0146_D51R0201_00005
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _13C0
    WaitMovement
    Message msg_0146_D51R0201_00007
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _13CE
    WaitMovement
    Message msg_0146_D51R0201_00008
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _13E0
    WaitMovement
    Message msg_0146_D51R0201_00009
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _13FA
    WaitMovement
    Message msg_0146_D51R0201_00010
    CloseMessage
    ApplyMovement obj_D51R0201_champion, _1404
    ApplyMovement LOCALID_PLAYER, _1416
    WaitMovement
    Message msg_0146_D51R0201_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1024:
    GoTo _1078
_102A:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _109B
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _146C
    ApplyMovement 241, _147A
    GoTo _10BE
_104D:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _10C6
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1484
    ApplyMovement 241, _1436
    GoTo _1070
_1070:
    WaitMovement
    GoTo _10E9
_1078:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _113F
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1496
    ApplyMovement 241, _14A0
    GoTo _1162
_109B:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _116A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _14A6
    ApplyMovement 241, _147A
    GoTo _10BE
_10BE:
    WaitMovement
    GoTo _10E9
_10C6:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _118D
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _14B4
    ApplyMovement 241, _1436
    GoTo _1070
_10E9:
    FadeOutBGM 0, 30
    @ HGSS: UnownCircle
    @ HGSS: Cinematic 2
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 14
    GoToIf 1, _11A5
    ReleaseObject obj_D51R0201_champion
    SetPosition obj_D51R0201_champion, 16, 1, 28, DIR_NORTH
    WaitTime 5, VAR_RESULT
    LockObject obj_D51R0201_champion
    CompareVar VAR_MAP_LOCAL_0x09, 483
    GoToIf 5, _11C0
    ApplyMovement LOCALID_PLAYER, _14C2
    GoTo _11DB
_113F:
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 5, _1225
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _14CC
    ApplyMovement 241, _14A0
    GoTo _1162
_1162:
    WaitMovement
    GoTo _10E9
_116A:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _1248
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _14DA
    ApplyMovement 241, _147A
    GoTo _10BE
_118D:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _14EC
    ApplyMovement 241, _1436
    WaitMovement
    GoTo _10E9
_11A5:
    CompareVar VAR_MAP_LOCAL_0x09, 483
    GoToIf 5, _11C0
    ApplyMovement LOCALID_PLAYER, _14C2
    GoTo _11DB
_11C0:
    CompareVar VAR_MAP_LOCAL_0x09, 484
    GoToIf 5, _1260
    ApplyMovement LOCALID_PLAYER, _14FA
    GoTo _11DB
_11DB:
    WaitTime 150, VAR_RESULT
    FadeScreen 6, 30, 1, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _1504
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x09, 483
    GoToIf 5, _12B5
    @ HGSS: ScrCmd_817 0
    GoTo _12CB
_1225:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _12DF
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _150A
    ApplyMovement 241, _14A0
    GoTo _1162
_1248:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1518
    ApplyMovement 241, _147A
    WaitMovement
    GoTo _10E9
_1260:
    BufferPlayerName 0
    ApplyMovement LOCALID_PLAYER, _1526
    WaitTime 150, VAR_RESULT
    FadeScreen 6, 30, 1, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _1504
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x09, 483
    GoToIf 5, _12B5
    @ HGSS: ScrCmd_817 0
    GoTo _12CB
_12B5:
    CompareVar VAR_MAP_LOCAL_0x09, 484
    GoToIf 5, _12F7
    @ HGSS: ScrCmd_817 1
    GoTo _12CB
_12CB:
    ApplyMovement LOCALID_PLAYER, _1530
    WaitMovement
    @ HGSS: ScrCmd_819
    @ HGSS data: .byte 3
    @ HGSS: PlayerMovementSavingSet
    @ HGSS data: .byte 0
_12DF:
    @ HGSS data: .byte 94
    @ HGSS data: .byte 0
    @ HGSS: GetSaveFileState 599
    Noop
    ApplyMovement 241, _14A0
    WaitMovement
    GoTo _10E9
_12F7:
    @ HGSS: ScrCmd_817 2
    ApplyMovement LOCALID_PLAYER, _1530
    WaitMovement
    @ HGSS: ScrCmd_819
    @ HGSS data: .byte 3
    @ HGSS: PlayerMovementSavingSet
    @ HGSS data: .byte 0
    .balign 4, 0
_130E:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_1314:
    FaceSouth
    EndMovement
    .balign 4, 0
_131A:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1320:
    WalkFastSouth 5
    FaceNorth
    EndMovement
    .balign 4, 0
_132A:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1330:
    WalkSlightlyFastNorth 6
    EndMovement
    .balign 4, 0
_1336:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_133C:
    WalkSlightlyFastSouth 2
    EndMovement
    .balign 4, 0
_1342:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_1348:
    WalkSlightlyFastSouth 2
    EndMovement
    .balign 4, 0
_134E:
    WalkSlightlyFastSouth 12
    EndMovement
    .balign 4, 0
_1354:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_135A:
    WalkFastSouth 13
    EndMovement
    .balign 4, 0
_1360:
    WalkSlightlyFastSouth 15
    EndMovement
    .balign 4, 0
_1366:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_136C:
    WalkNormalWest
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1376:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_137C:
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1386:
    WalkNormalNorth 6
    Delay16
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1394:
    Delay16
    WalkNormalWest
    WalkNormalNorth 3
    WalkNormalEast
    WalkNormalNorth 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_13AE:
    WalkNormalEast
    WalkNormalNorth 5
    Delay16
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_13C0:
    WalkNormalEast 3
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_13CE:
    WalkNormalSouth
    WalkNormalWest 8
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_13E0:
    WalkNormalNorth 3
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast 2
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_13FA:
    WalkNormalSouth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1404:
    WalkNormalEast
    WalkNormalSouth 6
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1416:
    Delay8 2
    WalkOnSpotNormalEast
    Delay8 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1428:
    WalkSlowEast 4
    WalkSlowNorth 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1436:
    WalkSlowEast 4
    WalkSlowNorth 3
    EndMovement
    .balign 4, 0
_1440:
    WalkNormalWest
    WalkNormalNorth 5
    Delay16
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1452:
    Delay16
    WalkNormalEast
    WalkNormalNorth 3
    WalkNormalEast
    WalkNormalNorth 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_146C:
    WalkSlowWest 4
    WalkSlowNorth 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_147A:
    WalkSlowWest 4
    WalkSlowNorth 3
    EndMovement
    .balign 4, 0
_1484:
    WalkSlowNorth 2
    WalkSlowEast 5
    WalkSlowNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1496:
    WalkSlowSouth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_14A0:
    WalkSlowSouth 4
    EndMovement
    .balign 4, 0
_14A6:
    WalkSlowWest 3
    WalkSlowNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_14B4:
    WalkSlowEast 3
    WalkSlowNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_14C2:
    WalkFasterEast 4
    FaceNorth
    EndMovement
    .balign 4, 0
_14CC:
    WalkSlowSouth 4
    WalkSlowEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_14DA:
    WalkSlowNorth 2
    WalkSlowWest 5
    WalkSlowNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_14EC:
    WalkSlowEast 4
    WalkSlowNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_14FA:
    WalkFasterWest 4
    FaceNorth
    EndMovement
    .balign 4, 0
_1504:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_150A:
    WalkSlowSouth 4
    WalkSlowWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1518:
    WalkSlowWest 4
    WalkSlowNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1526:
    WalkNormalSouth 7
    FaceNorth
    EndMovement
    .balign 4, 0
_1530:
    Delay8
    EmoteExclamationMark
    Delay8
    EndMovement
_153E:
    WalkSlowEast
    WalkSlowSouth 5
    WalkSlowWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
