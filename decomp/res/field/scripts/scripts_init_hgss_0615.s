#include "macros/scrcmd.inc"

#define _EV_scr_seq_T20_003 3
#define _EV_scr_seq_T20_006 6
#define _EV_scr_seq_T20_008 8
#define _EV_scr_seq_T20_009 9

    InitScriptEntry_OnFrameTable scr_seq_T20_map_scripts_2
    InitScriptEntry_OnTransition _EV_scr_seq_T20_006 + 1
    InitScriptEntry_OnResume _EV_scr_seq_T20_009 + 1
    InitScriptEntryEnd
scr_seq_T20_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 1, _EV_scr_seq_T20_003 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 1, _EV_scr_seq_T20_008 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
