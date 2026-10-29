#include "macros/scrcmd.inc"

#define _EV_scr_seq_R28R0101_002 2

    InitScriptEntry_OnFrameTable scr_seq_R28R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_R28R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4126, 0, _EV_scr_seq_R28R0101_002 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
