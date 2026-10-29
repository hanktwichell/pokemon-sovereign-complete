#include "macros/scrcmd.inc"

#define _EV_scr_seq_T27_000 0
#define _EV_scr_seq_T27_012 12
#define _EV_scr_seq_T27_015 15

    InitScriptEntry_OnResume _EV_scr_seq_T27_000 + 1
    InitScriptEntry_OnTransition _EV_scr_seq_T27_015 + 1
    InitScriptEntry_OnFrameTable scr_seq_T27_map_scripts_2
    InitScriptEntryEnd
scr_seq_T27_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4079, 1, _EV_scr_seq_T27_012 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
