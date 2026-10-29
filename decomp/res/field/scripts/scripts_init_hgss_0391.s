#include "macros/scrcmd.inc"

#define _EV_scr_seq_D51R0101_000 0
#define _EV_scr_seq_D51R0101_002 2

    InitScriptEntry_OnFrameTable scr_seq_D51R0101_map_scripts_2
    InitScriptEntry_OnResume _EV_scr_seq_D51R0101_002 + 1
    InitScriptEntryEnd
scr_seq_D51R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 4, _EV_scr_seq_D51R0101_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
