#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable scr_seq_T21PC0102_map_scripts_2
    @ HGSS (a standard script with no equivalent yet): InitScriptEntry_OnLoad std_wifi_reset_state
    InitScriptEntryEnd
scr_seq_T21PC0102_map_scripts_2:
    @ HGSS (a standard script with no equivalent yet): InitScriptGoToIfEqual VAR_SCENE_POKECENTER_WIFI_BASEMENT, 0, std_teala_first_intro
    @ HGSS (a standard script with no equivalent yet): InitScriptGoToIfEqual VAR_UNK_4137, 1, std_wifi_return
    InitScriptFrameTableEnd
    InitScriptEnd
