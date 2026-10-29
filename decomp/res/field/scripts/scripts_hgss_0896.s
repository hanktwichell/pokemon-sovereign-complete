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
    GoToIfSet FLAG_HGSS_UNK_15D, _0058
    GoToIfUnset FLAG_HGSS_UNK_0B5, _0058
    @ HGSS: GetPartySlotWithFatefulEncounter VAR_TEMP_x4000, 492
    CompareVar VAR_MAP_LOCAL_0x00, 255
    GoToIf 1, _0058
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 492
    GoToIf 5, _0058
    SetVarFromValue VAR_HGSS_UNK_4082, 1
_0058:
    End
scr_seq_T25R0601_003:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00FC
    ApplyMovement obj_T25R0601_gsgirl1, _0110
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_T25R0601_gsgirl1, _0120
    ApplyMovement LOCALID_PLAYER, _0108
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _014C
    WaitMovement
    Message msg_0589_T25R0601_00005
    CloseMessage
    ApplyMovement obj_T25R0601_gsgirl1, _012C
    WaitMovement
    Message msg_0589_T25R0601_00006
    SetVarFromValue VAR_0x8004, 466
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _00EA
    Common_GiveItemQuantity
    Message msg_0589_T25R0601_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_15D
    SetVarFromValue VAR_HGSS_UNK_4082, 0
    ReleaseAll
    End
_00EA:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4082, 0
    ReleaseAll
    End
    .balign 4, 0
_00FC:
    WalkNormalNorth
    Delay8
    EndMovement
    .balign 4, 0
_0108:
    FaceEast
    EndMovement
    .balign 4, 0
_0110:
    Delay8
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0120:
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_012C:
    WalkOnSpotFastWest 4
    EndMovement
    .balign 4, 0
_0134:
    WalkOnSpotFastSouth 4
    EndMovement
    .balign 4, 0
_013C:
    WalkOnSpotFastNorth 4
    EndMovement
    .balign 4, 0
_0144:
    WalkOnSpotFastEast 4
    EndMovement
    .balign 4, 0
_014C:
    FaceEast
    EndMovement
scr_seq_T25R0601_000:
    GoToIfSet FLAG_HGSS_UNK_0B5, _01E5
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0185
    NPCMessage msg_0589_T25R0601_00000
    End
_0185:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_SQUIRTBOTTLE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01D0
    Message msg_0589_T25R0601_00001
    SetVar VAR_0x8004, ITEM_SQUIRTBOTTLE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01DB
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_01D0:
    Message msg_0589_T25R0601_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DB:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_01E5:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0589_T25R0601_00003
    Message msg_0589_T25R0601_00008
    @ HGSS: ShowMoneyBox 20, 2
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 213, 0
    AddMenuEntryImm 214, 1
    AddMenuEntryImm 215, 2
    AddMenuEntryImm 216, 3
    AddMenuEntryImm 217, 4
    ShowMenu
    SetVarFromVar VAR_0x8000, VAR_RESULT
    SetVar VAR_0x8008, VAR_0x8000
    CompareVar VAR_0x8008, 0
    GoToIf 1, _033D
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0349
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0355
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0361
    Message msg_0589_T25R0601_00010
    GoTo _031F
_0276:
    CompareVar VAR_0x8000, 0
    CallIf 1, _036D
    CompareVar VAR_0x8000, 1
    CallIf 1, _0377
    CompareVar VAR_0x8000, 2
    CallIf 1, _0381
    CompareVar VAR_0x8000, 3
    CallIf 1, _038B
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0334
    CanFitItem VAR_0x8001, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _032B
    CompareVar VAR_0x8000, 0
    CallIf 1, _0395
    CompareVar VAR_0x8000, 1
    CallIf 1, _039D
    CompareVar VAR_0x8000, 2
    CallIf 1, _03A5
    CompareVar VAR_0x8000, 3
    CallIf 1, _03AD
    @ HGSS: UpdateMoneyBox
    PlaySE SEQ_SE_DP_REGI_sseq
    AddItem VAR_0x8001, 1, VAR_RESULT
    BufferItemName 0, VAR_0x8001
    Message msg_0589_T25R0601_00011
    Message msg_0589_T25R0601_00009
    GoTo _031F
_031F:
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_032B:
    Message msg_0589_T25R0601_00012
    GoTo _031F
_0334:
    Message msg_0589_T25R0601_00013
    GoTo _031F
_033D:
    SetVarFromValue VAR_0x8001, 95
    GoTo _0276
_0349:
    SetVarFromValue VAR_0x8001, 96
    GoTo _0276
_0355:
    SetVarFromValue VAR_0x8001, 97
    GoTo _0276
_0361:
    SetVarFromValue VAR_0x8001, 98
    GoTo _0276
_036D:
    CheckMoney VAR_RESULT, 200
    Return
_0377:
    CheckMoney VAR_RESULT, 200
    Return
_0381:
    CheckMoney VAR_RESULT, 200
    Return
_038B:
    CheckMoney VAR_RESULT, 200
    Return
_0395:
    RemoveMoney 200
    Return
_039D:
    RemoveMoney 200
    Return
_03A5:
    RemoveMoney 200
    Return
_03AD:
    RemoveMoney 200
    Return
scr_seq_T25R0601_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_15D, _03FD
    @ HGSS: GetPartySlotWithFatefulEncounter VAR_SPECIAL_RESULT, 492
    CompareVar VAR_RESULT, 255
    GoToIf 1, _03F2
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 492
    GoToIf 1, _0432
_03F2:
    Message msg_0589_T25R0601_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03FD:
    @ HGSS: GetPartySlotWithFatefulEncounter VAR_SPECIAL_RESULT, 492
    CompareVar VAR_RESULT, 255
    GoToIf 1, _03F2
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 492
    GoToIf 5, _03F2
    Message msg_0589_T25R0601_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0432:
    ApplyMovement obj_T25R0601_gsgirl1, _04F0
    WaitMovement
    Message msg_0589_T25R0601_00005
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0460
    ApplyMovement obj_T25R0601_gsgirl1, _0134
    GoTo _049E
_0460:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _047B
    ApplyMovement obj_T25R0601_gsgirl1, _013C
    GoTo _049E
_047B:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0496
    ApplyMovement obj_T25R0601_gsgirl1, _0144
    GoTo _049E
_0496:
    ApplyMovement obj_T25R0601_gsgirl1, _012C
_049E:
    WaitMovement
    Message msg_0589_T25R0601_00006
    SetVarFromValue VAR_0x8004, 466
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _04DD
    Common_GiveItemQuantity
    Message msg_0589_T25R0601_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_15D
    SetVarFromValue VAR_HGSS_UNK_4082, 0
    ReleaseAll
    End
_04DD:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4082, 0
    ReleaseAll
    End
    .balign 4, 0
_04F0:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
