#!/usr/bin/env python3
"""Box, PC and party icons from Pokémon Showdown for every Pokémon (the owner's call, Nov 6, 2026: "why can't we just
use Showdown's box sprite for every Pokémon").

Showdown's icon sheet (https://play.pokemonshowdown.com/sprites/pokemonicons-sheet.png: 40x30 cells, 12 to a row, a
species' cell at its National Pokédex number; the forms' cells are named in battle-dex-data.js's
BattlePokemonIconIndexes) is converted to the game's icons as Sovereign's placeholders were
(tools/sprites/make_placeholder_icons.py): each icon cropped to its art, scaled down only if wider or taller than 30
pixels, set bottom-centre in a 32x32 frame, and drawn in whichever of the three shared icon palettes
(res/pokemon/.shared/pl_poke_icon.pal) matches it best; the second frame is the first a pixel higher (the bounce), and
the PNG is 4-bit, as the icon NARC needs.

This writes decomp/res/pokemon/<species>/icon.png and the palette number in its data.json ("icon_palette") for
#1-1025 (Minior, Maushold and Xerneas take the icon of the form they have as form 0). Each of Sovereign's forms
(include/data/sovereign_forms.h, in its packing order, from tools/engine/gen_forms.py) gets its own icon in its folder,
res/pokemon/<species>/forms/<form>/icon.png: Showdown's icon for the form (FORM_KEYS where its name isn't the form's),
or its species' where Showdown has none (Pumpkaboo's sizes, Spiky-eared Pichu...). They're listed in that order in
res/pokemon/complete_form_icons.txt, which the icon archive appends after Platinum's own forms' icons, and their
palettes are packed in include/data/complete_form_icons.h (src/pokemon_icon.c). The data files are Sovereign's, which
JSON can't mark with a comment: this script is the record; a sync's three-way patch keeps the edits, but rerun it if a
sync clashes on those lines (and after gen_forms.py changes the forms). The two downloads are kept in .cache/showdown.

Usage: python3 tools/complete/import_showdown_icons.py [DEX ...]
"""
import os
import re
import subprocess
import sys

from PIL import Image

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'sprites'))
from make_placeholder_icons import FRAME, fit, load_palettes, quantise  # noqa: E402

DECOMP = os.path.join(ROOT, 'decomp')
CACHE = os.path.join(ROOT, '.cache', 'showdown')
SHEET_URL = 'https://play.pokemonshowdown.com/sprites/pokemonicons-sheet.png'
DATA_URL = 'https://play.pokemonshowdown.com/js/battle-dex-data.js'
CELL_W, CELL_H, PER_ROW = 40, 30, 12
DEX = {}  # SPECIES_ constant: number
LAST_DEX = 1025
# Species whose form 0 is another of Showdown's icons than its plain one
SPECIES_KEYS = {'minior': 'miniormeteor', 'maushold': 'mausholdfour', 'xerneas': 'xerneasneutral'}
# Forms whose Showdown name isn't made from their own (by their name in sovereign_forms.h); None: the species' icon
FORM_KEYS = {
    'Mega Meowstic (Male)': 'meowsticmmega', 'Mega Meowstic (Female)': 'meowsticfmega',
    'Mega Tatsugiri (Curly Form)': 'tatsugiricurlymega', 'Mega Tatsugiri (Droopy Form)': 'tatsugiridroopymega',
    'Mega Tatsugiri (Stretchy Form)': 'tatsugiristretchymega',
    'Wellspring Mask Ogerpon': 'ogerponwellspring', 'Hearthflame Mask Ogerpon': 'ogerponhearthflame',
    'Cornerstone Mask Ogerpon': 'ogerponcornerstone',
    'Dusk Necrozma': 'necrozmaduskmane', 'Dawn Necrozma': 'necrozmadawnwings', 'Ultra Necrozma': 'necrozmaultra',
    'Standard Galarian Darmanitan': 'darmanitangalar',
    'Paldean Tauros (Combat Breed)': 'taurospaldeacombat', 'Paldean Tauros (Blaze Breed)': 'taurospaldeablaze',
    'Paldean Tauros (Aqua Breed)': 'taurospaldeaaqua',
    'Totem Alolan Raticate': 'raticatealolatotem', 'Totem Alolan Marowak': 'marowakalolatotem',
    'Totem Disguised Mimikyu': 'mimikyutotem', 'Totem Busted Mimikyu': 'mimikyubustedtotem', 'Busted Mimikyu': None,
    'Red Core Minior': 'minior',
    '10% Zygarde': 'zygarde10', '50% Zygarde': None, 'Complete Zygarde': 'zygardecomplete',
    'Battle Bond Greninja': 'greninjabond', 'Rapid Strike Urshifu': None,
    'Female Meowstic': 'meowsticf', 'Female Indeedee': 'indeedeef', 'Female Basculegion': 'basculegionf',
    'Female Oinkologne': 'oinkolognef',
    'Blue Plumage Squawkabilly': 'squawkabillyblue', 'Yellow Plumage Squawkabilly': 'squawkabillyyellow',
    'White Plumage Squawkabilly': 'squawkabillywhite',
    'Maushold (Family of Three)': 'maushold', 'Xerneas (Active Mode)': 'xerneas',
}


