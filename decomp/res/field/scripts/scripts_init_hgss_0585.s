#include "macros/scrcmd.inc"

#define _EV_scr_seq_T08R0201_000 0
#define _EV_scr_seq_T08R0201_001 1
#define _EV_scr_seq_T08R0201_002 2

    InitScriptEntry_OnTransition _EV_scr_seq_T08R0201_000 + 1
    InitScriptEntry_OnFrameTable scr_seq_T08R0201_map_scripts_2
    InitScriptEntryEnd
scr_seq_T08R0201_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4124, 1, _EV_scr_seq_T08R0201_001 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_4124, 2, _EV_scr_seq_T08R0201_002 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
