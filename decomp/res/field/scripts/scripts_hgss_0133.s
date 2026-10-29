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
    GoToIf 4, _00A1
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _00A3
    GoTo _00A3
scr_seq_D52R0101_002:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _00B3
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
    CompleteStartWildBattle SPECIES_GROUDON, 70, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00C1
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _00C7
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 1, _00D6
    Message msg_0148_D52R0101_00001
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE
    ReleaseAll
    End
_00A1:
    End
_00A3:
    GoTo _0148
_00A9:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON_HIKER
    End
_00B3:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON
    RemoveObject obj_D52R0101_tsure_poke_static_groudon
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_00C1:
    BlackOutFromBattle
    ReleaseAll
    End
_00C7:
    Message msg_0148_D52R0101_00001
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE
    ReleaseAll
    End
_00D6:
    Message msg_0148_D52R0101_00005
    Message msg_0148_D52R0101_00006
    BufferPlayerName 0
    RemoveItem ITEM_RED_ORB, 1, VAR_RESULT
    SetVar VAR_0x8004, ITEM_BLUE_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 4
    SetFlag FLAG_HGSS_CAUGHT_GROUDON
    ClearFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON_HIKER
    AddObject obj_D52R0101_mount_2
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _016E
    ApplyMovement obj_D52R0101_mount_2, _021A
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0224
    WaitMovement
    GoTo _01C9
_0148:
    GoToIfSet FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE, _00A1
    CheckItem ITEM_RED_ORB, 1, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 4, _0210
    GoTo _00A9
_016E:
    ApplyMovement obj_D52R0101_mount_2, _022E
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0238
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0148_D52R0101_00002
    CloseMessage
    ApplyMovement obj_D52R0101_mount_2, _023E
    WaitMovement
    Message msg_0148_D52R0101_00003
    CloseMessage
    ApplyMovement obj_D52R0101_mount_2, _024C
    WaitMovement
    Message msg_0148_D52R0101_00004
    CloseMessage
    ApplyMovement obj_D52R0101_mount_2, _0256
    WaitMovement
    RemoveObject obj_D52R0101_mount_2
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON_HIKER
    SetFlag FLAG_HGSS_HIDE_ROUTE_47_EMBEDDED_TOWER_HIKER
    ReleaseAll
    End
_01C9:
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0148_D52R0101_00002
    CloseMessage
    ApplyMovement obj_D52R0101_mount_2, _023E
    WaitMovement
    Message msg_0148_D52R0101_00003
    CloseMessage
    ApplyMovement obj_D52R0101_mount_2, _024C
    WaitMovement
    Message msg_0148_D52R0101_00004
    CloseMessage
    ApplyMovement obj_D52R0101_mount_2, _0256
    WaitMovement
    RemoveObject obj_D52R0101_mount_2
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON_HIKER
    SetFlag FLAG_HGSS_HIDE_ROUTE_47_EMBEDDED_TOWER_HIKER
    ReleaseAll
    End
_0210:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON_HIKER
    ClearFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_GROUDON
    End
    .balign 4, 0
_021A:
    WalkNormalNorth 8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0224:
    WalkOnSpotNormalSouth
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_022E:
    WalkNormalNorth 10
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0238:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_023E:
    WalkOnSpotNormalSouth
    WalkSlowSouth 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_024C:
    WalkNormalNorth 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0256:
    WalkNormalSouth 8
    EndMovement
    .balign 4, 0
