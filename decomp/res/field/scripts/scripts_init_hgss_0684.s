#include "macros/scrcmd.inc"

#define _EV_scr_seq_T26_002 2
#define _EV_scr_seq_T26_003 3
#define _EV_scr_seq_T26_012 12

    InitScriptEntry_OnTransition _EV_scr_seq_T26_012 + 1
    InitScriptEntry_OnFrameTable scr_seq_T26_map_scripts_2
    InitScriptEntryEnd
scr_seq_T26_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_MIDGAME_BADGES, 4, _EV_scr_seq_T26_002 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE, 2, _EV_scr_seq_T26_003 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
