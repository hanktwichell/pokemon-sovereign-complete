#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0345.h"

#define obj_R10R0202_policeman 0
#define obj_R10R0202_gsassistantm 1
#define obj_R10R0202_gsbigman 6

    ScriptEntry scr_seq_R10R0202_000
    ScriptEntry scr_seq_R10R0202_001
    ScriptEntry scr_seq_R10R0202_002
    ScriptEntry scr_seq_R10R0202_003
    ScriptEntry scr_seq_R10R0202_004
    ScriptEntry scr_seq_R10R0202_005
    ScriptEntry scr_seq_R10R0202_006
    ScriptEntry scr_seq_R10R0202_007
    ScriptEntry scr_seq_R10R0202_008
    ScriptEntry scr_seq_R10R0202_009
    ScriptEntry scr_seq_R10R0202_010
    ScriptEntryEnd
scr_seq_R10R0202_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_MACHINE_PART, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0246
    GoToIfSet FLAG_HGSS_GOT_POWER_PLANT_MANAGERS_STORY, _02E3
    SetFlag FLAG_HGSS_GOT_POWER_PLANT_MANAGERS_STORY
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_10_POWER_PLANT, 1
    Message msg_0345_R10R0202_00013
    WaitButton
    CloseMessage
    ApplyMovement obj_R10R0202_policeman, _0326
    WaitMovement
    ReleaseAll
    End
scr_seq_R10R0202_007:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R10R0202_policeman, _032C
    ApplyMovement LOCALID_PLAYER, _0346
    ApplyMovement obj_R10R0202_gsassistantm, _035C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0345_R10R0202_00001
    CloseMessage
    ApplyMovement obj_R10R0202_policeman, _0366
    ApplyMovement LOCALID_PLAYER, _0374
    WaitMovement
    Message msg_0345_R10R0202_00002
    CloseMessage
    ApplyMovement obj_R10R0202_policeman, _037E
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_GYM_ROCKET
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_10_POWER_PLANT, 0
    SetVarFromValue VAR_HGSS_UNK_411C, 1
    ReleaseAll
    End
scr_seq_R10R0202_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_POWER_PLANT_MANAGERS_STORY, _02F8
    Message msg_0345_R10R0202_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R10R0202_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_POWER_PLANT_DUGTRIO_MAGNETON, _0303
    Message msg_0345_R10R0202_00008
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _030E
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _030E
    InitNPCTrade NPC_TRADE_HGSS_PERRY_PORYGON2
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _0319
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_AURA_SPHERE
    SetFlag FLAG_HGSS_TRADE_POWER_PLANT_DUGTRIO_MAGNETON
    Message msg_0345_R10R0202_00009
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0345_R10R0202_00021
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
scr_seq_R10R0202_003:
    NPCMessage msg_0345_R10R0202_00006
    End
scr_seq_R10R0202_001:
    NPCMessage msg_0345_R10R0202_00004
    End
scr_seq_R10R0202_002:
    NPCMessage msg_0345_R10R0202_00005
    End
scr_seq_R10R0202_004:
    NPCMessage msg_0345_R10R0202_00007
    End
scr_seq_R10R0202_008:
    NPCMessage msg_0345_R10R0202_00018
    End
scr_seq_R10R0202_009:
    NPCMessage msg_0345_R10R0202_00019
    End
scr_seq_R10R0202_010:
    BufferPlayerName 0
    End
_0246:
    Message msg_0345_R10R0202_00014
    CloseMessage
    RemoveItem ITEM_MACHINE_PART, 1, VAR_RESULT
    ApplyMovement obj_R10R0202_gsbigman, _0390
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_REPAIRED, 13, 7, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0345_R10R0202_00015
    ApplyMovement obj_R10R0202_gsbigman, _03A6
    WaitMovement
    SetFlag FLAG_HGSS_RESTORED_POWER
    Message msg_0345_R10R0202_00016
    SetVar VAR_0x8004, ITEM_TM57
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0345_R10R0202_00017
    WaitButton
    CloseMessage
    Message msg_0345_R10R0202_00020
    WaitButton
    CloseMessage
    SetVar VAR_0x8004, ITEM_RED_CHAIN
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    SetFlag FLAG_HGSS_UNK_258
    ClearFlag FLAG_HGSS_HIDE_LAVENDER_RADIO_TOWER_DIRECTOR
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_COPYCAT_HOUSE_CLEFAIRY_DOLL
    ClearFlag FLAG_HGSS_HIDE_VERMILION_FAN_CLUB_LOST_ITEM
    SetVarFromValue VAR_HGSS_UNK_40FF, 1
    ReleaseAll
    End
_02E3:
    Message msg_0345_R10R0202_00013
    WaitButton
    CloseMessage
    ApplyMovement obj_R10R0202_policeman, _0326
    WaitMovement
    ReleaseAll
    End
_02F8:
    Message msg_0345_R10R0202_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0303:
    Message msg_0345_R10R0202_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_030E:
    Message msg_0345_R10R0202_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0319:
    FinishNPCTrade
    Message msg_0345_R10R0202_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0326:
    FaceSouth
    EndMovement
    .balign 4, 0
_032C:
    EmoteExclamationMark
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast 5
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0346:
    Delay32 2
    WalkNormalNorth
    FaceSouth
    Delay16
    FaceEast
    EndMovement
    .balign 4, 0
_035C:
    Delay32 4
    FaceSouth
    EndMovement
    .balign 4, 0
_0366:
    WalkNormalSouth 2
    WalkNormalWest 5
    FaceNorth
    EndMovement
    .balign 4, 0
_0374:
    Delay8 7
    FaceSouth
    EndMovement
    .balign 4, 0
_037E:
    WalkNormalSouth 3
    WalkNormalWest 2
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0390:
    WalkOnSpotNormalWest
    Delay2
    WalkOnSpotNormalWest
    Delay2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_03A6:
    FaceNorth
    EndMovement
    .balign 4, 0
