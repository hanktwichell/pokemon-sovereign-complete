#include "macros/scrcmd.inc"

#define _EV_scr_seq_T11R0603_000 0

    InitScriptEntry_OnFrameTable scr_seq_T11R0603_map_scripts_2
    InitScriptEntryEnd
scr_seq_T11R0603_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_411F, 1, _EV_scr_seq_T11R0603_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
