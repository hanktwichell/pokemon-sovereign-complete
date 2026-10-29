#include "macros/scrcmd.inc"

#define obj_D03R0103_tsure_poke_static_mewtwo 14

    ScriptEntry scr_seq_D03R0103_000
    ScriptEntry scr_seq_D03R0103_001
    ScriptEntryEnd
scr_seq_D03R0103_001:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _0017
    End
_0017:
    SetFlag FLAG_HGSS_HIDE_CERULEAN_CAVE_MEWTWO
    RemoveObject obj_D03R0103_tsure_poke_static_mewtwo
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_D03R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MEWTWO, 0
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_MEWTWO, 70, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0077
    @ HGSS: GetStaticEncounterOutcome VAR_TEMP_x4002
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _0073
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _007D
_0073:
    ReleaseAll
    End
_0077:
    BlackOutFromBattle
    ReleaseAll
    End
_007D:
    SetFlag FLAG_HGSS_CAUGHT_MEWTWO
    Return
    .balign 4, 0
