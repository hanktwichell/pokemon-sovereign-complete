#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0466.h"

#define obj_T03R0601_gsoldman1 0

    ScriptEntry scr_seq_T03R0601_000
    ScriptEntry scr_seq_T03R0601_001
    ScriptEntry scr_seq_T03R0601_002
    ScriptEntryEnd
scr_seq_T03R0601_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    BufferPartyMonSpecies 1, 0
    BufferPlayerName 0
    GoToIfUnset FLAG_HGSS_SG_3FB9, _039B
    GoToIfUnset FLAG_HGSS_SG_3F9C, _03C3
    GoToIfSet FLAG_HGSS_HIDE_MT_SILVER_CAVE_MOLTRES, _0458
    GoToIfSet FLAG_HGSS_SG_3FCA, _0476
    GoToIfSet FLAG_HGSS_SG_3FB8, _048F
    GoToIfSet FLAG_HGSS_SG_3FB9, _049D
    ApplyMovement obj_T03R0601_gsoldman1, _0706
    WaitMovement
    Message msg_0466_T03R0601_00000
    SetFlag FLAG_HGSS_SG_3FB9
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _04C1
    GoTo _04EE
scr_seq_T03R0601_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0466_T03R0601_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051B
    Message msg_0466_T03R0601_00013
    Message msg_0466_T03R0601_00022
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051B
    Message msg_0466_T03R0601_00014
    DrawPokemonPreview SPECIES_ARTICUNO, 0
    PlayCry SPECIES_ARTICUNO, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_ZAPDOS, 0
    PlayCry SPECIES_ZAPDOS, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_MOLTRES, 0
    PlayCry SPECIES_MOLTRES, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_MEWTWO, 0
    PlayCry SPECIES_MEWTWO, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_MEW, 0
    PlayCry SPECIES_MEW, 0
    WaitButton
    RemovePokemonPreview
    Message msg_0466_T03R0601_00022
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051B
    Message msg_0466_T03R0601_00015
    DrawPokemonPreview SPECIES_RAIKOU, 0
    PlayCry SPECIES_RAIKOU, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_ENTEI, 0
    PlayCry SPECIES_ENTEI, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_SUICUNE, 0
    PlayCry SPECIES_SUICUNE, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_LUGIA, 0
    PlayCry SPECIES_LUGIA, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_HO_OH, 0
    PlayCry SPECIES_HO_OH, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_CELEBI, 0
    PlayCry SPECIES_CELEBI, 0
    WaitButton
    RemovePokemonPreview
    Message msg_0466_T03R0601_00022
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051B
    Message msg_0466_T03R0601_00016
    DrawPokemonPreview SPECIES_REGIROCK, 0
    PlayCry SPECIES_REGIROCK, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_REGICE, 0
    PlayCry SPECIES_REGICE, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_REGISTEEL, 0
    PlayCry SPECIES_REGISTEEL, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_LATIAS, 1
    PlayCry SPECIES_LATIAS, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_LATIOS, 0
    PlayCry SPECIES_LATIOS, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_KYOGRE, 0
    PlayCry SPECIES_KYOGRE, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_GROUDON, 0
    PlayCry SPECIES_GROUDON, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_RAYQUAZA, 0
    PlayCry SPECIES_RAYQUAZA, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_JIRACHI, 0
    PlayCry SPECIES_JIRACHI, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_DEOXYS, 0
    PlayCry SPECIES_DEOXYS, 0
    WaitButton
    RemovePokemonPreview
    Message msg_0466_T03R0601_00022
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051B
    Message msg_0466_T03R0601_00017
    DrawPokemonPreview SPECIES_UXIE, 0
    PlayCry SPECIES_UXIE, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_MESPRIT, 0
    PlayCry SPECIES_MESPRIT, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_AZELF, 0
    PlayCry SPECIES_AZELF, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_DIALGA, 0
    PlayCry SPECIES_DIALGA, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_PALKIA, 0
    PlayCry SPECIES_PALKIA, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_GIRATINA, 1
    PlayCry SPECIES_GIRATINA, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_HEATRAN, 0
    PlayCry SPECIES_HEATRAN, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_REGIGIGAS, 0
    PlayCry SPECIES_REGIGIGAS, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_CRESSELIA, 1
    PlayCry SPECIES_CRESSELIA, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_MANAPHY, 0
    PlayCry SPECIES_MANAPHY, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_DARKRAI, 0
    PlayCry SPECIES_DARKRAI, 0
    WaitButton
    RemovePokemonPreview
    DrawPokemonPreview SPECIES_SHAYMIN, 0
    PlayCry SPECIES_SHAYMIN, 0
    WaitButton
    RemovePokemonPreview
    Message msg_0466_T03R0601_00022
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051B
    Message msg_0466_T03R0601_00018
    Message msg_0466_T03R0601_00022
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051B
    Message msg_0466_T03R0601_00019
    DrawPokemonPreview SPECIES_PHIONE, 0
    PlayCry SPECIES_PHIONE, 0
    WaitButton
    RemovePokemonPreview
    Message msg_0466_T03R0601_00022
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051B
    Message msg_0466_T03R0601_00020
    Message msg_0466_T03R0601_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03R0601_002:
    BufferPlayerName 0
    End
