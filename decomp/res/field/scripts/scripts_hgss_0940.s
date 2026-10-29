#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0628.h"


    ScriptEntry scr_seq_T29R0201_000
    ScriptEntryEnd
scr_seq_T29R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_ROCKET_HIDEOUT_CLEARED, _003A
    GoToIfSet FLAG_HGSS_UNK_0C8, _002F
    Message msg_0628_T29R0201_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_002F:
    Message msg_0628_T29R0201_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_003A:
    @ HGSS: ScriptOverlayCmd 0, 0
    @ HGSS: PlayerHasSpecies VAR_SPECIAL_RESULT, SPECIES_MAGIKARP
    CompareVar VAR_RESULT, 0
    GoToIf 5, _005A
    Message msg_0628_T29R0201_00002
    GoTo _0146
_005A:
    Message msg_0628_T29R0201_00003
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: PartySelectUI
    @ HGSS: GetPartySelection VAR_SPECIAL_x8002
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8002, 255
    GoToIf 5, _0095
    Message msg_0628_T29R0201_00010
    GoTo _0146
_0095:
    GetPartyMonSpecies VAR_0x8002, VAR_0x8001
    CompareVar VAR_0x8001, 129
    GoToIf 1, _00B1
    Message msg_0628_T29R0201_00008
    GoTo _0146
_00B1:
    @ HGSS: SizeRecordCompare VAR_SPECIAL_RESULT, VAR_SPECIAL_x8002
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00E3
    @ HGSS: BufferMonSize 0, 1, VAR_SPECIAL_x8002
    @ HGSS: BufferRecordSize 2, 3, SPECIES_MAGIKARP
    Message msg_0628_T29R0201_00007
    GoTo _0146
_00DD:
    GoTo _0101
_00E3:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0101
    @ HGSS: BufferRecordSize 0, 1, SPECIES_MAGIKARP
    Message msg_0628_T29R0201_00006
    GoTo _0146
_0101:
    @ HGSS: BufferMonSize 0, 1, VAR_SPECIAL_x8002
    Message msg_0628_T29R0201_00004
    SetVarFromValue VAR_0x8004, 38
    SetVarFromValue VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0137
    Common_MessageBagIsFull
    GoTo _0148
_0137:
    Common_GiveItemQuantity
    @ HGSS: SizeRecordUpdate VAR_SPECIAL_x8002
    SetFlag FLAG_HGSS_UNK_139
    Message msg_0628_T29R0201_00005
_0146:
    WaitButton
_0148:
    CloseMessage
    @ HGSS: ScriptOverlayCmd 0, 1
    ReleaseAll
    End
    .balign 4, 0
