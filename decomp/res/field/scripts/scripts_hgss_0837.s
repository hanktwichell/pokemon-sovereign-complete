#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0537.h"

#define obj_T11R0701_daigo 2

    ScriptEntry scr_seq_T11R0701_000
    ScriptEntry scr_seq_T11R0701_001
    ScriptEntry scr_seq_T11R0701_002
    ScriptEntry scr_seq_T11R0701_003
    ScriptEntry scr_seq_T11R0701_004
    ScriptEntry scr_seq_T11R0701_005
    ScriptEntry scr_seq_T11R0701_006
    ScriptEntry scr_seq_T11R0701_007
    ScriptEntryEnd
scr_seq_T11R0701_002:
    SetVarFromValue VAR_MAP_LOCAL_0x08, 0
    SetVarFromValue VAR_MAP_LOCAL_0x09, 0
    CompareVar VAR_HGSS_UNK_4130, 3
    GoToIf 1, _01F4
    CheckPartyHasSpecies VAR_MAP_LOCAL_0x00, SPECIES_ROTOM
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0247
    SetVarFromValue VAR_MAP_LOCAL_0x09, 1
    ClearFlag FLAG_HGSS_UNK_281
    ClearFlag FLAG_HGSS_UNK_282
    GoToIfSet FLAG_HGSS_TRADE_STEVEN_FORRETRESS_BELDUM, _025F
    CompareVar VAR_HGSS_UNK_4130, 4
    GoToIf 1, _025F
    CompareVar VAR_HGSS_UNK_4130, 1
    GoToIf 3, _025F
    CompareVar VAR_HGSS_UNK_40FD, 0
    GoToIf 1, _025F
    ClearFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    CompareVar VAR_HGSS_UNK_4130, 5
    CallIf 1, _026B
    End
scr_seq_T11R0701_005:
    CompareVar VAR_MAP_LOCAL_0x09, 1
    GoToIf 5, _0271
    SetWarpEventPos 1, 23, 2
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _0299
    CompareVar VAR_HGSS_UNK_4130, 3
    GoToIf 2, _0299
    SetPosition obj_T11R0701_daigo, 6666, 0, 6666, DIR_NORTH
    End
scr_seq_T11R0701_000:
    NPCMessage msg_0537_T11R0701_00000
    End
scr_seq_T11R0701_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_UPGRADE_FROM_SAFFRON_CITY_GUARD, _029B
    Message msg_0537_T11R0701_00001
    SetVar VAR_0x8004, ITEM_UPGRADE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _02A6
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_UPGRADE_FROM_SAFFRON_CITY_GUARD
    Message msg_0537_T11R0701_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T11R0701_004:
    GoToIfSet FLAG_HGSS_GOT_HOENN_STARTER_FROM_STEVEN, _02B0
    CompareVar VAR_HGSS_UNK_4130, 3
    GoToIf 1, _02D4
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_HGSS_UNK_4130, 3
    Message msg_0537_T11R0701_00014
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _02E5
    ApplyMovement obj_T11R0701_daigo, _094F
    GoTo _0300
scr_seq_T11R0701_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0537_T11R0701_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T11R0701_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    FadeOutBGM 0, 5
    PlayMusic SEQ_GS_UTSUGI_RABO_sseq
    Message msg_0537_T11R0701_00031
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _093C
    CompareVar VAR_RESULT, 6
    GoToIf 1, _093C
    GetPlayerStarterSpecies VAR_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 1, _0837
    GetPlayerStarterSpecies VAR_RESULT
    CompareVar VAR_RESULT, 155
    GoToIf 1, _088E
    GoTo _08E5
scr_seq_T11R0701_007:
    End
_01F4:
    SetVarFromValue VAR_MAP_LOCAL_0x09, 1
    ClearFlag FLAG_HGSS_UNK_281
    ClearFlag FLAG_HGSS_UNK_282
    GoToIfSet FLAG_HGSS_TRADE_STEVEN_FORRETRESS_BELDUM, _025F
    CompareVar VAR_HGSS_UNK_4130, 4
    GoToIf 1, _025F
    CompareVar VAR_HGSS_UNK_4130, 1
    GoToIf 3, _025F
    CompareVar VAR_HGSS_UNK_40FD, 0
    GoToIf 1, _025F
    ClearFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    CompareVar VAR_HGSS_UNK_4130, 5
    CallIf 1, _026B
    End
_0247:
    SetFlag FLAG_HGSS_UNK_0A0
    SetFlag FLAG_HGSS_UNK_281
    SetFlag FLAG_HGSS_UNK_282
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    Call _032A
    End
