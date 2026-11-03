#ifndef POKEPLATINUM_COMPLETE_POKEDEX_H
#define POKEPLATINUM_COMPLETE_POKEDEX_H

#include <nitro.h>

#include "constants/heap.h"

// Sovereign Complete: the regional Pokédex (the owner's call, Nov 3, 2026). HeartGold's Johto Pokédex is the regional
// one until Sinnoh's story begins (the first ship to Sinnoh, Platinum's opening), Sinnoh's after that; the National
// Pokédex beside either once the player has it. Platinum's regional lookups (Pokemon_SinnohDexNumber, the Pokédex's
// regional list in pokedex_sort.c, the regional goal in pokedex.c) ask here first.

#define JOHTO_DEX_COUNT 256
#define JOHTO_DEX_GOAL  (JOHTO_DEX_COUNT - 2) // Mew and Celebi, the event Pokémon at its end, don't count

BOOL CompletePokedex_IsJohto(void);
u16 CompletePokedex_JohtoNumber(u16 species); // 0 when it isn't in the Johto Pokédex
const u16 *CompletePokedex_JohtoList(void); // the JOHTO_DEX_COUNT species in Johto order
u16 *CompletePokedex_NewJohtoList(enum HeapID heapID, int *length); // a copy on the heap, which the caller frees
BOOL CompletePokedex_CountsForJohtoGoal(u16 species);

#endif // POKEPLATINUM_COMPLETE_POKEDEX_H
