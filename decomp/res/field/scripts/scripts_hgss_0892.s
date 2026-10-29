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
    GoToIfSet FLAG_HGSS_GOT_EEVEE_FROM_BILL, _00E9
    BufferPlayerName 0
    Message msg_0586_T25R0401_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _004B
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00D3
    End
_004B:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _00DE
    Message msg_0586_T25R0401_00001
    @ HGSS: GiveMon SPECIES_EEVEE, 5, 0, 0, 0, VAR_SPECIAL_RESULT
    SetFlag FLAG_HGSS_GOT_EEVEE_FROM_BILL
    BufferPlayerName 0
    Message msg_0586_T25R0401_00002
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0586_T25R0401_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00A0
    CompareVar VAR_RESULT, 1
    GoToIf 4, _00C6
_00A0:
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_SPECIAL_x8005, VAR_TEMP_x4000
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_00C6:
    Message msg_0586_T25R0401_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00D3:
    Message msg_0586_T25R0401_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00DE:
    Message msg_0586_T25R0401_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E9:
    Message msg_0586_T25R0401_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0401_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_410D, 1
    GoToIf 1, _0114
    Message msg_0586_T25R0401_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0114:
    Message msg_0586_T25R0401_00010
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
    GoToIf 1, _019C
    CompareVar VAR_HGSS_UNK_410D, 1
    GoToIf 1, _0152
    Message msg_0586_T25R0401_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0152:
    Message msg_0586_T25R0401_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0179
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0191
    End
_0179:
    BufferPlayerName 0
    Message msg_0586_T25R0401_00013
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BILL
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0191:
    Message msg_0586_T25R0401_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_019C:
    Message msg_0586_T25R0401_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
