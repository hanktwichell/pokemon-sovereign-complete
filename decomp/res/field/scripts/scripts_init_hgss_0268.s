#include "macros/scrcmd.inc"

#define _EV_scr_seq_D02R0101_000 0

    InitScriptEntry_OnFrameTable scr_seq_D02R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_D02R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40F5, 0, _EV_scr_seq_D02R0101_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
