#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0597.h"

#define obj_T25R1006_gsleader3 3

    ScriptEntry scr_seq_T25R1006_000
    ScriptEntry scr_seq_T25R1006_001
    ScriptEntry scr_seq_T25R1006_002
    ScriptEntry scr_seq_T25R1006_003
    ScriptEntry scr_seq_T25R1006_004
    ScriptEntry scr_seq_T25R1006_005
    ScriptEntry scr_seq_T25R1006_006
    ScriptEntry scr_seq_T25R1006_007
    ScriptEntryEnd
scr_seq_T25R1006_006:
    GoToIfUnset FLAG_HGSS_UNK_189, _0033
    ClearFlag FLAG_HGSS_UNK_189
    End
_0033:
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _011D
    CompletePhoneGetRematch PHONE_CONTACT_WHITNEY, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _011D
    CompletePhoneCheckRegistered PHONE_CONTACT_WHITNEY, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00CC
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _007F
    ClearFlag FLAG_HGSS_UNK_26F
    GoTo _00CA
_007F:
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _0096
    ClearFlag FLAG_HGSS_UNK_26F
    GoTo _00CA
_0096:
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _00AD
    ClearFlag FLAG_HGSS_UNK_26F
    GoTo _00CA
_00AD:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _00C4
    ClearFlag FLAG_HGSS_UNK_26F
    GoTo _00CA
_00C4:
    GoTo _011D
_00CA:
    End
_00CC:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _00E7
    ClearFlag FLAG_HGSS_UNK_26F
    GoTo _011B
_00E7:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _00FE
    ClearFlag FLAG_HGSS_UNK_26F
    GoTo _011B
_00FE:
    CompareVar VAR_MAP_LOCAL_0x00, 20
    GoToIf 5, _0115
    ClearFlag FLAG_HGSS_UNK_26F
    GoTo _011B
_0115:
    GoTo _011D
_011B:
    End
_011D:
    SetFlag FLAG_HGSS_UNK_26F
    End
scr_seq_T25R1006_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ShowMoney 20, 2
    Message msg_0597_T25R1006_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0156
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04A3
_0156:
    CheckMoney VAR_RESULT, 300
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04D2
    RemoveMoney 300
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    Message msg_0597_T25R1006_00011
    GetRandom VAR_RESULT, 100
    CompareVar VAR_RESULT, 40
    GoToIf 4, _01AD
    CompareVar VAR_RESULT, 4
    GoToIf 4, _02B5
    CompareVar VAR_RESULT, 0
    GoToIf 4, _03AC
    End
_01AD:
    BufferNumber 0, 3
    Message msg_0597_T25R1006_00012
    GetRandom VAR_RESULT, 70
    CompareVar VAR_RESULT, 60
    GoToIf 4, _021C
    CompareVar VAR_RESULT, 50
    GoToIf 4, _022E
    CompareVar VAR_RESULT, 40
    GoToIf 4, _0240
    CompareVar VAR_RESULT, 30
    GoToIf 4, _0252
    CompareVar VAR_RESULT, 20
    GoToIf 4, _0264
    CompareVar VAR_RESULT, 10
    GoToIf 4, _0276
    CompareVar VAR_RESULT, 0
    GoToIf 4, _0288
    End
_021C:
    SetVarFromValue VAR_0x8004, ITEM_ORAN_BERRY
    SetVarFromValue VAR_0x8005, 1
    GoTo _0294
_022E:
    SetVarFromValue VAR_0x8004, ITEM_CHESTO_BERRY
    SetVarFromValue VAR_0x8005, 1
    GoTo _0294
_0240:
    SetVarFromValue VAR_0x8004, ITEM_PECHA_BERRY
    SetVarFromValue VAR_0x8005, 1
    GoTo _0294
_0252:
    SetVarFromValue VAR_0x8004, ITEM_RAWST_BERRY
    SetVarFromValue VAR_0x8005, 1
    GoTo _0294
_0264:
    SetVarFromValue VAR_0x8004, ITEM_ASPEAR_BERRY
    SetVarFromValue VAR_0x8005, 1
    GoTo _0294
