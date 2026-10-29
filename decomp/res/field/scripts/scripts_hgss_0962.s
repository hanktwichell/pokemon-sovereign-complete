#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "generated/ribbons.h"
#include "res/text/bank/hgss_msg_0744.h"

#define obj_W40_gsmiddleman1 5

    ScriptEntry scr_seq_W40_000
    ScriptEntry scr_seq_W40_001
    ScriptEntry scr_seq_W40_002
    ScriptEntry scr_seq_W40_003
    ScriptEntry scr_seq_W40_004
    ScriptEntry scr_seq_W40_005
    ScriptEntry scr_seq_W40_006
    ScriptEntry scr_seq_W40_007
    ScriptEntry scr_seq_W40_008
    ScriptEntry scr_seq_W40_009
    ScriptEntry scr_seq_W40_010
    ScriptEntry scr_seq_W40_011
    ScriptEntry scr_seq_W40_012
    ScriptEntryEnd
scr_seq_W40_000:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0219
    ClearFlag FLAG_HGSS_UNK_206
    GoTo _021F
scr_seq_W40_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    GetPartyMonRibbon VAR_RESULT, VAR_0x8002, RIBBON_ALERT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0221
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _0235
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _0249
    GoToIfSet FLAG_HGSS_GOT_SHARP_BEAK_FROM_MONICA, _026C
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0280
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 3
    GoTo _02CF
scr_seq_W40_008:
    LockAll
    ApplyMovement obj_W40_gsmiddleman1, _057A
    WaitMovement
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 252
    GoToIf 5, _02D7
    ApplyMovement obj_W40_gsmiddleman1, _0584
    GoTo _02F2
scr_seq_W40_007:
    NPCMessage msg_0744_W40_00018
    End
scr_seq_W40_002:
    DrawSignpostInstantMessage msg_0744_W40_00019, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_W40_009:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0744_W40_00020, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_W40_003:
    NPCMessage msg_0744_W40_00000
    End
scr_seq_W40_004:
    NPCMessage msg_0744_W40_00006
    End
scr_seq_W40_005:
    NPCMessage msg_0744_W40_00003
    End
scr_seq_W40_006:
    NPCMessage msg_0744_W40_00009
    End
scr_seq_W40_010:
    LockAll
    RemoveObject 7
    SetFlag FLAG_HGSS_SG_3FD1
    SetVar VAR_0x8004, ITEM_TM13
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
scr_seq_W40_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement 8, _057A
    WaitMovement
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_SG_3FBB, _0360
    SetFlag FLAG_HGSS_SG_3FBB
    Message msg_0744_W40_00021
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0387
    Message msg_0744_W40_00022
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    ReleaseAll
    End
scr_seq_W40_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3FB1, _03D5
    Message msg_0744_W40_00028
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 489
    GoToIf 1, _03E0
    Message msg_0744_W40_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0219:
    SetFlag FLAG_HGSS_UNK_206
    End
_021F:
    End
_0221:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 29
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0235:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 31
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0249:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _040C
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 3
    GoTo _02CF
_026C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0280:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 0
    SetVar VAR_0x8004, ITEM_SHARP_BEAK
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0435
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_SHARP_BEAK_FROM_MONICA
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 1
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02CF:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02D7:
    CompareVar VAR_0x8000, 253
    GoToIf 5, _043F
    ApplyMovement obj_W40_gsmiddleman1, _058E
    GoTo _02F2
_02F2:
    WaitMovement
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _045A
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_W40_gsmiddleman1, _05A0
    ApplyMovement LOCALID_PLAYER, _05A6
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0744_W40_00015
    CloseMessage
    ApplyMovement obj_W40_gsmiddleman1, _057A
    WaitMovement
    Message msg_0744_W40_00016
    CloseMessage
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 252
    GoToIf 5, _04AB
    ApplyMovement obj_W40_gsmiddleman1, _05B4
    GoTo _04C6
_0360:
    Message msg_0744_W40_00027
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0387
    Message msg_0744_W40_00022
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    ReleaseAll
    End
_0387:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _04CC
    Message msg_0744_W40_00023
    GiveEgg SPECIES_MANAPHY, 9
    Message msg_0744_W40_00024
    WaitFanfare
    Message msg_0744_W40_00025
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 8
    Common_FadeToDefaultMusic
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_03D5:
    Message msg_0744_W40_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E0:
    Message msg_0744_W40_00030
    CloseMessage
    ApplyMovement 9, _057A
    WaitMovement
    Message msg_0744_W40_00031
    SetVar VAR_0x8004, ITEM_HEART_SCALE
    SetVar VAR_0x8005, 5
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3FB1
    CloseMessage
    ReleaseAll
    End
_040C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 28
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 30
    SetPartyMonRibbon VAR_0x8002, RIBBON_ALERT
    PlayFanfare 20
    @ HGSS data: .byte 217, 7, 53, 0, 97, 0, 2, 0
_0435:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_043F:
    CompareVar VAR_0x8000, 254
    GoToIf 5, _04DB
    ApplyMovement obj_W40_gsmiddleman1, _05BE
    GoTo _02F2
_045A:
    ApplyMovement obj_W40_gsmiddleman1, _05A0
    ApplyMovement LOCALID_PLAYER, _05A6
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0744_W40_00015
    CloseMessage
    ApplyMovement obj_W40_gsmiddleman1, _057A
    WaitMovement
    Message msg_0744_W40_00016
    CloseMessage
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 252
    GoToIf 5, _04AB
    ApplyMovement obj_W40_gsmiddleman1, _05B4
    GoTo _04C6
_04AB:
    CompareVar VAR_0x8000, 253
    GoToIf 5, _0551
    ApplyMovement obj_W40_gsmiddleman1, _05D0
    GoTo _04C6
_04C6:
    WaitMovement
    ReleaseAll
    End
_04CC:
    Message msg_0744_W40_00026
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    ReleaseAll
    End
_04DB:
    ApplyMovement obj_W40_gsmiddleman1, _05E2
    WaitMovement
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _045A
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_W40_gsmiddleman1, _05A0
    ApplyMovement LOCALID_PLAYER, _05A6
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0744_W40_00015
    CloseMessage
    ApplyMovement obj_W40_gsmiddleman1, _057A
    WaitMovement
    Message msg_0744_W40_00016
    CloseMessage
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 252
    GoToIf 5, _04AB
    ApplyMovement obj_W40_gsmiddleman1, _05B4
    GoTo _04C6
_0551:
    CompareVar VAR_0x8000, 254
    GoToIf 5, _056C
    ApplyMovement obj_W40_gsmiddleman1, _05F4
    GoTo _04C6
_056C:
    ApplyMovement obj_W40_gsmiddleman1, _0606
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_057A:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0584:
    WalkFastNorth 5
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_058E:
    WalkFastNorth 2
    WalkFastEast
    WalkFastNorth 3
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_05A0:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_05A6:
    LockDir
    WalkNormalNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_05B4:
    WalkFastSouth 6
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05BE:
    WalkFastNorth 2
    WalkFastEast 2
    WalkFastNorth 3
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_05D0:
    WalkFastSouth 3
    WalkFastWest
    WalkFastSouth 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05E2:
    WalkFastNorth 2
    WalkFastEast 3
    WalkFastNorth 3
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_05F4:
    WalkFastSouth 3
    WalkFastWest 2
    WalkFastSouth 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0606:
    WalkFastSouth 3
    WalkFastWest 3
    WalkFastSouth 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
