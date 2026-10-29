#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0363.h"

#define obj_R25_gsleader11 8
#define obj_R25_gsman1 9
#define obj_R25_tsure_poke_static_suicune 12
#define obj_R25_minaki 13
#define obj_R25_minaki_2 14
#define obj_R25_gsleader11_2 15

    ScriptEntry scr_seq_R25_000
    ScriptEntry scr_seq_R25_001
    ScriptEntry scr_seq_R25_002
    ScriptEntry scr_seq_R25_003
    ScriptEntry scr_seq_R25_004
    ScriptEntry scr_seq_R25_005
    ScriptEntry scr_seq_R25_006
    ScriptEntry scr_seq_R25_007
    ScriptEntry scr_seq_R25_008
    ScriptEntry scr_seq_R25_009
    ScriptEntryEnd
scr_seq_R25_003:
    GoToIfUnset FLAG_HGSS_UNK_189, _003B
    ClearFlag FLAG_HGSS_UNK_189
    End
_003B:
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 2
    GoToIf 5, _0050
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE_2
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE
_0050:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _011B
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 1
    GoToIf 1, _011B
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 2
    GoToIf 1, _011B
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0115
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00DD
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _00BE
    ClearFlag FLAG_HGSS_UNK_2CD
    GoTo _00DB
_00BE:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _00D5
    ClearFlag FLAG_HGSS_UNK_2CD
    GoTo _00DB
_00D5:
    GoTo _0115
_00DB:
    End
_00DD:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _00F8
    ClearFlag FLAG_HGSS_UNK_2CD
    GoTo _0113
_00F8:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _010F
    ClearFlag FLAG_HGSS_UNK_2CD
    GoTo _0113
_010F:
    SetFlag FLAG_HGSS_UNK_2CD
_0113:
    End
_0115:
    SetFlag FLAG_HGSS_UNK_2CD
    End
_011B:
    SetFlag FLAG_HGSS_UNK_2CD
    End
scr_seq_R25_008:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _012E
    End
_012E:
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_SUICUNE
    RemoveObject obj_R25_tsure_poke_static_suicune
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_R25_000:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _0171
    ApplyMovement obj_R25_gsleader11, _029C
    ApplyMovement obj_R25_gsman1, _02B0
    ApplyMovement LOCALID_PLAYER, _0304
    GoTo _01B4
_0171:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _019C
    ApplyMovement obj_R25_gsleader11, _029C
    ApplyMovement obj_R25_gsman1, _02CC
    ApplyMovement LOCALID_PLAYER, _0304
    GoTo _01B4
_019C:
    ApplyMovement obj_R25_gsleader11, _029C
    ApplyMovement obj_R25_gsman1, _02E8
    ApplyMovement LOCALID_PLAYER, _0310
_01B4:
    WaitMovement
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _01E1
    ApplyMovement obj_R25_gsleader11, _032C
    ApplyMovement LOCALID_PLAYER, _0350
    GoTo _0214
_01E1:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _0204
    ApplyMovement obj_R25_gsleader11, _0338
    ApplyMovement LOCALID_PLAYER, _0350
    GoTo _0214
_0204:
    ApplyMovement obj_R25_gsleader11, _0344
    ApplyMovement LOCALID_PLAYER, _0350
_0214:
    WaitMovement
    Message msg_0363_R25_00000
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _023E
    ApplyMovement obj_R25_gsleader11, _035C
    ApplyMovement LOCALID_PLAYER, _0380
    GoTo _0271
_023E:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _0261
    ApplyMovement obj_R25_gsleader11, _0368
    ApplyMovement LOCALID_PLAYER, _0380
    GoTo _0271
_0261:
    ApplyMovement obj_R25_gsleader11, _0374
    ApplyMovement LOCALID_PLAYER, _0394
_0271:
    WaitMovement
    RemoveObject obj_R25_gsman1
    RemoveObject obj_R25_gsleader11
    StopMusic
    PlayMusic SEQ_ROAD_A_D_sseq
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_MISTYS_BOYFRIEND
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_MISTY
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_POPULATION
    SetVarFromValue VAR_HGSS_UNK_4088, 2
    ReleaseAll
    End
    .balign 4, 0
_029C:
    Delay8
    FaceWest
    Delay32 2
    FaceNorth
    EndMovement
    .balign 4, 0
_02B0:
    Delay32
    FaceNorth
    EmoteExclamationMark
    WalkFastNorth 5
    WalkFastWest 5
    WalkFastSouth 8
    EndMovement
    .balign 4, 0
_02CC:
    Delay32
    FaceNorth
    EmoteExclamationMark
    WalkFastNorth 5
    WalkFastWest 5
    WalkFastSouth 8
    EndMovement
    .balign 4, 0
_02E8:
    Delay32
    FaceNorth
    EmoteExclamationMark
    WalkFastNorth 6
    WalkFastWest 5
    WalkFastSouth 9
    EndMovement
    .balign 4, 0
_0304:
    Delay16 6
    FaceSouth
    EndMovement
    .balign 4, 0
_0310:
    Delay16 6
    FaceNorth
    Delay8
    FaceWest
    Delay8
    FaceSouth
    EndMovement
    .balign 4, 0
_032C:
    WalkNormalNorth 7
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0338:
    WalkNormalNorth 6
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0344:
    WalkNormalNorth 5
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0350:
    Delay16 3
    FaceEast
    EndMovement
    .balign 4, 0
