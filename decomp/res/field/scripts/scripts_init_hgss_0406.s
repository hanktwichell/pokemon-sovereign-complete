#include "macros/scrcmd.inc"

#define _EV_scr_seq_P01R0301_005 5
#define _EV_scr_seq_P01R0301_006 6
#define _EV_scr_seq_P01R0301_007 7
#define _EV_scr_seq_P01R0301_008 8

    InitScriptEntry_OnResume _EV_scr_seq_P01R0301_006 + 1
    InitScriptEntry_OnTransition _EV_scr_seq_P01R0301_007 + 1
    InitScriptEntry_OnLoad _EV_scr_seq_P01R0301_008 + 1
    InitScriptEntry_OnFrameTable scr_seq_P01R0301_map_scripts_2
    InitScriptEntryEnd
scr_seq_P01R0301_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40DC, 0, _EV_scr_seq_P01R0301_005 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
