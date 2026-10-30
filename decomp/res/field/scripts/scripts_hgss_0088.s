#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0111.h"

#define obj_D35R0101_babyboy1_10 0
#define obj_D35R0101_stop 1
#define obj_D35R0101_stop_2 2
#define obj_D35R0101_stop_3 3
#define obj_D35R0101_gsfighter 4
#define obj_D35R0101_sunglasses 5
#define obj_D35R0101_wataru 7
#define obj_D35R0101_tsure_poke_static_dragonite 8

    ScriptEntry scr_seq_D35R0101_000
    ScriptEntry scr_seq_D35R0101_001
    ScriptEntry scr_seq_D35R0101_002
    ScriptEntry scr_seq_D35R0101_003
    ScriptEntry scr_seq_D35R0101_004
    ScriptEntry scr_seq_D35R0101_005
    ScriptEntry scr_seq_D35R0101_006
    ScriptEntry scr_seq_D35R0101_007
    ScriptEntry scr_seq_D35R0101_008
    ScriptEntry scr_seq_D35R0101_009
    ScriptEntryEnd
scr_seq_D35R0101_001:
    ShowObject obj_D35R0101_stop
    ShowObject obj_D35R0101_stop_2
    ShowObject obj_D35R0101_stop_3
    CompareVar VAR_HGSS_UNK_40AC, 9
    GoToIf 4, _00B7
    CompareVar VAR_HGSS_UNK_40A8, 2
    GoToIf 4, _006D
    CompareVar VAR_HGSS_UNK_40A8, 1
    GoToIf 1, _005F
    End
_005F:
    SetPosition obj_D35R0101_gsfighter, 8, 0, 7, DIR_WEST
    End
_006D:
    SetPosition obj_D35R0101_gsfighter, 10, 0, 7, DIR_WEST
    SetPosition obj_D35R0101_sunglasses, 4, 0, 3, DIR_SOUTH
    SetPosition obj_D35R0101_babyboy1_10, 9, 0, 3, DIR_SOUTH
    SetPosition obj_D35R0101_stop, 8, 0, 3, DIR_SOUTH
    SetPosition obj_D35R0101_stop_2, 9, 0, 4, DIR_SOUTH
    SetPosition obj_D35R0101_stop_3, 8, 0, 4, DIR_SOUTH
    End
_00B7:
    SetPosition obj_D35R0101_babyboy1_10, 9, 0, 3, DIR_SOUTH
    SetPosition obj_D35R0101_stop, 8, 0, 3, DIR_SOUTH
    SetPosition obj_D35R0101_stop_2, 9, 0, 4, DIR_SOUTH
    SetPosition obj_D35R0101_stop_3, 8, 0, 4, DIR_SOUTH
    End
scr_seq_D35R0101_008:
    CompareVar VAR_HGSS_UNK_40AC, 3
    GoToIf 1, _010F
    CompareVar VAR_HGSS_UNK_40AC, 8
    GoToIf 1, _0105
    End
_0105:
    SetFlag FLAG_HGSS_UNK_1E5
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B2F_ARIANA
    End
_010F:
    ClearFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_GIOVANNI
    SetFlag FLAG_HGSS_HIDE_ROCKET_HIDEOUT_B3F_PETREL
    End
scr_seq_D35R0101_006:
    StopMusic
    PlayMusic SEQ_GS_D_AJITO_sseq
    LockAll
    ApplyMovement LOCALID_PLAYER, _0214
    WaitMovement
    Message msg_0111_D35R0101_00004
    CloseMessage
    ApplyMovement obj_D35R0101_tsure_poke_static_dragonite, _02AC
    ApplyMovement obj_D35R0101_gsfighter, _021C
    WaitMovement
    ApplyMovement obj_D35R0101_wataru, _022C
    ApplyMovement obj_D35R0101_tsure_poke_static_dragonite, _02C0
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0111_D35R0101_00005, msg_0111_D35R0101_00006
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D35R0101_wataru, _0240
    ApplyMovement LOCALID_PLAYER, _025C
    ApplyMovement obj_D35R0101_tsure_poke_static_dragonite, _02CC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D35R0101_sunglasses, _0268
    WaitMovement
    ApplyMovement obj_D35R0101_wataru, _0280
    WaitMovement
    Message msg_0111_D35R0101_00007
    CloseMessage
    ApplyMovement obj_D35R0101_sunglasses, _0290
    WaitMovement
    PlaySE SEQ_SE_DP_UG_023_sseq
    ApplyMovement obj_D35R0101_babyboy1_10, _029C
    ApplyMovement obj_D35R0101_stop, _029C
    ApplyMovement obj_D35R0101_stop_2, _029C
    ApplyMovement obj_D35R0101_stop_3, _029C
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0111_D35R0101_00008, msg_0111_D35R0101_00009
    CloseMessage
    ApplyMovement obj_D35R0101_wataru, _02A4
    WaitMovement
    RemoveObject obj_D35R0101_wataru
    ApplyMovement obj_D35R0101_tsure_poke_static_dragonite, _02DC
    WaitMovement
    RemoveObject obj_D35R0101_tsure_poke_static_dragonite
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_SHOP_LANCE
    SetVarFromValue VAR_HGSS_UNK_40A8, 2
    ReleaseAll
    End
    .balign 4, 0
