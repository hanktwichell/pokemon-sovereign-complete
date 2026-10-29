#include "macros/scrcmd.inc"

#define _EV_scr_seq_T28_005 5

    InitScriptEntry_OnFrameTable scr_seq_T28_map_scripts_2
    InitScriptEntryEnd
scr_seq_T28_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_MIDGAME_BADGES, 4, _EV_scr_seq_T28_005 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
