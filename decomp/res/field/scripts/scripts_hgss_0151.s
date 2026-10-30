#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0246.h"


    ScriptEntry scr_seq_0151_000
    ScriptEntry scr_seq_0151_001
    ScriptEntry scr_seq_0151_002
    ScriptEntry scr_seq_0151_003
    ScriptEntry scr_seq_0151_004
    ScriptEntry scr_seq_0151_005
    ScriptEntry scr_seq_0151_006
    ScriptEntry scr_seq_0151_007
    ScriptEntry scr_seq_0151_008
    ScriptEntry scr_seq_0151_009
    ScriptEntry scr_seq_0151_010
    ScriptEntry scr_seq_0151_011
    ScriptEntry scr_seq_0151_012
    ScriptEntry scr_seq_0151_013
    ScriptEntry scr_seq_0151_014
    ScriptEntry scr_seq_0151_015
    ScriptEntry scr_seq_0151_016
    ScriptEntry scr_seq_0151_017
    ScriptEntry scr_seq_0151_018
    ScriptEntry scr_seq_0151_019
    ScriptEntry scr_seq_0151_020
    ScriptEntry scr_seq_0151_021
    ScriptEntry scr_seq_0151_022
    ScriptEntry scr_seq_0151_023
    ScriptEntry scr_seq_0151_024
    ScriptEntry scr_seq_0151_025
    ScriptEntry scr_seq_0151_026
    ScriptEntry scr_seq_0151_027
    ScriptEntry scr_seq_0151_028
    ScriptEntryEnd
_0076:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NATIONAL_PARK, 46, 50, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Return
scr_seq_0151_000:
    LockAll
    PlaySE SEQ_SE_DP_PINPON_sseq
    Message msg_0246_00000
    CloseMessage
    Call _0076
    ReleaseAll
    End
scr_seq_0151_001:
    LockAll
    PlaySE SEQ_SE_DP_PINPON_sseq
    Message msg_0246_00001
    CloseMessage
    Call _0076
    ReleaseAll
    End
scr_seq_0151_002:
    End
scr_seq_0151_003:
    End
scr_seq_0151_004:
    LockAll
    CompleteBugContestGetTimeLeft 0
    Message msg_0246_00003
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00F9
    Call _0076
    ReleaseAll
    End
_00F9:
    ReleaseAll
    End
scr_seq_0151_005:
    CompareVar VAR_HGSS_BUG_CONTEST_HELD_PRIZE, 0
    GoToIf 1, _0114
    Call _02BC
    ReturnCommonScript
    End
_0114:
    GoToIfSet FLAG_HGSS_DAILY_DID_BUG_CONTEST, _02A6
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0139
    Message msg_0246_00004
    GoTo _016E
_0139:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _014F
    Message msg_0246_00005
    GoTo _016E
_014F:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0165
    Message msg_0246_00006
    GoTo _016E
_0165:
    Message msg_0246_00007
    GoTo _0260
_016E:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _018E
    Message msg_0246_00017
    GoTo _0260
    End
_018E:
    GetPCBoxesFreeSlotCount VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01B0
    GetPartyCount VAR_0x8004
    CompareVar VAR_0x8004, 6
    GoToIf 1, _02B1
_01B0:
    CountAliveMonsExcept VAR_0x8005, 6
    CompareVar VAR_0x8005, 1
    GoToIf 5, _01D4
    GetPartyCount VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 1, _021A
_01D4:
    GetFirstNonEggInParty VAR_RESULT
    BufferPartyMonNickname 0, VAR_RESULT
    Message msg_0246_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0200
    Message msg_0246_00028
    GoTo _0260
    End
_0200:
    FadeOutBGM 0, 10
    PlayMusic SEQ_GS_TAIKAIMAE_sseq
    BufferPlayerName 0
    Message msg_0246_00013
    SetFlag FLAG_HGSS_BUG_CONTEST_OTHER_POKES_HELD
    GoTo _0224
_021A:
    FadeOutBGM 0, 10
    PlayMusic SEQ_GS_TAIKAIMAE_sseq
_0224:
    BufferPlayerName 0
    Message msg_0246_00014
    Message msg_0246_00015
    SetFlag FLAG_HGSS_BUG_CONTEST_ACTIVE
    SetFlag FLAG_HGSS_UNK_24E
    SetVarFromValue VAR_HGSS_UNK_4118, 1
    SetVarFromValue VAR_HGSS_UNK_40F7, 1
    CompleteBugContestAction 0, VAR_MAP_LOCAL_0x00
    Call _0268
    SetFlag FLAG_HGSS_UNK_996
    GoTo _0262
    End
