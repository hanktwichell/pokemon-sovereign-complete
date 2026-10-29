#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0326.h"


    ScriptEntry scr_seq_R03_000
    ScriptEntry scr_seq_R03_001
    ScriptEntry scr_seq_R03_002
    ScriptEntry scr_seq_R03_003
    ScriptEntry scr_seq_R03_004
    ScriptEntryEnd
scr_seq_R03_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_517 SPECIES_DEOXYS, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02DF
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 386
    GoToIf 1, _0050
    @ HGSS: ScrCmd_518 3
    GoTo _00BE
_0050:
    @ HGSS: ScrCmd_518 3
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_ROUTE_3, VAR_0x8006, VAR_0x8007, VAR_RESULT
    @ HGSS: PlayerOnBikeCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00B2
    CompareVar VAR_RESULT, 1
    GoToIf 5, _009E
    @ HGSS: ScrCmd_605 0, 1
    GoTo _00A2
_009E:
    @ HGSS: ScrCmd_605 3, 2
_00A2:
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
_00B2:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_00BE:
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00002
    GoTo _02D5
scr_seq_R03_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_517 SPECIES_DEOXYS, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02DF
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 386
    GoToIf 1, _0107
    @ HGSS: ScrCmd_518 2
    GoTo _018C
_0107:
    @ HGSS: ScrCmd_518 2
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_ROUTE_3, VAR_0x8006, VAR_0x8007, VAR_RESULT
    @ HGSS: PlayerOnBikeCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0180
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0155
    @ HGSS: ScrCmd_605 0, 1
    GoTo _0170
_0155:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _016C
    @ HGSS: ScrCmd_605 0, 1
    GoTo _0170
_016C:
    @ HGSS: ScrCmd_605 3, 2
_0170:
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
_0180:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_018C:
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00003
    GoTo _02D5
scr_seq_R03_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_517 SPECIES_DEOXYS, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02DF
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 386
    GoToIf 1, _01D5
    @ HGSS: ScrCmd_518 1
    GoTo _022C
_01D5:
    @ HGSS: ScrCmd_518 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_ROUTE_3, VAR_0x8006, VAR_0x8007, VAR_RESULT
    @ HGSS: PlayerOnBikeCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0220
    @ HGSS: ScrCmd_605 2, 3
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
_0220:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_022C:
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00004
    GoTo _02D5
scr_seq_R03_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_517 SPECIES_DEOXYS, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02DF
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 386
    GoToIf 1, _0275
    @ HGSS: ScrCmd_518 0
    GoTo _02CC
_0275:
    @ HGSS: ScrCmd_518 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_ROUTE_3, VAR_0x8006, VAR_0x8007, VAR_RESULT
    @ HGSS: PlayerOnBikeCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02C0
    @ HGSS: ScrCmd_605 3, 2
    CompleteFollowerPause 0
    @ HGSS: ScrCmd_608
    WaitTime 10, VAR_RESULT
    CompleteFollowerPause 1
_02C0:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_02CC:
    PlayCry SPECIES_DEOXYS, 0
    Message msg_0326_R03_00005
_02D5:
    WaitButton
    WaitCry
    CloseMessage
    ReleaseAll
    End
_02DF:
    Message msg_0326_R03_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R03_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0326_R03_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
