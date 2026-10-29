#include "macros/scrcmd.inc"

#define _EV_scr_seq_T02_008 8
#define _EV_scr_seq_T02_011 11

    InitScriptEntry_OnTransition _EV_scr_seq_T02_008 + 1
    InitScriptEntry_OnFrameTable scr_seq_T02_map_scripts_2
    InitScriptEntryEnd
scr_seq_T02_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4096, 1, _EV_scr_seq_T02_011 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
