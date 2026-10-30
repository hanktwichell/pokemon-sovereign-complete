#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "generated/ribbons.h"
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
    ScriptEntry scr_seq_R29_009
    ScriptEntryEnd
scr_seq_R29_000:
    CompleteGetFriendSprite VAR_OBJ_GFX_ID_1
    CompleteCheckBadge BADGE_ID_HGSS_ZEPHYR, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _01DA
    SetFlag FLAG_HGSS_UNK_207
    End
scr_seq_R29_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    GetPartyMonRibbon VAR_RESULT, VAR_0x8002, RIBBON_SHOCK
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01F5
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _0209
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _021D
    GoToIfSet FLAG_HGSS_GOT_TWISTEDSPOON_FROM_TUSCANY, _0240
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0254
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 7
    GoTo _02A3
scr_seq_R29_001:
    LockAll
    PlayCry SPECIES_MARILL, 0
    WaitCry
    ApplyMovement obj_R29_tsure_poke_static_marill, _07DE
    WaitMovement
    ApplyMovement obj_R29_var_2, _07F0
    WaitMovement
    Common_SetCounterpartBGM
    MessageGendered msg_0373_R29_00017, msg_0373_R29_00018
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    ReleaseObject obj_R29_tsure_poke_static_marill
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _02AB
    ApplyMovement obj_R29_var_2, _07FA
    ApplyMovement obj_R29_tsure_poke_static_marill, _0814
    GoTo _02CE
scr_seq_R29_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetTimeOfDay VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0329
    Message msg_0373_R29_00012
    GoTo _033F
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
scr_seq_R29_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_FURRET, 0
    WaitCry
    CompleteStartWildBattle SPECIES_FURRET, 15, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0347
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 11
    SetFlag FLAG_HGSS_SG_3FFB
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_01DA:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _034D
    ClearFlag FLAG_HGSS_UNK_207
    GoTo _0353
_01F5:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 33
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0209:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 35
    WaitButton
    CloseMessage
    ReleaseAll
    End
_021D:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0355
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 7
    GoTo _02A3
_0240:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 6
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0254:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 4
    SetVar VAR_0x8004, ITEM_TWISTEDSPOON
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _037E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TWISTEDSPOON_FROM_TUSCANY
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02A3:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02AB:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0388
    ApplyMovement obj_R29_var_2, _0832
    ApplyMovement obj_R29_tsure_poke_static_marill, _0840
    GoTo _02CE
_02CE:
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
    GoToIf 5, _03AB
    ApplyMovement obj_R29_var_2, _0852
    ApplyMovement obj_R29_tsure_poke_static_marill, _085C
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _03E3
    ApplyMovement LOCALID_PLAYER, _086A
    GoTo _03F1
_0329:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _03F7
    Message msg_0373_R29_00013
    GoTo _033F
_033F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0347:
    BlackOutFromBattle
    ReleaseAll
    End
_034D:
    SetFlag FLAG_HGSS_UNK_207
    End
_0353:
    End
_0355:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 32
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 34
    SetPartyMonRibbon VAR_0x8002, RIBBON_SHOCK
    PlayFanfare 20
    @ HGSS data: .byte 217, 7, 53, 0, 97, 0, 2, 0
_037E:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0388:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _040D
    ApplyMovement obj_R29_var_2, _087C
    ApplyMovement obj_R29_tsure_poke_static_marill, _088A
    GoTo _02CE
_03AB:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0430
    ApplyMovement obj_R29_var_2, _089C
    ApplyMovement obj_R29_tsure_poke_static_marill, _08A6
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0468
    ApplyMovement LOCALID_PLAYER, _08B4
    GoTo _0476
_03E3:
    ApplyMovement LOCALID_PLAYER, _08C6
    GoTo _047C
_03F1:
    GoTo _047C
_03F7:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _04FB
    Message msg_0373_R29_00013
    GoTo _033F
_040D:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0506
    ApplyMovement obj_R29_var_2, _08D8
    ApplyMovement obj_R29_tsure_poke_static_marill, _08E6
    GoTo _02CE
_0430:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _0529
    ApplyMovement obj_R29_var_2, _08F8
    ApplyMovement obj_R29_tsure_poke_static_marill, _0902
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0561
    ApplyMovement LOCALID_PLAYER, _0910
    GoTo _056F
_0468:
    ApplyMovement LOCALID_PLAYER, _0922
    GoTo _047C
_0476:
    GoTo _047C