_025F:
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    Call _032A
    End
_026B:
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    Return
_0271:
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _0299
    CompareVar VAR_HGSS_UNK_4130, 3
    GoToIf 2, _0299
    SetPosition obj_T11R0701_daigo, 22, 0, 8, DIR_NORTH
    End
_0299:
    End
_029B:
    Message msg_0537_T11R0701_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02A6:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_02B0:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_UNK_4130, 6
    CompareVar VAR_MAP_LOCAL_0x0A, 77
    GoToIf 5, _0332
    Message msg_0537_T11R0701_00008
    GoTo _03C8
_02D4:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0537_T11R0701_00024
    GoTo _0455
_02E5:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _04C0
    ApplyMovement obj_T11R0701_daigo, _0955
    GoTo _0300
_0300:
    WaitMovement
    ApplyMovement obj_T11R0701_daigo, _095B
    WaitMovement
    Message msg_0537_T11R0701_00015
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _04F2
    ApplyMovement obj_T11R0701_daigo, _094F
    GoTo _050D
_032A:
    SetVarFromValue VAR_MAP_LOCAL_0x08, 1
    Return
_0332:
    Message msg_0537_T11R0701_00007
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 77
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _057D
    Message msg_0537_T11R0701_00009
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _057D
    InitNPCTrade NPC_TRADE_HGSS_ROBOTNIK_BELDUM
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonFriendship VAR_MAP_LOCAL_0x02, VAR_0x8004
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _0588
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    SetFlag FLAG_HGSS_TRADE_STEVEN_FORRETRESS_BELDUM
    CompareVar VAR_MAP_LOCAL_0x02, 200
    GoToIf 0, _0595
    Message msg_0537_T11R0701_00013
    GoTo _05B9
_03C8:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _057D
    Message msg_0537_T11R0701_00009
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _057D
    InitNPCTrade NPC_TRADE_HGSS_ROBOTNIK_BELDUM
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonFriendship VAR_MAP_LOCAL_0x02, VAR_0x8004
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _0588
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    SetFlag FLAG_HGSS_TRADE_STEVEN_FORRETRESS_BELDUM
    CompareVar VAR_MAP_LOCAL_0x02, 200
    GoToIf 0, _0595
    Message msg_0537_T11R0701_00013
    GoTo _05B9
_0455:
    InitLocalTextMenu 1, 1, 0, VAR_0x8004, 1
    AddMenuEntry 17, 0
    AddMenuEntry 18, 1
    AddMenuEntry 19, 2
    AddMenuEntry 27, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_0x8004
    CompareVar VAR_0x8008, 3
    GoToIf 1, _05DA
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _05E5
    CompareVar VAR_0x8004, 0
    GoToIf 5, _05F0
    SetVarFromValue VAR_0x8004, 252
    GoTo _0609
_04C0:
    ApplyMovement obj_T11R0701_daigo, _0961
    WaitMovement
    ApplyMovement obj_T11R0701_daigo, _095B
    WaitMovement
    Message msg_0537_T11R0701_00015
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _04F2
    ApplyMovement obj_T11R0701_daigo, _094F
    GoTo _050D
_04F2:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _066A
    ApplyMovement obj_T11R0701_daigo, _0955
    GoTo _050D
_050D:
    WaitMovement
    Message msg_0537_T11R0701_00016
    InitLocalTextMenu 1, 1, 0, VAR_0x8004, 1
    AddMenuEntry 17, 0
    AddMenuEntry 18, 1
    AddMenuEntry 19, 2
    AddMenuEntry 27, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_0x8004
    CompareVar VAR_0x8008, 3
    GoToIf 1, _05DA
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _05E5
    CompareVar VAR_0x8004, 0
    GoToIf 5, _05F0
    SetVarFromValue VAR_0x8004, 252
    GoTo _0609
_057D:
    Message msg_0537_T11R0701_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0588:
    FinishNPCTrade
    Message msg_0537_T11R0701_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0595:
    Message msg_0537_T11R0701_00012
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _06E2
    ApplyMovement obj_T11R0701_daigo, _0967
    GoTo _0706
_05B9:
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _06E2
    ApplyMovement obj_T11R0701_daigo, _0967
    GoTo _0706
_05DA:
    Message msg_0537_T11R0701_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05E5:
    Message msg_0537_T11R0701_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05F0:
    CompareVar VAR_0x8004, 1
    GoToIf 5, _0722
    SetVarFromValue VAR_0x8004, 255
    GoTo _0609
