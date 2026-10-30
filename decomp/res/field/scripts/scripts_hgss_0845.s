#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0545.h"

#define obj_T20R0201_gsmama 0

    ScriptEntry scr_seq_T20R0201_000
    ScriptEntry scr_seq_T20R0201_001
    ScriptEntry scr_seq_T20R0201_002
    ScriptEntry scr_seq_T20R0201_003
    ScriptEntry scr_seq_T20R0201_004
    ScriptEntry scr_seq_T20R0201_005
    ScriptEntry scr_seq_T20R0201_006
    ScriptEntryEnd
scr_seq_T20R0201_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _05EC
    ApplyMovement obj_T20R0201_gsmama, _05F6
    WaitMovement
    StopMusic
    SetBGM SEQ_GS_E_TSURETEKE1_sseq
    WaitTime 30, VAR_RESULT
    ApplyMovement obj_T20R0201_gsmama, _05FC
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0545_T20R0201_00000, msg_0545_T20R0201_00001
    SetFlag FLAG_HGSS_GOT_BAG
    SetFlag FLAG_HGSS_GOT_TRAINER_CARD
    SetFlag FLAG_HGSS_GOT_SAVE_BUTTON
    SetFlag FLAG_HGSS_GOT_OPTIONS_BUTTON
    PlayFanfare SEQ_SE_PL_KIRAKIRA_sseq
    WaitFanfare
    Message msg_0545_T20R0201_00002
    SetVarFromValue VAR_HGSS_SG_6130, 2
    SetFlag FLAG_HGSS_SG_3FE8
    SetFlag FLAG_HGSS_SG_3FE7
    SetFlag FLAG_HGSS_SG_3FDF
    SetFlag FLAG_HGSS_SG_3FD7
    SetFlag FLAG_HGSS_SG_3FD6
    SetFlag FLAG_HGSS_SG_3FD5
    SetFlag FLAG_HGSS_SG_3FC6
    SetFlag FLAG_HGSS_SG_3FC5
    SetFlag FLAG_HGSS_SG_3FC4
    SetFlag FLAG_HGSS_SG_3FC2
    SetFlag FLAG_HGSS_SG_3FBF
    SetFlag FLAG_HGSS_SG_3FBE
    SetFlag FLAG_HGSS_SG_3FBC
    SetFlag FLAG_HGSS_SG_3FBA
    SetFlag FLAG_HGSS_SG_3FB7
    SetFlag FLAG_HGSS_SG_3FB3
    SetFlag FLAG_HGSS_SG_3FB2
    SetFlag FLAG_HGSS_SG_3FA0
    SetFlag FLAG_HGSS_SG_3F9B
    SetFlag FLAG_HGSS_SG_3F8B
    SetFlag FLAG_HGSS_SG_3F62
    SetFlag FLAG_HGSS_SG_3F5D
    Message msg_0545_T20R0201_00003
    GiveRunningShoes
    GetSetNationalDexEnabled 1, VAR_RESULT
    PlayFanfare SEQ_SE_PL_KIRAKIRA_sseq
    WaitFanfare
    Message msg_0545_T20R0201_00004
    SetVar VAR_0x8004, ITEM_BICYCLE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVar VAR_0x8004, ITEM_GB_SOUNDS
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0545_T20R0201_00005
    CloseMessage
    WaitTime 15, VAR_RESULT
    ApplyMovement obj_T20R0201_gsmama, _060A
    WaitMovement
    Common_FadeToDefaultMusic3
    SetVarFromValue VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 1
    ReleaseAll
    End
scr_seq_T20R0201_006:
    LockAll
    ApplyMovement LOCALID_PLAYER, _05EC
    ApplyMovement obj_T20R0201_gsmama, _05F6
    WaitMovement
    StopMusic
    SetBGM SEQ_GS_E_TSURETEKE1_sseq
    WaitTime 30, VAR_RESULT
    ApplyMovement obj_T20R0201_gsmama, _05FC
    WaitMovement
    BufferPlayerName 0
    Message msg_0545_T20R0201_00033
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3F9B
    ApplyMovement obj_T20R0201_gsmama, _060A
    WaitMovement
    Common_FadeToDefaultMusic3
    SetVarFromValue VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 4
    ReleaseAll
    End
scr_seq_T20R0201_001:
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0202
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 4
    GoToIf 4, _021D
    GoToIfSet FLAG_HGSS_GOT_STARTER, _024C
    NPCMessage msg_0545_T20R0201_00006
    End
scr_seq_T20R0201_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfSet FLAG_HGSS_SG_3FC1, _0299
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02A4
    Message msg_0545_T20R0201_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0201_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0545_T20R0201_00036
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0201_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0545_T20R0201_00037
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0201_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0545_T20R0201_00038
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0202:
    CheckItem ITEM_SS_TICKET, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02CA
    GoTo _021D
_021D:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TALKED_TO_MOM_AFTER_NAMING_RIVAL, _02DD
    CompleteCheckBadge BADGE_ID_HGSS_ZEPHYR, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0345
    Message msg_0545_T20R0201_00015
    GoTo _0377
