#include "macros/scrcmd.inc"

#define obj_D25R0103_rapurasu 3

    ScriptEntry scr_seq_D25R0103_000
    ScriptEntry scr_seq_D25R0103_001
    ScriptEntry scr_seq_D25R0103_002
    ScriptEntryEnd
scr_seq_D25R0103_002:
    GoToIfSet FLAG_HGSS_DAILY_CAUGHT_LAPRAS, _0079
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _007F
    ClearFlag FLAG_HGSS_HIDE_UNION_CAVE_LAPRAS
    GoTo _0085
scr_seq_D25R0103_001:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _0087
    End
scr_seq_D25R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_LAPRAS, 0
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_LAPRAS, 25, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0091
    SetFlag FLAG_HGSS_DAILY_CAUGHT_LAPRAS
    ReleaseAll
    End
_0079:
    SetFlag FLAG_HGSS_HIDE_UNION_CAVE_LAPRAS
    End
_007F:
    SetFlag FLAG_HGSS_HIDE_UNION_CAVE_LAPRAS
    End
_0085:
    End
_0087:
    SetFlag FLAG_HGSS_HIDE_UNION_CAVE_LAPRAS
    RemoveObject obj_D25R0103_rapurasu
    End
_0091:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
