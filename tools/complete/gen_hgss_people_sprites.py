#!/usr/bin/env python3
"""Bring HeartGold's people (and its other walking overworld sprites) into the engine as overworld sprites.

Johto's and Kanto's people were drawn with Platinum stand-ins until now (tools/complete/import_hgss_events.py: Misty and
Whitney as Crasher Wake, Silver as Barry, Team Rocket as Team Galactic). This converts HeartGold's own sprites, from the
HeartGold source (built by tools/complete/build_heartgold.sh into .cache/pokeheartgold), and registers them:

- Which: every sprite of HeartGold's list (include/constants/sprites.h, its graphics in asm/overlay_01_sprite_data.s)
  drawn as a 32x32 walker of 16 frames (four per direction, in Platinum's order, so the frames are stacked as they
  are), from number 146 on (the ones Diamond and Pearl's list doesn't share; below that Platinum has the same art);
  Elm (DOCTOR, 99, Rowan's number in Platinum); the Pokémon Center nurse (PCWOMAN1, 17 frames: her bow); and Ethan
  and Lyra (HERO 0 and HEROINE 97, 32 frames: walking and running, as Platinum's player), for the friend, and the
  player in the Rocket uniform (RHERO and RHEROINE, the same, which the player wears in the Radio Tower); and its
  one-frame objects, 32x32 or 64x64 (the League's doors, Route 11's Snorlax, the shop signs, the medal, the scroll,
  the player's statues), drawn as Platinum's bollard and Regigigas are; its invisible blockers (FIXED) are
  Platinum's invisible object. Not the following Pokémon
  (gen_follower_sprites.py), the 3D gimmicks HeartGold draws as models (their table entries point at BABYBOY1's
  art), Mahogany Gym's ice blocks (ICE: src/complete_gyms.c knows them by Platinum's ICE_ROCK), the player's own
  states (bike, surf, ladder...). The Apricorn trees are still, bare or with their fruit (SKIP's note).
- A sprite whose frames are pixel for pixel one of Platinum's walkers uses Platinum's, and sprites sharing one
  graphics file share one ID, so each table entry is new art.
- Each becomes OBJ_EVENT_GFX_HGSS_<NAME> = HGSS_BASE + its HeartGold number in generated/object_events_gfx.txt: fixed
  numbers, since graphics IDs are saved with the map's objects; a PNG in res/graphics/field_sprites/npc/hgss/ (its
  one palette); the field sprites' meson.build and field_sprites.order; and the four tables of
  src/overlay005/object_event_gfx_data.c, copied from the Youngster's (the nurse's from Platinum's nurse, Ethan's and
  Lyra's from the player's). Each entry costs 40 bytes of the field overlay.
- The mapping from HeartGold's sprite names to the engine's IDs goes to data/complete/hgss_sprites.json, which
  import_hgss_events.py and translate_hgss_scripts.py read.

Every insertion sits between "Sovereign Complete: HeartGold's people" markers and is rewritten on each run.

Usage: python3 tools/complete/gen_hgss_people_sprites.py
"""
import json
import os
import re
import struct
import sys

from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from nsbtx_to_png import decode  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
HGSS = os.path.join(ROOT, '.cache', 'pokeheartgold')
SPRITES = os.path.join(DECOMP, 'res', 'graphics', 'field_sprites')
MAPPING = os.path.join(ROOT, 'data', 'complete', 'hgss_sprites.json')

HGSS_BASE = 1024  # OBJ_EVENT_GFX_HGSS_<NAME> = HGSS_BASE + HeartGold's number (below BERRY_SPROUT's 4096)
SHARED = 146  # Diamond and Pearl's list, which both games kept
EXTRA = {'DOCTOR': 16, 'HERO': 32, 'HEROINE': 32,  # below SHARED, with HeartGold's own art: Elm, Ethan and Lyra
         'RHERO': 32, 'RHEROINE': 32}  # and the player in the Rocket uniform (src/complete_scrcmd.c's costume)
