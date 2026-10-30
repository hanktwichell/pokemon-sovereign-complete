#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0584.h"


    ScriptEntry scr_seq_T25R0201_000
    ScriptEntry scr_seq_T25R0201_001
    ScriptEntry scr_seq_T25R0201_002
    ScriptEntry scr_seq_T25R0201_003
    ScriptEntry scr_seq_T25R0201_004
    ScriptEntry scr_seq_T25R0201_005
    ScriptEntry scr_seq_T25R0201_006
    ScriptEntry scr_seq_T25R0201_007
    ScriptEntryEnd
scr_seq_T25R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_089, _01CC
    Message msg_0584_T25R0201_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01EB
    CompareVar VAR_RESULT, 1
    GoToIf 1, _020E
    End
scr_seq_T25R0201_001:
    NPCMessage msg_0584_T25R0201_00005
    End
scr_seq_T25R0201_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    BufferPlayerName 0
    BufferPartyMonSpecies 1, 0
    GoToIfSet FLAG_HGSS_SG_3FDA, _021B
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0584_T25R0201_00006
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_SG_3FDA
    ReleaseAll
    End
scr_seq_T25R0201_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3FD8, _0272
    Message msg_0584_T25R0201_00011
    SetFlag FLAG_HGSS_SG_3FD8
    GoTo _027B
scr_seq_T25R0201_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3FD4, _02A8
    Message msg_0584_T25R0201_00042
    SetVar VAR_0x8004, ITEM_ROOT_FOSSIL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_CLAW_FOSSIL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_HELIX_FOSSIL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_DOME_FOSSIL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_ARMOR_FOSSIL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_SKULL_FOSSIL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3FD4
    Message msg_0584_T25R0201_00043
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0201_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0584_T25R0201_00054
    SetVar VAR_0x8004, ITEM_SERENADE_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0201_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3FAD, _02C8
    DrawPokemonPreview SPECIES_PHIONE, 0
    Message msg_0584_T25R0201_00069
    WaitButton
    CloseMessage
    RemovePokemonPreview
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 489
    GoToIf 1, _02F2
    ReleaseAll
    End
scr_seq_T25R0201_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _031E
    MessageGendered msg_0584_T25R0201_00083, msg_0584_T25R0201_00084
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01CC:
    Message msg_0584_T25R0201_00003
    WaitButton
    CloseMessage
    SetVar VAR_0x8004, ITEM_LOCK_CAPSULE
    SetVar VAR_0x8005, 1
    RemoveItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    ReleaseAll
    End
_01EB:
    Message msg_0584_T25R0201_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _040C
    CompareVar VAR_RESULT, 1
    GoToIf 1, _020E
    End
_020E:
    Message msg_0584_T25R0201_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_021B:
    GoToIfUnset FLAG_HGSS_SG_3F9B, _0428
    GoToIfUnset FLAG_HGSS_SG_3FD7, _04BD
    GoToIfUnset FLAG_HGSS_SG_3FD6, _04BD
    GoToIfUnset FLAG_HGSS_SG_3FD5, _04BD
    GoToIfUnset FLAG_HGSS_SG_3F5A, _04BD
    CheckItem ITEM_RED_CHAIN, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04E8
    Message msg_0584_T25R0201_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0272:
    Message msg_0584_T25R0201_00015
    GoTo _027B
_027B:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0502
    CompareVar VAR_RESULT, 2
    GoToIf 1, _053B
    Message msg_0584_T25R0201_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02A8:
    CheckItem ITEM_ENIGMA_STONE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0597
    Message msg_0584_T25R0201_00044
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02C8:
    DrawPokemonPreview SPECIES_MANAPHY, 0
    Message msg_0584_T25R0201_00071
    WaitButton
    CloseMessage
    RemovePokemonPreview
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 490
    GoToIf 1, _0631
    ReleaseAll
    End
_02F2:
    PlayCry SPECIES_PHIONE, 6
    WaitCry
    ApplyMovement 3, _1106
    WaitMovement
    Message msg_0584_T25R0201_00070
    DrawPokemonPreview SPECIES_MANAPHY, 0
    SetFlag FLAG_HGSS_SG_3FAD
    Message msg_0584_T25R0201_00071
    WaitButton
    CloseMessage
    RemovePokemonPreview
    ReleaseAll
    End
