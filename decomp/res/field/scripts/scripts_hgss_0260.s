#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0407.h"

#define obj_R47_leader3 5

    ScriptEntry scr_seq_R47_000
    ScriptEntry scr_seq_R47_001
    ScriptEntry scr_seq_R47_002
    ScriptEntry scr_seq_R47_003
    ScriptEntry scr_seq_R47_004
    ScriptEntry scr_seq_R47_005
    ScriptEntry scr_seq_R47_006
    ScriptEntry scr_seq_R47_007
    ScriptEntry scr_seq_R47_008
    ScriptEntry scr_seq_R47_009
    ScriptEntry scr_seq_R47_010
    ScriptEntry scr_seq_R47_011
    ScriptEntry scr_seq_R47_012
    ScriptEntry scr_seq_R47_013
    ScriptEntry scr_seq_R47_014
    ScriptEntry scr_seq_R47_015
    ScriptEntry scr_seq_R47_016
    ScriptEntry scr_seq_R47_017
    ScriptEntry scr_seq_R47_018
    ScriptEntry scr_seq_R47_019
    ScriptEntry scr_seq_R47_020
    ScriptEntryEnd
scr_seq_R47_000:
    SetVarFromValue VAR_HGSS_UNK_40EB, 1
    SetFlag FLAG_HGSS_UNK_9C9
    GoToIfUnset FLAG_HGSS_CAUGHT_GROUDON, _0674
    SetWarpEventPos 4, 87, 385
    SetWarpEventPos 5, 87, 389
    SetWarpEventPos 6, 87, 385
    GoTo _06C4
scr_seq_R47_002:
    GoToIfSet FLAG_HGSS_CAUGHT_KYOGRE, _06FC
    GoToIfUnset FLAG_HGSS_CAUGHT_GROUDON, _0716
    SetWarpEventPos 4, 87, 385
    SetWarpEventPos 5, 87, 389
    SetWarpEventPos 6, 87, 385
    GoTo _0730
scr_seq_R47_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_MET_ROUTE_47_EMBEDDED_TOWER_HIKER, _0732
    Message msg_0407_R47_00000
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_MET_ROUTE_47_EMBEDDED_TOWER_HIKER
    ReleaseAll
    End
scr_seq_R47_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_157, _073D
    Message msg_0407_R47_00002
    ApplyMovement obj_R47_leader3, _0894
    WaitMovement
    Message msg_0407_R47_00003
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0757
    ApplyMovement obj_R47_leader3, _089A
    GoTo _0772
scr_seq_R47_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0407_R47_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _078E
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0799
    Message msg_0407_R47_00006
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 91
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0407_R47_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R47_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    ApplyMovement LOCALID_PLAYER, _08A0
    WaitMovement
    Message msg_0407_R47_00010
    WaitButton
    StopMusic
    PlayMusic SEQ_GS_D_SHINTO_sseq
    Message msg_0407_R47_00011
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_61A1, 2
    SetFlag FLAG_HGSS_SG_3FE7
    ReleaseAll
    End
scr_seq_R47_006:
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    ApplyMovement 15, _08A6
    ApplyMovement 15, _08A0
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _08AC
    Message msg_0407_R47_00012
    ApplyMovement LOCALID_PLAYER, _08B2
    ApplyMovement 15, _08B2
    WaitMovement
    Message msg_0407_R47_00013
    CloseMessage
    StartTagBattle TRAINER_HGSS_SUPER_NERD_MICKEY, TRAINER_HGSS_SAGE_MICKEY, TRAINER_HGSS_SAGE_MICKEY_2
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07A4
    Message msg_0407_R47_00014
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 13
    RemoveObject 14
    SetFlag FLAG_HGSS_SG_3FE6
    FadeScreen 8, 1, 1, COLOR_BLACK
    ApplyMovement 15, _08A6
    ApplyMovement LOCALID_PLAYER, _08AC
    Message msg_0407_R47_00015
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    WaitForTransition
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_SG_61A0, 2
    ReleaseAll
    End
scr_seq_R47_007:
    NPCMessage msg_0407_R47_00016
    End
