#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0587.h"

#define obj_T25R0501_policeman 0

    ScriptEntry scr_seq_T25R0501_000
    ScriptEntry scr_seq_T25R0501_001
    ScriptEntry scr_seq_T25R0501_002
    ScriptEntry scr_seq_T25R0501_003
    ScriptEntry scr_seq_T25R0501_004
    ScriptEntry scr_seq_T25R0501_005
    ScriptEntry scr_seq_T25R0501_006
    ScriptEntry scr_seq_T25R0501_007
    ScriptEntry scr_seq_T25R0501_008
    ScriptEntryEnd
scr_seq_T25R0501_006:
    @ HGSS: ScrCmd_582 MAP_GOLDENROD, 348, 350
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0162
    End
scr_seq_T25R0501_005:
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _016A
    End
scr_seq_T25R0501_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0178
    Message msg_0587_T25R0501_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0501_001:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0350
    WaitMovement
    GoToIfSet FLAG_HGSS_UNK_123, _0196
    Message msg_0587_T25R0501_00001
    CloseMessage
    SetFlag FLAG_HGSS_UNK_123
    WaitTime 50, VAR_0x8004
    CheckItem ITEM_PASS, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _01A1
    Message msg_0587_T25R0501_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0356
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
scr_seq_T25R0501_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0587_T25R0501_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0501_002:
    End
scr_seq_T25R0501_003:
    End
scr_seq_T25R0501_004:
    End
scr_seq_T25R0501_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    MessageGendered msg_0587_T25R0501_00010, msg_0587_T25R0501_00011
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    BufferPartyMonSpecies 1, 0
    CompareVar VAR_MAP_LOCAL_0x01, 25
    GoToIf 1, _01B8
    CompareVar VAR_MAP_LOCAL_0x01, 113
    GoToIf 1, _01E5
    CompareVar VAR_MAP_LOCAL_0x01, 83
    GoToIf 1, _0212
    CompareVar VAR_MAP_LOCAL_0x01, 366
    GoToIf 1, _023F
    CompareVar VAR_MAP_LOCAL_0x01, 104
    GoToIf 1, _027F
    CompareVar VAR_MAP_LOCAL_0x01, 105
    GoToIf 1, _027F
    CompareVar VAR_MAP_LOCAL_0x01, 132
    GoToIf 1, _02AC
    Message msg_0587_T25R0501_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0162:
    SetVarFromValue VAR_HGSS_UNK_410B, 0
    End
_016A:
    SetPosition obj_T25R0501_policeman, 4, 0, 6, DIR_EAST
    End
_0178:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _02EC
    Message msg_0587_T25R0501_00005
    WaitButton
    CloseMessage
    GoTo _02FF
_0196:
    Message msg_0587_T25R0501_00003
    CloseMessage
    GoTo _0303
_01A1:
    Message msg_0587_T25R0501_00004
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_410B, 1
    SetVarFromValue VAR_HGSS_UNK_411E, 1
    ReleaseAll
    End
_01B8:
    GoToIfSet FLAG_HGSS_SG_3F6B, _0345
    Message msg_0587_T25R0501_00013
    SetVar VAR_0x8004, ITEM_LIGHT_BALL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F6B
    Message msg_0587_T25R0501_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01E5:
    GoToIfSet FLAG_HGSS_SG_3F6A, _0345
    Message msg_0587_T25R0501_00013
    SetVar VAR_0x8004, ITEM_LUCKY_PUNCH
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F6A
    Message msg_0587_T25R0501_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0212:
    GoToIfSet FLAG_HGSS_SG_3F69, _0345
    Message msg_0587_T25R0501_00013
    SetVar VAR_0x8004, ITEM_STICK
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F69
    Message msg_0587_T25R0501_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_023F:
    GoToIfSet FLAG_HGSS_SG_3F68, _0345
    Message msg_0587_T25R0501_00013
    Message msg_0587_T25R0501_00014
    SetVar VAR_0x8004, ITEM_DEEPSEATOOTH
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_DEEPSEASCALE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F68
    Message msg_0587_T25R0501_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_027F:
    GoToIfSet FLAG_HGSS_SG_3F67, _0345
    Message msg_0587_T25R0501_00013
    SetVar VAR_0x8004, ITEM_THICK_CLUB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F67
    Message msg_0587_T25R0501_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02AC:
    GoToIfSet FLAG_HGSS_SG_3F66, _0345
    Message msg_0587_T25R0501_00013
    Message msg_0587_T25R0501_00014
    SetVar VAR_0x8004, ITEM_QUICK_POWDER
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_METAL_POWDER
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F66
    Message msg_0587_T25R0501_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02EC:
    Message msg_0587_T25R0501_00007
    CloseMessage
    ApplyMovement obj_T25R0501_policeman, _035C
    WaitMovement
    ReleaseAll
    End
_02FF:
    ReleaseAll
    End
_0303:
    WaitTime 50, VAR_0x8004
    CheckItem ITEM_PASS, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _01A1
    Message msg_0587_T25R0501_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0356
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_0345:
    Message msg_0587_T25R0501_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0350:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0356:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_035C:
    FaceEast
    EndMovement
    .balign 4, 0
