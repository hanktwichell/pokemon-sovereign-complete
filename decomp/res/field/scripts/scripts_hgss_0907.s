#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0600.h"


    ScriptEntry scr_seq_T25R1201_000
    ScriptEntry scr_seq_T25R1201_001
    ScriptEntry scr_seq_T25R1201_002
    ScriptEntry scr_seq_T25R1201_003
    ScriptEntry scr_seq_T25R1201_004
    ScriptEntry scr_seq_T25R1201_005
    ScriptEntry scr_seq_T25R1201_006
    ScriptEntry scr_seq_T25R1201_007
    ScriptEntry scr_seq_T25R1201_008
    ScriptEntry scr_seq_T25R1201_009
    ScriptEntry scr_seq_T25R1201_010
    ScriptEntry scr_seq_T25R1201_011
    ScriptEntry scr_seq_T25R1201_012
    ScriptEntry scr_seq_T25R1201_013
    ScriptEntry scr_seq_T25R1201_014
    ScriptEntry scr_seq_T25R1201_015
    ScriptEntry scr_seq_T25R1201_016
    ScriptEntry scr_seq_T25R1201_017
    ScriptEntryEnd
    @ HGSS data: .byte 19, 253
scr_seq_T25R1201_001:
    CompareVar VAR_HGSS_UNK_4133, 6
    CallIf 1, _005B
    End
_005B:
    ShowObject LOCALID_PLAYER
    Return
scr_seq_T25R1201_002:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 1, _0084
    GoTo _009D
    GoTo _0097
_0084:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 1, _0097
    GoTo _009D
_0097:
    Call _00A7
_009D:
    SetVarFromValue VAR_HGSS_UNK_4133, 0
    ReleaseAll
    End
_00A7:
    @ HGSS: ScrCmd_307 0, 0, 8, 2, 77
    Call _00F5
    @ HGSS: ScrCmd_374 obj_player
    ApplyMovement LOCALID_PLAYER, _0108
    WaitMovement
    Call _00FD
    @ HGSS: ScrCmd_307 0, 0, 8, 4, 77
    Call _00F5
    ApplyMovement LOCALID_PLAYER, _0118
    WaitMovement
    Call _00FD
    SetVarFromValue VAR_HGSS_UNK_4133, 0
    Return
_00F5:
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    Return
_00FD:
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    Return
    .balign 4, 0
_0108:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0118:
    WalkNormalSouth 2
    EndMovement
scr_seq_T25R1201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: PartyLegalCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03C4
    GoToIfSet FLAG_HGSS_UNK_112, _0354
    SetFlag FLAG_HGSS_UNK_112
    Message msg_0600_T25R1201_00000
_014B:
_014D:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 131, 0
    AddMenuEntry 130, 1
    AddMenuEntry 132, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0227
    CompareVar VAR_0x8008, 1
    GoToIf 1, _01A4
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0330
    GoTo _0330
    End
_01A4:
    Message msg_0600_T25R1201_00002
    GoTo _01AF
    End
_01AF:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 133, 0
    AddMenuEntry 134, 1
    AddMenuEntry 135, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0206
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0211
    CompareVar VAR_0x8008, 2
    GoToIf 1, _021C
    GoTo _021C
    End
_0206:
    Message msg_0600_T25R1201_00003
    GoTo _01AF
    End
_0211:
    Message msg_0600_T25R1201_00004
    GoTo _01AF
    End
_021C:
    Message msg_0600_T25R1201_00005
    GoTo _014D
    End
_0227:
    CountPartyNonEggs VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 0, _0240
    GoTo _035F
    End
_0240:
    Message msg_0600_T25R1201_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_024D:
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0343
    HealParty
    SetVarFromValue VAR_HGSS_UNK_4133, 6
    Message msg_0600_T25R1201_00007
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _03A0
    WaitMovement
    @ HGSS: ScrCmd_307 0, 0, 8, 4, 77
    Call _00F5
    ApplyMovement LOCALID_PLAYER, _03B4
    WaitMovement
    Call _00FD
    @ HGSS: ScrCmd_307 0, 0, 8, 2, 77
    Call _00F5
    ApplyMovement LOCALID_PLAYER, _03AC
    WaitMovement
    ShowObject LOCALID_PLAYER
    ApplyMovement LOCALID_PLAYER, _03BC
    WaitMovement
    Call _00FD
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_579
    @ HGSS: ScrCmd_815 0
    @ HGSS: ScrCmd_166 VAR_SPECIAL_RESULT
    SetVarFromVar VAR_0x8004, VAR_RESULT
    @ HGSS: ScrCmd_165 VAR_SPECIAL_x8004, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0314
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Call _00A7
    ReleaseAll
    End
