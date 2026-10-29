#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0543.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T20R0101_doctor 0
#define obj_T20R0101_policeman 1
#define obj_T20R0101_assistantm 2
#define obj_T20R0101_var_1 3

    ScriptEntry scr_seq_T20R0101_000
    ScriptEntry scr_seq_T20R0101_001
    ScriptEntry scr_seq_T20R0101_002
    ScriptEntry scr_seq_T20R0101_003
    ScriptEntry scr_seq_T20R0101_004
    ScriptEntry scr_seq_T20R0101_005
    ScriptEntry scr_seq_T20R0101_006
    ScriptEntry scr_seq_T20R0101_007
    ScriptEntry scr_seq_T20R0101_008
    ScriptEntry scr_seq_T20R0101_009
    ScriptEntry scr_seq_T20R0101_010
    ScriptEntry scr_seq_T20R0101_011
    ScriptEntry scr_seq_T20R0101_012
    ScriptEntry scr_seq_T20R0101_013
    ScriptEntry scr_seq_T20R0101_014
    ScriptEntry scr_seq_T20R0101_015
    ScriptEntryEnd
scr_seq_T20R0101_010:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    GoToIfSet FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE, _00B8
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 0
    GoToIf 5, _0070
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_SOUTH
    GoTo _00B4
_0070:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 3
    GoToIf 5, _008F
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_SOUTH
    GoTo _00B4
_008F:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 8
    GoToIf 5, _00B4
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_SOUTH
    SetPosition obj_T20R0101_var_1, 7, 0, 12, DIR_EAST
_00B4:
    @ HGSS: PlaceStarterBallsInElmsLab
    End
_00B8:
    SetPosition obj_T20R0101_doctor, 4, 0, 5, DIR_EAST
    GoTo _00B4
scr_seq_T20R0101_011:
    LockAll
    GoToIfSet FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE, _0197
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _00FA
    ApplyMovement LOCALID_PLAYER, _01BC
    GoTo _0145
_00FA:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0115
    ApplyMovement LOCALID_PLAYER, _01CC
    GoTo _0145
_0115:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0130
    ApplyMovement LOCALID_PLAYER, _01D4
    GoTo _0145
_0130:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0145
    ApplyMovement LOCALID_PLAYER, _01E4
_0145:
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00000, msg_0543_T20R0101_00001
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0368
    WaitMovement
    WaitTime 15, VAR_0x8004
    ApplyMovement obj_T20R0101_doctor, _01F4
    WaitMovement
    Message msg_0543_T20R0101_00002
    Message msg_0543_T20R0101_00003
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0204
    WaitMovement
    Message msg_0543_T20R0101_00004
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0368
    WaitMovement
    SetFlag FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE
    ReleaseAll
    End
_0197:
    ApplyMovement obj_T20R0101_doctor, _020C
    WaitMovement
    Message msg_0543_T20R0101_00006
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0368
    ApplyMovement LOCALID_PLAYER, _021C
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_01BC:
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_01CC:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_01D4:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_01E4:
    WalkNormalNorth 2
    WalkNormalWest 2
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_01F4:
    EmoteExclamationMark
    WalkNormalNorth
    Delay16
    EndMovement
    .balign 4, 0
_0204:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_020C:
    FaceSouth
    EmoteExclamationMark
    WalkOnSpotNormalSouth 2
    EndMovement
    .balign 4, 0
_021C:
    WalkNormalNorth
    EndMovement
scr_seq_T20R0101_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_STARTER, _0331
    @ HGSS: ChooseStarter
    SetFlag FLAG_HGSS_GOT_STARTER
    @ HGSS: ScrCmd_605 3, 2
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
    GetPartyMonSpecies 0, VAR_MAP_LOCAL_0x01
    @ HGSS: SetStarterChoice VAR_TEMP_x4001
    BufferPlayerName 0
    BufferPartyMonSpecies 1, 0
    Message msg_0543_T20R0101_00007
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    BufferPartyMonSpecies 1, 0
    Message msg_0543_T20R0101_00008
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    CallIf 1, _02EE
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0370
    ApplyMovement obj_T20R0101_doctor, _0388
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0543_T20R0101_00010
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0380
    WaitMovement
    Message msg_0543_T20R0101_00011
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0390
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00012, msg_0543_T20R0101_00013
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 1
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 1
    ClearFlag FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE
    ReleaseAll
    End
