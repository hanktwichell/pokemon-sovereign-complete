#ifndef POKEPLATINUM_COMPLETE_POKEATHLON_SHOP_H
#define POKEPLATINUM_COMPLETE_POKEATHLON_SHOP_H

#include "overlay007/shop_menu.h"

#include "message.h"
#include "string_gf.h"

// Sovereign Complete: the Pokéathlon Dome's two prize counters on Platinum's shop (src/overlay007/shop_menu.c's
// marked hooks; src/overlay007/complete_pokeathlon_shop.c): HeartGold's MART_TYPE_POKEATHLON_DAILY (the day's prizes,
// each bought once a day) and MART_TYPE_DATA_CARDS (the data cards, each bought once), paid in Athlete Points
enum CompletePokeathlonCounter {
    COMPLETE_POKEATHLON_COUNTER_NONE = 0,
    COMPLETE_POKEATHLON_COUNTER_PRIZES,
    COMPLETE_POKEATHLON_COUNTER_DATA_CARDS,
};

void CompletePokeathlonShop_Init(ShopMenu *shopMenu, const u16 *prices, enum CompletePokeathlonCounter counter);
void CompletePokeathlonShop_Free(ShopMenu *shopMenu);
u32 CompletePokeathlonShop_Price(ShopMenu *shopMenu, u16 item);
u32 CompletePokeathlonShop_Points(ShopMenu *shopMenu);
void CompletePokeathlonShop_TakePoints(ShopMenu *shopMenu, u32 amount);
String *CompletePokeathlonShop_Refusal(ShopMenu *shopMenu, u32 points); // why the chosen item can't be bought, or NULL
BOOL CompletePokeathlonShop_CanFit(ShopMenu *shopMenu);
void CompletePokeathlonShop_Buy(ShopMenu *shopMenu);
String *CompletePokeathlonShop_String(ShopMenu *shopMenu, u32 shopTextID); // the shop's text (bank 543) or HeartGold's

#endif // POKEPLATINUM_COMPLETE_POKEATHLON_SHOP_H
