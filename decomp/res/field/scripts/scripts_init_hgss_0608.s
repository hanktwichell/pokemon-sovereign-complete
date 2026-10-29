#include "macros/scrcmd.inc"

#define _EV_scr_seq_T11R0602_000 0

    InitScriptEntry_OnFrameTable scr_seq_T11R0602_map_scripts_2
    InitScriptEntryEnd
scr_seq_T11R0602_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_411F, 0, _EV_scr_seq_T11R0602_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
