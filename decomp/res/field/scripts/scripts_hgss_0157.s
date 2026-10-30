#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0260.h"

#define obj_P01R0302_gsbabygirl1 1

    ScriptEntry scr_seq_P01R0302_000
    ScriptEntry scr_seq_P01R0302_001
    ScriptEntry scr_seq_P01R0302_002
    ScriptEntryEnd
scr_seq_P01R0302_002:
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 4
    GoToIf 4, _0074
    End
scr_seq_P01R0302_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 6
    GoToIf 4, _007A
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 4
    GoToIf 1, _00AE
    Message msg_0260_P01R0302_00004
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
    GoToIf 5, _00B9
    ApplyMovement obj_P01R0302_gsbabygirl1, _0188
    GoTo _00FB
_0074:
    SetFlag FLAG_HGSS_HIDE_SS_AQUA_CAPTAINS_ROOM_GRANDDAUGHTER
    End
_007A:
    GoToIfSet FLAG_HGSS_DAILY_RECEIVED_PLATE_FROM_AQUA_CAPTAIN, _0135
    GoToIfSet FLAG_HGSS_RECEIVED_PLATE_FROM_AQUA_CAPTAIN_THIS_TRIP, _0135
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0140
    Message msg_0260_P01R0302_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00AE:
    Message msg_0260_P01R0302_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B9:
    ApplyMovement obj_P01R0302_gsbabygirl1, _0196
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
_00FB:
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
_0135:
    Message msg_0260_P01R0302_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0140:
    Message msg_0260_P01R0302_00007
    CloseMessage
    SetVar VAR_0x8004, ITEM_ODD_KEYSTONE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0178
    Common_GiveItemQuantityNoLineFeed
    SetFlag FLAG_HGSS_DAILY_RECEIVED_PLATE_FROM_AQUA_CAPTAIN
    SetFlag FLAG_HGSS_RECEIVED_PLATE_FROM_AQUA_CAPTAIN_THIS_TRIP
    CloseMessage
    ReleaseAll
    End
_0178:
    BufferItemName 1, VAR_0x8004
    Message msg_0260_P01R0302_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0188:
    EmoteExclamationMark
    Delay8
    FaceNorth 2
    EndMovement
    .balign 4, 0
_0196:
    EmoteExclamationMark
    Delay8
    FaceEast 2
    EndMovement
    .balign 4, 0
