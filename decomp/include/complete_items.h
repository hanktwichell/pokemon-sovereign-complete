#ifndef POKEPLATINUM_COMPLETE_ITEMS_H
#define POKEPLATINUM_COMPLETE_ITEMS_H

// Sovereign Complete: Johto's and Kanto's hidden items (include/data/field/hgss_hidden_items.h,
// tools/complete/import_hgss_field_items.py) are hidden item scripts from 8000 + HGSS_HIDDEN_ITEMS_START, after
// Platinum's. Each keeps HeartGold's own flag, its flag HGSS_HIDDEN_ITEMS_FLAG_BASE + the item's number, which is
// FLAG_HGSS_HIDDENITEM_* in the save (COMPLETE_FLAGS_START + HeartGold's flag).
#define HGSS_HIDDEN_ITEMS_START     300
#define HGSS_HIDDEN_ITEMS_FLAG_BASE 800

#endif // POKEPLATINUM_COMPLETE_ITEMS_H
