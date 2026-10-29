#include "macros/scrcmd.inc"

#define _EV_scr_seq_T25R0503_000 0

    InitScriptEntry_OnFrameTable scr_seq_T25R0503_map_scripts_2
    InitScriptEntryEnd
scr_seq_T25R0503_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_411E, 1, _EV_scr_seq_T25R0503_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
