#include "macros/scrcmd.inc"

#define _EV_scr_seq_D24R0218_001 1
#define _EV_scr_seq_D24R0218_002 2
#define _EV_scr_seq_D24R0218_003 3
#define _EV_scr_seq_D24R0218_004 4
#define _EV_scr_seq_D24R0218_005 5
#define _EV_scr_seq_D24R0218_006 6

    InitScriptEntry_OnFrameTable scr_seq_D24R0218_map_scripts_2
    InitScriptEntry_OnTransition _EV_scr_seq_D24R0218_004 + 1
    InitScriptEntry_OnResume _EV_scr_seq_D24R0218_005 + 1
    InitScriptEntryEnd
scr_seq_D24R0218_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 2, _EV_scr_seq_D24R0218_001 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 9, _EV_scr_seq_D24R0218_002 + 1
    InitScriptGoToIfEqual VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 11, _EV_scr_seq_D24R0218_003 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_40CE, 1, _EV_scr_seq_D24R0218_006 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