_0314:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Call _00A7
    GoTo _0343
    End
_0330:
    SetVarFromValue VAR_HGSS_UNK_4133, 0
    Message msg_0600_T25R1201_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0343:
    SetVarFromValue VAR_HGSS_UNK_4133, 0
    Message msg_0600_T25R1201_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0354:
    Message msg_0600_T25R1201_00001
    GoTo _014B
    End
_035F:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0378
    GoTo _024D
    End
_0378:
    GetPCBoxesFreeSlotCount VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0391
    GoTo _024D
    End
_0391:
    Message msg_0600_T25R1201_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_03A0:
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03AC:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_03B4:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_03BC:
    FaceSouth
    EndMovement
_03C4:
    @ HGSS: CallStd std_party_illegal
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1201_003:
    NPCMessage msg_0600_T25R1201_00010
    End
scr_seq_T25R1201_004:
    NPCMessage msg_0600_T25R1201_00011
    End
scr_seq_T25R1201_005:
    NPCMessage msg_0600_T25R1201_00012
    End
scr_seq_T25R1201_006:
    NPCMessage msg_0600_T25R1201_00013
    End
scr_seq_T25R1201_007:
    NPCMessage msg_0600_T25R1201_00014
    End
scr_seq_T25R1201_008:
    NPCMessage msg_0600_T25R1201_00015
    End
scr_seq_T25R1201_009:
    NPCMessage msg_0600_T25R1201_00016
    End
scr_seq_T25R1201_010:
    NPCMessage msg_0600_T25R1201_00017
    End
scr_seq_T25R1201_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8005, 3
    GoTo _047C
    End
_047C:
    Message msg_0600_T25R1201_00031
    InitLocalTextMenu 21, 11, 0, VAR_RESULT, 1
    AddMenuEntry 33, 0
    AddMenuEntry 34, 1
    AddMenuEntry 35, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _04D3
    CompareVar VAR_0x8008, 1
    GoToIf 1, _04F8
    GoTo _04CB
    End
_04CB:
_04CD:
    CloseMessage
    ReleaseAll
    End
_04D3:
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04CD
    CloseMessage
    @ HGSS: ScrCmd_815 0
    CallCommonScript 0x802
    ReleaseAll
    End
_04F8:
    Message msg_0600_T25R1201_00032
    GoTo _047C
    End
scr_seq_T25R1201_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8005, 4
    GoTo _0517
    End
_0517:
    Message msg_0600_T25R1201_00029
    InitLocalTextMenu 21, 11, 0, VAR_RESULT, 1
    AddMenuEntry 33, 0
    AddMenuEntry 34, 1
    AddMenuEntry 35, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _056E
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0593
    GoTo _0566
    End
_0566:
_0568:
    CloseMessage
    ReleaseAll
    End
_056E:
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0568
    CloseMessage
    @ HGSS: ScrCmd_815 0
    CallCommonScript 0x802
    ReleaseAll
    End
_0593:
    Message msg_0600_T25R1201_00030
    GoTo _0517
    End
scr_seq_T25R1201_013:
    NPCMessage msg_0600_T25R1201_00027
    End
scr_seq_T25R1201_014:
    NPCMessage msg_0600_T25R1201_00028
    End
scr_seq_T25R1201_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: PartyLegalCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0622
    SetVarFromValue VAR_0x8000, 0
    GetPartyMonSpecies VAR_0x8000, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _064D
    BufferPartyMonSpecies 0, 0
    Message msg_0600_T25R1201_00018
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _062D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _063A
    End
_0622:
    Message msg_0600_T25R1201_00023
    GoTo _067F
    End
_062D:
    SetFavoriteMon
    Message msg_0600_T25R1201_00020
    GoTo _067F
    End
_063A:
    BufferPartyMonSpecies 0, 0
    Message msg_0600_T25R1201_00021
    GoTo _067F
    End
    Message msg_0600_T25R1201_00018
_064D:
    Message msg_0600_T25R1201_00019
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _062D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0674
    End
_0674:
    Message msg_0600_T25R1201_00022
    GoTo _067F
    End
_067F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1201_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0600_T25R1201_00024
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06D1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: ScrCmd_681 VAR_SPECIAL_x8004
    CompareVar VAR_0x8004, 0
    GoToIf 1, _06D1
    Message msg_0600_T25R1201_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06D1:
    Message msg_0600_T25R1201_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1201_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0600_T25R1201_00036
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
