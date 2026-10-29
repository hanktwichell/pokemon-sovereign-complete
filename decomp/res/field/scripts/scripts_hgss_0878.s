#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0575.h"


    ScriptEntry scr_seq_T24PC0101_000
    ScriptEntry scr_seq_T24PC0101_001
    ScriptEntry scr_seq_T24PC0101_002
    ScriptEntry scr_seq_T24PC0101_003
    ScriptEntryEnd
scr_seq_T24PC0101_000:
    SetVarFromValue VAR_0x8007, 3
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T24PC0101_001:
    NPCMessage msg_0575_T24PC0101_00000
    End
scr_seq_T24PC0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CountPCEmptySpace VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 540
    GoToIf 5, _0056
    GoTo _005C
_0050:
    GoTo _005C
_0056:
    GoTo _00E4
_005C:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0079
    GoTo _007F
_0073:
    GoTo _007F
_0079:
    GoTo _00E4
_007F:
    Message msg_0575_T24PC0101_00004
    BufferPlayerName 0
    Message msg_0575_T24PC0101_00005
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    @ HGSS: GiveMon SPECIES_TENTACOOL, 15, 0, 0, 0, VAR_SPECIAL_RESULT
    Message msg_0575_T24PC0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00BC
    CloseMessage
    GoTo _00E0
_00BC:
    CloseMessage
    @ HGSS: ScrCmd_815 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput 1, VAR_SPECIAL_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_00E0:
    ReleaseAll
    End
_00E4:
    Message msg_0575_T24PC0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T24PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0115
    Message msg_0575_T24PC0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0115:
    BufferPlayerName 0
    Message msg_0575_T24PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
