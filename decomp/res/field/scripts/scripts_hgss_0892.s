#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0586.h"


    ScriptEntry scr_seq_T25R0401_000
    ScriptEntry scr_seq_T25R0401_001
    ScriptEntry scr_seq_T25R0401_002
    ScriptEntryEnd
scr_seq_T25R0401_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_EEVEE_FROM_BILL, _009E
    BufferPlayerName 0
    Message msg_0586_T25R0401_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00A9
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0131
    End
scr_seq_T25R0401_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_410D, 1
    GoToIf 1, _013C
    Message msg_0586_T25R0401_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0401_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BILL, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0147
    CompareVar VAR_HGSS_UNK_410D, 1
    GoToIf 1, _0152
    Message msg_0586_T25R0401_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_009E:
    Message msg_0586_T25R0401_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A9:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _0179
    Message msg_0586_T25R0401_00001
    GivePokemon SPECIES_CASTFORM, 25, 243, VAR_RESULT
    SetFlag FLAG_HGSS_GOT_EEVEE_FROM_BILL
    BufferPlayerName 0
    Message msg_0586_T25R0401_00002
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0586_T25R0401_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0184
    CompareVar VAR_RESULT, 1
    GoToIf 4, _01B7
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_SPECIAL_x8005, VAR_TEMP_x4000
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0586_T25R0401_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0131:
    Message msg_0586_T25R0401_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013C:
    Message msg_0586_T25R0401_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0147:
    Message msg_0586_T25R0401_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0152:
    Message msg_0586_T25R0401_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01C4
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01DC
    End
_0179:
    Message msg_0586_T25R0401_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0184:
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_SPECIAL_x8005, VAR_TEMP_x4000
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0586_T25R0401_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01B7:
    Message msg_0586_T25R0401_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01C4:
    BufferPlayerName 0
    Message msg_0586_T25R0401_00013
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BILL
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DC:
    Message msg_0586_T25R0401_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
