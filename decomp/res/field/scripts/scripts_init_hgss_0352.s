#include "macros/scrcmd.inc"

#define _EV_scr_seq_D35R0104_001 1
#define _EV_scr_seq_D35R0104_006 6
#define _EV_scr_seq_D35R0104_008 8

    InitScriptEntry_OnTransition _EV_scr_seq_D35R0104_006 + 1
    InitScriptEntry_OnFrameTable scr_seq_D35R0104_map_scripts_2
    InitScriptEntry_OnResume _EV_scr_seq_D35R0104_008 + 1
    InitScriptEntryEnd
scr_seq_D35R0104_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40AC, 0, _EV_scr_seq_D35R0104_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
