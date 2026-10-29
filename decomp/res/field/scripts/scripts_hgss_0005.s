#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0047.h"

#define obj_D01R0101_gsleader14 1

    ScriptEntry scr_seq_D01R0101_000
    ScriptEntry scr_seq_D01R0101_001
    ScriptEntry scr_seq_D01R0101_002
    ScriptEntryEnd
scr_seq_D01R0101_000:
    GoToIfUnset FLAG_HGSS_UNK_189, _001F
    ClearFlag FLAG_HGSS_UNK_189
    End
_001F:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BROCK, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _009E
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _004D
    GoTo _0102
    End
_004D:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _0068
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _009C
_0068:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _007F
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _009C
_007F:
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _0096
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _009C
_0096:
    GoTo _0102
_009C:
    End
_009E:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BROCK, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0102
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _00CC
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _0100
_00CC:
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _00E3
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _0100
_00E3:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _00FA
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _0100
_00FA:
    GoTo _0102
_0100:
    End
_0102:
    SetFlag FLAG_HGSS_UNK_262
    End
scr_seq_D01R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BROCK, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01B6
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 4, _01AB
    Message msg_0047_D01R0101_00001
_0133:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0157
    CompareVar VAR_RESULT, 1
    GoToIf 4, _019A
    End
_0157:
    BufferPlayerName 0
    Message msg_0047_D01R0101_00002
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BROCK
    Message msg_0047_D01R0101_00003
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_262
    RemoveObject obj_D01R0101_gsleader14
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_019A:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    Message msg_0047_D01R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AB:
    Message msg_0047_D01R0101_00005
    GoTo _0133
    End
_01B6:
    GetDayOfWeek VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 5, _01D8
    GoToIfUnset FLAG_HGSS_TRADE_BROCK_BONSLY_RHYHORN, _0292
    GoTo _020E
_01D8:
    CompareVar VAR_0x8004, 4
    GoToIf 5, _01F6
    GoToIfUnset FLAG_HGSS_TRADE_BROCK_BONSLY_RHYHORN, _0292
    GoTo _020E
_01F6:
    CompareVar VAR_0x8004, 6
    GoToIf 5, _020E
    GoToIfUnset FLAG_HGSS_TRADE_BROCK_BONSLY_RHYHORN, _0292
_020E:
    CompareVar VAR_MAP_LOCAL_0x00, 55
    GoToIf 1, _0357
    Message msg_0047_D01R0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _027C
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0287
    Message msg_0047_D01R0101_00007
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 86
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0047_D01R0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_027C:
    Message msg_0047_D01R0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0287:
    Message msg_0047_D01R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0292:
    CompareVar VAR_MAP_LOCAL_0x00, 111
    GoToIf 5, _02A8
    Message msg_0047_D01R0101_00015
    GoTo _02AF
_02A8:
    BufferPlayerName 0
    MessageGendered msg_0047_D01R0101_00011, msg_0047_D01R0101_00012
_02AF:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0346
    Message msg_0047_D01R0101_00013
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_566
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0346
    @ HGSS: LoadNPCTrade 11
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    @ HGSS: NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _0339
    @ HGSS: NPCTradeExec VAR_SPECIAL_x8004
    @ HGSS: NPCTradeEnd
    @ HGSS: SetMonMove VAR_SPECIAL_x8004, 0, MOVE_THUNDER_FANG
    SetFlag FLAG_HGSS_TRADE_BROCK_BONSLY_RHYHORN
    SetVarFromValue VAR_MAP_LOCAL_0x00, 55
    Message msg_0047_D01R0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0339:
    @ HGSS: NPCTradeEnd
    Message msg_0047_D01R0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0346:
    Message msg_0047_D01R0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_MAP_LOCAL_0x00, 111
    End
_0357:
    Message msg_0047_D01R0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D01R0101_002:
    NPCMessage msg_0047_D01R0101_00000
    End
    .balign 4, 0
