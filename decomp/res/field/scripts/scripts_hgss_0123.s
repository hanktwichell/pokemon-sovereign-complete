#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0138.h"

#define obj_D49R0101_gsleader3 1

    ScriptEntry scr_seq_D49R0101_000
    ScriptEntry scr_seq_D49R0101_001
    ScriptEntry scr_seq_D49R0101_002
    ScriptEntry scr_seq_D49R0101_003
    ScriptEntry scr_seq_D49R0101_004
    ScriptEntry scr_seq_D49R0101_005
    ScriptEntry scr_seq_D49R0101_006
    ScriptEntry scr_seq_D49R0101_007
    ScriptEntry scr_seq_D49R0101_008
    ScriptEntry scr_seq_D49R0101_009
    ScriptEntry scr_seq_D49R0101_010
    ScriptEntry scr_seq_D49R0101_011
    ScriptEntry scr_seq_D49R0101_012
    ScriptEntry scr_seq_D49R0101_013
    ScriptEntry scr_seq_D49R0101_014
    ScriptEntry scr_seq_D49R0101_015
    ScriptEntry scr_seq_D49R0101_016
    ScriptEntry scr_seq_D49R0101_017
    ScriptEntry scr_seq_D49R0101_018
    ScriptEntry scr_seq_D49R0101_019
    ScriptEntry scr_seq_D49R0101_020
    ScriptEntry scr_seq_D49R0101_021
    ScriptEntry scr_seq_D49R0101_022
    ScriptEntry scr_seq_D49R0101_023
    ScriptEntryEnd
scr_seq_D49R0101_023:
    SetFlag FLAG_HGSS_SYS_FLYPOINT_POKEATHLON
    End
    .balign 4, 0
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0070:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0078:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0080:
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_D49R0101_000:
    LockAll
    GetPlayerDir VAR_MAP_LOCAL_0x0A
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _00AB
    ApplyMovement LOCALID_PLAYER, _0230
    GoTo _00B3
_00AB:
    ApplyMovement LOCALID_PLAYER, _023C
_00B3:
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_POKEATHLON_RECEPTION_WHITNEY
    AddObject obj_D49R0101_gsleader3
    SetPosition obj_D49R0101_gsleader3, 23, 0, 20, DIR_NORTH
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _00EC
    ApplyMovement obj_D49R0101_gsleader3, _0248
    ApplyMovement LOCALID_PLAYER, _0260
    GoTo _00F4
_00EC:
    ApplyMovement obj_D49R0101_gsleader3, _0258
_00F4:
    WaitMovement
    BufferPlayerName 0
    Message msg_0138_D49R0101_00080
    CloseMessage
    WaitTime 30, VAR_RESULT
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _011F
    ApplyMovement obj_D49R0101_gsleader3, _0200
    GoTo _0127
_011F:
    ApplyMovement obj_D49R0101_gsleader3, _0218
_0127:
    WaitMovement
    Message msg_0138_D49R0101_00081
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _0149
    ApplyMovement obj_D49R0101_gsleader3, _0270
    GoTo _018E
_0149:
    CompareVar VAR_MAP_LOCAL_0x0A, 3
    GoToIf 5, _016C
    ApplyMovement obj_D49R0101_gsleader3, _02AC
    ApplyMovement LOCALID_PLAYER, _0070
    GoTo _018E
_016C:
    ApplyMovement obj_D49R0101_gsleader3, _02E8
    ApplyMovement LOCALID_PLAYER, _0070
    WaitMovement
    ApplyMovement obj_D49R0101_gsleader3, _0080
    ApplyMovement LOCALID_PLAYER, _0078
_018E:
    WaitMovement
    Message msg_0138_D49R0101_00082
    CloseMessage
    Message msg_0138_D49R0101_00083
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0138_D49R0101_00084
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _01BE
    ApplyMovement obj_D49R0101_gsleader3, _0328
    GoTo _01E1
_01BE:
    CompareVar VAR_MAP_LOCAL_0x0A, 3
    GoToIf 5, _01D9
    ApplyMovement obj_D49R0101_gsleader3, _0338
    GoTo _01E1