_024C:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_POKEGEAR, _03A3
    BufferPlayerName 0
    Message msg_0545_T20R0201_00007
    BufferPlayerName 0
    Message msg_0545_T20R0201_00008
    SetFlag FLAG_HGSS_GOT_POKEGEAR
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    Message msg_0545_T20R0201_00009
    Message msg_0545_T20R0201_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03AE
    Message msg_0545_T20R0201_00011
    GoTo _03BC
_0299:
    Message msg_0545_T20R0201_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02A4:
    Message msg_0545_T20R0201_00039
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03C7
    ReleaseAll
    End
_02CA:
    NPCMessage msg_0545_T20R0201_00034
    End
_02DD:
    Message msg_0545_T20R0201_00020
    CompleteBankShowBalance
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 29, 0
    AddMenuEntry 30, 1
    AddMenuEntry 31, 2
    AddMenuEntry 32, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0443
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0499
    CompareVar VAR_0x8008, 2
    GoToIf 1, _04ED
    GoTo _0517
_0345:
    BufferPlayerName 0
    Message msg_0545_T20R0201_00016
    SetFlag FLAG_HGSS_TALKED_TO_MOM_AFTER_NAMING_RIVAL
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_PHONE_CALL, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0526
    Message msg_0545_T20R0201_00017
    SetFlag FLAG_HGSS_SYS_MOMS_SAVINGS
    GoTo _0535
_0377:
    SetFlag FLAG_HGSS_TALKED_TO_MOM_AFTER_NAMING_RIVAL
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_PHONE_CALL, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0526
    Message msg_0545_T20R0201_00017
    SetFlag FLAG_HGSS_SYS_MOMS_SAVINGS
    GoTo _0535
_03A3:
    Message msg_0545_T20R0201_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03AE:
    Message msg_0545_T20R0201_00012
    Message msg_0545_T20R0201_00013
    WaitABPadPress
    CloseMessage
    ReleaseAll
    End
_03BC:
    Message msg_0545_T20R0201_00013
    WaitABPadPress
    CloseMessage
    ReleaseAll
    End
_03C7:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0545_T20R0201_00040
    PlayCry SPECIES_ROTOM, 6
    Message msg_0545_T20R0201_00043
    WaitCry
    CloseMessage
    CompleteStartWildBattle SPECIES_ROTOM, 20, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _053D
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0543
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _054E
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _0543
    ReleaseAll
    End
_0443:
    CompleteBankOrWalletIsFull 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _055D
    CompleteBankCheckBalance VAR_RESULT, 1
    CompareVar VAR_RESULT, 0
    GoToIf 1, _056C
    CompleteBankTransaction 1, VAR_RESULT
    CompleteBankHideBalance
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _057B
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0595
    ReleaseAll
    End
_0499:
    CompleteBankOrWalletIsFull 0, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05A0
    CheckMoney2 VAR_RESULT, 1
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05AF
    CompleteBankTransaction 0, VAR_RESULT
    CompleteBankHideBalance
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _05BE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0595
    ReleaseAll
    End
_04ED:
    Message msg_0545_T20R0201_00025
    ShowYesNoMenu VAR_RESULT
    CompleteBankHideBalance
    CompareVar VAR_RESULT, 0
    GoToIf 5, _05D5
    BufferPlayerName 0
    Message msg_0545_T20R0201_00017
    SetFlag FLAG_HGSS_SYS_MOMS_SAVINGS
    GoTo _05E4
_0517:
    CompleteBankHideBalance
    Message msg_0545_T20R0201_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0526:
    Message msg_0545_T20R0201_00018
    ClearFlag FLAG_HGSS_SYS_MOMS_SAVINGS
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0535:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_053D:
    BlackOutFromBattle
    ReleaseAll
    End
_0543:
    Message msg_0545_T20R0201_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End
_054E:
    Message msg_0545_T20R0201_00042
    SetFlag FLAG_HGSS_SG_3FC1
    WaitButton
    CloseMessage
    ReleaseAll
    End
_055D:
    CompleteBankHideBalance
    Message msg_0545_T20R0201_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
_056C:
    CompleteBankHideBalance
    Message msg_0545_T20R0201_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_057B:
    CloseMessage
    WaitTime 8, VAR_RESULT
    BufferPlayerName 0
    Message msg_0545_T20R0201_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0595:
    Message msg_0545_T20R0201_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05A0:
    CompleteBankHideBalance
    Message msg_0545_T20R0201_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05AF:
    CompleteBankHideBalance
    Message msg_0545_T20R0201_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05BE:
    CloseMessage
    WaitTime 8, VAR_RESULT
    Message msg_0545_T20R0201_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05D5:
    Message msg_0545_T20R0201_00018
    ClearFlag FLAG_HGSS_SYS_MOMS_SAVINGS
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05E4:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_05EC:
    Delay4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05F6:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05FC:
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_060A:
    WalkOnSpotNormalSouth
    WalkNormalSouth 3
    WalkNormalEast 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