_0609:
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    BufferPlayerName 0
    Message msg_0537_T11R0701_00020
    PlayFanfare SEQ_ME_POKEGET_sseq
    Message msg_0537_T11R0701_00021
    WaitFanfare
    GivePokemon VAR_0x8004, 5, 0, VAR_RESULT
    Message msg_0537_T11R0701_00025
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0789
    Message msg_0537_T11R0701_00022
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _07D3
    ApplyMovement obj_T11R0701_daigo, _097D
    GoTo _07F7
_066A:
    ApplyMovement obj_T11R0701_daigo, _0961
    WaitMovement
    Message msg_0537_T11R0701_00016
    InitLocalTextMenu 1, 1, 0, VAR_0x8004, 1
    AddMenuEntry 17, 0
    AddMenuEntry 18, 1
    AddMenuEntry 19, 2
    AddMenuEntry 27, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_0x8004
    CompareVar VAR_0x8008, 3
    GoToIf 1, _05DA
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _05E5
    CompareVar VAR_0x8004, 0
    GoToIf 5, _05F0
    SetVarFromValue VAR_0x8004, 252
    GoTo _0609
_06E2:
    ApplyMovement obj_T11R0701_daigo, _0987
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T11R0701_daigo
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    SetVarFromValue VAR_HGSS_UNK_4130, 7
    ReleaseAll
    End
_0706:
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T11R0701_daigo
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    SetVarFromValue VAR_HGSS_UNK_4130, 7
    ReleaseAll
    End
_0722:
    SetVarFromValue VAR_0x8004, 258
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    BufferPlayerName 0
    Message msg_0537_T11R0701_00020
    PlayFanfare SEQ_ME_POKEGET_sseq
    Message msg_0537_T11R0701_00021
    WaitFanfare
    GivePokemon VAR_0x8004, 5, 0, VAR_RESULT
    Message msg_0537_T11R0701_00025
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0789
    Message msg_0537_T11R0701_00022
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _07D3
    ApplyMovement obj_T11R0701_daigo, _097D
    GoTo _07F7
_0789:
    CloseMessage
    GetPartyCount VAR_RESULT
    SubVar VAR_RESULT, 1
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_RESULT, VAR_MAP_LOCAL_0x00
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0813
    Message msg_0537_T11R0701_00026
    GoTo _0813
_07D3:
    ApplyMovement obj_T11R0701_daigo, _0999
    WaitMovement
    RemoveObject obj_T11R0701_daigo
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    SetFlag FLAG_HGSS_GOT_HOENN_STARTER_FROM_STEVEN
    SetVarFromValue VAR_HGSS_UNK_4130, 4
    ClearFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    ReleaseAll
    End
_07F7:
    WaitMovement
    RemoveObject obj_T11R0701_daigo
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    SetFlag FLAG_HGSS_GOT_HOENN_STARTER_FROM_STEVEN
    SetVarFromValue VAR_HGSS_UNK_4130, 4
    ClearFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    ReleaseAll
    End
_0813:
    Message msg_0537_T11R0701_00022
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _07D3
    ApplyMovement obj_T11R0701_daigo, _097D
    GoTo _07F7
_0837:
    GivePokemon SPECIES_CYNDAQUIL, 10, 155, VAR_RESULT
    GivePokemon SPECIES_TOTODILE, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0537_T11R0701_00034
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    Message msg_0537_T11R0701_00037
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 3
    FadeOutBGM 0, 20
    PlayDefaultMusic
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_088E:
    GivePokemon SPECIES_CHIKORITA, 10, 155, VAR_RESULT
    GivePokemon SPECIES_TOTODILE, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0537_T11R0701_00035
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    Message msg_0537_T11R0701_00037
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 3
    FadeOutBGM 0, 20
    PlayDefaultMusic
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_08E5:
    GivePokemon SPECIES_CHIKORITA, 10, 155, VAR_RESULT
    GivePokemon SPECIES_CYNDAQUIL, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0537_T11R0701_00036
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    Message msg_0537_T11R0701_00037
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 3
    FadeOutBGM 0, 20
    PlayDefaultMusic
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_093C:
    FadeOutBGM 0, 20
    PlayDefaultMusic
    Message msg_0537_T11R0701_00038
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_094F:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0955:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_095B:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0961:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0967:
    WalkNormalWest 2
    WalkNormalSouth 5
    WalkNormalWest
    WalkNormalSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_097D:
    WalkNormalSouth 3
    WalkNormalWest 10
    EndMovement
    .balign 4, 0
_0987:
    WalkNormalSouth 5
    WalkNormalWest 3
    WalkNormalSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_0999:
    WalkNormalWest 2
    WalkNormalSouth 3
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
