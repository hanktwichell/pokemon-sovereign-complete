#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0622.h"


    ScriptEntry scr_seq_T28GYM0101_000
    ScriptEntry scr_seq_T28GYM0101_001
    ScriptEntryEnd
scr_seq_T28GYM0101_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _00E2
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T28GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_GLACIER, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _012E
    Message msg_0622_T28GYM0101_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_PRYCE_PRYCE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0144
    SetTrainerFlag TRAINER_HGSS_BOARDER_DEANDRE
    SetTrainerFlag TRAINER_HGSS_BOARDER_GERARDO
    SetTrainerFlag TRAINER_HGSS_SKIER_JILL
    SetTrainerFlag TRAINER_HGSS_SKIER_DIANA
    SetTrainerFlag TRAINER_HGSS_BOARDER_PATTON
    Message msg_0622_T28GYM0101_00001
    CompleteGiveBadge BADGE_ID_HGSS_GLACIER
    AddVar VAR_HGSS_MIDGAME_BADGES, 1
    IncrementTrainerScore TRAINER_SCORE_EVENT_BADGE_EARNED
    CompareVar VAR_HGSS_MIDGAME_BADGES, 3
    GoToIf 5, _014A
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 1
    BufferPlayerName 0
    Message msg_0622_T28GYM0101_00002
    PlayFanfare SEQ_ME_BADGE_sseq
    WaitFanfare
    Message msg_0622_T28GYM0101_00003
    SetVar VAR_0x8004, ITEM_TM07
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01A0
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM07_FROM_PRYCE
    Message msg_0622_T28GYM0101_00004
    Message msg_0622_T28GYM0101_00011
    BufferPlayerName 0
    Message msg_0622_T28GYM0101_00012
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_PRYCE
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E2:
    CompletePhoneGetRematch PHONE_CONTACT_PRYCE, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _01AA
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _01B0
    CompletePhoneCheckRegistered PHONE_CONTACT_PRYCE, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01B0
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _01B6
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    GoTo _01CD
_012E:
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _01CF
    Message msg_0622_T28GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0144:
    BlackOutFromBattle
    ReleaseAll
    End
_014A:
    BufferPlayerName 0
    Message msg_0622_T28GYM0101_00002
    PlayFanfare SEQ_ME_BADGE_sseq
    WaitFanfare
    Message msg_0622_T28GYM0101_00003
    SetVar VAR_0x8004, ITEM_TM07
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01A0
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM07_FROM_PRYCE
    Message msg_0622_T28GYM0101_00004
    Message msg_0622_T28GYM0101_00011
    BufferPlayerName 0
    Message msg_0622_T28GYM0101_00012
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_PRYCE
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A0:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_01AA:
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    End
_01B0:
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    End
_01B6:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0230
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    GoTo _01CD
_01CD:
    End
_01CF:
    Message msg_0622_T28GYM0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0247
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0252
    Message msg_0622_T28GYM0101_00007
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 40
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0622_T28GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0230:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _025D
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    GoTo _01CD
_0247:
    Message msg_0622_T28GYM0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0252:
    Message msg_0622_T28GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_025D:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _0274
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    GoTo _01CD
_0274:
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    End
    .balign 4, 0
