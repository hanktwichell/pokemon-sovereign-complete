#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0451.h"

#define obj_T01R0301_ookido 0
#define obj_T01R0301_monstarball 4
#define obj_T01R0301_monstarball_2 5
#define obj_T01R0301_monstarball_3 6

    ScriptEntry scr_seq_T01R0301_000
    ScriptEntry scr_seq_T01R0301_001
    ScriptEntry scr_seq_T01R0301_002
    ScriptEntry scr_seq_T01R0301_003
    ScriptEntry scr_seq_T01R0301_004
    ScriptEntry scr_seq_T01R0301_005
    ScriptEntry scr_seq_T01R0301_006
    ScriptEntry scr_seq_T01R0301_007
    ScriptEntry scr_seq_T01R0301_008
    ScriptEntry scr_seq_T01R0301_009
    ScriptEntry scr_seq_T01R0301_010
    ScriptEntry scr_seq_T01R0301_011
    ScriptEntryEnd
scr_seq_T01R0301_010:
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _02F6
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _02F6
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _02F6
    End
scr_seq_T01R0301_006:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0AC6
    WaitMovement
    BufferPlayerName 0
    Message msg_0451_T01R0301_00058
    Message msg_0451_T01R0301_00059
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4131, 2
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_BULBASAUR_BALL
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_SQUIRTLE_BALL
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_CHARMANDER_BALL
    SetVarFromVar VAR_HGSS_UNK_4131, VAR_0x8006
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 1
    ReleaseAll
    End
scr_seq_T01R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4096, 2
    GoToIf 1, _030A
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _034C
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _034C
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _034C
    CompareVar VAR_HGSS_UNK_4131, 2
    GoToIf 1, _0357
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 7
    GoToIf 1, _0362
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 5
    GoToIf 1, _0373
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 4
    GoToIf 1, _037E
    GoToIfSet FLAG_HGSS_GOT_HM08, _03CD
    GoToIfSet FLAG_HGSS_UNK_12A, _040B
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00000, msg_0451_T01R0301_00001
    SetFlag FLAG_HGSS_UNK_12A
    CompareVar VAR_HGSS_UNK_4135, 0
    GoToIf 5, _0421
    Message msg_0451_T01R0301_00008
    GoTo _03CD
scr_seq_T01R0301_001:
    NPCMessage msg_0451_T01R0301_00033
    End
scr_seq_T01R0301_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0451_T01R0301_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T01R0301_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0451_T01R0301_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T01R0301_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0451_T01R0301_00036
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T01R0301_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00037, msg_0451_T01R0301_00038
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T01R0301_007:
    CompareVar VAR_HGSS_UNK_4131, 6
    GoToIf 1, _0466
    CompareVar VAR_HGSS_UNK_4131, 0
    GoToIf 1, _0468
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _0468
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _046A
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _046A
    .short SCRCMD_UNUSED_06A
    .short obj_T01R0301_ookido
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _0478
    ApplyMovement obj_T01R0301_ookido, _0ACC
    GoTo _04BA
scr_seq_T01R0301_008:
    CompareVar VAR_HGSS_UNK_4131, 6
    GoToIf 1, _0466
    CompareVar VAR_HGSS_UNK_4131, 0
    GoToIf 1, _0468
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _0468
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _046A
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _046A
    .short SCRCMD_UNUSED_06A
    .short obj_T01R0301_ookido
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _04F4
    ApplyMovement obj_T01R0301_ookido, _0ACC
    GoTo _0536
scr_seq_T01R0301_009:
    CompareVar VAR_HGSS_UNK_4131, 6
    GoToIf 1, _0466
    CompareVar VAR_HGSS_UNK_4131, 0
    GoToIf 1, _0468
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _0468
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _046A
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _046A
    .short SCRCMD_UNUSED_06A
    .short obj_T01R0301_ookido
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _0570
    ApplyMovement obj_T01R0301_ookido, _0ACC
    GoTo _05B2
scr_seq_T01R0301_011:
    End
_02F6:
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_BULBASAUR_BALL
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_SQUIRTLE_BALL
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_CHARMANDER_BALL
    SetVarFromValue VAR_HGSS_UNK_4131, 6
    End
_030A:
    GoToIfSet FLAG_HGSS_GOT_HM08, _05EC
    Message msg_0451_T01R0301_00055
    SetVar VAR_0x8004, ITEM_HM08
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0451_T01R0301_00056
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00006, msg_0451_T01R0301_00007
    SetVarFromValue VAR_HGSS_UNK_4110, 2
    SetFlag FLAG_HGSS_UNLOCKED_MT_SILVER
    ClearFlag FLAG_HGSS_SG_3F8B
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_GOT_HM08
    ReleaseAll
    End
_034C:
    Message msg_0451_T01R0301_00053
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0357:
    Message msg_0451_T01R0301_00042
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0362:
    Message msg_0451_T01R0301_00023
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 8
    GoTo _03CD
_0373:
    Message msg_0451_T01R0301_00022
    CloseMessage
    GoTo _03CD
