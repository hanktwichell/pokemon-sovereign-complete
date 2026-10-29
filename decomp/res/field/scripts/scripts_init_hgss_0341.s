#include "macros/scrcmd.inc"

#define _EV_scr_seq_D32R0101_000 0
#define _EV_scr_seq_D32R0101_011 11

    InitScriptEntry_OnTransition _EV_scr_seq_D32R0101_011 + 1
    InitScriptEntry_OnFrameTable scr_seq_D32R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_D32R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40E6, 0, _EV_scr_seq_D32R0101_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
