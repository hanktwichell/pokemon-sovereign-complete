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
    ScriptEntry scr_seq_T28_009
    ScriptEntryEnd
scr_seq_T28_005:
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    SetFlag FLAG_HGSS_UNK_0C5
    SetFlag FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE
    CompareVar VAR_HGSS_UNK_40F8, 0
    GoToIf 5, _01BB
    SetVarFromValue VAR_HGSS_UNK_40F8, 2
    SetVar VAR_0x8004, PHONE_CONTACT_PROF__ELM
    SetVar VAR_0x8005, 2
    SetVar VAR_0x8006, 2
    CallCommonScript 0x813
    SetVarFromValue VAR_HGSS_MIDGAME_BADGES, 5
    End
scr_seq_T28_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 5
    GoToIf 1, _01D9
    GoToIfSet FLAG_HGSS_GOT_RAGECANDYBAR, _0214
    Message msg_0620_T28_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021F
    CheckMoney VAR_RESULT, 200
    CompareVar VAR_RESULT, 0
    GoToIf 1, _022A
    SetVar VAR_0x8004, ITEM_RAGECANDYBAR
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0235
    Common_GiveItemQuantity
    RemoveMoney 200
    Message msg_0620_T28_00005
    WaitButton
    SetFlag FLAG_HGSS_GOT_RAGECANDYBAR
    GoTo _023F
scr_seq_T28_001:
    LockAll
    ApplyMovement obj_T28_gsmiddleman1, _04C6
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 176
    GoToIf 5, _0245
    ApplyMovement obj_T28_gsmiddleman1, _04D0
    ApplyMovement LOCALID_PLAYER, _04DE
    GoTo _02FB
scr_seq_T28_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_RED_SCALE, _03A1
    Message msg_0620_T28_00014
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
scr_seq_T28_009:
    BufferPlayerName 0
    End
_01BB:
    SetVar VAR_0x8004, PHONE_CONTACT_PROF__ELM
    SetVar VAR_0x8005, 2
    SetVar VAR_0x8006, 2
    CallCommonScript 0x813
    SetVarFromValue VAR_HGSS_MIDGAME_BADGES, 5
    End
_01D9:
    GoToIfSet FLAG_HGSS_GOT_RAGECANDYBAR, _03AC
    Message msg_0620_T28_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03B7
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021F
    Message msg_0620_T28_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0214:
    Message msg_0620_T28_00001
    WaitButton
    GoTo _023F
_021F:
    Message msg_0620_T28_00009
    WaitButton
    GoTo _023F
_022A:
    Message msg_0620_T28_00007
    WaitButton
    GoTo _023F
_0235:
    Common_MessageBagIsFull
    GoTo _023F
_023F:
    CloseMessage
    ReleaseAll
    End
_0245:
    ApplyMovement obj_T28_gsmiddleman1, _04EC
    ApplyMovement LOCALID_PLAYER, _04FA
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoToIfSet FLAG_HGSS_GOT_RAGECANDYBAR, _0406
    Message msg_0620_T28_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0411
    CompareVar VAR_RESULT, 1
    GoToIf 1, _047B
    CheckMoney VAR_RESULT, 300
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0486
    SetVar VAR_0x8004, ITEM_RAGECANDYBAR
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0235
    Common_GiveItemQuantity
    RemoveMoney 300
    Message msg_0620_T28_00006
    CloseMessage
    SetFlag FLAG_HGSS_GOT_RAGECANDYBAR
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 176
    GoToIf 5, _0491
    ApplyMovement obj_T28_gsmiddleman1, _0508
    GoTo _049F
_02FB:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoToIfSet FLAG_HGSS_GOT_RAGECANDYBAR, _0406
    Message msg_0620_T28_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0411
    CompareVar VAR_RESULT, 1
    GoToIf 1, _047B
    CheckMoney VAR_RESULT, 300
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0486
    SetVar VAR_0x8004, ITEM_RAGECANDYBAR
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0235
    Common_GiveItemQuantity
    RemoveMoney 300
    Message msg_0620_T28_00006
    CloseMessage
    SetFlag FLAG_HGSS_GOT_RAGECANDYBAR
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 176
    GoToIf 5, _0491
    ApplyMovement obj_T28_gsmiddleman1, _0508
    GoTo _049F
_03A1:
    Message msg_0620_T28_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03AC:
    Message msg_0620_T28_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03B7:
    CheckMoney VAR_RESULT, 200
    CompareVar VAR_RESULT, 0
    GoToIf 1, _022A
    SetVar VAR_0x8004, ITEM_RAGECANDYBAR
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0235
    Common_GiveItemQuantity
    RemoveMoney 200
    Message msg_0620_T28_00005
    WaitButton
    SetFlag FLAG_HGSS_GOT_RAGECANDYBAR
    GoTo _023F
_0406:
    Message msg_0620_T28_00002
    CloseMessage
    GoTo _04A5
_0411:
    CheckMoney VAR_RESULT, 300
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0486
    SetVar VAR_0x8004, ITEM_RAGECANDYBAR
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0235
    Common_GiveItemQuantity
    RemoveMoney 300
    Message msg_0620_T28_00006
    CloseMessage
    SetFlag FLAG_HGSS_GOT_RAGECANDYBAR
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 176
    GoToIf 5, _0491
    ApplyMovement obj_T28_gsmiddleman1, _0508
    GoTo _049F
_047B:
    Message msg_0620_T28_00010
    CloseMessage
    GoTo _04A5
_0486:
    Message msg_0620_T28_00008
    CloseMessage
    GoTo _04A5
_0491:
    ApplyMovement obj_T28_gsmiddleman1, _0512
    WaitMovement
    ReleaseAll
    End
_049F:
    WaitMovement
    ReleaseAll
    End
_04A5:
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 176
    GoToIf 5, _0491
    ApplyMovement obj_T28_gsmiddleman1, _0508
    GoTo _049F
    .balign 4, 0
_04C6:
    FaceSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_04D0:
    WalkFastEast
    WalkFastSouth
    WalkFastWest
    EndMovement
    .balign 4, 0
_04DE:
    Delay4 2
    WalkFastWest
    FaceEast
    EndMovement
    .balign 4, 0
_04EC:
    WalkFastEast
    WalkFastSouth 2
    WalkFastWest
    EndMovement
    .balign 4, 0
_04FA:
    Delay4 3
    WalkFastWest
    FaceEast
    EndMovement
    .balign 4, 0
_0508:
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0512:
    WalkNormalNorth 2
    FaceSouth
    EndMovement
    .balign 4, 0
