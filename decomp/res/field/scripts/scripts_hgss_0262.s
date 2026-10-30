#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0427.h"


    ScriptEntry scr_seq_0262_000
    ScriptEntry scr_seq_0262_001
    ScriptEntry scr_seq_0262_002
    ScriptEntry scr_seq_0262_003
    ScriptEntry scr_seq_0262_004
    ScriptEntry scr_seq_0262_005
    ScriptEntry scr_seq_0262_006
    ScriptEntryEnd
scr_seq_0262_000:
    LockAll
    CompleteSafariCanPlaceObject VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _006A
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0049
    Message msg_0427_00008
    GoTo _0062
_0049:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _005F
    Message msg_0427_00009
    GoTo _0062
_005F:
    Message msg_0427_00010
_0062:
    WaitButton
    GoTo _00B5
_006A:
    Message msg_0427_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00B5
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    InitLocalTextListMenu 1, 1, 0, VAR_RESULT
    CompleteSafariAddObjectEntries
    ShowListMenu
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteSafariPlaceObject VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _00B7
    CompleteSafariBufferObjectName 0, VAR_RESULT
    Message msg_0427_00005
    WaitButton
_00B5:
    CloseMessage
_00B7:
    ReleaseAll
    End
scr_seq_0262_001:
    LockAll
    CompleteSafariObjectInFront VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 255
    GoToIf 1, _0114
    CompleteSafariBufferObjectName 0, VAR_0x8000
    Message msg_0427_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0112
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    CompleteSafariRemoveObject VAR_0x8001
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0427_00007
    WaitButton
_0112:
    CloseMessage
_0114:
    ReleaseAll
    End
_011A:
    CompleteSafariZoneAction 1, 0
    CompareVar VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 3
    GoToIf 5, _0155
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_INTERIOR, 19, 2, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _0179
_0155:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_INTERIOR, 5, 2, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0179:
    SetVarFromValue VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 2
    Return
scr_seq_0262_002:
    LockAll
    PlaySE SEQ_SE_DP_PINPON_sseq
    Message msg_0427_00000
    CloseMessage
    Call _011A
    ReleaseAll
    End
scr_seq_0262_003:
    LockAll
    PlaySE SEQ_SE_DP_PINPON_sseq
    Message msg_0427_00001
    CloseMessage
    Call _011A
    ReleaseAll
    End
scr_seq_0262_004:
    LockAll
    PlaySE SEQ_SE_DP_PINPON_sseq
    Message msg_0427_00002
    CloseMessage
    Call _011A
    ReleaseAll
    End
scr_seq_0262_005:
    SetVarFromValue VAR_HGSS_SCENE_SAFARI_ZONE_ENTRANCE, 2
    CompleteSafariZoneAction 1, 0
    End
scr_seq_0262_006:
    LockAll
    Message msg_0427_00003
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01FA
    Call _011A
    ReleaseAll
    End
_01FA:
    ReleaseAll
    End
    .balign 4, 0
