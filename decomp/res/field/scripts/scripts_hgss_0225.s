#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0373.h"

#define obj_R29_var_2 6
#define obj_R29_tsure_poke_static_marill 7

    ScriptEntry scr_seq_R29_000
    ScriptEntry scr_seq_R29_001
    ScriptEntry scr_seq_R29_002
    ScriptEntry scr_seq_R29_003
    ScriptEntry scr_seq_R29_004
    ScriptEntry scr_seq_R29_005
    ScriptEntry scr_seq_R29_006
    ScriptEntry scr_seq_R29_007
    ScriptEntry scr_seq_R29_008
    ScriptEntryEnd
scr_seq_R29_000:
    @ HGSS: GetFriendSprite VAR_OBJ_1
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0043
    SetFlag FLAG_HGSS_UNK_207
    End
_0043:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _005E
    ClearFlag FLAG_HGSS_UNK_207
    GoTo _0062
_005E:
    SetFlag FLAG_HGSS_UNK_207
_0062:
    End
scr_seq_R29_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    @ HGSS: MonHasRibbon VAR_SPECIAL_RESULT, VAR_SPECIAL_x8002, RIBBON_SHOCK
    CompareVar VAR_RESULT, 1
    GoToIf 1, _018A
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _019E
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _0138
    GoToIfSet FLAG_HGSS_GOT_TWISTEDSPOON_FROM_TUSCANY, _011A
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _00CB
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 7
    GoTo _0112
_00CB:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 4
    SetVar VAR_0x8004, ITEM_TWISTEDSPOON
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _012E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TWISTEDSPOON_FROM_TUSCANY
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 5
_0112:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_011A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 6
    WaitButton
    CloseMessage
    ReleaseAll
    End
_012E:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0138:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _015B
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 7
    GoTo _0112
_015B:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 32
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 34
    @ HGSS: GiveRibbon VAR_SPECIAL_x8002, RIBBON_SHOCK
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON
    WaitButton
    CloseMessage
    ReleaseAll
    End
_018A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 33
    WaitButton
    CloseMessage
    ReleaseAll
    End
_019E:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 35
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R29_001:
    LockAll
    PlayCry SPECIES_MARILL, 0
    WaitCry
    ApplyMovement obj_R29_tsure_poke_static_marill, _05C4
    WaitMovement
    ApplyMovement obj_R29_var_2, _05D8
    WaitMovement
    Common_SetCounterpartBGM
    MessageGendered msg_0373_R29_00017, msg_0373_R29_00018
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    ReleaseObject obj_R29_tsure_poke_static_marill
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0209
    ApplyMovement obj_R29_var_2, _0660
    ApplyMovement obj_R29_tsure_poke_static_marill, _06D4
    GoTo _02D5
_0209:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _022C
    ApplyMovement obj_R29_var_2, _067C
    ApplyMovement obj_R29_tsure_poke_static_marill, _06F4
    GoTo _02D5
_022C:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _024F
    ApplyMovement obj_R29_var_2, _068C
    ApplyMovement obj_R29_tsure_poke_static_marill, _0708
    GoTo _02D5
_024F:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0272
    ApplyMovement obj_R29_var_2, _069C
    ApplyMovement obj_R29_tsure_poke_static_marill, _071C
    GoTo _02D5
_0272:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0295
    ApplyMovement obj_R29_var_2, _06AC
    ApplyMovement obj_R29_tsure_poke_static_marill, _0730
    GoTo _02D5
_0295:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _02B8
    ApplyMovement obj_R29_var_2, _06B4
    ApplyMovement obj_R29_tsure_poke_static_marill, _073C
    GoTo _02D5
_02B8:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _02D5
    ApplyMovement obj_R29_var_2, _06C4
    ApplyMovement obj_R29_tsure_poke_static_marill, _0750
_02D5:
    WaitMovement
    LockObject obj_R29_tsure_poke_static_marill
    BufferPlayerName 0
    MessageGendered msg_0373_R29_00000, msg_0373_R29_00001
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    GetPlayerGender VAR_MAP_LOCAL_0x02
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _033E
    ApplyMovement obj_R29_var_2, _0764
    ApplyMovement obj_R29_tsure_poke_static_marill, _07B4
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0330
    ApplyMovement LOCALID_PLAYER, _0820
    GoTo _0338
