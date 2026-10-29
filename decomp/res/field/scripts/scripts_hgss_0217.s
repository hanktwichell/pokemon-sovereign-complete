#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0364.h"


    ScriptEntry scr_seq_R25R0101_000
    ScriptEntryEnd
scr_seq_R25R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_14E, _0020
    Message msg_0364_R25R0101_00000
    SetFlag FLAG_HGSS_UNK_14E
_0020:
    GetGameVersion VAR_0x8002
    CompareVar VAR_0x8002, 8
    GoToIf 5, _0037
    GoTo _00B1
_0037:
    CompareVar VAR_HGSS_UNK_412D, 0
    GoToIf 5, _004D
    Message msg_0364_R25R0101_00001
    GoTo _00AB
_004D:
    CompareVar VAR_HGSS_UNK_412D, 1
    GoToIf 5, _0063
    Message msg_0364_R25R0101_00002
    GoTo _00AB
_0063:
    CompareVar VAR_HGSS_UNK_412D, 2
    GoToIf 5, _0079
    Message msg_0364_R25R0101_00003
    GoTo _00AB
_0079:
    CompareVar VAR_HGSS_UNK_412D, 3
    GoToIf 5, _008F
    Message msg_0364_R25R0101_00004
    GoTo _00AB
_008F:
    CompareVar VAR_HGSS_UNK_412D, 4
    GoToIf 5, _00A5
    Message msg_0364_R25R0101_00005
    GoTo _00AB
_00A5:
    GoTo _0484
_00AB:
    GoTo _0125
_00B1:
    CompareVar VAR_HGSS_UNK_412D, 0
    GoToIf 5, _00C7
    Message msg_0364_R25R0101_00006
    GoTo _0125
_00C7:
    CompareVar VAR_HGSS_UNK_412D, 1
    GoToIf 5, _00DD
    Message msg_0364_R25R0101_00007
    GoTo _0125
_00DD:
    CompareVar VAR_HGSS_UNK_412D, 2
    GoToIf 5, _00F3
    Message msg_0364_R25R0101_00008
    GoTo _0125
_00F3:
    CompareVar VAR_HGSS_UNK_412D, 3
    GoToIf 5, _0109
    Message msg_0364_R25R0101_00009
    GoTo _0125
_0109:
    CompareVar VAR_HGSS_UNK_412D, 4
    GoToIf 5, _011F
    Message msg_0364_R25R0101_00010
    GoTo _0125
_011F:
    GoTo _0484
_0125:
    Message msg_0364_R25R0101_00011
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _048D
    Message msg_0364_R25R0101_00012
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: PartySelectUI
    @ HGSS: GetPartySelection VAR_SPECIAL_x8000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _048D
    GetPartyMonSpecies VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8002, 8
    GoToIf 5, _0188
    GoTo _02F0
_0188:
    SetVar VAR_0x8008, VAR_HGSS_UNK_412D
    CompareVar VAR_0x8008, 0
    GoToIf 1, _01C8
    CompareVar VAR_0x8008, 1
    GoToIf 1, _01E4
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0200
    CompareVar VAR_0x8008, 3
    GoToIf 1, _021C
    GoTo _0238
_01C8:
    CompareVar VAR_0x8001, 43
    GoToIf 1, _01DE
    Message msg_0364_R25R0101_00014
    GoTo _0490
_01DE:
    GoTo _024E
_01E4:
    CompareVar VAR_0x8001, 58
    GoToIf 1, _01FA
    Message msg_0364_R25R0101_00014
    GoTo _0490
_01FA:
    GoTo _024E
_0200:
    CompareVar VAR_0x8001, 39
    GoToIf 1, _0216
    Message msg_0364_R25R0101_00014
    GoTo _0490
_0216:
    GoTo _024E
_021C:
    CompareVar VAR_0x8001, 172
    GoToIf 1, _0232
    Message msg_0364_R25R0101_00014
    GoTo _0490
