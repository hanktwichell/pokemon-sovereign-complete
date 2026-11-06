#include "pokemon_icon.h"

#include <nitro.h>
#include <string.h>

#include "constants/pokemon.h"
#include "constants/species.h"

#include "pokemon.h"

#include "res/pokemon/pl_poke_icon.naix"
#include "res/pokemon/species_icon_palettes.h"

#include "data/complete_form_icons.h" // Sovereign Complete

// Sovereign Complete: a Sovereign form's icon (tools/complete/import_showdown_icons.py), after Platinum's own forms'
#define COMPLETE_FORM_ICON(index) (ICON_ROTOM_MOW + 1 + (index))

static inline u32 IconTilesIndex(u32 icon)
{
    return icon + icon_00000_NCGR;
}

u32 BoxPokemon_IconSpriteIndex(const BoxPokemon *boxMon)
{
    BOOL reencrypt = BoxPokemon_EnterDecryptionContext((BoxPokemon *)boxMon);

    u32 species = BoxPokemon_GetValue((BoxPokemon *)boxMon, MON_DATA_SPECIES, NULL);
    BOOL isEgg = BoxPokemon_GetValue((BoxPokemon *)boxMon, MON_DATA_IS_EGG, NULL);
    u32 form = BoxPokemon_IconFormOffset((BoxPokemon *)boxMon);
    u32 index = PokeIconSpriteIndex(species, isEgg, form);

    BoxPokemon_ExitDecryptionContext((BoxPokemon *)boxMon, reencrypt);
    return index;
}

u32 Pokemon_IconSpriteIndex(Pokemon *mon)
{
    return BoxPokemon_IconSpriteIndex((const BoxPokemon *)Pokemon_GetBoxPokemon(mon));
}

u32 PokeIconSpriteIndex(u32 species, u32 isEgg, u32 form)
{
    if (isEgg == TRUE) {
        if (species == SPECIES_MANAPHY) {
            return IconTilesIndex(ICON_MANAPHY_EGG);
        }

        return IconTilesIndex(ICON_EGG);
    }

    form = Pokemon_SanitizeFormId(species, form);

    if (form != 0) {
        if (species == SPECIES_DEOXYS) {
            return IconTilesIndex(ICON_DEOXYS_ATTACK) + form - 1;
        }

        if (species == SPECIES_UNOWN) {
            return IconTilesIndex(ICON_UNOWN_B) + form - 1;
        }

        if (species == SPECIES_BURMY) {
            return IconTilesIndex(ICON_BURMY_SANDY) + form - 1;
        }

        if (species == SPECIES_WORMADAM) {
            return IconTilesIndex(ICON_WORMADAM_SANDY) + form - 1;
        }

        if (species == SPECIES_SHELLOS) {
            return IconTilesIndex(ICON_SHELLOS_EAST_SEA) + form - 1;
        }

        if (species == SPECIES_GASTRODON) {
            return IconTilesIndex(ICON_GASTRODON_EAST_SEA) + form - 1;
        }

        if (species == SPECIES_GIRATINA) {
            return IconTilesIndex(ICON_GIRATINA_ORIGIN) + form - 1;
        }

        if (species == SPECIES_SHAYMIN) {
            return IconTilesIndex(ICON_SHAYMIN_SKY) + form - 1;
        }

        if (species == SPECIES_ROTOM) {
            return IconTilesIndex(ICON_ROTOM_HEAT) + form - 1;
        }

        int sovereignForm = Pokemon_SovereignFormIndex(species, form); // Sovereign Complete: its own icon

        if (sovereignForm >= 0) {
            return IconTilesIndex(COMPLETE_FORM_ICON(sovereignForm));
        }
    }

    if (species > NATIONAL_DEX_COUNT) {
        species = SPECIES_NONE;
    }

    return IconTilesIndex(species);
}

