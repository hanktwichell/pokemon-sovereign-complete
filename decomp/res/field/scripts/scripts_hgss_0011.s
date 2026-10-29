#include "macros/scrcmd.inc"

#define obj_D03R0103_tsure_poke_static_mewtwo 14

    ScriptEntry scr_seq_D03R0103_000
    ScriptEntry scr_seq_D03R0103_001
    ScriptEntry scr_seq_D03R0103_002
    ScriptEntryEnd
scr_seq_D03R0103_001:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _00DE
    End
scr_seq_D03R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MEWTWO, 0
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_MEWTWO, 75, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00EC
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _00F2
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _00F6
    ReleaseAll
    End
scr_seq_D03R0103_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_LUGIA, 6
    WaitCry
    PlayCry SPECIES_HO_OH, 6
    WaitCry
    PlayCry SPECIES_MEWTWO, 6
    WaitCry
    StartTrainerBattle TRAINER_HGSS_YOUNGSTER_MICKEY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0100
    FadeScreen 6, 1, 0, COLOR_WHITE
    WaitFadeScreen
    PlayCry SPECIES_LUGIA, 6
    WaitCry
    PlayCry SPECIES_HO_OH, 6
    WaitCry
    PlayCry SPECIES_MEWTWO, 6
    WaitCry
    RemoveObject 16
    FadeScreen 6, 1, 1, COLOR_WHITE
    WaitFadeScreen
    ReleaseAll
    End
_00DE:
    SetFlag FLAG_HGSS_HIDE_CERULEAN_CAVE_MEWTWO
    RemoveObject obj_D03R0103_tsure_poke_static_mewtwo
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_00EC:
    BlackOutFromBattle
    ReleaseAll
    End
_00F2:
    ReleaseAll
    End
_00F6:
    SetFlag FLAG_HGSS_CAUGHT_MEWTWO
    ClearFlag FLAG_HGSS_SG_3F5D
    Return
_0100:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