_02EE:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput 0, VAR_TEMP_x4000
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    BufferPartyMonNickname 1, 0
    Message msg_0543_T20R0101_00009
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02EE
    Return
_0331:
    GoToIfSet FLAG_HGSS_GOT_TM51_FROM_FALKNER, _035D
    GoToIfSet FLAG_HGSS_MET_PASSERBY_BOY, _0352
    Message msg_0543_T20R0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0352:
    Message msg_0543_T20R0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_035D:
    Message msg_0543_T20R0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0368:
    FaceEast
    EndMovement
    .balign 4, 0
_0370:
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0380:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0388:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0390:
    Delay16
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_T20R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_SS_TICKET_FROM_ELM, _03BA
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0526
_03BA:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03F5
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, SPECIES_PICHU
    GoToIf 5, _03F5
    GetPartyMonForm2 VAR_MAP_LOCAL_0x00, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0CDC
_03F5:
    GoToIfSet FLAG_HGSS_UNK_072, _04A1
    GoToIfSet FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG, _055F
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 9
    GoToIf 4, _04A1
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 0
    GoToIf 5, _043C
    Message msg_0543_T20R0101_00005
    WaitButton
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0368
    WaitMovement
    GoTo _049D
_043C:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 2
    GoToIf 2, _045A
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00012, msg_0543_T20R0101_00013
    WaitButton
    CloseMessage
    GoTo _049D
_045A:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 5
    GoToIf 2, _0474
    Message msg_0543_T20R0101_00040
    WaitButton
    CloseMessage
    GoTo _049D
_0474:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 6
    GoToIf 5, _0492
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00042, msg_0543_T20R0101_00043
    WaitButton
    CloseMessage
    GoTo _049D
_0492:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00044, msg_0543_T20R0101_00045
    WaitButton
    CloseMessage
_049D:
    ReleaseAll
    End
_04A1:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 1, _0550
    GoToIfSet FLAG_HGSS_GOT_SS_TICKET_FROM_ELM, _0541
    GoToIfSet FLAG_HGSS_UNK_108, _051B
    GoToIfSet FLAG_HGSS_UNK_109, _051B
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0510
    CompareVar VAR_MAP_LOCAL_0x0F, 1
    GoToIf 1, _0504
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00098, msg_0543_T20R0101_00099
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0504:
    MessageGendered msg_0543_T20R0101_00100, msg_0543_T20R0101_00101
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0510:
    Message msg_0543_T20R0101_00069
    WaitButton
    CloseMessage
    ReleaseAll
    End
_051B:
    Message msg_0543_T20R0101_00070
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0526:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00071, msg_0543_T20R0101_00072
    SetVarFromValue VAR_0x8004, ITEM_SS_TICKET
    SetVarFromValue VAR_0x8005, 1
    SetFlag FLAG_HGSS_GOT_SS_TICKET_FROM_ELM
    Common_GiveItemQuantity
_0541:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00073, msg_0543_T20R0101_00074
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0550:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00102, msg_0543_T20R0101_00103
    WaitButton
    CloseMessage
    ReleaseAll
    End
_055F:
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    @ HGSS: UnsetPhoneCallTrigger CALL_TRIGGER_ELM_EGG_HATCHED
    CompareVar VAR_MAP_LOCAL_0x01, SPECIES_TOGEPI
    GoToIf 1, _0599
    CompareVar VAR_MAP_LOCAL_0x01, SPECIES_TOGETIC
    GoToIf 1, _0599
    CompareVar VAR_MAP_LOCAL_0x01, SPECIES_TOGEKISS
    GoToIf 1, _0599
    GoTo _0637
_0599:
    ApplyMovement obj_T20R0101_doctor, _0658
    WaitMovement
    Message msg_0543_T20R0101_00046
    BufferPlayerName 0
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _05D9
    GoToIfUnset FLAG_HGSS_UNK_108, _05CF
    MessageGendered msg_0543_T20R0101_00104, msg_0543_T20R0101_00105
    GoTo _05D3