_047C:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x02, 0
    CallIf 1, _0575
    WaitTime 10, VAR_RESULT
    ApplyMovement obj_R29_var_2, _0934
    ApplyMovement obj_R29_tsure_poke_static_marill, _093A
    WaitMovement
    MessageGendered msg_0373_R29_00003, msg_0373_R29_00004
    SetVar VAR_0x8004, ITEM_POKE_BALL
    SetVar VAR_0x8005, 15
    Common_GiveItemQuantity
    MessageGendered msg_0373_R29_00007, msg_0373_R29_00008
    CloseMessage
    ApplyMovement obj_R29_var_2, _0944
    ApplyMovement obj_R29_tsure_poke_static_marill, _0956
    WaitMovement
    RemoveObject obj_R29_var_2
    RemoveObject obj_R29_tsure_poke_static_marill
    SetFlag FLAG_HGSS_HIDE_ROUTE_29_FRIEND
    SetFlag FLAG_HGSS_HIDE_ROUTE_29_MARILL
    SetVarFromValue VAR_HGSS_UNK_408B, 0
    SetFlag FLAG_HGSS_WATCHED_CATCHING_TUTORIAL
    Common_FadeToDefaultMusic
    ReleaseAll
    End
_04FB:
    Message msg_0373_R29_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0506:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _05D8
    ApplyMovement obj_R29_var_2, _096C
    ApplyMovement obj_R29_tsure_poke_static_marill, _0972
    GoTo _02CE
_0529:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _05FB
    ApplyMovement obj_R29_var_2, _097C
    ApplyMovement obj_R29_tsure_poke_static_marill, _0986
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0633
    ApplyMovement LOCALID_PLAYER, _0994
    GoTo _0641
_0561:
    ApplyMovement LOCALID_PLAYER, _09A6
    GoTo _047C
_056F:
    GoTo _047C
_0575:
    ApplyMovement obj_R29_var_2, _09B8
    WaitMovement
    ApplyMovement obj_R29_var_2, _09BE
    ApplyMovement obj_R29_tsure_poke_static_marill, _09D8
    WaitMovement
    ApplyMovement obj_R29_var_2, _09F2
    ApplyMovement obj_R29_tsure_poke_static_marill, _09F8
    WaitMovement
    Message msg_0373_R29_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R29_var_2, _09FE
    ApplyMovement obj_R29_tsure_poke_static_marill, _0A04
    ApplyMovement LOCALID_PLAYER, _0A0E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
_05D8:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0647
    ApplyMovement obj_R29_var_2, _0A18
    ApplyMovement obj_R29_tsure_poke_static_marill, _0A26
    GoTo _02CE
_05FB:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _06BF
    ApplyMovement obj_R29_var_2, _0A38
    ApplyMovement obj_R29_tsure_poke_static_marill, _0A42
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _06F7
    ApplyMovement LOCALID_PLAYER, _0A50
    GoTo _0705
_0633:
    ApplyMovement LOCALID_PLAYER, _0A62
    GoTo _047C
_0641:
    GoTo _047C
_0647:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _02CE
    ApplyMovement obj_R29_var_2, _0A74
    ApplyMovement obj_R29_tsure_poke_static_marill, _0A82
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
    GoToIf 5, _03AB
    ApplyMovement obj_R29_var_2, _0852
    ApplyMovement obj_R29_tsure_poke_static_marill, _085C
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _03E3
    ApplyMovement LOCALID_PLAYER, _086A
    GoTo _03F1
_06BF:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _070B
    ApplyMovement obj_R29_var_2, _0A94
    ApplyMovement obj_R29_tsure_poke_static_marill, _0A9E
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0743
    ApplyMovement LOCALID_PLAYER, _0AAC
    GoTo _0751
_06F7:
    ApplyMovement LOCALID_PLAYER, _0ABE
    GoTo _047C
_0705:
    GoTo _047C
_070B:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _047C
    ApplyMovement obj_R29_var_2, _0AD0
    ApplyMovement obj_R29_tsure_poke_static_marill, _0AD6
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0757
    ApplyMovement LOCALID_PLAYER, _0AE0
    GoTo _047C
_0743:
    ApplyMovement LOCALID_PLAYER, _0AEA
    GoTo _047C
_0751:
    GoTo _047C
