#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0589.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T25R0601_gsgirl1 1

    ScriptEntry scr_seq_T25R0601_000
    ScriptEntry scr_seq_T25R0601_001
    ScriptEntry scr_seq_T25R0601_002
    ScriptEntry scr_seq_T25R0601_003
    ScriptEntryEnd
scr_seq_T25R0601_002:
    GoToIfSet FLAG_HGSS_UNK_15D, _0176
    GoToIfUnset FLAG_HGSS_UNK_0B5, _0176
    @ HGSS: GetPartySlotWithFatefulEncounter VAR_TEMP_x4000, 492
    CompareVar VAR_MAP_LOCAL_0x00, 255
    GoToIf 1, _0176
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 492
    GoToIf 5, _0176
    SetVarFromValue VAR_HGSS_UNK_4082, 1
    End
scr_seq_T25R0601_003:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _056A
    ApplyMovement obj_T25R0601_gsgirl1, _0574
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T25R0601_gsgirl1, _0582
    ApplyMovement LOCALID_PLAYER, _058C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0592
    WaitMovement
    Message msg_0589_T25R0601_00005
    CloseMessage
    ApplyMovement obj_T25R0601_gsgirl1, _0598
    WaitMovement
    Message msg_0589_T25R0601_00006
    SetVarFromValue VAR_0x8004, ITEM_GRACIDEA
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0178
    Common_GiveItemQuantity
    Message msg_0589_T25R0601_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_15D
    SetVarFromValue VAR_HGSS_UNK_4082, 0
    ReleaseAll
    End
scr_seq_T25R0601_000:
    GoToIfSet FLAG_HGSS_UNK_0B5, _018A
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _021B
    NPCMessage msg_0589_T25R0601_00000
    End
scr_seq_T25R0601_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04F6
    GoToIfSet FLAG_HGSS_UNK_15D, _0266
    @ HGSS: GetPartySlotWithFatefulEncounter VAR_SPECIAL_RESULT, 492
    CompareVar VAR_RESULT, 255
    GoToIf 1, _029B
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 492
    GoToIf 1, _02A6
    Message msg_0589_T25R0601_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0176:
    End
_0178:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4082, 0
    ReleaseAll
    End
_018A:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0589_T25R0601_00003
    Message msg_0589_T25R0601_00008
    ShowMoney 20, 2
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 213, 0
    AddMenuEntry 214, 1
    AddMenuEntry 215, 2
    AddMenuEntry 216, 3
    AddMenuEntry 217, 4
    ShowMenu
    SetVarFromVar VAR_0x8000, VAR_RESULT
    SetVar VAR_0x8008, VAR_0x8000
    CompareVar VAR_0x8008, 0
    GoToIf 1, _02D4
    CompareVar VAR_0x8008, 1
    GoToIf 1, _02E0
    CompareVar VAR_0x8008, 2
    GoToIf 1, _02EC
    CompareVar VAR_0x8008, 3
    GoToIf 1, _02F8
    Message msg_0589_T25R0601_00010
    GoTo _0304
_021B:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_SQUIRTBOTTLE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0310
    Message msg_0589_T25R0601_00001
    SetVar VAR_0x8004, ITEM_SQUIRTBOTTLE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _031B
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_0266:
    @ HGSS: GetPartySlotWithFatefulEncounter VAR_SPECIAL_RESULT, 492
    CompareVar VAR_RESULT, 255
    GoToIf 1, _029B
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 492
    GoToIf 5, _029B
    Message msg_0589_T25R0601_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_029B:
    Message msg_0589_T25R0601_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02A6:
    ApplyMovement obj_T25R0601_gsgirl1, _059E
    WaitMovement
    Message msg_0589_T25R0601_00005
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0325
    ApplyMovement obj_T25R0601_gsgirl1, _05A4
    GoTo _0340
_02D4:
    SetVarFromValue VAR_0x8001, 95
    GoTo _037F
_02E0:
    SetVarFromValue VAR_0x8001, 96
    GoTo _037F
_02EC:
    SetVarFromValue VAR_0x8001, 97
    GoTo _037F
_02F8:
    SetVarFromValue VAR_0x8001, 98
    GoTo _037F
