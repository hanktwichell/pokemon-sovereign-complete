#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0538.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T11R0702_rotomf 0
#define obj_T11R0702_rotoms 1
#define obj_T11R0702_rotomi 2
#define obj_T11R0702_rotomw 3
#define obj_T11R0702_rotomg 4

    ScriptEntry scr_seq_T11R0702_000
    ScriptEntry scr_seq_T11R0702_001
    ScriptEntry scr_seq_T11R0702_002
    ScriptEntry scr_seq_T11R0702_003
    ScriptEntry scr_seq_T11R0702_004
    ScriptEntry scr_seq_T11R0702_005
    ScriptEntry scr_seq_T11R0702_006
    ScriptEntry scr_seq_T11R0702_007
    ScriptEntry scr_seq_T11R0702_008
    ScriptEntryEnd
scr_seq_T11R0702_006:
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_HEAT
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_WASH
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FROST
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FAN
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_MOW
    @ HGSS: GetOwnedRotomForms VAR_TEMP_x4000, VAR_TEMP_x4001, VAR_TEMP_x4002, VAR_TEMP_x4003, VAR_TEMP_x4004
    CompareVar VAR_MAP_LOCAL_0x00, 0
    CallIf 1, _01A2
    CompareVar VAR_MAP_LOCAL_0x01, 0
    CallIf 1, _01A8
    CompareVar VAR_MAP_LOCAL_0x02, 0
    CallIf 1, _01AE
    CompareVar VAR_MAP_LOCAL_0x03, 0
    CallIf 1, _01B4
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _01BA
    End
scr_seq_T11R0702_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 1
    GoTo _01C0
scr_seq_T11R0702_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 4
    GoTo _01C0
scr_seq_T11R0702_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 3
    GoTo _01C0
scr_seq_T11R0702_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 2
    GoTo _01C0
scr_seq_T11R0702_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 5
    GoTo _01C0
scr_seq_T11R0702_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: CountTranformedRotomsInParty VAR_SPECIAL_x8003, VAR_SPECIAL_RESULT
    CompareVar VAR_0x8003, 0
    GoToIf 1, _0240
    Message msg_0538_T11R0702_00013
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 14, 0
    AddMenuEntry 19, 1
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _024D
    GoTo _026C
scr_seq_T11R0702_000:
    NPCMessage msg_0538_T11R0702_00035
    End
scr_seq_T11R0702_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0538_T11R0702_00044
    PlayCry SPECIES_CLAYDOL, 0
    WaitCry
    WaitButton
    CloseMessage
    @ HGSS: ScrCmd_600
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    BufferPlayerName 0
    ApplyMovement LOCALID_PLAYER, _094A
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_WHITE
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_GOLDENROD, 352, 369, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_WHITE
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    Message msg_0538_T11R0702_00045
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A2:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_HEAT
    Return
_01A8:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_WASH
    Return
_01AE:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FROST
    Return
_01B4:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FAN
    Return
_01BA:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_MOW
    Return
_01C0:
    CheckPartyHasSpecies VAR_RESULT, SPECIES_ROTOM
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0274
    CompareVar VAR_0x8004, 1
    CallIf 1, _02BB
    CompareVar VAR_0x8004, 3
    CallIf 1, _02C0
    CompareVar VAR_0x8004, 2
    CallIf 1, _02C5
    CompareVar VAR_0x8004, 4
    CallIf 1, _02CA
    CompareVar VAR_0x8004, 5
    CallIf 1, _02CF
    @ HGSS: CountTranformedRotomsInParty VAR_SPECIAL_x8003, VAR_SPECIAL_RESULT
    CompareVar VAR_0x8003, 1
    GoToIf 4, _02D4
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _031E
    GoTo _0376
_0240:
    Message msg_0538_T11R0702_00018
    WaitButton
    CloseMessage
    GoTo _03D0
_024D:
    @ HGSS: CountTranformedRotomsInParty VAR_SPECIAL_x8003, VAR_SPECIAL_RESULT
    SetVarFromVar VAR_0x8000, VAR_RESULT
    CompareVar VAR_0x8003, 2
    GoToIf 4, _03D4
    GoTo _043F
_026C:
    CloseMessage
    ReleaseAll
    End
_0274:
    CompareVar VAR_0x8004, 1
    CallIf 1, _04AC
    CompareVar VAR_0x8004, 3
    CallIf 1, _04B1
    CompareVar VAR_0x8004, 2
    CallIf 1, _04B6
    CompareVar VAR_0x8004, 4
    CallIf 1, _04BB
    CompareVar VAR_0x8004, 5
    CallIf 1, _04C0
    GoTo _026C
_02BB:
    Message msg_0538_T11R0702_00021
    Return
_02C0:
    Message msg_0538_T11R0702_00024
    Return
_02C5:
    Message msg_0538_T11R0702_00027
    Return
_02CA:
    Message msg_0538_T11R0702_00030
    Return
_02CF:
    Message msg_0538_T11R0702_00033
    Return
