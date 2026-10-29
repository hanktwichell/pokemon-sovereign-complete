#include "macros/scrcmd.inc"

#define _EV_scr_seq_T27PC0101_001 1

    @ HGSS (a standard script with no equivalent yet): InitScriptEntry_OnResume std_wireless_reset_state
    InitScriptEntry_OnFrameTable scr_seq_T27PC0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_T27PC0101_map_scripts_2:
    @ HGSS (a standard script with no equivalent yet): InitScriptGoToIfEqual VAR_UNK_4133, 2, std_union_room_return
    @ HGSS (a standard script with no equivalent yet): InitScriptGoToIfEqual VAR_UNK_4133, 1, std_wireless_colosseum_return
    InitScriptGoToIfEqual VAR_HGSS_UNK_410D, 0, _EV_scr_seq_T27PC0101_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
