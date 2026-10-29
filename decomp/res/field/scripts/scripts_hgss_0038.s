#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0073.h"

#define obj_D24R0102_suit 0

    ScriptEntry scr_seq_D24R0102_000
    ScriptEntry scr_seq_D24R0102_001
    ScriptEntry scr_seq_D24R0102_002
    ScriptEntry scr_seq_D24R0102_003
    ScriptEntry scr_seq_D24R0102_004
    ScriptEntry scr_seq_D24R0102_005
    ScriptEntryEnd
scr_seq_D24R0102_005:
    ClearFlag FLAG_HGSS_UNK_10F
    End
scr_seq_D24R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_545 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 28
    GoToIf 1, _0093
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 4, _008A
    GoToIfSet FLAG_HGSS_UNK_10F, _0081
    Message msg_0073_D24R0102_00000
    SetFlag FLAG_HGSS_UNK_10F
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0077
    ApplyMovement obj_D24R0102_suit, _009C
    GoTo _007F
_0077:
    ApplyMovement obj_D24R0102_suit, _00E4
_007F:
    WaitMovement
_0081:
    Message msg_0073_D24R0102_00001
    GoTo _0366
_008A:
    Message msg_0073_D24R0102_00002
    GoTo _0366
_0093:
    Message msg_0073_D24R0102_00003
    GoTo _0366
    .balign 4, 0
_009C:
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_00E4:
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    EmoteExclamationMark
    EndMovement
scr_seq_D24R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 8
    GoToIf 1, _033C
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 1, _02C4
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 4
    GoToIf 4, _0277
    @ HGSS: ScrCmd_545 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02DB
    @ HGSS: CheckSeenAllLetterUnown VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0223
    CompareVar VAR_HGSS_UNK_40EC, 4
    GoToIf 1, _01F6
    CompareVar VAR_HGSS_UNK_40EC, 3
    GoToIf 1, _01D6
    CompareVar VAR_HGSS_UNK_40EC, 2
    GoToIf 1, _01C3
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 1, _01BA
_01B1:
    Message msg_0073_D24R0102_00004
    GoTo _0366
_01BA:
    Message msg_0073_D24R0102_00005
    GoTo _0366
_01C3:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoToIf 1, _035D
    GoTo _02FA
_01D6:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 2
    GoToIf 1, _035D
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoToIf 1, _0303
    GoTo _02FA
_01F6:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 3
    GoToIf 1, _035D
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 2
    GoToIf 1, _030C
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoToIf 1, _0303
    GoTo _02FA
_0223:
    CompareVar VAR_HGSS_UNK_40EC, 0
    GoToIf 1, _01B1
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 1, _01BA
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 4
    GoToIf 1, _035D
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 3
    GoToIf 1, _0315
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 2
    GoToIf 1, _030C
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoToIf 1, _0303
    GoTo _02FA
_0277:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _035D
    CompareVar VAR_HGSS_UNK_40F1, 4
    GoToIf 1, _02B1
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 5
    GoToIf 1, _035D
    CompareVar VAR_HGSS_UNK_40F1, 1
    GoToIf 4, _0321
    GoTo _035D
_02B1:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 5
    GoToIf 1, _032A
    GoTo _0321
_02C4:
    @ HGSS: ScrCmd_545 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 28
    GoToIf 1, _0333
    GoTo _035D
_02DB:
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 1, _02F1
    Message msg_0073_D24R0102_00004
    GoTo _0366
_02F1:
    Message msg_0073_D24R0102_00009
    GoTo _0366
_02FA:
    Message msg_0073_D24R0102_00006
    GoTo _0345
_0303:
    Message msg_0073_D24R0102_00007
    GoTo _0345
_030C:
    Message msg_0073_D24R0102_00008
    GoTo _0345
_0315:
    Message msg_0073_D24R0102_00010
    Message msg_0073_D24R0102_00011
    GoTo _0345
_0321:
    Message msg_0073_D24R0102_00012
    GoTo _0345
_032A:
    Message msg_0073_D24R0102_00013
    GoTo _0345
_0333:
    Message msg_0073_D24R0102_00014
    GoTo _0345
_033C:
    Message msg_0073_D24R0102_00017
    GoTo _0366
_0345:
    BufferPlayerName 0
    Message msg_0073_D24R0102_00016
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    AddVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoTo _0366
_035D:
    Message msg_0073_D24R0102_00015
    GoTo _0366
_0366:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D24R0102_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckSeenAllLetterUnown VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03AA
    @ HGSS: ScrCmd_545 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03A1
    Message msg_0073_D24R0102_00019
    GoTo _0366
_03A1:
    Message msg_0073_D24R0102_00018
    GoTo _0366
_03AA:
    Message msg_0073_D24R0102_00020
    GoTo _0366
scr_seq_D24R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _03EB
    @ HGSS: CheckSeenAllLetterUnown VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03E2
    Message msg_0073_D24R0102_00021
    GoTo _0366
_03E2:
    Message msg_0073_D24R0102_00022
    GoTo _0366
_03EB:
    Message msg_0073_D24R0102_00023
    GoTo _0366
scr_seq_D24R0102_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0073_D24R0102_00024
    GoTo _0366
    .balign 4, 0
