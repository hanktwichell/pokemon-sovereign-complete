#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0132.h"

#define obj_D46R0101_gsleader2 0

    ScriptEntry scr_seq_D46R0101_000
    ScriptEntry scr_seq_D46R0101_001
    ScriptEntryEnd
scr_seq_D46R0101_001:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BUGSY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0047
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0030
    GoTo _0047
    End
_0030:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0047
    ClearFlag FLAG_HGSS_UNK_263
    End
_0047:
    SetFlag FLAG_HGSS_UNK_263
    End
scr_seq_D46R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _00DD
    Message msg_0132_D46R0101_00000
_0065:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0089
    CompareVar VAR_RESULT, 1
    GoToIf 4, _00CC
    End
_0089:
    BufferPlayerName 0
    Message msg_0132_D46R0101_00001
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BUGSY
    Message msg_0132_D46R0101_00002
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_263
    RemoveObject obj_D46R0101_gsleader2
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_00CC:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0132_D46R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00DD:
    Message msg_0132_D46R0101_00004
    GoTo _0065
    End
    .balign 4, 0
