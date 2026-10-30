#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0512.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T08_gsboy2 2
#define obj_T08_gsmiddleman1_2 5
#define obj_T08_juggrer 6

    ScriptEntry scr_seq_T08_000
    ScriptEntry scr_seq_T08_001
    ScriptEntry scr_seq_T08_002
    ScriptEntry scr_seq_T08_003
    ScriptEntry scr_seq_T08_004
    ScriptEntry scr_seq_T08_005
    ScriptEntry scr_seq_T08_006
    ScriptEntry scr_seq_T08_007
    ScriptEntry scr_seq_T08_008
    ScriptEntry scr_seq_T08_009
    ScriptEntry scr_seq_T08_010
    ScriptEntry scr_seq_T08_011
    ScriptEntry scr_seq_T08_012
    ScriptEntry scr_seq_T08_013
    ScriptEntry scr_seq_T08_014
    ScriptEntry scr_seq_T08_015
    ScriptEntry scr_seq_T08_016
    ScriptEntry scr_seq_T08_017
    ScriptEntry scr_seq_T08_018
    ScriptEntry scr_seq_T08_019
    ScriptEntryEnd
scr_seq_T08_007:
    GoToIfUnset FLAG_HGSS_UNK_189, _039A
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T08_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03C2
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03D6
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _03EA
    ApplyMovement LOCALID_PLAYER, _0EDE
    GoTo _045B
scr_seq_T08_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Call _04BC
    Call _04DD
    CompareVar VAR_0x8006, 1
    GoToIf 1, _0563
    Message msg_0512_T08_00007
    CloseMessage
    Call _04BC
    ReleaseAll
    End
scr_seq_T08_000:
    NPCMessage msg_0512_T08_00000
    End
scr_seq_T08_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_SG_3F63, _0610
    Message msg_0512_T08_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_SG_3F63, _061B
    Message msg_0512_T08_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08_009:
    DrawSignpostInstantMessage msg_0512_T08_00003, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T08_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0512_T08_00004, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T08_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0512_T08_00005, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T08_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0512_T08_00006, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T08_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F61, _0626
    PlayCry SPECIES_SHELLDER, 0
    Message msg_0512_T08_00016
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F61, _0668
    PlayCry SPECIES_CLOYSTER, 0
    Message msg_0512_T08_00017
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08_012:
    NPCMessage msg_0512_T08_00018
    End
scr_seq_T08_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_CLOYSTER, 0
    Message msg_0512_T08_00022
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_CHANSEY, 6
    Message msg_0512_T08_00021
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_SG_3F61, _06DB
    FadeOutBGM 0, 10
    PlayMusic SEQ_GS_VS_GYMREADER_KANTO_sseq
    Message msg_0512_T08_00023
    CloseMessage
    ReleaseObject 27
    ReleaseObject 25
    PlayDefaultMusic
    PlayCry SPECIES_VENOMOTH, 5
    WaitCry
    PlayCry SPECIES_VENOMOTH, 6
    WaitCry
    PlayCry SPECIES_VENOMOTH, 0
    WaitCry
    PlayDefaultMusic
    StopMusic
    LockObject 27
    LockObject 25
    Message msg_0512_T08_00030
    CloseMessage
    ApplyMovement 29, _0EE8
    WaitMovement
    PlayMusic SEQ_GS_IBUKI_sseq
    FacePlayer
    Message msg_0512_T08_00024
    Message msg_0512_T08_00025
    Message msg_0512_T08_00026
    WaitButton
    CloseMessage
    FadeOutBGM 0, 10
    StopMusic
    PlayDefaultMusic
    ApplyMovement 29, _0EEE
    WaitMovement
    SetFlag FLAG_HGSS_SG_3F61
    ReleaseAll
    End
scr_seq_T08_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FadeOutBGM 0, 10
    PlayMusic SEQ_GS_VS_TRAINER_KANTO_sseq
    Message msg_0512_T08_00027
    CloseMessage
    ReleaseObject 28
    ReleaseObject 26
    PlayCry SPECIES_CHANSEY, 5
    WaitCry
    PlayCry SPECIES_CLOYSTER, 6
    WaitCry
    PlayCry SPECIES_CHANSEY, 0
    WaitCry
    LockObject 28
    LockObject 26
    FadeOutBGM 0, 10
    PlayDefaultMusic
    FadeOutBGM 0, 10
    PlayDefaultMusic
    LockAll
    FacePlayer
    Message msg_0512_T08_00028
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
    Message msg_0512_T08_00029
    WaitButton
    CloseMessage
    BufferPlayerName 0
    ApplyMovement 30, _0EEE
    WaitMovement
    ReleaseAll
    End
scr_seq_T08_017:
    End
