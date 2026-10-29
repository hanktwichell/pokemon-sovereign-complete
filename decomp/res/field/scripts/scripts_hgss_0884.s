#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0580.h"


    ScriptEntry scr_seq_T24R0801_000
    ScriptEntry scr_seq_T24R0801_001
    ScriptEntryEnd
scr_seq_T24R0801_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_MET_MOVE_MANIAC, _011E
    CheckItem ITEM_HEART_SCALE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _012D
    Message msg_0580_T24R0801_00010
    Message msg_0580_T24R0801_00012
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8005
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8005, 255
    GoToIf 1, _012D
    GetPartyMonSpecies VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0138
    @ HGSS: ScrCmd_466 VAR_SPECIAL_RESULT, VAR_SPECIAL_x8005
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0143
    Message msg_0580_T24R0801_00013
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: MoveRelearnerInit VAR_SPECIAL_x8005
    @ HGSS: MoveRelearnerGetResult VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _012D
    RemoveItem ITEM_HEART_SCALE, 1, VAR_RESULT
    BufferPlayerName 3
    Message msg_0580_T24R0801_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T24R0801_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_MAP_LOCAL_0x01, _00F7
    Message msg_0580_T24R0801_00000
    SetFlag FLAG_MAP_LOCAL_0x01
    GoTo _00F7
_00F7:
    Message msg_0580_T24R0801_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0173
    CompareVar VAR_RESULT, 1
    GoToIf 1, _017E
    End
_011E:
    Message msg_0580_T24R0801_00009
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_MET_MOVE_MANIAC
    End
_012D:
    Message msg_0580_T24R0801_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0138:
    Message msg_0580_T24R0801_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0143:
    Message msg_0580_T24R0801_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
    Message msg_0580_T24R0801_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
    Message msg_0580_T24R0801_00004
    GoTo _016B
    Message msg_0580_T24R0801_00002
    GoTo _016B
_016B:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0173:
    Message msg_0580_T24R0801_00002
    CloseMessage
    GoTo _0189
_017E:
    Message msg_0580_T24R0801_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0189:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8002
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8002, 255
    GoToIf 1, _017E
    GetPartyMonSpecies VAR_0x8002, VAR_0x8001
    CompareVar VAR_0x8001, 0
    GoToIf 1, _023E
    GetPartyMonMoveCount VAR_RESULT, VAR_0x8002
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0249
    Message msg_0580_T24R0801_00006
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_394 VAR_SPECIAL_x8002
    @ HGSS: ScrCmd_395 VAR_SPECIAL_x8001
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8001, 255
    GoToIf 1, _0173
    @ HGSS: BufferPartyMonMoveName 0, VAR_SPECIAL_x8002, VAR_SPECIAL_x8001
    Message msg_0580_T24R0801_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0254
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0173
    End
_023E:
    Message msg_0580_T24R0801_00005
    CloseMessage
    GoTo _0189
_0249:
    Message msg_0580_T24R0801_00004
    CloseMessage
    GoTo _0189
_0254:
    ClearPartyMonMoveSlot VAR_0x8002, VAR_0x8001
    WaitFanfare
    Message msg_0580_T24R0801_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
