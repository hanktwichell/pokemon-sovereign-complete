#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0051.h"

#define obj_D02R0104_tsure_poke_static_clefairy 0
#define obj_D02R0104_tsure_poke_static_clefairy_2 1
#define obj_D02R0104_tsure_poke_static_clefairy_3 2
#define obj_D02R0104_tsure_poke_static_clefairy_4 3
#define obj_D02R0104_tsure_poke_static_clefairy_5 4
#define obj_D02R0104_tsure_poke_static_clefairy_6 5
#define obj_D02R0104_monstarball 6

    ScriptEntry scr_seq_D02R0104_000
    ScriptEntry scr_seq_D02R0104_001
    ScriptEntry scr_seq_D02R0104_002
    ScriptEntry scr_seq_D02R0104_003
    ScriptEntry scr_seq_D02R0104_004
    ScriptEntry scr_seq_D02R0104_005
    ScriptEntryEnd
scr_seq_D02R0104_000:
    SetFlag FLAG_HGSS_UNK_298
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _003B
    GoTo _0060
_0035:
    GoTo _005E
_003B:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0054
    GoTo _007D
_004E:
    GoTo _005E
_0054:
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    SetFlag FLAG_HGSS_UNK_26E
_005E:
    End
_0060:
    @ HGSS: ScrCmd_379 VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _009A
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    SetFlag FLAG_HGSS_UNK_26E
    End
_007D:
    @ HGSS: ScrCmd_379 VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 1, _009A
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    SetFlag FLAG_HGSS_UNK_26E
    End
_009A:
    SetVarFromValue VAR_HGSS_UNK_40F6, 0
    ClearFlag FLAG_HGSS_UNK_26E
    End
scr_seq_D02R0104_005:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _00C3
    GoTo _0113
_00BD:
    GoTo _00E2
_00C3:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00DC
    GoTo _012A
_00D6:
    GoTo _00E2
_00DC:
    GoTo _00E2
_00E2:
    CompareVar VAR_HGSS_UNK_40F6, 1
    GoToIf 1, _0141
    SetFlag FLAG_HGSS_UNK_26E
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_2
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_3
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_4
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_5
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_6
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    End
_0113:
    @ HGSS: ScrCmd_379 VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _0141
    GoTo _00E2
_012A:
    @ HGSS: ScrCmd_379 VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 1, _0141
    GoTo _00E2
_0141:
    End
scr_seq_D02R0104_002:
    LockAll
    ClearFlag FLAG_HGSS_UNK_298
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    @ HGSS: ScrCmd_102 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    ApplyMovement 241, _0330
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _0344
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _0350
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _035C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _0368
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _0374
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _037C
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _0384
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _0394
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _03A4
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _03B4
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _03C4
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _03CC
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _03D4
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _03F0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _040C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _0428
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _0444
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _0468
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _048C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _04A8
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _04C4
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _04E0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _04FC
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _0520
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _0544
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _0560
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _057C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _0598
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _05B4
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _05D8
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _05FC
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _0614
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _0630
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _064C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _0668
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _068C
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _06B0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _06D4
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _06F8
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _0720
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _0744
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _0760
    WaitMovement
    AddObject obj_D02R0104_monstarball
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _077C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _0798
    WaitMovement
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_2
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_3
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_4
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_5
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_6
    SetFlag FLAG_HGSS_UNK_26E
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    SetFlag FLAG_HGSS_UNK_AB5
    ApplyMovement 241, _0338
    WaitMovement
    @ HGSS: ScrCmd_103
    ReleaseAll
    End
    .balign 4, 0
_0330:
    WalkSlightlyFastNorth 2
    EndMovement
    .balign 4, 0
_0338:
    Delay16
    WalkSlightlyFastSouth 2
    EndMovement
    .balign 4, 0
_0344:
    WalkOnSpotNormalNorth 5
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0350:
    WalkOnSpotNormalWest 5
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_035C:
    WalkOnSpotNormalSouth 5
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0368:
    WalkOnSpotNormalEast 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0374:
    WalkOnSpotNormalWest 6
    EndMovement
    .balign 4, 0
_037C:
    WalkOnSpotNormalEast 6
    EndMovement
    .balign 4, 0
_0384:
    WalkOnSpotNormalEast 6
    WalkNormalEast
    JumpFarEast
    EndMovement
    .balign 4, 0
_0394:
    WalkOnSpotNormalNorth 6
    WalkNormalNorth
    JumpFarNorth
    EndMovement
    .balign 4, 0
_03A4:
    WalkOnSpotNormalWest 6
    WalkNormalWest
    JumpFarWest
    EndMovement
    .balign 4, 0
