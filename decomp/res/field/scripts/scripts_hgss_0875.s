#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0572.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T24_middlewoman1_2 0
#define obj_T24_tsure_poke_static_suicune 5
#define obj_T24_minaki 6

    ScriptEntry scr_seq_T24_000
    ScriptEntry scr_seq_T24_001
    ScriptEntry scr_seq_T24_002
    ScriptEntry scr_seq_T24_003
    ScriptEntry scr_seq_T24_004
    ScriptEntry scr_seq_T24_005
    ScriptEntry scr_seq_T24_006
    ScriptEntry scr_seq_T24_007
    ScriptEntry scr_seq_T24_008
    ScriptEntry scr_seq_T24_009
    ScriptEntry scr_seq_T24_010
    ScriptEntry scr_seq_T24_011
    ScriptEntry scr_seq_T24_012
    ScriptEntry scr_seq_T24_013
    ScriptEntry scr_seq_T24_014
    ScriptEntry scr_seq_T24_015
    ScriptEntry scr_seq_T24_016
    ScriptEntryEnd
scr_seq_T24_005:
    ClearFlag FLAG_HGSS_SYS_CIANWOOD_WATERFALL_DISABLE
    SetVarFromValue VAR_HGSS_UNK_40EB, 0
    End
scr_seq_T24_006:
    LockAll
    ApplyMovement obj_T24_middlewoman1_2, _0626
    ApplyMovement LOCALID_PLAYER, _0638
    WaitMovement
    Message msg_0572_T24_00002
    SetVar VAR_0x8004, ITEM_HM02
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _03AB
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HM02
    SetVarFromValue VAR_HGSS_UNK_4116, 2
    Message msg_0572_T24_00004
    WaitButton
    CloseMessage
    ApplyMovement obj_T24_middlewoman1_2, _0642
    WaitMovement
    CompareVar VAR_HGSS_MIDGAME_BADGES, 4
    GoToIf 1, _03B5
    ReleaseAll
    End
scr_seq_T24_001:
    End
scr_seq_T24_002:
    LockAll
    ApplyMovement LOCALID_PLAYER, _064C
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_T24_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_T24_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_T24_tsure_poke_static_suicune
    WaitCry
    ApplyMovement obj_T24_tsure_poke_static_suicune, _0656
    WaitMovement
    ApplyMovement obj_T24_tsure_poke_static_suicune, _065C
    ApplyMovement LOCALID_PLAYER, _0662
    WaitMovement
    WaitTime 30, VAR_RESULT
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T24_tsure_poke_static_suicune, _0668
    ApplyMovement LOCALID_PLAYER, _0672
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    RemoveObject obj_T24_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_CIANWOOD_SUICUNE
    AddVar VAR_HGSS_UNK_4076, 1
    ClearFlag FLAG_HGSS_HIDE_CIANWOOD_EUSINE
    AddObject obj_T24_minaki
    ApplyMovement obj_T24_minaki, _0680
    ApplyMovement LOCALID_PLAYER, _068E
    WaitMovement
    BufferPlayerName 0
    Message msg_0572_T24_00015
    WaitABPress
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_MYSTERY_MAN_EUSINE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03F6
    BufferPlayerName 0
    Message msg_0572_T24_00016
    CloseMessage
    ApplyMovement obj_T24_minaki, _0698
    WaitMovement
    RemoveObject obj_T24_minaki
    SetFlag FLAG_HGSS_HIDE_CIANWOOD_EUSINE
    ClearFlag FLAG_HGSS_HIDE_ROUTE_42_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4092, 1
    ReleaseAll
    End
scr_seq_T24_003:
    End
scr_seq_T24_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _040E
    GoToIfSet FLAG_HGSS_GOT_HM02, _0455
    Message msg_0572_T24_00000
    Message msg_0572_T24_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T24_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 6
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0460
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0466
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 7
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _047A
    ApplyMovement LOCALID_PLAYER, _06A6
    GoTo _0495
scr_seq_T24_008:
    DrawSignpostInstantMessage msg_0572_T24_00018, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T24_009:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0572_T24_00019, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T24_010:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0572_T24_00020, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T24_011:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0572_T24_00021, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T24_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0572_T24_00022, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T24_012:
    NPCMessage msg_0572_T24_00012
    End
scr_seq_T24_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0572_T24_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T24_014:
    NPCMessage msg_0572_T24_00014
    End
scr_seq_T24_015:
    NPCMessage msg_0572_T24_00017
    End
