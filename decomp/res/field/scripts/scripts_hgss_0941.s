#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "generated/ribbons.h"
#include "res/text/bank/hgss_msg_0629.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T30_gsmiddleman1 9

    ScriptEntry scr_seq_T30_000
    ScriptEntry scr_seq_T30_001
    ScriptEntry scr_seq_T30_002
    ScriptEntry scr_seq_T30_003
    ScriptEntry scr_seq_T30_004
    ScriptEntry scr_seq_T30_005
    ScriptEntry scr_seq_T30_006
    ScriptEntry scr_seq_T30_007
    ScriptEntry scr_seq_T30_008
    ScriptEntry scr_seq_T30_009
    ScriptEntry scr_seq_T30_010
    ScriptEntry scr_seq_T30_011
    ScriptEntry scr_seq_T30_012
    ScriptEntry scr_seq_T30_013
    ScriptEntry scr_seq_T30_014
    ScriptEntry scr_seq_T30_015
    ScriptEntry scr_seq_T30_016
    ScriptEntryEnd
scr_seq_T30_005:
    CompareVar VAR_HGSS_UNK_40C4, 1
    GoToIf 5, _005D
    SetFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    SetVarFromValue VAR_HGSS_UNK_40C4, 2
_005D:
    GoToIfUnset FLAG_HGSS_UNK_189, _006E
    ClearFlag FLAG_HGSS_UNK_189
    End
_006E:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0089
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _00A4
_0089:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00A0
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _00A4
_00A0:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_00A4:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _00BF
    ClearFlag FLAG_HGSS_UNK_204
    GoTo _00C3
_00BF:
    SetFlag FLAG_HGSS_UNK_204
_00C3:
    End
scr_seq_T30_007:
    SetVar VAR_0x8004, PHONE_CONTACT_PROF__ELM
    SetVar VAR_0x8005, 2
    SetVar VAR_0x8006, 3
    CallCommonScript 0x813
    SetVarFromValue VAR_HGSS_UNK_407B, 2
    End
scr_seq_T30_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    GetPartyMonRibbon VAR_RESULT, VAR_0x8002, RIBBON_SNOOZE
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0209
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _021D
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _01B7
    GoToIfSet FLAG_HGSS_GOT_SOFT_SAND_FROM_SANTOS, _0199
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _014A
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 23
    GoTo _0191
_014A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 20
    SetVar VAR_0x8004, ITEM_SOFT_SAND
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01AD
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_SOFT_SAND_FROM_SANTOS
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 21
_0191:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0199:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 22
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AD:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_01B7:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _01DA
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 23
    GoTo _0191
_01DA:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 48
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 50
    SetPartyMonRibbon VAR_0x8002, RIBBON_SNOOZE
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0209:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 49
    WaitButton
    CloseMessage
    ReleaseAll
    End
_021D:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 51
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30_000:
    NPCMessage msg_0629_T30_00000
    End
scr_seq_T30_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0D1, _0262
    Message msg_0629_T30_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0262:
    Message msg_0629_T30_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30_002:
    NPCMessage msg_0629_T30_00003
    End
scr_seq_T30_003:
    NPCMessage msg_0629_T30_00004
    End
scr_seq_T30_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 5, _02B1
    Message msg_0629_T30_00005
    GoTo _02B4
_02B1:
    Message msg_0629_T30_00006
_02B4:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03C1
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03D5
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0335
    ApplyMovement LOCALID_PLAYER, _03EC
    ApplyMovement obj_T30_gsmiddleman1, _0424
    GoTo _0360
_0335:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0350
    ApplyMovement LOCALID_PLAYER, _0404
    GoTo _0360
_0350:
    ApplyMovement LOCALID_PLAYER, _0410
    ApplyMovement obj_T30_gsmiddleman1, _0424
_0360:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0387
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0430
    WaitMovement
_0387:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 44
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
_03C1:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03D5:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_03EC:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0404:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0410:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0424:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0430:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T30_008:
    DrawSignpostInstantMessage msg_0629_T30_00010, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T30_009:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0629_T30_00011, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T30_010:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0629_T30_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T30_011:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0629_T30_00013, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T30_012:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0629_T30_00014, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T30_013:
    NPCMessage msg_0629_T30_00007
    End
scr_seq_T30_014:
    NPCMessage msg_0629_T30_00008
    End
scr_seq_T30_015:
    NPCMessage msg_0629_T30_00009
    End
    .balign 4, 0
