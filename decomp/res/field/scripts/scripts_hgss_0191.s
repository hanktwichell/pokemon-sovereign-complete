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
    ScriptEntryEnd
scr_seq_R10_004:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _002B
    End
_002B:
    SetFlag FLAG_HGSS_HIDE_ROUTE_10_ZAPDOS
    RemoveObject obj_R10_tsure_poke_static_zapdos
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_R10_001:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 1, _0052
    GoTo _00BF
_0052:
    GoToIfUnset FLAG_HGSS_CAUGHT_ZAPDOS, _00BF
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00BF
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _008B
    ClearFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
    GoTo _00BD
_008B:
    CompareVar VAR_MAP_LOCAL_0x00, 10
    GoToIf 5, _00A2
    ClearFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
    GoTo _00BD
_00A2:
    CompareVar VAR_MAP_LOCAL_0x00, 11
    GoToIf 5, _00B9
    ClearFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
    GoTo _00BD
_00B9:
    SetFlag FLAG_HGSS_HIDE_ROUTE_10_LT_SURGE
_00BD:
    End
_00BF:
    End
scr_seq_R10_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0148
    @ HGSS: PlayerOnBikeCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0197
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 25
    GoToIf 5, _0197
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _018C
    Message msg_0341_R10_00000
_0114:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0138
    CompareVar VAR_RESULT, 1
    GoToIf 4, _017B
    End
_0138:
    BufferPlayerName 0
    Message msg_0341_R10_00001
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_LT__SURGE
_0148:
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
_017B:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0341_R10_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_018C:
    Message msg_0341_R10_00004
    GoTo _0114
    End
_0197:
    Message msg_0341_R10_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R10_000:
    LockAll
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _0209
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01D5
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01D5
    @ HGSS: ScrCmd_600
_01D5:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_BROKEN, 7, 20, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_582 MAP_ROUTE_10, 1423, 185
    ReleaseAll
    End
_0209:
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _022D
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _022D
    @ HGSS: ScrCmd_600
_022D:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_REPAIRED, 7, 20, DIR_NORTH
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
    @ HGSS: WildBattle SPECIES_ZAPDOS, 50, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02B3
    @ HGSS: GetStaticEncounterOutcome VAR_TEMP_x4002
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _02AF
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _02B9
_02AF:
    ReleaseAll
    End
_02B3:
    BlackOutFromBattle
    ReleaseAll
    End
_02B9:
    SetFlag FLAG_HGSS_CAUGHT_ZAPDOS
    Return
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
    .balign 4, 0
