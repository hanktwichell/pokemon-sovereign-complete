#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0528.h"

#define obj_T10R0701_wataru 0

    ScriptEntry scr_seq_T10R0701_000
    ScriptEntry scr_seq_T10R0701_001
    ScriptEntryEnd
scr_seq_T10R0701_001:
    StopMusic
    End
scr_seq_T10R0701_000:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0188
    ApplyMovement obj_T10R0701_wataru, _0194
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0528_T10R0701_00000, msg_0528_T10R0701_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _01A8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CountPartyNonEggs VAR_RESULT
    PlayHallOfFameHealingAnimation VAR_RESULT
    IncrementTrainerScore TRAINER_SCORE_EVENT_HALL_OF_FAME_ENTRY
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Call _01B4
    CheckItem ITEM_SS_TICKET, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _009A
    SetVarFromValue VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 3
_009A:
    SetFlag FLAG_HGSS_UNK_97E
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_PRYCE
    CallIfUnset FLAG_HGSS_CAUGHT_HO_OH, _01C9
    CallIfUnset FLAG_HGSS_CAUGHT_LUGIA, _01CF
    CallIfUnset FLAG_HGSS_CAUGHT_SUDOWOODO, _01D5
    CallIfUnset FLAG_HGSS_CAUGHT_RED_GYARADOS, _01DB
    CallIfUnset FLAG_HGSS_CAUGHT_MEWTWO, _01E1
    CallIfUnset FLAG_HGSS_CAUGHT_ARTICUNO, _01E7
    CallIfUnset FLAG_HGSS_CAUGHT_ZAPDOS, _01ED
    CallIfUnset FLAG_HGSS_CAUGHT_MOLTRES, _0206
    GoToIfUnset FLAG_HGSS_CAUGHT_SNORLAX, _020C
_0105:
    CallIfUnset FLAG_HGSS_CAUGHT_SUICUNE, _0227
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _012D
    GoTo _023A
    GoTo _0133
_012D:
    GoTo _024F
_0133:
    CallIfUnset FLAG_HGSS_CAUGHT_RAYQUAZA, _0264
    CompareVar VAR_HGSS_ROAMER_ENTEI_STATUS, 2
    CallIf 1, _026A
    CompareVar VAR_HGSS_ROAMER_RAIKOU_STATUS, 2
    CallIf 1, _0275
    CompareVar VAR_HGSS_ROAMER_LATIAS_STATUS, 2
    CallIf 1, _0280
    CompareVar VAR_HGSS_ROAMER_LATIOS_STATUS, 2
    CallIf 1, _028B
    CompleteJohtoClearGame 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0188:
    WalkNormalNorth 14
    FaceEast 2
    EndMovement
    .balign 4, 0
_0194:
    WalkNormalNorth 12
    FaceEast 2
    WalkNormalEast
    FaceWest 2
    EndMovement
    .balign 4, 0
_01A8:
    FaceNorth 2
    WalkNormalNorth 4
    EndMovement
_01B4:
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _01C3
    SetFlag FLAG_HGSS_UNK_998
_01C3:
    ClearFlag FLAG_HGSS_UNK_25F
    Return
_01C9:
    ClearFlag FLAG_HGSS_HIDE_BELL_TOWER_HO_OH
    Return
_01CF:
    ClearFlag FLAG_HGSS_HIDE_WHIRL_ISLAND_LUGIA
    Return
_01D5:
    ClearFlag FLAG_HGSS_HIDE_ROUTE_36_SUDOWOODO
    Return
_01DB:
    ClearFlag FLAG_HGSS_HIDE_LAKE_OF_RAGE_RED_GYARADOS
    Return
_01E1:
    ClearFlag FLAG_HGSS_HIDE_CERULEAN_CAVE_MEWTWO
    Return
_01E7:
    ClearFlag FLAG_HGSS_HIDE_SEAFOAM_ISLAND_ARTICUNO
    Return
_01ED:
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0204
    ClearFlag FLAG_HGSS_HIDE_ROUTE_10_ZAPDOS
_0204:
    Return
_0206:
    ClearFlag FLAG_HGSS_HIDE_MT_SILVER_CAVE_MOLTRES
    Return
_020C:
    GoToIfSet FLAG_HGSS_SNORLAX_MEET, _021D
    GoTo _0105
_021D:
    ClearFlag FLAG_HGSS_HIDE_ROUTE_12_SNORLAX
    GoTo _0105
_0227:
    CompareVar VAR_HGSS_SCENE_ROUTE_25, 3
    GoToIf 5, _0238
    ClearFlag FLAG_HGSS_HIDE_BURNED_TOWER_STATIC_SUICUNE
_0238:
    Return
_023A:
    GoToIfSet FLAG_HGSS_CAUGHT_KYOGRE, _0133
    ClearFlag FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE
    GoTo _0133
_024F:
    GoToIfSet FLAG_HGSS_CAUGHT_KYOGRE, _0133
    ClearFlag FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE
    GoTo _0133
_0264:
    ClearFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_RAYQUAZA
    Return
_026A:
    SetVarFromValue VAR_HGSS_ROAMER_ENTEI_STATUS, 0
    ActivateRoamingPokemon ROAMING_SLOT_ENTEI
    Return
_0275:
    SetVarFromValue VAR_HGSS_ROAMER_RAIKOU_STATUS, 0
    ActivateRoamingPokemon ROAMING_SLOT_RAIKOU
    Return
_0280:
    SetVarFromValue VAR_HGSS_ROAMER_LATIAS_STATUS, 0
    ActivateRoamingPokemon ROAMING_SLOT_LATIAS
    Return
_028B:
    SetVarFromValue VAR_HGSS_ROAMER_LATIOS_STATUS, 0
    ActivateRoamingPokemon ROAMING_SLOT_LATIOS
    Return
    .balign 4, 0
