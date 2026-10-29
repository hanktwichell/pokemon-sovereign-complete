#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0483.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T06_gsmiddleman1_2 14
#define obj_T06_tsure_poke_static_suicune 15
#define obj_T06_minaki 16
#define obj_T06_minaki_2 17
#define obj_T06_daigo 18

    ScriptEntry scr_seq_T06_000
    ScriptEntry scr_seq_T06_001
    ScriptEntry scr_seq_T06_002
    ScriptEntry scr_seq_T06_003
    ScriptEntry scr_seq_T06_004
    ScriptEntry scr_seq_T06_005
    ScriptEntry scr_seq_T06_006
    ScriptEntry scr_seq_T06_007
    ScriptEntry scr_seq_T06_008
    ScriptEntry scr_seq_T06_009
    ScriptEntry scr_seq_T06_010
    ScriptEntry scr_seq_T06_011
    ScriptEntry scr_seq_T06_012
    ScriptEntry scr_seq_T06_013
    ScriptEntryEnd
scr_seq_T06_009:
    GoToIfUnset FLAG_HGSS_UNK_189, _004B
    ClearFlag FLAG_HGSS_UNK_189
    End
_004B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0066
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0081
_0066:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _007D
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0081
_007D:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_0081:
    SetVarFromValue VAR_HGSS_UNK_4085, 0
    End
scr_seq_T06_013:
    LockAll
    ApplyMovement obj_T06_daigo, _016C
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0190
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0483_T06_00016
    CloseMessage
    ApplyMovement obj_T06_daigo, _0180
    WaitMovement
    GetGameVersion VAR_MAP_LOCAL_0x04
    CompareVar VAR_MAP_LOCAL_0x04, 8
    GoToIf 1, _0109
    @ HGSS: ScrCmd_452 SPECIES_LATIAS, 1
    Message msg_0483_T06_00017
    CloseMessage
    @ HGSS: CreateRoamer 2
    @ HGSS: ScrCmd_453
    ApplyMovement obj_T06_daigo, _0180
    WaitMovement
    Message msg_0483_T06_00019
    CloseMessage
    ApplyMovement obj_T06_daigo, _0180
    WaitMovement
    Message msg_0483_T06_00021
    CloseMessage
    GoTo _013F
    End
_0109:
    @ HGSS: ScrCmd_452 SPECIES_LATIOS, 0
    Message msg_0483_T06_00018
    CloseMessage
    @ HGSS: CreateRoamer 3
    @ HGSS: ScrCmd_453
    ApplyMovement obj_T06_daigo, _0180
    WaitMovement
    Message msg_0483_T06_00020
    CloseMessage
    ApplyMovement obj_T06_daigo, _0180
    WaitMovement
    Message msg_0483_T06_00022
    CloseMessage
    GoTo _013F
    End
_013F:
    ApplyMovement obj_T06_daigo, _0180
    WaitMovement
    Message msg_0483_T06_00023
    CloseMessage
    ApplyMovement obj_T06_daigo, _0188
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4130, 2
    RemoveObject obj_T06_daigo
    SetFlag FLAG_HGSS_HIDE_VERMILION_CITY_STEVEN
    ReleaseAll
    End
    .balign 4, 0
_016C:
    EmoteExclamationMark
    Delay8
    WalkNormalWest 4
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0180:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0188:
    WalkNormalEast 10
    EndMovement
    .balign 4, 0
_0190:
    Delay16 4
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
scr_seq_T06_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_491 247
    GoToIfSet FLAG_HGSS_GOT_PP_MAX_FROM_VERMILLION_CITY_MAN, _01FF
    CompareVar VAR_HGSS_UNK_4135, 8
    GoToIf 4, _020A
    CompareVar VAR_HGSS_UNK_4135, 5
    GoToIf 4, _01F4
    CompareVar VAR_HGSS_UNK_4135, 1
    GoToIf 4, _01E9
    Message msg_0483_T06_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01E9:
    Message msg_0483_T06_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01F4:
    Message msg_0483_T06_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01FF:
    Message msg_0483_T06_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_020A:
    Message msg_0483_T06_00007
    SetVar VAR_0x8004, ITEM_PP_MAX
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0241
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_PP_MAX_FROM_VERMILLION_CITY_MAN
    Message msg_0483_T06_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0241:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_T06_011:
    LockAll
    ClearFlag FLAG_HGSS_HIDE_VERMILION_EUSINE
    AddObject obj_T06_minaki
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 1334
    GoToIf 5, _0270
    GoTo _037F