_03B4:
    WalkOnSpotNormalSouth 6
    WalkNormalSouth
    JumpFarSouth
    EndMovement
    .balign 4, 0
_03C4:
    WalkOnSpotNormalWest 8
    EndMovement
    .balign 4, 0
_03CC:
    WalkOnSpotNormalEast 8
    EndMovement
    .balign 4, 0
_03D4:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkNormalNorth 4
    JumpFarNorth
    EndMovement
    .balign 4, 0
_03F0:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkNormalWest 4
    JumpFarWest
    EndMovement
    .balign 4, 0
_040C:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkNormalSouth 4
    JumpFarSouth
    EndMovement
    .balign 4, 0
_0428:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkNormalEast 4
    JumpFarEast
    EndMovement
    .balign 4, 0
_0444:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0468:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_048C:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkNormalWest 4
    JumpFarWest
    EndMovement
    .balign 4, 0
_04A8:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkNormalSouth 4
    JumpFarSouth
    EndMovement
    .balign 4, 0
_04C4:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkNormalEast 4
    JumpFarEast
    EndMovement
    .balign 4, 0
_04E0:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkNormalNorth 4
    JumpFarNorth
    EndMovement
    .balign 4, 0
_04FC:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0520:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0544:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkNormalSouth 4
    JumpFarSouth
    EndMovement
    .balign 4, 0
_0560:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkNormalEast 4
    JumpFarEast
    EndMovement
    .balign 4, 0
_057C:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkNormalNorth 4
    JumpFarNorth
    EndMovement
    .balign 4, 0
_0598:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkNormalWest 4
    JumpFarWest
    EndMovement
    .balign 4, 0
_05B4:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05D8:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05FC:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0614:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkNormalNorth 2
    JumpFarNorth
    EndMovement
    .balign 4, 0
_0630:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkNormalWest 2
    JumpFarWest
    EndMovement
    .balign 4, 0
_064C:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkNormalSouth 2
    JumpFarSouth
    EndMovement
    .balign 4, 0
_0668:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_068C:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06B0:
    JumpOnSpotFastNorth 3
    WalkFastEast 6
    WalkFastNorth 3
    WalkFastEast 3
    WalkFastSouth 3
    WalkFastEast
    JumpFarEast
    WalkFastEast 2
    EndMovement
    .balign 4, 0
_06D4:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkFastSouth
    WalkFastEast 3
    WalkFastSouth 2
    WalkFastEast
    JumpFarEast
    WalkFastEast 2
    EndMovement
    .balign 4, 0
_06F8:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkFastEast 4
    WalkFastSouth 3
    WalkFastEast 3
    WalkFastSouth 2
    WalkFastEast
    JumpFarEast
    WalkFastEast 2
    EndMovement
    .balign 4, 0
_0720:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkFastSouth 2
    WalkFastEast 6
    WalkFastNorth 3
    WalkFastEast 2
    WalkFastSouth 3
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_0744:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkFastSouth 2
    WalkFastEast 2
    JumpFarEast
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_0760:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkNormalEast 2
    WalkNormalSouth 3
    WalkNormalEast 5
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_077C:
    WalkOnSpotFastWest 2
    WalkOnSpotFastNorth 4
    JumpOnSpotFastNorth 2
    WalkFastEast 2
    JumpFarEast
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_0798:
    WalkNormalEast
    WalkNormalNorth 3
    WalkNormalEast 3
    WalkNormalSouth 3
    WalkNormalEast
    JumpFarEast
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_07B8:
    SetVisible
    EndMovement
scr_seq_D02R0104_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0051_D02R0104_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D02R0104_003:
    SetVarFromValue VAR_0x8008, 81
    SetVarFromValue VAR_0x8009, 1
    GoTo _07E9
    End
_07E9:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    WaitSE SE_CONFIRM_sseq_3
    SetVarFromVar VAR_0x8004, VAR_0x8008
    SetVarFromVar VAR_0x8005, VAR_0x8009
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0825
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0866
    End
_0825:
    @ HGSS: CallStd std_hidden_item_fanfare
    RemoveObject VAR_LAST_TALKED
    AddItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    Message msg_0051_D02R0104_00002
    WaitFanfare
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 2, VAR_RESULT
    Message msg_0051_D02R0104_00003
    WaitButton
    SetVarFromValue VAR_RESULT, 1
_0860:
    CloseMessage
    ReleaseAll
    End
_0866:
    BufferItemName 0, VAR_0x8004
    Message msg_0051_D02R0104_00004
    WaitButton
    SetVarFromValue VAR_RESULT, 0
    GoTo _0860
    End
scr_seq_D02R0104_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0051_D02R0104_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
