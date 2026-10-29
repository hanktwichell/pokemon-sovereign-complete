#include "macros/scrcmd.inc"

#define _EV_scr_seq_R30R0201_001 1
#define _EV_scr_seq_R30R0201_002 2
#define _EV_scr_seq_R30R0201_003 3

    InitScriptEntry_OnFrameTable scr_seq_R30R0201_map_scripts_2
    InitScriptEntry_OnResume _EV_scr_seq_R30R0201_003 + 1
    InitScriptEntryEnd
scr_seq_R30R0201_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_EMBEDDED_TOWER, 1, _EV_scr_seq_R30R0201_002 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_MR_POKEMONS_HOUSE, 0, _EV_scr_seq_R30R0201_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