_0260:
    WaitButton
_0262:
    CloseMessage
    ReturnCommonScript
    End
_0268:
    SetVarFromValue VAR_0x8004, ITEM_NONE
    SetVarFromValue VAR_0x8005, 627
_0274:
    CompleteIsBugContestantRegistered VAR_0x8004, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _028B
    CompleteSetHGSSFlagFromVar VAR_0x8005
_028B:
    AddVar VAR_0x8004, 1
    AddVar VAR_0x8005, 1
    CompareVar VAR_0x8004, 10
    GoToIf 0, _0274
    Return
_02A6:
    Message msg_0246_00018
    GoTo _0260
    End
_02B1:
    Message msg_0246_00016
    GoTo _0260
    End
_02BC:
    BufferPlayerName 0
    Message msg_0246_00020
    CanFitItem VAR_HGSS_BUG_CONTEST_HELD_PRIZE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02F3
    SetVarFromVar VAR_0x8004, VAR_HGSS_BUG_CONTEST_HELD_PRIZE
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    SetVarFromValue VAR_HGSS_BUG_CONTEST_HELD_PRIZE, 0
    GoTo _02F8
_02F3:
    Message msg_0246_00021
    WaitButton
_02F8:
    CloseMessage
    Return
    Message msg_0246_00018
    GoTo _0260
    End
scr_seq_0151_006:
    CompleteBugContestGetTimeLeft 0
    Message msg_0246_00023
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _032B
    Message msg_0246_00026
    CloseMessage
    ReturnCommonScript
    End
_032B:
    Message msg_0246_00027
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4118, 2
    Call _0076
    ReturnCommonScript
    End
scr_seq_0151_007:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_4118, 0
    SetVarFromValue VAR_HGSS_UNK_40F7, 0
    CompleteJudgeBugContest VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01, VAR_MAP_LOCAL_0x02
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _053C
    WaitMovement
    Message msg_0246_00029
    CompleteBufferBugContestWinner 2
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _038E
    Message msg_0246_00030
    GoTo _0391
_038E:
    Message msg_0246_00031
_0391:
    WaitFanfare
    Message msg_0246_00032
    CompleteBufferBugContestWinner 1
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _03B3
    Message msg_0246_00033
    GoTo _03B6
_03B3:
    Message msg_0246_00034
_03B6:
    WaitFanfare
    Message msg_0246_00032
    CompleteBufferBugContestWinner 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _03DC
    SetFlag FLAG_HGSS_WON_THIS_BUG_CONTEST
    Message msg_0246_00035
    GoTo _03E3
_03DC:
    ClearFlag FLAG_HGSS_WON_THIS_BUG_CONTEST
    Message msg_0246_00036
_03E3:
    WaitFanfare
    Message msg_0246_00032
    BufferPlayerName 0
    BufferItemName 3, VAR_MAP_LOCAL_0x01
    SetVarFromValue VAR_0x8004, 37
    AddVar VAR_0x8004, VAR_MAP_LOCAL_0x00
    MessageVar VAR_0x8004
    SetVar VAR_0x8004, VAR_MAP_LOCAL_0x01
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfNe VAR_RESULT, 1, _042F
    Common_GiveItemQuantity
    GoTo _043B
_042F:
    BufferPlayerName 0
    Message msg_0246_00045
    SetVarFromVar VAR_HGSS_BUG_CONTEST_HELD_PRIZE, VAR_MAP_LOCAL_0x01
_043B:
    CallIfSet FLAG_HGSS_BUG_CONTEST_OTHER_POKES_HELD, _04F6
    Message msg_0246_00042
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _045E
    CloseMessage
    GoTo _04B5
_045E:
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 2, 1
    Message msg_0246_00043
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _049E
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteBugContestNicknameStart VAR_0x8004
    OpenPokemonNamingScreen VAR_0x8004, VAR_RESULT
    CompleteBugContestNicknameEnd
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_049E:
    CompleteBufferBugContestMonNick 5, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04B5
    Message msg_0246_00046
    CloseMessage
