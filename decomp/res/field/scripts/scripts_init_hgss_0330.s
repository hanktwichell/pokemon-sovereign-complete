#include "macros/scrcmd.inc"

#define _EV_scr_seq_D31R0201_003 3
#define _EV_scr_seq_D31R0201_004 4
#define _EV_scr_seq_D31R0201_005 5
#define _EV_scr_seq_D31R0201_007 7
#define _EV_scr_seq_D31R0201_021 21
#define _EV_scr_seq_D31R0201_022 22

    InitScriptEntry_OnTransition _EV_scr_seq_D31R0201_021 + 1
    InitScriptEntry_OnResume _EV_scr_seq_D31R0201_022 + 1
    InitScriptEntry_OnFrameTable scr_seq_D31R0201_map_scripts_2
    InitScriptEntryEnd
scr_seq_D31R0201_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_414B, 1, _EV_scr_seq_D31R0201_003 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_414B, 2, _EV_scr_seq_D31R0201_004 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_414B, 3, _EV_scr_seq_D31R0201_007 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_414B, 255, _EV_scr_seq_D31R0201_005 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