_0330:
    ApplyMovement LOCALID_PLAYER, _08A4
_0338:
    GoTo _04DC
_033E:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0384
    ApplyMovement obj_R29_var_2, _0770
    ApplyMovement obj_R29_tsure_poke_static_marill, _07C4
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0376
    ApplyMovement LOCALID_PLAYER, _0834
    GoTo _037E
_0376:
    ApplyMovement LOCALID_PLAYER, _08B8
_037E:
    GoTo _04DC
_0384:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _03CA
    ApplyMovement obj_R29_var_2, _077C
    ApplyMovement obj_R29_tsure_poke_static_marill, _07D4
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _03BC
    ApplyMovement LOCALID_PLAYER, _0848
    GoTo _03C4
_03BC:
    ApplyMovement LOCALID_PLAYER, _08CC
_03C4:
    GoTo _04DC
_03CA:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0410
    ApplyMovement obj_R29_var_2, _0788
    ApplyMovement obj_R29_tsure_poke_static_marill, _07E4
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0402
    ApplyMovement LOCALID_PLAYER, _085C
    GoTo _040A
_0402:
    ApplyMovement LOCALID_PLAYER, _08E0
_040A:
    GoTo _04DC
_0410:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0456
    ApplyMovement obj_R29_var_2, _0794
    ApplyMovement obj_R29_tsure_poke_static_marill, _07F4
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0448
    ApplyMovement LOCALID_PLAYER, _0870
    GoTo _0450
_0448:
    ApplyMovement LOCALID_PLAYER, _08F4
_0450:
    GoTo _04DC
_0456:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _049C
    ApplyMovement obj_R29_var_2, _07A0
    ApplyMovement obj_R29_tsure_poke_static_marill, _0804
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _048E
    ApplyMovement LOCALID_PLAYER, _0884
    GoTo _0496
_048E:
    ApplyMovement LOCALID_PLAYER, _0908
_0496:
    GoTo _04DC
_049C:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _04DC
    ApplyMovement obj_R29_var_2, _07AC
    ApplyMovement obj_R29_tsure_poke_static_marill, _0814
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _04D4
    ApplyMovement LOCALID_PLAYER, _0898
    GoTo _04DC
_04D4:
    ApplyMovement LOCALID_PLAYER, _091C
_04DC:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x02, 0
    CallIf 1, _0559
    WaitTime 10, VAR_RESULT
    @ HGSS: CatchingTutorial
    ApplyMovement obj_R29_var_2, _064C
    ApplyMovement obj_R29_tsure_poke_static_marill, _0654
    WaitMovement
    MessageGendered msg_0373_R29_00003, msg_0373_R29_00004
    SetVar VAR_0x8004, ITEM_POKE_BALL
    SetVar VAR_0x8005, 5
    Common_GiveItemQuantity
    MessageGendered msg_0373_R29_00007, msg_0373_R29_00008
    CloseMessage
    ApplyMovement obj_R29_var_2, _0928
    ApplyMovement obj_R29_tsure_poke_static_marill, _093C
    WaitMovement
    RemoveObject obj_R29_var_2
    RemoveObject obj_R29_tsure_poke_static_marill
    SetFlag FLAG_HGSS_HIDE_ROUTE_29_FRIEND
    SetFlag FLAG_HGSS_HIDE_ROUTE_29_MARILL
    SetVarFromValue VAR_HGSS_UNK_408B, 0
    SetFlag FLAG_HGSS_WATCHED_CATCHING_TUTORIAL
    ReleaseAll
    End
_0559:
    ApplyMovement obj_R29_var_2, _05BC
    WaitMovement
    ApplyMovement obj_R29_var_2, _05E4
    ApplyMovement obj_R29_tsure_poke_static_marill, _0600
    WaitMovement
    ApplyMovement obj_R29_var_2, _061C
    ApplyMovement obj_R29_tsure_poke_static_marill, _0624
    WaitMovement
    Message msg_0373_R29_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R29_var_2, _062C
    ApplyMovement obj_R29_tsure_poke_static_marill, _0634
    ApplyMovement LOCALID_PLAYER, _0640
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
    .balign 4, 0
_05BC:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_05C4:
    WalkFastSouth
    WalkFastEast 2
    WalkFastNorth
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_05D8:
    WalkOnSpotNormalEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_05E4:
    JumpOnSpotFastWest 3
    Delay16
    JumpOnSpotFastWest 3
    Delay8 3
    JumpOnSpotFastWest 3
    Delay8 3
    EndMovement
    .balign 4, 0
