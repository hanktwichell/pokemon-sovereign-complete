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
    ApplyMovement LOCALID_PLAYER, _00A4
    ApplyMovement obj_T20R0201_gsmama, _00B0
    WaitMovement
    Common_SetFollowMeBGM
    WaitTime 30, VAR_RESULT
    ApplyMovement obj_T20R0201_gsmama, _00B8
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0545_T20R0201_00000, msg_0545_T20R0201_00001
    SetFlag FLAG_HGSS_GOT_BAG
    PlayFanfare SEQ_SE_PL_KIRAKIRA_sseq
    WaitFanfare
    Message msg_0545_T20R0201_00002
    SetFlag FLAG_HGSS_GOT_TRAINER_CARD
    PlayFanfare SEQ_SE_PL_KIRAKIRA_sseq
    WaitFanfare
    Message msg_0545_T20R0201_00003
    SetFlag FLAG_HGSS_GOT_SAVE_BUTTON
    PlayFanfare SEQ_SE_PL_KIRAKIRA_sseq
    WaitFanfare
    Message msg_0545_T20R0201_00004
    SetFlag FLAG_HGSS_GOT_OPTIONS_BUTTON
    PlayFanfare SEQ_SE_PL_KIRAKIRA_sseq
    WaitFanfare
    Message msg_0545_T20R0201_00005
    CloseMessage
    WaitTime 15, VAR_RESULT
    ApplyMovement obj_T20R0201_gsmama, _00C8
    WaitMovement
    Common_FadeToDefaultMusic3
    SetVarFromValue VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 1
    ReleaseAll
    End
    .balign 4, 0
_00A4:
    Delay4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_00B0:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_00B8:
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_00C8:
    WalkOnSpotNormalSouth
    WalkNormalSouth 3
    WalkNormalEast 3
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_T20R0201_006:
    LockAll
    ApplyMovement LOCALID_PLAYER, _00A4
    ApplyMovement obj_T20R0201_gsmama, _00B0
    WaitMovement
    Common_SetFollowMeBGM
    WaitTime 30, VAR_RESULT
    ApplyMovement obj_T20R0201_gsmama, _00B8
    WaitMovement
    BufferPlayerName 0
    Message msg_0545_T20R0201_00033
    CloseMessage
    ApplyMovement obj_T20R0201_gsmama, _00C8
    WaitMovement
    Common_FadeToDefaultMusic3
    SetVarFromValue VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 4
    ReleaseAll
    End
scr_seq_T20R0201_001:
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _015C
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 4
    GoToIf 4, _0205
    GoToIfSet FLAG_HGSS_GOT_STARTER, _0179
    NPCMessage msg_0545_T20R0201_00006
    End
_015C:
    CheckItem ITEM_SS_TICKET, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01F2
    GoTo _0205
    End
_0179:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_POKEGEAR, _01D4
    BufferPlayerName 0
    Message msg_0545_T20R0201_00007
    BufferPlayerName 0
    Message msg_0545_T20R0201_00008
    SetFlag FLAG_HGSS_GOT_POKEGEAR
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0545_T20R0201_00009
    Message msg_0545_T20R0201_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01C6
    Message msg_0545_T20R0201_00011
    GoTo _01C9
_01C6:
    Message msg_0545_T20R0201_00012
_01C9:
    Message msg_0545_T20R0201_00013
    WaitABPadPress
    CloseMessage
    ReleaseAll
    End
_01D4:
    Message msg_0545_T20R0201_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DF:
    NPCMessage msg_0545_T20R0201_00007
    End
_01F2:
    NPCMessage msg_0545_T20R0201_00034
    End
_0205:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TALKED_TO_MOM_AFTER_NAMING_RIVAL, _0275
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0234
    Message msg_0545_T20R0201_00015
    GoTo _023A
_0234:
    BufferPlayerName 0
    Message msg_0545_T20R0201_00016
_023A:
    SetFlag FLAG_HGSS_TALKED_TO_MOM_AFTER_NAMING_RIVAL
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_PHONE_CALL, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0266
    Message msg_0545_T20R0201_00017
    SetFlag FLAG_HGSS_SYS_MOMS_SAVINGS
    GoTo _026D
_0266:
    Message msg_0545_T20R0201_00018
    ClearFlag FLAG_HGSS_SYS_MOMS_SAVINGS
_026D:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0275:
    Message msg_0545_T20R0201_00020
    @ HGSS: ScrCmd_795 1, 1
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 29, 0
    AddMenuEntryImm 30, 1
    AddMenuEntryImm 31, 2
    AddMenuEntryImm 32, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _02DF
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0335
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0398
    GoTo _03D1
    End
_02DF:
    @ HGSS: BankOrWalletIsFull 1, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _043A
    @ HGSS: CheckBankBalance VAR_SPECIAL_RESULT, 1
    CompareVar VAR_RESULT, 0
    GoToIf 1, _041C
    @ HGSS: BankTransaction 1, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_796
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _03E0
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0411
    ReleaseAll
    End
_0335:
    @ HGSS: BankOrWalletIsFull 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _042B
    @ HGSS: HasEnoughMoneyVar VAR_SPECIAL_RESULT, 1
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0389
    @ HGSS: BankTransaction 0, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_796
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _03FA
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0411
    ReleaseAll
    End
_0389:
    @ HGSS: ScrCmd_796
    Message msg_0545_T20R0201_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0398:
    Message msg_0545_T20R0201_00025
    ShowYesNoMenu VAR_RESULT
    @ HGSS: ScrCmd_796
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03C2
    BufferPlayerName 0
    Message msg_0545_T20R0201_00017
    SetFlag FLAG_HGSS_SYS_MOMS_SAVINGS
    GoTo _03C9
_03C2:
    Message msg_0545_T20R0201_00018
    ClearFlag FLAG_HGSS_SYS_MOMS_SAVINGS
_03C9:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03D1:
    @ HGSS: ScrCmd_796
    Message msg_0545_T20R0201_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E0:
    CloseMessage
    WaitTime 8, VAR_RESULT
    BufferPlayerName 0
    Message msg_0545_T20R0201_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03FA:
    CloseMessage
    WaitTime 8, VAR_RESULT
    Message msg_0545_T20R0201_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0411:
    Message msg_0545_T20R0201_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_041C:
    @ HGSS: ScrCmd_796
    Message msg_0545_T20R0201_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_042B:
    @ HGSS: ScrCmd_796
    Message msg_0545_T20R0201_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
_043A:
    @ HGSS: ScrCmd_796
    Message msg_0545_T20R0201_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0201_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
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
    .balign 4, 0