_0757:
    ApplyMovement LOCALID_PLAYER, _0AFC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x02, 0
    CallIf 1, _0575
    WaitTime 10, VAR_RESULT
    ApplyMovement obj_R29_var_2, _0934
    ApplyMovement obj_R29_tsure_poke_static_marill, _093A
    WaitMovement
    MessageGendered msg_0373_R29_00003, msg_0373_R29_00004
    SetVar VAR_0x8004, ITEM_POKE_BALL
    SetVar VAR_0x8005, 15
    Common_GiveItemQuantity
    MessageGendered msg_0373_R29_00007, msg_0373_R29_00008
    CloseMessage
    ApplyMovement obj_R29_var_2, _0944
    ApplyMovement obj_R29_tsure_poke_static_marill, _0956
    WaitMovement
    RemoveObject obj_R29_var_2
    RemoveObject obj_R29_tsure_poke_static_marill
    SetFlag FLAG_HGSS_HIDE_ROUTE_29_FRIEND
    SetFlag FLAG_HGSS_HIDE_ROUTE_29_MARILL
    SetVarFromValue VAR_HGSS_UNK_408B, 0
    SetFlag FLAG_HGSS_WATCHED_CATCHING_TUTORIAL
    Common_FadeToDefaultMusic
    ReleaseAll
    End
    .balign 4, 0
_07DE:
    WalkFastSouth
    WalkFastEast 2
    WalkFastNorth
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_07F0:
    WalkOnSpotNormalEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_07FA:
    WalkFastNorth 4
    WalkFastEast 2
    WalkFastSouth 2
    WalkFastWest 2
    WalkFastNorth 2
    WalkFastEast 4
    EndMovement
    .balign 4, 0
_0814:
    WalkFastWest
    WalkFastNorth 4
    WalkFastEast 2
    WalkFastSouth 2
    WalkFastWest 2
    WalkFastNorth 2
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_0832:
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0840:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0852:
    WalkNormalSouth 6
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_085C:
    WalkNormalEast
    WalkNormalSouth 6
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_086A:
    Delay8
    WalkNormalWest
    WalkNormalSouth 6
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_087C:
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_088A:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_089C:
    WalkNormalSouth 5
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_08A6:
    WalkNormalEast
    WalkNormalSouth 5
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_08B4:
    Delay8
    WalkNormalWest
    WalkNormalSouth 5
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_08C6:
    Delay8
    WalkNormalWest
    WalkNormalSouth 6
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_08D8:
    WalkNormalEast 2
    WalkNormalNorth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_08E6:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalNorth
    WalkNormalEast
    EndMovement
    .balign 4, 0
_08F8:
    WalkNormalSouth 4
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0902:
    WalkNormalEast
    WalkNormalSouth 4
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0910:
    Delay8
    WalkNormalWest
    WalkNormalSouth 4
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0922:
    Delay8
    WalkNormalWest
    WalkNormalSouth 5
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_0934:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_093A:
    WalkNormalWest
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0944:
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkNormalSouth 4
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0956:
    WalkNormalEast
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkNormalSouth 4
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_096C:
    WalkNormalEast 4
    EndMovement
    .balign 4, 0
_0972:
    WalkNormalWest
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_097C:
    WalkNormalSouth 3
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0986:
    WalkNormalEast
    WalkNormalSouth 3
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0994:
    Delay8
    WalkNormalWest
    WalkNormalSouth 3
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_09A6:
    Delay8
    WalkNormalWest
    WalkNormalSouth 4
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_09B8:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_09BE:
    JumpOnSpotFastWest 3
    Delay16
    JumpOnSpotFastWest 3
    Delay8 3
    JumpOnSpotFastWest 3
    Delay8 3
    EndMovement
    .balign 4, 0
_09D8:
    Delay8 3
    JumpFarWest
    Delay8 3
    JumpOnSpotFastWest 3
    Delay8 3
    JumpOnSpotFastWest 3
    EndMovement
    .balign 4, 0
_09F2:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_09F8:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_09FE:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0A04:
    WalkNormalEast
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0A0E:
    Delay8
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0A18:
    WalkNormalEast 2
    WalkNormalSouth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0A26:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalSouth
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0A38:
    WalkNormalSouth 2
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0A42:
    WalkNormalEast
    WalkNormalSouth 2
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0A50:
    Delay8
    WalkNormalWest
    WalkNormalSouth 2
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0A62:
    Delay8
    WalkNormalWest
    WalkNormalSouth 3
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_0A74:
    WalkNormalEast 2
    WalkNormalSouth 2
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0A82:
    WalkNormalWest
    WalkNormalEast 2
    WalkNormalSouth 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0A94:
    WalkNormalSouth
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0A9E:
    WalkNormalEast
    WalkNormalSouth
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0AAC:
    Delay8
    WalkNormalWest
    WalkNormalSouth
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_0ABE:
    Delay8
    WalkNormalWest
    WalkNormalSouth 2
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_0AD0:
    WalkNormalWest 9
    EndMovement
    .balign 4, 0
_0AD6:
    WalkNormalEast
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0AE0:
    Delay8
    WalkNormalWest 6
    EndMovement
    .balign 4, 0
_0AEA:
    Delay8
    WalkNormalWest
    WalkNormalSouth
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_0AFC:
    Delay8
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