scr_seq_T08_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F61, _07CA
    PlayCry SPECIES_CLOYSTER, 0
    Message msg_0512_T08_00017
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08_019:
    NPCMessage msg_0512_T08_00036
    End
_039A:
    ClearFlag FLAG_HGSS_UNK_149
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _083D
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _083D
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_03C2:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03D6:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03EA:
    ApplyMovement LOCALID_PLAYER, _0EF4
    ApplyMovement obj_T08_gsmiddleman1_2, _0F06
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0843
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0F10
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 62
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
_045B:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0843
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0F10
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 62
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
_04BC:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _087D
    ApplyMovement obj_T08_juggrer, _0F1E
    WaitMovement
    GoTo _089A
_04DD:
    CheckItem ITEM_RED_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _089C
    SetVarFromValue VAR_0x8000, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_BLUE_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0901
    SetVarFromValue VAR_0x8001, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0945
    SetVarFromValue VAR_0x8002, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0968
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
    Return
_0563:
    Message msg_0512_T08_00008
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    CompareVar VAR_0x8000, 1
    GoToIf 5, _096A
    AddMenuEntry 205, 0
    CompareVar VAR_0x8001, 1
    GoToIf 5, _09F5
    AddMenuEntry 206, 1
    CompareVar VAR_0x8002, 1
    GoToIf 5, _0A6B
    AddMenuEntry 207, 2
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0ACC
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B18
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0BBC
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0C60
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0D04
    GoTo _0DA8
_0610:
    Message msg_0512_T08_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_061B:
    Message msg_0512_T08_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0626:
    PlayCry SPECIES_SHELLDER, 0
    WaitCry
    FadeOutBGM 5, 0
    PlayMusic SEQ_GS_EYE_K_SHOUJO_sseq
    Message msg_0512_T08_00033
    CloseMessage
    PlayCry SPECIES_SHELLDER, 0
    WaitCry
    CompleteStartWildBattle SPECIES_SHELLDER, 50, 0
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _0DB7
    Message msg_0512_T08_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0668:
    PlayCry SPECIES_CLOYSTER, 0
    ReleaseObject 14
    @ HGSS: ScrCmd_523 14, 4, 90, 4, 0
    LockObject 14
    FadeOutBGM 5, 0
    PlayMusic SEQ_GS_EYE_K_SHOUNEN_sseq
    Message msg_0512_T08_00031
    CloseMessage
    PlayCry SPECIES_CLOYSTER, 0
    WaitCry
    CompleteStartWildBattle SPECIES_CLOYSTER, 54, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_SHELLDER, 6
    WaitCry
    RemoveObject 13
    RemoveObject 14
    RemoveObject 15
    RemoveObject 16
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0512_T08_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06DB:
    GoToIfUnset FLAG_HGSS_SG_3F60, _0DC2
    GoToIfUnset FLAG_HGSS_SG_3F5F, _0DC2
    GoToIfUnset FLAG_HGSS_SG_3F5E, _0DC2
    FadeOutBGM 0, 10
    StopMusic
    PlayMusic SEQ_GS_VS_GYMREADER_KANTO_sseq
    Message msg_0512_T08_00037
    CloseMessage
    PlayCry SPECIES_VENOMOTH, 0
    WaitCry
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_CLOYSTER, 6
    WaitCry
    PlayCry SPECIES_CLOYSTER, 5
    WaitCry
    RemoveObject 25
    RemoveObject 26
    ClearFlag FLAG_HGSS_SG_3F62
    RemoveObject 7
    RemoveObject 8
    RemoveObject 9
    RemoveObject 10
    RemoveObject 11
    RemoveObject 12
    FadeOutBGM 0, 10
    StopMusic
    PlayDefaultMusic
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    FacePlayer
    LockAll
    Message msg_0512_T08_00038
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_SG_3F63
    AddObject obj_T08_gsboy2
    AddObject obj_T08_juggrer
    RemoveObject 27
    RemoveObject 28
    RemoveObject 29
    RemoveObject 30
    RemoveObject 19
    RemoveObject 17
    RemoveObject 18
    RemoveObject 24
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_DOOR_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_07CA:
    PlayCry SPECIES_CLOYSTER, 0
    ReleaseObject 20
    @ HGSS: ScrCmd_523 20, 4, 90, 4, 0
    LockObject 20
    FadeOutBGM 5, 0
    PlayMusic SEQ_GS_EYE_K_SHOUNEN_sseq
    Message msg_0512_T08_00031
    CloseMessage
    PlayCry SPECIES_CLOYSTER, 0
    WaitCry
    CompleteStartWildBattle SPECIES_CLOYSTER, 55, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_SHELLDER, 6
    WaitCry
    RemoveObject 20
    RemoveObject 21
    RemoveObject 22
    RemoveObject 23
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0512_T08_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
_083D:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
_0843:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 62
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
_087D:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0DD9
    ApplyMovement obj_T08_juggrer, _0F60
    WaitMovement
    GoTo _089A
