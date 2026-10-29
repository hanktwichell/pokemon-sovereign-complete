#include "macros/scrcmd.inc"

#define _EV_scr_seq_T06_009 9
#define _EV_scr_seq_T06_013 13

    InitScriptEntry_OnTransition _EV_scr_seq_T06_009 + 1
    InitScriptEntry_OnFrameTable scr_seq_T06_map_scripts_2
    InitScriptEntryEnd
scr_seq_T06_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4130, 1, _EV_scr_seq_T06_013 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
