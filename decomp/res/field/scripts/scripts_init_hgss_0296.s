#include "macros/scrcmd.inc"

#define _EV_scr_seq_D23R0107_000 0

    InitScriptEntry_OnFrameTable scr_seq_D23R0107_map_scripts_2
    InitScriptEntryEnd
scr_seq_D23R0107_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4125, 0, _EV_scr_seq_D23R0107_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
