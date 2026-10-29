#include "macros/scrcmd.inc"

#define _EV_scr_seq_T04GYM0101_004 4
#define _EV_scr_seq_T04GYM0101_006 6
#define _EV_scr_seq_T04GYM0101_007 7

    InitScriptEntry_OnFrameTable scr_seq_T04GYM0101_map_scripts_2
    InitScriptEntry_OnLoad _EV_scr_seq_T04GYM0101_006 + 1
    InitScriptEntry_OnTransition _EV_scr_seq_T04GYM0101_007 + 1
    InitScriptEntryEnd
scr_seq_T04GYM0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_411C, 1, _EV_scr_seq_T04GYM0101_004 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