_031E:
    MessageGendered msg_0584_T25R0201_00085, msg_0584_T25R0201_00086
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 87, 0
    AddMenuEntry 88, 1
    AddMenuEntry 89, 2
    AddMenuEntry 90, 3
    AddMenuEntry 91, 4
    AddMenuEntry 92, 5
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    SetVarFromValue VAR_0x8004, ITEM_SUN_STONE
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 72
    GoToIf 1, _067E
    CompareVar VAR_0x8008, 1
    SetVarFromValue VAR_0x8004, ITEM_MOON_STONE
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 73
    GoToIf 1, _067E
    CompareVar VAR_0x8008, 2
    SetVarFromValue VAR_0x8004, ITEM_SHINY_STONE
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 74
    GoToIf 1, _067E
    CompareVar VAR_0x8008, 3
    SetVarFromValue VAR_0x8004, ITEM_DUSK_STONE
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 75
    GoToIf 1, _067E
    CompareVar VAR_0x8008, 4
    SetVarFromValue VAR_0x8004, ITEM_DAWN_STONE
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 90
    GoToIf 1, _067E
    Message msg_0584_T25R0201_00095
    WaitButton
    CloseMessage
    ReleaseAll
    End
_040C:
    SetVar VAR_0x8004, ITEM_BICYCLE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_089
    CloseMessage
    ReleaseAll
    End
_0428:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0584_T25R0201_00075
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 387
    GoToIf 1, _06A8
    CompareVar VAR_MAP_LOCAL_0x01, 388
    GoToIf 1, _06A8
    CompareVar VAR_MAP_LOCAL_0x01, 389
    GoToIf 1, _06A8
    CompareVar VAR_MAP_LOCAL_0x01, 390
    GoToIf 1, _0700
    CompareVar VAR_MAP_LOCAL_0x01, 391
    GoToIf 1, _0700
    CompareVar VAR_MAP_LOCAL_0x01, 392
    GoToIf 1, _0700
    CompareVar VAR_MAP_LOCAL_0x01, 393
    GoToIf 1, _0758
    CompareVar VAR_MAP_LOCAL_0x01, 394
    GoToIf 1, _0758
    CompareVar VAR_MAP_LOCAL_0x01, 395
    GoToIf 1, _0758
    Message msg_0584_T25R0201_00076
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04BD:
    GoToIfSet FLAG_HGSS_SG_3FD9, _07B0
    CheckItem ITEM_LOCK_CAPSULE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07BB
    Message msg_0584_T25R0201_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04E8:
    GoToIfSet FLAG_HGSS_SG_3FCB, _082A
    Message msg_0584_T25R0201_00045
    SetFlag FLAG_HGSS_SG_3FCB
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0502:
    GoToIfSet FLAG_MAP_LOCAL_0x01, _0874
    CompareVar VAR_HGSS_UNK_407F, 0
    GoToIf 5, _0881
    Message msg_0584_T25R0201_00033
    GetFossilCount VAR_0x8000
    CompareVar VAR_0x8000, 0
    GoToIf 5, _08A6
    Message msg_0584_T25R0201_00038
    GoTo _0A4B
_053B:
    Message msg_0584_T25R0201_00017
    ShowMoney 20, 2
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 28, 0
    AddMenuEntry 29, 1
    AddMenuEntry 27, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0A57
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0B6C
    HideMoney
    Message msg_0584_T25R0201_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0597:
    ApplyMovement 2, _110C
    BufferPlayerName 0
    BufferPlayerName 0
    WaitMovement
    Message msg_0584_T25R0201_00048
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0BFD
    Message msg_0584_T25R0201_00050
    RemoveItem ITEM_ENIGMA_STONE, 1, VAR_RESULT
    Message msg_0584_T25R0201_00051
    WaitFanfare
    Message msg_0584_T25R0201_00052
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0584_T25R0201_00053
    SetVar VAR_0x8004, ITEM_SOUL_DEW
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_0631:
    PlayCry SPECIES_MANAPHY, 6
    WaitCry
    ApplyMovement 3, _1106
    WaitMovement
    Message msg_0584_T25R0201_00072
    SetVar VAR_0x8004, ITEM_SPLASH_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    MessageGendered msg_0584_T25R0201_00073, msg_0584_T25R0201_00074
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 3
    FadeScreen 8, 1, 1, 10
    WaitFadeScreen
    ReleaseAll
    End
_067E:
    CheckItem VAR_0x8006, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C08
    Message msg_0584_T25R0201_00094
    RemoveItem VAR_0x8006, 1, VAR_RESULT
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_06A8:
    Message msg_0584_T25R0201_00077
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0C13
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0C13
    GivePokemon SPECIES_CHIMCHAR, 10, 155, VAR_RESULT
    GivePokemon SPECIES_PIPLUP, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0584_T25R0201_00078
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0584_T25R0201_00081
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_SG_3F9B
    ReleaseAll
    End
