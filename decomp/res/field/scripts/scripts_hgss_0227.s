#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0375.h"

#define obj_R30_tsure_poke_static_rattata 6
#define obj_R30_tsure_poke_static_pidgey 7
#define obj_R30_gsboy2_3 8
#define obj_R30_gsmiddleman1 13

    ScriptEntry scr_seq_R30_000
    ScriptEntry scr_seq_R30_001
    ScriptEntry scr_seq_R30_002
    ScriptEntry scr_seq_R30_003
    ScriptEntry scr_seq_R30_004
    ScriptEntry scr_seq_R30_005
    ScriptEntry scr_seq_R30_006
    ScriptEntry scr_seq_R30_007
    ScriptEntry scr_seq_R30_008
    ScriptEntry scr_seq_R30_009
    ScriptEntry scr_seq_R30_010
    ScriptEntryEnd
scr_seq_R30_001:
    SetFlag FLAG_HGSS_GOT_ELMS_PANIC_CALL
    @ HGSS: PhoneCall PHONE_CONTACT_PROF__ELM, 2, 0
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_OW, 3
    End
scr_seq_R30_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0375_R30_00000
    CloseMessage
    ApplyMovement obj_R30_tsure_poke_static_rattata, _0088
    WaitMovement
    ApplyMovement obj_R30_tsure_poke_static_pidgey, _0090
    WaitMovement
    PlaySE SE_CONFIRM_sseq_3
    FacePlayer
    Message msg_0375_R30_00001
    CloseMessage
    ApplyMovement obj_R30_gsboy2_3, _0098
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0088:
    JumpOnSpotFastNorth 3
    EndMovement
    .balign 4, 0
_0090:
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_0098:
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_R30_002:
    LockAll
    @ HGSS: ScrCmd_307 17, 11, 11, 3, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ClearFlag FLAG_HGSS_HIDE_ROUTE_30_APRICORN_MAN
    AddObject obj_R30_gsmiddleman1
    ApplyMovement obj_R30_gsmiddleman1, _01B0
    WaitMovement
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    ApplyMovement obj_R30_gsmiddleman1, _01C4
    WaitMovement
    Message msg_0375_R30_00005
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x00, 558
    GoToIf 5, _010A
    ApplyMovement LOCALID_PLAYER, _01D4
    GoTo _0148
_010A:
    CompareVar VAR_MAP_LOCAL_0x00, 559
    GoToIf 5, _0125
    ApplyMovement LOCALID_PLAYER, _01E8
    GoTo _0148
_0125:
    CompareVar VAR_MAP_LOCAL_0x00, 560
    GoToIf 5, _0140
    ApplyMovement LOCALID_PLAYER, _01FC
    GoTo _0148
_0140:
    ApplyMovement LOCALID_PLAYER, _0210
_0148:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0375_R30_00006
    SetVar VAR_0x8004, ITEM_APRICORN_BOX
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0375_R30_00008
    CloseMessage
    ApplyMovement obj_R30_gsmiddleman1, _01CC
    WaitMovement
    @ HGSS: ScrCmd_307 17, 11, 11, 3, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_R30_gsmiddleman1, _01B8
    WaitMovement
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    RemoveObject obj_R30_gsmiddleman1
    SetFlag FLAG_HGSS_HIDE_ROUTE_30_APRICORN_MAN
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_APRICORN_BOX
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_OW, 1
    End
    .balign 4, 0
_01B0:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_01B8:
    WalkNormalNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_01C4:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_01CC:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01D4:
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    Delay8 2
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_01E8:
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    Delay8 2
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_01FC:
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    Delay8 2
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_0210:
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    Delay8 2
    WalkNormalWest 5
    EndMovement
scr_seq_R30_003:
    NPCMessage msg_0375_R30_00013
    End
scr_seq_R30_004:
    LockAll
    @ HGSS: PhoneCall PHONE_CONTACT_MOTHER, 2, 0
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_PHONE_CALL, 0
    SetFlag FLAG_HGSS_TALKED_TO_MOM_AFTER_NAMING_RIVAL
    ReleaseAll
    End
scr_seq_R30_005:
    DrawSignpostInstantMessage msg_0375_R30_00009, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R30_006:
    DrawSignpostInstantMessage msg_0375_R30_00010, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R30_007:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0375_R30_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R30_008:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0375_R30_00011, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R30_009:
    GoToIfSet FLAG_HGSS_GOT_POKEDEX, _02D5
    NPCMessage msg_0375_R30_00002
    End
_02D5:
    NPCMessage msg_0375_R30_00003
    End
scr_seq_R30_010:
    NPCMessage msg_0375_R30_00004
    End
    .balign 4, 0
