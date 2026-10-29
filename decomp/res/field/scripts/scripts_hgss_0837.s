#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0537.h"

#define obj_T11R0701_daigo 2

    ScriptEntry scr_seq_T11R0701_000
    ScriptEntry scr_seq_T11R0701_001
    ScriptEntry scr_seq_T11R0701_002
    ScriptEntry scr_seq_T11R0701_003
    ScriptEntry scr_seq_T11R0701_004
    ScriptEntry scr_seq_T11R0701_005
    ScriptEntryEnd
scr_seq_T11R0701_002:
    SetVarFromValue VAR_MAP_LOCAL_0x08, 0
    SetVarFromValue VAR_MAP_LOCAL_0x09, 0
    CompareVar VAR_HGSS_UNK_4130, 3
    GoToIf 1, _0046
    @ HGSS: PlayerHasSpecies VAR_TEMP_x4000, SPECIES_ROTOM
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _00AB
_0046:
    SetVarFromValue VAR_MAP_LOCAL_0x09, 1
    ClearFlag FLAG_HGSS_UNK_281
    ClearFlag FLAG_HGSS_UNK_282
    GoToIfSet FLAG_HGSS_TRADE_STEVEN_FORRETRESS_BELDUM, _0099
    CompareVar VAR_HGSS_UNK_4130, 4
    GoToIf 1, _0099
    CompareVar VAR_HGSS_UNK_4130, 1
    GoToIf 3, _0099
    CompareVar VAR_HGSS_UNK_40FD, 0
    GoToIf 1, _0099
    ClearFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    CompareVar VAR_HGSS_UNK_4130, 5
    CallIf 1, _00A5
    End
_0099:
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    Call _00C3
    End
_00A5:
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    Return
_00AB:
    SetFlag FLAG_HGSS_UNK_0A0
    SetFlag FLAG_HGSS_UNK_281
    SetFlag FLAG_HGSS_UNK_282
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    Call _00C3
    End
_00C3:
    SetVarFromValue VAR_MAP_LOCAL_0x08, 1
    Return
scr_seq_T11R0701_005:
    CompareVar VAR_MAP_LOCAL_0x09, 1
    GoToIf 5, _00E0
    SetWarpEventPos 1, 23, 2
_00E0:
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _0106
    CompareVar VAR_HGSS_UNK_4130, 3
    GoToIf 2, _0106
    SetPosition obj_T11R0701_daigo, 22, 0, 8, DIR_NORTH
_0106:
    End
scr_seq_T11R0701_000:
    NPCMessage msg_0537_T11R0701_00000
    End
scr_seq_T11R0701_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_UPGRADE_FROM_SAFFRON_CITY_GUARD, _015A
    Message msg_0537_T11R0701_00001
    SetVar VAR_0x8004, ITEM_UPGRADE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0165
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_UPGRADE_FROM_SAFFRON_CITY_GUARD
_015A:
    Message msg_0537_T11R0701_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0165:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_T11R0701_004:
    GoToIfSet FLAG_HGSS_GOT_HOENN_STARTER_FROM_STEVEN, _03E8
    CompareVar VAR_HGSS_UNK_4130, 3
    GoToIf 1, _039B
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_HGSS_UNK_4130, 3
    Message msg_0537_T11R0701_00014
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _01B7
    ApplyMovement obj_T11R0701_daigo, _03AC
    GoTo _01DA
_01B7:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _01D2
    ApplyMovement obj_T11R0701_daigo, _03BC
    GoTo _01DA
_01D2:
    ApplyMovement obj_T11R0701_daigo, _03B4
_01DA:
    WaitMovement
    ApplyMovement obj_T11R0701_daigo, _03C4
    WaitMovement
    Message msg_0537_T11R0701_00015
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0204
    ApplyMovement obj_T11R0701_daigo, _03AC
    GoTo _0227
_0204:
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _021F
    ApplyMovement obj_T11R0701_daigo, _03BC
    GoTo _0227
_021F:
    ApplyMovement obj_T11R0701_daigo, _03B4
_0227:
    WaitMovement
    Message msg_0537_T11R0701_00016
