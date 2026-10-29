#include "macros/scrcmd.inc"

#define _EV_scr_seq_T02R0302_002 2
#define _EV_scr_seq_T02R0302_003 3

    @ HGSS (a standard script with no equivalent yet): InitScriptEntry_OnTransition std_trainer_house_reset
    InitScriptEntry_OnFrameTable scr_seq_T02R0302_map_scripts_2
    InitScriptEntryEnd
scr_seq_T02R0302_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_412E, 0, _EV_scr_seq_T02R0302_002 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_412E, 5, _EV_scr_seq_T02R0302_003 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
