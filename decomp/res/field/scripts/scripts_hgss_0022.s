#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0059.h"

#define obj_D17R1101_gsleader4 0

    ScriptEntry scr_seq_D17R1101_000
    ScriptEntry scr_seq_D17R1101_001
    ScriptEntry scr_seq_D17R1101_002
    ScriptEntry scr_seq_D17R1101_003
    ScriptEntry scr_seq_D17R1101_004
    ScriptEntryEnd
scr_seq_D17R1101_000:
    GoToIfUnset FLAG_HGSS_UNK_189, _00CC
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D17R1101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0118
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _0179
    Message msg_0059_D17R1101_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0182
    CompareVar VAR_RESULT, 1
    GoToIf 4, _01C5
    End
scr_seq_D17R1101_002:
    LockAll
    RemoveObject 1
    SetFlag FLAG_HGSS_SG_3FD2
    SetVar VAR_0x8004, ITEM_TM35
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
scr_seq_D17R1101_003:
    End
scr_seq_D17R1101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0059_D17R1101_00010
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _0258
    WaitMovement
    RemoveObject 2
    BufferPlayerName 0
    SetVar VAR_0x8004, ITEM_FLAME_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_00CC:
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _01D6
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _01D6
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01DC
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _01F7
    ClearFlag FLAG_HGSS_UNK_2CA
    GoTo _020E
_0118:
    Message msg_0059_D17R1101_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0210
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021B
    Message msg_0059_D17R1101_00006
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 20
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0059_D17R1101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0179:
    Message msg_0059_D17R1101_00004
    GoTo _0226
_0182:
    BufferPlayerName 0
    Message msg_0059_D17R1101_00001
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_MORTY
    Message msg_0059_D17R1101_00002
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_2CA
    RemoveObject obj_D17R1101_gsleader4
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_01C5:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0059_D17R1101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01D6:
    SetFlag FLAG_HGSS_UNK_2CA
    End
_01DC:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _024A
    ClearFlag FLAG_HGSS_UNK_2CA
    GoTo _0250
_01F7:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0252
    ClearFlag FLAG_HGSS_UNK_2CA
    GoTo _020E
_020E:
    End
_0210:
    Message msg_0059_D17R1101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_021B:
    Message msg_0059_D17R1101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0226:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0182
    CompareVar VAR_RESULT, 1
    GoToIf 4, _01C5
    End
_024A:
    SetFlag FLAG_HGSS_UNK_2CA
    End
_0250:
    End
_0252:
    SetFlag FLAG_HGSS_UNK_2CA
    End
    .balign 4, 0
_0258:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