_037E:
    @ HGSS: CheckKyogreGroudonInParty VAR_SPECIAL_x8005
    CompareVar VAR_0x8005, 1
    GoToIf 1, _05F7
    GoToIfSet FLAG_HGSS_UNK_0BC, _062A
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00011, msg_0451_T01R0301_00012
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _0AD2
    WaitMovement
    SetFlag FLAG_HGSS_UNK_0BC
    Message msg_0451_T01R0301_00013
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0644
    GoTo _0657
_03CD:
    GoToIfSet FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION, _0676
    @ HGSS: CallStd std_in_person_evaluate_dex
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06DA
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06DA
    CheckNationalDexCompleted VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06DE
    ReleaseAll
    End
_040B:
    CompareVar VAR_HGSS_UNK_4135, 0
    GoToIf 5, _0421
    Message msg_0451_T01R0301_00008
    GoTo _03CD
_0421:
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00009, msg_0451_T01R0301_00010
    GoToIfSet FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION, _0676
    @ HGSS: CallStd std_in_person_evaluate_dex
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06DA
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06DA
    CheckNationalDexCompleted VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06DE
    ReleaseAll
    End
_0466:
    End
_0468:
    End
_046A:
    BufferRivalName 1
    Message msg_0451_T01R0301_00054
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0478:
    ApplyMovement obj_T01R0301_ookido, _0ADC
    WaitMovement
    DrawPokemonPreview SPECIES_BULBASAUR, 0
    PlayCry SPECIES_BULBASAUR, 0
    Message msg_0451_T01R0301_00045
    WaitCry
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0744
    SetVarFromValue VAR_0x8004, 1
    SetVarFromValue VAR_0x8006, 3
    Call _0753
    End
_04BA:
    WaitMovement
    DrawPokemonPreview SPECIES_BULBASAUR, 0
    PlayCry SPECIES_BULBASAUR, 0
    Message msg_0451_T01R0301_00045
    WaitCry
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0744
    SetVarFromValue VAR_0x8004, 1
    SetVarFromValue VAR_0x8006, 3
    Call _0753
    End
_04F4:
    ApplyMovement obj_T01R0301_ookido, _0ADC
    WaitMovement
    DrawPokemonPreview SPECIES_SQUIRTLE, 0
    PlayCry SPECIES_SQUIRTLE, 0
    Message msg_0451_T01R0301_00044
    WaitCry
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0744
    SetVarFromValue VAR_0x8004, 7
    SetVarFromValue VAR_0x8006, 4
    Call _0753
    End
_0536:
    WaitMovement
    DrawPokemonPreview SPECIES_SQUIRTLE, 0
    PlayCry SPECIES_SQUIRTLE, 0
    Message msg_0451_T01R0301_00044
    WaitCry
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0744
    SetVarFromValue VAR_0x8004, 7
    SetVarFromValue VAR_0x8006, 4
    Call _0753
    End
_0570:
    ApplyMovement obj_T01R0301_ookido, _0ADC
    WaitMovement
    DrawPokemonPreview SPECIES_CHARMANDER, 0
    PlayCry SPECIES_CHARMANDER, 0
    Message msg_0451_T01R0301_00043
    WaitCry
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0744
    SetVarFromValue VAR_0x8004, 4
    SetVarFromValue VAR_0x8006, 5
    Call _0753
    End
_05B2:
    WaitMovement
    DrawPokemonPreview SPECIES_CHARMANDER, 0
    PlayCry SPECIES_CHARMANDER, 0
    Message msg_0451_T01R0301_00043
    WaitCry
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0744
    SetVarFromValue VAR_0x8004, 4
    SetVarFromValue VAR_0x8006, 5
    Call _0753
    End
_05EC:
    Message msg_0451_T01R0301_00057
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05F7:
    GoToIfUnset FLAG_HGSS_UNK_0BC, _0781
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00019, msg_0451_T01R0301_00020
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0790
    ApplyMovement obj_T01R0301_ookido, _0AE2
    GoTo _07AB
_062A:
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 8
    GoToIf 1, _07D3
    BufferPlayerName 0
    GoTo _03CD
_0644:
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _07DC
    GoTo _07EF
_0657:
    ApplyMovement obj_T01R0301_ookido, _0AE2
    WaitMovement
    Message msg_0451_T01R0301_00014
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _0AE2
    WaitMovement
    GoTo _062A
_0676:
    SetFlag FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00004, msg_0451_T01R0301_00005
    Message msg_0451_T01R0301_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _080E
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0819
    Message msg_0451_T01R0301_00029
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 90
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0451_T01R0301_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06DA:
    ReleaseAll
    End
_06DE:
    WaitABPress
    SetFlag FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00004, msg_0451_T01R0301_00005
    Message msg_0451_T01R0301_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _080E
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0819
    Message msg_0451_T01R0301_00029
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 90
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0451_T01R0301_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0744:
    RemovePokemonPreview
    Message msg_0451_T01R0301_00047
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0753:
    RemovePokemonPreview
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _0824
    CompareVar VAR_0x8004, 1
    GoToIf 5, _0831
    RemoveObject obj_T01R0301_monstarball_3
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_BULBASAUR_BALL
    GoTo _084C