scr_seq_R47_008:
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    ApplyMovement 19, _08AC
    ApplyMovement 19, _08A0
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _08A6
    Message msg_0407_R47_00020
    ApplyMovement LOCALID_PLAYER, _08B2
    ApplyMovement 19, _08B2
    WaitMovement
    Message msg_0407_R47_00021
    CloseMessage
    StartTagBattle TRAINER_HGSS_TEAM_ROCKET_MICKEY, TRAINER_HGSS_ACE_TRAINER_M_MICKEY, TRAINER_HGSS_ACE_TRAINER_M_MICKEY_2
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07A4
    Message msg_0407_R47_00022
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 17
    RemoveObject 18
    SetFlag FLAG_HGSS_SG_3FE6
    FadeScreen 8, 1, 1, COLOR_BLACK
    ApplyMovement 19, _08AC
    ApplyMovement LOCALID_PLAYER, _08A6
    Message msg_0407_R47_00023
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    WaitForTransition
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_619F, 2
    ReleaseAll
    End
scr_seq_R47_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfUnset FLAG_HGSS_SG_3FE6, _07AA
    FacePlayer
    PlayCry SPECIES_ALAKAZAM, 0
    Message msg_0407_R47_00017
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R47_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3FE5, _07BD
    Message msg_0407_R47_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R47_011:
    NPCMessage msg_0407_R47_00024
    End
scr_seq_R47_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfUnset FLAG_HGSS_SG_3FE5, _07CC
    FacePlayer
    PlayCry SPECIES_CLAYDOL, 0
    Message msg_0407_R47_00025
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R47_013:
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    ApplyMovement 24, _08A6
    ApplyMovement 24, _08A0
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _08AC
    WaitMovement
    Message msg_0407_R47_00026
    ApplyMovement LOCALID_PLAYER, _08B2
    ApplyMovement 24, _08B2
    WaitMovement
    Message msg_0407_R47_00027
    CloseMessage
    StartTagBattle TRAINER_HGSS_CAMPER_MICKEY, TRAINER_HGSS_SWIMMER_F_MICKEY, TRAINER_HGSS_SWIMMER_F_MICKEY_2
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07A4
    Message msg_0407_R47_00028
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 22
    RemoveObject 23
    SetFlag FLAG_HGSS_SG_3FE4
    FadeScreen 8, 1, 1, COLOR_BLACK
    ApplyMovement 24, _08A6
    ApplyMovement LOCALID_PLAYER, _08AC
    Message msg_0407_R47_00029
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    WaitForTransition
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_619E, 2
    ReleaseAll
    End
scr_seq_R47_014:
    NPCMessage msg_0407_R47_00030
    End
scr_seq_R47_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfUnset FLAG_HGSS_SG_3FE4, _07DF
    FacePlayer
    PlayCry SPECIES_BLISSEY, 0
    Message msg_0407_R47_00031
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R47_016:
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    ApplyMovement 28, _08A6
    ApplyMovement 28, _08A0
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _08AC
    WaitMovement
    Message msg_0407_R47_00032
    ApplyMovement LOCALID_PLAYER, _08B8
    ApplyMovement 28, _08B8
    WaitMovement
    Message msg_0407_R47_00033
    CloseMessage
    StartTagBattle TRAINER_HGSS_CAMPER_MICKEY_2, TRAINER_HGSS_SWIMMER_F_MICKEY_3, TRAINER_HGSS_SWIMMER_M_MICKEY
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07A4
    Message msg_0407_R47_00034
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 26
    RemoveObject 27
    SetFlag FLAG_HGSS_SG_3FE3
    FadeScreen 8, 1, 1, COLOR_BLACK
    ApplyMovement 28, _08A6
    ApplyMovement LOCALID_PLAYER, _08AC
    Message msg_0407_R47_00035
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    WaitForTransition
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_6139, 2
    ReleaseAll
    End
scr_seq_R47_017:
    NPCMessage msg_0407_R47_00036
    End
scr_seq_R47_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfUnset FLAG_HGSS_SG_3FE3, _07F2
    FacePlayer
    PlayCry SPECIES_ARCANINE, 0
    Message msg_0407_R47_00037
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R47_019:
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetFlag FLAG_HGSS_SG_3FFF
    Message msg_0407_R47_00038
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_ACE_TRAINER_M_MICKEY_3, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06C4
    Message msg_0407_R47_00039
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 30
    FadeScreen 8, 1, 1, COLOR_BLACK
    SetFlag FLAG_HGSS_SG_3FE1
    Message msg_0407_R47_00041
    SetVar VAR_0x8004, ITEM_TM84
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
scr_seq_R47_020:
    NPCMessage msg_0407_R47_00040
    End
