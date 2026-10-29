#include "macros/scrcmd.inc"

#define obj_D41R0105_tsure_poke_static_moltres 0

    ScriptEntry scr_seq_D41R0105_000
    ScriptEntry scr_seq_D41R0105_001
    ScriptEntryEnd
scr_seq_D41R0105_001:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _0069
    End
scr_seq_D41R0105_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_REGIGIGAS, 0
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_REGIGIGAS, 75, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0077
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _007D
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _0081
    ReleaseAll
    End
_0069:
    SetFlag FLAG_HGSS_HIDE_MT_SILVER_CAVE_MOLTRES
    RemoveObject obj_D41R0105_tsure_poke_static_moltres
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_0077:
    BlackOutFromBattle
    ReleaseAll
    End
_007D:
    ReleaseAll
    End
_0081:
    SetFlag FLAG_HGSS_CAUGHT_MOLTRES
    Return
    .balign 4, 0
