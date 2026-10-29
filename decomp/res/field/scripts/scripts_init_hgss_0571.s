#include "macros/scrcmd.inc"

#define _EV_scr_seq_T07R0203_008 8
#define _EV_scr_seq_T07R0203_010 10
#define _EV_scr_seq_T07R0203_011 11

    InitScriptEntry_OnTransition _EV_scr_seq_T07R0203_008 + 1
    InitScriptEntry_OnResume _EV_scr_seq_T07R0203_011 + 1
    InitScriptEntry_OnFrameTable scr_seq_T07R0203_map_scripts_2
    InitScriptEntryEnd
scr_seq_T07R0203_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_412C, 0, _EV_scr_seq_T07R0203_010 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