SKIP = {'ICE', 'FISHINGHERO', 'FISH_HEROINE'}  # Mahogany Gym's ice blocks stay Platinum's ICE_ROCK, which
# src/complete_gyms.c pushes; the player's fishing (the player is Platinum's). The Apricorn trees (BONGURI, bare,
# and BONGURI_R .. _BK, with each colour's fruit) are their first frame, still: src/complete_apricorns.c shows the
# fruit until the tree is picked. The Apricorns themselves (BONMI*) aren't shown on the field.
# Per frame count and size: the first table's renderer, the billboard's model, frame sequence and animations
# (Platinum's Youngster, its Pokémon Center nurse, its player, and its one-frame bollard and Regigigas)
# HeartGold's invisible blockers: STOP objects stand around Lugia's and the Ampharos's big sprites and across closed
# ways, sharing their hide flags (Whirl Islands' share Lugia's), so they block without being seen: Platinum's
# invisible object does the same
FIXED = {'STOP': 'OBJ_EVENT_GFX_INVISIBLE'}
KINDS = {(16, 32): ('&Unk_ov5_021FAFD8', 'GENERIC_32x32', 'BILLBOARD_FRAME_SEQ_GENERIC_WALK', 'sWalkBillboardAnims'),
         (17, 32): ('&Unk_ov5_021FB08C', 'GENERIC_32x32', 'BILLBOARD_FRAME_SEQ_POKECENTER_NURSE',
                    'sPokecenterNurseBillboardAnims'),
         (32, 32): ('&Unk_ov5_021FB0F0', 'GENERIC_32x32', 'BILLBOARD_FRAME_SEQ_WALK_AND_RUN', 'sWalkRunBillboardAnims'),
         (1, 32): ('&Unk_ov5_021FAFD8', 'GENERIC_32x32', 'BILLBOARD_FRAME_SEQ_GENERIC_WALK', 'sWalkBillboardAnims'),
         (1, 64): ('&Unk_ov5_021FB0A0', 'GENERIC_64x64', 'BILLBOARD_FRAME_SEQ_GENERIC_WALK', 'sWalkBillboardAnims')}

BEGIN = "Sovereign Complete: HeartGold's people (tools/complete/gen_hgss_people_sprites.py)"
END = "Sovereign Complete: end of HeartGold's people"


def hgss_sprites():
    """[(number, name, mmodel NSBTX path)] in HeartGold's sprite table's order, the first entry for each number."""
    mmodel = {}
    for line in open(os.path.join(HGSS, 'include/constants/mmodel.h')):
        m = re.match(r'#define (MMODEL_\w+)\s+(\d+)', line)
        if m:
            mmodel[m.group(1)] = int(m.group(2))
    numbers = {}
    for line in open(os.path.join(HGSS, 'include/constants/sprites.h')):
        m = re.match(r'#define SPRITE_(\w+)\s+(0x[0-9A-Fa-f]+|\d+)\b', line)
        if m:
            numbers.setdefault(m.group(1), int(m.group(2), 0))
    sprites, seen = [], set()
    for line in open(os.path.join(HGSS, 'asm/overlay_01_sprite_data.s')):
        m = re.search(r'\.short SPRITE_(\w+), (MMODEL_\w+),', line)
        if not m or m.group(1) not in numbers or numbers[m.group(1)] in seen:
            continue
        name, model = m.group(1), m.group(2)
        seen.add(numbers[name])
        if model not in mmodel or name.startswith(('FOLLOWER_MON_', 'BONMI')) or name in SKIP \
                or model == 'MMODEL_BABYBOY1' and name != 'BABYBOY1':  # a 3D gimmick (ov01_022073D8's list)
            continue
        path = os.path.join(HGSS, f'files/data/mmodel/mmodel/mmodel_{mmodel[model]:08d}.NSBTX')
        sprites.append((numbers[name], name, path))
    return sprites


