#include "macros/scrcmd.inc"

#define _EV_scr_seq_T30_005 5
#define _EV_scr_seq_T30_007 7

    InitScriptEntry_OnTransition _EV_scr_seq_T30_005 + 1
    InitScriptEntry_OnFrameTable scr_seq_T30_map_scripts_2
    InitScriptEntryEnd
scr_seq_T30_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_407B, 1, _EV_scr_seq_T30_007 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
