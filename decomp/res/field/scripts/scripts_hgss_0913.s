#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0606.h"

#define obj_T26GYM0101_gsgirl1 1
#define obj_T26GYM0101_gsgentleman 2

    ScriptEntry scr_seq_T26GYM0101_000
    ScriptEntry scr_seq_T26GYM0101_001
    ScriptEntry scr_seq_T26GYM0101_002
    ScriptEntry scr_seq_T26GYM0101_003
    ScriptEntry scr_seq_T26GYM0101_004
    ScriptEntry scr_seq_T26GYM0101_005
    ScriptEntry scr_seq_T26GYM0101_006
    ScriptEntry scr_seq_T26GYM0101_007
    ScriptEntry scr_seq_T26GYM0101_008
    ScriptEntryEnd
scr_seq_T26GYM0101_007:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0232
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _0238
    ClearFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _023A
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _0255
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _025B
scr_seq_T26GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _025D
    Message msg_0606_T26GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_JASMINE_JASMINE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0286
    SetVarFromValue VAR_HGSS_SG_61A6, 2
    Message msg_0606_T26GYM0101_00001
    BufferPlayerName 0
    Message msg_0606_T26GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    AddVar VAR_HGSS_MIDGAME_BADGES, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    CompareVar VAR_HGSS_MIDGAME_BADGES, 3
    GoToIf 5, _028C
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 1
    Message msg_0606_T26GYM0101_00003
    SetVar VAR_0x8004, ITEM_TM23
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _02C3
    Common_GiveItemQuantity
    Message msg_0606_T26GYM0101_00005
    Message msg_0606_T26GYM0101_00026
    BufferPlayerName 0
    Message msg_0606_T26GYM0101_00027
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_JASMINE
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_TM23_FROM_JASMINE
    End
scr_seq_T26GYM0101_001:
    LockAll
    ApplyMovement obj_T26GYM0101_gsgentleman, _071E
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _02CD
    ApplyMovement obj_T26GYM0101_gsgentleman, _0724
    GoTo _02E8
scr_seq_T26GYM0101_002:
    LockAll
    ApplyMovement obj_T26GYM0101_gsgirl1, _071E
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0310
    ApplyMovement obj_T26GYM0101_gsgirl1, _072A
    GoTo _032B
scr_seq_T26GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0353
    Message msg_0606_T26GYM0101_00020
    GoTo _0371
scr_seq_T26GYM0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 5, _038C
    Message msg_0606_T26GYM0101_00022
    GoTo _03AA
scr_seq_T26GYM0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03C5
    CompareVar VAR_HGSS_UNK_410E, 0
    GoToIf 5, _03D0
    Message msg_0606_T26GYM0101_00016
    GoTo _03DB
scr_seq_T26GYM0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03E3
    Message msg_0606_T26GYM0101_00023
    GoTo _03EE
scr_seq_T26GYM0101_008:
    BufferPlayerName 0
    End
_0232:
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    End
_0238:
    End
_023A:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _03F6
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _03FC
_0255:
    GoTo _03FE
_025B:
    End
_025D:
    GoToIfUnset FLAG_HGSS_GOT_TM23_FROM_JASMINE, _042A
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _045E
    Message msg_0606_T26GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0286:
    BlackOutFromBattle
    ReleaseAll
    End
_028C:
    Message msg_0606_T26GYM0101_00003
    SetVar VAR_0x8004, ITEM_TM23
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _02C3
    Common_GiveItemQuantity
    Message msg_0606_T26GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_TM23_FROM_JASMINE
    End
_02C3:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_02CD:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0487
    ApplyMovement obj_T26GYM0101_gsgentleman, _0730
    GoTo _02E8
_02E8:
    ApplyMovement LOCALID_PLAYER, _0736
    WaitMovement
    Message msg_0606_T26GYM0101_00019
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 1
    GoToIf 5, _04B7
    SetVarFromValue VAR_HGSS_UNK_410E, 2
    End
_0310:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _04B9
    ApplyMovement obj_T26GYM0101_gsgirl1, _073C
    GoTo _032B
_032B:
    ApplyMovement LOCALID_PLAYER, _0742
    WaitMovement
    Message msg_0606_T26GYM0101_00021
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 2
    GoToIf 5, _04E9
    SetVarFromValue VAR_HGSS_UNK_410E, 3
    End
_0353:
    Message msg_0606_T26GYM0101_00019
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 1
    GoToIf 5, _04EB
    SetVarFromValue VAR_HGSS_UNK_410E, 2
    End
_0371:
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 1
    GoToIf 5, _04EB
    SetVarFromValue VAR_HGSS_UNK_410E, 2
    End
_038C:
    Message msg_0606_T26GYM0101_00021
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 2
    GoToIf 5, _04ED
    SetVarFromValue VAR_HGSS_UNK_410E, 3
    End
