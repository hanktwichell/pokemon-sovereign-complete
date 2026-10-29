#include "macros/scrcmd.inc"

#define _EV_scr_seq_D48R0101_004 4
#define _EV_scr_seq_D48R0101_005 5
#define _EV_scr_seq_D48R0101_006 6

    InitScriptEntry_OnFrameTable scr_seq_D48R0101_map_scripts_2
    InitScriptEntry_OnTransition _EV_scr_seq_D48R0101_005 + 1
    InitScriptEntry_OnResume _EV_scr_seq_D48R0101_006 + 1
    InitScriptEntryEnd
scr_seq_D48R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_EMBEDDED_TOWER, 2, _EV_scr_seq_D48R0101_004 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
