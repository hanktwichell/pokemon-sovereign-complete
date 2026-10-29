#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0612.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T27_gsrivel 6
#define obj_T27_gsmiddleman1 8

    ScriptEntry scr_seq_T27_000
    ScriptEntry scr_seq_T27_001
    ScriptEntry scr_seq_T27_002
    ScriptEntry scr_seq_T27_003
    ScriptEntry scr_seq_T27_004
    ScriptEntry scr_seq_T27_005
    ScriptEntry scr_seq_T27_006
    ScriptEntry scr_seq_T27_007
    ScriptEntry scr_seq_T27_008
    ScriptEntry scr_seq_T27_009
    ScriptEntry scr_seq_T27_010
    ScriptEntry scr_seq_T27_011
    ScriptEntry scr_seq_T27_012
    ScriptEntry scr_seq_T27_013
    ScriptEntry scr_seq_T27_014
    ScriptEntry scr_seq_T27_015
    ScriptEntry scr_seq_T27_016
    ScriptEntry scr_seq_T27_017
    ScriptEntry scr_seq_T27_018
    ScriptEntryEnd
scr_seq_T27_000:
    End
scr_seq_T27_015:
    GoToIfUnset FLAG_HGSS_UNK_189, _0370
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T27_012:
    LockAll
    @ HGSS: ScrCmd_307 11, 5, 25, 23, 1
    @ HGSS: ScrCmd_310 1
    @ HGSS: ScrCmd_308 1
    ApplyMovement LOCALID_PLAYER, _0586
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _038B
    @ HGSS: ScrCmd_606
    GoTo _03A4
scr_seq_T27_005:
    LockAll
    ClearFlag FLAG_HGSS_HIDE_ECRUTEAK_RIVAL
    AddObject obj_T27_gsrivel
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T27_gsrivel, _0590
    ApplyMovement LOCALID_PLAYER, _05A2
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    Message msg_0612_T27_00016
    WaitTime 30, VAR_RESULT
    BufferRivalName 1
    Message msg_0612_T27_00017
    CloseMessage
    ApplyMovement obj_T27_gsrivel, _05B4
    WaitMovement
    BufferPlayerName 0
    BufferRivalName 1
    Message msg_0612_T27_00018
    CloseMessage
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T27_gsrivel, _05C2
    ApplyMovement LOCALID_PLAYER, _05A2
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T27_gsrivel, _05CC
    ApplyMovement LOCALID_PLAYER, _05DA
    WaitMovement
    RemoveObject obj_T27_gsrivel
    SetFlag FLAG_HGSS_HIDE_ECRUTEAK_RIVAL
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4079, 4
    SetVarFromValue VAR_HGSS_UNK_410C, 4
    ClearFlag FLAG_HGSS_HIDE_DANCE_STUDIO_KIMONO_GIRLS
    SetFlag FLAG_HGSS_UNK_241
    End
scr_seq_T27_013:
    NPCMessage msg_0612_T27_00019
    End
scr_seq_T27_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03BB
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03CF
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03E3
    ApplyMovement LOCALID_PLAYER, _05E4
    ApplyMovement obj_T27_gsmiddleman1, _05FA
    GoTo _03FE
scr_seq_T27_001:
    DrawSignpostInstantMessage msg_0612_T27_00011, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_002:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0612_T27_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0612_T27_00013, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0612_T27_00014, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_016:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0612_T27_00015, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T27_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_96A, _045F
    Message msg_0612_T27_00008
    GoTo _046A
scr_seq_T27_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0472
    Message msg_0612_T27_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T27_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_410C, 2
    GoToIf 2, _047D
    Message msg_0612_T27_00002
    GoTo _0488
scr_seq_T27_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0490
    CompareVar VAR_HGSS_UNK_40A1, 0
    GoToIf 5, _049B
    Message msg_0612_T27_00005
    GoTo _04A6
scr_seq_T27_007:
    NPCMessage msg_0612_T27_00010
    End
scr_seq_T27_011:
    NPCMessage msg_0612_T27_00004
    End
scr_seq_T27_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    GoToIfUnset FLAG_HGSS_SG_3FB2, _04AE
    Message msg_0612_T27_00020
    DrawPokemonPreview SPECIES_JIRACHI, 0
    Message msg_0612_T27_00021
    RemovePokemonPreview
    Message msg_0612_T27_00022
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FB2
    Common_FadeToDefaultMusic
    ReleaseAll
    End
scr_seq_T27_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    ApplyMovement 10, _0604
    WaitMovement
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F79, _04C8
    Message msg_0612_T27_00025
    SetVar VAR_0x8004, ITEM_TM92
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0612_T27_00026
    SetFlag FLAG_HGSS_SG_3F79
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0370:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _04D3
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _04D9
_038B:
    @ HGSS: ScrCmd_607
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    SetVarFromValue VAR_HGSS_UNK_4079, 0
    @ HGSS: ScrCmd_311 1
    @ HGSS: ScrCmd_308 1
    @ HGSS: ScrCmd_309 1
    ReleaseAll
    End
_03A4:
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    SetVarFromValue VAR_HGSS_UNK_4079, 0
    @ HGSS: ScrCmd_311 1
    @ HGSS: ScrCmd_308 1
    @ HGSS: ScrCmd_309 1
    ReleaseAll
    End
_03BB:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03CF:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E3:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04DB
    ApplyMovement LOCALID_PLAYER, _068A
    GoTo _03FE
_03FE:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _054C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0694
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 19
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
_045F:
    Message msg_0612_T27_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_046A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0472:
    Message msg_0612_T27_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_047D:
    Message msg_0612_T27_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0488:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0490:
    Message msg_0612_T27_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_049B:
    Message msg_0612_T27_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04A6:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04AE:
    Message msg_0612_T27_00023
    DrawPokemonPreview SPECIES_JIRACHI, 0
    Message msg_0612_T27_00024
    WaitButton
    RemovePokemonPreview
    CloseMessage
    Common_FadeToDefaultMusic
    ReleaseAll
    End
_04C8:
    Message msg_0612_T27_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04D3:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_04D9:
    End
_04DB:
    ApplyMovement LOCALID_PLAYER, _06A2
    ApplyMovement obj_T27_gsmiddleman1, _05FA
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _054C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0694
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 19
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
_054C:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 19
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
    .balign 4, 0
_0586:
    WalkFastSouth 2
    Delay8
    EndMovement
    .balign 4, 0
_0590:
    LockDir
    WalkFastSouth
    WalkOnSpotFastNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_05A2:
    FaceNorth
    LockDir
    WalkFastSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_05B4:
    EmoteExclamationMark
    Delay8
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05C2:
    WalkFastSouth
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_05CC:
    WalkSlowWest 3
    Delay8 3
    WalkFastWest 6
    EndMovement
    .balign 4, 0
_05DA:
    Delay8 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_05E4:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05FA:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0604:
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_068A:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0694:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_06A2:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
