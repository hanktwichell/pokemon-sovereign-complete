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
    ScriptEntryEnd
scr_seq_T24_005:
    ClearFlag FLAG_HGSS_SYS_CIANWOOD_WATERFALL_DISABLE
    SetVarFromValue VAR_HGSS_UNK_40EB, 0
    End
scr_seq_T24_006:
    LockAll
    ApplyMovement obj_T24_middlewoman1_2, _00C4
    ApplyMovement LOCALID_PLAYER, _00E4
    WaitMovement
    Message msg_0572_T24_00002
    SetVar VAR_0x8004, ITEM_HM02
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _00B8
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HM02
    SetVarFromValue VAR_HGSS_UNK_4116, 2
    Message msg_0572_T24_00004
    WaitButton
    CloseMessage
    ApplyMovement obj_T24_middlewoman1_2, _00D8
    WaitMovement
    CompareVar VAR_HGSS_MIDGAME_BADGES, 4
    GoToIf 1, _00F0
    ReleaseAll
    End
_00B8:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_00C4:
    WalkOnSpotFastNorth
    EmoteExclamationMark
    WalkNormalNorth 2
    FaceWest
    EndMovement
    .balign 4, 0
_00D8:
    WalkNormalSouth 2
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_00E4:
    Delay16 3
    FaceEast
    EndMovement
_00F0:
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    SetFlag FLAG_HGSS_UNK_0C5
    SetFlag FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE
    CompareVar VAR_HGSS_UNK_40F8, 0
    GoToIf 5, _0111
    SetVarFromValue VAR_HGSS_UNK_40F8, 2
_0111:
    @ HGSS: PhoneCall PHONE_CONTACT_PROF__ELM, 2, 2
    SetVarFromValue VAR_HGSS_MIDGAME_BADGES, 5
    ReleaseAll
    End
    .balign 4, 0
_0134:
    EmoteExclamationMark
    EndMovement
scr_seq_T24_001:
    End
scr_seq_T24_002:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0310
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_T24_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_T24_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_T24_tsure_poke_static_suicune
    WaitCry
    ApplyMovement obj_T24_tsure_poke_static_suicune, _02F4
    WaitMovement
    ApplyMovement obj_T24_tsure_poke_static_suicune, _0338
    ApplyMovement LOCALID_PLAYER, _0320
    WaitMovement
    WaitTime 30, VAR_RESULT
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T24_tsure_poke_static_suicune, _0300
    ApplyMovement LOCALID_PLAYER, _0344
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    RemoveObject obj_T24_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_CIANWOOD_SUICUNE
    AddVar VAR_HGSS_UNK_4076, 1
    ClearFlag FLAG_HGSS_HIDE_CIANWOOD_EUSINE
    AddObject obj_T24_minaki
    ApplyMovement obj_T24_minaki, _0358
    ApplyMovement LOCALID_PLAYER, _036C
    WaitMovement
    BufferPlayerName 0
    Message msg_0572_T24_00015
    WaitABPress
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_MYSTERY_MAN_EUSINE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0227
    BufferPlayerName 0
    Message msg_0572_T24_00016
    CloseMessage
    ApplyMovement obj_T24_minaki, _037C
    WaitMovement
    RemoveObject obj_T24_minaki
    SetFlag FLAG_HGSS_HIDE_CIANWOOD_EUSINE
    ClearFlag FLAG_HGSS_HIDE_ROUTE_42_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4092, 1
    ReleaseAll
    End
_0227:
    RemoveObject obj_T24_minaki
    SetFlag FLAG_HGSS_HIDE_CIANWOOD_EUSINE
    ClearFlag FLAG_HGSS_HIDE_ROUTE_42_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_4092, 1
    BlackOutFromBattle
    ReleaseAll
scr_seq_T24_003:
    End
scr_seq_T24_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0276
    GoToIfSet FLAG_HGSS_GOT_HM02, _026B
    Message msg_0572_T24_00000
    Message msg_0572_T24_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_026B:
    Message msg_0572_T24_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0276:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_CHUCK, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _02CD
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _02E9
    Message msg_0572_T24_00007
_0299:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02BD
    CompareVar VAR_RESULT, 1
    GoToIf 4, _02D8
    End
_02BD:
    BufferPlayerName 0
    Message msg_0572_T24_00008
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_CHUCK
_02CD:
    Message msg_0572_T24_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02D8:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0572_T24_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02E9:
    Message msg_0572_T24_00011
    GoTo _0299
    End
    .balign 4, 0
_02F4:
    MoveAction_111 1
    EndMovement
    End
    .balign 4, 0
_0300:
    MoveAction_112 1
    SetInvisible
    EndMovement
    End
    .balign 4, 0
_0310:
    FaceNorth
    EmoteExclamationMark
    EndMovement
    End
    .balign 4, 0
_0320:
    FaceNorth
    EndMovement
    End
    .balign 4, 0
_032C:
    FaceEast
    EndMovement
    End
    .balign 4, 0
_0338:
    FaceSouth
    EndMovement
    End
    .balign 4, 0
_0344:
    FaceEast
    Delay8
    WalkNormalEast 2
    EndMovement
    End
    .balign 4, 0
_0358:
    WalkNormalNorth 5
    WalkNormalEast 2
    WalkNormalNorth 2
    EndMovement
    End
    .balign 4, 0
_036C:
    Delay8 6
    FaceSouth
    EndMovement
    End
    .balign 4, 0
_037C:
    WalkNormalSouth 2
    WalkNormalWest 2
    WalkNormalSouth 5
    EndMovement
    End
scr_seq_T24_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 6
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _047B
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0481
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 7
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03FF
    ApplyMovement LOCALID_PLAYER, _0498
    GoTo _0422
_03FF:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _041A
    ApplyMovement LOCALID_PLAYER, _04B0
    GoTo _0422
_041A:
    ApplyMovement LOCALID_PLAYER, _04BC
_0422:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0449
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _04D0
    WaitMovement
_0449:
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
_047B:
    CloseMessage
    ReleaseAll
    End
_0481:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 9
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0498:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04B0:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04BC:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04D0:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
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
    NPCMessage msg_0572_T24_00013
    End
scr_seq_T24_014:
    NPCMessage msg_0572_T24_00014
    End
scr_seq_T24_015:
    NPCMessage msg_0572_T24_00017
    End
    .balign 4, 0
