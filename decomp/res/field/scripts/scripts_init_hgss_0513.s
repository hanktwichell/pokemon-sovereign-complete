#include "macros/scrcmd.inc"

#define _EV_scr_seq_T01R0301_006 6
#define _EV_scr_seq_T01R0301_010 10

    InitScriptEntry_OnTransition _EV_scr_seq_T01R0301_010 + 1
    InitScriptEntry_OnFrameTable scr_seq_T01R0301_map_scripts_2
    InitScriptEntryEnd
scr_seq_T01R0301_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4131, 1, _EV_scr_seq_T01R0301_006 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