_0276:
    SetVarFromValue VAR_0x8004, ITEM_PERSIM_BERRY
    SetVarFromValue VAR_0x8005, 1
    GoTo _0294
_0288:
    SetVarFromValue VAR_0x8004, ITEM_CHERI_BERRY
    SetVarFromValue VAR_0x8005, 1
_0294:
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04B0
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    HideMoney
    ReleaseAll
    End
_02B5:
    BufferNumber 0, 2
    Message msg_0597_T25R1006_00012
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _02E4
    SetVarFromValue VAR_0x8004, ITEM_LUXURY_BALL
    SetVarFromValue VAR_0x8005, 1
    GoTo _038B
_02E4:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0303
    SetVarFromValue VAR_0x8004, ITEM_NEST_BALL
    SetVarFromValue VAR_0x8005, 1
    GoTo _038B
_0303:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0322
    SetVarFromValue VAR_0x8004, ITEM_REPEAT_BALL
    SetVarFromValue VAR_0x8005, 1
    GoTo _038B
_0322:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0341
    SetVarFromValue VAR_0x8004, ITEM_NET_BALL
    SetVarFromValue VAR_0x8005, 1
    GoTo _038B
_0341:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0360
    SetVarFromValue VAR_0x8004, ITEM_QUICK_BALL
    SetVarFromValue VAR_0x8005, 1
    GoTo _038B
_0360:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _037F
    SetVarFromValue VAR_0x8004, ITEM_DUSK_BALL
    SetVarFromValue VAR_0x8005, 1
    GoTo _038B
_037F:
    SetVarFromValue VAR_0x8004, ITEM_TIMER_BALL
    SetVarFromValue VAR_0x8005, 1
_038B:
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04B0
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    HideMoney
    ReleaseAll
    End
_03AC:
    BufferNumber 0, 1
    Message msg_0597_T25R1006_00012
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _03DB
    SetVarFromValue VAR_0x8004, ITEM_TM02
    SetVarFromValue VAR_0x8005, 1
    GoTo _0482
_03DB:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _03FA
    SetVarFromValue VAR_0x8004, ITEM_TM65
    SetVarFromValue VAR_0x8005, 1
    GoTo _0482
_03FA:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0419
    SetVarFromValue VAR_0x8004, ITEM_TM91
    SetVarFromValue VAR_0x8005, 1
    GoTo _0482
_0419:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0438
    SetVarFromValue VAR_0x8004, ITEM_TM57
    SetVarFromValue VAR_0x8005, 1
    GoTo _0482
_0438:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0457
    SetVarFromValue VAR_0x8004, ITEM_TM60
    SetVarFromValue VAR_0x8005, 1
    GoTo _0482
_0457:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0476
    SetVarFromValue VAR_0x8004, ITEM_TM42
    SetVarFromValue VAR_0x8005, 1
    GoTo _0482
_0476:
    SetVarFromValue VAR_0x8004, ITEM_TM62
    SetVarFromValue VAR_0x8005, 1
_0482:
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04B0
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    HideMoney
    ReleaseAll
    End
_04A3:
    Message msg_0597_T25R1006_00014
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_04B0:
    Message msg_0597_T25R1006_00015
    CloseMessage
    GiveMoney 300
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    Message msg_0597_T25R1006_00017
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
_04D2:
    Message msg_0597_T25R1006_00016
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
scr_seq_T25R1006_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0501
    Message msg_0597_T25R1006_00018
    GoTo _0572
_0501:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0517
    Message msg_0597_T25R1006_00019
    GoTo _0572
_0517:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _052D
    Message msg_0597_T25R1006_00020
    GoTo _0572
_052D:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0543
    Message msg_0597_T25R1006_00021
    GoTo _0572
_0543:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0559
    Message msg_0597_T25R1006_00022
    GoTo _0572
_0559:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _056F
    Message msg_0597_T25R1006_00023
    GoTo _0572
_056F:
    Message msg_0597_T25R1006_00024
_0572:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1006_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0598
    Message msg_0597_T25R1006_00003
    GoTo _059B
