#include "macros/scrcmd.inc"


    ScriptEntry scr_seq_D02R0102_000
    ScriptEntryEnd
scr_seq_D02R0102_000:
    GoToIfSet FLAG_HGSS_UNK_AB5, _004D
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _002E
    GoTo _004F
    GoTo _004D
_002E:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0047
    GoTo _008E
    GoTo _004D
_0047:
    GoTo _004D
_004D:
    End
_004F:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _0086
    SetWarpEventPos 1, 1, 7
    SetWarpEventPos 4, 5, 6
    SetWarpEventPos 2, 1, 26
    SetWarpEventPos 5, 5, 25
    GoTo _008C
_0086:
    GoTo _004D
_008C:
    End
_008E:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 5, _00C5
    SetWarpEventPos 1, 1, 7
    SetWarpEventPos 4, 5, 6
    SetWarpEventPos 2, 1, 26
    SetWarpEventPos 5, 5, 25
    GoTo _00CB
_00C5:
    GoTo _004D
_00CB:
    End
    End
    .balign 4, 0
