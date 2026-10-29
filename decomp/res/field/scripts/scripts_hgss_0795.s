#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0500.h"

#define obj_T07R0107_gswoman6 0

    ScriptEntry scr_seq_T07R0107_000
    ScriptEntryEnd
scr_seq_T07R0107_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0068
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0072
    CompareVar VAR_0x8008, 3
    GoToIf 1, _007C
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0086
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0090
    CompareVar VAR_0x8008, 0
    GoToIf 1, _009A
    End
_0068:
    CompleteBufferFloorName 0, 6
    GoTo _00A4
_0072:
    CompleteBufferFloorName 0, 5
    GoTo _00A4
_007C:
    CompleteBufferFloorName 0, 4
    GoTo _00A4
_0086:
    CompleteBufferFloorName 0, 3
    GoTo _00A4
_0090:
    CompleteBufferFloorName 0, 2
    GoTo _00A4
_009A:
    CompleteBufferFloorName 0, 1
    GoTo _00A4
_00A4:
    ShowCurrentFloor 20, 1, VAR_HGSS_ELEVATOR_LAST_FLOOR
    Message msg_0500_T07R0107_00000
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 121, 6
    AddMenuEntry 120, 0
    AddMenuEntry 119, 1
    AddMenuEntry 118, 2
    AddMenuEntry 117, 3
    AddMenuEntry 116, 4
    AddMenuEntry 126, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 6
    GoToIf 1, _052D
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0467
    CompareVar VAR_0x8008, 1
    GoToIf 1, _03A1
    CompareVar VAR_0x8008, 2
    GoToIf 1, _02DB
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0215
    CompareVar VAR_0x8008, 4
    GoToIf 1, _014F
    GoTo _06DE
_014F:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_1F, 2, 5, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 1, _06C7
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    CallIf 2, _05FE
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    CallIf 0, _05F3
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _01A5
    SetVarFromValue VAR_0x8005, 1
    GoTo _0203
_01A5:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _01BE
    SetVarFromValue VAR_0x8005, 2
    GoTo _0203
_01BE:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _01D7
    SetVarFromValue VAR_0x8005, 3
    GoTo _0203
_01D7:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _01F0
    SetVarFromValue VAR_0x8005, 4
    GoTo _0203
_01F0:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _0203
    SetVarFromValue VAR_0x8005, 5
_0203:
    Call _0609
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoTo _0627
_0215:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_2F, 2, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 1, _06C7
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    CallIf 2, _05FE
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    CallIf 0, _05F3
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _026B
    SetVarFromValue VAR_0x8005, 1
    GoTo _02C9
_026B:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _0284
    SetVarFromValue VAR_0x8005, 1
    GoTo _02C9
_0284:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _029D
    SetVarFromValue VAR_0x8005, 2
    GoTo _02C9
_029D:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _02B6
    SetVarFromValue VAR_0x8005, 3
    GoTo _02C9
_02B6:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _02C9
    SetVarFromValue VAR_0x8005, 4
_02C9:
    Call _0609
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoTo _0627
_02DB:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_3F, 2, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 1, _06C7
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    CallIf 2, _05FE
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    CallIf 0, _05F3
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _0331
    SetVarFromValue VAR_0x8005, 2
    GoTo _038F
_0331:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _034A
    SetVarFromValue VAR_0x8005, 1
    GoTo _038F
_034A:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _0363
    SetVarFromValue VAR_0x8005, 1
    GoTo _038F
_0363:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _037C
    SetVarFromValue VAR_0x8005, 2
    GoTo _038F
_037C:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _038F
    SetVarFromValue VAR_0x8005, 3
_038F:
    Call _0609
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoTo _0627
_03A1:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_4F, 2, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 1, _06C7
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    CallIf 2, _05FE
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    CallIf 0, _05F3
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _03F7
    SetVarFromValue VAR_0x8005, 3
    GoTo _0455
_03F7:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _0410
    SetVarFromValue VAR_0x8005, 2
    GoTo _0455
_0410:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _0429
    SetVarFromValue VAR_0x8005, 1
    GoTo _0455
_0429:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _0442
    SetVarFromValue VAR_0x8005, 1
    GoTo _0455
_0442:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _0455
    SetVarFromValue VAR_0x8005, 2
_0455:
    Call _0609
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoTo _0627
_0467:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_5F, 2, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 1, _06C7
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    CallIf 2, _05FE
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    CallIf 0, _05F3
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _04BD
    SetVarFromValue VAR_0x8005, 4
    GoTo _051B
_04BD:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _04D6
    SetVarFromValue VAR_0x8005, 3
    GoTo _051B
_04D6:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _04EF
    SetVarFromValue VAR_0x8005, 2
    GoTo _051B
_04EF:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _0508
    SetVarFromValue VAR_0x8005, 1
    GoTo _051B
_0508:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _051B
    SetVarFromValue VAR_0x8005, 1
_051B:
    Call _0609
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoTo _0627
_052D:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_ROOF, 1, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 1, _06C7
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    CallIf 2, _05FE
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    CallIf 0, _05F3
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _0583
    SetVarFromValue VAR_0x8005, 5
    GoTo _05E1
_0583:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _059C
    SetVarFromValue VAR_0x8005, 4
    GoTo _05E1
_059C:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _05B5
    SetVarFromValue VAR_0x8005, 3
    GoTo _05E1
_05B5:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _05CE
    SetVarFromValue VAR_0x8005, 2
    GoTo _05E1
_05CE:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _05E1
    SetVarFromValue VAR_0x8005, 1
_05E1:
    Call _0609
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoTo _0627
_05F3:
    Message msg_0500_T07R0107_00002
    SetVarFromValue VAR_0x8004, 0
    Return
_05FE:
    Message msg_0500_T07R0107_00003
    SetVarFromValue VAR_0x8004, 1
    Return
_0609:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    CloseMessage
    ApplyMovement obj_T07R0107_gswoman6, _06F8
    WaitMovement
    WaitSE SE_CONFIRM_sseq_3
    PlayElevatorAnimation VAR_0x8004, VAR_0x8005
    Return
_0627:
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 5
    GoToIf 1, _067D
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0688
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0693
    CompareVar VAR_0x8008, 2
    GoToIf 1, _069E
    CompareVar VAR_0x8008, 1
    GoToIf 1, _06A9
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06B4
    End
_067D:
    Message msg_0500_T07R0107_00010
    GoTo _06BF
    End
_0688:
    Message msg_0500_T07R0107_00009
    GoTo _06BF
    End
_0693:
    Message msg_0500_T07R0107_00008
    GoTo _06BF
    End
_069E:
    Message msg_0500_T07R0107_00007
    GoTo _06BF
    End
_06A9:
    Message msg_0500_T07R0107_00006
    GoTo _06BF
    End
_06B4:
    Message msg_0500_T07R0107_00005
    GoTo _06BF
    End
_06BF:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06C7:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    WaitTime 1, VAR_RESULT
    Message msg_0500_T07R0107_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06DE:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    WaitTime 1, VAR_RESULT
    Message msg_0500_T07R0107_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_06F8:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