_02D4:
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 15, 0
    AddMenuEntry 14, 1
    AddMenuEntry 16, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0376
    CompareVar VAR_0x8008, 1
    GoToIf 1, _024D
    GoTo _031E
_031E:
    CompareVar VAR_0x8004, 1
    CallIf 1, _04C5
    CompareVar VAR_0x8004, 3
    CallIf 1, _04CC
    CompareVar VAR_0x8004, 2
    CallIf 1, _04D3
    CompareVar VAR_0x8004, 4
    CallIf 1, _04DA
    CompareVar VAR_0x8004, 5
    CallIf 1, _04E1
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    CallIf 1, _04E8
    @ HGSS: NopVar490 VAR_TEMP_x4006
    GoTo _026C
_0376:
    CompareVar VAR_0x8004, 1
    CallIf 1, _04FC
    CompareVar VAR_0x8004, 3
    CallIf 1, _0504
    CompareVar VAR_0x8004, 2
    CallIf 1, _050C
    CompareVar VAR_0x8004, 4
    CallIf 1, _0514
    CompareVar VAR_0x8004, 5
    CallIf 1, _051C
    @ HGSS: CountPartyMonsOfSpecies VAR_SPECIAL_RESULT, SPECIES_ROTOM
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0524
    GoTo _0530
_03D0:
    ReleaseAll
    End
_03D4:
    Message msg_0538_T11R0702_00007
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _0588
    GetPartyMonSpecies VAR_0x8000, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _058E
    CompareVar VAR_RESULT, 479
    GoToIf 5, _0599
    GetPartyMonForm VAR_0x8000, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05A4
    GoTo _043F
_043F:
    BufferPartyMonNickname 0, VAR_0x8000
    Message msg_0538_T11R0702_00011
    @ HGSS: UpdateRotomForm VAR_SPECIAL_x8000, 0, 0, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    GetPartyMonForm VAR_0x8000, VAR_0x8004
    CompareVar VAR_0x8004, 1
    CallIf 1, _05AF
    CompareVar VAR_0x8004, 3
    CallIf 1, _05B9
    CompareVar VAR_0x8004, 2
    CallIf 1, _05C3
    CompareVar VAR_0x8004, 4
    CallIf 1, _05CD
    CompareVar VAR_0x8004, 5
    CallIf 1, _05D7
    GoTo _05E1
_04AC:
    Message msg_0538_T11R0702_00020
    Return
_04B1:
    Message msg_0538_T11R0702_00023
    Return
_04B6:
    Message msg_0538_T11R0702_00026
    Return
_04BB:
    Message msg_0538_T11R0702_00029
    Return
_04C0:
    Message msg_0538_T11R0702_00032
    Return
_04C5:
    Message msg_0538_T11R0702_00022
    WaitButton
    Return
_04CC:
    Message msg_0538_T11R0702_00025
    WaitButton
    Return
_04D3:
    Message msg_0538_T11R0702_00028
    WaitButton
    Return
_04DA:
    Message msg_0538_T11R0702_00031
    WaitButton
    Return
_04E1:
    Message msg_0538_T11R0702_00034
    WaitButton
    Return
_04E8:
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _093A
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    Return
_04FC:
    SetVarFromValue VAR_0x8001, 315
    Return
_0504:
    SetVarFromValue VAR_0x8001, 59
    Return
_050C:
    SetVarFromValue VAR_0x8001, 56
    Return
_0514:
    SetVarFromValue VAR_0x8001, 403
    Return
_051C:
    SetVarFromValue VAR_0x8001, 437
    Return
_0524:
    FindPartySlotWithSpecies VAR_0x8000, SPECIES_ROTOM
    GoTo _061E
_0530:
    Message msg_0538_T11R0702_00007
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _031E
    GetPartyMonSpecies VAR_0x8000, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _058E
    CompareVar VAR_RESULT, 479
    GoToIf 5, _0599
    GoTo _061E
_0588:
    ReleaseAll
    End
_058E:
    Message msg_0538_T11R0702_00008
    WaitButton
    GoTo _026C
_0599:
    Message msg_0538_T11R0702_00009
    WaitButton
    GoTo _026C
_05A4:
    Message msg_0538_T11R0702_00017
    WaitButton
    GoTo _026C
_05AF:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_HEAT
    AddObject obj_T11R0702_rotomf
    Return
_05B9:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FROST
    AddObject obj_T11R0702_rotomi
    Return
_05C3:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_WASH
    AddObject obj_T11R0702_rotomw
    Return
_05CD:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FAN
    AddObject obj_T11R0702_rotoms
    Return
_05D7:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_MOW
    AddObject obj_T11R0702_rotomg
    Return
_05E1:
    @ HGSS: ScrCmd_815 0
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_SAFFRON_SILPH_CO_ROTOM_ROOM, VAR_0x8006, VAR_0x8007, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NopVar490 VAR_TEMP_x400B
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    CallIf 1, _04E8
    GoTo _03D0
