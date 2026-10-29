#include "macros/scrcmd.inc"

#define _EV_scr_seq_T10R0601_001 1
#define _EV_scr_seq_T10R0601_002 2

    InitScriptEntry_OnFrameTable scr_seq_T10R0601_map_scripts_2
    InitScriptEntry_OnTransition _EV_scr_seq_T10R0601_002 + 1
    InitScriptEntryEnd
scr_seq_T10R0601_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40C8, 0, _EV_scr_seq_T10R0601_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