_0781:
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00024, msg_0451_T01R0301_00025
    CloseMessage
    GoTo _08CD
_0790:
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _08EC
    ApplyMovement obj_T01R0301_ookido, _0AEC
    GoTo _07AB
_07AB:
    WaitMovement
    BufferPlayerName 0
    SetVar VAR_0x8004, ITEM_JADE_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    Message msg_0451_T01R0301_00021
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 5
    GoTo _03CD
_07D3:
    BufferPlayerName 0
    GoTo _03CD
_07DC:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _0907
    GoTo _090D
_07EF:
    ApplyMovement obj_T01R0301_ookido, _0AEC
    WaitMovement
    Message msg_0451_T01R0301_00014
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _0AEC
    WaitMovement
    GoTo _062A
_080E:
    Message msg_0451_T01R0301_00031
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0819:
    Message msg_0451_T01R0301_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0824:
    Message msg_0451_T01R0301_00051
    WaitButton
    CloseMessage
    ReleaseAll
    Return
_0831:
    CompareVar VAR_0x8004, 7
    GoToIf 5, _092C
    RemoveObject obj_T01R0301_monstarball_2
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_SQUIRTLE_BALL
    GoTo _084C
_084C:
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    Message msg_0451_T01R0301_00046
    Message msg_0451_T01R0301_00048
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    GivePokemon VAR_0x8004, 5, 0, VAR_RESULT
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    Message msg_0451_T01R0301_00049
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    CallIf 1, _09B5
    .short SCRCMD_UNUSED_06A
    .short obj_T01R0301_ookido
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 1, _09F8
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8004, 1
    GoToIf 5, _0A19
    ApplyMovement LOCALID_PLAYER, _0AF6
    GoTo _0A34
_08CD:
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0790
    ApplyMovement obj_T01R0301_ookido, _0AE2
    GoTo _07AB
_08EC:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _0A46
    ApplyMovement obj_T01R0301_ookido, _0B00
    GoTo _07AB
_0907:
    GoTo _0A76
_090D:
    ApplyMovement obj_T01R0301_ookido, _0B00
    WaitMovement
    Message msg_0451_T01R0301_00014
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _0B00
    WaitMovement
    GoTo _062A
_092C:
    RemoveObject obj_T01R0301_monstarball
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_CHARMANDER_BALL
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    Message msg_0451_T01R0301_00046
    Message msg_0451_T01R0301_00048
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    GivePokemon VAR_0x8004, 5, 0, VAR_RESULT
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    Message msg_0451_T01R0301_00049
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    CallIf 1, _09B5
    .short SCRCMD_UNUSED_06A
    .short obj_T01R0301_ookido
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 1, _09F8
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8004, 1
    GoToIf 5, _0A19
    ApplyMovement LOCALID_PLAYER, _0AF6
    GoTo _0A34
_09B5:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_0x8005, VAR_MAP_LOCAL_0x00
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    BufferPartyMonNickname 1, VAR_0x8005
    Message msg_0451_T01R0301_00050
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _09B5
    Return
_09F8:
    ApplyMovement LOCALID_PLAYER, _0B0A
    WaitMovement
    Message msg_0451_T01R0301_00052
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromVar VAR_HGSS_UNK_4131, VAR_0x8006
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 1
    Return
_0A19:
    CompareVar VAR_0x8004, 7
    GoToIf 5, _0A95
    ApplyMovement LOCALID_PLAYER, _0B10
    GoTo _0A34
_0A34:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0AAF
_0A46:
    ApplyMovement obj_T01R0301_ookido, _0B1A
    WaitMovement
    BufferPlayerName 0
    SetVar VAR_0x8004, ITEM_JADE_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    Message msg_0451_T01R0301_00021
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 5
    GoTo _03CD
_0A76:
    ApplyMovement obj_T01R0301_ookido, _0B1A
    WaitMovement
    Message msg_0451_T01R0301_00014
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _0B1A
    WaitMovement
    GoTo _062A
_0A95:
    ApplyMovement LOCALID_PLAYER, _0B24
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0AAF
_0AAF:
    Message msg_0451_T01R0301_00052
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromVar VAR_HGSS_UNK_4131, VAR_0x8006
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 1
    Return
    .balign 4, 0
_0AC6:
    WalkNormalNorth 5
    EndMovement
    .balign 4, 0
_0ACC:
    FaceNorth
    EndMovement
    .balign 4, 0
_0AD2:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0ADC:
    FaceEast
    EndMovement
    .balign 4, 0
_0AE2:
    WalkOnSpotNormalSouth
    Delay8
    EndMovement
    .balign 4, 0
_0AEC:
    WalkOnSpotNormalWest
    Delay8
    EndMovement
    .balign 4, 0
_0AF6:
    WalkNormalSouth
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0B00:
    WalkOnSpotNormalEast
    Delay8
    EndMovement
    .balign 4, 0
_0B0A:
    FaceSouth
    EndMovement
    .balign 4, 0
_0B10:
    WalkNormalSouth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0B1A:
    WalkOnSpotNormalNorth
    Delay8
    EndMovement
    .balign 4, 0
_0B24:
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
