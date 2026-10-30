#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0480.h"


    ScriptEntry scr_seq_T05R0401_000
    ScriptEntryEnd
scr_seq_T05R0401_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0480_T05R0401_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _002E
    GoTo _00B3
    End
_002E:
    Message msg_0480_T05R0401_00001
    WaitABPress
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _00B3
    SetVarFromVar VAR_0x8005, VAR_RESULT
    GetPartyMonSpecies VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00BE
    CompletePartyMonIsNotMine VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00C9
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0480_T05R0401_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00D9
    GoTo _00B3
    End
_00B3:
    Message msg_0480_T05R0401_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00BE:
    Message msg_0480_T05R0401_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00C9:
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0480_T05R0401_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00D9:
    Message msg_0480_T05R0401_00003
    CloseMessage
    SetVarFromValue VAR_RESULT, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_0x8005, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 1
    GoToIf 1, _011F
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0480_T05R0401_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_011F:
    BufferPartyMonNickname 0, VAR_0x8005
    Message msg_0480_T05R0401_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
