#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0059.h"

#define obj_D17R1101_gsleader4 0

    ScriptEntry scr_seq_D17R1101_000
    ScriptEntry scr_seq_D17R1101_001
    ScriptEntryEnd
scr_seq_D17R1101_000:
    GoToIfUnset FLAG_HGSS_UNK_189, _001B
    ClearFlag FLAG_HGSS_UNK_189
    End
_001B:
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _00A5
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00A5
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0084
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0067
    ClearFlag FLAG_HGSS_UNK_2CA
    GoTo _0082
_0067:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _007E
    ClearFlag FLAG_HGSS_UNK_2CA
    GoTo _0082
_007E:
    SetFlag FLAG_HGSS_UNK_2CA
_0082:
    End
_0084:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _009F
    ClearFlag FLAG_HGSS_UNK_2CA
    GoTo _00A3
_009F:
    SetFlag FLAG_HGSS_UNK_2CA
_00A3:
    End
_00A5:
    SetFlag FLAG_HGSS_UNK_2CA
    End
scr_seq_D17R1101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_MORTY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0159
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _014E
    Message msg_0059_D17R1101_00000
_00D6:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00FA
    CompareVar VAR_RESULT, 1
    GoToIf 4, _013D
    End
_00FA:
    BufferPlayerName 0
    Message msg_0059_D17R1101_00001
    PlayFanfare SEQ_FANFA4_sseq
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
_013D:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0059_D17R1101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_014E:
    Message msg_0059_D17R1101_00004
    GoTo _00D6
    End
_0159:
    Message msg_0059_D17R1101_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01BA
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01C5
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
_01BA:
    Message msg_0059_D17R1101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01C5:
    Message msg_0059_D17R1101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
