#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0598.h"

#define obj_T25R1007_gswoman6 0

    ScriptEntry scr_seq_T25R1007_000
    ScriptEntryEnd
scr_seq_T25R1007_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 6
    GoToIf 1, _0075
    CompareVar VAR_0x8008, 5
    GoToIf 1, _007F
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0089
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0093
    CompareVar VAR_0x8008, 2
    GoToIf 1, _009D
    CompareVar VAR_0x8008, 1
    GoToIf 1, _00A7
    CompareVar VAR_0x8008, 0
    GoToIf 1, _00B1
    End
_0075:
    CompleteBufferFloorName 0, 6
    GoTo _00BC
_007F:
    CompleteBufferFloorName 0, 5
    GoTo _00BC
_0089:
    CompleteBufferFloorName 0, 4
    GoTo _00BC
_0093:
    CompleteBufferFloorName 0, 3
    GoTo _00BC
_009D:
    CompleteBufferFloorName 0, 2
    GoTo _00BC
_00A7:
    CompleteBufferFloorName 0, 1
    GoTo _00BC
_00B1:
    BufferNumber 0, 0
    GoTo _00BC
_00BC:
    ShowCurrentFloor 20, 1, VAR_HGSS_ELEVATOR_LAST_FLOOR
    Message msg_0598_T25R1007_00000
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 121, 6
    AddMenuEntry 120, 0
    AddMenuEntry 119, 1
    AddMenuEntry 118, 2
    AddMenuEntry 117, 3
    AddMenuEntry 116, 4
    AddMenuEntry 122, 5
    AddMenuEntry 126, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 6
    GoToIf 1, _05D7
    CompareVar VAR_0x8008, 0
    GoToIf 1, _04F8
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0419
    CompareVar VAR_0x8008, 2
    GoToIf 1, _033A
    CompareVar VAR_0x8008, 3
    GoToIf 1, _025B
    CompareVar VAR_0x8008, 4
    GoToIf 1, _017C
    CompareVar VAR_0x8008, 5
    GoToIf 1, _06B6
    GoTo _0898
_017C:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_1F, 2, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 1, _0881
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    CallIf 2, _07A0
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    CallIf 0, _0795
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _01D2
    SetVarFromValue VAR_0x8005, 1
    GoTo _0249
_01D2:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _01EB
    SetVarFromValue VAR_0x8005, 2
    GoTo _0249
_01EB:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _0204
    SetVarFromValue VAR_0x8005, 3
    GoTo _0249
_0204:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _021D
    SetVarFromValue VAR_0x8005, 4
    GoTo _0249
_021D:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    GoToIf 5, _0236
    SetVarFromValue VAR_0x8005, 5
    GoTo _0249
_0236:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _0249
    SetVarFromValue VAR_0x8005, 1
_0249:
    Call _07AB
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoTo _07C9
_025B:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_2F, 2, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 1, _0881
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    CallIf 2, _07A0
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    CallIf 0, _0795
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _02B1
    SetVarFromValue VAR_0x8005, 1
    GoTo _0328
_02B1:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _02CA
    SetVarFromValue VAR_0x8005, 1
    GoTo _0328
_02CA:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _02E3
    SetVarFromValue VAR_0x8005, 2
    GoTo _0328
_02E3:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _02FC
    SetVarFromValue VAR_0x8005, 3
    GoTo _0328
_02FC:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    GoToIf 5, _0315
    SetVarFromValue VAR_0x8005, 4
    GoTo _0328
_0315:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _0328
    SetVarFromValue VAR_0x8005, 2
_0328:
    Call _07AB
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoTo _07C9
_033A:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_3F, 2, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 1, _0881
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    CallIf 2, _07A0
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    CallIf 0, _0795
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _0390
    SetVarFromValue VAR_0x8005, 2
    GoTo _0407
_0390:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _03A9
    SetVarFromValue VAR_0x8005, 1
    GoTo _0407
_03A9:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _03C2
    SetVarFromValue VAR_0x8005, 1
    GoTo _0407
_03C2:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _03DB
    SetVarFromValue VAR_0x8005, 2
    GoTo _0407
_03DB:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    GoToIf 5, _03F4
    SetVarFromValue VAR_0x8005, 3
    GoTo _0407
_03F4:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _0407
    SetVarFromValue VAR_0x8005, 3
_0407:
    Call _07AB
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoTo _07C9
_0419:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_4F, 2, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 1, _0881
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    CallIf 2, _07A0
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    CallIf 0, _0795
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _046F
    SetVarFromValue VAR_0x8005, 3
    GoTo _04E6
_046F:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _0488
    SetVarFromValue VAR_0x8005, 2
    GoTo _04E6
_0488:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _04A1
    SetVarFromValue VAR_0x8005, 1
    GoTo _04E6
_04A1:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _04BA
    SetVarFromValue VAR_0x8005, 1
    GoTo _04E6
