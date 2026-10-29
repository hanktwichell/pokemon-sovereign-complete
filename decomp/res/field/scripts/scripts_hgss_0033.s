#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0069.h"

#define obj_D23R0105_gsgentleman 0
#define obj_D23R0105_rkanbum2 2

    ScriptEntry scr_seq_D23R0105_000
    ScriptEntry scr_seq_D23R0105_001
    ScriptEntry scr_seq_D23R0105_002
    ScriptEntry scr_seq_D23R0105_003
    ScriptEntryEnd
scr_seq_D23R0105_000:
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    SetVarFromValue VAR_HGSS_UNK_4125, 0
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _002D
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
_002D:
    End
scr_seq_D23R0105_001:
    NPCMessage msg_0069_D23R0105_00007
    End
scr_seq_D23R0105_003:
    NPCMessage msg_0069_D23R0105_00008
    End
scr_seq_D23R0105_002:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 1, _0075
    NPCMessage msg_0069_D23R0105_00006
    End
_0075:
    GetItemQuantity ITEM_BASEMENT_KEY, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _022B
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0069_D23R0105_00000
    CloseMessage
    WaitTime 16, VAR_RESULT
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _00B8
    ApplyMovement obj_D23R0105_gsgentleman, _0258
    GoTo _00DB
_00B8:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00D3
    ApplyMovement obj_D23R0105_gsgentleman, _024C
    GoTo _00DB
_00D3:
    ApplyMovement obj_D23R0105_gsgentleman, _0240
_00DB:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _00F8
    ApplyMovement obj_D23R0105_gsgentleman, _0264
    GoTo _010D
_00F8:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _010D
    ApplyMovement obj_D23R0105_gsgentleman, _0274
_010D:
    WaitMovement
    Message msg_0069_D23R0105_00001
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _012F
    ApplyMovement obj_D23R0105_gsgentleman, _0284
    GoTo _0144
_012F:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0144
    ApplyMovement obj_D23R0105_gsgentleman, _028C
_0144:
    WaitMovement
    BufferPlayerName 0
    Message msg_0069_D23R0105_00002
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0167
    ApplyMovement obj_D23R0105_gsgentleman, _02B0
    GoTo _018A
_0167:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0182
    ApplyMovement obj_D23R0105_gsgentleman, _0294
    GoTo _018A
_0182:
    ApplyMovement obj_D23R0105_gsgentleman, _02C8
_018A:
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_RADIO_TOWER_5F_OFFICE_DIRECTOR
    ClearFlag FLAG_HGSS_HIDE_RADIO_TOWER_5F_PETREL_REVEALED
    AddObject obj_D23R0105_rkanbum2
    RemoveObject obj_D23R0105_gsgentleman
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _01B7
    ApplyMovement obj_D23R0105_rkanbum2, _0328
    GoTo _01DA
_01B7:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _01D2
    ApplyMovement obj_D23R0105_rkanbum2, _0310
    GoTo _01DA
_01D2:
    ApplyMovement obj_D23R0105_rkanbum2, _0344
_01DA:
    WaitMovement
    Message msg_0069_D23R0105_00003
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_EXECUTIVE_PETREL_PETREL, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _021D
    Message msg_0069_D23R0105_00004
    SetVarFromValue VAR_0x8004, ITEM_BASEMENT_KEY
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40E7, 2
    ClearFlag FLAG_HGSS_HIDE_UNDERGROUND_KIMONO_GIRL
    End
_021D:
    BlackOutFromBattle
    ClearFlag FLAG_HGSS_HIDE_RADIO_TOWER_5F_OFFICE_DIRECTOR
    SetFlag FLAG_HGSS_HIDE_RADIO_TOWER_5F_PETREL_REVEALED
    ReleaseAll
    End
_022B:
    NPCMessage msg_0069_D23R0105_00005
    End
    .balign 4, 0
_0240:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_024C:
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0258:
    FaceSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0264:
    LockDir
    WalkFastEast
    UnlockDir
    EndMovement
    .balign 4, 0
_0274:
    LockDir
    WalkFastWest
    UnlockDir
    EndMovement
    .balign 4, 0
_0284:
    WalkFastWest
    EndMovement
    .balign 4, 0
_028C:
    WalkFastEast
    EndMovement
    .balign 4, 0
_0294:
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_02B0:
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
_02C8:
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    EndMovement
    .balign 4, 0
_0310:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    EndMovement
    .balign 4, 0
_0328:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0344:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    EndMovement
    .balign 4, 0
