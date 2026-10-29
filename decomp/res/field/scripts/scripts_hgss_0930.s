#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0620.h"

#define obj_T28_gsmiddleman1 0

    ScriptEntry scr_seq_T28_000
    ScriptEntry scr_seq_T28_001
    ScriptEntry scr_seq_T28_002
    ScriptEntry scr_seq_T28_003
    ScriptEntry scr_seq_T28_004
    ScriptEntry scr_seq_T28_005
    ScriptEntry scr_seq_T28_006
    ScriptEntry scr_seq_T28_007
    ScriptEntry scr_seq_T28_008
    ScriptEntryEnd
scr_seq_T28_005:
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    SetFlag FLAG_HGSS_UNK_0C5
    SetFlag FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE
    CompareVar VAR_HGSS_UNK_40F8, 0
    GoToIf 5, _0047
    SetVarFromValue VAR_HGSS_UNK_40F8, 2
_0047:
    @ HGSS: PhoneCall PHONE_CONTACT_PROF__ELM, 2, 2
    SetVarFromValue VAR_HGSS_MIDGAME_BADGES, 5
    End
scr_seq_T28_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 5
    GoToIf 1, _0117
    GoToIfSet FLAG_HGSS_GOT_RAGECANDYBAR, _010C
    Message msg_0620_T28_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0101
_009D:
    CheckMoney VAR_RESULT, 200
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00EC
    SetVar VAR_0x8004, ITEM_RAGECANDYBAR
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _00F7
    Common_GiveItemQuantity
    RemoveMoney 200
    Message msg_0620_T28_00005
    WaitButton
    SetFlag FLAG_HGSS_GOT_RAGECANDYBAR
    GoTo _014C
_00EC:
    Message msg_0620_T28_00007
    WaitButton
    GoTo _014C
_00F7:
    Common_MessageBagIsFull
    GoTo _014C
_0101:
    Message msg_0620_T28_00009
    WaitButton
    GoTo _014C
_010C:
    Message msg_0620_T28_00001
    WaitButton
    GoTo _014C
_0117:
    GoToIfSet FLAG_HGSS_GOT_RAGECANDYBAR, _0147
    Message msg_0620_T28_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _009D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0101
_0147:
    Message msg_0620_T28_00004
    WaitButton
_014C:
    CloseMessage
    ReleaseAll
    End
scr_seq_T28_001:
    LockAll
    ApplyMovement obj_T28_gsmiddleman1, _0278
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 176
    GoToIf 5, _0193
    ApplyMovement obj_T28_gsmiddleman1, _0284
    ApplyMovement LOCALID_PLAYER, _0294
    GoTo _01A3
_0193:
    ApplyMovement obj_T28_gsmiddleman1, _02A4
    ApplyMovement LOCALID_PLAYER, _02B4
_01A3:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoToIfSet FLAG_HGSS_GOT_RAGECANDYBAR, _026D
    Message msg_0620_T28_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01DF
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0257
_01DF:
    CheckMoney VAR_RESULT, 300
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0262
    SetVar VAR_0x8004, ITEM_RAGECANDYBAR
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _00F7
    Common_GiveItemQuantity
    RemoveMoney 300
    Message msg_0620_T28_00006
    CloseMessage
    SetFlag FLAG_HGSS_GOT_RAGECANDYBAR
_0228:
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 176
    GoToIf 5, _0249
    ApplyMovement obj_T28_gsmiddleman1, _02C4
    GoTo _0251
_0249:
    ApplyMovement obj_T28_gsmiddleman1, _02D0
_0251:
    WaitMovement
    ReleaseAll
    End
_0257:
    Message msg_0620_T28_00010
    CloseMessage
    GoTo _0228
_0262:
    Message msg_0620_T28_00008
    CloseMessage
    GoTo _0228
_026D:
    Message msg_0620_T28_00002
    CloseMessage
    GoTo _0228
    .balign 4, 0
_0278:
    FaceSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0284:
    WalkFastEast
    WalkFastSouth
    WalkFastWest
    EndMovement
    .balign 4, 0
_0294:
    Delay4 2
    WalkFastWest
    FaceEast
    EndMovement
    .balign 4, 0
_02A4:
    WalkFastEast
    WalkFastSouth 2
    WalkFastWest
    EndMovement
    .balign 4, 0
_02B4:
    Delay4 3
    WalkFastWest
    FaceEast
    EndMovement
    .balign 4, 0
_02C4:
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_02D0:
    WalkNormalNorth 2
    FaceSouth
    EndMovement
scr_seq_T28_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_RED_SCALE, _02FA
    Message msg_0620_T28_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02FA:
    Message msg_0620_T28_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T28_003:
    NPCMessage msg_0620_T28_00016
    End
scr_seq_T28_004:
    NPCMessage msg_0620_T28_00013
    End
scr_seq_T28_006:
    DrawSignpostInstantMessage msg_0620_T28_00017, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T28_007:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0620_T28_00018, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T28_008:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0620_T28_00019, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
