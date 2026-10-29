#include "macros/scrcmd.inc"

#define _EV_scr_seq_P01R0306_001 1
#define _EV_scr_seq_P01R0306_003 3

    InitScriptEntry_OnTransition _EV_scr_seq_P01R0306_001 + 1
    InitScriptEntry_OnFrameTable scr_seq_P01R0306_map_scripts_2
    InitScriptEntryEnd
scr_seq_P01R0306_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SS_AQUA, 5, _EV_scr_seq_P01R0306_003 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
