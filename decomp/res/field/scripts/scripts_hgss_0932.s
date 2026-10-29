#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0622.h"


    ScriptEntry scr_seq_T28GYM0101_000
    ScriptEntry scr_seq_T28GYM0101_001
    ScriptEntryEnd
scr_seq_T28GYM0101_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _001B
    ClearFlag FLAG_HGSS_UNK_189
    End
_001B:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_PRYCE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00B8
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _00B2
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_PRYCE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00B2
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0067
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    GoTo _00B0
_0067:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _007E
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    GoTo _00B0
_007E:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _0095
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    GoTo _00B0
_0095:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _00AC
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    GoTo _00B0
_00AC:
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
_00B0:
    End
_00B2:
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    End
_00B8:
    SetFlag FLAG_HGSS_HIDE_MAHOGANY_GYM_PRYCE
    End
scr_seq_T28GYM0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0178
    Message msg_0622_T28GYM0101_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_PRYCE_PRYCE, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0172
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    SetTrainerFlag TRAINER_NONE
    Message msg_0622_T28GYM0101_00001
    AddVar VAR_HGSS_MIDGAME_BADGES, 1
    @ HGSS: AddSpecialGameStat SCORE_EVENT_BADGE_GET
    CompareVar VAR_HGSS_MIDGAME_BADGES, 3
    GoToIf 5, _012F
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 1
_012F:
    BufferPlayerName 0
    Message msg_0622_T28GYM0101_00002
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0622_T28GYM0101_00003
    SetVar VAR_0x8004, ITEM_TM07
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _018E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM07_FROM_PRYCE
    Message msg_0622_T28GYM0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0172:
    BlackOutFromBattle
    ReleaseAll
    End
_0178:
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0198
    Message msg_0622_T28GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_018E:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0198:
    Message msg_0622_T28GYM0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01F9
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0204
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
_01F9:
    Message msg_0622_T28GYM0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0204:
    Message msg_0622_T28GYM0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
