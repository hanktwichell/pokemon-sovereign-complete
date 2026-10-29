#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0535.h"

#define obj_T11R0601_policeman 0
#define obj_T11R0601_gsleader9 4

    ScriptEntry scr_seq_T11R0601_000
    ScriptEntry scr_seq_T11R0601_001
    ScriptEntry scr_seq_T11R0601_002
    ScriptEntry scr_seq_T11R0601_003
    ScriptEntry scr_seq_T11R0601_004
    ScriptEntry scr_seq_T11R0601_005
    ScriptEntry scr_seq_T11R0601_006
    ScriptEntry scr_seq_T11R0601_007
    ScriptEntry scr_seq_T11R0601_008
    ScriptEntryEnd
scr_seq_T11R0601_006:
    @ HGSS: ScrCmd_582 MAP_GOLDENROD, 1290, 209
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _003F
    GoTo _0045
_003F:
    SetVarFromValue VAR_HGSS_UNK_411D, 0
_0045:
    SetFlag FLAG_HGSS_HIDE_SAFFRON_TRAIN_STATION_LT_SURGE
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _007E
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _007E
    GoToIfSet FLAG_HGSS_TRADE_LT_SURGE_PIKACHU, _007E
    ClearFlag FLAG_HGSS_HIDE_SAFFRON_TRAIN_STATION_LT_SURGE
_007E:
    End
scr_seq_T11R0601_005:
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _008D
    End
_008D:
    SetPosition obj_T11R0601_policeman, 12, 0, 7, DIR_EAST
    End
scr_seq_T11R0601_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _00B9
    Message msg_0535_T11R0601_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B9:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _00D7
    Message msg_0535_T11R0601_00005
    WaitButton
    CloseMessage
    GoTo _00E6
_00D7:
    Message msg_0535_T11R0601_00007
    CloseMessage
    ApplyMovement obj_T11R0601_policeman, _00EC
    WaitMovement
_00E6:
    ReleaseAll
    End
    .balign 4, 0
_00EC:
    FaceEast
    EndMovement
scr_seq_T11R0601_004:
    LockAll
    ApplyMovement LOCALID_PLAYER, _017C
    WaitMovement
    GoToIfSet FLAG_HGSS_UNK_123, _0158
    Message msg_0535_T11R0601_00001
    CloseMessage
    SetFlag FLAG_HGSS_UNK_123
_0116:
    WaitTime 50, VAR_0x8004
    CheckItem ITEM_PASS, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0163
    Message msg_0535_T11R0601_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0184
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_0158:
    Message msg_0535_T11R0601_00003
    CloseMessage
    GoTo _0116
_0163:
    Message msg_0535_T11R0601_00004
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_411D, 1
    SetVarFromValue VAR_HGSS_UNK_411F, 1
    ReleaseAll
    End
    .balign 4, 0
_017C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0184:
    WalkNormalSouth 2
    EndMovement
scr_seq_T11R0601_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0535_T11R0601_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _024F
    Message msg_0535_T11R0601_00014
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_566
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _024F
    @ HGSS: LoadNPCTrade 10
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    @ HGSS: NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _0242
    @ HGSS: NPCTradeExec VAR_SPECIAL_x8004
    @ HGSS: NPCTradeEnd
    SetFlag FLAG_HGSS_TRADE_LT_SURGE_PIKACHU
    Message msg_0535_T11R0601_00016
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _022C
    ApplyMovement obj_T11R0601_gsleader9, _025C
    GoTo _0234
_022C:
    ApplyMovement obj_T11R0601_gsleader9, _0268
_0234:
    WaitMovement
    RemoveObject obj_T11R0601_gsleader9
    SetFlag FLAG_HGSS_HIDE_SAFFRON_TRAIN_STATION_LT_SURGE
    ReleaseAll
    End
_0242:
    @ HGSS: NPCTradeEnd
    Message msg_0535_T11R0601_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_024F:
    Message msg_0535_T11R0601_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_025C:
    WalkSlightlyFastWest 5
    WalkSlightlyFastSouth 10
    EndMovement
    .balign 4, 0
_0268:
    WalkSlightlyFastSouth 10
    EndMovement
scr_seq_T11R0601_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _028E
    Message msg_0535_T11R0601_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_028E:
    Message msg_0535_T11R0601_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T11R0601_002:
    NPCMessage msg_0535_T11R0601_00010
    End
scr_seq_T11R0601_003:
    NPCMessage msg_0535_T11R0601_00011
    End
scr_seq_T11R0601_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0535_T11R0601_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