_05CF:
    MessageGendered msg_0543_T20R0101_00047, msg_0543_T20R0101_00048
_05D3:
    GoTo _05F2
_05D9:
    GoToIfUnset FLAG_HGSS_UNK_109, _05EE
    MessageGendered msg_0543_T20R0101_00104, msg_0543_T20R0101_00105
    GoTo _05F2
_05EE:
    MessageGendered msg_0543_T20R0101_00047, msg_0543_T20R0101_00048
_05F2:
    SetVar VAR_0x8004, ITEM_EVERSTONE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _064E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_072
    SetFlag FLAG_HGSS_GOT_EVERSTONE_FROM_ELM
    SetVarFromValue VAR_MAP_LOCAL_0x0F, 0
    Message msg_0543_T20R0101_00049
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00050, msg_0543_T20R0101_00051
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0637:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00053, msg_0543_T20R0101_00054
    SetVarFromValue VAR_MAP_LOCAL_0x0F, 1
    GoTo _04A1
_064A:
    ReleaseAll
    End
_064E:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0658:
    EmoteExclamationMark
    Delay4
    EndMovement
scr_seq_T20R0101_003:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0689
    ApplyMovement obj_T20R0101_assistantm, _081C
    GoTo _06D4
_0689:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _06A4
    ApplyMovement obj_T20R0101_assistantm, _082C
    GoTo _06D4
_06A4:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _06BF
    ApplyMovement obj_T20R0101_assistantm, _083C
    GoTo _06D4
_06BF:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _06D4
    ApplyMovement obj_T20R0101_assistantm, _084C
_06D4:
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00019, msg_0543_T20R0101_00020
    SetVar VAR_0x8004, ITEM_POTION
    SetVar VAR_0x8005, 5
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0805
    SetVarFromValue VAR_0x8004, ITEM_POTION
    SetVarFromValue VAR_0x8005, 5
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 2
    Message msg_0543_T20R0101_00021
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0736
    ApplyMovement obj_T20R0101_assistantm, _0864
    GoTo _0781
_0736:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0751
    ApplyMovement obj_T20R0101_assistantm, _0870
    GoTo _0781
_0751:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _076C
    ApplyMovement obj_T20R0101_assistantm, _087C
    GoTo _0781
_076C:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0781
    ApplyMovement obj_T20R0101_assistantm, _0888
_0781:
    WaitMovement
    ReleaseAll
    End
scr_seq_T20R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40FC, 3
    GoToIf 1, _080F
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 0
    GoToIf 5, _07B2
    Message msg_0543_T20R0101_00018
    GoTo _07FD
_07B2:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 2
    GoToIf 5, _07C8
    Message msg_0543_T20R0101_00022
    GoTo _07FD
_07C8:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 4
    GoToIf 5, _07E4
    Message msg_0543_T20R0101_00041
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 5
    GoTo _07FD
_07E4:
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 6
    GoToIf 5, _07FA
    Message msg_0543_T20R0101_00055
    GoTo _07FD
_07FA:
    Message msg_0543_T20R0101_00055
_07FD:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0805:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_080F:
    Message msg_0543_T20R0101_00057
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_081C:
    EmoteExclamationMark
    WalkSlightlyFastWest 6
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_082C:
    EmoteExclamationMark
    WalkSlightlyFastWest 5
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_083C:
    EmoteExclamationMark
    WalkSlightlyFastWest 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_084C:
    EmoteExclamationMark
    WalkSlightlyFastWest 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_085C:
    FaceEast
    EndMovement
    .balign 4, 0
_0864:
    WalkSlightlyFastEast 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0870:
    WalkSlightlyFastEast 5
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_087C:
    WalkSlightlyFastEast 4
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0888:
    WalkSlightlyFastEast 3
    WalkOnSpotNormalWest
    EndMovement