_0700:
    Message msg_0584_T25R0201_00077
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0C13
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0C13
    GivePokemon SPECIES_TURTWIG, 10, 155, VAR_RESULT
    GivePokemon SPECIES_PIPLUP, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0584_T25R0201_00079
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0584_T25R0201_00081
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_SG_3F9B
    ReleaseAll
    End
_0758:
    Message msg_0584_T25R0201_00077
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0C13
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0C13
    GivePokemon SPECIES_TURTWIG, 10, 155, VAR_RESULT
    GivePokemon SPECIES_CHIMCHAR, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0584_T25R0201_00080
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0584_T25R0201_00081
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_SG_3F9B
    ReleaseAll
    End
_07B0:
    Message msg_0584_T25R0201_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_07BB:
    BufferPlayerName 0
    StopMusic
    PlayMusic SEQ_GS_D_SHINTO_sseq
    Message msg_0584_T25R0201_00008
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteScreenShake 0, 20, 10, 10
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    WaitSE SEQ_SE_DP_KI_GASYAN_sseq
    Message msg_0584_T25R0201_00009
    RemoveItem ITEM_LOCK_CAPSULE, 1, VAR_RESULT
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_SG_3FD9
    ClearFlag FLAG_HGSS_SG_3FD7
    ClearFlag FLAG_HGSS_SG_3FD6
    ClearFlag FLAG_HGSS_SG_3FD5
    SetFlag FLAG_HGSS_SG_3F5A
    ReleaseAll
    End
_082A:
    Message msg_0584_T25R0201_00047
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0C1E
    CloseMessage
    CompleteFollowerPutAway
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SINJOH_RUINS_CABIN, 5, 6, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteFollowerReturn
    ReleaseAll
    End
_0874:
    SetFlag FLAG_MAP_LOCAL_0x01
    Message msg_0584_T25R0201_00035
    GoTo _0A4B
_0881:
    BufferSpeciesNameFromVar 0, VAR_HGSS_UNK_407F, 0, 0
    Message msg_0584_T25R0201_00036
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 5, _0C3C
    Message msg_0584_T25R0201_00037
    GoTo _0A4B
_08A6:
    CompareVar VAR_0x8000, 1
    GoToIf 1, _0CC3
    SetVarFromValue VAR_0x8001, 0
    CheckItem ITEM_OLD_AMBER, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_HELIX_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_DOME_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_ROOT_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_CLAW_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_ARMOR_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_SKULL_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CompareVar VAR_0x8001, 1
    GoToIf 1, _0CC3
    SetVarFromValue VAR_0x8004, ITEM_NONE
    SetVarFromValue VAR_0x8005, 0
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    SetVarFromValue VAR_MAP_LOCAL_0x05, 0
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    CompleteInitHGSSMenu 1, 1, 0, VAR_0x8000, 1
    CompareVar VAR_0x8005, 0
    CallIf 1, _0CFC
    CompareVar VAR_0x8005, 1
    CallIf 1, _0D0C
    CompareVar VAR_0x8005, 2
    CallIf 1, _0D1C
    CompareVar VAR_0x8005, 3
    CallIf 1, _0D2C
    CompareVar VAR_0x8005, 4
    CallIf 1, _0D3C
    CompareVar VAR_0x8005, 5
    CallIf 1, _0D4C
    CompareVar VAR_0x8005, 6
    CallIf 1, _0D5C
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D6C
    CompareVar VAR_0x8004, 0
    CallIf 1, _0D78
    CompareVar VAR_0x8004, 1
    CallIf 1, _0D80
    CompareVar VAR_0x8004, 2
    CallIf 1, _0D88
    CompareVar VAR_0x8004, 3
    CallIf 1, _0D90
    CompareVar VAR_0x8004, 4
    CallIf 1, _0D98
    CompareVar VAR_0x8004, 5
    CallIf 1, _0DA0
    CompareVar VAR_0x8004, 6
    CallIf 1, _0DA8
    SetVarFromVar VAR_0x8006, VAR_0x8005
    AddVar VAR_0x8006, 159
    AddMenuEntry VAR_0x8006, VAR_0x8004
    GoTo _0DB0