_0598:
    Message msg_0597_T25R1006_00002
_059B:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1006_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _05C1
    Message msg_0597_T25R1006_00001
    GoTo _05C4
_05C1:
    Message msg_0597_T25R1006_00000
_05C4:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1006_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompletePhoneCheckRegistered PHONE_CONTACT_WHITNEY, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _067A
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _066F
    Message msg_0597_T25R1006_00025
_05F7:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _061B
    CompareVar VAR_RESULT, 1
    GoToIf 4, _065E
    End
_061B:
    BufferPlayerName 0
    Message msg_0597_T25R1006_00026
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_WHITNEY
    Message msg_0597_T25R1006_00027
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_26F
    RemoveObject obj_T25R1006_gsleader3
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_065E:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0597_T25R1006_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
_066F:
    Message msg_0597_T25R1006_00029
    GoTo _05F7
    End
_067A:
    Message msg_0597_T25R1006_00030
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06DB
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06E6
    Message msg_0597_T25R1006_00031
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 15
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0597_T25R1006_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06DB:
    Message msg_0597_T25R1006_00033
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06E6:
    Message msg_0597_T25R1006_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1006_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0597_T25R1006_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1006_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0597_T25R1006_00005
    ShowMoney 20, 2
    GoTo _0717
_0717:
    CompleteInitHGSSMenu 1, 1, 0, VAR_0x8000, 1
    AddMenuEntry 209, 0
    AddMenuEntry 210, 1
    AddMenuEntry 211, 2
    AddMenuEntry 212, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_0x8000
    CompareVar VAR_0x8008, 0
    GoToIf 1, _077B
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0787
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0793
    Message msg_0597_T25R1006_00009
    GoTo _08BE
_077B:
    SetVarFromValue VAR_0x8001, 30
    GoTo _07D5
_0787:
    SetVarFromValue VAR_0x8001, 31
    GoTo _07D5
_0793:
    SetVarFromValue VAR_0x8001, 32
    GoTo _07D5
_079F:
    CheckMoney VAR_RESULT, 200
    Return
_07A9:
    CheckMoney VAR_RESULT, 300
    Return
_07B3:
    CheckMoney VAR_RESULT, 350
    Return
_07BD:
    RemoveMoney 200
    Return
_07C5:
    RemoveMoney 300
    Return
_07CD:
    RemoveMoney 350
    Return
_07D5:
    CompareVar VAR_0x8000, 0
    CallIf 1, _079F
    CompareVar VAR_0x8000, 1
    CallIf 1, _07A9
    CompareVar VAR_0x8000, 2
    CallIf 1, _07B3
    CompareVar VAR_RESULT, 0
    GoToIf 1, _08A9
    CanFitItem VAR_0x8001, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _08B2
    CompareVar VAR_0x8000, 0
    CallIf 1, _07BD
    CompareVar VAR_0x8000, 1
    CallIf 1, _07C5
    CompareVar VAR_0x8000, 2
    CallIf 1, _07CD
    UpdateMoneyDisplay
    BufferItemName 0, VAR_0x8001
    PlaySE SEQ_SE_DP_JIHANKI_sseq
    BufferItemName 0, VAR_0x8001
    Message msg_0597_T25R1006_00006
    SetVar VAR_0x8004, VAR_0x8001
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    GetRandom VAR_RESULT, 64
    CompareVar VAR_RESULT, 0
    GoToIf 5, _08A0
    PlaySE SEQ_SE_DP_JIHANKI_sseq
    BufferItemName 0, VAR_0x8001
    Message msg_0597_T25R1006_00007
    CanFitItem VAR_0x8001, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _08B2
    Common_GiveItemQuantity
_08A0:
    Message msg_0597_T25R1006_00005
    GoTo _0717
_08A9:
    Message msg_0597_T25R1006_00008
    GoTo _08BE
_08B2:
    Common_MessageBagIsFull
    CloseMessage
    HideMoney
    ReleaseAll
    End
_08BE:
    WaitButton
    CloseMessage
    HideMoney
    ReleaseAll
    End
    .balign 4, 0
