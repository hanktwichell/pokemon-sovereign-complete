#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0403.h"

#define obj_R43R0201_rocketm 0
#define obj_R43R0201_rocketm_2 1

    ScriptEntry scr_seq_R43R0201_000
    ScriptEntry scr_seq_R43R0201_001
    ScriptEntry scr_seq_R43R0201_002
    ScriptEntry scr_seq_R43R0201_003
    ScriptEntryEnd
scr_seq_R43R0201_001:
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0037
    GoTo _0095
    GoTo _0066
_0037:
    ApplyMovement obj_R43R0201_rocketm, _0114
    ApplyMovement obj_R43R0201_rocketm_2, _0128
    WaitMovement
    Message msg_0403_R43R0201_00000
    CheckMoney VAR_RESULT, 1000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _006C
    Message msg_0403_R43R0201_00001
    CloseMessage
_0066:
    GoTo _0077
_006C:
    Message msg_0403_R43R0201_00002
    CloseMessage
    GoTo _0077
_0077:
    RemoveMoney 1000
    ApplyMovement obj_R43R0201_rocketm, _0144
    ApplyMovement obj_R43R0201_rocketm_2, _0158
    WaitMovement
    GoTo _00ED
_0095:
    ApplyMovement obj_R43R0201_rocketm, _0164
    ApplyMovement obj_R43R0201_rocketm_2, _0180
    WaitMovement
    Message msg_0403_R43R0201_00000
    CheckMoney VAR_RESULT, 1000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00CA
    Message msg_0403_R43R0201_00001
    CloseMessage
    GoTo _00D5
_00CA:
    Message msg_0403_R43R0201_00002
    CloseMessage
    GoTo _00D5
_00D5:
    RemoveMoney 1000
    ApplyMovement obj_R43R0201_rocketm, _0194
    ApplyMovement obj_R43R0201_rocketm_2, _01A4
    WaitMovement
_00ED:
    StopMusic
    PlayMusic SEQ_ROAD_A_D_sseq
    SetVarFromValue VAR_HGSS_UNK_410F, 1
    End
scr_seq_R43R0201_002:
    GoToIfSet FLAG_HGSS_ROCKET_HIDEOUT_CLEARED, _0110
    SetVarFromValue VAR_HGSS_UNK_410F, 0
    End
_0110:
    End
    .balign 4, 0
_0114:
    EmoteExclamationMark
    WalkFasterSouth 3
    WalkFasterEast 2
    FaceSouth
    EndMovement
    .balign 4, 0
_0128:
    Delay8 6
    FaceSouth
    EmoteExclamationMark
    WalkFasterSouth 3
    WalkFasterWest
    FaceSouth
    EndMovement
    .balign 4, 0
_0144:
    Delay4 3
    WalkFasterWest 2
    WalkFasterNorth 3
    FaceSouth
    EndMovement
    .balign 4, 0
_0158:
    WalkFasterEast
    WalkFasterNorth 3
    EndMovement
    .balign 4, 0
_0164:
    Delay8 6
    FaceNorth
    EmoteExclamationMark
    WalkFasterNorth 4
    WalkFasterEast
    FaceNorth
    EndMovement
    .balign 4, 0
_0180:
    EmoteExclamationMark
    WalkFasterNorth 4
    WalkFasterWest 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0194:
    Delay4 3
    WalkFasterWest
    WalkFasterSouth 4
    EndMovement
    .balign 4, 0
_01A4:
    WalkFasterEast 2
    WalkFasterSouth 4
    FaceNorth
    EndMovement
scr_seq_R43R0201_000:
    NPCMessage msg_0403_R43R0201_00003
    End
scr_seq_R43R0201_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TM36_FROM_ROUTE_43_GUARD, _0208
    Message msg_0403_R43R0201_00004
    SetVar VAR_0x8004, ITEM_TM36
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0213
    Common_GiveItemQuantityNoLineFeed
    WaitButton
    SetFlag FLAG_HGSS_GOT_TM36_FROM_ROUTE_43_GUARD
_0208:
    Message msg_0403_R43R0201_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0213:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
