#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0047.h"

#define obj_D01R0101_gsleader14 1

    ScriptEntry scr_seq_D01R0101_000
    ScriptEntry scr_seq_D01R0101_001
    ScriptEntry scr_seq_D01R0101_002
    ScriptEntry scr_seq_D01R0101_003
    ScriptEntryEnd
scr_seq_D01R0101_000:
    GoToIfUnset FLAG_HGSS_UNK_189, _00A1
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D01R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompletePhoneCheckRegistered PHONE_CONTACT_BROCK, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00CD
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 4, _00EF
    Message msg_0047_D01R0101_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00F8
    CompareVar VAR_RESULT, 1
    GoToIf 4, _013B
    End
scr_seq_D01R0101_002:
    NPCMessage msg_0047_D01R0101_00000
    End
scr_seq_D01R0101_003:
    LockAll
    RemoveObject 4
    SetVar VAR_0x8004, ITEM_EARTH_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_00A1:
    CompletePhoneCheckRegistered PHONE_CONTACT_BROCK, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _014C
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _017A
    GoTo _0195
_00CD:
    GetDayOfWeek VAR_0x8004
    CompareVar VAR_0x8004, 1
    GoToIf 5, _019B
    GoToIfUnset FLAG_HGSS_TRADE_BROCK_BONSLY_RHYHORN, _01B9
    GoTo _01CF
_00EF:
    Message msg_0047_D01R0101_00005
    GoTo _023D
_00F8:
    BufferPlayerName 0
    Message msg_0047_D01R0101_00002
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_BROCK
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
_013B:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    Message msg_0047_D01R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_014C:
    CompletePhoneGetRematch PHONE_CONTACT_BROCK, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0195
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _0261
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _0278
_017A:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _027A
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _0291
_0195:
    SetFlag FLAG_HGSS_UNK_262
    End
_019B:
    CompareVar VAR_0x8004, 4
    GoToIf 5, _0293
    GoToIfUnset FLAG_HGSS_TRADE_BROCK_BONSLY_RHYHORN, _01B9
    GoTo _01CF
_01B9:
    CompareVar VAR_MAP_LOCAL_0x00, 111
    GoToIf 5, _0319
    Message msg_0047_D01R0101_00015
    GoTo _03DF
_01CF:
    CompareVar VAR_MAP_LOCAL_0x00, 55
    GoToIf 1, _049E
    Message msg_0047_D01R0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04A9
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04B4
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
_023D:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00F8
    CompareVar VAR_RESULT, 1
    GoToIf 4, _013B
    End
_0261:
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _04BF
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _0278
_0278:
    End
_027A:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _04D6
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _0291
_0291:
    End
_0293:
    CompareVar VAR_0x8004, 6
    GoToIf 5, _01CF
    GoToIfUnset FLAG_HGSS_TRADE_BROCK_BONSLY_RHYHORN, _01B9
    CompareVar VAR_MAP_LOCAL_0x00, 55
    GoToIf 1, _049E
    Message msg_0047_D01R0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04A9
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04B4
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
_0319:
    BufferPlayerName 0
    MessageGendered msg_0047_D01R0101_00011, msg_0047_D01R0101_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04ED
    Message msg_0047_D01R0101_00013
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _04ED
    InitNPCTrade NPC_TRADE_HGSS_HORNLETTE_RHYPERIOR
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _04FE
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_THUNDER_FANG
    SetFlag FLAG_HGSS_TRADE_BROCK_BONSLY_RHYHORN
    SetVarFromValue VAR_MAP_LOCAL_0x00, 55
    Message msg_0047_D01R0101_00016
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0047_D01R0101_00019
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_03DF:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04ED
    Message msg_0047_D01R0101_00013
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _04ED
    InitNPCTrade NPC_TRADE_HGSS_HORNLETTE_RHYPERIOR
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _04FE
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_FISSURE
    SetFlag FLAG_HGSS_TRADE_BROCK_BONSLY_RHYHORN
    SetVarFromValue VAR_MAP_LOCAL_0x00, 55
    Message msg_0047_D01R0101_00016
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0047_D01R0101_00019
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_049E:
    Message msg_0047_D01R0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04A9:
    Message msg_0047_D01R0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04B4:
    Message msg_0047_D01R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04BF:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _050B
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _0278
_04D6:
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _0511
    ClearFlag FLAG_HGSS_UNK_262
    GoTo _0291
_04ED:
    Message msg_0047_D01R0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_MAP_LOCAL_0x00, 111
    End
_04FE:
    FinishNPCTrade
    Message msg_0047_D01R0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_050B:
    GoTo _0195
_0511:
    GoTo _0195
    .balign 4, 0
