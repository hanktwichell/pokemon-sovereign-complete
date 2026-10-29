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
    ScriptEntryEnd
scr_seq_T11R0702_006:
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_HEAT
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_WASH
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FROST
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FAN
    SetFlag FLAG_HGSS_HIDE_SILPH_ROTOM_MOW
    @ HGSS: GetOwnedRotomForms VAR_TEMP_x4000, VAR_TEMP_x4001, VAR_TEMP_x4002, VAR_TEMP_x4003, VAR_TEMP_x4004
    CompareVar VAR_MAP_LOCAL_0x00, 0
    CallIf 1, _0085
    CompareVar VAR_MAP_LOCAL_0x01, 0
    CallIf 1, _008B
    CompareVar VAR_MAP_LOCAL_0x02, 0
    CallIf 1, _0091
    CompareVar VAR_MAP_LOCAL_0x03, 0
    CallIf 1, _0097
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _009D
    End
_0085:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_HEAT
    Return
_008B:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_WASH
    Return
_0091:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FROST
    Return
_0097:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FAN
    Return
_009D:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_MOW
    Return
scr_seq_T11R0702_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 1
    GoTo _0107
    End
scr_seq_T11R0702_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 4
    GoTo _0107
    End
scr_seq_T11R0702_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 3
    GoTo _0107
    End
scr_seq_T11R0702_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 2
    GoTo _0107
    End
scr_seq_T11R0702_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8004, 5
    GoTo _0107
    End
_0107:
    @ HGSS: PlayerHasSpecies VAR_SPECIAL_RESULT, SPECIES_ROTOM
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07D8
    CompareVar VAR_0x8004, 1
    CallIf 1, _0724
    CompareVar VAR_0x8004, 3
    CallIf 1, _0729
    CompareVar VAR_0x8004, 2
    CallIf 1, _072E
    CompareVar VAR_0x8004, 4
    CallIf 1, _0733
    CompareVar VAR_0x8004, 5
    CallIf 1, _0738
    @ HGSS: CountTranformedRotomsInParty VAR_SPECIAL_x8003, VAR_SPECIAL_RESULT
    CompareVar VAR_0x8003, 1
    GoToIf 4, _01E5
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _073D
    GoTo _0189
    End
_0189:
    CompareVar VAR_0x8004, 1
    CallIf 1, _06FC
    CompareVar VAR_0x8004, 3
    CallIf 1, _0704
    CompareVar VAR_0x8004, 2
    CallIf 1, _070C
    CompareVar VAR_0x8004, 4
    CallIf 1, _0714
    CompareVar VAR_0x8004, 5
    CallIf 1, _071C
    @ HGSS: CountPartyMonsOfSpecies VAR_SPECIAL_RESULT, SPECIES_ROTOM
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03B2
    GoTo _03C0
    End
_01E5:
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 15, 0
    AddMenuEntryImm 14, 1
    AddMenuEntryImm 16, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0189
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0231
    GoTo _073D
    End
_0231:
    @ HGSS: CountTranformedRotomsInParty VAR_SPECIAL_x8003, VAR_SPECIAL_RESULT
    SetVarFromVar VAR_0x8000, VAR_RESULT
    CompareVar VAR_0x8003, 2
    GoToIf 4, _0332
    GoTo _0252
    End
_0252:
    BufferPartyMonNickname 0, VAR_0x8000
    Message msg_0538_T11R0702_00011
    @ HGSS: UpdateRotomForm VAR_SPECIAL_x8000, 0, 0, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    GetPartyMonForm VAR_0x8000, VAR_0x8004
    CompareVar VAR_0x8004, 1
    CallIf 1, _0300
    CompareVar VAR_0x8004, 3
    CallIf 1, _030A
    CompareVar VAR_0x8004, 2
    CallIf 1, _0314
    CompareVar VAR_0x8004, 4
    CallIf 1, _031E
    CompareVar VAR_0x8004, 5
    CallIf 1, _0328
    GoTo _02C1
    End
_02C1:
    @ HGSS: ScrCmd_815 0
    GetPlayerMapPos VAR_0x8006, VAR_0x8007
    GetPlayerDir VAR_RESULT
    Warp MAP_HEADER_HGSS_SAFFRON_SILPH_CO_ROTOM_ROOM, VAR_0x8006, VAR_0x8007, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NopVar490 VAR_TEMP_x400B
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    CallIf 1, _07BA
    GoTo _08A4
    End
_0300:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_HEAT
    AddObject obj_T11R0702_rotomf
    Return
_030A:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FROST
    AddObject obj_T11R0702_rotomi
    Return
