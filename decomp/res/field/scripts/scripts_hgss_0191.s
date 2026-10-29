#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0341.h"

#define obj_R10_gsleader9 0
#define obj_R10_tsure_poke_static_zapdos 1

    ScriptEntry scr_seq_R10_000
    ScriptEntry scr_seq_R10_001
    ScriptEntry scr_seq_R10_002
    ScriptEntry scr_seq_R10_003
    ScriptEntry scr_seq_R10_004
    ScriptEntry scr_seq_R10_005
    ScriptEntry scr_seq_R10_006
    ScriptEntry scr_seq_R10_007
    ScriptEntryEnd
scr_seq_R10_004:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _01B5
    End
scr_seq_R10_001:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 1, _01C3
    GoTo _01FC
scr_seq_R10_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01FE
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0231
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 25
    GoToIf 5, _0231
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _023C
    Message msg_0341_R10_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0245
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0288
    End
scr_seq_R10_000:
    LockAll
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0299
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02F1
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02F1
    CompleteFollowerPutAway
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_BROKEN, 7, 20, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_582 MAP_ROUTE_10, 1423, 185
    ReleaseAll
    End
scr_seq_R10_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ZAPDOS, 0
    WaitCry
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_ZAPDOS, 60, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0325
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _032B
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _032F
    ReleaseAll
    End
scr_seq_R10_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0341_R10_00008, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R10_006:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0341_R10_00009, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R10_007:
    NPCMessage msg_0341_R10_00010
    End
_01B5:
    SetFlag FLAG_HGSS_HIDE_ROUTE_10_ZAPDOS
    RemoveObject obj_R10_tsure_poke_static_zapdos
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_01C3:
    GoToIfUnset FLAG_HGSS_CAUGHT_ZAPDOS, _01FC
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01FC
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _0335
    ClearFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
    GoTo _034C
_01FC:
    End
_01FE:
    Message msg_0341_R10_00002
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
    RemoveObject obj_R10_gsleader9
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0231:
    Message msg_0341_R10_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_023C:
    Message msg_0341_R10_00004
    GoTo _034E
_0245:
    BufferPlayerName 0
    Message msg_0341_R10_00001
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_LT__SURGE
    Message msg_0341_R10_00002
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
    RemoveObject obj_R10_gsleader9
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0288:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0341_R10_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0299:
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0372
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0372
    CompleteFollowerPutAway
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_REPAIRED, 7, 20, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_582 MAP_ROUTE_10, 1423, 185
    ReleaseAll
    End
_02F1:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_BROKEN, 7, 20, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_582 MAP_ROUTE_10, 1423, 185
    ReleaseAll
    End
_0325:
    BlackOutFromBattle
    ReleaseAll
    End
_032B:
    ReleaseAll
    End
_032F:
    SetFlag FLAG_HGSS_CAUGHT_ZAPDOS
    Return
_0335:
    CompareVar VAR_MAP_LOCAL_0x00, 10
    GoToIf 5, _03A6
    ClearFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
    GoTo _034C
_034C:
    End
_034E:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0245
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0288
    End
_0372:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_REPAIRED, 7, 20, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_582 MAP_ROUTE_10, 1423, 185
    ReleaseAll
    End
_03A6:
    CompareVar VAR_MAP_LOCAL_0x00, 11
    GoToIf 5, _03BD
    ClearFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
    GoTo _034C
_03BD:
    SetFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
    End
    .balign 4, 0
