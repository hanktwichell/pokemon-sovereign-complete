#include "macros/scrcmd.inc"

#define _EV_scr_seq_R35R0201_009 9
#define _EV_scr_seq_R35R0201_010 10
#define _EV_scr_seq_R35R0201_012 12

    InitScriptEntry_OnFrameTable scr_seq_R35R0201_map_scripts_2
    InitScriptEntry_OnResume _EV_scr_seq_R35R0201_009 + 1
    InitScriptEntry_OnTransition _EV_scr_seq_R35R0201_012 + 1
    InitScriptEntryEnd
scr_seq_R35R0201_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4118, 1, _EV_scr_seq_R35R0201_010 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
