#include "macros/scrcmd.inc"

#define _EV_scr_seq_T20R0201_000 0
#define _EV_scr_seq_T20R0201_006 6

    InitScriptEntry_OnFrameTable scr_seq_T20R0201_map_scripts_2
    InitScriptEntryEnd
scr_seq_T20R0201_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 3, _EV_scr_seq_T20R0201_006 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 0, _EV_scr_seq_T20R0201_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
