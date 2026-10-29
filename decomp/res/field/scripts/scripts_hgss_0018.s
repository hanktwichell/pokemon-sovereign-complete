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
    GoToIfSet FLAG_HGSS_UNK_078, _001F
    End
_001F:
    SetFlag FLAG_HGSS_UNK_1A3
    End
scr_seq_D15R0103_001:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40A4, 1
    ApplyMovement LOCALID_PLAYER, _00B4
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    @ HGSS: ScrCmd_102 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    ApplyMovement 241, _00C0
    WaitMovement
    ApplyMovement obj_D15R0103_chourou, _00D0
    WaitMovement
    Message msg_0056_D15R0103_00000
    CloseMessage
    WaitTime 15, VAR_RESULT
    Common_SetRivalBGM
    BufferRivalName 0
    ApplyMovement obj_D15R0103_gsrivel, _00D8
    WaitMovement
    Message msg_0056_D15R0103_00001
    CloseMessage
    WaitTime 15, VAR_RESULT
    BufferRivalName 0
    Message msg_0056_D15R0103_00002
    WaitABPress
    CloseMessage
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_D15R0103_gsrivel, _00E0
    WaitMovement
    RemoveObject obj_D15R0103_gsrivel
    SetFlag FLAG_HGSS_UNK_078
    Common_FadeToDefaultMusic2
    ApplyMovement 241, _00C8
    WaitMovement
    @ HGSS: ScrCmd_103
    ReleaseAll
    End
    .balign 4, 0
_00B4:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_00C0:
    WalkNormalNorth 5
    EndMovement
    .balign 4, 0
_00C8:
    WalkNormalSouth 5
    EndMovement
    .balign 4, 0
_00D0:
    WalkOnSpotNormalSouth 2
    EndMovement
    .balign 4, 0
_00D8:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_00E0:
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
scr_seq_D15R0103_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_076, _0197
    Message msg_0056_D15R0103_00003
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_ELDER_LI, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A2
    Message msg_0056_D15R0103_00004
    SetVar VAR_0x8004, ITEM_TM70
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_076
    SetFlag FLAG_HGSS_HIDE_VIOLET_GYM_GYM_GUY_AFTER_SPROUT
    ClearFlag FLAG_HGSS_HIDE_VIOLET_GYM_GYM_GUY_BEFORE_SPROUT
    Message msg_0056_D15R0103_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0197:
    Message msg_0056_D15R0103_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A2:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
