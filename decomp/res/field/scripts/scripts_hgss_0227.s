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
    ScriptEntry scr_seq_R30_011
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
    ApplyMovement obj_R30_tsure_poke_static_rattata, _03BA
    WaitMovement
    ApplyMovement obj_R30_tsure_poke_static_pidgey, _03C0
    WaitMovement
    PlaySE SE_CONFIRM_sseq_3
    FacePlayer
    Message msg_0375_R30_00001
    CloseMessage
    ApplyMovement obj_R30_gsboy2_3, _03C6
    WaitMovement
    ReleaseAll
    End
scr_seq_R30_002:
    LockAll
    @ HGSS: ScrCmd_307 17, 11, 11, 3, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ClearFlag FLAG_HGSS_HIDE_ROUTE_30_APRICORN_MAN
    AddObject obj_R30_gsmiddleman1
    ApplyMovement obj_R30_gsmiddleman1, _03CC
    WaitMovement
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    ApplyMovement obj_R30_gsmiddleman1, _03D2
    WaitMovement
    Message msg_0375_R30_00005
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x00, 558
    GoToIf 5, _023D
    ApplyMovement LOCALID_PLAYER, _03D8
    GoTo _0258
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
    GoToIfSet FLAG_HGSS_GOT_POKEDEX, _02C0
    NPCMessage msg_0375_R30_00002
    End
scr_seq_R30_010:
    NPCMessage msg_0375_R30_00004
    End
scr_seq_R30_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0375_R30_00014
    Message msg_0375_R30_00015
    Message msg_0375_R30_00016
    Message msg_0375_R30_00017
    Message msg_0375_R30_00018
    Message msg_0375_R30_00019
    GetPartyCount VAR_0x8005
    GivePokemon SPECIES_EEVEE, 5, 0, VAR_RESULT
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0375_R30_00020
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _035E
    Message msg_0375_R30_00021
    Message msg_0375_R30_00022
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 15
    SetFlag FLAG_HGSS_SG_3F5C
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_DOOR_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_023D:
    CompareVar VAR_MAP_LOCAL_0x00, 559
    GoToIf 5, _02D3
    ApplyMovement LOCALID_PLAYER, _03EA
    GoTo _0258
_0258:
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
    ApplyMovement obj_R30_gsmiddleman1, _03FC
    WaitMovement
    @ HGSS: ScrCmd_307 17, 11, 11, 3, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_R30_gsmiddleman1, _0402
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
_02C0:
    NPCMessage msg_0375_R30_00003
    End
_02D3:
    CompareVar VAR_MAP_LOCAL_0x00, 560
    GoToIf 5, _02EE
    ApplyMovement LOCALID_PLAYER, _040C
    GoTo _0258
_02EE:
    ApplyMovement LOCALID_PLAYER, _041E
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
    ApplyMovement obj_R30_gsmiddleman1, _03FC
    WaitMovement
    @ HGSS: ScrCmd_307 17, 11, 11, 3, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_R30_gsmiddleman1, _0402
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
_035E:
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_SPECIAL_x8005, VAR_TEMP_x4000
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0375_R30_00021
    Message msg_0375_R30_00022
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 15
    SetFlag FLAG_HGSS_SG_3F5C
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_DOOR_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_03BA:
    JumpOnSpotFastNorth 3
    EndMovement
    .balign 4, 0
_03C0:
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_03C6:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03CC:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_03D2:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_03D8:
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    Delay8 2
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_03EA:
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    Delay8 2
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_03FC:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0402:
    WalkNormalNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_040C:
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    Delay8 2
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_041E:
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    Delay8 2
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
