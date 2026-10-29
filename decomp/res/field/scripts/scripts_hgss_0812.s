#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0516.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T08R0201_workman 6

    ScriptEntry scr_seq_T08R0201_000
    ScriptEntry scr_seq_T08R0201_001
    ScriptEntry scr_seq_T08R0201_002
    ScriptEntry scr_seq_T08R0201_003
    ScriptEntry scr_seq_T08R0201_004
    ScriptEntry scr_seq_T08R0201_005
    ScriptEntry scr_seq_T08R0201_006
    ScriptEntry scr_seq_T08R0201_007
    ScriptEntry scr_seq_T08R0201_008
    ScriptEntry scr_seq_T08R0201_009
    ScriptEntryEnd
scr_seq_T08R0201_000:
    GoToIfSet FLAG_HGSS_UNK_9CD, _003B
    SetVarFromValue VAR_HGSS_PAL_PARK_HIGH_SCORE, 2000
_003B:
    ClearFlag FLAG_HGSS_UNK_999
    SetFlag FLAG_HGSS_UNK_9CD
    CompareVar VAR_HGSS_UNK_4124, 0
    GoToIf 5, _0052
    End
_0052:
    SetObjectEventPos obj_T08R0201_workman, 8, 9
    SetObjectEventDir obj_T08R0201_workman, DIR_WEST
    End
_0062:
    CompareVar VAR_HGSS_PAL_PARK_HIGH_SCORE, 2000
    GoToIf 1, _0079
    BufferPlayerName 1
    BufferNumber 2, VAR_HGSS_PAL_PARK_HIGH_SCORE
    Return
_0079:
    BufferRivalName 1
    BufferNumber 2, VAR_HGSS_PAL_PARK_HIGH_SCORE
    Return
scr_seq_T08R0201_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_136, _019B
    SetFlag FLAG_HGSS_UNK_136
    BufferPlayerName 0
    MessageGendered msg_0516_T08R0201_00000, msg_0516_T08R0201_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00C5
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0190
    End
_00C5:
    Message msg_0516_T08R0201_00002
    GoTo _00E9
_00CE:
    Message msg_0516_T08R0201_00003
    GoTo _00E9
_00D7:
    Message msg_0516_T08R0201_00004
    GoTo _00E9
_00E0:
    Message msg_0516_T08R0201_00005
    GoTo _00E9
_00E9:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 194, 0
    AddMenuEntry 195, 1
    AddMenuEntry 196, 2
    AddMenuEntry 198, 4
    ShowMenu
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00CE
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00D7
    CompareVar VAR_RESULT, 2
    GoToIf 1, _00E0
    GoTo _0144
_0144:
    Message msg_0516_T08R0201_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0190
_015C:
    SetVarFromValue VAR_RESULT, 0
    GetPCBoxesFreeSlotCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 0, _0274
    SetVarFromValue VAR_RESULT, 0
    @ HGSS: ScrCmd_509 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0260
    GoTo _01FB
_0190:
    Message msg_0516_T08R0201_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_019B:
    BufferPlayerName 0
    MessageGendered msg_0516_T08R0201_00008, msg_0516_T08R0201_00009
    GoTo _01A8
_01A8:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 199, 0
    AddMenuEntry 200, 1
    AddMenuEntry 201, 2
    ShowMenu
    CompareVar VAR_RESULT, 0
    GoToIf 1, _015C
    CompareVar VAR_RESULT, 1
    GoToIf 1, _026B
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0190
    GoTo _0190
_01FB:
    Call _0062
    BufferPlayerName 0
    MessageGendered msg_0516_T08R0201_00010, msg_0516_T08R0201_00011
    CloseMessage
    ApplyMovement obj_T08R0201_workman, _0280
    WaitMovement
    @ HGSS: ScrCmd_600
    ApplyMovement LOCALID_PLAYER, _0294
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_PAL_PARK, 24, 47, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockObject LOCALID_COMPLETE_FOLLOWER
    @ HGSS: ScrCmd_606
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02A0
    WaitMovement
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ReleaseAll
    End
_0260:
    Message msg_0516_T08R0201_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_026B:
    Message msg_0516_T08R0201_00013
    GoTo _00E9
_0274:
    Message msg_0516_T08R0201_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0280:
    WalkOnSpotFastNorth
    WalkNormalNorth 2
    WalkNormalEast
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_0294:
    WalkNormalNorth 5
    SetInvisible
    EndMovement
    .balign 4, 0
_02A0:
    FaceNorth
    EndMovement