_0232:
    GoTo _024E
_0238:
    CompareVar VAR_0x8001, 183
    GoToIf 1, _024E
    Message msg_0364_R25R0101_00014
    GoTo _0490
_024E:
    BufferPartyMonSpecies 0, VAR_0x8000
    Message msg_0364_R25R0101_00015
    SetVar VAR_0x8008, VAR_HGSS_UNK_412D
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0296
    CompareVar VAR_0x8008, 1
    GoToIf 1, _02A8
    CompareVar VAR_0x8008, 2
    GoToIf 1, _02BA
    CompareVar VAR_0x8008, 3
    GoToIf 1, _02CC
    GoTo _02DE
_0296:
    SetVarFromValue VAR_0x8004, 85
    SetVarFromValue VAR_0x8005, 1
    GoTo _0452
_02A8:
    SetVarFromValue VAR_0x8004, 82
    SetVarFromValue VAR_0x8005, 1
    GoTo _0452
_02BA:
    SetVarFromValue VAR_0x8004, 229
    SetVarFromValue VAR_0x8005, 1
    GoTo _0452
_02CC:
    SetVarFromValue VAR_0x8004, 83
    SetVarFromValue VAR_0x8005, 1
    GoTo _0452
_02DE:
    SetVarFromValue VAR_0x8004, 84
    SetVarFromValue VAR_0x8005, 1
    GoTo _0452
_02F0:
    SetVar VAR_0x8008, VAR_HGSS_UNK_412D
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0330
    CompareVar VAR_0x8008, 1
    GoToIf 1, _034C
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0368
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0384
    GoTo _03A0
_0330:
    CompareVar VAR_0x8001, 108
    GoToIf 1, _0346
    Message msg_0364_R25R0101_00014
    GoTo _0490
_0346:
    GoTo _03B6
_034C:
    CompareVar VAR_0x8001, 43
    GoToIf 1, _0362
    Message msg_0364_R25R0101_00014
    GoTo _0490
_0362:
    GoTo _03B6
_0368:
    CompareVar VAR_0x8001, 120
    GoToIf 1, _037E
    Message msg_0364_R25R0101_00014
    GoTo _0490
_037E:
    GoTo _03B6
_0384:
    CompareVar VAR_0x8001, 37
    GoToIf 1, _039A
    Message msg_0364_R25R0101_00014
    GoTo _0490
_039A:
    GoTo _03B6
_03A0:
    CompareVar VAR_0x8001, 172
    GoToIf 1, _03B6
    Message msg_0364_R25R0101_00014
    GoTo _0490
_03B6:
    BufferPartyMonSpecies 0, VAR_0x8000
    Message msg_0364_R25R0101_00015
    SetVar VAR_0x8008, VAR_HGSS_UNK_412D
    CompareVar VAR_0x8008, 0
    GoToIf 1, _03FE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0410
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0422
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0434
    GoTo _0446
_03FE:
    SetVarFromValue VAR_0x8004, 229
    SetVarFromValue VAR_0x8005, 1
    GoTo _0452
_0410:
    SetVarFromValue VAR_0x8004, 85
    SetVarFromValue VAR_0x8005, 1
    GoTo _0452
_0422:
    SetVarFromValue VAR_0x8004, 84
    SetVarFromValue VAR_0x8005, 1
    GoTo _0452
_0434:
    SetVarFromValue VAR_0x8004, 82
    SetVarFromValue VAR_0x8005, 1
    GoTo _0452
_0446:
    SetVarFromValue VAR_0x8004, 83
    SetVarFromValue VAR_0x8005, 1
_0452:
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _047A
    Common_GiveItemQuantity
    AddVar VAR_HGSS_UNK_412D, 1
    Message msg_0364_R25R0101_00016
    GoTo _0490
_047A:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0484:
    Message msg_0364_R25R0101_00017
    GoTo _0490
_048D:
    Message msg_0364_R25R0101_00013
_0490:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
