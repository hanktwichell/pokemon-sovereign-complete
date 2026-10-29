#include "macros/scrcmd.inc"

#define _EV_scr_seq_D37R0101_002 2
#define _EV_scr_seq_D37R0101_003 3

    InitScriptEntry_OnTransition _EV_scr_seq_D37R0101_003 + 1
    InitScriptEntry_OnFrameTable scr_seq_D37R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_D37R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40F8, 0, _EV_scr_seq_D37R0101_002 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
