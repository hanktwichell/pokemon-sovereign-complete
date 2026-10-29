#include "macros/scrcmd.inc"

#define _EV_scr_seq_T22_000 0
#define _EV_scr_seq_T22_004 4

    InitScriptEntry_OnFrameTable scr_seq_T22_map_scripts_2
    InitScriptEntryEnd
scr_seq_T22_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_VIOLET_CITY_OW, 1, _EV_scr_seq_T22_000 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_VIOLET_CITY_OW, 3, _EV_scr_seq_T22_004 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
