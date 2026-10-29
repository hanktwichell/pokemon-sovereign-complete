#include "macros/scrcmd.inc"

#define _EV_scr_seq_T27R0501_013 13
#define _EV_scr_seq_T27R0501_015 15
#define _EV_scr_seq_T27R0501_016 16

    InitScriptEntry_OnResume _EV_scr_seq_T27R0501_013 + 1
    InitScriptEntry_OnFrameTable scr_seq_T27R0501_map_scripts_2
    InitScriptEntryEnd
scr_seq_T27R0501_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_410C, 0, _EV_scr_seq_T27R0501_015 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_410C, 4, _EV_scr_seq_T27R0501_016 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
