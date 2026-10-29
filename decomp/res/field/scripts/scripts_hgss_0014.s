#include "macros/scrcmd.inc"

#define obj_D11R0105_tsure_poke_static_articuno 2

    ScriptEntry scr_seq_D11R0105_000
    ScriptEntry scr_seq_D11R0105_001
    ScriptEntryEnd
scr_seq_D11R0105_001:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _0069
    End
scr_seq_D11R0105_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ARTICUNO, 0
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_ARTICUNO, 60, 0
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
    SetFlag FLAG_HGSS_HIDE_SEAFOAM_ISLAND_ARTICUNO
    RemoveObject obj_D11R0105_tsure_poke_static_articuno
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
    SetFlag FLAG_HGSS_CAUGHT_ARTICUNO
    Return
    .balign 4, 0