u16 BoxPokemon_IconFormOffset(const BoxPokemon *boxMon)
{
    u32 speciesOrEgg = BoxPokemon_GetValue((BoxPokemon *)boxMon, MON_DATA_SPECIES_OR_EGG, NULL);

    switch (speciesOrEgg) {
    case SPECIES_UNOWN:
        return BoxPokemon_GetForm((BoxPokemon *)boxMon);
    case SPECIES_DEOXYS:
    case SPECIES_BURMY:
    case SPECIES_WORMADAM:
    case SPECIES_SHELLOS:
    case SPECIES_GASTRODON:
    case SPECIES_GIRATINA:
    case SPECIES_SHAYMIN:
    case SPECIES_ROTOM:
        return BoxPokemon_GetValue((BoxPokemon *)boxMon, MON_DATA_FORM, NULL);
    }

    // Sovereign Complete: a Sovereign form has its own icon
    u32 form = BoxPokemon_GetValue((BoxPokemon *)boxMon, MON_DATA_FORM, NULL);

    return Pokemon_SovereignFormIndex(speciesOrEgg, form) >= 0 ? form : 0;
}

const u8 PokeIconPaletteIndex(u32 species, u32 form, u32 isEgg)
{
    if (isEgg == TRUE) {
        if (species == SPECIES_MANAPHY) {
            species = ICON_MANAPHY_EGG;
        } else {
            species = ICON_EGG;
        }
    } else if (species > NATIONAL_DEX_COUNT) {
        species = SPECIES_NONE;
    } else if (form != 0) {
        if (species == SPECIES_DEOXYS) {
            species = ICON_DEOXYS_ATTACK + form - 1;
        } else if (species == SPECIES_UNOWN) {
            species = ICON_UNOWN_A + form - 1;
        } else if (species == SPECIES_BURMY) {
            species = ICON_BURMY_SANDY + form - 1;
        } else if (species == SPECIES_WORMADAM) {
            species = ICON_WORMADAM_SANDY + form - 1;
        } else if (species == SPECIES_SHELLOS) {
            species = ICON_SHELLOS_EAST_SEA + form - 1;
        } else if (species == SPECIES_GASTRODON) {
            species = ICON_GASTRODON_EAST_SEA + form - 1;
        } else if (species == SPECIES_GIRATINA) {
            species = ICON_GIRATINA_ORIGIN + form - 1;
        } else if (species == SPECIES_SHAYMIN) {
            species = ICON_SHAYMIN_SKY + form - 1;
        } else if (species == SPECIES_ROTOM) {
            species = ICON_ROTOM_HEAT + form - 1;
        } else {
            int sovereignForm = Pokemon_SovereignFormIndex(species, form); // Sovereign Complete: its own icon's

            if (sovereignForm >= 0) {
                return (sCompleteFormIconPalettes[sovereignForm / 4] >> (sovereignForm % 4 * 2)) & 3;
            }
        }
    }

    return sPokemonIconPaletteIndex[species];
}

const u8 BoxPokemon_IconPaletteIndex(const BoxPokemon *boxMon)
{
    BOOL reencrypt = BoxPokemon_EnterDecryptionContext((BoxPokemon *)boxMon);

    u32 form = BoxPokemon_IconFormOffset(boxMon);
    u32 species = BoxPokemon_GetValue((BoxPokemon *)boxMon, MON_DATA_SPECIES, NULL);
    u32 isEgg = BoxPokemon_GetValue((BoxPokemon *)boxMon, MON_DATA_IS_EGG, NULL);

    BoxPokemon_ExitDecryptionContext((BoxPokemon *)boxMon, reencrypt);

    return PokeIconPaletteIndex(species, form, isEgg);
}

const u8 Pokemon_IconPaletteIndex(Pokemon *mon)
{
    return BoxPokemon_IconPaletteIndex((const BoxPokemon *)Pokemon_GetBoxPokemon(mon));
}

u32 PokeIconPalettesFileIndex(void)
{
    return shared_pals_NCLR;
}

u32 PokeIconCellsFileIndex(void)
{
    return shared_cell_NCER;
}

u32 PokeIcon32KCellsFileIndex(void)
{
    return shared_cell_32k_NCER;
}

u32 PokeIcon64KCellsFileIndex(void)
{
    return shared_cell_64k_NCER;
}

u32 PokeIconAnimationFileIndex(void)
{
    return shared_anim_NANR;
}

u32 PokeIcon32KAnimationFileIndex(void)
{
    return shared_anim_32k_NANR;
}

u32 PokeIcon64KAnimationFileIndex(void)
{
    return shared_anim_64k_NANR;
}
