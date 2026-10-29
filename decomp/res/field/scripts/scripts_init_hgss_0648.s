#include "macros/scrcmd.inc"

#define _EV_scr_seq_T24_005 5
#define _EV_scr_seq_T24_006 6

    InitScriptEntry_OnTransition _EV_scr_seq_T24_005 + 1
    InitScriptEntry_OnFrameTable scr_seq_T24_map_scripts_2
    InitScriptEntryEnd
scr_seq_T24_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4116, 1, _EV_scr_seq_T24_006 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
