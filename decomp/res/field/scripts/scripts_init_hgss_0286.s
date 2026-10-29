#include "macros/scrcmd.inc"

#define _EV_scr_seq_D22R0101_011 11
#define _EV_scr_seq_D22R0101_025 25

    InitScriptEntry_OnFrameTable scr_seq_D22R0101_map_scripts_2
    InitScriptEntry_OnResume _EV_scr_seq_D22R0101_011 + 1
    InitScriptEntry_OnTransition _EV_scr_seq_D22R0101_025 + 1
    InitScriptEntryEnd
scr_seq_D22R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40F7, 1, 11007
    InitScriptFrameTableEnd
    InitScriptEnd
