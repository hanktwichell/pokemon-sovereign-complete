#include "macros/scrcmd.inc"

#define _EV_scr_seq_T11R0703_000 0

    InitScriptEntry_OnFrameTable scr_seq_T11R0703_map_scripts_2
    InitScriptEntryEnd
scr_seq_T11R0703_map_scripts_2:
    InitScriptGoToIfEqual VAR_MAP_LOCAL_0x01, 0, _EV_scr_seq_T11R0703_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