_0A4B:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0A57:
    Message msg_0584_T25R0201_00017
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 18, 0
    AddMenuEntry 19, 1
    AddMenuEntry 20, 2
    AddMenuEntry 21, 3
    AddMenuEntry 22, 4
    AddMenuEntry 23, 5
    AddMenuEntry 30, 6
    AddMenuEntry 27, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    SetVarFromValue VAR_0x8004, ITEM_FIRE_STONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 1
    SetVarFromValue VAR_0x8004, ITEM_THUNDERSTONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 2
    SetVarFromValue VAR_0x8004, ITEM_WATER_STONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 3
    SetVarFromValue VAR_0x8004, ITEM_LEAF_STONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 4
    SetVarFromValue VAR_0x8004, ITEM_SUN_STONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 5
    SetVarFromValue VAR_0x8004, ITEM_MOON_STONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 6
    SetVarFromValue VAR_0x8004, ITEM_EVERSTONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 7
    GoToIf 1, _0EFF
    End
_0B6C:
    Message msg_0584_T25R0201_00017
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 25, 0
    AddMenuEntry 26, 1
    AddMenuEntry 24, 2
    AddMenuEntry 27, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    SetVarFromValue VAR_0x8004, ITEM_SHINY_STONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 1
    SetVarFromValue VAR_0x8004, ITEM_DUSK_STONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 2
    SetVarFromValue VAR_0x8004, ITEM_DAWN_STONE
    SetVarFromValue VAR_0x8005, 1
    GoToIf 1, _0E7B
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0EFF
    End
_0BFD:
    Message msg_0584_T25R0201_00049
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C08:
    Message msg_0584_T25R0201_00093
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C13:
    Message msg_0584_T25R0201_00082
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C1E:
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F0C
    Message msg_0584_T25R0201_00046
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C3C:
    BufferSpeciesNameFromVar 1, VAR_HGSS_UNK_407F, 0, 0
    BufferPlayerName 0
    PlayFanfare SEQ_FANFA5_sseq
    Message msg_0584_T25R0201_00040
    WaitFanfare
    GivePokemon VAR_HGSS_UNK_407F, 20, 0, VAR_RESULT
    IncrementGameRecord RECORD_POKEMON_RECEIVED_FROM_FOSSIL_REVIVAL
    SetVarFromValue VAR_HGSS_UNK_407F, 0
    Message msg_0584_T25R0201_00041
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F4D
    GetPartyCount VAR_MAP_LOCAL_0x00
    SubVar VAR_MAP_LOCAL_0x00, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_MAP_LOCAL_0x00, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F55
    IncrementGameRecord RECORD_POKEMON_NICKNAMED
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0CC3:
    FindFossilAtThreshold VAR_0x8002, VAR_0x8004, 1
    BufferItemName 0, VAR_0x8002
    Message msg_0584_T25R0201_00039
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F69
    GetSpeciesFromFossil VAR_HGSS_UNK_407F, VAR_0x8002
    RemoveItem VAR_0x8002, 1, VAR_RESULT
    GoTo _0874
_0CFC:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 103
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0D0C:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 101
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0D1C:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 102
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0D2C:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 99
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0D3C:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 100
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0D4C:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 104
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0D5C:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 105
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0D6C:
    AddVar VAR_0x8005, 1
    GoTo _0F78
_0D78:
    SetVarFromVar VAR_MAP_LOCAL_0x01, VAR_MAP_LOCAL_0x00
    Return
_0D80:
    SetVarFromVar VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x00
    Return
_0D88:
    SetVarFromVar VAR_MAP_LOCAL_0x03, VAR_MAP_LOCAL_0x00
    Return
_0D90:
    SetVarFromVar VAR_MAP_LOCAL_0x04, VAR_MAP_LOCAL_0x00
    Return
_0D98:
    SetVarFromVar VAR_MAP_LOCAL_0x05, VAR_MAP_LOCAL_0x00
    Return
_0DA0:
    SetVarFromVar VAR_MAP_LOCAL_0x06, VAR_MAP_LOCAL_0x00
    Return
_0DA8:
    SetVarFromVar VAR_MAP_LOCAL_0x07, VAR_MAP_LOCAL_0x00
    Return
