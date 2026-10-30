#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "generated/ribbons.h"
#include "res/text/bank/hgss_msg_0380.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R32_gsmiddleman1 1
#define obj_R32_gsmiddleman1_2 18

    ScriptEntry scr_seq_R32_000
    ScriptEntry scr_seq_R32_001
    ScriptEntry scr_seq_R32_002
    ScriptEntry scr_seq_R32_003
    ScriptEntry scr_seq_R32_004
    ScriptEntry scr_seq_R32_005
    ScriptEntry scr_seq_R32_006
    ScriptEntry scr_seq_R32_007
    ScriptEntry scr_seq_R32_008
    ScriptEntry scr_seq_R32_009
    ScriptEntry scr_seq_R32_010
    ScriptEntryEnd
scr_seq_R32_004:
    GoToIfUnset FLAG_HGSS_UNK_189, _02C7
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_R32_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    GetPartyMonRibbon VAR_RESULT, VAR_0x8002, RIBBON_RELAX
    CompareVar VAR_RESULT, 1
    GoToIf 1, _030F
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _0323
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _0337
    GoToIfSet FLAG_HGSS_GOT_POISON_BARB_FROM_FRIEDA, _035A
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _036E
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 19
    GoTo _03BD
scr_seq_R32_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TM05_FROM_ROUTE_32_MAN, _03C5
    Message msg_0380_R32_00010
    SetVar VAR_0x8004, ITEM_TM05
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _03D0
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM05_FROM_ROUTE_32_MAN
    Message msg_0380_R32_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R32_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_ZEPHYR, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03DA
    GoToIfUnset FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT, _03E3
    GoToIfUnset FLAG_HGSS_UNK_074, _03EF
    Message msg_0380_R32_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R32_002:
    LockAll
    ApplyMovement obj_R32_gsmiddleman1, _0832
    WaitMovement
    Message msg_0380_R32_00000
    CloseMessage
    GoToIfSet FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT, _03FF
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _0438
    ApplyMovement obj_R32_gsmiddleman1, _083C
    ApplyMovement LOCALID_PLAYER, _0846
    GoTo _0470
scr_seq_R32_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0380_R32_00014
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0498
    Message msg_0380_R32_00015
    GoTo _04A3
scr_seq_R32_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04AB
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04BF
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04D3
    ApplyMovement LOCALID_PLAYER, _0854
    ApplyMovement obj_R32_gsmiddleman1_2, _086A
    GoTo _04EE
scr_seq_R32_006:
    DrawSignpostInstantMessage msg_0380_R32_00018, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R32_007:
    DrawSignpostInstantMessage msg_0380_R32_00017, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R32_008:
    DrawSignpostInstantMessage msg_0380_R32_00019, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R32_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SKIPLOOM, 0
    WaitCry
    CompleteStartWildBattle SPECIES_SKIPLOOM, 18, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _054F
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 19
    SetFlag FLAG_HGSS_SG_3FF5
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockAll
    Message msg_0380_R32_00020
    SetVar VAR_0x8004, ITEM_TM86
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_02C7:
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0555
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _055F
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _055F
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _055F
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0569
_030F:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 45
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0323:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 47
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0337:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0584
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 19
    GoTo _03BD
_035A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 18
    WaitButton
    CloseMessage
    ReleaseAll
    End
_036E:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 16
    SetVar VAR_0x8004, ITEM_POISON_BARB
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _05AD
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_POISON_BARB_FROM_FRIEDA
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 17
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03BD:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03C5:
    Message msg_0380_R32_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03D0:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_03DA:
    Message msg_0380_R32_00003
    GoTo _05B7
_03E3:
    BufferPlayerName 0
    Message msg_0380_R32_00001
    GoTo _05B7
_03EF:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    Call _05BF
    ReleaseAll
    End
_03FF:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _060E
    ApplyMovement obj_R32_gsmiddleman1, _0874
    ApplyMovement LOCALID_PLAYER, _087A
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    GoTo _0651
_0438:
    ApplyMovement obj_R32_gsmiddleman1, _0884
    ApplyMovement LOCALID_PLAYER, _0892
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteCheckBadge BADGE_ID_HGSS_ZEPHYR, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _067E
    Message msg_0380_R32_00004
    GoTo _06A7
