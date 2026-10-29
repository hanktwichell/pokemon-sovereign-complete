#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
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
    ScriptEntryEnd
scr_seq_R32_004:
    GoToIfUnset FLAG_HGSS_UNK_189, _003B
    ClearFlag FLAG_HGSS_UNK_189
    End
_003B:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0079
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0083
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0083
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0083
_0079:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _008D
_0083:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _008D
_008D:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _00A8
    ClearFlag FLAG_HGSS_UNK_208
    GoTo _00AC
_00A8:
    SetFlag FLAG_HGSS_UNK_208
_00AC:
    End
scr_seq_R32_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    @ HGSS: MonHasRibbon VAR_SPECIAL_RESULT, VAR_SPECIAL_x8002, RIBBON_RELAX
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01D4
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _01E8
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _0182
    GoToIfSet FLAG_HGSS_GOT_POISON_BARB_FROM_FRIEDA, _0164
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0115
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 19
    GoTo _015C
_0115:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 16
    SetVar VAR_0x8004, ITEM_POISON_BARB
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0178
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_POISON_BARB_FROM_FRIEDA
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 17
_015C:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0164:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 18
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0178:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0182:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _01A5
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 19
    GoTo _015C
_01A5:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 44
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 46
    @ HGSS: GiveRibbon VAR_SPECIAL_x8002, RIBBON_RELAX
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01D4:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 45
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01E8:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 47
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R32_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TM05_FROM_ROUTE_32_MAN, _023B
    Message msg_0380_R32_00010
    SetVar VAR_0x8004, ITEM_TM05
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0246
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM05_FROM_ROUTE_32_MAN
_023B:
    Message msg_0380_R32_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0246:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_R32_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _028C
    GoToIfUnset FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT, _0297
    GoToIfUnset FLAG_HGSS_UNK_074, _02A5
    Message msg_0380_R32_00007
_0284:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_028C:
    Message msg_0380_R32_00003
    GoTo _0284
    End
_0297:
    BufferPlayerName 0
    Message msg_0380_R32_00001
    GoTo _0284
    End
_02A5:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    Call _02B5
    ReleaseAll
    End
_02B5:
    CompareVar VAR_HGSS_UNK_408D, 0
    GoToIf 5, _02C8
    SetVarFromValue VAR_HGSS_UNK_408D, 1
_02C8:
    Message msg_0380_R32_00005
    SetVarFromValue VAR_0x8004, 239
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _030D
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0304
    Message msg_0380_R32_00008
    WaitButton
    GoTo _0307
_0304:
    Message msg_0380_R32_00009
_0307:
    GoTo _032C
_030D:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0324
    Common_GiveItemQuantityNoLineFeed
    GoTo _0328
_0324:
    Common_GiveItemQuantity
_0328:
    SetFlag FLAG_HGSS_UNK_074
_032C:
    CloseMessage
    Return
scr_seq_R32_002:
    LockAll
    ApplyMovement obj_R32_gsmiddleman1, _046C
    WaitMovement
    Message msg_0380_R32_00000
    CloseMessage
    GoToIfSet FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT, _03F0
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _0381
    ApplyMovement obj_R32_gsmiddleman1, _0478
    ApplyMovement LOCALID_PLAYER, _0494
    GoTo _0391
_0381:
    ApplyMovement obj_R32_gsmiddleman1, _0484
    ApplyMovement LOCALID_PLAYER, _04A4
_0391:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03B9
    Message msg_0380_R32_00004
    GoTo _03BF
_03B9:
    BufferPlayerName 0
    Message msg_0380_R32_00002
_03BF:
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _03E2
    ApplyMovement obj_R32_gsmiddleman1, _04B4
    GoTo _03EA
_03E2:
    ApplyMovement obj_R32_gsmiddleman1, _04C4
_03EA:
    WaitMovement
    ReleaseAll
    End
_03F0:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _0429
    ApplyMovement obj_R32_gsmiddleman1, _04D4
    ApplyMovement LOCALID_PLAYER, _04E4
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    GoTo _043F
_0429:
    ApplyMovement obj_R32_gsmiddleman1, _04DC
    ApplyMovement LOCALID_PLAYER, _04F0
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
_043F:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Call _02B5
    CompareVar VAR_MAP_LOCAL_0x00, 475
    GoToIf 5, _0468
    ApplyMovement obj_R32_gsmiddleman1, _04F8
    WaitMovement
_0468:
    ReleaseAll
    End
    .balign 4, 0
_046C:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0478:
    WalkNormalWest 2
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0484:
    Delay4
    WalkNormalWest
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0494:
    Delay8
    WalkNormalNorth 2
    FaceSouth
    EndMovement
    .balign 4, 0
_04A4:
    Delay4
    WalkNormalNorth 2
    FaceSouth
    EndMovement
    .balign 4, 0
_04B4:
    WalkNormalSouth
    WalkNormalEast 2
    FaceWest
    EndMovement
    .balign 4, 0
_04C4:
    WalkNormalSouth
    WalkNormalEast
    FaceWest
    EndMovement
    .balign 4, 0
_04D4:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_04DC:
    Delay4
    EndMovement
    .balign 4, 0
_04E4:
    Delay8
    FaceEast
    EndMovement
    .balign 4, 0
_04F0:
    FaceEast
    EndMovement
    .balign 4, 0
_04F8:
    WalkNormalEast
    FaceWest
    EndMovement
scr_seq_R32_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0380_R32_00014
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _052D
    Message msg_0380_R32_00015
    GoTo _0530
_052D:
    Message msg_0380_R32_00016
_0530:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R32_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0660
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0674
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _05B1
    ApplyMovement LOCALID_PLAYER, _0688
    ApplyMovement obj_R32_gsmiddleman1_2, _06D4
    GoTo _05FF
_05B1:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05CC
    ApplyMovement LOCALID_PLAYER, _06A0
    GoTo _05FF
_05CC:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _05EF
    ApplyMovement LOCALID_PLAYER, _06C0
    ApplyMovement obj_R32_gsmiddleman1_2, _06D4
    GoTo _05FF
_05EF:
    ApplyMovement LOCALID_PLAYER, _06AC
    ApplyMovement obj_R32_gsmiddleman1_2, _06D4
_05FF:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0626
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06E0
    WaitMovement
_0626:
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
_0660:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0674:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0688:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06A0:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06AC:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06C0:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06D4:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_06E0:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
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
    .balign 4, 0