_0304:
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_0310:
    Message msg_0589_T25R0601_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_031B:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0325:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0428
    ApplyMovement obj_T25R0601_gsgirl1, _05AA
    GoTo _0340
_0340:
    WaitMovement
    Message msg_0589_T25R0601_00006
    SetVarFromValue VAR_0x8004, ITEM_GRACIDEA
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0443
    Common_GiveItemQuantity
    Message msg_0589_T25R0601_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_15D
    SetVarFromValue VAR_HGSS_UNK_4082, 0
    ReleaseAll
    End
_037F:
    CompareVar VAR_0x8000, 0
    CallIf 1, _0455
    CompareVar VAR_0x8000, 1
    CallIf 1, _045F
    CompareVar VAR_0x8000, 2
    CallIf 1, _0469
    CompareVar VAR_0x8000, 3
    CallIf 1, _0473
    CompareVar VAR_RESULT, 0
    GoToIf 1, _047D
    CanFitItem VAR_0x8001, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0486
    CompareVar VAR_0x8000, 0
    CallIf 1, _048F
    CompareVar VAR_0x8000, 1
    CallIf 1, _0497
    CompareVar VAR_0x8000, 2
    CallIf 1, _049F
    CompareVar VAR_0x8000, 3
    CallIf 1, _04A7
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    AddItem VAR_0x8001, 1, VAR_RESULT
    BufferItemName 0, VAR_0x8001
    Message msg_0589_T25R0601_00011
    Message msg_0589_T25R0601_00009
    GoTo _0304
_0428:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _04AF
    ApplyMovement obj_T25R0601_gsgirl1, _05B0
    GoTo _0340
_0443:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4082, 0
    ReleaseAll
    End
_0455:
    CheckMoney VAR_RESULT, 200
    Return
_045F:
    CheckMoney VAR_RESULT, 200
    Return
_0469:
    CheckMoney VAR_RESULT, 200
    Return
_0473:
    CheckMoney VAR_RESULT, 200
    Return
_047D:
    Message msg_0589_T25R0601_00013
    GoTo _0304
_0486:
    Message msg_0589_T25R0601_00012
    GoTo _0304
_048F:
    RemoveMoney 200
    Return
_0497:
    RemoveMoney 200
    Return
_049F:
    RemoveMoney 200
    Return
_04A7:
    RemoveMoney 200
    Return
_04AF:
    ApplyMovement obj_T25R0601_gsgirl1, _0598
    WaitMovement
    Message msg_0589_T25R0601_00006
    SetVarFromValue VAR_0x8004, ITEM_GRACIDEA
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0443
    Common_GiveItemQuantity
    Message msg_0589_T25R0601_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_15D
    SetVarFromValue VAR_HGSS_UNK_4082, 0
    ReleaseAll
    End
_04F6:
    GoToIfSet FLAG_HGSS_SG_3FBD, _0514
    Message msg_0589_T25R0601_00014
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FBE
    SetFlag FLAG_HGSS_SG_3FBD
    ReleaseAll
    End
_0514:
    GoToIfUnset FLAG_HGSS_SG_3FBE, _055F
    GoToIfSet FLAG_HGSS_UNK_15D, _0266
    @ HGSS: GetPartySlotWithFatefulEncounter VAR_SPECIAL_RESULT, 492
    CompareVar VAR_RESULT, 255
    GoToIf 1, _029B
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 492
    GoToIf 1, _02A6
    Message msg_0589_T25R0601_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_055F:
    Message msg_0589_T25R0601_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_056A:
    WalkNormalNorth
    Delay8
    EndMovement
    .balign 4, 0
_0574:
    Delay8
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0582:
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_058C:
    FaceEast
    EndMovement
    .balign 4, 0
_0592:
    FaceEast
    EndMovement
    .balign 4, 0
_0598:
    WalkOnSpotFastWest 4
    EndMovement
    .balign 4, 0
_059E:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_05A4:
    WalkOnSpotFastSouth 4
    EndMovement
    .balign 4, 0
_05AA:
    WalkOnSpotFastNorth 4
    EndMovement
    .balign 4, 0
_05B0:
    WalkOnSpotFastEast 4
    EndMovement
    .balign 4, 0
