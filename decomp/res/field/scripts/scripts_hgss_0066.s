#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0094.h"

#define obj_D27R0107_babyboy1_8 0
#define obj_D27R0107_gsleader6 1
#define obj_D27R0107_tsure_poke_static_ampharos 2
#define obj_D27R0107_stop 4

    ScriptEntry scr_seq_D27R0107_000
    ScriptEntry scr_seq_D27R0107_001
    ScriptEntry scr_seq_D27R0107_002
    ScriptEntry scr_seq_D27R0107_003
    ScriptEntry scr_seq_D27R0107_004
    ScriptEntry scr_seq_D27R0107_005
    ScriptEntryEnd
scr_seq_D27R0107_003:
    SetVarFromValue VAR_HGSS_UNK_4125, 0
    End
scr_seq_D27R0107_004:
    GoToIfSet FLAG_HGSS_UNK_1D8, _0093
    ShowObject obj_D27R0107_stop
    End
scr_seq_D27R0107_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_SECRETPOTION, _0095
    CompareVar VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 0
    GoToIf 1, _0169
    Message msg_0094_D27R0107_00001
    CloseMessage
    ApplyMovement obj_D27R0107_gsleader6, _01FA
    WaitMovement
    ReleaseAll
    End
scr_seq_D27R0107_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 2
    GoToIf 0, _01BC
    PlayCry SPECIES_AMPHAROS, 0
    Message msg_0094_D27R0107_00012
    WaitCry
    GoTo _01D2
scr_seq_D27R0107_002:
    End
scr_seq_D27R0107_005:
    BufferPlayerName 0
    End
_0093:
    End
_0095:
    Message msg_0094_D27R0107_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01DA
    RemoveItem ITEM_SECRETPOTION, 1, VAR_RESULT
    BufferPlayerName 0
    Message msg_0094_D27R0107_00003
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0094_D27R0107_00004
    CloseMessage
    ApplyMovement obj_D27R0107_gsleader6, _01FA
    WaitMovement
    Message msg_0094_D27R0107_00005
    CloseMessage
    ApplyMovement obj_D27R0107_tsure_poke_static_ampharos, _0200
    WaitMovement
    PlayCry SPECIES_AMPHAROS, 0
    Message msg_0094_D27R0107_00006
    WaitCry
    CloseMessage
    @ HGSS: ScrCmd_459
    ApplyMovement obj_D27R0107_tsure_poke_static_ampharos, _0206
    WaitMovement
    PlayCry SPECIES_AMPHAROS, 0
    WaitCry
    Message msg_0094_D27R0107_00007
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _020C
    ApplyMovement obj_D27R0107_gsleader6, _022A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    RemoveObject obj_D27R0107_gsleader6
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_96A
    SetVarFromValue VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 2
    SetVarFromValue VAR_HGSS_UNK_410E, 1
    SetVarFromValue VAR_HGSS_SG_612E, 2
    SetFlag FLAG_HGSS_UNK_1D7
    ClearFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    SetFlag FLAG_HGSS_UNK_1DA
    SetFlag FLAG_HGSS_UNK_1DB
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_GYM_GENTLEMAN
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_GYM_GIRL
    ClearFlag FLAG_HGSS_SG_3FE8
    SetFlag FLAG_HGSS_UNK_998
    End
_0169:
    Message msg_0094_D27R0107_00000
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0240
    ApplyMovement obj_D27R0107_gsleader6, _025E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_DOOR_sseq
    RemoveObject obj_D27R0107_stop
    RemoveObject obj_D27R0107_babyboy1_8
    WaitSE SEQ_SE_DP_DOOR_sseq
    ApplyMovement obj_D27R0107_gsleader6, _0274
    WaitMovement
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 1
    SetFlag FLAG_HGSS_UNK_1D8
    End
_01BC:
    PlayCry SPECIES_AMPHAROS, 12
    Message msg_0094_D27R0107_00010
    WaitCry
    Message msg_0094_D27R0107_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01D2:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DA:
    Message msg_0094_D27R0107_00008
    CloseMessage
    ApplyMovement obj_D27R0107_gsleader6, _01FA
    WaitMovement
    Message msg_0094_D27R0107_00009
    CloseMessage
    PlayCry SPECIES_AMPHAROS, 12
    WaitCry
    ReleaseAll
    End
    .balign 4, 0
_01FA:
    WalkOnSpotSlowEast
    EndMovement
    .balign 4, 0
_0200:
    WalkOnSpotSlowWest
    EndMovement
    .balign 4, 0
_0206:
    JumpOnSpotFastWest 3
    EndMovement
    .balign 4, 0
_020C:
    FaceNorth
    LockDir
    WalkNormalSouth
    UnlockDir
    Delay8 2
    Delay4
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_022A:
    Delay8
    WalkNormalSouth
    WalkNormalEast 2
    WalkOnSpotNormalSouth
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0240:
    FaceWest
    LockDir
    WalkNormalEast
    UnlockDir
    Delay8 3
    Delay4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_025E:
    Delay8
    WalkNormalSouth 3
    WalkNormalEast
    WalkOnSpotNormalSouth
    Delay16
    EndMovement
    .balign 4, 0
_0274:
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