_0674:
    SetWarpEventPos 4, 87, 389
    SetWarpEventPos 5, 87, 385
    SetWarpEventPos 6, 87, 385
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    GoToIf 1, _0805
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 3
    GoToIf 1, _0805
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 5
    GoToIf 4, _080B
    GoToIfUnset FLAG_HGSS_UNK_189, _0829
    ClearFlag FLAG_HGSS_UNK_189
    End
_06C4:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    GoToIf 1, _0805
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 3
    GoToIf 1, _0805
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 5
    GoToIf 4, _080B
    GoToIfUnset FLAG_HGSS_UNK_189, _0829
    ClearFlag FLAG_HGSS_UNK_189
    End
_06FC:
    SetWarpEventPos 4, 87, 385
    SetWarpEventPos 5, 87, 385
    SetWarpEventPos 6, 87, 389
    End
_0716:
    SetWarpEventPos 4, 87, 389
    SetWarpEventPos 5, 87, 385
    SetWarpEventPos 6, 87, 385
    End
_0730:
    End
_0732:
    Message msg_0407_R47_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_073D:
    BufferPlayerName 0
    Message msg_0407_R47_00004
    CloseMessage
    ApplyMovement obj_R47_leader3, _0894
    WaitMovement
    SetFlag FLAG_HGSS_UNK_157
    ReleaseAll
    End
_0757:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _083A
    ApplyMovement obj_R47_leader3, _08BE
    GoTo _0772
_0772:
    WaitMovement
    BufferPlayerName 0
    Message msg_0407_R47_00004
    CloseMessage
    ApplyMovement obj_R47_leader3, _0894
    WaitMovement
    SetFlag FLAG_HGSS_UNK_157
    ReleaseAll
    End
_078E:
    Message msg_0407_R47_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0799:
    Message msg_0407_R47_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_07A4:
    BlackOutFromBattle
    ReleaseAll
    End
_07AA:
    PlayCry SPECIES_ALAKAZAM, 0
    Message msg_0407_R47_00017
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
_07BD:
    Message msg_0407_R47_00019
    WaitButton
    CloseMessage
    RemoveObject 21
    ReleaseAll
    End
_07CC:
    PlayCry SPECIES_CLAYDOL, 0
    Message msg_0407_R47_00025
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
_07DF:
    PlayCry SPECIES_BLISSEY, 0
    Message msg_0407_R47_00031
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
_07F2:
    PlayCry SPECIES_ARCANINE, 0
    Message msg_0407_R47_00037
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0805:
    SetFlag FLAG_HGSS_HIDE_ROUTE_47_CHUCK
    End
_080B:
    SetWarpEventPos 4, 87, 385
    SetWarpEventPos 5, 87, 385
    SetWarpEventPos 6, 87, 389
    GoTo _0805
_0829:
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _085E
    GoTo _0805
_083A:
    ApplyMovement obj_R47_leader3, _08C4
    WaitMovement
    BufferPlayerName 0
    Message msg_0407_R47_00004
    CloseMessage
    ApplyMovement obj_R47_leader3, _0894
    WaitMovement
    SetFlag FLAG_HGSS_UNK_157
    ReleaseAll
    End
_085E:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_CHUCK, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0805
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _088C
    ClearFlag FLAG_HGSS_HIDE_ROUTE_47_CHUCK
    GoTo _0892
_088C:
    SetFlag FLAG_HGSS_HIDE_ROUTE_47_CHUCK
    End
_0892:
    End
    .balign 4, 0
_0894:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_089A:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_08A0:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_08A6:
    FaceSouth
    EndMovement
    .balign 4, 0
_08AC:
    FaceNorth
    EndMovement
    .balign 4, 0
_08B2:
    FaceWest
    EndMovement
    .balign 4, 0
_08B8:
    FaceEast
    EndMovement
    .balign 4, 0
_08BE:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_08C4:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
