#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0541.h"

#define obj_T11R0802_gsgirl1 0
#define obj_T11R0802_mono_pip 1
#define obj_T11R0802_jupetta 2
#define obj_T11R0802_var_1 3

    ScriptEntry scr_seq_T11R0802_000
    ScriptEntry scr_seq_T11R0802_001
    ScriptEntry scr_seq_T11R0802_002
    ScriptEntry scr_seq_T11R0802_003
    ScriptEntry scr_seq_T11R0802_004
    ScriptEntry scr_seq_T11R0802_005
    ScriptEntry scr_seq_T11R0802_006
    ScriptEntryEnd
scr_seq_T11R0802_004:
    GetPlayerGender VAR_MAP_LOCAL_0x09
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 5, _003B
    SetVarFromValue VAR_OBJ_GFX_ID_0, 0
    GoTo _0041
_003B:
    SetVarFromValue VAR_OBJ_GFX_ID_0, 97
_0041:
    End
scr_seq_T11R0802_005:
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _005A
    RemoveObject obj_T11R0802_var_1
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 1
_005A:
    End
scr_seq_T11R0802_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_PASS, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0125
    GetItemQuantity ITEM_LOST_ITEM, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00E9
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _00BD
    Call _014D
    BufferPlayerName 0
    MessageGendered msg_0541_T11R0802_00000, msg_0541_T11R0802_00001
    CloseMessage
    Call _01DB
    Message msg_0541_T11R0802_00002
    CloseMessage
    ApplyMovement obj_T11R0802_gsgirl1, _026C
    WaitMovement
    ReleaseAll
    End
_00BD:
    SetFlag FLAG_HGSS_UNK_119
    Call _014D
    BufferPlayerName 0
    MessageGendered msg_0541_T11R0802_00003, msg_0541_T11R0802_00004
    CloseMessage
    Call _01DB
    Message msg_0541_T11R0802_00005
    CloseMessage
    ApplyMovement obj_T11R0802_gsgirl1, _026C
    WaitMovement
    ReleaseAll
    End
_00E9:
    RemoveItem ITEM_LOST_ITEM, 1, VAR_RESULT
    Message msg_0541_T11R0802_00006
    ClearFlag FLAG_HGSS_HIDE_SAFFRON_CITY_COPYCAT_HOUSE_CLEFAIRY_DOLL
    AddObject obj_T11R0802_mono_pip
    SetVar VAR_0x8004, ITEM_PASS
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0541_T11R0802_00008
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_087
    SetFlag FLAG_HGSS_UNK_998
    SetVarFromValue VAR_HGSS_UNK_40FF, 2
    End
_0125:
    Call _014D
    BufferPlayerName 0
    MessageGendered msg_0541_T11R0802_00009, msg_0541_T11R0802_00010
    CloseMessage
    Call _01DB
    Message msg_0541_T11R0802_00011
    CloseMessage
    ApplyMovement obj_T11R0802_gsgirl1, _026C
    WaitMovement
    ReleaseAll
    End
_014D:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _016C
    ApplyMovement obj_T11R0802_gsgirl1, _02B0
    GoTo _018F
_016C:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0187
    ApplyMovement obj_T11R0802_gsgirl1, _0274
    GoTo _018F
_0187:
    ApplyMovement obj_T11R0802_gsgirl1, _0294
_018F:
    WaitMovement
    AddObject obj_T11R0802_var_1
    RemoveObject obj_T11R0802_gsgirl1
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01B4
    ApplyMovement obj_T11R0802_var_1, _0304
    GoTo _01D7
_01B4:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01CF
    ApplyMovement obj_T11R0802_var_1, _02C8
    GoTo _01D7
_01CF:
    ApplyMovement obj_T11R0802_var_1, _02EC
_01D7:
    WaitMovement
    Return
_01DB:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01FA
    ApplyMovement obj_T11R0802_var_1, _02B0
    GoTo _021D
_01FA:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0215
    ApplyMovement obj_T11R0802_var_1, _0274
    GoTo _021D
_0215:
    ApplyMovement obj_T11R0802_var_1, _0294
_021D:
    WaitMovement
    AddObject obj_T11R0802_gsgirl1
    RemoveObject obj_T11R0802_var_1
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0242
    ApplyMovement obj_T11R0802_gsgirl1, _0304
    GoTo _0265
_0242:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _025D
    ApplyMovement obj_T11R0802_gsgirl1, _02C8
    GoTo _0265
_025D:
    ApplyMovement obj_T11R0802_gsgirl1, _02EC
_0265:
    WaitMovement
    Return
    .balign 4, 0
_026C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0274:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
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
_02EC:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    EndMovement
    .balign 4, 0
_0304:
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
scr_seq_T11R0802_003:
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _03A3
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0541_T11R0802_00012
    WaitButton
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0359
    ApplyMovement obj_T11R0802_jupetta, _03C8
    GoTo _0397
_0359:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0374
    ApplyMovement obj_T11R0802_jupetta, _03C0
    GoTo _0397
_0374:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _038F
    ApplyMovement obj_T11R0802_jupetta, _03D8
    GoTo _0397
_038F:
    ApplyMovement obj_T11R0802_jupetta, _03D0
_0397:
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    ReleaseAll
    End
_03A3:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BANETTE, 0
    Message msg_0541_T11R0802_00013
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_03C0:
    FaceNorth
    EndMovement
    .balign 4, 0
_03C8:
    FaceSouth
    EndMovement
    .balign 4, 0
_03D0:
    FaceWest
    EndMovement
    .balign 4, 0
_03D8:
    FaceEast
    EndMovement
scr_seq_T11R0802_001:
    NPCMessage msg_0541_T11R0802_00015
    End
scr_seq_T11R0802_002:
    NPCMessage msg_0541_T11R0802_00014
    End
scr_seq_T11R0802_006:
    GoToIfSet FLAG_HGSS_HIDE_SAFFRON_CITY_COPYCAT_HOUSE_CLEFAIRY_DOLL, _0431
    CompareVar VAR_HGSS_UNK_40FF, 2
    GoToIf 1, _0433
    NPCMessage msg_0541_T11R0802_00016
    End
_0431:
    End
_0433:
    NPCMessage msg_0541_T11R0802_00017
    End
    .balign 4, 0