def sheet(path, first_only=False):
    """HeartGold's frames stacked into Platinum's sheet, and its kind (frame count, size), or None for a sprite
    that isn't one palette's square frames of one size; with first_only, its first frame in its first palette."""
    try:
        frames, palettes = decode(path)
    except (ValueError, IndexError, AssertionError, KeyError, struct.error):
        return None
    if first_only and frames:
        frames, palettes = frames[:1], dict(list(palettes.items())[:1])
    if len(palettes) != 1 or not frames:
        return None
    size = frames[0][1]
    if any(f[1] != size or f[2] != size for f in frames):
        return None
    palette = next(iter(palettes.values()))
    image = Image.new('P', (size, size * len(frames)))
    image.putpalette([c for rgb in palette for c in rgb])
    for i, frame in enumerate(frames):
        tile = Image.new('P', (size, size))
        tile.putdata(frame[3])
        image.paste(tile, (0, size * i))
    image.info['transparency'] = 0
    return image, (len(frames), size)


def rgba(image):
    return image.convert('RGBA').tobytes()


def platinum_walkers():
    """{RGBA bytes: OBJ_EVENT_GFX_* name} for Platinum's own 32x32 sheets (the npc and player folders), from the
    texture table's names (src/overlay005/object_event_gfx_data.c) and the build's file list."""
    files = dict(re.findall(r"\{ 'file': '([^']+\.png)', 'basename': '(\w+)'", open(os.path.join(SPRITES, 'meson.build')).read()))
    by_stem = {os.path.splitext(os.path.basename(f))[0]: f for f in files}
    table = open(os.path.join(DECOMP, 'src/overlay005/object_event_gfx_data.c')).read()
    known = {}
    for gfx, stem in re.findall(r'\{ (OBJ_EVENT_GFX_\w+), (\w+)_nsbtx \}', table):
        # (not the player's own textures from import_hgss_player.py: they're HeartGold's Ethan, kept as HERO)
        if stem in by_stem and not stem.startswith('hgss_') and '/complete/' not in by_stem[stem] \
                and gfx not in known.values():
            path = os.path.join(SPRITES, by_stem[stem])
            if os.path.exists(path):
                image = Image.open(path)
                if image.size[0] == 32:
                    known.setdefault(rgba(image), gfx)
    return known


def replace_block(text, block, before, comment='//', indent='', tag='list'):
    """Put block (lines) between the markers named by tag, replacing an earlier block with that tag, or insert it
    before the line holding `before`."""
    body = ''.join(f'{indent}{line}\n' for line in block)
    begin, end = f'{BEGIN} [{tag}]', f'{END} [{tag}]'
    marked = f'{indent}{comment} {begin}\n{body}{indent}{comment} {end}\n'
    pattern = re.compile(rf'[ \t]*{re.escape(comment)} {re.escape(begin)}\n.*?{re.escape(comment)} {re.escape(end)}\n',
                         re.S)
    if pattern.search(text):
        return pattern.sub(lambda _: marked, text, count=1)
    index = text.index(before)
    index = text.rfind('\n', 0, index) + 1
    return text[:index] + marked + text[index:]


def edit(path, change):
    full = os.path.join(DECOMP, path)
    text = open(full).read()
    new = change(text)
    if new != text:
        open(full, 'w').write(new)


