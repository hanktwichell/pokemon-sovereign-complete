#include "macros/scrcmd.inc"

#define _EV_scr_seq_D35R0101_001 1
#define _EV_scr_seq_D35R0101_006 6
#define _EV_scr_seq_D35R0101_008 8

    InitScriptEntry_OnResume _EV_scr_seq_D35R0101_001 + 1
    InitScriptEntry_OnLoad _EV_scr_seq_D35R0101_008 + 1
    InitScriptEntry_OnFrameTable scr_seq_D35R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_D35R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40A8, 1, _EV_scr_seq_D35R0101_006 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
