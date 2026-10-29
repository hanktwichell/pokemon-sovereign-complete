#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0260.h"

#define obj_P01R0302_gsbabygirl1 1

    ScriptEntry scr_seq_P01R0302_000
    ScriptEntry scr_seq_P01R0302_001
    ScriptEntry scr_seq_P01R0302_002
    ScriptEntryEnd
scr_seq_P01R0302_002:
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 4
    GoToIf 4, _001D
    End
_001D:
    SetFlag FLAG_HGSS_HIDE_SS_AQUA_CAPTAINS_ROOM_GRANDDAUGHTER
    End
scr_seq_P01R0302_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 6
    GoToIf 4, _005B
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 4
    GoToIf 1, _0050
    Message msg_0260_P01R0302_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0050:
    Message msg_0260_P01R0302_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_005B:
    GoToIfSet FLAG_HGSS_DAILY_RECEIVED_PLATE_FROM_AQUA_CAPTAIN, _0084
    GoToIfSet FLAG_HGSS_RECEIVED_PLATE_FROM_AQUA_CAPTAIN_THIS_TRIP, _0084
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _008F
_0084:
    Message msg_0260_P01R0302_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_008F:
    Message msg_0260_P01R0302_00007
    CloseMessage
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 0
    GoToIf 5, _00B3
    SetVarFromValue VAR_0x8004, ITEM_FLAME_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_00B3:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 1
    GoToIf 5, _00D2
    SetVarFromValue VAR_0x8004, ITEM_SPLASH_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_00D2:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 2
    GoToIf 5, _00F1
    SetVarFromValue VAR_0x8004, ITEM_ZAP_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_00F1:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 3
    GoToIf 5, _0110
    SetVarFromValue VAR_0x8004, ITEM_MEADOW_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_0110:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 4
    GoToIf 5, _012F
    SetVarFromValue VAR_0x8004, ITEM_ICICLE_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_012F:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 5
    GoToIf 5, _014E
    SetVarFromValue VAR_0x8004, ITEM_FIST_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_014E:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 6
    GoToIf 5, _016D
    SetVarFromValue VAR_0x8004, ITEM_TOXIC_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_016D:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 7
    GoToIf 5, _018C
    SetVarFromValue VAR_0x8004, ITEM_EARTH_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_018C:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 8
    GoToIf 5, _01AB
    SetVarFromValue VAR_0x8004, ITEM_SKY_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_01AB:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 9
    GoToIf 5, _01CA
    SetVarFromValue VAR_0x8004, ITEM_MIND_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_01CA:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 10
    GoToIf 5, _01E9
    SetVarFromValue VAR_0x8004, ITEM_INSECT_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_01E9:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 11
    GoToIf 5, _0208
    SetVarFromValue VAR_0x8004, ITEM_STONE_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_0208:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 12
    GoToIf 5, _0227
    SetVarFromValue VAR_0x8004, ITEM_SPOOKY_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_0227:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 13
    GoToIf 5, _0246
    SetVarFromValue VAR_0x8004, ITEM_DRACO_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_0246:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 14
    GoToIf 5, _0265
    SetVarFromValue VAR_0x8004, ITEM_DREAD_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_0265:
    CompareVar VAR_HGSS_RECEIVED_PLATES_COUNT, 15
    GoToIf 5, _0284
    SetVarFromValue VAR_0x8004, ITEM_IRON_PLATE
    SetVarFromValue VAR_0x8005, 1
    GoTo _0296
_0284:
    SetVarFromValue VAR_0x8004, ITEM_NUGGET
    SetVarFromValue VAR_0x8005, 1
    GoTo _029C
_0296:
    AddVar VAR_HGSS_RECEIVED_PLATES_COUNT, 1
_029C:
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02C3
    Common_GiveItemQuantityNoLineFeed
    SetFlag FLAG_HGSS_DAILY_RECEIVED_PLATE_FROM_AQUA_CAPTAIN
    SetFlag FLAG_HGSS_RECEIVED_PLATE_FROM_AQUA_CAPTAIN_THIS_TRIP
    CloseMessage
    ReleaseAll
    End
_02C3:
    BufferItemName 1, VAR_0x8004
    Message msg_0260_P01R0302_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_P01R0302_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0260_P01R0302_00000
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02FD
    ApplyMovement obj_P01R0302_gsbabygirl1, _0340
    GoTo _0305
_02FD:
    ApplyMovement obj_P01R0302_gsbabygirl1, _0350
_0305:
    WaitMovement
    MessageGendered msg_0260_P01R0302_00003, msg_0260_P01R0302_00002
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 4
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_P01R0302_gsbabygirl1
    SetFlag FLAG_HGSS_HIDE_SS_AQUA_CAPTAINS_ROOM_GRANDDAUGHTER
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0340:
    EmoteExclamationMark
    Delay8
    FaceNorth 2
    EndMovement
    .balign 4, 0
_0350:
    EmoteExclamationMark
    Delay8
    FaceEast 2
    EndMovement
    .balign 4, 0
