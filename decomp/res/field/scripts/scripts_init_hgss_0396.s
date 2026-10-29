#include "macros/scrcmd.inc"

#define _EV_scr_seq_D52R0103_001 1
#define _EV_scr_seq_D52R0103_002 2
#define _EV_scr_seq_D52R0103_003 3

    InitScriptEntry_OnFrameTable scr_seq_D52R0103_map_scripts_2
    InitScriptEntry_OnLoad _EV_scr_seq_D52R0103_002 + 1
    InitScriptEntry_OnTransition _EV_scr_seq_D52R0103_003 + 1
    InitScriptEntryEnd
scr_seq_D52R0103_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_EMBEDDED_TOWER, 5, _EV_scr_seq_D52R0103_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
