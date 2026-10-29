#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0148.h"

#define obj_D52R0101_tsure_poke_static_groudon 0
#define obj_D52R0101_mount_2 1

    ScriptEntry scr_seq_D52R0101_000
    ScriptEntry scr_seq_D52R0101_001
    ScriptEntry scr_seq_D52R0101_002
    ScriptEntryEnd
scr_seq_D52R0101_001:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 4
    GoToIf 4, _007C
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0038
    GoTo _0040
_0032:
    GoTo _003E
_0038:
    GoTo _004A
_003E:
    End
_0040:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON_HIKER
    End
_004A:
    GoToIfSet FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE, _007C
    CheckItem ITEM_RED_ORB, 1, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 4, _0072
    GoTo _0040
    End
_0072:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON_HIKER
    ClearFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON
    End
_007C:
    End
scr_seq_D52R0101_002:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _008B
    End
_008B:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON
    RemoveObject obj_D52R0101_tsure_poke_static_groudon
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_D52R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_GROUDON, 0
    Message msg_0148_D52R0101_00000
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_GROUDON, 50, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _019D
    @ HGSS: GetStaticEncounterOutcome VAR_TEMP_x4002
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _00EC
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 1, _00FB
_00EC:
    Message msg_0148_D52R0101_00001
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE
    ReleaseAll
    End
_00FB:
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 4
    SetFlag FLAG_HGSS_CAUGHT_GROUDON
    ClearFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON_HIKER
    AddObject obj_D52R0101_mount_2
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0142
    ApplyMovement obj_D52R0101_mount_2, _01A4
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _01B0
    WaitMovement
    GoTo _0156
_0142:
    ApplyMovement obj_D52R0101_mount_2, _01BC
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _01C8
    WaitMovement
_0156:
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0148_D52R0101_00002
    CloseMessage
    ApplyMovement obj_D52R0101_mount_2, _01D0
    WaitMovement
    Message msg_0148_D52R0101_00003
    CloseMessage
    ApplyMovement obj_D52R0101_mount_2, _01E0
    WaitMovement
    Message msg_0148_D52R0101_00004
    CloseMessage
    ApplyMovement obj_D52R0101_mount_2, _01EC
    WaitMovement
    RemoveObject obj_D52R0101_mount_2
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON_HIKER
    SetFlag FLAG_HGSS_HIDE_ROUTE_47_EMBEDDED_TOWER_HIKER
    ReleaseAll
    End
_019D:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_01A4:
    WalkNormalNorth 8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01B0:
    WalkOnSpotNormalSouth
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_01BC:
    WalkNormalNorth 10
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01C8:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01D0:
    WalkOnSpotNormalSouth
    WalkSlowSouth 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01E0:
    WalkNormalNorth 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01EC:
    WalkNormalSouth 8
    EndMovement
    .balign 4, 0
