#include "macros/scrcmd.inc"

#define _EV_scr_seq_D24R0205_000 0
#define _EV_scr_seq_D24R0205_001 1
#define _EV_scr_seq_D24R0205_006 6
#define _EV_scr_seq_D24R0205_007 7
#define _EV_scr_seq_D24R0205_008 8
#define _EV_scr_seq_D24R0205_009 9

    InitScriptEntry_OnFrameTable scr_seq_D24R0205_map_scripts_2
    InitScriptEntry_OnResume _EV_scr_seq_D24R0205_001 + 1
    InitScriptEntry_OnTransition _EV_scr_seq_D24R0205_008 + 1
    InitScriptEntryEnd
scr_seq_D24R0205_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40CE, 1, _EV_scr_seq_D24R0205_000 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 2, _EV_scr_seq_D24R0205_006 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 9, _EV_scr_seq_D24R0205_007 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 11, _EV_scr_seq_D24R0205_009 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