_04B5:
    ApplyMovement 241, _0544
    WaitMovement
    FadeOutBGM 0, 10
    PlayMusic SEQ_GS_D_KOUEN_sseq
    RestoreCamera
    Call _04FD
    SetFlag FLAG_HGSS_DAILY_DID_BUG_CONTEST
    ClearFlag FLAG_HGSS_BUG_CONTEST_ACTIVE
    ClearFlag FLAG_HGSS_UNK_24E
    ClearFlag FLAG_HGSS_BUG_CONTEST_OTHER_POKES_HELD
    CompleteBugContestAction 1, 0
    FadeOutBGM 0, 30
    PlayDefaultMusic
    ReleaseAll
    End
_04F6:
    Message msg_0246_00047
    CloseMessage
    Return
_04FD:
    SetVarFromValue VAR_0x8004, ITEM_NONE
    SetVarFromValue VAR_0x8005, 10
    SetVarFromValue VAR_0x8006, 627
_050F:
    SetMovementType VAR_0x8005, 2
    CompleteClearHGSSFlagFromVar VAR_0x8006
    AddVar VAR_0x8004, 1
    AddVar VAR_0x8005, 1
    AddVar VAR_0x8006, 1
    CompareVar VAR_0x8004, 10
    GoToIf 0, _050F
    Return
    .balign 4, 0
_053C:
    WalkNormalEast 5
    EndMovement
    .balign 4, 0
_0544:
    WalkNormalWest 5
    EndMovement
scr_seq_0151_008:
    NPCMessage msg_0246_00048
    End
scr_seq_0151_009:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _0581
    NPCMessage msg_0246_00049
    GoTo _0592
_0581:
    NPCMessage msg_0246_00050
_0592:
    End
scr_seq_0151_010:
    NPCMessage msg_0246_00051
    End
scr_seq_0151_011:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _05C9
    NPCMessage msg_0246_00052
    GoTo _05DA
_05C9:
    NPCMessage msg_0246_00053
_05DA:
    End
scr_seq_0151_012:
    NPCMessage msg_0246_00054
    End
scr_seq_0151_013:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _0611
    NPCMessage msg_0246_00055
    GoTo _0622
_0611:
    NPCMessage msg_0246_00056
_0622:
    End
scr_seq_0151_014:
    NPCMessage msg_0246_00057
    End
scr_seq_0151_015:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _0659
    NPCMessage msg_0246_00058
    GoTo _066A
_0659:
    NPCMessage msg_0246_00059
_066A:
    End
scr_seq_0151_016:
    NPCMessage msg_0246_00060
    End
scr_seq_0151_017:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _06A1
    NPCMessage msg_0246_00061
    GoTo _06B2
_06A1:
    NPCMessage msg_0246_00062
_06B2:
    End
scr_seq_0151_018:
    NPCMessage msg_0246_00063
    End
scr_seq_0151_019:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _06E9
    NPCMessage msg_0246_00064
    GoTo _06FA
_06E9:
    NPCMessage msg_0246_00065
_06FA:
    End
scr_seq_0151_020:
    NPCMessage msg_0246_00066
    End
scr_seq_0151_021:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _0731
    NPCMessage msg_0246_00067
    GoTo _0742
_0731:
    NPCMessage msg_0246_00068
_0742:
    End
scr_seq_0151_022:
    NPCMessage msg_0246_00069
    End
scr_seq_0151_023:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _0779
    NPCMessage msg_0246_00070
    GoTo _078A
_0779:
    NPCMessage msg_0246_00071
_078A:
    End
scr_seq_0151_024:
    NPCMessage msg_0246_00072
    End
scr_seq_0151_025:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _07C1
    NPCMessage msg_0246_00073
    GoTo _07D2
_07C1:
    NPCMessage msg_0246_00074
_07D2:
    End
scr_seq_0151_026:
    NPCMessage msg_0246_00075
    End
scr_seq_0151_027:
    GoToIfSet FLAG_HGSS_WON_THIS_BUG_CONTEST, _0809
    NPCMessage msg_0246_00076
    GoTo _081A
_0809:
    NPCMessage msg_0246_00077
_081A:
    End
scr_seq_0151_028:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_BUG_CONTEST_HELD_PRIZE, 0
    GoToIf 1, _083D
    Call _02BC
    GoTo _0844
_083D:
    Message msg_0246_00022
    WaitButton
    CloseMessage
_0844:
    ReleaseAll
    End
    .balign 4, 0