_0600:
    Delay8 3
    JumpFarWest
    Delay8 3
    JumpOnSpotFastWest 3
    Delay8 3
    JumpOnSpotFastWest 3
    EndMovement
    .balign 4, 0
_061C:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0624:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_062C:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0634:
    WalkNormalEast
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0640:
    Delay8
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_064C:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0654:
    WalkNormalWest
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0660:
    WalkFastNorth 4
    WalkFastEast 2
    WalkFastSouth 2
    WalkFastWest 2
    WalkFastNorth 2
    WalkFastEast 4
    EndMovement
    .balign 4, 0
_067C:
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_068C:
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_069C:
    WalkNormalEast 2
    WalkNormalNorth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_06AC:
    WalkNormalEast 4
    EndMovement
    .balign 4, 0
_06B4:
    WalkNormalEast 2
    WalkNormalSouth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_06C4:
    WalkNormalEast 2
    WalkNormalSouth 2
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_06D4:
    WalkFastWest
    WalkFastNorth 4
    WalkFastEast 2
    WalkFastSouth 2
    WalkFastWest 2
    WalkFastNorth 2
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_06F4:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0708:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_071C:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalNorth
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0730:
    WalkNormalWest
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_073C:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalSouth
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0750:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalSouth 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0764:
    WalkNormalSouth 6
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0770:
    WalkNormalSouth 5
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_077C:
    WalkNormalSouth 4
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0788:
    WalkNormalSouth 3
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0794:
    WalkNormalSouth 2
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_07A0:
    WalkNormalSouth
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_07AC:
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_07B4:
    WalkNormalEast
    WalkNormalSouth 6
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_07C4:
    WalkNormalEast
    WalkNormalSouth 5
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_07D4:
    WalkNormalEast
    WalkNormalSouth 4
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_07E4:
    WalkNormalEast
    WalkNormalSouth 3
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_07F4:
    WalkNormalEast
    WalkNormalSouth 2
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0804:
    WalkNormalEast
    WalkNormalSouth
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0814:
    WalkNormalEast
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0820:
    Delay8
    WalkNormalWest
    WalkNormalSouth 6
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0834:
    Delay8
    WalkNormalWest
    WalkNormalSouth 5
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0848:
    Delay8
    WalkNormalWest
    WalkNormalSouth 4
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_085C:
    Delay8
    WalkNormalWest
    WalkNormalSouth 3
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0870:
    Delay8
    WalkNormalWest
    WalkNormalSouth 2
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0884:
    Delay8
    WalkNormalWest
    WalkNormalSouth
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0898:
    Delay8
    WalkNormalWest 6
    EndMovement
    .balign 4, 0
_08A4:
    Delay8
    WalkNormalWest
    WalkNormalSouth 6
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_08B8:
    Delay8
    WalkNormalWest
    WalkNormalSouth 5
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_08CC:
    Delay8
    WalkNormalWest
    WalkNormalSouth 4
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_08E0:
    Delay8
    WalkNormalWest
    WalkNormalSouth 3
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_08F4:
    Delay8
    WalkNormalWest
    WalkNormalSouth 2
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_0908:
    Delay8
    WalkNormalWest
    WalkNormalSouth
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_091C:
    Delay8
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0928:
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkNormalSouth 4
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_093C:
    WalkNormalEast
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkNormalSouth 4
    WalkNormalWest 2
    EndMovement
scr_seq_R29_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_379 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0976
    Message msg_0373_R29_00012
    GoTo _09A5
_0976:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _098C
    Message msg_0373_R29_00013
    GoTo _09A5
_098C:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _09A2
    Message msg_0373_R29_00013
    GoTo _09A5
_09A2:
    Message msg_0373_R29_00014
_09A5:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R29_004:
    DrawSignpostInstantMessage msg_0373_R29_00016, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R29_005:
    DrawSignpostInstantMessage msg_0373_R29_00015, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R29_006:
    NPCMessage msg_0373_R29_00009
    End
scr_seq_R29_007:
    NPCMessage msg_0373_R29_00011
    End
scr_seq_R29_008:
    NPCMessage msg_0373_R29_00010
    End
    .balign 4, 0