_01D9:
    ApplyMovement obj_D49R0101_gsleader3, _0348
_01E1:
    ApplyMovement LOCALID_PLAYER, _0078
    WaitMovement
    RemoveObject obj_D49R0101_gsleader3
    SetFlag FLAG_HGSS_HIDE_POKEATHLON_RECEPTION_WHITNEY
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40E2, 1
    End
    .balign 4, 0
_0200:
    LockDir
    JumpNearFastEast
    UnlockDir
    Delay16 2
    WalkFastWest
    EndMovement
    .balign 4, 0
_0218:
    LockDir
    JumpNearFastSouth
    UnlockDir
    Delay16 2
    WalkFastNorth
    EndMovement
    .balign 4, 0
_0230:
    EmoteExclamationMark
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_023C:
    EmoteExclamationMark
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0248:
    WalkFasterEast
    WalkSlightlyFastNorth 10
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0258:
    WalkSlightlyFastNorth 9
    EndMovement
    .balign 4, 0
_0260:
    Delay2
    Delay8 8
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0270:
    WalkOnSpotNormalSouth
    Delay8
    WalkOnSpotNormalNorth
    Delay8
    WalkFastEast 6
    WalkFastNorth 6
    WalkNormalWest
    SetInvisible
    Delay16 2
    FaceEast
    SetVisible
    WalkNormalEast
    WalkFastSouth 6
    WalkFastWest 6
    EndMovement
    .balign 4, 0
_02AC:
    WalkFastEast 7
    WalkOnSpotNormalSouth
    Delay8
    WalkOnSpotNormalNorth
    Delay8
    WalkFastNorth 7
    WalkNormalWest
    SetInvisible
    Delay16 2
    FaceEast
    SetVisible
    WalkNormalEast
    WalkFastSouth 6
    WalkFastWest 6
    EndMovement
    .balign 4, 0
_02E8:
    WalkFastEast 7
    WalkOnSpotNormalSouth
    Delay8
    WalkOnSpotNormalNorth
    Delay8
    WalkFastNorth 7
    WalkNormalWest
    SetInvisible
    Delay16 2
    FaceEast
    SetVisible
    WalkNormalEast
    WalkFastSouth 7
    WalkFastWest 7
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0328:
    WalkSlightlyFastSouth 2
    WalkSlightlyFastWest
    WalkSlightlyFastSouth 8
    EndMovement
    .balign 4, 0
_0338:
    WalkSlightlyFastSouth
    WalkSlightlyFastWest
    WalkSlightlyFastSouth 9
    EndMovement
    .balign 4, 0
_0348:
    WalkSlightlyFastSouth 9
    EndMovement
scr_seq_D49R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_UNK_114, _03F1
    @ HGSS: ScrCmd_834 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0400
    Message msg_0138_D49R0101_00049
_0377:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 325, 0
    AddMenuEntry 324, 1
    AddMenuEntry 323, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _03C7
    CompareVar VAR_0x8008, 1
    GoToIf 1, _03D7
    GoTo _03E4
    CloseMessage
    ReleaseAll
    End
_03C7:
    CloseMessageWithoutErasing
    @ HGSS: ScrCmd_815 0
    @ HGSS: ScrCmd_771
    GoTo _03E4
    End
_03D7:
    Message msg_0138_D49R0101_00052
    GoTo _0377
    End
_03E4:
    Message msg_0138_D49R0101_00051
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03F1:
    Message msg_0138_D49R0101_00048
    SetFlag FLAG_HGSS_UNK_114
    GoTo _0377
    End
_0400:
    Message msg_0138_D49R0101_00050
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0101_002:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _05B7
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_835 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 27
    GoToIf 1, _05A9
    GoToIfUnset FLAG_HGSS_UNK_115, _0529
    Message msg_0138_D49R0101_00054
_0443:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 325, 0
    AddMenuEntry 324, 1
    AddMenuEntry 323, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0493
    CompareVar VAR_0x8008, 1
    GoToIf 1, _04E8
    GoTo _051C
    CloseMessage
    ReleaseAll
    End
