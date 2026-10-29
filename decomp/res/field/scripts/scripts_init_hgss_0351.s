#include "macros/scrcmd.inc"

#define _EV_scr_seq_D35R0103_000 0
#define _EV_scr_seq_D35R0103_002 2
#define _EV_scr_seq_D35R0103_007 7

    InitScriptEntry_OnResume _EV_scr_seq_D35R0103_002 + 1
    InitScriptEntry_OnLoad _EV_scr_seq_D35R0103_007 + 1
    InitScriptEntry_OnFrameTable scr_seq_D35R0103_map_scripts_2
    InitScriptEntryEnd
scr_seq_D35R0103_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40A9, 0, _EV_scr_seq_D35R0103_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