_022C:
    InitLocalTextMenu 1, 1, 0, VAR_0x8004, 1
    AddMenuEntryImm 17, 0
    AddMenuEntryImm 18, 1
    AddMenuEntryImm 19, 2
    AddMenuEntryImm 27, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_0x8004
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0346
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _033B
    CompareVar VAR_0x8004, 0
    GoToIf 5, _0297
    SetVarFromValue VAR_0x8004, 252
    GoTo _02B6
_0297:
    CompareVar VAR_0x8004, 1
    GoToIf 5, _02B0
    SetVarFromValue VAR_0x8004, 255
    GoTo _02B6
_02B0:
    SetVarFromValue VAR_0x8004, 258
_02B6:
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    BufferPlayerName 0
    Message msg_0537_T11R0701_00020
    PlayFanfare SEQ_FANFA5_sseq
    Message msg_0537_T11R0701_00021
    WaitFanfare
    @ HGSS: GiveMon VAR_SPECIAL_x8004, 5, 0, 0, 0, VAR_SPECIAL_RESULT
    Message msg_0537_T11R0701_00025
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0351
_02F3:
    Message msg_0537_T11R0701_00022
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0317
    ApplyMovement obj_T11R0701_daigo, _03DC
    GoTo _031F
_0317:
    ApplyMovement obj_T11R0701_daigo, _03CC
_031F:
    WaitMovement
    RemoveObject obj_T11R0701_daigo
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    SetFlag FLAG_HGSS_GOT_HOENN_STARTER_FROM_STEVEN
    SetVarFromValue VAR_HGSS_UNK_4130, 4
    ClearFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    ReleaseAll
    End
_033B:
    Message msg_0537_T11R0701_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0346:
    Message msg_0537_T11R0701_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0351:
    CloseMessage
    GetPartyCount VAR_RESULT
    SubVar VAR_RESULT, 1
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_815 0
    @ HGSS: NicknameInput VAR_SPECIAL_RESULT, VAR_TEMP_x4000
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _02F3
    Message msg_0537_T11R0701_00026
    GoTo _02F3
_039B:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0537_T11R0701_00024
    GoTo _022C
    .balign 4, 0
_03AC:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03B4:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_03BC:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_03C4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03CC:
    WalkNormalWest 2
    WalkNormalSouth 3
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_03DC:
    WalkNormalSouth 3
    WalkNormalWest 10
    EndMovement
_03E8:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_UNK_4130, 6
    CompareVar VAR_MAP_LOCAL_0x0A, 77
    GoToIf 5, _040C
    Message msg_0537_T11R0701_00008
    GoTo _0415
_040C:
    Message msg_0537_T11R0701_00007
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 77
_0415:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04EA
    Message msg_0537_T11R0701_00009
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_566
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _04EA
    @ HGSS: LoadNPCTrade 12
    SetVarFromVar VAR_0x8004, VAR_RESULT
    @ HGSS: MonGetFriendship VAR_TEMP_x4002, VAR_SPECIAL_x8004
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    @ HGSS: NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _04F5
    @ HGSS: NPCTradeExec VAR_SPECIAL_x8004
    @ HGSS: NPCTradeEnd
    SetFlag FLAG_HGSS_TRADE_STEVEN_FORRETRESS_BELDUM
    CompareVar VAR_MAP_LOCAL_0x02, 200
    GoToIf 0, _04A2
    Message msg_0537_T11R0701_00013
    GoTo _04A5
_04A2:
    Message msg_0537_T11R0701_00012
_04A5:
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _04C6
    ApplyMovement obj_T11R0701_daigo, _0504
    GoTo _04CE
_04C6:
    ApplyMovement obj_T11R0701_daigo, _051C
_04CE:
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T11R0701_daigo
    SetFlag FLAG_HGSS_HIDE_SAFFRON_CITY_STEVEN
    SetVarFromValue VAR_HGSS_UNK_4130, 7
    ReleaseAll
    End
_04EA:
    Message msg_0537_T11R0701_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04F5:
    @ HGSS: NPCTradeEnd
    Message msg_0537_T11R0701_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0504:
    WalkNormalWest 2
    WalkNormalSouth 5
    WalkNormalWest
    WalkNormalSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_051C:
    WalkNormalSouth 5
    WalkNormalWest 3
    WalkNormalSouth
    SetInvisible
    EndMovement
scr_seq_T11R0701_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0537_T11R0701_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
