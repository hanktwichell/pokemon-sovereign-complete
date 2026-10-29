#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0626.h"

#define obj_T29_rgyaradosu 3
#define obj_T29_wataru 8
#define obj_T29_tsure_poke_static_dragonite 10
#define obj_T29_gsleader7 20

    ScriptEntry scr_seq_T29_000
    ScriptEntry scr_seq_T29_001
    ScriptEntry scr_seq_T29_002
    ScriptEntry scr_seq_T29_003
    ScriptEntry scr_seq_T29_004
    ScriptEntry scr_seq_T29_005
    ScriptEntry scr_seq_T29_006
    ScriptEntry scr_seq_T29_007
    ScriptEntry scr_seq_T29_008
    ScriptEntry scr_seq_T29_009
    ScriptEntry scr_seq_T29_010
    ScriptEntry scr_seq_T29_011
    ScriptEntry scr_seq_T29_012
    ScriptEntry scr_seq_T29_013
    ScriptEntry scr_seq_T29_014
    ScriptEntry scr_seq_T29_015
    ScriptEntry scr_seq_T29_016
    ScriptEntry scr_seq_T29_017
    ScriptEntry scr_seq_T29_018
    ScriptEntryEnd
scr_seq_T29_000:
    GoToIfSet FLAG_HGSS_GOT_RED_SCALE, _007F
    SetFlag FLAG_HGSS_UNK_1FC
    SetFlag FLAG_HGSS_UNK_1FE
    SetFlag FLAG_MAP_LOCAL_0x11
    SetFlag FLAG_MAP_LOCAL_0x13
    SetFlag FLAG_MAP_LOCAL_0x14
    SetFlag FLAG_MAP_LOCAL_0x15
    SetFlag FLAG_HGSS_UNK_289
    SetFlag FLAG_HGSS_UNK_28B
    SetFlag FLAG_HGSS_UNK_28C
    End
_007F:
    GoTo _0115
_0085:
    CompareVar VAR_HGSS_UNK_4037, 61993
    GoToIf 1, _00BC
    SetFlag FLAG_HGSS_UNK_1FC
    SetFlag FLAG_HGSS_UNK_1FE
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_FISHERMEN
    SetFlag FLAG_MAP_LOCAL_0x11
    SetFlag FLAG_MAP_LOCAL_0x13
    SetFlag FLAG_MAP_LOCAL_0x14
    SetFlag FLAG_MAP_LOCAL_0x15
    SetFlag FLAG_HGSS_UNK_289
    SetFlag FLAG_HGSS_UNK_28B
    SetFlag FLAG_HGSS_UNK_28C
    End
_00BC:
    ClearFlag FLAG_HGSS_UNK_1FC
    ClearFlag FLAG_HGSS_UNK_1FE
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_FISHERMEN
    ClearFlag FLAG_HGSS_UNK_289
    ClearFlag FLAG_HGSS_UNK_28B
    ClearFlag FLAG_HGSS_UNK_28C
    GoToIfSet FLAG_HGSS_UNK_146, _00E5
    GoTo _00E9
_00E5:
    SetFlag FLAG_HGSS_UNK_289
_00E9:
    GoToIfSet FLAG_HGSS_UNK_147, _00FA
    GoTo _00FE
_00FA:
    SetFlag FLAG_HGSS_UNK_28B
_00FE:
    GoToIfSet FLAG_HGSS_UNK_148, _010F
    GoTo _0113
_010F:
    SetFlag FLAG_HGSS_UNK_28C
_0113:
    End
_0115:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_PRYCE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01A7
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0139
    GoTo _01A7
_0139:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0154
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _019F
_0154:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _016B
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _019F
_016B:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _0182
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _019F
_0182:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _0199
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _019F
_0199:
    GoTo _01A7
_019F:
    GoTo _0085
    End
_01A7:
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _0085
    End
scr_seq_T29_002:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _01C0
    End
_01C0:
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_RED_GYARADOS
    RemoveObject obj_T29_rgyaradosu
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE
    AddObject obj_T29_wataru
    AddObject obj_T29_tsure_poke_static_dragonite
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_T29_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 4, _026A
    Message msg_0626_T29_00013
_01F2:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0216
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0259
    End
_0216:
    BufferPlayerName 0
    Message msg_0626_T29_00014
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_PRYCE
    Message msg_0626_T29_00015
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    RemoveObject obj_T29_gsleader7
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0259:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    Message msg_0626_T29_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_026A:
    Message msg_0626_T29_00017
    GoTo _01F2
    End
scr_seq_T29_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    @ HGSS: MonHasRibbon VAR_SPECIAL_RESULT, VAR_SPECIAL_x8002, RIBBON_DOWNCAST
    CompareVar VAR_RESULT, 1
    GoToIf 1, _039B
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _03AF
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _0349
    GoToIfSet FLAG_HGSS_GOT_BLACK_BELT_FROM_WESLEY, _032B
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 1, _02DC
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 11
    GoTo _0323
_02DC:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 8
    SetVar VAR_0x8004, ITEM_BLACK_BELT
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _033F
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_BLACK_BELT_FROM_WESLEY
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 9
_0323:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_032B:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 10
    WaitButton
    CloseMessage
    ReleaseAll
    End
_033F:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0349:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 1, _036C
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 11
    GoTo _0323
_036C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 36
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 38
    @ HGSS: GiveRibbon VAR_SPECIAL_x8002, RIBBON_DOWNCAST
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON
    WaitButton
    CloseMessage
    ReleaseAll
    End
