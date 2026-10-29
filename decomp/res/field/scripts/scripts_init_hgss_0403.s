#include "macros/scrcmd.inc"

#define _EV_scr_seq_P01R0102_001 1
#define _EV_scr_seq_P01R0102_002 2
#define _EV_scr_seq_P01R0102_005 5

    InitScriptEntry_OnResume _EV_scr_seq_P01R0102_001 + 1
    InitScriptEntry_OnFrameTable scr_seq_P01R0102_map_scripts_2
    InitScriptEntry_OnTransition _EV_scr_seq_P01R0102_005 + 1
    InitScriptEntryEnd
scr_seq_P01R0102_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_BOAT_DIRECTION, 2, _EV_scr_seq_P01R0102_002 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
