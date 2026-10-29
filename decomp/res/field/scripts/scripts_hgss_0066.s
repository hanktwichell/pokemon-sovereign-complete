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
    ScriptEntryEnd
scr_seq_D27R0107_003:
    SetVarFromValue VAR_HGSS_UNK_4125, 0
    End
scr_seq_D27R0107_004:
    GoToIfSet FLAG_HGSS_UNK_1D8, _002D
    ShowObject obj_D27R0107_stop
_002D:
    End
scr_seq_D27R0107_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_SECRETPOTION, _00B5
    CompareVar VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 0
    GoToIf 1, _0062
    Message msg_0094_D27R0107_00001
    CloseMessage
    ApplyMovement obj_D27R0107_gsleader6, _01B0
    WaitMovement
    ReleaseAll
    End
_0062:
    Message msg_0094_D27R0107_00000
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _01D0
    ApplyMovement obj_D27R0107_gsleader6, _01B8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_DOOR_sseq
    RemoveObject obj_D27R0107_stop
    RemoveObject obj_D27R0107_babyboy1_8
    WaitSE SEQ_SE_DP_DOOR_sseq
    ApplyMovement obj_D27R0107_gsleader6, _01F0
    WaitMovement
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 1
    SetFlag FLAG_HGSS_UNK_1D8
    End
_00B5:
    Message msg_0094_D27R0107_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _017F
    RemoveItem ITEM_SECRETPOTION, 1, VAR_RESULT
    BufferPlayerName 0
    Message msg_0094_D27R0107_00003
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0094_D27R0107_00004
    CloseMessage
    ApplyMovement obj_D27R0107_gsleader6, _01B0
    WaitMovement
    Message msg_0094_D27R0107_00005
    CloseMessage
    ApplyMovement obj_D27R0107_tsure_poke_static_ampharos, _01A0
    WaitMovement
    PlayCry SPECIES_AMPHAROS, 0
    Message msg_0094_D27R0107_00006
    WaitCry
    CloseMessage
    @ HGSS: ScrCmd_459
    ApplyMovement obj_D27R0107_tsure_poke_static_ampharos, _01A8
    WaitMovement
    PlayCry SPECIES_AMPHAROS, 0
    WaitCry
    Message msg_0094_D27R0107_00007
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0218
    ApplyMovement obj_D27R0107_gsleader6, _0200
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    RemoveObject obj_D27R0107_gsleader6
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_96A
    SetVarFromValue VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 2
    SetVarFromValue VAR_HGSS_UNK_410E, 1
    SetFlag FLAG_HGSS_UNK_1D7
    ClearFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    SetFlag FLAG_HGSS_UNK_1DA
    SetFlag FLAG_HGSS_UNK_1DB
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_GYM_GENTLEMAN
    ClearFlag FLAG_HGSS_HIDE_OLIVINE_GYM_GIRL
    SetFlag FLAG_HGSS_UNK_998
    End
_017F:
    Message msg_0094_D27R0107_00008
    CloseMessage
    ApplyMovement obj_D27R0107_gsleader6, _01B0
    WaitMovement
    Message msg_0094_D27R0107_00009
    CloseMessage
    PlayCry SPECIES_AMPHAROS, 12
    WaitCry
    ReleaseAll
    End
    .balign 4, 0
_01A0:
    WalkOnSpotSlowWest
    EndMovement
    .balign 4, 0
_01A8:
    JumpOnSpotFastWest 3
    EndMovement
    .balign 4, 0
_01B0:
    WalkOnSpotSlowEast
    EndMovement
    .balign 4, 0
_01B8:
    Delay8
    WalkNormalSouth 3
    WalkNormalEast
    WalkOnSpotNormalSouth
    Delay16
    EndMovement
    .balign 4, 0
_01D0:
    FaceWest
    LockDir
    WalkNormalEast
    UnlockDir
    Delay8 3
    Delay4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01F0:
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0200:
    Delay8
    WalkNormalSouth
    WalkNormalEast 2
    WalkOnSpotNormalSouth
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0218:
    FaceNorth
    LockDir
    WalkNormalSouth
    UnlockDir
    Delay8 2
    Delay4
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0238:
    WalkSlowWest 2
    EndMovement
scr_seq_D27R0107_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 2
    GoToIf 0, _0266
    PlayCry SPECIES_AMPHAROS, 0
    Message msg_0094_D27R0107_00012
    WaitCry
    GoTo _0274
_0266:
    PlayCry SPECIES_AMPHAROS, 12
    Message msg_0094_D27R0107_00010
    WaitCry
    Message msg_0094_D27R0107_00011
_0274:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D27R0107_002:
    End
    .balign 4, 0
