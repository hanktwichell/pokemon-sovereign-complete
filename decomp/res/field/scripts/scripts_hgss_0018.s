#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0056.h"

#define obj_D15R0103_chourou 3
#define obj_D15R0103_gsrivel 6

    ScriptEntry scr_seq_D15R0103_000
    ScriptEntry scr_seq_D15R0103_001
    ScriptEntry scr_seq_D15R0103_002
    ScriptEntryEnd
scr_seq_D15R0103_000:
    ClearFlag FLAG_HGSS_UNK_1A3
    GoToIfSet FLAG_HGSS_UNK_078, _01A7
    End
scr_seq_D15R0103_001:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40A4, 1
    ApplyMovement LOCALID_PLAYER, _0360
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _036A
    WaitMovement
    ApplyMovement obj_D15R0103_chourou, _0370
    WaitMovement
    Message msg_0056_D15R0103_00000
    CloseMessage
    WaitTime 15, VAR_RESULT
    StopMusic
    SetBGM SEQ_GS_E_RIVAL2_sseq
    CompleteBufferHGSSRivalName 0
    ApplyMovement obj_D15R0103_gsrivel, _0376
    WaitMovement
    Message msg_0056_D15R0103_00001
    CloseMessage
    WaitTime 15, VAR_RESULT
    CompleteBufferHGSSRivalName 0
    Message msg_0056_D15R0103_00002
    WaitABPress
    CloseMessage
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_D15R0103_gsrivel, _037C
    WaitMovement
    RemoveObject obj_D15R0103_gsrivel
    SetFlag FLAG_HGSS_UNK_078
    Common_FadeToDefaultMusic2
    ApplyMovement 241, _03D6
    WaitMovement
    RestoreCamera
    ReleaseAll
    End
scr_seq_D15R0103_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag 118
    BufferPlayerName 0
    GoToIf 1, _01AD
    Message msg_0056_D15R0103_00003
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_ELDER_LI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01B8
    Message msg_0056_D15R0103_00004
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 9, 0
    AddMenuEntry 10, 1
    AddMenuEntry 11, 2
    AddMenuEntry 12, 3
    AddMenuEntry 13, 4
    AddMenuEntry 14, 5
    AddMenuEntry 15, 6
    AddMenuEntry 17, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _01BE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _01D7
    CompareVar VAR_0x8008, 2
    GoToIf 1, _01F0
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0209
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0222
    CompareVar VAR_0x8008, 5
    GoToIf 1, _023B
    CompareVar VAR_0x8008, 6
    GoToIf 1, _0254
    CompareVar VAR_0x8008, 7
    GoToIf 1, _026D
    GoTo _026D
_01A7:
    SetFlag FLAG_HGSS_UNK_1A3
    End
_01AD:
    Message msg_0056_D15R0103_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01B8:
    BlackOutFromBattle
    ReleaseAll
    End
_01BE:
    Message msg_0056_D15R0103_00016
    SetVar VAR_0x8004, ITEM_WATER_STONE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GoTo _0276
_01D7:
    Message msg_0056_D15R0103_00016
    SetVar VAR_0x8004, ITEM_THUNDERSTONE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GoTo _0276
_01F0:
    Message msg_0056_D15R0103_00016
    SetVar VAR_0x8004, ITEM_FIRE_STONE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GoTo _0276
_0209:
    Message msg_0056_D15R0103_00016
    SetVar VAR_0x8004, ITEM_AUBADE_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GoTo _0276
_0222:
    Message msg_0056_D15R0103_00016
    SetVar VAR_0x8004, ITEM_SERENADE_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GoTo _0276
_023B:
    Message msg_0056_D15R0103_00016
    SetVar VAR_0x8004, ITEM_WOODLAND_ORE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GoTo _0276
_0254:
    Message msg_0056_D15R0103_00016
    SetVar VAR_0x8004, ITEM_CHILLED_ORE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GoTo _0276
_026D:
    Message msg_0056_D15R0103_00018
    GoTo _02A2
_0276:
    SetFlag FLAG_HGSS_UNK_076
    SetFlag FLAG_HGSS_HIDE_VIOLET_GYM_GYM_GUY_AFTER_SPROUT
    ClearFlag FLAG_HGSS_HIDE_VIOLET_GYM_GYM_GUY_BEFORE_SPROUT
    Message msg_0056_D15R0103_00019
    SetVar VAR_0x8004, ITEM_TM70
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0056_D15R0103_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02A2:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 9, 0
    AddMenuEntry 10, 1
    AddMenuEntry 11, 2
    AddMenuEntry 12, 3
    AddMenuEntry 13, 4
    AddMenuEntry 14, 5
    AddMenuEntry 15, 6
    AddMenuEntry 17, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _01BE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _01D7
    CompareVar VAR_0x8008, 2
    GoToIf 1, _01F0
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0209
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0222
    CompareVar VAR_0x8008, 5
    GoToIf 1, _023B
    CompareVar VAR_0x8008, 6
    GoToIf 1, _0254
    CompareVar VAR_0x8008, 7
    GoToIf 1, _026D
    ReleaseAll
    End
    .balign 4, 0
_0360:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_036A:
    WalkNormalNorth 5
    EndMovement
    .balign 4, 0
_0370:
    WalkOnSpotNormalSouth 2
    EndMovement
    .balign 4, 0
_0376:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_037C:
    FaceWest 4
    FaceNorth 4
    FaceEast 4
    FaceSouth 4
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest
    FaceNorth
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
_03D6:
    WalkNormalSouth 5
    EndMovement
    .balign 4, 0