_039B:
    ApplyMovement obj_T03R0601_gsoldman1, _0706
    WaitMovement
    Message msg_0466_T03R0601_00000
    SetFlag FLAG_HGSS_SG_3FB9
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _04C1
    GoTo _04EE
_03C3:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0466_T03R0601_00028
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 252
    GoToIf 1, _0521
    CompareVar VAR_MAP_LOCAL_0x01, 253
    GoToIf 1, _0521
    CompareVar VAR_MAP_LOCAL_0x01, 254
    GoToIf 1, _0521
    CompareVar VAR_MAP_LOCAL_0x01, 255
    GoToIf 1, _0579
    CompareVar VAR_MAP_LOCAL_0x01, 256
    GoToIf 1, _0579
    CompareVar VAR_MAP_LOCAL_0x01, 257
    GoToIf 1, _0579
    CompareVar VAR_MAP_LOCAL_0x01, 258
    GoToIf 1, _05D1
    CompareVar VAR_MAP_LOCAL_0x01, 259
    GoToIf 1, _05D1
    CompareVar VAR_MAP_LOCAL_0x01, 260
    GoToIf 1, _05D1
    Message msg_0466_T03R0601_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0458:
    Message msg_0466_T03R0601_00023
    WaitButton
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0629
    CloseMessage
    ReleaseAll
    End
_0476:
    Message msg_0466_T03R0601_00006
    DrawPokemonPreview SPECIES_REGIGIGAS, 0
    Message msg_0466_T03R0601_00010
    RemovePokemonPreview
    Message msg_0466_T03R0601_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_048F:
    Message msg_0466_T03R0601_00006
    Message msg_0466_T03R0601_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_049D:
    ApplyMovement obj_T03R0601_gsoldman1, _0706
    WaitMovement
    Message msg_0466_T03R0601_00006
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _04C1
    GoTo _04EE
_04C1:
    DrawPokemonPreview SPECIES_LATIOS, 0
    Message msg_0466_T03R0601_00001
    RemovePokemonPreview
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 381
    GoToIf 1, _066A
    Message msg_0466_T03R0601_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04EE:
    DrawPokemonPreview SPECIES_LATIAS, 1
    Message msg_0466_T03R0601_00001
    RemovePokemonPreview
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 380
    GoToIf 1, _06AA
    Message msg_0466_T03R0601_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_051B:
    CloseMessage
    ReleaseAll
    End
_0521:
    Message msg_0466_T03R0601_00030
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _06EA
    CompareVar VAR_RESULT, 6
    GoToIf 1, _06EA
    GivePokemon SPECIES_TORCHIC, 10, 155, VAR_RESULT
    GivePokemon SPECIES_MUDKIP, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0466_T03R0601_00031
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    Message msg_0466_T03R0601_00034
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_SG_3F9C
    ReleaseAll
    End
_0579:
    Message msg_0466_T03R0601_00030
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _06EA
    CompareVar VAR_RESULT, 6
    GoToIf 1, _06EA
    GivePokemon SPECIES_TREECKO, 10, 155, VAR_RESULT
    GivePokemon SPECIES_MUDKIP, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0466_T03R0601_00032
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    Message msg_0466_T03R0601_00034
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_SG_3F9C
    ReleaseAll
    End
_05D1:
    Message msg_0466_T03R0601_00030
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _06EA
    CompareVar VAR_RESULT, 6
    GoToIf 1, _06EA
    GivePokemon SPECIES_TREECKO, 10, 155, VAR_RESULT
    GivePokemon SPECIES_TORCHIC, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0466_T03R0601_00033
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    Message msg_0466_T03R0601_00034
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_SG_3F9C
    ReleaseAll
    End
_0629:
    Message msg_0466_T03R0601_00024
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06F5
    Message msg_0466_T03R0601_00025
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_PICNICKER_MICKEY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 9
    GoToIf 1, _0700
    Message msg_0466_T03R0601_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_066A:
    Message msg_0466_T03R0601_00007
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_WHITE
    FadeScreen 6, 1, 1, COLOR_WHITE
    Message msg_0466_T03R0601_00009
    SetVar VAR_0x8004, ITEM_ENIGMA_STONE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    SetFlag FLAG_HGSS_SG_3FB8
    ReleaseAll
    End
_06AA:
    Message msg_0466_T03R0601_00003
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_WHITE
    FadeScreen 6, 1, 1, COLOR_WHITE
    Message msg_0466_T03R0601_00005
    SetVar VAR_0x8004, ITEM_ENIGMA_STONE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    SetFlag FLAG_HGSS_SG_3FB8
    ReleaseAll
    End
_06EA:
    Message msg_0466_T03R0601_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06F5:
    Message msg_0466_T03R0601_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0700:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0706:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
