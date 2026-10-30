#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0073.h"

#define obj_D24R0102_suit 0

    ScriptEntry scr_seq_D24R0102_000
    ScriptEntry scr_seq_D24R0102_001
    ScriptEntry scr_seq_D24R0102_002
    ScriptEntry scr_seq_D24R0102_003
    ScriptEntry scr_seq_D24R0102_004
    ScriptEntry scr_seq_D24R0102_005
    ScriptEntry scr_seq_D24R0102_006
    ScriptEntryEnd
scr_seq_D24R0102_005:
    ClearFlag FLAG_HGSS_UNK_10F
    End
scr_seq_D24R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetUnownFormsSeenCount VAR_RESULT
    CompareVar VAR_RESULT, 28
    GoToIf 1, _01AF
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 4, _01B8
    GoToIfSet FLAG_HGSS_UNK_10F, _01C1
    Message msg_0073_D24R0102_00000
    SetFlag FLAG_HGSS_UNK_10F
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01CA
    ApplyMovement obj_D24R0102_suit, _0706
    GoTo _01DD
scr_seq_D24R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 8
    GoToIf 1, _01E8
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 1, _01F1
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 4
    GoToIf 4, _0208
    GetUnownFormsSeenCount VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0242
    CompleteCheckSeenAllUnownLetters VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0258
    CompareVar VAR_HGSS_UNK_40EC, 4
    GoToIf 1, _02AC
    CompareVar VAR_HGSS_UNK_40EC, 3
    GoToIf 1, _02D9
    CompareVar VAR_HGSS_UNK_40EC, 2
    GoToIf 1, _02F9
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 1, _030C
    Message msg_0073_D24R0102_00004
    GoTo _0315
scr_seq_D24R0102_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckSeenAllUnownLetters VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _031D
    GetUnownFormsSeenCount VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0326
    Message msg_0073_D24R0102_00019
    GoTo _0315
scr_seq_D24R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _032F
    CompleteCheckSeenAllUnownLetters VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0338
    Message msg_0073_D24R0102_00021
    GoTo _0315
scr_seq_D24R0102_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0073_D24R0102_00024
    GoTo _0315
scr_seq_D24R0102_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3FA6, _0341
    CheckItem ITEM_UNOWN_REPORT, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _034C
    Message msg_0073_D24R0102_00026
    WaitButton
    GoTo _0357
_01AF:
    Message msg_0073_D24R0102_00003
    GoTo _0315
_01B8:
    Message msg_0073_D24R0102_00002
    GoTo _0315
_01C1:
    Message msg_0073_D24R0102_00001
    GoTo _0315
_01CA:
    ApplyMovement obj_D24R0102_suit, _074C
    WaitMovement
    Message msg_0073_D24R0102_00001
    GoTo _0315
_01DD:
    WaitMovement
    Message msg_0073_D24R0102_00001
    GoTo _0315
_01E8:
    Message msg_0073_D24R0102_00017
    GoTo _0315
_01F1:
    GetUnownFormsSeenCount VAR_RESULT
    CompareVar VAR_RESULT, 28
    GoToIf 1, _048A
    GoTo _0493
_0208:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _0493
    CompareVar VAR_HGSS_UNK_40F1, 4
    GoToIf 1, _049C
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 5
    GoToIf 1, _0493
    CompareVar VAR_HGSS_UNK_40F1, 1
    GoToIf 4, _04AF
    GoTo _0493
_0242:
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 1, _04B8
    Message msg_0073_D24R0102_00004
    GoTo _0315
_0258:
    CompareVar VAR_HGSS_UNK_40EC, 0
    GoToIf 1, _04C1
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 1, _030C
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 4
    GoToIf 1, _0493
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 3
    GoToIf 1, _04CA
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 2
    GoToIf 1, _04D6
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoToIf 1, _04DF
    GoTo _04E8
_02AC:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 3
    GoToIf 1, _0493
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 2
    GoToIf 1, _04D6
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoToIf 1, _04DF
    GoTo _04E8
_02D9:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 2
    GoToIf 1, _0493
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoToIf 1, _04DF
    GoTo _04E8
_02F9:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoToIf 1, _0493
    GoTo _04E8
_030C:
    Message msg_0073_D24R0102_00005
    GoTo _0315
_0315:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_031D:
    Message msg_0073_D24R0102_00020
    GoTo _0315
_0326:
    Message msg_0073_D24R0102_00018
    GoTo _0315
