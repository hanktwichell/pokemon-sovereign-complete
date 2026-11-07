#ifndef POKEPLATINUM_COMPLETE_POKEATHLON_HGSS_COMPAT_H
#define POKEPLATINUM_COMPLETE_POKEATHLON_HGSS_COMPAT_H

#include "constants/heap.h"
#include "constants/narc.h"

#include "font.h"

// Sovereign Complete: what the shims for HeartGold's assembly (src/applications/complete_pokeathlon/hgss_compat*.c)
// share: HeartGold's numbers as Complete's

#define HGSS_NARC_MSGDATA         27
#define HGSS_NARC_MMODEL          81 // data/mmodel/mmodel: the walking Pokémon's models from member 297
#define HGSS_NARC_PERFORMANCE     169 // poketool/personal/performance (Complete's: from data/complete/pokeathlon_performance.json)
#define HGSS_FOLLOWER_MON_DITTO   133 // HeartGold's FOLLOWER_MON_DITTO
#define HGSS_PLATINUM_NARC        0x8000 // an archive number that is Platinum's already (a Pokémon picture's)

// A HeartGold archive and member as Complete's: the archive returned, the member moved where it's packed
enum NarcID HgssCompat_NarcMember(int narcID, int *member);
// A HeartGold text bank (its msgdata/msg member) as Complete's
u32 HgssCompat_TextBank(int bank);
// HeartGold's fonts: 0 to 3 are Platinum's; its 4 and 5 (the small touch-screen ones) Platinum's small font
enum Font HgssCompat_Font(int font);
// HeartGold's sub_02014540: a Pokémon's picture's first frame (10 by 10 tiles) into dest
void HgssCompat_LoadPokemonSprite(int narcID, int narcIdx, enum HeapID heapID, void *dest, u32 personality, BOOL isAnimated, int face, int species);

#endif // POKEPLATINUM_COMPLETE_POKEATHLON_HGSS_COMPAT_H