_089A:
    Return
_089C:
    CheckItem ITEM_BLUE_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0901
    SetVarFromValue VAR_0x8001, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0945
    SetVarFromValue VAR_0x8002, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0968
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
    Return
_0901:
    CheckItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0945
    SetVarFromValue VAR_0x8002, 1
    SetVarFromValue VAR_0x8006, 1
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0968
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
    Return
_0945:
    CheckItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0968
    SetVarFromValue VAR_0x8003, 1
    SetVarFromValue VAR_0x8006, 1
    Return
_0968:
    Return
_096A:
    CompareVar VAR_0x8001, 1
    GoToIf 5, _09F5
    AddMenuEntry 206, 1
    CompareVar VAR_0x8002, 1
    GoToIf 5, _0A6B
    AddMenuEntry 207, 2
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0ACC
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B18
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0BBC
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0C60
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0D04
    GoTo _0DA8
_09F5:
    CompareVar VAR_0x8002, 1
    GoToIf 5, _0A6B
    AddMenuEntry 207, 2
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0ACC
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B18
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0BBC
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0C60
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0D04
    GoTo _0DA8
_0A6B:
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0ACC
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B18
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0BBC
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0C60
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0D04
    GoTo _0DA8
_0ACC:
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B18
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0BBC
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0C60
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0D04
    GoTo _0DA8
_0B18:
    Message msg_0512_T08_00011
    SetVar VAR_0x8004, ITEM_PERSIM_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_RAZZ_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_POMEG_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_PERSIM_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_RAZZ_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_POMEG_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_RED_SHARD, 1, VAR_RESULT
    GoTo _0DF4
_0BBC:
    Message msg_0512_T08_00012
    SetVar VAR_0x8004, ITEM_BLUK_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_KELPSY_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_CORNN_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_BLUK_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_KELPSY_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_CORNN_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_BLUE_SHARD, 1, VAR_RESULT
    GoTo _0DF4
_0C60:
    Message msg_0512_T08_00013
    SetVar VAR_0x8004, ITEM_PINAP_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_GREPA_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_NOMEL_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_PINAP_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_GREPA_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_NOMEL_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_YELLOW_SHARD, 1, VAR_RESULT
    GoTo _0DF4
_0D04:
    Message msg_0512_T08_00014
    SetVar VAR_0x8004, ITEM_WEPEAR_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_HONDEW_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_DURIN_BERRY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0DE5
    SetVar VAR_0x8004, ITEM_WEPEAR_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_HONDEW_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_DURIN_BERRY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    RemoveItem ITEM_GREEN_SHARD, 1, VAR_RESULT
    GoTo _0DF4
_0DA8:
    Message msg_0512_T08_00010
    CloseMessage
    Call _04BC
    ReleaseAll
    End
_0DB7:
    Message msg_0512_T08_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DC2:
    FacePlayer
    Message msg_0512_T08_00026
    WaitButton
    CloseMessage
    ApplyMovement 29, _0EEE
    WaitMovement
    ReleaseAll
    End
_0DD9:
    ApplyMovement obj_T08_juggrer, _0FA2
    WaitMovement
    Return
_0DE5:
    Message msg_0512_T08_00015
    CloseMessage
    Call _04BC
    ReleaseAll
    End
_0DF4:
    SetVarFromValue VAR_0x8000, 0
    SetVarFromValue VAR_0x8001, 0
    SetVarFromValue VAR_0x8002, 0
    SetVarFromValue VAR_0x8003, 0
    SetVarFromValue VAR_0x8006, 0
    Call _04DD
    CompareVar VAR_0x8006, 1
    GoToIf 5, _0E2E
    Message msg_0512_T08_00009
    GoTo _0E34
_0E2E:
    GoTo _0DA8
_0E34:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    CompareVar VAR_0x8000, 1
    GoToIf 5, _096A
    AddMenuEntry 205, 0
    CompareVar VAR_0x8001, 1
    GoToIf 5, _09F5
    AddMenuEntry 206, 1
    CompareVar VAR_0x8002, 1
    GoToIf 5, _0A6B
    AddMenuEntry 207, 2
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0ACC
    AddMenuEntry 208, 3
    AddMenuEntry 126, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B18
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0BBC
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0C60
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0D04
    GoTo _0DA8
    .balign 4, 0
_0EDE:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0EE8:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0EEE:
    FaceNorth
    EndMovement
    .balign 4, 0
_0EF4:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0F06:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0F10:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0F1E:
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    EndMovement
    .balign 4, 0
_0F60:
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    EndMovement
    .balign 4, 0
_0FA2:
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    EndMovement
    .balign 4, 0