_04BA:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    GoToIf 5, _04D3
    SetVarFromValue VAR_0x8005, 2
    GoTo _04E6
_04D3:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _04E6
    SetVarFromValue VAR_0x8005, 4
_04E6:
    Call _07AB
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoTo _07C9
_04F8:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_5F, 2, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 1, _0881
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    CallIf 2, _07A0
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    CallIf 0, _0795
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _054E
    SetVarFromValue VAR_0x8005, 4
    GoTo _05C5
_054E:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _0567
    SetVarFromValue VAR_0x8005, 3
    GoTo _05C5
_0567:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _0580
    SetVarFromValue VAR_0x8005, 2
    GoTo _05C5
_0580:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _0599
    SetVarFromValue VAR_0x8005, 1
    GoTo _05C5
_0599:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    GoToIf 5, _05B2
    SetVarFromValue VAR_0x8005, 1
    GoTo _05C5
_05B2:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _05C5
    SetVarFromValue VAR_0x8005, 5
_05C5:
    Call _07AB
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoTo _07C9
_05D7:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_6F, 1, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    GoToIf 1, _0881
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    CallIf 2, _07A0
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    CallIf 0, _0795
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _062D
    SetVarFromValue VAR_0x8005, 5
    GoTo _06A4
_062D:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _0646
    SetVarFromValue VAR_0x8005, 4
    GoTo _06A4
_0646:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _065F
    SetVarFromValue VAR_0x8005, 3
    GoTo _06A4
_065F:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _0678
    SetVarFromValue VAR_0x8005, 2
    GoTo _06A4
_0678:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _0691
    SetVarFromValue VAR_0x8005, 1
    GoTo _06A4
_0691:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 5, _06A4
    SetVarFromValue VAR_0x8005, 6
_06A4:
    Call _07AB
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    GoTo _07C9
_06B6:
    WaitTime 1, VAR_RESULT
    CompleteGetElevatorFloor VAR_HGSS_ELEVATOR_LAST_FLOOR
    SetSpecialLocation MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_BASEMENT, 1, 19, 3, 1
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoToIf 1, _0881
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    CallIf 2, _07A0
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    CallIf 0, _0795
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 1
    GoToIf 5, _070C
    SetVarFromValue VAR_0x8005, 1
    GoTo _0783
_070C:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 2
    GoToIf 5, _0725
    SetVarFromValue VAR_0x8005, 2
    GoTo _0783
_0725:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 3
    GoToIf 5, _073E
    SetVarFromValue VAR_0x8005, 3
    GoTo _0783
_073E:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 4
    GoToIf 5, _0757
    SetVarFromValue VAR_0x8005, 4
    GoTo _0783
_0757:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 5
    GoToIf 5, _0770
    SetVarFromValue VAR_0x8005, 5
    GoTo _0783
_0770:
    CompareVar VAR_HGSS_ELEVATOR_LAST_FLOOR, 6
    GoToIf 5, _0783
    SetVarFromValue VAR_0x8005, 6
_0783:
    Call _07AB
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 0
    GoTo _07C9
_0795:
    Message msg_0598_T25R1007_00002
    SetVarFromValue VAR_0x8004, 0
    Return
_07A0:
    Message msg_0598_T25R1007_00003
    SetVarFromValue VAR_0x8004, 1
    Return
_07AB:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    CloseMessage
    ApplyMovement obj_T25R1007_gswoman6, _08B0
    WaitMovement
    WaitSE SE_CONFIRM_sseq_3
    PlayElevatorAnimation VAR_0x8004, VAR_0x8005
    Return
_07C9:
    SetVar VAR_0x8008, VAR_HGSS_ELEVATOR_LAST_FLOOR
    CompareVar VAR_0x8008, 6
    GoToIf 1, _082C
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0837
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0842
    CompareVar VAR_0x8008, 3
    GoToIf 1, _084D
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0858
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0863
    CompareVar VAR_0x8008, 0
    GoToIf 1, _086E
    End
_082C:
    Message msg_0598_T25R1007_00010
    GoTo _0879
    End
_0837:
    Message msg_0598_T25R1007_00009
    GoTo _0879
    End
_0842:
    Message msg_0598_T25R1007_00008
    GoTo _0879
    End
_084D:
    Message msg_0598_T25R1007_00007
    GoTo _0879
    End
_0858:
    Message msg_0598_T25R1007_00006
    GoTo _0879
    End
_0863:
    Message msg_0598_T25R1007_00005
    GoTo _0879
    End
_086E:
    Message msg_0598_T25R1007_00011
    GoTo _0879
    End
_0879:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0881:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    WaitTime 1, VAR_RESULT
    Message msg_0598_T25R1007_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0898:
    SetVarFromValue VAR_HGSS_ELEVATOR_LAST_FLOOR, 65535
    WaitTime 1, VAR_RESULT
    Message msg_0598_T25R1007_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_08B0:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
