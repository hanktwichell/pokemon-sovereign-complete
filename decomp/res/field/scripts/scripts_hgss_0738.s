#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0449.h"


    ScriptEntry scr_seq_T01R0201_000
    ScriptEntryEnd
scr_seq_T01R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4122, 7
    GoToIf 1, _003B
_001F:
    GetHour VAR_RESULT
    CompareVar VAR_RESULT, 15
    GoToIf 1, _0056
    Message msg_0449_T01R0201_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_003B:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BLUE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _001F
    GoTo _015D
    End
_0056:
    GoToIfSet FLAG_HGSS_UNK_AA8, _0152
    Message msg_0449_T01R0201_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0147
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0099
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00A7
    End
_0099:
    SetVarFromValue VAR_0x8004, 0
    GoTo _00F0
    End
_00A7:
    Message msg_0449_T01R0201_00002
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8004
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8004, 255
    GoToIf 1, _0147
    GetPartyMonSpecies VAR_0x8004, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _013C
_00F0:
    BufferPartyMonNickname 0, VAR_0x8004
    PlaySE SEQ_SE_DP_FW367_sseq
    Message msg_0449_T01R0201_00003
    WaitSE SEQ_SE_DP_FW367_sseq
    WaitTime 15, VAR_RESULT
    IncreasePartyMonFriendship 10, VAR_0x8004
    CompleteMonAddContestValue VAR_0x8004, 1, 32
    CompleteMonAddContestValue VAR_0x8004, 5, 22
    CompareVar VAR_HGSS_UNK_4122, 7
    GoToIf 1, _012D
    AddVar VAR_HGSS_UNK_4122, 1
_012D:
    SetFlag FLAG_HGSS_UNK_AA8
    Message msg_0449_T01R0201_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013C:
    Message msg_0449_T01R0201_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0147:
    Message msg_0449_T01R0201_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0152:
    Message msg_0449_T01R0201_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_015D:
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 4, _01AE
    Message msg_0449_T01R0201_00008
_016D:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _019D
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BLUE
    BufferPlayerName 0
    Message msg_0449_T01R0201_00009
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    Message msg_0449_T01R0201_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_019D:
    Message msg_0449_T01R0201_00011
    WaitButton
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    ReleaseAll
    End
_01AE:
    Message msg_0449_T01R0201_00012
    GoTo _016D
    End
    .balign 4, 0