scr_seq_T08R0201_002:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_4124, 0
    ApplyMovement LOCALID_PLAYER, _03D4
    WaitMovement
    ApplyMovement obj_T08R0201_workman, _03BC
    WaitMovement
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
scr_seq_T08R0201_001:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_4124, 0
    ApplyMovement LOCALID_PLAYER, _03DC
    ApplyMovement obj_T08R0201_workman, _03C8
    WaitMovement
    @ HGSS: PalParkScoreGet 0, VAR_SPECIAL_RESULT
    BufferNumber 0, VAR_RESULT
    @ HGSS: PalParkScoreGet 1, VAR_SPECIAL_RESULT
    BufferNumber 1, VAR_RESULT
    @ HGSS: PalParkScoreGet 2, VAR_SPECIAL_RESULT
    BufferNumber 2, VAR_RESULT
    @ HGSS: PalParkScoreGet 3, VAR_SPECIAL_RESULT
    BufferNumber 3, VAR_RESULT
    Message msg_0516_T08R0201_00016
    @ HGSS: PalParkScoreGet 3, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, VAR_HGSS_PAL_PARK_HIGH_SCORE
    GoToIf 2, _0339
    Message msg_0516_T08R0201_00018
    Call _0669
    GoTo _034E
_0339:
    Message msg_0516_T08R0201_00017
    Call _0669
    @ HGSS: PalParkScoreGet 3, VAR_PAL_PARK_HIGH_SCORE
    GoTo _034E
_034E:
    Message msg_0516_T08R0201_00019
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0391
    Message msg_0516_T08R0201_00024
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0384
    GoTo _034E
_0384:
    Message msg_0516_T08R0201_00021
    WaitABPress
    CloseMessage
    GoTo _03A1
_0391:
    @ HGSS: ScrCmd_510
    Message msg_0516_T08R0201_00020
    Message msg_0516_T08R0201_00022
    CloseMessage
    GoTo _03A1
_03A1:
    ApplyMovement LOCALID_PLAYER, _03E8
    WaitMovement
    ApplyMovement obj_T08R0201_workman, _03BC
    WaitMovement
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
    .balign 4, 0
_03BC:
    WalkNormalWest
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_03C8:
    Delay8 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_03D4:
    WalkNormalSouth 5
    EndMovement
    .balign 4, 0
_03DC:
    WalkNormalSouth 2
    WalkOnSpotFastEast
    EndMovement
    .balign 4, 0
_03E8:
    WalkNormalSouth 4
    EndMovement
    NPCMessage msg_0516_T08R0201_00025
    End
scr_seq_T08R0201_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0444
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0439
    GoTo _042E
_042E:
    Message msg_0516_T08R0201_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0439:
    Message msg_0516_T08R0201_00042
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0444:
    Message msg_0516_T08R0201_00043
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08R0201_005:
    BufferPlayerName 0
    NPCMessage msg_0516_T08R0201_00044
    End
scr_seq_T08R0201_006:
    NPCMessage msg_0516_T08R0201_00045
    End
scr_seq_T08R0201_007:
    NPCMessage msg_0516_T08R0201_00033
    End
scr_seq_T08R0201_008:
    Call _0062
    NPCMessage msg_0516_T08R0201_00025
    End
scr_seq_T08R0201_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x09, 1
    GoToIf 1, _0511
    @ HGSS: ScrCmd_528 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _051C
    CompareVar VAR_RESULT, 5
    GoToIf 1, _055D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _059E
    CompareVar VAR_RESULT, 2
    GoToIf 1, _05D7
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0610
    GoTo _0506
    End
_0506:
    Message msg_0516_T08R0201_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0511:
    Message msg_0516_T08R0201_00040
    WaitButton
    CloseMessage
    ReleaseAll
    End
_051C:
    CheckItem ITEM_FASHION_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0506
    SetVarFromValue VAR_0x8004, ITEM_STABLE_MULCH
    SetVarFromValue VAR_0x8005, 1
    @ HGSS: ScrCmd_404 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0506
    Message msg_0516_T08R0201_00035
    GoTo _0649
    End
_055D:
    CheckItem ITEM_FASHION_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0506
    SetVarFromValue VAR_0x8004, ITEM_GOOEY_MULCH
    SetVarFromValue VAR_0x8005, 1
    @ HGSS: ScrCmd_404 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0506
    Message msg_0516_T08R0201_00036
    GoTo _0649
    End
_059E:
    CheckItem ITEM_FASHION_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0506
    SetVarFromValue VAR_0x8004, 14
    @ HGSS: ScrCmd_407 VAR_SPECIAL_x8004, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0506
    Message msg_0516_T08R0201_00037
    GoTo _0659
    End
_05D7:
    CheckItem ITEM_FASHION_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0506
    SetVarFromValue VAR_0x8004, 15
    @ HGSS: ScrCmd_407 VAR_SPECIAL_x8004, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0506
    Message msg_0516_T08R0201_00038
    GoTo _0659
    End
_0610:
    CheckItem ITEM_FASHION_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0506
    SetVarFromValue VAR_0x8004, 16
    @ HGSS: ScrCmd_407 VAR_SPECIAL_x8004, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0506
    Message msg_0516_T08R0201_00039
    GoTo _0659
    End
_0649:
    Common_GiveAccessory
    SetVarFromValue VAR_MAP_LOCAL_0x09, 1
    CloseMessage
    ReleaseAll
    End
_0659:
    Common_ObtainContestBackdrop
    SetVarFromValue VAR_MAP_LOCAL_0x09, 1
    CloseMessage
    ReleaseAll
    End
