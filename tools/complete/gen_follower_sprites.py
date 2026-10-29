#!/usr/bin/env python3
"""Bring HeartGold's walking (following) Pokémon sprites into the engine as overworld sprites.

For each species asked for, this takes HeartGold's walking sprite from the HeartGold source (built by
tools/complete/build_heartgold.sh into .cache/pokeheartgold), turns it into a Platinum overworld sprite and registers
it:

- HeartGold's sprite (data/mmodel, the SPRITE_FOLLOWER_MON_* entries of asm/overlay_01_sprite_data.s) is a BTX0 file
  of 8 frames, two per direction in the order up, down, left, right, with a normal and a shiny palette. Platinum's
  walking sprites have four frames per direction in the same order and loop through them, so each pair becomes
  A, B, A, B. The PNG goes to res/graphics/field_sprites/pokemon/follower/ (normal palette).
- 32x32 sprites use BILLBOARD_MODEL_GENERIC_32x32 and 64x64 ones BILLBOARD_MODEL_GENERIC_64x64, both with the generic
  walk, a shadow, footprints and a reflection, like Platinum's own walking Pokémon (Pikachu) and Sovereign's Totems.
- It writes OBJ_EVENT_GFX_FOLLOWER_<SPECIES> to generated/object_events_gfx.txt, the four tables of
  src/overlay005/object_event_gfx_data.c, field_sprites.order and the field sprites' meson.build, and the species
  table in src/complete_follower_gfx.h.

Every insertion sits between "Sovereign Complete: following Pokémon" markers and is rewritten on each run, so the
script can be run again after changing the list.

Prototype: every table entry costs field-overlay RAM, so only the species listed are added. The full set (627 sprites
with female and form variants) needs a range-based lookup instead of four table entries each.

Usage: python3 tools/complete/gen_follower_sprites.py [SPECIES ...]   (names as in SPECIES_*, e.g. GARCHOMP)
"""
import os
import re
import sys

from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from nsbtx_to_png import decode  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
HGSS = os.path.join(ROOT, '.cache', 'pokeheartgold')

PROTOTYPE = ['GARCHOMP', 'TURTWIG', 'STARLY', 'GALLADE', 'PIKACHU']

BEGIN = 'Sovereign Complete: following Pokémon (tools/complete/gen_follower_sprites.py)'
END = 'Sovereign Complete: end of following Pokémon'


def hgss_sprite_paths():
    """{species name: mmodel NSBTX path} for HeartGold's walking sprites (normal form, male/default only)."""
    mmodel = {}
    for line in open(os.path.join(HGSS, 'include/constants/mmodel.h')):
        m = re.match(r'#define MMODEL_FOLLOWER_MON_(\w+)\s+(\d+)', line)
        if m:
            mmodel[m.group(1)] = int(m.group(2))
    paths = {}
    for line in open(os.path.join(HGSS, 'asm/overlay_01_sprite_data.s')):
        m = re.search(r'SPRITE_FOLLOWER_MON_(\w+), MMODEL_FOLLOWER_MON_(\w+)', line)
        if m and m.group(2) in mmodel:
            paths[m.group(1)] = os.path.join(HGSS, f'files/data/mmodel/mmodel/mmodel_{mmodel[m.group(2)]:08d}.NSBTX')
    return paths


def convert(nsbtx, png):
    """Write Platinum's 16-frame walking sheet from HeartGold's 8 frames. Returns the frame size."""
    frames, palettes = decode(nsbtx)
    assert len(frames) == 8, f'{nsbtx}: expected 8 frames, found {len(frames)}'
    size = frames[0][1]
    assert all(f[1] == size and f[2] == size for f in frames), f'{nsbtx}: frames differ in size'
    normal = next(colours for name, colours in palettes.items() if name.endswith('0'))
    sheet = Image.new('P', (size, size * 16))
    sheet.putpalette([c for rgb in normal for c in rgb])
    for direction in range(4):
        a, b = frames[2 * direction][3], frames[2 * direction + 1][3]
        for step, pixels in enumerate((a, b, a, b)):
            frame = Image.new('P', (size, size))
            frame.putdata(pixels)
            sheet.paste(frame, (0, (direction * 4 + step) * size))
    sheet.save(png, transparency=0)
    return size


