#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "generated/ribbons.h"
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
    GoToIfSet FLAG_HGSS_GOT_RED_SCALE, _0366
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
scr_seq_T29_002:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _036C
    End
scr_seq_T29_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 4, _0386
    Message msg_0626_T29_00013
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _038F
    CompareVar VAR_RESULT, 1
    GoToIf 4, _03D2
    End
scr_seq_T29_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    GetPartyMonRibbon VAR_RESULT, VAR_0x8002, RIBBON_DOWNCAST
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03E3
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _03F7
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _040B
    GoToIfSet FLAG_HGSS_GOT_BLACK_BELT_FROM_WESLEY, _042E
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0442
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 11
    GoTo _0491
scr_seq_T29_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_GYARADOS, 0
    Message msg_0626_T29_00000
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_GYARADOS, 40, 1
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0499
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _049F
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _04A3
    GoToIfSet FLAG_HGSS_GOT_RED_SCALE, _04A9
    OpenMessage
    SetVar VAR_0x8004, ITEM_RED_SCALE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _04B9
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_RED_SCALE
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_ACE_TRAINER_LOIS
    CloseMessage
    ReleaseAll
    End
scr_seq_T29_003:
    GoToIfSet FLAG_HGSS_UNK_0C3, _04C3
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0626_T29_00002
    FacePlayer
    BufferPlayerName 0
    MessageGendered msg_0626_T29_00003, msg_0626_T29_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04F2
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0531
    BufferPlayerName 0
    MessageGendered msg_0626_T29_00005, msg_0626_T29_00006
    WaitButton
    CloseMessage
    ApplyMovement obj_T29_tsure_poke_static_dragonite, _082A
    WaitMovement
    ApplyMovement obj_T29_wataru, _0834
    WaitMovement
    @ HGSS: ScrCmd_775 8, 10
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE
    RemoveObject obj_T29_wataru
    RemoveObject obj_T29_tsure_poke_static_dragonite
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_SHOP_LANCE
    SetVarFromValue VAR_HGSS_UNK_40A8, 1
    ReleaseAll
    End
scr_seq_T29_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_ROCKET_HIDEOUT_CLEARED, _0540
    Message msg_0626_T29_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T29_006:
    GoToIfSet FLAG_HGSS_UNK_139, _054B
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0626_T29_00031, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T29_014:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    SetVarFromValue VAR_0x8008, 27
    SetVarFromValue VAR_0x8009, 1
    GoTo _0581
scr_seq_T29_015:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 2
    SetVarFromValue VAR_0x8008, 29
    SetVarFromValue VAR_0x8009, 1
    GoTo _0581
scr_seq_T29_016:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 3
    SetVarFromValue VAR_0x8008, 23
    SetVarFromValue VAR_0x8009, 1
    GoTo _0581
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
scr_seq_T29_008:
    NPCMessage msg_0626_T29_00012
    End
scr_seq_T29_009:
    NPCMessage msg_0626_T29_00011
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
_0366:
    GoTo _05BD
_036C:
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_RED_GYARADOS
    RemoveObject obj_T29_rgyaradosu
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE
    AddObject obj_T29_wataru
    AddObject obj_T29_tsure_poke_static_dragonite
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_0386:
    Message msg_0626_T29_00017
    GoTo _05E1
_038F:
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
_03D2:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    Message msg_0626_T29_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E3:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 37
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03F7:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 39
    WaitButton
    CloseMessage
    ReleaseAll
    End
_040B:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0605
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 11
    GoTo _0491
_042E:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 10
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0442:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 8
    SetVar VAR_0x8004, ITEM_BLACK_BELT
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _062E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_BLACK_BELT_FROM_WESLEY
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 9
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0491:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0499:
    BlackOutFromBattle
    ReleaseAll
    End
_049F:
    ReleaseAll
    End
_04A3:
    SetFlag FLAG_HGSS_CAUGHT_RED_GYARADOS
    Return
_04A9:
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE
    RemoveObject obj_T29_wataru
    RemoveObject obj_T29_tsure_poke_static_dragonite
    ReleaseAll
    End
_04B9:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_04C3:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0626_T29_00008
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04F2
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0531
    End
