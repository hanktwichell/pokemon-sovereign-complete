#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 1
    InitScriptEntry_OnLoad 24
    InitScriptEntry_OnFrameTable InitScriptFrameTable
    InitScriptEntryEnd

InitScriptFrameTable:
    InitScriptGoToIfEqual VAR_PLAYER_HOUSE_SPECIAL_PROGRAM_STATE, 0, 26 @ Sovereign Complete: the first ship lands
    InitScriptGoToIfEqual VAR_CANALAVE_CITY_STATE, 2, 4
    InitScriptGoToIfEqual VAR_CANALAVE_CITY_STATE, 4, 5
    InitScriptGoToIfEqual VAR_DARKRAI_EVENT_STATE, 3, 23
    InitScriptFrameTableEnd

    InitScriptEnd
