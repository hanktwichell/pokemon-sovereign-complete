#include "macros/scrcmd.inc"

#define _EV_scr_seq_D47R0101_006 6
#define _EV_scr_seq_D47R0101_007 7
#define _EV_scr_seq_D47R0101_008 8
#define _EV_scr_seq_D47R0101_009 9

    InitScriptEntry_OnFrameTable scr_seq_D47R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_D47R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 1, _EV_scr_seq_D47R0101_006 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 3, _EV_scr_seq_D47R0101_006 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 2, _EV_scr_seq_D47R0101_007 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_4057, 1, _EV_scr_seq_D47R0101_008 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_4057, 4, _EV_scr_seq_D47R0101_009 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
