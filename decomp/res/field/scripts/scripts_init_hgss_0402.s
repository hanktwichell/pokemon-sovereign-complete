#include "macros/scrcmd.inc"

#define _EV_scr_seq_P01R0101_001 1
#define _EV_scr_seq_P01R0101_002 2

    InitScriptEntry_OnTransition _EV_scr_seq_P01R0101_001 + 1
    InitScriptEntry_OnFrameTable scr_seq_P01R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_P01R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_411A, 1, _EV_scr_seq_P01R0101_002 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
