#include "macros/scrcmd.inc"

#define _EV_scr_seq_R43R0201_001 1
#define _EV_scr_seq_R43R0201_002 2

    InitScriptEntry_OnFrameTable scr_seq_R43R0201_map_scripts_2
    InitScriptEntry_OnTransition _EV_scr_seq_R43R0201_002 + 1
    InitScriptEntryEnd
scr_seq_R43R0201_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_410F, 0, _EV_scr_seq_R43R0201_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
