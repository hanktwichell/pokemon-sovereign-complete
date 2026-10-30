#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0075.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D24R0204_babyboy1_12 0
#define obj_D24R0204_babyboy1_13 1

    ScriptEntry scr_seq_D24R0204_000
    ScriptEntry scr_seq_D24R0204_001
    ScriptEntry scr_seq_D24R0204_002
    ScriptEntry scr_seq_D24R0204_003
    ScriptEntryEnd
scr_seq_D24R0204_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteAlphPuzzle 1
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoToIfSet FLAG_HGSS_SYS_ALPH_PUZZLE_AERODACTYL, _0046
    ReleaseAll
    End
_0046:
    WaitTime 2, VAR_0x8004
    CompleteScreenShake 0, 2, 10, 6
    WaitTime 10, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _02BC
    WaitMovement
    RemoveObject obj_D24R0204_babyboy1_13
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_UNK_111
    SetFlag FLAG_HGSS_UNK_21E
    ClearFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_ASSISTANTS
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _009A
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00AA
    End
_009A:
    ApplyMovement LOCALID_PLAYER, _022C
    WaitMovement
    GoTo _00BC
_00AA:
    ApplyMovement LOCALID_PLAYER, _022C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0238
    WaitMovement
_00BC:
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 4, _0107
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 25, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_UNK_40DE, 1
    AddVar VAR_HGSS_UNK_40EC, 1
    ReleaseAll
    End
_0107:
    SetFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_ASSISTANTS
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 25, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_UNK_40DE, 1
    AddVar VAR_HGSS_UNK_40EC, 1
    ReleaseAll
    End
scr_seq_D24R0204_003:
    LockAll
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0167
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0177
    End
_0167:
    ApplyMovement LOCALID_PLAYER, _022C
    WaitMovement
    GoTo _0189
_0177:
    ApplyMovement LOCALID_PLAYER, _022C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0238
    WaitMovement
_0189:
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _01D5
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _01FF
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 25, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01D1:
    ReleaseAll
    End
_01D5:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 25, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01D1
_01FF:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 25, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01D1
    .balign 4, 0
_022C:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0238:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
scr_seq_D24R0204_001:
    LockAll
    ReleaseAll
    End
scr_seq_D24R0204_002:
    LockAll
    BufferPartyMonNickname 0, VAR_0x8000
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0211
    MessageFromBank VAR_RESULT, 28
    CloseMessage
    @ HGSS: ScrCmd_183 VAR_SPECIAL_x8000
    WaitTime 2, VAR_0x8004
    GoToIfSet FLAG_HGSS_OPENED_ALPH_FLASH_SECRET_ROOM, _02A9
    CompleteScreenShake 0, 2, 10, 6
    WaitTime 10, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _02BC
    WaitMovement
    RemoveObject obj_D24R0204_babyboy1_12
    SetFlag FLAG_HGSS_OPENED_ALPH_FLASH_SECRET_ROOM
    PlaySE SEQ_SE_DP_UG_008_sseq
    ReleaseAll
    End
_02A9:
    WaitTime 20, VAR_0x8004
    Message msg_0075_D24R0204_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_02BC:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