_032F:
    Message msg_0073_D24R0102_00023
    GoTo _0315
_0338:
    Message msg_0073_D24R0102_00022
    GoTo _0315
_0341:
    Message msg_0073_D24R0102_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
_034C:
    Message msg_0073_D24R0102_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0357:
    GoToIfSet FLAG_HGSS_SG_3FA9, _04F1
    GetUnownFormsSeenCount VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 8
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 9
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 10
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 11
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 12
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 13
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 14
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 15
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 16
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 17
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 18
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 19
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 20
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 21
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 22
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 23
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 24
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 25
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 26
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 27
    GoToIf 1, _05C9
    CompareVar VAR_RESULT, 28
    GoToIf 1, _05C9
    CloseMessage
    ReleaseAll
    End
_048A:
    Message msg_0073_D24R0102_00014
    GoTo _05EB
_0493:
    Message msg_0073_D24R0102_00015
    GoTo _0315
_049C:
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 5
    GoToIf 1, _0603
    GoTo _04AF
_04AF:
    Message msg_0073_D24R0102_00012
    GoTo _05EB
_04B8:
    Message msg_0073_D24R0102_00009
    GoTo _0315
_04C1:
    Message msg_0073_D24R0102_00004
    GoTo _0315
_04CA:
    Message msg_0073_D24R0102_00010
    Message msg_0073_D24R0102_00011
    GoTo _05EB
_04D6:
    Message msg_0073_D24R0102_00008
    GoTo _05EB
_04DF:
    Message msg_0073_D24R0102_00007
    GoTo _05EB
_04E8:
    Message msg_0073_D24R0102_00006
    GoTo _05EB
_04F1:
    GoToIfSet FLAG_HGSS_SG_3FA8, _060C
    GetUnownFormsSeenCount VAR_RESULT
    CompareVar VAR_RESULT, 14
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 15
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 16
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 17
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 18
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 19
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 20
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 21
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 22
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 23
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 24
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 25
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 26
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 27
    GoToIf 1, _0689
    CompareVar VAR_RESULT, 28
    GoToIf 1, _0689
    CloseMessage
    ReleaseAll
    End
_05C9:
    Message msg_0073_D24R0102_00027
    SetVar VAR_0x8004, ITEM_TM10
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0073_D24R0102_00028
    SetFlag FLAG_HGSS_SG_3FA9
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05EB:
    BufferPlayerName 0
    Message msg_0073_D24R0102_00016
    PlayFanfare SEQ_ME_LVUP_sseq
    WaitFanfare
    AddVar VAR_HGSS_UNOWN_REPORT_LEVEL, 1
    GoTo _0315
_0603:
    Message msg_0073_D24R0102_00013
    GoTo _05EB
_060C:
    GoToIfSet FLAG_HGSS_SG_3FA7, _06AB
    GetUnownFormsSeenCount VAR_RESULT
    CompareVar VAR_RESULT, 21
    GoToIf 1, _06C2
    CompareVar VAR_RESULT, 22
    GoToIf 1, _06C2
    CompareVar VAR_RESULT, 23
    GoToIf 1, _06C2
    CompareVar VAR_RESULT, 24
    GoToIf 1, _06C2
    CompareVar VAR_RESULT, 25
    GoToIf 1, _06C2
    CompareVar VAR_RESULT, 26
    GoToIf 1, _06C2
    CompareVar VAR_RESULT, 27
    GoToIf 1, _06C2
    CompareVar VAR_RESULT, 28
    GoToIf 1, _06C2
    CloseMessage
    ReleaseAll
    End
_0689:
    Message msg_0073_D24R0102_00029
    SetVar VAR_0x8004, ITEM_UPGRADE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0073_D24R0102_00030
    SetFlag FLAG_HGSS_SG_3FA8
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06AB:
    GetUnownFormsSeenCount VAR_RESULT
    CompareVar VAR_RESULT, 28
    GoToIf 1, _06E4
    CloseMessage
    ReleaseAll
    End
_06C2:
    Message msg_0073_D24R0102_00031
    SetVar VAR_0x8004, ITEM_LUCKY_EGG
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0073_D24R0102_00034
    SetFlag FLAG_HGSS_SG_3FA7
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06E4:
    Message msg_0073_D24R0102_00033
    SetVar VAR_0x8004, ITEM_MASTER_BALL
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0073_D24R0102_00032
    SetFlag FLAG_HGSS_SG_3FA6
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0706:
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
_074C:
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
    .balign 4, 0