def main():
    out_dir = os.path.join(SPRITES, 'npc', 'hgss')
    os.makedirs(out_dir, exist_ok=True)
    for old in os.listdir(out_dir):
        if old.endswith('.png'):
            os.remove(os.path.join(out_dir, old))
    platinum = platinum_walkers()
    mapping, sprites, art = {}, [], {}
    for number, name, path in hgss_sprites():
        if name in FIXED:
            mapping[name] = FIXED[name]
            continue
        if number < SHARED and name not in EXTRA:
            continue
        converted = sheet(path, name.startswith('BONGURI'))
        if converted is None or converted[1] not in KINDS or EXTRA.get(name, converted[1][0]) != converted[1][0] \
                or converted[1][0] == 32 and name not in EXTRA:  # the player's own states (running, the Pokéathlon)
            continue
        image, kind = converted
        key = rgba(image)
        if key in platinum:  # the same art as one of Platinum's
            mapping[name] = platinum[key]
            continue
        if key in art:  # the same art as an earlier HeartGold sprite
            mapping[name] = art[key]
            continue
        stem, gfx = f'hgss_{name.lower()}', f'OBJ_EVENT_GFX_HGSS_{name}'
        image.save(os.path.join(out_dir, stem + '.png'), transparency=0)
        art[key] = mapping[name] = gfx
        sprites.append((number, name, stem, gfx, kind))
    print(f'{len(sprites)} HeartGold sprites converted, {len(mapping) - len(sprites)} the same as another\'s')

    edit('generated/object_events_gfx.txt', lambda t: replace_block(
        t, [f'{gfx} = {HGSS_BASE + number}' for number, _, _, gfx, _ in sprites], 'OBJ_EVENT_GFX_BERRY_SPROUT',
        comment='#'))

    def tables(text):
        text = replace_block(text, [f'{{ {gfx}, {KINDS[kind][0]} }},' for _, _, _, gfx, kind in sprites],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, NULL }', indent='    ', tag='graphics')
        text = replace_block(text, [f'{{ {gfx}, {stem}_nsbtx }},' for _, _, stem, gfx, _ in sprites],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, 0 }', indent='    ', tag='textures')
        text = replace_block(text, [f'{{ {gfx}, BILLBOARD_MODEL_{KINDS[kind][1]}, {KINDS[kind][2]}, {KINDS[kind][3]} }},'
                                    for _, _, _, gfx, kind in sprites],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, BILLBOARD_MODEL_SENTINEL_ID', indent='    ', tag='billboards')
        text = replace_block(text, [f'{{ {gfx}, MODEL_TYPE_BILLBOARD, .hasShadow = TRUE, TRACK_TYPE_FOOTSTEPS, '
                                    '.hasReflection = TRUE },' if kind[0] > 1 else  # a still (a door, a sign) neither
                                    f'{{ {gfx}, MODEL_TYPE_BILLBOARD, .hasShadow = FALSE, TRACK_TYPE_NONE, '
                                    '.hasReflection = FALSE },' for *_, gfx, kind in sprites],  # walks nor casts shadow
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, 0, 0, 0, 0 }', indent='    ', tag='model types')
        return text
    edit('src/overlay005/object_event_gfx_data.c', tables)

    def order(text):
        lines = [line for line in text.splitlines() if not line.startswith('hgss_')]
        return '\n'.join(lines + [f'{stem}.nsbtx' for _, _, stem, _, _ in sprites]) + '\n'
    edit('res/graphics/field_sprites/field_sprites.order', order)

    def meson(text):
        entries = []
        for still, (listed, sheet_args) in enumerate((
                ('people', "'--spritesheet', '--frame-height', '32', "),  # walkers: Platinum's 32-pixel sheets
                ('stills', ''))):  # one frame: Platinum's single-frame textures (its bollard)
            entries.append(f'field_sprites_textures_complete_hgss_{listed} = [')
            entries += [f"    {{ 'file': 'npc/hgss/{stem}.png', 'basename': 'hg{number:03d}'}},"
                        for number, _, stem, _, kind in sprites if (kind[0] == 1) == bool(still)]
            entries += [']',
                        f'foreach texture : field_sprites_textures_complete_hgss_{listed}',
                        '    field_sprites_nsbtxs += custom_target(',
                        "        input: files(texture['file']),",
                        '        build_subdir: field_sprites_private_dir,',
                        "        output: '@BASENAME@.nsbtx',",
                        "        command: [nitrobtx_exe, 'pack', '--texture', '@INPUT@', '--name', texture['basename'],",
                        f"                  {sheet_args}'--extract-palette', '@OUTPUT@'],",
                        '    )',
                        'endforeach']
        return replace_block(text, entries, 'foreach texture : field_sprites_textures_32_px_single_palette',
                             comment='#')
    edit('res/graphics/field_sprites/meson.build', meson)

    os.makedirs(os.path.dirname(MAPPING), exist_ok=True)
    with open(MAPPING, 'w') as f:
        json.dump({'_comment': 'Generated by tools/complete/gen_hgss_people_sprites.py: HeartGold sprite name -> '
                               "the engine's graphics ID, for import_hgss_events.py and translate_hgss_scripts.py",
                   'sprites': dict(sorted(mapping.items()))}, f, indent=2)
        f.write('\n')


if __name__ == '__main__':
    main()
