#include "macros/scrcmd.inc"

#define _EV_scr_seq_T10R0201_000 0
#define _EV_scr_seq_T10R0201_002 2

    InitScriptEntry_OnFrameTable scr_seq_T10R0201_map_scripts_2
    InitScriptEntry_OnLoad _EV_scr_seq_T10R0201_002 + 1
    InitScriptEntryEnd
scr_seq_T10R0201_map_scripts_2:
    InitScriptGoToIfEqual VAR_MAP_LOCAL_0x01, 0, _EV_scr_seq_T10R0201_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
