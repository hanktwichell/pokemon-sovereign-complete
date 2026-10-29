#include "macros/scrcmd.inc"

#define _EV_scr_seq_T07R0207_000 0

    InitScriptEntry_OnFrameTable scr_seq_T07R0207_map_scripts_2
    InitScriptEntryEnd
scr_seq_T07R0207_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4125, 0, _EV_scr_seq_T07R0207_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