_0493:
    CloseMessageWithoutErasing
    @ HGSS: ScrCmd_815 0
    @ HGSS: ScrCmd_772
    @ HGSS: ScrCmd_835 VAR_SPECIAL_x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _0538
    CompareVar VAR_0x8005, 12
    GoToIf 1, _054B
    CompareVar VAR_0x8005, 18
    GoToIf 1, _055E
    CompareVar VAR_0x8005, 24
    GoToIf 1, _0571
    CompareVar VAR_0x8005, 27
    GoToIf 1, _0595
    GoTo _051C
    End
_04E8:
    Message msg_0138_D49R0101_00055
    @ HGSS: ScrCmd_724 12, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 100
    GoToIf 0, _0509
    Message msg_0138_D49R0101_00057
    GoTo _0511
_0509:
    BufferNumber 0, VAR_RESULT
    Message msg_0138_D49R0101_00056
_0511:
    Message msg_0138_D49R0101_00058
    GoTo _0443
    End
_051C:
    Message msg_0138_D49R0101_00051
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0529:
    Message msg_0138_D49R0101_00053
    SetFlag FLAG_HGSS_UNK_115
    GoTo _0443
    End
_0538:
    CompareVar VAR_HGSS_UNK_4139, 0
    GoToIf 1, _0584
    GoTo _051C
_054B:
    CompareVar VAR_HGSS_UNK_4139, 1
    GoToIf 1, _0584
    GoTo _051C
_055E:
    CompareVar VAR_HGSS_UNK_4139, 2
    GoToIf 1, _0584
    GoTo _051C
_0571:
    CompareVar VAR_HGSS_UNK_4139, 3
    GoToIf 1, _0584
    GoTo _051C
_0584:
    Message msg_0138_D49R0101_00061
    WaitButton
    CloseMessage
    ReleaseAll
    AddVar VAR_HGSS_UNK_4139, 1
    End
_0595:
    BufferPlayerName 0
    Message msg_0138_D49R0101_00062
    WaitButton
    CloseMessage
    ReleaseAll
    AddVar VAR_HGSS_UNK_4139, 1
    End
_05A9:
    BufferPlayerName 0
    Message msg_0138_D49R0101_00060
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05B7:
    End
scr_seq_D49R0101_003:
    End
scr_seq_D49R0101_004:
    NPCMessage msg_0138_D49R0101_00068
    End
scr_seq_D49R0101_005:
    NPCMessage msg_0138_D49R0101_00069
    End
scr_seq_D49R0101_006:
    NPCMessage msg_0138_D49R0101_00070
    End
scr_seq_D49R0101_007:
    NPCMessage msg_0138_D49R0101_00071
    End
scr_seq_D49R0101_008:
    NPCMessage msg_0138_D49R0101_00072
    End
scr_seq_D49R0101_009:
    NPCMessage msg_0138_D49R0101_00073
    End
scr_seq_D49R0101_010:
    NPCMessage msg_0138_D49R0101_00074
    End
scr_seq_D49R0101_011:
    NPCMessage msg_0138_D49R0101_00075
    End
scr_seq_D49R0101_012:
    NPCMessage msg_0138_D49R0101_00076
    End
scr_seq_D49R0101_013:
    NPCMessage msg_0138_D49R0101_00077
    End
scr_seq_D49R0101_015:
    NPCMessage msg_0138_D49R0101_00063
    End
scr_seq_D49R0101_016:
    NPCMessage msg_0138_D49R0101_00064
    End
scr_seq_D49R0101_017:
    NPCMessage msg_0138_D49R0101_00065
    End
scr_seq_D49R0101_018:
    NPCMessage msg_0138_D49R0101_00066
    End
scr_seq_D49R0101_019:
    NPCMessage msg_0138_D49R0101_00067
    End
scr_seq_D49R0101_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScriptOverlayCmd 3, 0
    Message msg_0138_D49R0101_00085
    CompleteInitHGSSMenu 1, 1, 0, VAR_0x8000, 1
    AddMenuEntry 337, 0
    AddMenuEntry 338, 1
    AddMenuEntry 12, 2
    ShowMenu
    SetVarFromVar VAR_MAP_LOCAL_0x05, VAR_0x8000
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _072E
    ShowMoney 20, 2
    GoTo _0759
    GoTo _0748