scr_seq_T24_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0572_T24_00023
    GetPartyMonFriendship VAR_RESULT, 0
    CompareVar VAR_RESULT, 255
    GoToIf 0, _04EE
    Message msg_0572_T24_00025
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04F9
    Message msg_0572_T24_00027
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _0504
    BufferPlayerName 0
    Message msg_0572_T24_00029
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    GivePokemon SPECIES_PIKACHU, 26, 0, VAR_RESULT
    ResetPartyMonMoveSlot_Unused VAR_0x8005, 0, MOVE_SURF
    ResetPartyMonMoveSlot_Unused VAR_0x8005, 1, MOVE_FLY
    ResetPartyMonMoveSlot_Unused VAR_0x8005, 2, MOVE_WISH
    Message msg_0572_T24_00030
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 12
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_DOOR_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_03AB:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_03B5:
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    SetFlag FLAG_HGSS_UNK_0C5
    SetFlag FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE
    CompareVar VAR_HGSS_UNK_40F8, 0
    GoToIf 5, _050F
    SetVarFromValue VAR_HGSS_UNK_40F8, 2
    SetVar VAR_0x8004, PHONE_CONTACT_PROF__ELM
    SetVar VAR_0x8005, 2
    SetVar VAR_0x8006, 2
    CallCommonScript 0x813
    SetVarFromValue VAR_HGSS_MIDGAME_BADGES, 5
    ReleaseAll
    End
_03F6:
    RemoveObject obj_T24_minaki
    SetFlag FLAG_HGSS_HIDE_CIANWOOD_EUSINE
    ClearFlag FLAG_HGSS_HIDE_ROUTE_42_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4092, 1
    BlackOutFromBattle
    ReleaseAll
    End
_040E:
    CompletePhoneCheckRegistered PHONE_CONTACT_CHUCK, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _052F
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _053A
    Message msg_0572_T24_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0543
    CompareVar VAR_RESULT, 1
    GoToIf 4, _055E
    End
_0455:
    Message msg_0572_T24_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0460:
    CloseMessage
    ReleaseAll
    End
_0466:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 9
    WaitButton
    CloseMessage
    ReleaseAll
    End
_047A:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _056F
    ApplyMovement LOCALID_PLAYER, _06BC
    GoTo _0495
_0495:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05D0
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06C6
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 35
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 8
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04EE:
    Message msg_0572_T24_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04F9:
    Message msg_0572_T24_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0504:
    Message msg_0572_T24_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
_050F:
    SetVar VAR_0x8004, PHONE_CONTACT_PROF__ELM
    SetVar VAR_0x8005, 2
    SetVar VAR_0x8006, 2
    CallCommonScript 0x813
    SetVarFromValue VAR_HGSS_MIDGAME_BADGES, 5
    ReleaseAll
    End
_052F:
    Message msg_0572_T24_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_053A:
    Message msg_0572_T24_00011
    GoTo _0602
_0543:
    BufferPlayerName 0
    Message msg_0572_T24_00008
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_CHUCK
    Message msg_0572_T24_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_055E:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0572_T24_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_056F:
    ApplyMovement LOCALID_PLAYER, _06D4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05D0
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06C6
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 35
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 8
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05D0:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 35
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 8
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0602:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0543
    CompareVar VAR_RESULT, 1
    GoToIf 4, _055E
    End
    .balign 4, 0
_0626:
    WalkOnSpotFastNorth
    EmoteExclamationMark
    WalkNormalNorth 2
    FaceWest
    EndMovement
    .balign 4, 0
_0638:
    Delay16 3
    FaceEast
    EndMovement
    .balign 4, 0
_0642:
    WalkNormalSouth 2
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_064C:
    FaceNorth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0656:
    MoveAction_111
    EndMovement
    .balign 4, 0
_065C:
    FaceSouth
    EndMovement
    .balign 4, 0
_0662:
    FaceNorth
    EndMovement
    .balign 4, 0
_0668:
    MoveAction_112
    SetInvisible
    EndMovement
    .balign 4, 0
_0672:
    FaceEast
    Delay8
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0680:
    WalkNormalNorth 5
    WalkNormalEast 2
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_068E:
    Delay8 6
    FaceSouth
    EndMovement
    .balign 4, 0
_0698:
    WalkNormalSouth 2
    WalkNormalWest 2
    WalkNormalSouth 5
    EndMovement
    .balign 4, 0
_06A6:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06BC:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06C6:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_06D4:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