_0270:
    ApplyMovement LOCALID_PLAYER, _040C
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_T06_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_T06_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_T06_tsure_poke_static_suicune
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 331
    GoToIf 5, _02D5
    ApplyMovement LOCALID_PLAYER, _0460
    ApplyMovement obj_T06_minaki, _0490
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0414
    GoTo _0318
_02D5:
    CompareVar VAR_MAP_LOCAL_0x01, 332
    GoToIf 5, _0300
    ApplyMovement LOCALID_PLAYER, _0470
    ApplyMovement obj_T06_minaki, _04A0
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0420
    GoTo _0318
_0300:
    ApplyMovement LOCALID_PLAYER, _0480
    ApplyMovement obj_T06_minaki, _04B0
    ApplyMovement obj_T06_tsure_poke_static_suicune, _042C
_0318:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0483_T06_00014
    CloseMessage
    ApplyMovement obj_T06_minaki, _04D0
    WaitMovement
    BufferPlayerName 0
    Message msg_0483_T06_00015
    CloseMessage
    ApplyMovement obj_T06_minaki, _04E8
    ApplyMovement LOCALID_PLAYER, _04F0
    WaitMovement
_034D:
    Common_FadeToDefaultMusic
    RemoveObject obj_T06_minaki
    RemoveObject obj_T06_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE_2
    SetFlag FLAG_HGSS_HIDE_VERMILION_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4070, 0
    SetVarFromValue VAR_HGSS_UNK_4071, 0
    ClearFlag FLAG_HGSS_HIDE_ROUTE_14_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4086, 1
    ReleaseAll
    End
_037F:
    ApplyMovement LOCALID_PLAYER, _040C
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0458
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_T06_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_T06_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_T06_tsure_poke_static_suicune
    WaitCry
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0438
    ApplyMovement obj_T06_minaki, _04C0
    ApplyMovement LOCALID_PLAYER, _04F8
    WaitMovement
    ApplyMovement obj_T06_minaki, _04E0
    ApplyMovement LOCALID_PLAYER, _0504
    WaitMovement
    Message msg_0483_T06_00014
    CloseMessage
    ApplyMovement obj_T06_minaki, _04D8
    WaitMovement
    Message msg_0483_T06_00015
    CloseMessage
    ApplyMovement obj_T06_minaki, _04E8
    ApplyMovement LOCALID_PLAYER, _04F0
    WaitMovement
    GoTo _034D
    .balign 4, 0
_040C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0414:
    Delay4 9
    MoveAction_112 1
    EndMovement
    .balign 4, 0
_0420:
    Delay4 11
    MoveAction_112 1
    EndMovement
    .balign 4, 0
_042C:
    Delay4 13
    MoveAction_112 1
    EndMovement
    .balign 4, 0
_0438:
    Delay4 4
    WalkFasterSouth 2
    JumpNearFastSouth
    JumpFarSouth
    WalkFasterSouth 2
    JumpNearFastSouth
    JumpFarSouth 2
    EndMovement
    .balign 4, 0
_0458:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0460:
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0470:
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0480:
    WalkNormalEast 2
    WalkNormalNorth 4
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0490:
    Delay8
    WalkFastSouth 6
    WalkFastEast
    EndMovement
    .balign 4, 0
_04A0:
    Delay4 3
    WalkFastSouth 6
    WalkFastEast
    EndMovement
    .balign 4, 0
_04B0:
    Delay4 5
    WalkFastSouth 6
    WalkFastEast
    EndMovement
    .balign 4, 0
_04C0:
    Delay4 2
    WalkFastEast
    WalkFastSouth 2
    EndMovement
    .balign 4, 0
_04D0:
    FaceSouth
    EndMovement
    .balign 4, 0
_04D8:
    FaceEast
    EndMovement
    .balign 4, 0
_04E0:
    JumpOnSpotFastSouth 3
    EndMovement
    .balign 4, 0
_04E8:
    WalkNormalNorth 8
    EndMovement
    .balign 4, 0
_04F0:
    FaceNorth
    EndMovement
    .balign 4, 0
_04F8:
    Delay4 4
    FaceSouth
    EndMovement
    .balign 4, 0