def download(url, name):
    path = os.path.join(CACHE, name)
    if not os.path.exists(path):
        os.makedirs(CACHE, exist_ok=True)
        subprocess.run(['curl', '-sSfL', '-o', path, url], check=True)
    return path


def cell(sheet, index):
    """The icon at a cell of the sheet, its background made transparent."""
    x, y = (index % PER_ROW) * CELL_W, (index // PER_ROW) * CELL_H
    im = sheet.crop((x, y, x + CELL_W, y + CELL_H)).convert('RGBA')
    return im if im.getbbox() else None


def to_icon(art, palettes):
    """(the 32x64 two-frame 4-bit icon, its palette number)"""
    frame = fit(art, True)
    best = min(range(len(palettes)), key=lambda k: quantise(frame, palettes[k])[1])
    indices, _ = quantise(frame, palettes[best])
    first = Image.new('P', (FRAME, FRAME))
    first.putdata(indices)
    icon = Image.new('P', (FRAME, FRAME * 2), 0)
    icon.paste(first, (0, 0))
    icon.paste(first, (0, FRAME - 1))  # the second frame: a pixel higher
    flat = [c for colour in palettes[best] for c in colour]
    icon.putpalette(flat + [0] * (48 - len(flat)))
    return icon, best


def icon_keys():
    """{Showdown's name for an icon: its cell}"""
    text = open(download(DATA_URL, 'battle-dex-data.js'), encoding='utf-8').read()
    block = text[text.index('BattlePokemonIconIndexes'):]
    block = block[:block.index('};')]
    return {k: eval(v) for k, v in re.findall(r'([a-z0-9]+):\s*([0-9+ ]+)', block)}


def form_key(form, keys):
    """Showdown's name for a Sovereign form's icon, or None for its species' icon."""
    name, stem = form['name'], form['stem'].replace('_', '')
    if name in FORM_KEYS:
        return FORM_KEYS[name]  # a species' own name: its cell at its number
    m = re.match(r'(\w+) Meteor Minior$', name)
    if m:
        return 'miniormeteor'
    m = re.match(r'(\w+) Cap Pikachu$', name)
    if m:
        return 'pikachu' + m.group(1).lower()
    m = re.match(r'Alcremie \((\w+) (Cream|Swirl), \w+ Sweet\)$', name)
    if m:
        key = 'alcremie' + (m.group(1) + m.group(2)).lower()
        return key if key in keys else None
    if form.get('ident'):
        key = form['ident'].replace('-', '')
    elif name.startswith('Mega '):
        last = name.split()[-1]
        key = stem + 'mega' + (last.lower() if last in ('X', 'Y', 'Z') else '')
    elif name.startswith('Primal '):
        key = stem + 'primal'
    else:
        key = None
    return key if key in keys else None


def form_icons(sheet, palettes, keys):
    """Each Sovereign form's icon, in packing order; the list for the build and the palettes' header."""
    sys.path.insert(0, os.path.join(ROOT, 'tools', 'engine'))
    from gen_forms import load_rows
    forms = load_rows()
    paths, packed, own = [], [0] * ((len(forms) + 3) // 4), 0
    for i, form in enumerate(forms):
        key = form_key(form, keys)
        own += key is not None
        if key:
            index = keys[key] if key in keys else DEX['SPECIES_' + key.upper()]
        else:  # its species' icon
            index = keys[SPECIES_KEYS[form['stem']]] if form['stem'] in SPECIES_KEYS else DEX[form['species']]
        art = cell(sheet, index)
        icon, palette = to_icon(art, palettes)
        path = os.path.join('res', 'pokemon', form['stem'], 'forms', form['dir'], 'icon.png')
        icon.save(os.path.join(DECOMP, path), bits=4)
        paths.append(os.path.relpath(path, os.path.join('res', 'pokemon')))
        packed[i // 4] |= palette << (i % 4 * 2)
    open(os.path.join(DECOMP, 'res', 'pokemon', 'complete_form_icons.txt'), 'w').write('\n'.join(paths) + '\n')
    rows = ',\n'.join('    ' + ', '.join(f'0x{b:02X}' for b in packed[k:k + 12]) for k in range(0, len(packed), 12))
    open(os.path.join(DECOMP, 'include', 'data', 'complete_form_icons.h'), 'w').write(f"""\
// Generated by tools/complete/import_showdown_icons.py. Do not edit.
#ifndef POKEPLATINUM_DATA_COMPLETE_FORM_ICONS_H
#define POKEPLATINUM_DATA_COMPLETE_FORM_ICONS_H

#include "constants/sovereign_forms.h"

// Sovereign Complete: each Sovereign form's icon follows Platinum's own forms' in the icon archive, in
// sSovereignForms' packing order (res/pokemon/complete_form_icons.txt); its palette, two bits each, four to a byte
#define COMPLETE_FORM_ICON_COUNT {len(forms)}
#if COMPLETE_FORM_ICON_COUNT != SOVEREIGN_FORM_COUNT
#error "rerun tools/complete/import_showdown_icons.py: the forms changed"
#endif

static const u8 sCompleteFormIconPalettes[{len(packed)}] = {{
{rows}
}};

#endif // POKEPLATINUM_DATA_COMPLETE_FORM_ICONS_H
""")
    return len(forms), own


def main():
    global DEX
    wanted = {int(a) for a in sys.argv[1:]}
    sheet = Image.open(download(SHEET_URL, 'pokemonicons-sheet.png')).convert('RGBA')
    palettes = load_palettes()
    keys = icon_keys()
    species = open(os.path.join(DECOMP, 'generated', 'species.txt')).read().split()
    DEX = {name: n for n, name in enumerate(species)}
    done, missing = 0, []
    for dex in range(1, LAST_DEX + 1):
        if wanted and dex not in wanted:
            continue
        stem = species[dex][len('SPECIES_'):].lower()
        folder = os.path.join(DECOMP, 'res', 'pokemon', stem)
        art = cell(sheet, keys[SPECIES_KEYS[stem]] if stem in SPECIES_KEYS else dex)
        if art is None or not os.path.isdir(folder):
            missing.append(dex)
            continue
        icon, palette = to_icon(art, palettes)
        icon.save(os.path.join(folder, 'icon.png'), bits=4)
        data = os.path.join(folder, 'data.json')
        text = open(data, encoding='utf-8').read()
        new = re.sub(r'("icon_palette": )\d+', rf'\g<1>{palette}', text, count=1)
        if new != text:
            open(data, 'w', encoding='utf-8').write(new)
        done += 1
    print(f'{done} icons from Showdown' + (f'; none for {missing}' if missing else ''))
    if not wanted:
        count, own = form_icons(sheet, palettes, keys)
        print(f'{count} forms\' icons, {own} of them their own')


if __name__ == '__main__':
    main()
