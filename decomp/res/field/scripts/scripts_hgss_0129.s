#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0144.h"

#define obj_D50R0101_breakrock 1
#define obj_D50R0101_breakrock_2 2
#define obj_D50R0101_breakrock_3 3
#define obj_D50R0101_breakrock_4 4
#define obj_D50R0101_breakrock_5 5
#define obj_D50R0101_breakrock_6 6

    ScriptEntry scr_seq_D50R0101_000
    ScriptEntry scr_seq_D50R0101_001
    ScriptEntry scr_seq_D50R0101_002
    ScriptEntry scr_seq_D50R0101_003
    ScriptEntryEnd
scr_seq_D50R0101_001:
    GetSetNationalDexEnabled 2, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _010D
    SetPosition obj_D50R0101_breakrock, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_2, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_3, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_4, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_5, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_6, 30, 1, 30, DIR_NORTH
    End
scr_seq_D50R0101_000:
    NPCMessage msg_0144_D50R0101_00000
    End
scr_seq_D50R0101_002:
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0144_D50R0101_00001
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_SWIMMER_M_MICKEY_4, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _010F
    Message msg_0144_D50R0101_00002
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 7
    FadeScreen 8, 1, 1, COLOR_BLACK
    SetFlag FLAG_HGSS_SG_3FE2
    Message msg_0144_D50R0101_00003
    SetVar VAR_0x8004, ITEM_TM06
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
scr_seq_D50R0101_003:
    LockAll
    RemoveObject 8
    SetFlag FLAG_HGSS_SG_3FD0
    SetVar VAR_0x8004, ITEM_TM29
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_010D:
    End
_010F:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