_039B:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 37
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03AF:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 39
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T29_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_GYARADOS, 0
    Message msg_0626_T29_00000
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_GYARADOS, 30, 1
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0456
    @ HGSS: GetStaticEncounterOutcome VAR_TEMP_x4002
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _0452
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _0466
    GoToIfSet FLAG_HGSS_GOT_RED_SCALE, _046C
    OpenMessage
    SetVar VAR_0x8004, ITEM_RED_SCALE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _045C
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_RED_SCALE
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_ACE_TRAINER_LOIS
    CloseMessage
_0452:
    ReleaseAll
    End
_0456:
    BlackOutFromBattle
    ReleaseAll
    End
_045C:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0466:
    SetFlag FLAG_HGSS_CAUGHT_RED_GYARADOS
    Return
_046C:
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE
    RemoveObject obj_T29_wataru
    RemoveObject obj_T29_tsure_poke_static_dragonite
    ReleaseAll
    End
scr_seq_T29_003:
    GoToIfSet FLAG_HGSS_UNK_0C3, _0509
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0626_T29_00002
    FacePlayer
    BufferPlayerName 0
    MessageGendered msg_0626_T29_00003, msg_0626_T29_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04BB
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04FA
_04BB:
    BufferPlayerName 0
    MessageGendered msg_0626_T29_00005, msg_0626_T29_00006
    WaitButton
    CloseMessage
    ApplyMovement obj_T29_tsure_poke_static_dragonite, _0538
    WaitMovement
    ApplyMovement obj_T29_wataru, _0544
    WaitMovement
    @ HGSS: ScrCmd_775 8, 10
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE
    RemoveObject obj_T29_wataru
    RemoveObject obj_T29_tsure_poke_static_dragonite
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_SHOP_LANCE
    SetVarFromValue VAR_HGSS_UNK_40A8, 1
    ReleaseAll
    End
_04FA:
    SetFlag FLAG_HGSS_UNK_0C3
    Message msg_0626_T29_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0509:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0626_T29_00008
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04BB
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04FA
    End
    .balign 4, 0
_0538:
    WalkOnSpotNormalWest
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_0544:
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_T29_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_ROCKET_HIDEOUT_CLEARED, _056A
    Message msg_0626_T29_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_056A:
    Message msg_0626_T29_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
    End
scr_seq_T29_006:
    GoToIfSet FLAG_HGSS_UNK_139, _0597
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0626_T29_00031, VAR_RESULT
    Common_HandleSignpostInput
    End
_0597:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScriptOverlayCmd 0, 0
    @ HGSS: BufferRecordSize 0, 1, SPECIES_MAGIKARP
    @ HGSS: ScriptOverlayCmd 0, 1
    BufferPlayerName 2
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0626_T29_00032, VAR_RESULT
    Common_HandleSignpostInput
    @ HGSS: Dummy486
    @ HGSS: Dummy486
    ReleaseAll
    End
scr_seq_T29_014:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    SetVarFromValue VAR_0x8008, 27
    SetVarFromValue VAR_0x8009, 1
    GoTo _061B
    End
scr_seq_T29_015:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 2
    SetVarFromValue VAR_0x8008, 29
    SetVarFromValue VAR_0x8009, 1
    GoTo _061B
    End
scr_seq_T29_016:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 3
    SetVarFromValue VAR_0x8008, 23
    SetVarFromValue VAR_0x8009, 1
    GoTo _061B
    End
_061B:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    WaitSE SE_CONFIRM_sseq_3
    SetVarFromVar VAR_0x8004, VAR_0x8008
    SetVarFromVar VAR_0x8005, VAR_0x8009
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0657
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06CA
    End
_0657:
    @ HGSS: CallStd std_hidden_item_fanfare
    RemoveObject VAR_LAST_TALKED
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 5, _0676
    SetFlag FLAG_HGSS_UNK_146
    GoTo _0691
_0676:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _068D
    SetFlag FLAG_HGSS_UNK_147
    GoTo _0691
_068D:
    SetFlag FLAG_HGSS_UNK_148
_0691:
    AddItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    Message msg_0626_T29_00033
    WaitFanfare
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 2, VAR_RESULT
    Message msg_0626_T29_00034
    WaitButton
    SetVarFromValue VAR_RESULT, 1
_06C4:
    CloseMessage
    ReleaseAll
    End
_06CA:
    BufferItemName 0, VAR_0x8004
    Message msg_0626_T29_00035
    WaitButton
    SetVarFromValue VAR_RESULT, 0
    GoTo _06C4
    End
scr_seq_T29_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_DRAGONITE, 0
    Message msg_0626_T29_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T29_007:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0626_T29_00030, VAR_RESULT
    Common_HandleSignpostInput
    End
_0710:
    NPCMessage msg_0626_T29_00009
    End
scr_seq_T29_008:
    NPCMessage msg_0626_T29_00012
    End
scr_seq_T29_009:
    NPCMessage msg_0626_T29_00011
    End
_0749:
    NPCMessage msg_0626_T29_00000
    End
scr_seq_T29_010:
    NPCMessage msg_0626_T29_00018
    End
scr_seq_T29_011:
    NPCMessage msg_0626_T29_00021
    End
scr_seq_T29_012:
    NPCMessage msg_0626_T29_00024
    End
scr_seq_T29_013:
    NPCMessage msg_0626_T29_00027
    End
    .balign 4, 0
