#ifndef POKEPLATINUM_DATA_COMPLETE_PLAYER_H
#define POKEPLATINUM_DATA_COMPLETE_PLAYER_H

#include "generated/trainer_classes.h"

// Sovereign Complete: the player's trainer classes, the boy Ethan and the girl Dawn
// (tools/complete/import_hgss_player.py). Generated. Platinum's TRAINER_CLASS_PLAYER_MALE and _FEMALE stay Lucas and
// Dawn, for Rowan's assistant in battle.
#define COMPLETE_PLAYER_CLASS_MALE   TRAINER_CLASS_HGSS_PKMN_TRAINER_ETHAN
#define COMPLETE_PLAYER_CLASS_FEMALE TRAINER_CLASS_PLAYER_FEMALE

// Whether each is HeartGold's player: the Fly take-off's rider then comes from HeartGold's cut-in archive
// (src/overlay006/hm_cut_in.c)
#define COMPLETE_PLAYER_BOY_IS_HGSS  1
#define COMPLETE_PLAYER_GIRL_IS_HGSS 0

#endif