_04F2:
    BufferPlayerName 0
    MessageGendered msg_0626_T29_00005, msg_0626_T29_00006
    WaitButton
    CloseMessage
    ApplyMovement obj_T29_tsure_poke_static_dragonite, _082A
    WaitMovement
    ApplyMovement obj_T29_wataru, _0834
    WaitMovement
    @ HGSS: ScrCmd_775 8, 10
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE
    RemoveObject obj_T29_wataru
    RemoveObject obj_T29_tsure_poke_static_dragonite
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_SHOP_LANCE
    SetVarFromValue VAR_HGSS_UNK_40A8, 1
    ReleaseAll
    End
_0531:
    SetFlag FLAG_HGSS_UNK_0C3
    Message msg_0626_T29_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0540:
    Message msg_0626_T29_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_054B:
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
_0581:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    WaitSE SE_CONFIRM_sseq_3
    SetVarFromVar VAR_0x8004, VAR_0x8008
    SetVarFromVar VAR_0x8005, VAR_0x8009
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0638
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0657
    End
_05BD:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_PRYCE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _066D
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0677
    GoTo _066D
_05E1:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _038F
    CompareVar VAR_RESULT, 1
    GoToIf 4, _03D2
    End
_0605:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 36
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 38
    SetPartyMonRibbon VAR_0x8002, RIBBON_DOWNCAST
    PlayFanfare 20
    @ HGSS data: .byte 217, 7, 53, 0, 97, 0, 2, 0
_062E:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0638:
    @ HGSS: CallStd std_hidden_item_fanfare
    RemoveObject VAR_LAST_TALKED
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 5, _0692
    SetFlag FLAG_HGSS_UNK_146
    GoTo _06A9
_0657:
    BufferItemName 0, VAR_0x8004
    Message msg_0626_T29_00035
    WaitButton
    SetVarFromValue VAR_RESULT, 0
    GoTo _06E2
_066D:
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _06E8
_0677:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _071F
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _0736
_0692:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _073C
    SetFlag FLAG_HGSS_UNK_147
    GoTo _06A9
_06A9:
    AddItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    Message msg_0626_T29_00033
    WaitFanfare
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0626_T29_00034
    WaitButton
    SetVarFromValue VAR_RESULT, 1
    CloseMessage
    ReleaseAll
    End
_06E2:
    CloseMessage
    ReleaseAll
    End
_06E8:
    CompareVar VAR_HGSS_UNK_4037, 61993
    GoToIf 1, _0779
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
_071F:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _07A2
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _0736
_0736:
    GoTo _06E8
_073C:
    SetFlag FLAG_HGSS_UNK_148
    AddItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    Message msg_0626_T29_00033
    WaitFanfare
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0626_T29_00034
    WaitButton
    SetVarFromValue VAR_RESULT, 1
    CloseMessage
    ReleaseAll
    End
_0779:
    ClearFlag FLAG_HGSS_UNK_1FC
    ClearFlag FLAG_HGSS_UNK_1FE
    SetFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_FISHERMEN
    ClearFlag FLAG_HGSS_UNK_289
    ClearFlag FLAG_HGSS_UNK_28B
    ClearFlag FLAG_HGSS_UNK_28C
    GoToIfSet FLAG_HGSS_UNK_146, _07B9
    GoTo _07CE
_07A2:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _07DF
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _0736
_07B9:
    SetFlag FLAG_HGSS_UNK_289
    GoToIfSet FLAG_HGSS_UNK_147, _07F6
    GoTo _080B
_07CE:
    GoToIfSet FLAG_HGSS_UNK_147, _07F6
    GoTo _080B
_07DF:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _081C
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    GoTo _0736
_07F6:
    SetFlag FLAG_HGSS_UNK_28B
    GoToIfSet FLAG_HGSS_UNK_148, _0822
    GoTo _0828
_080B:
    GoToIfSet FLAG_HGSS_UNK_148, _0822
    GoTo _0828
_081C:
    GoTo _066D
_0822:
    SetFlag FLAG_HGSS_UNK_28C
    End
_0828:
    End
    .balign 4, 0
_082A:
    WalkOnSpotNormalWest
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_0834:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