_061E:
    CheckPartyMonHasMove VAR_RESULT, MOVE_OVERHEAT, VAR_0x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06A6
    CheckPartyMonHasMove VAR_RESULT, MOVE_BLIZZARD, VAR_0x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06A6
    CheckPartyMonHasMove VAR_RESULT, MOVE_HYDRO_PUMP, VAR_0x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06A6
    CheckPartyMonHasMove VAR_RESULT, MOVE_AIR_SLASH, VAR_0x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06A6
    CheckPartyMonHasMove VAR_RESULT, MOVE_LEAF_STORM, VAR_0x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06A6
    GetPartyMonMoveCount VAR_RESULT, VAR_0x8000
    SetVarFromVar VAR_0x8002, VAR_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _06B2
    GoTo _071E
_06A6:
    SetVarFromValue VAR_0x8002, 0
    GoTo _071E
_06B2:
    @ HGSS: NopVar490 VAR_TEMP_x4007
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 479
    GoToIf 5, _076C
    @ HGSS: NopVar490 VAR_TEMP_x4000
    @ HGSS: NopVar490 VAR_SPECIAL_x8000
    CompareVar VAR_MAP_LOCAL_0x00, VAR_0x8000
    GoToIf 5, _0790
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0940
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    BufferPartyMonNickname 0, VAR_0x8000
    BufferMoveName 1, VAR_0x8001
    Message msg_0538_T11R0702_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07BA
    GoTo _07E0
_071E:
    @ HGSS: NopVar490 VAR_TEMP_x4005
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 479
    GoToIf 5, _087C
    CompareVar VAR_MAP_LOCAL_0x00, VAR_0x8000
    GoToIf 5, _088A
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0940
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    BufferPartyMonNickname 0, VAR_0x8000
    Message msg_0538_T11R0702_00010
    GoTo _089E
_076C:
    BufferPartyMonNickname 0, VAR_0x8000
    BufferMoveName 1, VAR_0x8001
    Message msg_0538_T11R0702_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07BA
    GoTo _07E0
_0790:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    BufferPartyMonNickname 0, VAR_0x8000
    BufferMoveName 1, VAR_0x8001
    Message msg_0538_T11R0702_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07BA
    GoTo _07E0
_07BA:
    BufferPartyMonNickname 0, VAR_0x8000
    BufferMoveName 1, VAR_0x8001
    Message msg_0538_T11R0702_00002
    WaitButton
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    CallIf 1, _04E8
    @ HGSS: NopVar490 VAR_TEMP_x400D
    GoTo _026C
_07E0:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    OpenSummaryScreenTeachMove VAR_0x8000, VAR_0x8001
    GetSummarySelectedMoveSlot VAR_0x8002
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8002, 4
    GoToIf 1, _08FD
    GetPartyMonMove VAR_RESULT, VAR_0x8000, VAR_0x8002
    BufferMoveName 1, VAR_RESULT
    Message msg_0538_T11R0702_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07BA
    BufferPartyMonNickname 0, VAR_0x8000
    GetPartyMonMove VAR_RESULT, VAR_0x8000, VAR_0x8002
    BufferMoveName 1, VAR_RESULT
    Message msg_0538_T11R0702_00004
    PlaySE SEQ_SE_DP_KON_sseq
    WaitSE SEQ_SE_DP_KON_sseq
    WaitTime 30, VAR_RESULT
    Message msg_0538_T11R0702_00005
    WaitTime 32, VAR_RESULT
    BufferMoveName 1, VAR_0x8001
    Message msg_0538_T11R0702_00006
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    WaitTime 16, VAR_RESULT
    GoTo _089E
_087C:
    BufferPartyMonNickname 0, VAR_0x8000
    Message msg_0538_T11R0702_00010
    GoTo _089E
_088A:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    BufferPartyMonNickname 0, VAR_0x8000
    Message msg_0538_T11R0702_00010
    GoTo _089E
_089E:
    @ HGSS: UpdateRotomForm VAR_SPECIAL_x8000, VAR_SPECIAL_x8002, VAR_SPECIAL_x8001, VAR_SPECIAL_x8004
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    CompareVar VAR_0x8004, 1
    CallIf 1, _091C
    CompareVar VAR_0x8004, 4
    CallIf 1, _0922
    CompareVar VAR_0x8004, 3
    CallIf 1, _0928
    CompareVar VAR_0x8004, 2
    CallIf 1, _092E
    CompareVar VAR_0x8004, 5
    CallIf 1, _0934
    GoTo _05E1
_08FD:
    BufferMoveName 1, VAR_0x8001
    Message msg_0538_T11R0702_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07E0
    GoTo _07BA
_091C:
    RemoveObject obj_T11R0702_rotomf
    Return
_0922:
    RemoveObject obj_T11R0702_rotoms
    Return
_0928:
    RemoveObject obj_T11R0702_rotomi
    Return
_092E:
    RemoveObject obj_T11R0702_rotomw
    Return
_0934:
    RemoveObject obj_T11R0702_rotomg
    Return
    .balign 4, 0
_093A:
    SetVisible
    EndMovement
    .balign 4, 0
_0940:
    JumpOnSpotSlowSouth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_094A:
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast
    SetInvisible 0
    EndMovement
    .balign 4, 0
