#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0580.h"


    ScriptEntry scr_seq_T24R0801_000
    ScriptEntryEnd
scr_seq_T24R0801_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _002B
    GoTo _0031
_0025:
    GoTo _0031
_002B:
    GoTo _0073
_0031:
    CheckItem ITEM_CLEAR_BELL, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0061
    CheckItem ITEM_RAINBOW_WING, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _006A
    GoTo _00B5
_0061:
    Message msg_0580_T24R0801_00003
    GoTo _00B8
_006A:
    Message msg_0580_T24R0801_00001
    GoTo _00B8
_0073:
    CheckItem ITEM_TIDAL_BELL, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _00A3
    CheckItem ITEM_SILVER_WING, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 4, _00AC
    GoTo _00B5
_00A3:
    Message msg_0580_T24R0801_00004
    GoTo _00B8
_00AC:
    Message msg_0580_T24R0801_00002
    GoTo _00B8
_00B5:
    Message msg_0580_T24R0801_00000
_00B8:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