_0DB0:
    AddVar VAR_0x8004, 1
    AddVar VAR_0x8005, 1
    CompareVar VAR_0x8004, VAR_0x8001
    GoToIf 5, _0F78
    AddMenuEntry 45, VAR_0x8004
    ShowMenu
    CompareVar VAR_0x8000, 255
    GoToIf 1, _0F69
    CompareVar VAR_0x8000, 0
    CallIf 1, _1055
    CompareVar VAR_0x8000, 1
    CallIf 1, _105D
    CompareVar VAR_0x8000, 2
    CallIf 1, _1065
    CompareVar VAR_0x8000, 3
    CallIf 1, _106D
    CompareVar VAR_0x8000, 4
    CallIf 1, _1075
    CompareVar VAR_0x8000, 5
    CallIf 1, _107D
    CompareVar VAR_0x8000, 6
    CallIf 1, _1085
    GetSpeciesFromFossil VAR_HGSS_UNK_407F, VAR_0x8002
    CompareVar VAR_HGSS_UNK_407F, 0
    GoToIf 1, _0F69
    BufferItemName 0, VAR_0x8002
    Message msg_0584_T25R0201_00039
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F69
    RemoveItem VAR_0x8002, 1, VAR_RESULT
    GoTo _0874
_0E7B:
    CompareVar VAR_0x8004, 82
    GoToIf 1, _108D
    CompareVar VAR_0x8004, 83
    GoToIf 1, _108D
    CompareVar VAR_0x8004, 84
    GoToIf 1, _108D
    CompareVar VAR_0x8004, 85
    GoToIf 1, _108D
    CompareVar VAR_0x8004, 81
    GoToIf 1, _10A7
    CompareVar VAR_0x8004, 80
    GoToIf 1, _10A7
    CompareVar VAR_0x8004, 229
    GoToIf 1, _10C1
    CompareVar VAR_0x8004, 107
    GoToIf 1, _10DB
    CompareVar VAR_0x8004, 108
    GoToIf 1, _10DB
    CompareVar VAR_0x8004, 109
    GoToIf 1, _10DB
    End
_0EFF:
    HideMoney
    Message msg_0584_T25R0201_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0F0C:
    Message msg_0584_T25R0201_00064
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _10F5
    Message msg_0584_T25R0201_00065
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_CAMPER_MICKEY_7, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _1100
    Message msg_0584_T25R0201_00067
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0F4D:
    ReleaseAll
    End
_0F55:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0F69:
    SetVarFromValue VAR_HGSS_UNK_407F, 0
    Message msg_0584_T25R0201_00034
    GoTo _0A4B
_0F78:
    CompareVar VAR_0x8005, 0
    CallIf 1, _0CFC
    CompareVar VAR_0x8005, 1
    CallIf 1, _0D0C
    CompareVar VAR_0x8005, 2
    CallIf 1, _0D1C
    CompareVar VAR_0x8005, 3
    CallIf 1, _0D2C
    CompareVar VAR_0x8005, 4
    CallIf 1, _0D3C
    CompareVar VAR_0x8005, 5
    CallIf 1, _0D4C
    CompareVar VAR_0x8005, 6
    CallIf 1, _0D5C
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D6C
    CompareVar VAR_0x8004, 0
    CallIf 1, _0D78
    CompareVar VAR_0x8004, 1
    CallIf 1, _0D80
    CompareVar VAR_0x8004, 2
    CallIf 1, _0D88
    CompareVar VAR_0x8004, 3
    CallIf 1, _0D90
    CompareVar VAR_0x8004, 4
    CallIf 1, _0D98
    CompareVar VAR_0x8004, 5
    CallIf 1, _0DA0
    CompareVar VAR_0x8004, 6
    CallIf 1, _0DA8
    SetVarFromVar VAR_0x8006, VAR_0x8005
    AddVar VAR_0x8006, 159
    AddMenuEntry VAR_0x8006, VAR_0x8004
    GoTo _0DB0
_1055:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x01
    Return
_105D:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x02
    Return
_1065:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x03
    Return
_106D:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x04
    Return
_1075:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x05
    Return
_107D:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x06
    Return
_1085:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x07
    Return
_108D:
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    RemoveMoney 3000
    UpdateMoneyDisplay
    Common_GiveItemQuantity
    GoTo _0A57
_10A7:
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    RemoveMoney 5000
    UpdateMoneyDisplay
    Common_GiveItemQuantity
    GoTo _0A57
_10C1:
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    RemoveMoney 1000
    UpdateMoneyDisplay
    Common_GiveItemQuantity
    GoTo _0A57
_10DB:
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    RemoveMoney 10000
    UpdateMoneyDisplay
    Common_GiveItemQuantity
    GoTo _0B6C
_10F5:
    Message msg_0584_T25R0201_00066
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1100:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_1106:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_110C:
    EmoteExclamationMark
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
