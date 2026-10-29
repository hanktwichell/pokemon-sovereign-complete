#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0127.h"


    ScriptEntry scr_seq_D42R0101_000
    ScriptEntry scr_seq_D42R0101_001
    ScriptEntryEnd
scr_seq_D42R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_BLACKGLASSES_FROM_DARK_CAVE_MAN, _00D5
    Message msg_0127_D42R0101_00000
    SetVar VAR_0x8004, ITEM_BLACKGLASSES
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _00E0
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_BLACKGLASSES_FROM_DARK_CAVE_MAN
    Message msg_0127_D42R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D42R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_REGISTEEL, 6
    ReleaseObject 3
    @ HGSS: ScrCmd_523 3, 2, 90, 2, 0
    LockObject 3
    Message msg_0127_D42R0101_00004
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_REGISTEEL, 40, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00EB
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 3
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _00F1
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _00F1
    ReleaseAll
    End
_00D5:
    Message msg_0127_D42R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E0:
    Message msg_0127_D42R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00EB:
    BlackOutFromBattle
    ReleaseAll
    End
_00F1:
    Message msg_0127_D42R0101_00005
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FD5
    ReleaseAll
    End
    .balign 4, 0