_0669:
    @ HGSS: PalParkScoreGet 3, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 3000
    CallIf 0, _06A5
    CompareVar VAR_RESULT, 3300
    CallIf 0, _071B
    CompareVar VAR_RESULT, 3500
    CallIf 0, _076A
    CompareVar VAR_RESULT, 10000
    CallIf 0, _07D3
    Return
_06A5:
    GetRandom VAR_0x8006, 8
    CompareVar VAR_0x8006, 0
    CallIf 1, _0861
    CompareVar VAR_0x8006, 1
    CallIf 1, _0869
    CompareVar VAR_0x8006, 2
    CallIf 1, _0871
    CompareVar VAR_0x8006, 3
    CallIf 1, _0879
    CompareVar VAR_0x8006, 4
    CallIf 1, _0881
    CompareVar VAR_0x8006, 5
    CallIf 1, _0889
    CompareVar VAR_0x8006, 6
    CallIf 1, _0891
    CompareVar VAR_0x8006, 7
    CallIf 1, _0899
    Call _082F
    Return
_071B:
    GetRandom VAR_0x8006, 5
    CompareVar VAR_0x8006, 0
    CallIf 1, _08A1
    CompareVar VAR_0x8006, 1
    CallIf 1, _08A9
    CompareVar VAR_0x8006, 2
    CallIf 1, _08B1
    CompareVar VAR_0x8006, 3
    CallIf 1, _08B9
    CompareVar VAR_0x8006, 4
    CallIf 1, _08C1
    Call _082F
    Return
_076A:
    GetRandom VAR_0x8006, 7
    CompareVar VAR_0x8006, 0
    CallIf 1, _08C9
    CompareVar VAR_0x8006, 1
    CallIf 1, _08D1
    CompareVar VAR_0x8006, 2
    CallIf 1, _08D9
    CompareVar VAR_0x8006, 3
    CallIf 1, _08E1
    CompareVar VAR_0x8006, 4
    CallIf 1, _08E9
    CompareVar VAR_0x8006, 5
    CallIf 1, _08F1
    CompareVar VAR_0x8006, 6
    CallIf 1, _08F9
    Call _082F
    Return
_07D3:
    GetRandom VAR_0x8006, 6
    CompareVar VAR_0x8006, 0
    CallIf 1, _0901
    CompareVar VAR_0x8006, 1
    CallIf 1, _0909
    CompareVar VAR_0x8006, 2
    CallIf 1, _0911
    CompareVar VAR_0x8006, 3
    CallIf 1, _0919
    CompareVar VAR_0x8006, 4
    CallIf 1, _0921
    CompareVar VAR_0x8006, 5
    CallIf 1, _0929
    Call _082F
    Return
_082F:
    CanFitItem VAR_0x8006, 1, VAR_0x8007
    CompareVar VAR_0x8007, 0
    CallIf 5, _084C
    SetVarFromValue VAR_RESULT, 10000
    Return
_084C:
    Message msg_0516_T08R0201_00023
    SetVar VAR_0x8004, VAR_0x8006
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Return
_0861:
    SetVarFromValue VAR_0x8006, 149
    Return
_0869:
    SetVarFromValue VAR_0x8006, 150
    Return
_0871:
    SetVarFromValue VAR_0x8006, 151
    Return
_0879:
    SetVarFromValue VAR_0x8006, 152
    Return
_0881:
    SetVarFromValue VAR_0x8006, 153
    Return
_0889:
    SetVarFromValue VAR_0x8006, 154
    Return
_0891:
    SetVarFromValue VAR_0x8006, 155
    Return
_0899:
    SetVarFromValue VAR_0x8006, 156
    Return
_08A1:
    SetVarFromValue VAR_0x8006, 159
    Return
_08A9:
    SetVarFromValue VAR_0x8006, 160
    Return
_08B1:
    SetVarFromValue VAR_0x8006, 161
    Return
_08B9:
    SetVarFromValue VAR_0x8006, 162
    Return
_08C1:
    SetVarFromValue VAR_0x8006, 163
    Return
_08C9:
    SetVarFromValue VAR_0x8006, 164
    Return
_08D1:
    SetVarFromValue VAR_0x8006, 165
    Return
_08D9:
    SetVarFromValue VAR_0x8006, 166
    Return
_08E1:
    SetVarFromValue VAR_0x8006, 167
    Return
_08E9:
    SetVarFromValue VAR_0x8006, 168
    Return
_08F1:
    SetVarFromValue VAR_0x8006, 157
    Return
_08F9:
    SetVarFromValue VAR_0x8006, 158
    Return
_0901:
    SetVarFromValue VAR_0x8006, 169
    Return
_0909:
    SetVarFromValue VAR_0x8006, 170
    Return
_0911:
    SetVarFromValue VAR_0x8006, 171
    Return
_0919:
    SetVarFromValue VAR_0x8006, 172
    Return
_0921:
    SetVarFromValue VAR_0x8006, 173
    Return
_0929:
    SetVarFromValue VAR_0x8006, 174
    Return
    .balign 4, 0
