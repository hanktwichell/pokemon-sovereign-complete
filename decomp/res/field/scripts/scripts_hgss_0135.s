#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0150.h"

#define obj_D52R0103_tsure_poke_static_rayquaza 0

    ScriptEntry scr_seq_D52R0103_000
    ScriptEntry scr_seq_D52R0103_001
    ScriptEntry scr_seq_D52R0103_002
    ScriptEntry scr_seq_D52R0103_003
    ScriptEntryEnd
scr_seq_D52R0103_002:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _0119
    End
scr_seq_D52R0103_003:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 7
    GoToIf 4, _0123
    ClearFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_RAYQUAZA
    End
scr_seq_D52R0103_001:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _014A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlayCry SPECIES_RAYQUAZA, 0
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _014A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseObject obj_D52R0103_tsure_poke_static_rayquaza
    CompleteObjectSway obj_D52R0103_tsure_poke_static_rayquaza, 8, 90, 3, 0
    PlayCry SPECIES_RAYQUAZA, 0
    Message msg_0150_D52R0103_00000
    WaitCry
    LockObject obj_D52R0103_tsure_poke_static_rayquaza
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 6
    ReleaseAll
    End
scr_seq_D52R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ReleaseObject obj_D52R0103_tsure_poke_static_rayquaza
    CompleteObjectSway obj_D52R0103_tsure_poke_static_rayquaza, 8, 90, 3, 0
    PlayCry SPECIES_RAYQUAZA, 0
    Message msg_0150_D52R0103_00000
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_RAYQUAZA, 75, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0125
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _012B
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 1, _013C
    Message msg_0150_D52R0103_00001
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 9
    ReleaseAll
    End
_0119:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_RAYQUAZA
    RemoveObject obj_D52R0103_tsure_poke_static_rayquaza
    End
_0123:
    End
_0125:
    BlackOutFromBattle
    ReleaseAll
    End
_012B:
    Message msg_0150_D52R0103_00001
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 9
    ReleaseAll
    End
_013C:
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 7
    SetFlag FLAG_HGSS_CAUGHT_RAYQUAZA
    ReleaseAll
    End
    .balign 4, 0
_014A:
    WalkNormalNorth 8
    Delay8 2
    EndMovement
    .balign 4, 0
