#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0458.h"


    ScriptEntry scr_seq_T02R0302_000
    ScriptEntry scr_seq_T02R0302_001
    ScriptEntry scr_seq_T02R0302_002
    ScriptEntry scr_seq_T02R0302_003
    ScriptEntryEnd
scr_seq_T02R0302_002:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_412E, 2
    Message msg_0458_T02R0302_00007
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0070
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0458_T02R0302_00008
    GoToIfSet FLAG_HGSS_UNK_176, _0063
    Message msg_0458_T02R0302_00009
    SetFlag FLAG_HGSS_UNK_25B
    @ HGSS: Dummy486
    SetVarFromValue VAR_HGSS_UNK_40E5, 2
    Message msg_0458_T02R0302_00011
    SetFlag FLAG_HGSS_UNK_176
_0063:
    Message msg_0458_T02R0302_00012
    GoTo _0091
_006C:
    ReleaseAll
    End
    .balign 4, 0
_0070:
    WalkNormalWest 2
    WalkNormalSouth
    WalkNormalWest 2
    EndMovement
scr_seq_T02R0302_000:
scr_seq_T02R0302_003:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0120
    WaitMovement
    Message msg_0458_T02R0302_00000
_0091:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00ED
    @ HGSS: SetFollowMonInhibitState 1
    SetVarFromValue VAR_HGSS_UNK_412E, 5
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00ED
    @ HGSS: ScrCmd_600
    HealParty
    Message msg_0458_T02R0302_00002
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _017C
    WaitMovement
    @ HGSS: ScrCmd_607
    @ HGSS: ScrCmd_109 253, 56
    SetVarFromValue VAR_HGSS_UNK_412E, 4
    ReleaseAll
    End
_00ED:
    @ HGSS: SetFollowMonInhibitState 0
    Message msg_0458_T02R0302_00003
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0184
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_UNK_412E, 3
    ReleaseAll
    End
    .balign 4, 0
_0120:
    WalkOnSpotNormalWest
    EndMovement
scr_seq_T02R0302_001:
    LockAll
    Message msg_0458_T02R0302_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0168
    Message msg_0458_T02R0302_00005
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _0184
    WaitMovement
    @ HGSS: SetFollowMonInhibitState 0
    @ HGSS: ScrCmd_606
    @ HGSS: ScrCmd_109 253, 48
    SetVarFromValue VAR_HGSS_UNK_412E, 3
    ReleaseAll
    End
_0168:
    Message msg_0458_T02R0302_00006
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _017C
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_017C:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0184:
    WalkNormalEast
    EndMovement
    .balign 4, 0