def replace_block(text, block, before, comment='//', indent='', tag='list'):
    """Put block (lines) between the markers named by tag, replacing an earlier block with that tag, or insert it
    before the line holding `before`. Each block in a file needs its own tag."""
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
    wanted = [s.upper() for s in sys.argv[1:]] or PROTOTYPE
    sources = hgss_sprite_paths()
    missing = [s for s in wanted if s not in sources]
    if missing:
        sys.exit(f'No HeartGold walking sprite for: {", ".join(missing)}')

    out_dir = os.path.join(DECOMP, 'res/graphics/field_sprites/pokemon/follower')
    os.makedirs(out_dir, exist_ok=True)
    sprites = []
    for i, species in enumerate(wanted, 1):
        stem = f'follower_{species.lower()}'
        size = convert(sources[species], os.path.join(out_dir, stem + '.png'))
        sprites.append((species, stem, size, f'scfol{i:03d}'))
        print(f'{species}: {size}x{size} -> pokemon/follower/{stem}.png')

    gfx = lambda species: f'OBJ_EVENT_GFX_FOLLOWER_{species}'  # noqa: E731
    model = {32: 'BILLBOARD_MODEL_GENERIC_32x32', 64: 'BILLBOARD_MODEL_GENERIC_64x64'}
    # The first table's per-size setup: Platinum's Pikachu (32x32) and Regigigas (64x64).
    unk = {32: '&Unk_ov5_021FAFD8', 64: '&Unk_ov5_021FB0A0'}

    edit('generated/object_events_gfx.txt', lambda t: replace_block(
        t, [gfx(s) for s, *_ in sprites], 'OBJ_EVENT_GFX_BERRY_SPROUT', comment='#'))

    def tables(text):
        text = replace_block(text, [f'{{ {gfx(s)}, {unk[size]} }},' for s, _, size, _ in sprites],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, NULL }', indent='    ', tag='graphics')
        text = replace_block(text, [f'{{ {gfx(s)}, {stem}_nsbtx }},' for s, stem, _, _ in sprites],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, 0 }', indent='    ', tag='textures')
        text = replace_block(text, [f'{{ {gfx(s)}, {model[size]}, BILLBOARD_FRAME_SEQ_GENERIC_WALK, sWalkBillboardAnims }},'
                                    for s, _, size, _ in sprites],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, BILLBOARD_MODEL_SENTINEL_ID', indent='    ', tag='billboards')
        text = replace_block(text, [f'{{ {gfx(s)}, MODEL_TYPE_BILLBOARD, .hasShadow = TRUE, TRACK_TYPE_FOOTSTEPS, '
                                    '.hasReflection = TRUE },' for s, *_ in sprites],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, 0, 0, 0, 0 }', indent='    ', tag='model types')
        return text
    edit('src/overlay005/object_event_gfx_data.c', tables)

    def order(text):
        lines = [line for line in text.splitlines() if not line.startswith('follower_')]
        return '\n'.join(lines + [f'{stem}.nsbtx' for _, stem, _, _ in sprites]) + '\n'
    edit('res/graphics/field_sprites/field_sprites.order', order)

    def meson(text):
        entries = []
        for px in (32, 64):
            entries.append(f"field_sprites_textures_complete_followers_{px} = [")
            entries += [f"    {{ 'file': 'pokemon/follower/{stem}.png', 'basename': '{base}'}},"
                        for _, stem, size, base in sprites if size == px]
            entries.append(']')
        for px in (32, 64):
            entries += [
                f'foreach texture : field_sprites_textures_complete_followers_{px}',
                '    field_sprites_nsbtxs += custom_target(',
                "        input: files(texture['file']),",
                '        build_subdir: field_sprites_private_dir,',
                "        output: '@BASENAME@.nsbtx',",
                "        command: [nitrobtx_exe, 'pack', '--texture', '@INPUT@', '--name', texture['basename'],",
                f"                  '--spritesheet', '--frame-height', '{px}', '--extract-palette', '@OUTPUT@'],",
                '    )',
                'endforeach',
            ]
        return replace_block(text, entries, 'foreach texture : field_sprites_textures_32_px_single_palette',
                             comment='#')
    edit('res/graphics/field_sprites/meson.build', meson)

    header = os.path.join(DECOMP, 'src/complete_follower_gfx.h')
    with open(header, 'w') as f:
        f.write('// Generated by tools/complete/gen_follower_sprites.py: the walking sprite of each species that has one.\n')
        f.write('static const struct { u16 species; u16 graphicsID; } sFollowerGfx[] = {\n')
        for species, *_ in sprites:
            f.write(f'    {{ SPECIES_{species}, {gfx(species)} }},\n')
        f.write('};\n')
    print(f'{len(sprites)} walking sprites registered')


if __name__ == '__main__':
    main()