_0314:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_WASH
    AddObject obj_T11R0702_rotomw
    Return
_031E:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_FAN
    AddObject obj_T11R0702_rotoms
    Return
_0328:
    ClearFlag FLAG_HGSS_HIDE_SILPH_ROTOM_MOW
    AddObject obj_T11R0702_rotomg
    Return
_0332:
    Message msg_0538_T11R0702_00007
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: PartySelectUI
    @ HGSS: GetPartySelection VAR_SPECIAL_x8000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _03AC
    GetPartyMonSpecies VAR_0x8000, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _041A
    CompareVar VAR_RESULT, 479
    GoToIf 5, _0427
    GetPartyMonForm VAR_0x8000, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _039F
    GoTo _0252
    End
_039F:
    Message msg_0538_T11R0702_00017
    WaitButton
    GoTo _089C
    End
_03AC:
    ReleaseAll
    End
_03B2:
    @ HGSS: GetPartySlotWithSpecies VAR_SPECIAL_x8000, SPECIES_ROTOM
    GoTo _0434
    End
_03C0:
    Message msg_0538_T11R0702_00007
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: PartySelectUI
    @ HGSS: GetPartySelection VAR_SPECIAL_x8000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _073D
    GetPartyMonSpecies VAR_0x8000, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _041A
    CompareVar VAR_RESULT, 479
    GoToIf 5, _0427
    GoTo _0434
    End
_041A:
    Message msg_0538_T11R0702_00008
    WaitButton
    GoTo _089C
    End
_0427:
    Message msg_0538_T11R0702_00009
    WaitButton
    GoTo _089C
    End
_0434:
    @ HGSS: MonHasMove VAR_SPECIAL_RESULT, MOVE_OVERHEAT, VAR_SPECIAL_x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04BE
    @ HGSS: MonHasMove VAR_SPECIAL_RESULT, MOVE_BLIZZARD, VAR_SPECIAL_x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04BE
    @ HGSS: MonHasMove VAR_SPECIAL_RESULT, MOVE_HYDRO_PUMP, VAR_SPECIAL_x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04BE
    @ HGSS: MonHasMove VAR_SPECIAL_RESULT, MOVE_AIR_SLASH, VAR_SPECIAL_x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04BE
    @ HGSS: MonHasMove VAR_SPECIAL_RESULT, MOVE_LEAF_STORM, VAR_SPECIAL_x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04BE
    @ HGSS: CountMonMoves VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000
    SetVarFromVar VAR_0x8002, VAR_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _051C
    GoTo _04CC
    End
_04BE:
    SetVarFromValue VAR_0x8002, 0
    GoTo _04CC
    End
_04CC:
    @ HGSS: NopVar490 VAR_TEMP_x4005
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 479
    GoToIf 5, _050C
    CompareVar VAR_MAP_LOCAL_0x00, VAR_0x8000
    GoToIf 5, _0506
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06F0
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
_0506:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
_050C:
    BufferPartyMonNickname 0, VAR_0x8000
    Message msg_0538_T11R0702_00010
    GoTo _0671
    End
_051C:
    @ HGSS: NopVar490 VAR_TEMP_x4007
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 479
    GoToIf 5, _0564
    @ HGSS: NopVar490 VAR_TEMP_x4000
    @ HGSS: NopVar490 VAR_SPECIAL_x8000
    CompareVar VAR_MAP_LOCAL_0x00, VAR_0x8000
    GoToIf 5, _055E
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06F0
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
_055E:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
_0564:
    BufferPartyMonNickname 0, VAR_0x8000
    BufferMoveName 1, VAR_0x8001
    Message msg_0538_T11R0702_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0649
    GoTo _058A
    End
_058A:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: PokemonSummaryScreen 1, VAR_SPECIAL_x8000, VAR_SPECIAL_x8001
    @ HGSS: GetMoveSelection 1, VAR_SPECIAL_x8002
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8002, 4
    GoToIf 1, _0628
    @ HGSS: MonGetMove VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000, VAR_SPECIAL_x8002
    BufferMoveName 1, VAR_RESULT
    Message msg_0538_T11R0702_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0649
    BufferPartyMonNickname 0, VAR_0x8000
    @ HGSS: MonGetMove VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000, VAR_SPECIAL_x8002
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
    GoTo _0671
    End
_0628:
    BufferMoveName 1, VAR_0x8001
    Message msg_0538_T11R0702_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _058A
    GoTo _0649
    End
_0649:
    BufferPartyMonNickname 0, VAR_0x8000
    BufferMoveName 1, VAR_0x8001
    Message msg_0538_T11R0702_00002
    WaitButton
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    CallIf 1, _07BA
    @ HGSS: NopVar490 VAR_TEMP_x400D
    GoTo _089C
    End