scr_seq_T20R0101_002:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0A68
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T20R0101_policeman, _0A7C
    WaitMovement
    Message msg_0543_T20R0101_00023
    CloseMessage
    ClearFlag FLAG_HGSS_HIDE_ELMS_LAB_FRIEND
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    AddObject obj_T20R0101_var_1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    Common_SetCounterpartBGM
    ApplyMovement obj_T20R0101_var_1, _0ADC
    ApplyMovement obj_T20R0101_policeman, _0A84
    WaitMovement
    MessageGendered msg_0543_T20R0101_00024, msg_0543_T20R0101_00025
    CloseMessage
    ApplyMovement obj_T20R0101_policeman, _0A90
    WaitMovement
    Message msg_0543_T20R0101_00026
    CloseMessage
    Common_FadeToDefaultMusic
_0904:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NameRival VAR_SPECIAL_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0904
    ApplyMovement obj_T20R0101_policeman, _0A7C
    WaitMovement
    BufferRivalName 1
    Message msg_0543_T20R0101_00027
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A59
    CloseMessage
    Message msg_0543_T20R0101_00028
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _0AEC
    ApplyMovement obj_T20R0101_policeman, _0ABC
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20R0101_policeman
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T20R0101_var_1, _0B08
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00030, msg_0543_T20R0101_00031
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _0B18
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20R0101_var_1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_OFFICER
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_FRIEND
    SetFlag FLAG_HGSS_GAVE_RIVAL_NAME_TO_OFFICER
    ApplyMovement LOCALID_PLAYER, _0A74
    WaitMovement
    ApplyMovement obj_T20R0101_doctor, _0B2C
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00032, msg_0543_T20R0101_00033
    CloseMessage
    Message msg_0543_T20R0101_00034
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVar VAR_0x8004, ITEM_MYSTERY_EGG
    SetVar VAR_0x8005, 1
    RemoveItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    ApplyMovement obj_T20R0101_doctor, _0B34
    WaitMovement
    Message msg_0543_T20R0101_00035
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0B48
    WaitMovement
    MessageGendered msg_0543_T20R0101_00036, msg_0543_T20R0101_00037
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0B50
    WaitMovement
    MessageGendered msg_0543_T20R0101_00038, msg_0543_T20R0101_00039
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0B64
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_ROUTE_30_BATTLERS
    ClearFlag FLAG_HGSS_HIDE_ROUTE_30_YOUNGSTER_JOEY
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 4
    SetVarFromValue VAR_HGSS_UNK_408B, 1
    ClearFlag FLAG_HGSS_HIDE_ROUTE_29_FRIEND
    ClearFlag FLAG_HGSS_HIDE_ROUTE_29_MARILL
    SetVarFromValue VAR_HGSS_SCENE_MR_POKEMONS_HOUSE, 2
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 3
    ClearFlag FLAG_HGSS_HIDE_CHERRYGROVE_MART_SPECIAL_CLERK
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_PHONE_CALL, 1
    ReleaseAll
    End
_0A59:
    Message msg_0543_T20R0101_00029
    CloseMessage
    GoTo _0904
    End
    .balign 4, 0
_0A68:
    WalkSlightlyFastNorth 8
    FaceWest
    EndMovement
    .balign 4, 0
_0A74:
    FaceNorth
    EndMovement
    .balign 4, 0
_0A7C:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0A84:
    Delay8 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0A90:
    EmoteExclamationMark
    Delay1
    FaceSouth
    Delay8 2
    FaceEast
    Delay8 2
    FaceSouth
    Delay8 2
    FaceEast
    Delay8 2
    EndMovement
    .balign 4, 0
_0ABC:
    FaceSouth
    Delay4
    WalkNormalSouth 6
    FaceEast
    WalkNormalEast
    FaceSouth
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0ADC:
    WalkFastNorth 6
    WalkFastWest
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_0AEC:
    FaceWest
    LockDir
    WalkNormalEast
    UnlockDir
    Delay32
    FaceSouth
    EndMovement
    .balign 4, 0
_0B08:
    WalkNormalWest
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0B18:
    FaceSouth
    WalkNormalSouth 6
    WalkNormalEast
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0B2C:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0B34:
    JumpOnSpotFastSouth
    LockDir
    WalkSlightlyFasterNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_0B48:
    WalkSlightlyFastSouth
    EndMovement
    .balign 4, 0
