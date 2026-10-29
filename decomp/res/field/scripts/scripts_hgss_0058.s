#include "macros/scrcmd.inc"

#define obj_D25R0103_rapurasu 3

    ScriptEntry scr_seq_D25R0103_000
    ScriptEntry scr_seq_D25R0103_001
    ScriptEntry scr_seq_D25R0103_002
    ScriptEntryEnd
scr_seq_D25R0103_002:
    GoToIfSet FLAG_HGSS_DAILY_CAUGHT_LAPRAS, _003A
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0034
    ClearFlag FLAG_HGSS_HIDE_UNION_CAVE_LAPRAS
    GoTo _0038
_0034:
    SetFlag FLAG_HGSS_HIDE_UNION_CAVE_LAPRAS
_0038:
    End
_003A:
    SetFlag FLAG_HGSS_HIDE_UNION_CAVE_LAPRAS
    End
scr_seq_D25R0103_001:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _004D
    End
_004D:
    SetFlag FLAG_HGSS_HIDE_UNION_CAVE_LAPRAS
    RemoveObject obj_D25R0103_rapurasu
    End
scr_seq_D25R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_LAPRAS, 0
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_LAPRAS, 20, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _008F
    SetFlag FLAG_HGSS_DAILY_CAUGHT_LAPRAS
    ReleaseAll
    End
_008F:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
