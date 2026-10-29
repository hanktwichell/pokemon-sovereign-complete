#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0103.h"

#define obj_D32R0101_bfsw2 3
#define obj_D32R0101_bfsw2_2 4
#define obj_D32R0101_bfsw2_3 5
#define obj_D32R0101_bfsw2_4 6
#define obj_D32R0101_bfsw2_5 7
#define obj_D32R0101_bfsw2_6 8

    ScriptEntry scr_seq_D32R0101_000
    ScriptEntry scr_seq_D32R0101_001
    ScriptEntry scr_seq_D32R0101_002
    ScriptEntry scr_seq_D32R0101_003
    ScriptEntry scr_seq_D32R0101_004
    ScriptEntry scr_seq_D32R0101_005
    ScriptEntry scr_seq_D32R0101_006
    ScriptEntry scr_seq_D32R0101_007
    ScriptEntry scr_seq_D32R0101_008
    ScriptEntry scr_seq_D32R0101_009
    ScriptEntry scr_seq_D32R0101_010
    ScriptEntry scr_seq_D32R0101_011
    ScriptEntryEnd
scr_seq_D32R0101_011:
    SetFlag FLAG_HGSS_SYS_FLYPOINT_UNION_CAVE
    SetVarFromValue VAR_HGSS_UNK_40E5, 2
    End
scr_seq_D32R0101_000:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40E6, 1
    Call _02FF
    Message msg_0103_D32R0101_00000
    CloseMessage
    Call _0333
    GoToIfSet FLAG_HGSS_UNK_176, _0077
    Message msg_0103_D32R0101_00001
    BufferPlayerName 0
    PlayFanfare SEQ_FANFA4_sseq
    Message msg_0103_D32R0101_00002
    WaitFanfare
    SetFlag FLAG_HGSS_UNK_176
_0077:
    Message msg_0103_D32R0101_00003
    Call _00A6
    Message msg_0103_D32R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0103_D32R0101_00004
    Call _00A6
    GoTo _012B
    End
_00A6:
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 451, 0
    AddMenuEntryImm 452, 1
    AddMenuEntryImm 453, 2
    AddMenuEntryImm 454, 3
    AddMenuEntryImm 455, 4
    AddMenuEntryImm 456, 5
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0138
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0170
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0146
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0154
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0162
    Return
_012B:
    Message msg_0103_D32R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0138:
    Message msg_0103_D32R0101_00005
    Message msg_0103_D32R0101_00004
    GoTo _00A6
    End
_0146:
    Message msg_0103_D32R0101_00007
    Message msg_0103_D32R0101_00004
    GoTo _00A6
    End
_0154:
    Message msg_0103_D32R0101_00008
    Message msg_0103_D32R0101_00004
    GoTo _00A6
    End
_0162:
    Message msg_0103_D32R0101_00009
    Message msg_0103_D32R0101_00004
    GoTo _00A6
    End
_0170:
    Message msg_0103_D32R0101_00006
    Message msg_0103_D32R0101_00004
    GoTo _00A6
    End
scr_seq_D32R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0103_D32R0101_00017
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01AD
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01B8
    End
_01AD:
    Message msg_0103_D32R0101_00018
    GoTo _01B8
    End
_01B8:
    Message msg_0103_D32R0101_00019
    GoTo _01C3
    End
_01C3:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0103_D32R0101_00020
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01FA
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0205
    End
_01FA:
    Message msg_0103_D32R0101_00021
    GoTo _0205
    End
_0205:
    Message msg_0103_D32R0101_00022
    GoTo _0210
    End
_0210:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0103_D32R0101_00023
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0247
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0252
    End
_0247:
    Message msg_0103_D32R0101_00024
    GoTo _0252
    End
_0252:
    Message msg_0103_D32R0101_00025
    GoTo _025D
    End
_025D:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0103_D32R0101_00026
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0294
    CompareVar VAR_RESULT, 1
    GoToIf 1, _029F
    End
_0294:
    Message msg_0103_D32R0101_00027
    GoTo _029F
    End
_029F:
    Message msg_0103_D32R0101_00028
    GoTo _02AA
    End
_02AA:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0103_D32R0101_00029
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02E1
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02EC
    End
_02E1:
    Message msg_0103_D32R0101_00030
    GoTo _02EC
    End
_02EC:
    Message msg_0103_D32R0101_00031
    GoTo _02F7
    End
_02F7:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02FF:
    ApplyMovement obj_D32R0101_bfsw2, _0384
    ApplyMovement obj_D32R0101_bfsw2_2, _0384
    ApplyMovement obj_D32R0101_bfsw2_3, _0384
    ApplyMovement obj_D32R0101_bfsw2_4, _0384
    ApplyMovement obj_D32R0101_bfsw2_5, _0384
    ApplyMovement obj_D32R0101_bfsw2_6, _0384
    WaitMovement
    Return
_0333:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D32R0101_bfsw2, _038C
    ApplyMovement obj_D32R0101_bfsw2_2, _038C
    ApplyMovement obj_D32R0101_bfsw2_3, _038C
    ApplyMovement obj_D32R0101_bfsw2_4, _0394
    ApplyMovement obj_D32R0101_bfsw2_5, _0394
    ApplyMovement obj_D32R0101_bfsw2_6, _0394
    ApplyMovement LOCALID_PLAYER, _039C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
    .balign 4, 0
_0384:
    FaceSouth
    EndMovement
    .balign 4, 0
_038C:
    FaceEast
    EndMovement
    .balign 4, 0
_0394:
    FaceWest
    EndMovement
    .balign 4, 0
_039C:
    WalkNormalNorth 3
    WalkOnSpotNormalWest
    EndMovement
scr_seq_D32R0101_007:
    NPCMessage msg_0103_D32R0101_00032
    End
scr_seq_D32R0101_008:
    NPCMessage msg_0103_D32R0101_00033
    End
scr_seq_D32R0101_009:
    NPCMessage msg_0103_D32R0101_00034
    End
scr_seq_D32R0101_010:
    NPCMessage msg_0103_D32R0101_00035
    End
    .balign 4, 0
