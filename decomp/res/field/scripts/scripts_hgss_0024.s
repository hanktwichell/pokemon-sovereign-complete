#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0061.h"

#define obj_D18R0102_tsure_poke_static_suicune 0
#define obj_D18R0102_tsure_poke_static_entei 1
#define obj_D18R0102_tsure_poke_static_raikou 2
#define obj_D18R0102_minaki 3
#define obj_D18R0102_tsure_poke_static_suicune_2 12

    ScriptEntry scr_seq_D18R0102_000
    ScriptEntry scr_seq_D18R0102_001
    ScriptEntry scr_seq_D18R0102_002
    ScriptEntryEnd
scr_seq_D18R0102_002:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _001B
    End
_001B:
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_STATIC_SUICUNE
    RemoveObject obj_D18R0102_tsure_poke_static_suicune_2
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_D18R0102_000:
    LockAll
    PlayCry SPECIES_RAIKOU, 0
    ReleaseObject obj_D18R0102_tsure_poke_static_raikou
    @ HGSS: ScrCmd_523 obj_D18R0102_tsure_poke_static_raikou, 2, 90, 2, 0
    LockObject obj_D18R0102_tsure_poke_static_raikou
    WaitCry
    PlayCry SPECIES_ENTEI, 0
    ReleaseObject obj_D18R0102_tsure_poke_static_entei
    @ HGSS: ScrCmd_523 obj_D18R0102_tsure_poke_static_entei, 2, 90, 2, 0
    LockObject obj_D18R0102_tsure_poke_static_entei
    WaitCry
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_D18R0102_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_D18R0102_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_D18R0102_tsure_poke_static_suicune
    WaitCry
    ApplyMovement obj_D18R0102_tsure_poke_static_raikou, _0224
    WaitMovement
    ApplyMovement obj_D18R0102_tsure_poke_static_entei, _0234
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 16
    GoToIf 5, _00C8
    ApplyMovement obj_D18R0102_tsure_poke_static_suicune, _0244
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ApplyMovement obj_D18R0102_tsure_poke_static_suicune, _0254
    WaitCry
    GoTo _00E2
_00C8:
    ApplyMovement obj_D18R0102_tsure_poke_static_suicune, _0268
    WaitMovement
    PlayCry SPECIES_SUICUNE, 0
    ApplyMovement obj_D18R0102_tsure_poke_static_suicune, _0278
    WaitCry
_00E2:
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _028C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_B1F_RAIKOU
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_B1F_ENTEI
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_B1F_SUICUNE
    RemoveObject obj_D18R0102_tsure_poke_static_raikou
    RemoveObject obj_D18R0102_tsure_poke_static_entei
    RemoveObject obj_D18R0102_tsure_poke_static_suicune
    ActivateRoamingPokemon ROAMING_SLOT_RAIKOU
    ActivateRoamingPokemon ROAMING_SLOT_ENTEI
    WaitTime 15, VAR_RESULT
    ClearFlag FLAG_HGSS_HIDE_BURNED_TOWER_B1F_EUSINE
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    AddObject obj_D18R0102_minaki
    LockObject obj_D18R0102_minaki
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 16
    GoToIf 5, _015B
    ApplyMovement obj_D18R0102_minaki, _029C
    GoTo _016B
_015B:
    ApplyMovement obj_D18R0102_minaki, _02B0
    ApplyMovement LOCALID_PLAYER, _02D8
_016B:
    WaitMovement
    Message msg_0061_D18R0102_00000
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 16
    GoToIf 5, _0191
    ApplyMovement obj_D18R0102_minaki, _02C4
    GoTo _01A1
_0191:
    ApplyMovement obj_D18R0102_minaki, _02D0
    ApplyMovement LOCALID_PLAYER, _02D8
_01A1:
    WaitMovement
    BufferPlayerName 0
    Message msg_0061_D18R0102_00001
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 16
    GoToIf 5, _01CC
    ApplyMovement obj_D18R0102_minaki, _02E8
    GoTo _01D4
_01CC:
    ApplyMovement obj_D18R0102_minaki, _02F8
_01D4:
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitTime 2, VAR_RESULT
    RemoveObject obj_D18R0102_minaki
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_B1F_EUSINE
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_1F_EUSINE
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_1F_MORTY
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_1F_RAIKOU
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_1F_ENTEI
    SetFlag FLAG_HGSS_HIDE_BURNED_TOWER_1F_SUICUNE
    ClearFlag FLAG_HGSS_HIDE_CIANWOOD_SUICUNE
    SetVarFromValue VAR_HGSS_UNK_40A1, 1
    SetVarFromValue VAR_HGSS_UNK_4076, 1
    SetVarFromValue VAR_HGSS_UNK_4079, 2
    SetFlag FLAG_HGSS_UNK_247
    ClearFlag FLAG_HGSS_HIDE_ECRUTEAK_OLD_MAN
    ReleaseAll
    End
    .balign 4, 0
_0224:
    MoveAction_105
    SetInvisible
    EndMovement
    End
    .balign 4, 0
_0234:
    MoveAction_106
    SetInvisible
    EndMovement
    End
    .balign 4, 0
_0244:
    MoveAction_107
    FaceEast
    EndMovement
    End
    .balign 4, 0
_0254:
    Delay4 6
    MoveAction_108
    SetInvisible
    EndMovement
    End
    .balign 4, 0
_0268:
    MoveAction_109
    FaceEast
    EndMovement
    End
    .balign 4, 0
_0278:
    Delay4 6
    MoveAction_110
    SetInvisible
    EndMovement
    End
    .balign 4, 0
_028C:
    WalkNormalWest
    FaceSouth
    EndMovement
    End
    .balign 4, 0
_029C:
    WalkFastSouth
    WalkFastWest 3
    FaceSouth
    EndMovement
    End
    .balign 4, 0
_02B0:
    WalkFastWest 5
    WalkFastSouth
    FaceSouth
    EndMovement
    End
    .balign 4, 0
_02C4:
    WalkFastWest
    FaceNorth
    EndMovement
    .balign 4, 0
_02D0:
    FaceEast
    EndMovement
    .balign 4, 0
_02D8:
    Delay4 6
    FaceWest
    EndMovement
    End
    .balign 4, 0
_02E8:
    WalkFastEast 4
    WalkFastNorth
    EndMovement
    End
    .balign 4, 0
_02F8:
    WalkFastNorth
    WalkFastEast 5
    FaceNorth
    EndMovement
    End
scr_seq_D18R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SUICUNE, 0
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_SUICUNE, 40, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _035C
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _0358
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _0362
_0358:
    ReleaseAll
    End
_035C:
    BlackOutFromBattle
    ReleaseAll
    End
_0362:
    SetFlag FLAG_HGSS_CAUGHT_SUICUNE
    Return
    .balign 4, 0
