#include "macros/scrcmd.inc"

#define _EV_scr_seq_T20R0101_002 2
#define _EV_scr_seq_T20R0101_010 10
#define _EV_scr_seq_T20R0101_014 14
#define _EV_scr_seq_T20R0101_015 15

    InitScriptEntry_OnResume _EV_scr_seq_T20R0101_010 + 1
    InitScriptEntry_OnFrameTable scr_seq_T20R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_T20R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40FC, 2, _EV_scr_seq_T20R0101_015 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_ELMS_LAB, 3, _EV_scr_seq_T20R0101_002 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_ELMS_LAB, 8, _EV_scr_seq_T20R0101_014 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
