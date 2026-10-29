#include "macros/scrcmd.inc"

#define _EV_scr_seq_R30_001 1

    InitScriptEntry_OnFrameTable scr_seq_R30_map_scripts_2
    InitScriptEntryEnd
scr_seq_R30_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_ROUTE_30_OW, 2, _EV_scr_seq_R30_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