_0470:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteCheckBadge BADGE_ID_HGSS_ZEPHYR, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _067E
    Message msg_0380_R32_00004
    GoTo _06A7
_0498:
    Message msg_0380_R32_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04A3:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04AB:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04BF:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04D3:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _06CA
    ApplyMovement LOCALID_PLAYER, _08A0
    GoTo _04EE
_04EE:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _06ED
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _08AA
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 5
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_054F:
    BlackOutFromBattle
    ReleaseAll
    End
_0555:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0569
_055F:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0569
_0569:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0727
    ClearFlag FLAG_HGSS_UNK_208
    GoTo _072D
_0584:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 44
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 46
    SetPartyMonRibbon VAR_0x8002, RIBBON_RELAX
    PlayFanfare 20
    @ HGSS data: .byte 217, 7, 53, 0, 97, 0, 2, 0
_05AD:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_05B7:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05BF:
    CompareVar VAR_HGSS_UNK_408D, 0
    GoToIf 5, _072F
    SetVarFromValue VAR_HGSS_UNK_408D, 1
    Message msg_0380_R32_00005
    SetVarFromValue VAR_0x8004, ITEM_MIRACLE_SEED
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _076B
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0782
    Message msg_0380_R32_00008
    WaitButton
    GoTo _078B
_060E:
    ApplyMovement obj_R32_gsmiddleman1, _08B8
    ApplyMovement LOCALID_PLAYER, _08BE
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Call _05BF
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _0791
    ApplyMovement obj_R32_gsmiddleman1, _08C4
    WaitMovement
    ReleaseAll
    End
_0651:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Call _05BF
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _0791
    ApplyMovement obj_R32_gsmiddleman1, _08C4
    WaitMovement
    ReleaseAll
    End
_067E:
    BufferPlayerName 0
    Message msg_0380_R32_00002
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _0795
    ApplyMovement obj_R32_gsmiddleman1, _08CE
    GoTo _07A3
_06A7:
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _0795
    ApplyMovement obj_R32_gsmiddleman1, _08CE
    GoTo _07A3
_06CA:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _07A9
    ApplyMovement LOCALID_PLAYER, _08DC
    ApplyMovement obj_R32_gsmiddleman1_2, _086A
    GoTo _04EE
_06ED:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 5
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0727:
    SetFlag FLAG_HGSS_UNK_208
    End
_072D:
    End
_072F:
    Message msg_0380_R32_00005
    SetVarFromValue VAR_0x8004, ITEM_MIRACLE_SEED
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _076B
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0782
    Message msg_0380_R32_00008
    WaitButton
    GoTo _078B
_076B:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _081A
    Common_GiveItemQuantityNoLineFeed
    GoTo _0826
_0782:
    Message msg_0380_R32_00009
    GoTo _082E
_078B:
    GoTo _082E
_0791:
    ReleaseAll
    End
_0795:
    ApplyMovement obj_R32_gsmiddleman1, _08EE
    WaitMovement
    ReleaseAll
    End
_07A3:
    WaitMovement
    ReleaseAll
    End
_07A9:
    ApplyMovement LOCALID_PLAYER, _08FC
    ApplyMovement obj_R32_gsmiddleman1_2, _086A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _06ED
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _08AA
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 5
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_081A:
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_074
    CloseMessage
    Return
_0826:
    SetFlag FLAG_HGSS_UNK_074
    CloseMessage
    Return
_082E:
    CloseMessage
    Return
    .balign 4, 0
_0832:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_083C:
    WalkNormalWest 2
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0846:
    Delay8
    WalkNormalNorth 2
    FaceSouth
    EndMovement
    .balign 4, 0
_0854:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_086A:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0874:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_087A:
    Delay8
    FaceEast
    EndMovement
    .balign 4, 0
_0884:
    Delay4
    WalkNormalWest
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0892:
    Delay4
    WalkNormalNorth 2
    FaceSouth
    EndMovement
    .balign 4, 0
_08A0:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_08AA:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_08B8:
    Delay4
    EndMovement
    .balign 4, 0
_08BE:
    FaceEast
    EndMovement
    .balign 4, 0
_08C4:
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_08CE:
    WalkNormalSouth
    WalkNormalEast 2
    FaceWest
    EndMovement
    .balign 4, 0
_08DC:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_08EE:
    WalkNormalSouth
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_08FC:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