_0B50:
    FaceNorth
    WalkSlowNorth
    Delay15
    FaceSouth
    EndMovement
    .balign 4, 0
_0B64:
    WalkSlightlyFastSouth
    EndMovement
scr_seq_T20R0101_014:
    LockAll
    ApplyMovement obj_T20R0101_var_1, _0C78
    WaitMovement
    ApplyMovement obj_T20R0101_var_1, _0C84
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00058, msg_0543_T20R0101_00059
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0CA4
    ApplyMovement obj_T20R0101_var_1, _0C90
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T20R0101_doctor, _0B2C
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00060, msg_0543_T20R0101_00061
    SetVarFromValue VAR_0x8004, 1
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0BEF
    Common_MessageBagIsFull
    GoTo _0BF3
_0BEF:
    Common_GiveItemQuantity
_0BF3:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00062, msg_0543_T20R0101_00063
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00064, msg_0543_T20R0101_00065
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _0CAC
    ApplyMovement LOCALID_PLAYER, _0CB8
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00067, msg_0543_T20R0101_00068
    CloseMessage
    ApplyMovement obj_T20R0101_var_1, _0CC4
    WaitMovement
    RemoveObject obj_T20R0101_var_1
    SetFlag FLAG_HGSS_HIDE_ELMS_LAB_FRIEND
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T20R0101_doctor, _0B2C
    ApplyMovement LOCALID_PLAYER, _0CD4
    WaitMovement
    Message msg_0543_T20R0101_00069
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 9
    SetVarFromValue VAR_HGSS_UNK_4079, 3
    SetFlag FLAG_HGSS_UNK_23B
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND_2
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_EAST_EXIT, 2
    SetVarFromValue VAR_HGSS_UNK_407B, 2
    End
    .balign 4, 0
_0C78:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0C84:
    WalkSlightlyFastWest 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C90:
    WalkNormalNorth 5
    WalkNormalEast
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0CA4:
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_0CAC:
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0CB8:
    Delay8
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0CC4:
    WalkSlightlyFastSouth 3
    WalkSlightlyFastWest
    WalkSlightlyFastSouth 4
    EndMovement
    .balign 4, 0
_0CD4:
    WalkOnSpotNormalNorth
    EndMovement
_0CDC:
    CompareVar VAR_MAP_LOCAL_0x06, 1
    GoToIf 1, _0DD2
    CompareVar VAR_HGSS_UNK_412F, 2
    GoToIf 4, _1044
    CompareVar VAR_HGSS_UNK_412F, 1
    GoToIf 1, _0FE4
    Call _0DE3
    ApplyMovement obj_T20R0101_doctor, _0F48
    WaitMovement
    Message msg_0543_T20R0101_00075
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0F50
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0F38
    WaitMovement
    Message msg_0543_T20R0101_00076
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0F48
    WaitMovement
    Message msg_0543_T20R0101_00077
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0F60
    WaitMovement
    Message msg_0543_T20R0101_00078
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0FBC
    WaitMovement
    Message msg_0543_T20R0101_00079
    CloseMessage
    .short SCRCMD_UNUSED_06A
    .short 0
    .short VAR_0x8006
    .short VAR_0x8007
    CompareVar VAR_0x8006, 4
    GoToIf 5, _0D81
    ApplyMovement obj_T20R0101_doctor, _0F98
    GoTo _0D89
_0D81:
    ApplyMovement obj_T20R0101_doctor, _0F6C
_0D89:
    WaitMovement
    Message msg_0543_T20R0101_00080
    CloseMessage
    CompareVar VAR_0x8006, 4
    GoToIf 5, _0DAD
    ApplyMovement obj_T20R0101_doctor, _0FDC
    WaitMovement
    GoTo _0DB7
_0DAD:
    ApplyMovement obj_T20R0101_doctor, _0FCC
    WaitMovement
_0DB7:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00081, msg_0543_T20R0101_00082
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_412F, 1
    AddVar VAR_MAP_LOCAL_0x06, 1
    ReleaseAll
    End
_0DD2:
    Message msg_0543_T20R0101_00083
    WaitButton
    CloseMessage
    AddVar VAR_MAP_LOCAL_0x06, 1
    ReleaseAll
    End