_0671:
    @ HGSS: UpdateRotomForm VAR_SPECIAL_x8000, VAR_SPECIAL_x8002, VAR_SPECIAL_x8001, VAR_SPECIAL_x8004
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    CompareVar VAR_0x8004, 1
    CallIf 1, _06D2
    CompareVar VAR_0x8004, 4
    CallIf 1, _06D8
    CompareVar VAR_0x8004, 3
    CallIf 1, _06DE
    CompareVar VAR_0x8004, 2
    CallIf 1, _06E4
    CompareVar VAR_0x8004, 5
    CallIf 1, _06EA
    GoTo _02C1
    End
_06D2:
    RemoveObject obj_T11R0702_rotomf
    Return
_06D8:
    RemoveObject obj_T11R0702_rotoms
    Return
_06DE:
    RemoveObject obj_T11R0702_rotomi
    Return
_06E4:
    RemoveObject obj_T11R0702_rotomw
    Return
_06EA:
    RemoveObject obj_T11R0702_rotomg
    Return
    .balign 4, 0
_06F0:
    JumpOnSpotSlowSouth 2
    SetInvisible
    EndMovement
_06FC:
    SetVarFromValue VAR_0x8001, 315
    Return
_0704:
    SetVarFromValue VAR_0x8001, 59
    Return
_070C:
    SetVarFromValue VAR_0x8001, 56
    Return
_0714:
    SetVarFromValue VAR_0x8001, 403
    Return
_071C:
    SetVarFromValue VAR_0x8001, 437
    Return
_0724:
    Message msg_0538_T11R0702_00021
    Return
_0729:
    Message msg_0538_T11R0702_00024
    Return
_072E:
    Message msg_0538_T11R0702_00027
    Return
_0733:
    Message msg_0538_T11R0702_00030
    Return
_0738:
    Message msg_0538_T11R0702_00033
    Return
_073D:
    CompareVar VAR_0x8004, 1
    CallIf 1, _0797
    CompareVar VAR_0x8004, 3
    CallIf 1, _079E
    CompareVar VAR_0x8004, 2
    CallIf 1, _07A5
    CompareVar VAR_0x8004, 4
    CallIf 1, _07AC
    CompareVar VAR_0x8004, 5
    CallIf 1, _07B3
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    CallIf 1, _07BA
    @ HGSS: NopVar490 VAR_TEMP_x4006
    GoTo _089C
    End
_0797:
    Message msg_0538_T11R0702_00022
    WaitButton
    Return
_079E:
    Message msg_0538_T11R0702_00025
    WaitButton
    Return
_07A5:
    Message msg_0538_T11R0702_00028
    WaitButton
    Return
_07AC:
    Message msg_0538_T11R0702_00031
    WaitButton
    Return
_07B3:
    Message msg_0538_T11R0702_00034
    WaitButton
    Return
_07BA:
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _07D0
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    Return
    .balign 4, 0
_07D0:
    SetVisible
    EndMovement
_07D8:
    CompareVar VAR_0x8004, 1
    CallIf 1, _0821
    CompareVar VAR_0x8004, 3
    CallIf 1, _0826
    CompareVar VAR_0x8004, 2
    CallIf 1, _082B
    CompareVar VAR_0x8004, 4
    CallIf 1, _0830
    CompareVar VAR_0x8004, 5
    CallIf 1, _0835
    GoTo _089C
    End
_0821:
    Message msg_0538_T11R0702_00020
    Return
_0826:
    Message msg_0538_T11R0702_00023
    Return
_082B:
    Message msg_0538_T11R0702_00026
    Return
_0830:
    Message msg_0538_T11R0702_00029
    Return
_0835:
    Message msg_0538_T11R0702_00032
    Return
scr_seq_T11R0702_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: CountTranformedRotomsInParty VAR_SPECIAL_x8003, VAR_SPECIAL_RESULT
    CompareVar VAR_0x8003, 0
    GoToIf 1, _088D
    Message msg_0538_T11R0702_00013
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 14, 0
    AddMenuEntryImm 19, 1
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0231
    GoTo _089C
    End
_088D:
    Message msg_0538_T11R0702_00018
    WaitButton
    CloseMessage
    GoTo _08A4
    End
_089C:
    CloseMessage
    ReleaseAll
    End
_08A4:
    ReleaseAll
    End
scr_seq_T11R0702_000:
    NPCMessage msg_0538_T11R0702_00035
    End
    .balign 4, 0