_035C:
    WalkNormalSouth
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_0368:
    WalkNormalSouth
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_0374:
    WalkNormalNorth
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_0380:
    Delay8
    FaceSouth
    Delay8
    FaceWest
    EndMovement
    .balign 4, 0
_0394:
    Delay8
    FaceNorth
    Delay4
    FaceWest
    EndMovement
scr_seq_R25_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MISTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0456
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _044B
    Message msg_0363_R25_00001
_03D3:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03F7
    CompareVar VAR_RESULT, 1
    GoToIf 4, _043A
    End
_03F7:
    BufferPlayerName 0
    Message msg_0363_R25_00002
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_MISTY
    Message msg_0363_R25_00003
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_2CD
    RemoveObject obj_R25_gsleader11_2
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_043A:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0363_R25_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_044B:
    Message msg_0363_R25_00005
    GoTo _03D3
    End
_0456:
    @ HGSS: PlayerOnBikeCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04DA
    @ HGSS: ScrCmd_733 11, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04DA
    Message msg_0363_R25_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04E5
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04F0
    Message msg_0363_R25_00007
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 84
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0363_R25_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04DA:
    Message msg_0363_R25_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04E5:
    Message msg_0363_R25_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04F0:
    Message msg_0363_R25_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R25_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_NUGGET_FROM_ACE_TRAINER_M_KEVIN, _0558
    Message msg_0363_R25_00011
    SetVar VAR_0x8004, ITEM_NUGGET
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0563
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_NUGGET_FROM_ACE_TRAINER_M_KEVIN
    Message msg_0363_R25_00013
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_ACE_TRAINER_M_KEVIN, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _056D
_0558:
    Message msg_0363_R25_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0563:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_056D:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_R25_004:
    LockAll
    SetFlag FLAG_HGSS_HIDE_ROUTE_14_EUSINE_2
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE
    AddObject obj_R25_minaki
    ApplyMovement LOCALID_PLAYER, _0648
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_R25_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_R25_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_R25_tsure_poke_static_suicune
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _05D4
    ApplyMovement LOCALID_PLAYER, _0650
    GoTo _05F7
_05D4:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _05EF
    ApplyMovement LOCALID_PLAYER, _065C
    GoTo _05F7
_05EF:
    ApplyMovement LOCALID_PLAYER, _0670
_05F7:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_R25_minaki, _069C
    ApplyMovement LOCALID_PLAYER, _0690
    WaitMovement
    Message msg_0363_R25_00016
    CloseMessage
    ApplyMovement obj_R25_minaki, _06B0
    ApplyMovement LOCALID_PLAYER, _0684
    WaitMovement
    Message msg_0363_R25_00017
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_25, 2
    ReleaseAll
    End
    .balign 4, 0
_0648:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0650:
    WalkNormalEast 3
    FaceNorth
    EndMovement
    .balign 4, 0
_065C:
    WalkNormalEast
    WalkNormalNorth
    WalkNormalEast 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0670:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalEast 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0684:
    Delay16
    FaceNorth
    EndMovement
    .balign 4, 0
_0690:
    Delay8 2
    FaceSouth
    EndMovement
    .balign 4, 0
_069C:
    WalkFastEast 8
    WalkNormalEast 3
    WalkSlowerEast
    FaceNorth
    EndMovement
    .balign 4, 0
_06B0:
    WalkNormalEast
    WalkNormalNorth 2
    EndMovement
scr_seq_R25_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0363_R25_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R25_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0363_R25_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R25_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_R25_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_R25_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_R25_tsure_poke_static_suicune
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_SUICUNE, 40, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07AA
    @ HGSS: GetStaticEncounterOutcome VAR_TEMP_x4002
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _07A6
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _07B0
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _07B6
    BufferPlayerName 0
    Message msg_0363_R25_00018
    CloseMessage
    GoToIfSet FLAG_HGSS_HIDE_ROUTE_25_EUSINE_2, _0766
    GoTo _0786
_0766:
    ApplyMovement LOCALID_PLAYER, _07F4
    ApplyMovement obj_R25_minaki, _0800
    WaitMovement
    RemoveObject obj_R25_minaki
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE
    GoTo _07A0
_0786:
    ApplyMovement LOCALID_PLAYER, _07F4
    ApplyMovement obj_R25_minaki_2, _0800
    WaitMovement
    RemoveObject obj_R25_minaki_2
    SetFlag FLAG_HGSS_HIDE_ROUTE_25_EUSINE_2
_07A0:
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_25, 3
_07A6:
    ReleaseAll
    End
_07AA:
    BlackOutFromBattle
    ReleaseAll
    End
_07B0:
    SetFlag FLAG_HGSS_CAUGHT_SUICUNE
    Return
_07B6:
    WaitTime 20, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _07EC
    WaitMovement
    BufferPlayerName 0
    Message msg_0363_R25_00019
    CloseMessage
    GoToIfSet FLAG_HGSS_HIDE_ROUTE_25_EUSINE_2, _0766
    GoTo _0786
    .balign 4, 0
_07E0:
    FaceSouth
    Delay8 2
    EndMovement
    .balign 4, 0
_07EC:
    FaceSouth
    EndMovement
    .balign 4, 0
_07F4:
    Delay8 2
    FaceWest
    EndMovement
    .balign 4, 0
_0800:
    WalkNormalWest 11
    EndMovement
scr_seq_R25_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0363_R25_00015, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