_0214:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_021C:
    LockDir
    WalkFasterEast 2
    UnlockDir
    EndMovement
    .balign 4, 0
_022C:
    Delay8 3
    FaceSouth 2
    WalkNormalSouth
    Delay8 5
    EndMovement
    .balign 4, 0
_0240:
    FaceNorth 2
    WalkNormalNorth 4
    FaceEast 2
    WalkNormalEast
    FaceNorth 2
    Delay8 5
    EndMovement
    .balign 4, 0
_025C:
    Delay8
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_0268:
    EmoteExclamationMark
    Delay8
    LockDir
    WalkFasterWest 2
    UnlockDir
    EndMovement
    .balign 4, 0
_0280:
    WalkNormalNorth
    FaceEast 2
    Delay8 2
    EndMovement
    .balign 4, 0
_0290:
    FaceEast 2
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_029C:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_02A4:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_02AC:
    WalkFasterEast 2
    LockDir
    WalkFasterWest 2
    UnlockDir
    EndMovement
    .balign 4, 0
_02C0:
    Delay8 3
    FaceSouth 2
    EndMovement
    .balign 4, 0
_02CC:
    Delay8 3
    FaceNorth 2
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_02DC:
    Delay8 3
    WalkNormalNorth 2
    FaceEast 2
    WalkNormalEast
    EndMovement
scr_seq_D35R0101_000:
    End
scr_seq_D35R0101_007:
    End
scr_seq_D35R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40A8, 2
    GoToIf 4, _031C
    Message msg_0111_D35R0101_00000
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 28
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
_031C:
    Message msg_0111_D35R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D35R0101_003:
    CompareVar VAR_HGSS_UNK_40A8, 2
    GoToIf 4, _0347
    NPCMessage msg_0111_D35R0101_00002
    End
_0347:
    NPCMessage msg_0111_D35R0101_00003
    End
scr_seq_D35R0101_005:
    End
scr_seq_D35R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetFlag FLAG_HGSS_SPECIAL_MART_MAHOGANY_GOOD
    Message msg_0111_D35R0101_00010
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 29
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ClearFlag FLAG_HGSS_SPECIAL_MART_MAHOGANY_GOOD
    ReleaseAll
    End
scr_seq_D35R0101_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40AC, 10
    GoToIf 4, _039D
    Message msg_0111_D35R0101_00015
    GoTo _0552
_039D:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 5, _03B3
    Message msg_0111_D35R0101_00014
    GoTo _03E5
_03B3:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _03C9
    Message msg_0111_D35R0101_00014
    GoTo _03E5
_03C9:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _03DF
    Message msg_0111_D35R0101_00014
    GoTo _03E5
_03DF:
    GoTo _03EB
_03E5:
    GoTo _0552
_03EB:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0405
    Message msg_0111_D35R0101_00011
    GoTo _0552
_0405:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _041B
    Message msg_0111_D35R0101_00012
    GoTo _0552
_041B:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0431
    Message msg_0111_D35R0101_00011
    GoTo _0552
_0431:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0447
    Message msg_0111_D35R0101_00012
    GoTo _0552
_0447:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _045D
    Message msg_0111_D35R0101_00011
    GoTo _0552
_045D:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0473
    Message msg_0111_D35R0101_00012
    GoTo _0552
_0473:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _0489
    Message msg_0111_D35R0101_00011
    GoTo _0552
_0489:
    CompareVar VAR_MAP_LOCAL_0x00, 10
    GoToIf 5, _049F
    Message msg_0111_D35R0101_00012
    GoTo _0552
_049F:
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _04B5
    Message msg_0111_D35R0101_00011
    GoTo _0552
_04B5:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _04CB
    Message msg_0111_D35R0101_00012
    GoTo _0552
_04CB:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _04E1
    Message msg_0111_D35R0101_00011
    GoTo _0552
_04E1:
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _04F7
    Message msg_0111_D35R0101_00012
    GoTo _0552
_04F7:
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _050D
    Message msg_0111_D35R0101_00011
    GoTo _0552
_050D:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _0523
    Message msg_0111_D35R0101_00012
    GoTo _0552
_0523:
    CompareVar VAR_MAP_LOCAL_0x00, 21
    GoToIf 5, _0539
    Message msg_0111_D35R0101_00011
    GoTo _0552
_0539:
    CompareVar VAR_MAP_LOCAL_0x00, 22
    GoToIf 5, _054F
    Message msg_0111_D35R0101_00012
    GoTo _0552
_054F:
    Message msg_0111_D35R0101_00013
_0552:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