_072E:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 5, _0748
    @ HGSS: ScrCmd_116 2, 20, 2
    GoTo _0A7F
_0748:
    Message msg_0138_D49R0101_00091
    WaitButton
    CloseMessage
    ReleaseAll
    @ HGSS: ScriptOverlayCmd 3, 1
    End
_0759:
    Message msg_0138_D49R0101_00086
    CompleteInitHGSSMenu 1, 1, 0, VAR_0x8000, 1
    AddMenuEntry 209, 0
    AddMenuEntry 210, 1
    AddMenuEntry 211, 2
    AddMenuEntry 212, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_0x8000
    CompareVar VAR_0x8008, 0
    GoToIf 1, _07C0
    CompareVar VAR_0x8008, 1
    GoToIf 1, _07CC
    CompareVar VAR_0x8008, 2
    GoToIf 1, _07D8
    Message msg_0138_D49R0101_00091
    GoTo _0A5C
_07C0:
    SetVarFromValue VAR_0x8001, 30
    GoTo _08F8
_07CC:
    SetVarFromValue VAR_0x8001, 31
    GoTo _08F8
_07D8:
    SetVarFromValue VAR_0x8001, 32
    GoTo _08F8
_07E4:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _07FF
    CheckMoney VAR_RESULT, 200
    GoTo _0812
_07FF:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 5, _0812
    @ HGSS: CheckAthletePoints VAR_SPECIAL_RESULT, 50
_0812:
    Return
_0814:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _082F
    CheckMoney VAR_RESULT, 300
    GoTo _0842
_082F:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 5, _0842
    @ HGSS: CheckAthletePoints VAR_SPECIAL_RESULT, 80
_0842:
    Return
_0844:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _085F
    CheckMoney VAR_RESULT, 350
    GoTo _0872
_085F:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 5, _0872
    @ HGSS: CheckAthletePoints VAR_SPECIAL_RESULT, 100
_0872:
    Return
_0874:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _088D
    RemoveMoney 200
    GoTo _089E
_088D:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 5, _089E
    @ HGSS: TakeAthletePoints 50
_089E:
    Return
_08A0:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _08B9
    RemoveMoney 300
    GoTo _08CA
_08B9:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 5, _08CA
    @ HGSS: TakeAthletePoints 80
_08CA:
    Return
_08CC:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _08E5
    RemoveMoney 350
    GoTo _08F6
_08E5:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 5, _08F6
    @ HGSS: TakeAthletePoints 100
_08F6:
    Return
_08F8:
    CompareVar VAR_0x8000, 0
    CallIf 1, _07E4
    CompareVar VAR_0x8000, 1
    CallIf 1, _0814
    CompareVar VAR_0x8000, 2
    CallIf 1, _0844
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A07
    CanFitItem VAR_0x8001, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A35
    CompareVar VAR_0x8000, 0
    CallIf 1, _0874
    CompareVar VAR_0x8000, 1
    CallIf 1, _08A0
    CompareVar VAR_0x8000, 2
    CallIf 1, _08CC
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _097D
    UpdateMoneyDisplay
    GoTo _098D
_097D:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 5, _098D
    @ HGSS: ScrCmd_118 2
_098D:
    BufferItemName 0, VAR_0x8001
    PlaySE SEQ_SE_DP_JIHANKI_sseq
    BufferItemName 0, VAR_0x8001
    Message msg_0138_D49R0101_00087
    SetVar VAR_0x8004, VAR_0x8001
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GetRandom VAR_RESULT, 64
    CompareVar VAR_RESULT, 0
    GoToIf 5, _09E6
    PlaySE SEQ_SE_DP_JIHANKI_sseq
    BufferItemName 0, VAR_0x8001
    Message msg_0138_D49R0101_00088
    CanFitItem VAR_0x8001, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A35
    Common_GiveItemQuantity
_09E6:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _09FF
    GoTo _0759
    GoTo _0A05
_09FF:
    GoTo _0A7F
_0A05:
    End
