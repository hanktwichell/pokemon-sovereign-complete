#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0143.h"

#define obj_D49R0107_thlonowner 0
#define obj_D49R0107_statuehero 1
#define obj_D49R0107_statueheroine 2

    ScriptEntry scr_seq_D49R0107_000
    ScriptEntry scr_seq_D49R0107_001
    ScriptEntry scr_seq_D49R0107_002
    ScriptEntry scr_seq_D49R0107_003
    ScriptEntry scr_seq_D49R0107_004
    ScriptEntry scr_seq_D49R0107_005
    ScriptEntry scr_seq_D49R0107_006
    ScriptEntry scr_seq_D49R0107_007
    ScriptEntryEnd
scr_seq_D49R0107_007:
    CompareVar VAR_HGSS_UNK_40D3, 1
    GoToIf 5, _003B
    SetVarFromValue VAR_MAP_LOCAL_0x0E, 1
    GoTo _0041
_003B:
    SetVarFromValue VAR_MAP_LOCAL_0x0E, 0
_0041:
    End
scr_seq_D49R0107_006:
    CompareVar VAR_MAP_LOCAL_0x0F, 0
    GoToIf 5, _0058
    @ HGSS: CreatePokeathlonFriendshipRoomStatues
    SetVarFromValue VAR_MAP_LOCAL_0x0F, 1
_0058:
    GetPlayerGender VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _007B
    SetPosition obj_D49R0107_statueheroine, 28, 0, 28, DIR_NORTH
    GoTo _0087
_007B:
    SetPosition obj_D49R0107_statuehero, 28, 0, 28, DIR_NORTH
_0087:
    CompareVar VAR_MAP_LOCAL_0x0E, 1
    GoToIf 5, _00A6
    SetPosition obj_D49R0107_thlonowner, 9, 0, 9, DIR_SOUTH
    SetVarFromValue VAR_MAP_LOCAL_0x0E, 0
_00A6:
    End
scr_seq_D49R0107_005:
    LockAll
    ApplyMovement obj_D49R0107_thlonowner, _015C
    WaitMovement
    Message msg_0143_D49R0107_00000
    CloseMessage
    ApplyMovement obj_D49R0107_thlonowner, _0164
    WaitMovement
    WaitTime 15, VAR_RESULT
    BufferPlayerName 0
    Message msg_0143_D49R0107_00001
    CloseMessage
    ApplyMovement obj_D49R0107_thlonowner, _016C
    WaitMovement
    Message msg_0143_D49R0107_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D49R0107_thlonowner, _0174
    ApplyMovement LOCALID_PLAYER, _0180
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    Message msg_0143_D49R0107_00003
    CloseMessage
    ApplyMovement obj_D49R0107_thlonowner, _0188
    WaitMovement
    Message msg_0143_D49R0107_00004
    CloseMessage
    ApplyMovement obj_D49R0107_thlonowner, _0164
    WaitMovement
    Message msg_0143_D49R0107_00005
    CloseMessage
    ApplyMovement obj_D49R0107_thlonowner, _0190
    WaitMovement
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40D3, 1
    GetSetNationalDexEnabled 2, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    CallIf 1, _0154
    End
_0154:
    ClearFlag FLAG_HGSS_HIDE_POKEATHLON_SUPREME_CUP_RECEPTIONIST
    Return
    .balign 4, 0
_015C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0164:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_016C:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0174:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0180:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_0188:
    WalkSlowNorth
    EndMovement
    .balign 4, 0
_0190:
    WalkOnSpotNormalWest
    LockDir
    WalkSlowEast 2
    UnlockDir
    EndMovement
scr_seq_D49R0107_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0143_D49R0107_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0107_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0143_D49R0107_00007
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_712 3
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D49R0107_002:
    NPCMessage msg_0143_D49R0107_00008
    End
scr_seq_D49R0107_003:
    NPCMessage msg_0143_D49R0107_00008
    End
scr_seq_D49R0107_004:
    NPCMessage msg_0143_D49R0107_00008
    End
    .balign 4, 0