_0504:
    FaceWest
    EndMovement
scr_seq_T06_012:
    LockAll
    ClearFlag FLAG_HGSS_HIDE_VERMILION_EUSINE_2
    AddObject obj_T06_minaki_2
    ApplyMovement LOCALID_PLAYER, _040C
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_T06_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_T06_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_T06_tsure_poke_static_suicune
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 1324
    GoToIf 5, _057D
    ApplyMovement obj_T06_minaki_2, _0654
    ApplyMovement LOCALID_PLAYER, _0630
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0414
    GoTo _05C0
_057D:
    CompareVar VAR_MAP_LOCAL_0x00, 1325
    GoToIf 5, _05A8
    ApplyMovement obj_T06_minaki_2, _0668
    ApplyMovement LOCALID_PLAYER, _063C
    ApplyMovement obj_T06_tsure_poke_static_suicune, _0420
    GoTo _05C0
_05A8:
    ApplyMovement obj_T06_minaki_2, _067C
    ApplyMovement LOCALID_PLAYER, _0648
    ApplyMovement obj_T06_tsure_poke_static_suicune, _042C
_05C0:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0483_T06_00014
    CloseMessage
    ApplyMovement obj_T06_minaki_2, _0690
    ApplyMovement LOCALID_PLAYER, _06A4
    WaitMovement
    BufferPlayerName 0
    Message msg_0483_T06_00015
    CloseMessage
    ApplyMovement obj_T06_minaki_2, _0698
    ApplyMovement LOCALID_PLAYER, _06AC
    WaitMovement
    Common_FadeToDefaultMusic
    RemoveObject obj_T06_minaki_2
    RemoveObject obj_T06_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE
    SetFlag FLAG_HGSS_HIDE_VERMILION_EUSINE_2
    SetFlag FLAG_HGSS_HIDE_VERMILION_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4070, 0
    SetVarFromValue VAR_HGSS_UNK_4071, 0
    ClearFlag FLAG_HGSS_HIDE_ROUTE_14_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4086, 1
    ReleaseAll
    End
    .balign 4, 0
_0630:
    WalkNormalSouth 4
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_063C:
    WalkNormalSouth 4
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0648:
    WalkNormalSouth 4
    FaceEast
    EndMovement
    .balign 4, 0
_0654:
    Delay8
    WalkFastEast 7
    WalkFastNorth 3
    WalkFastEast
    EndMovement
    .balign 4, 0
_0668:
    Delay8 2
    WalkFastEast 7
    WalkFastNorth 3
    WalkFastEast
    EndMovement
    .balign 4, 0
_067C:
    Delay8 3
    WalkFastEast 7
    WalkFastNorth 3
    WalkFastEast
    EndMovement
    .balign 4, 0
_0690:
    FaceNorth
    EndMovement
    .balign 4, 0
_0698:
    WalkNormalWest 2
    WalkNormalNorth 13
    EndMovement
    .balign 4, 0
_06A4:
    FaceSouth
    EndMovement
    .balign 4, 0
_06AC:
    Delay8 2
    FaceWest
    Delay8
    FaceNorth
    EndMovement
scr_seq_T06_001:
    NPCMessage msg_0483_T06_00000
    End
scr_seq_T06_002:
    NPCMessage msg_0483_T06_00003
    End
scr_seq_T06_003:
    NPCMessage msg_0483_T06_00001
    End
scr_seq_T06_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MACHOP, 0
    Message msg_0483_T06_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T06_005:
    DrawSignpostInstantMessage msg_0483_T06_00010, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T06_006:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0483_T06_00011, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T06_007:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0483_T06_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T06_008:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0483_T06_00013, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T06_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _086F
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0883
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _07DB
    ApplyMovement LOCALID_PLAYER, _0898
    GoTo _080E
_07DB:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _07FE
    ApplyMovement LOCALID_PLAYER, _08B8
    ApplyMovement obj_T06_gsmiddleman1_2, _08CC
    GoTo _080E
_07FE:
    ApplyMovement LOCALID_PLAYER, _08A4
    ApplyMovement obj_T06_gsmiddleman1_2, _08CC
_080E:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0835
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _08D8
    WaitMovement
_0835:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 50
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
_086F:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0883:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0898:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_08A4:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_08B8:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_08CC:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_08D8:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
