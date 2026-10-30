#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0349.h"

#define obj_R12R0101_fishing_2 0

    ScriptEntry scr_seq_R12R0101_000
    ScriptEntry scr_seq_R12R0101_001
    ScriptEntryEnd
scr_seq_R12R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_SUPER_ROD, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0108
    Message msg_0349_R12R0101_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0113
    Message msg_0349_R12R0101_00001
    SetVar VAR_0x8004, ITEM_SUPER_ROD
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0349_R12R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R12R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    StopMusic
    PlayMusic SEQ_GS_OHKIDO_sseq
    BufferPlayerName 0
    BufferPartyMonSpecies 1, 0
    Message msg_0349_R12R0101_00004
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _011E
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 1, _011E
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _011E
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 1, _019A
    CompareVar VAR_MAP_LOCAL_0x01, 5
    GoToIf 1, _019A
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 1, _019A
    CompareVar VAR_MAP_LOCAL_0x01, 7
    GoToIf 1, _0216
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 1, _0216
    CompareVar VAR_MAP_LOCAL_0x01, 9
    GoToIf 1, _0216
    Message msg_0349_R12R0101_00005
    WaitButton
    CloseMessage
    FadeOutBGM 0, 10
    PlayDefaultMusic
    ReleaseAll
    End
_0108:
    Message msg_0349_R12R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0113:
    Message msg_0349_R12R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_011E:
    Message msg_0349_R12R0101_00006
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0292
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0292
    GivePokemon SPECIES_CHARMANDER, 10, 155, VAR_RESULT
    GivePokemon SPECIES_SQUIRTLE, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0349_R12R0101_00007
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0349_R12R0101_00010
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_R12R0101_fishing_2
    FadeOutBGM 0, 30
    StopMusic
    PlayDefaultMusic
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_019A:
    Message msg_0349_R12R0101_00006
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0292
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0292
    GivePokemon SPECIES_BULBASAUR, 10, 155, VAR_RESULT
    GivePokemon SPECIES_SQUIRTLE, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0349_R12R0101_00008
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0349_R12R0101_00010
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_R12R0101_fishing_2
    FadeOutBGM 0, 30
    StopMusic
    PlayDefaultMusic
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0216:
    Message msg_0349_R12R0101_00006
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0292
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0292
    GivePokemon SPECIES_BULBASAUR, 10, 155, VAR_RESULT
    GivePokemon SPECIES_CHARMANDER, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0349_R12R0101_00009
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0349_R12R0101_00010
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_R12R0101_fishing_2
    FadeOutBGM 0, 30
    StopMusic
    PlayDefaultMusic
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0292:
    Message msg_0349_R12R0101_00011
    WaitButton
    CloseMessage
    FadeOutBGM 0, 30
    StopMusic
    PlayDefaultMusic
    ReleaseAll
    End
    .balign 4, 0
