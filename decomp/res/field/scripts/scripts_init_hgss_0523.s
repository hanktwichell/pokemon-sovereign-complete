#include "macros/scrcmd.inc"

#define _EV_scr_seq_T03_008 8
#define _EV_scr_seq_T03_011 11
#define _EV_scr_seq_T03_012 12
#define _EV_scr_seq_T03_013 13

    InitScriptEntry_OnTransition _EV_scr_seq_T03_008 + 1
    InitScriptEntry_OnLoad _EV_scr_seq_T03_013 + 1
    InitScriptEntry_OnResume _EV_scr_seq_T03_011 + 1
    InitScriptEntry_OnFrameTable scr_seq_T03_map_scripts_2
    InitScriptEntryEnd
scr_seq_T03_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4083, 2, _EV_scr_seq_T03_012 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