_0A07:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0A1F
    Message msg_0138_D49R0101_00089
    GoTo _0A2F
_0A1F:
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 5, _0A2F
    Message msg_0138_D49R0101_00090
_0A2F:
    GoTo _0A5C
_0A35:
    Common_MessageBagIsFull
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0A52
    HideMoney
    GoTo _0A54
_0A52:
    @ HGSS: ScrCmd_117
_0A54:
    @ HGSS: ScriptOverlayCmd 3, 1
    ReleaseAll
    End
_0A5C:
    WaitButton
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0A75
    HideMoney
    GoTo _0A77
_0A75:
    @ HGSS: ScrCmd_117
_0A77:
    @ HGSS: ScriptOverlayCmd 3, 1
    ReleaseAll
    End
_0A7F:
    Message msg_0138_D49R0101_00086
    CompleteInitHGSSMenu 1, 1, 0, VAR_0x8000, 1
    AddMenuEntry 339, 0
    AddMenuEntry 340, 1
    AddMenuEntry 341, 2
    AddMenuEntry 212, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_0x8000
    CompareVar VAR_0x8008, 0
    GoToIf 1, _07C0
    CompareVar VAR_0x8008, 1
    GoToIf 1, _07CC
    CompareVar VAR_0x8008, 2
    GoToIf 1, _07D8
    Message msg_0138_D49R0101_00091
    GoTo _0A5C
    End
scr_seq_D49R0101_020:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0138_D49R0101_00092
_0AF3:
    Message msg_0138_D49R0101_00093
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 94, 0
    AddMenuEntry 95, 1
    AddMenuEntry 96, 2
    AddMenuEntry 97, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B57
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0B65
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0B73
    GoTo _0BA5
    End
_0B57:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    GoTo _0B81
    End
_0B65:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 1
    GoTo _0B81
    End
_0B73:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 2
    GoTo _0B81
    End
_0B81:
    Message msg_0138_D49R0101_00098
    WaitTime 4, VAR_RESULT
    Message msg_0138_D49R0101_00099
    WaitTime 4, VAR_RESULT
    CloseMessage
    PlaySE SEQ_SE_DP_DECIDE_sseq
    @ HGSS: ScrCmd_743 VAR_TEMP_x4007
    GoTo _0AF3
    End
_0BA5:
    Message msg_0138_D49R0101_00101
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0101_021:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_152, _0C4C
    Message msg_0138_D49R0101_00103
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0BFE
    Message msg_0138_D49R0101_00105
    @ HGSS: ScrCmd_724 14, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 1000
    GoToIf 4, _0C09
    Message msg_0138_D49R0101_00106
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0BFE:
    Message msg_0138_D49R0101_00104
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C09:
    Message msg_0138_D49R0101_00107
    SetVar VAR_0x8004, ITEM_RARE_CANDY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C42
    Common_GiveItemQuantity
    @ HGSS: ScrCmd_725 0, 100
    SetFlag FLAG_HGSS_UNK_152
    GoTo _0C4C
    End
_0C42:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0C4C:
    Message msg_0138_D49R0101_00108
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0101_022:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_153, _0CF0
    @ HGSS: ScrCmd_724 15, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 500
    GoToIf 4, _0C86
    Message msg_0138_D49R0101_00109
    GoTo _0C9F
_0C86:
    CompareVar VAR_MAP_LOCAL_0x00, 1000
    GoToIf 4, _0C9C
    Message msg_0138_D49R0101_00111
    GoTo _0C9F
_0C9C:
    Message msg_0138_D49R0101_00112
_0C9F:
    CompareVar VAR_MAP_LOCAL_0x00, 2001
    GoToIf 4, _0CB7
    Message msg_0138_D49R0101_00110
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0CB7:
    Message msg_0138_D49R0101_00113
    SetVar VAR_0x8004, ITEM_RARE_CANDY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C42
    Common_GiveItemQuantity
    @ HGSS: ScrCmd_725 0, 100
    SetFlag FLAG_HGSS_UNK_153
    GoTo _0CF0
    End
_0CF0:
    Message msg_0138_D49R0101_00114
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