_03AA:
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 2
    GoToIf 5, _04ED
    SetVarFromValue VAR_HGSS_UNK_410E, 3
    End
_03C5:
    Message msg_0606_T26GYM0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03D0:
    Message msg_0606_T26GYM0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03DB:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E3:
    Message msg_0606_T26GYM0101_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03EE:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03F6:
    GoTo _03FE
_03FC:
    End
_03FE:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_ERIKA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0238
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _04EF
    GoTo _0238
_042A:
    SetVar VAR_0x8004, ITEM_TM23
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _02C3
    Common_GiveItemQuantity
    Message msg_0606_T26GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_TM23_FROM_JASMINE
    End
_045E:
    GoToIfSet FLAG_HGSS_TRADE_JASMINE_STEELIX, _0506
    CompareVar VAR_MAP_LOCAL_0x00, 77
    GoToIf 1, _051C
    SetVarFromValue VAR_MAP_LOCAL_0x00, 77
    Message msg_0606_T26GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0487:
    ApplyMovement obj_T26GYM0101_gsgentleman, _0748
    ApplyMovement LOCALID_PLAYER, _0736
    WaitMovement
    Message msg_0606_T26GYM0101_00019
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 1
    GoToIf 5, _04B7
    SetVarFromValue VAR_HGSS_UNK_410E, 2
    End
_04B7:
    End
_04B9:
    ApplyMovement obj_T26GYM0101_gsgirl1, _074E
    ApplyMovement LOCALID_PLAYER, _0742
    WaitMovement
    Message msg_0606_T26GYM0101_00021
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_HGSS_UNK_410E, 2
    GoToIf 5, _04E9
    SetVarFromValue VAR_HGSS_UNK_410E, 3
    End
_04E9:
    End
_04EB:
    End
_04ED:
    End
_04EF:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _060B
    GoTo _061E
_0506:
    CompareVar VAR_MAP_LOCAL_0x00, 55
    GoToIf 5, _0639
    Message msg_0606_T26GYM0101_00011
    GoTo _0644
_051C:
    Message msg_0606_T26GYM0101_00008
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _064C
    Message msg_0606_T26GYM0101_00009
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _064C
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_MAP_LOCAL_0x03
    GetPartyMonForm2 VAR_0x8004, VAR_MAP_LOCAL_0x04
    CompareVar VAR_MAP_LOCAL_0x03, 0
    GoToIf 1, _0657
    CompareVar VAR_MAP_LOCAL_0x04, 0
    GoToIf 1, _0665
    CompareVar VAR_MAP_LOCAL_0x03, 487
    GoToIf 1, _06D7
    CompareVar VAR_MAP_LOCAL_0x03, 492
    GoToIf 1, _06D7
    CompareVar VAR_MAP_LOCAL_0x03, 172
    GoToIf 1, _06D7
    CompareVar VAR_MAP_LOCAL_0x03, 479
    GoToIf 1, _06D7
    BufferPartyMonNickname 1, VAR_0x8004
    Message msg_0606_T26GYM0101_00013
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _064C
    CloseMessage
    InitNPCTrade NPC_TRADE_HGSS_RUSTY_STEELIX
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_METAL_BURST
    SetFlag FLAG_HGSS_TRADE_JASMINE_STEELIX
    SetVarFromValue VAR_MAP_LOCAL_0x00, 55
    Message msg_0606_T26GYM0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_060B:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _06E2
    GoTo _061E
_061E:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _06E8
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _06FF
_0639:
    Message msg_0606_T26GYM0101_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0644:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_064C:
    Message msg_0606_T26GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0657:
    BufferPlayerName 0
    Message msg_0606_T26GYM0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0665:
    BufferPartyMonNickname 1, VAR_0x8004
    Message msg_0606_T26GYM0101_00013
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _064C
    CloseMessage
    InitNPCTrade NPC_TRADE_HGSS_RUSTY_STEELIX
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    SetFlag FLAG_HGSS_TRADE_JASMINE_STEELIX
    SetVarFromValue VAR_MAP_LOCAL_0x00, 55
    Message msg_0606_T26GYM0101_00011
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0606_T26GYM0101_00025
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_06D7:
    Message msg_0606_T26GYM0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06E2:
    GoTo _0238
_06E8:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _0701
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _06FF
_06FF:
    End
_0701:
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0718
    SetFlag FLAG_HGSS_HIDE_JASMINE_IN_GYM
    GoTo _06FF
_0718:
    GoTo _0238
    .balign 4, 0
_071E:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0724:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_072A:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0730:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0736:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_073C:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0742:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0748:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_074E:
    WalkNormalWest
    EndMovement
    .balign 4, 0