_0DE3:
    BufferPlayerName 0
    MessageGendered msg_0543_T20R0101_00084, msg_0543_T20R0101_00085
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    .short SCRCMD_UNUSED_06A
    .short 0
    .short VAR_0x8006
    .short VAR_0x8007
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0E27
    ApplyMovement LOCALID_PLAYER, _0EB8
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0F0C
    GoTo _0EA8
_0E27:
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _0E4C
    ApplyMovement LOCALID_PLAYER, _0EC4
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0F1C
    GoTo _0EA8
_0E4C:
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 5, _0E71
    ApplyMovement LOCALID_PLAYER, _0ED4
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0F30
    GoTo _0EA8
_0E71:
    CompareVar VAR_0x8006, 4
    GoToIf 5, _0E96
    ApplyMovement LOCALID_PLAYER, _0EF8
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0F30
    GoTo _0EA8
_0E96:
    ApplyMovement LOCALID_PLAYER, _0EE4
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0F1C
_0EA8:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
    .balign 4, 0
_0EB8:
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0EC4:
    WalkNormalSouth 2
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0ED4:
    WalkNormalSouth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0EE4:
    WalkNormalWest
    WalkNormalSouth 3
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0EF8:
    WalkNormalEast
    WalkNormalSouth 3
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0F0C:
    WalkNormalEast
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0F1C:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0F30:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0F38:
    JumpOnSpotFastSouth
    Delay16
    JumpOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0F48:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0F50:
    WalkNormalSouth
    WalkNormalEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0F60:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0F6C:
    WalkNormalNorth
    WalkNormalWest 2
    WalkOnSpotNormalNorth
    Delay8 2
    LockDir
    WalkSlowEast
    WalkOnSpotNormalNorth
    WalkSlowWest
    UnlockDir
    Delay8 2
    EndMovement
    .balign 4, 0
_0F98:
    WalkNormalNorth
    Delay8 2
    LockDir
    WalkSlowEast
    WalkOnSpotNormalNorth
    WalkSlowWest
    UnlockDir
    Delay8 2
    EndMovement
    .balign 4, 0
_0FBC:
    WalkNormalNorth
    WalkNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0FCC:
    WalkNormalSouth
    WalkNormalEast 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0FDC:
    WalkNormalSouth
    EndMovement
_0FE4:
    @ HGSS: MonGetFriendship VAR_SPECIAL_RESULT, VAR_TEMP_x4000
    CompareVar VAR_RESULT, 220
    GoToIf 4, _0FFF
    GoTo _03F5
    End
_0FFF:
    Call _0DE3
    MessageGendered msg_0543_T20R0101_00086, msg_0543_T20R0101_00087
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0F60
    WaitMovement
    Message msg_0543_T20R0101_00088
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0F50
    WaitMovement
    Message msg_0543_T20R0101_00089
    CloseMessage
    ApplyMovement obj_T20R0101_doctor, _0FBC
    WaitMovement
    Message msg_0543_T20R0101_00090
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_412F, 2
    ReleaseAll
    End
_1044:
    Message msg_0543_T20R0101_00091
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_004:
    End
scr_seq_T20R0101_005:
    BufferPlayerName 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00093
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_006:
    BufferPlayerName 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00094
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_007:
    BufferPlayerName 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00095
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_008:
    BufferPlayerName 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00096
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0543_T20R0101_00097
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_GOT_STARTER, _1107
    Message msg_0543_T20R0101_00092
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _1103
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ASA_sseq
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    WaitFanfare
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_1103:
    ReleaseAll
    End
_1107:
    Message msg_0543_T20R0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0101_015:
    LockAll
    ApplyMovement obj_T20R0101_assistantm, _113C
    WaitMovement
    BufferPlayerName 0
    Message msg_0543_T20R0101_00056
    CloseMessage
    ApplyMovement obj_T20R0101_assistantm, _1148
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40FC, 3
    ReleaseAll
    End
    .balign 4, 0
_113C:
    WalkNormalWest 5
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_1148:
    WalkNormalNorth
    WalkNormalEast 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
