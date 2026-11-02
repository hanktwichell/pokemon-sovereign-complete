#!/usr/bin/env python3
"""Bring all of HeartGold's walking (following) Pokémon sprites into the engine, as one range of overworld sprites.

HeartGold has 566 walking sprites (SPRITE_FOLLOWER_MON_BULBASAUR, 428, to SPRITE_FOLLOWER_MON_ARCEUS_DARK, 993): one
per species up to Arceus, with its female variants, Unown's letters, Arceus's types and the other forms. This takes
them from the HeartGold source (built by tools/complete/build_heartgold.sh into .cache/pokeheartgold) and registers
them as a range of graphics IDs, so the field overlay doesn't need four table entries for each:

- Each sprite (data/mmodel, the SPRITE_FOLLOWER_MON_* entries of asm/overlay_01_sprite_data.s) is a BTX0 file of 8
  frames, two per direction in the order up, down, left, right, with a normal and a shiny palette. Platinum's walking
  sprites have four frames per direction in the same order and loop through them, so each pair becomes A, B, A, B.
  The PNGs go to res/graphics/field_sprites/pokemon/follower/follower_NNN.png (the normal palette), NNN the sprite's
  place in the range, and into field_sprites.order one after another, so the k-th sprite's texture is the first's
  NARC member + k.
- generated/object_events_gfx.txt gets OBJ_EVENT_GFX_HGSS_MON_<NAME> = FIRST + k (FIRST 2048, fixed, as graphics IDs
  are saved), for the maps' Pokémon standing about (tools/complete/import_hgss_events.py).
- src/overlay005/object_event_gfx_data.c gets entries for two of them only, the first 32x32 one and the first 64x64
  one: the templates. src/complete_follower.c's CompleteFollower_TemplateGfx turns any ID in the range into its
  size's template for the renderer, billboard and model-type lookups (src/map_object.c, src/overlay005/
  ov5_021ECE40.c, ov5_021ECC20.c), and CompleteFollower_GfxNarcIndex gives its texture's NARC member for the texture
  lookups (ov5_021ECE40.c). Both use src/complete_follower_gfx.h, written here: which sprites are 64x64, and per
  species (HeartGold's sModelIndexLUT, sFormMaxLUT and sFemaleFlagLUT, src/follow_mon.c) its first sprite, its forms
  and whether a female one follows, as HeartGold's FollowMon_GetSpriteID reads them, and HeartGold's "too tall" flag
  (files/fielddata/tsurepoke/tp_param.csv): those stay in their ball on maps that only let small Pokémon follow.
- 32x32 sprites use BILLBOARD_MODEL_GENERIC_32x32 and 64x64 ones BILLBOARD_MODEL_GENERIC_64x64, both with the generic
  walk, a shadow, footprints and a reflection, like Platinum's own walking Pokémon (Pikachu) and Sovereign's Totems.

Every insertion sits between "Sovereign Complete: following Pokémon" markers and is rewritten on each run.

Usage: python3 tools/complete/gen_follower_sprites.py
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

FIRST = 2048  # OBJ_EVENT_GFX_HGSS_MON_* = FIRST + the sprite's place in HeartGold's range
HG_FIRST, HG_LAST = 428, 993  # SPRITE_FOLLOWER_MON_BULBASAUR .. SPRITE_FOLLOWER_MON_ARCEUS_DARK
HG_SPECIES = 493  # HeartGold's species, Bulbasaur to Arceus

BEGIN = 'Sovereign Complete: following Pokémon (tools/complete/gen_follower_sprites.py)'
END = 'Sovereign Complete: end of following Pokémon'


def defines(path, pattern):
    values = {}
    for line in open(os.path.join(HGSS, path)):
        m = re.match(rf'#define ({pattern})\s+(0x[0-9A-Fa-f]+|\d+)\b', line)
        if m:
            values.setdefault(m.group(1), int(m.group(2), 0))
    return values


def hgss_range():
    """[(name, mmodel NSBTX path)] for HeartGold's walking sprites 428-993 in order (names without FOLLOWER_MON_)."""
    numbers = {n: name for name, n in defines('include/constants/sprites.h', r'SPRITE_FOLLOWER_MON_\w+').items()}
    mmodel = defines('include/constants/mmodel.h', r'MMODEL_\w+')
    models = {}
    for line in open(os.path.join(HGSS, 'asm/overlay_01_sprite_data.s')):
        m = re.search(r'\.short (SPRITE_FOLLOWER_MON_\w+), (MMODEL_\w+),', line)
        if m:
            models.setdefault(m.group(1), m.group(2))
    sprites = []
    for n in range(HG_FIRST, HG_LAST + 1):
        name = numbers[n]
        path = os.path.join(HGSS, f'files/data/mmodel/mmodel/mmodel_{mmodel[models[name]]:08d}.NSBTX')
        sprites.append((name[len('SPRITE_FOLLOWER_MON_'):], path))
    return sprites


def lookup_tables():
    """HeartGold's per-species tables (src/follow_mon.c): [first sprite's place] (index species, 0 none), [forms - 1]
    and [female sprite follows] (index species - 1)."""
    offsets = defines('include/constants/follow_mon_idx.h', r'FOLLOWER_MON_\w+')
    source = open(os.path.join(HGSS, 'src/follow_mon.c')).read()

    def table(name):
        body = re.search(rf'{name}\[\] = \{{(.*?)\n\}};', source, re.S).group(1)
        return [re.sub(r'//.*', '', line).strip().rstrip(',') for line in body.splitlines()
                if re.sub(r'//.*', '', line).strip()]
    first = [offsets[v] for v in table('sModelIndexLUT')]
    forms = [int(v, 0) for v in table('sFormMaxLUT')]
    female = [v == 'TRUE' for v in table('sFemaleFlagLUT')]
    assert len(first) == HG_SPECIES + 1 and len(forms) == len(female) == HG_SPECIES, (len(first), len(forms))
    return first, forms, female


def too_tall(first, names):
    """[too tall] per species (index species - 1) from HeartGold's following Pokémon parameters (tp_param.csv, the
    first row naming the species' first sprite)."""
    flags = {}
    for line in open(os.path.join(HGSS, 'files/fielddata/tsurepoke/tp_param.csv')).read().splitlines()[1:]:
        name, _, tall = line.split(',')[:3]
        flags.setdefault(name[len('TSURE_POKE_'):], tall == 'true')
    return [flags.get(names[first[species]], False) for species in range(1, HG_SPECIES + 1)]


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


def bits(flags):
    return [sum(1 << b for b in range(8) if i + b < len(flags) and flags[i + b]) for i in range(0, len(flags), 8)]


def c_array(values, per_line=16, fmt='{}'):
    lines = []
    for i in range(0, len(values), per_line):
        lines.append('    ' + ', '.join(fmt.format(v) for v in values[i:i + per_line]) + ',')
    return '\n'.join(lines)


def main():
    out_dir = os.path.join(DECOMP, 'res/graphics/field_sprites/pokemon/follower')
    os.makedirs(out_dir, exist_ok=True)
    for old in os.listdir(out_dir):
        if old.endswith('.png'):
            os.remove(os.path.join(out_dir, old))
    sprites = []
    for k, (name, path) in enumerate(hgss_range()):
        stem = f'follower_{k:03d}'
        size = convert(path, os.path.join(out_dir, stem + '.png'))
        sprites.append((k, name, stem, size))
    names = [name for _, name, _, _ in sprites]
    large = [size == 64 for *_, size in sprites]
    first64 = large.index(True)
    print(f'{len(sprites)} walking sprites, {sum(large)} of them 64x64')

    gfx = lambda k: f'OBJ_EVENT_GFX_HGSS_MON_{names[k]}'  # noqa: E731
    edit('generated/object_events_gfx.txt', lambda t: replace_block(
        t, [f'{gfx(k)} = {FIRST + k}' for k in range(len(sprites))], 'OBJ_EVENT_GFX_BERRY_SPROUT', comment='#'))

    templates = [(0, 'BILLBOARD_MODEL_GENERIC_32x32', '&Unk_ov5_021FAFD8'),
                 (first64, 'BILLBOARD_MODEL_GENERIC_64x64', '&Unk_ov5_021FB0A0')]  # Pikachu's and Regigigas's setup

    def tables(text):
        text = replace_block(text, [f'{{ {gfx(k)}, {unk} }},' for k, _, unk in templates],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, NULL }', indent='    ', tag='graphics')
        text = replace_block(text, [], '{ OBJ_EVENT_GFX_SENTINEL_ID, 0 }', indent='    ', tag='textures')
        text = replace_block(text, [f'{{ {gfx(k)}, {model}, BILLBOARD_FRAME_SEQ_GENERIC_WALK, sWalkBillboardAnims }},'
                                    for k, model, _ in templates],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, BILLBOARD_MODEL_SENTINEL_ID', indent='    ', tag='billboards')
        text = replace_block(text, [f'{{ {gfx(k)}, MODEL_TYPE_BILLBOARD, .hasShadow = TRUE, TRACK_TYPE_FOOTSTEPS, '
                                    '.hasReflection = TRUE },' for k, _, _ in templates],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, 0, 0, 0, 0 }', indent='    ', tag='model types')
        return text
    edit('src/overlay005/object_event_gfx_data.c', tables)

    def order(text):
        lines = [line for line in text.splitlines() if not line.startswith('follower_')]
        return '\n'.join(lines + [f'{stem}.nsbtx' for _, _, stem, _ in sprites]) + '\n'
    edit('res/graphics/field_sprites/field_sprites.order', order)

    def meson(text):
        entries = []
        for px in (32, 64):
            entries.append(f"field_sprites_textures_complete_followers_{px} = [")
            entries += [f"    {{ 'file': 'pokemon/follower/{stem}.png', 'basename': 'hgmon{k:03d}'}},"
                        for k, _, stem, size in sprites if size == px]
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

    first, forms, female = lookup_tables()
    tall = too_tall(first, names)
    header = os.path.join(DECOMP, 'src/complete_follower_gfx.h')
    with open(header, 'w') as f:
        f.write(f'''// Generated by tools/complete/gen_follower_sprites.py: HeartGold's walking Pokémon sprites, a range of graphics
// IDs (OBJ_EVENT_GFX_HGSS_MON_*) whose textures are NARC members one after another.
#define FOLLOWER_GFX_FIRST {FIRST}
#define FOLLOWER_GFX_COUNT {len(sprites)}
#define FOLLOWER_GFX_TEMPLATE_32 {gfx(0)}
#define FOLLOWER_GFX_TEMPLATE_64 {gfx(first64)}
#define FOLLOWER_GFX_FIRST_TEXTURE {sprites[0][2]}_nsbtx
#define FOLLOWER_SPECIES_COUNT {HG_SPECIES}

// Bit k: the range's k-th sprite is 64x64
static const u8 sFollowerGfxLarge[] = {{
{c_array(bits(large), fmt='0x{:02X}')}
}};

// Per species (index species): its first sprite's place in the range (HeartGold's sModelIndexLUT)
static const u16 sFollowerGfxFirst[] = {{
{c_array(first)}
}};

// Per species (index species - 1): its forms beyond the first (sFormMaxLUT), and bit 7 if a female sprite follows
// its first (sFemaleFlagLUT)
static const u8 sFollowerGfxForms[] = {{
{c_array([fm | (0x80 if fe else 0) for fm, fe in zip(forms, female)])}
}};

// Bit species - 1: too tall for the maps that only let small Pokémon follow (HeartGold's tp_param.csv)
static const u8 sFollowerTooTall[] = {{
{c_array(bits(tall), fmt='0x{:02X}')}
}};
''')
    print(f'{sum(tall)} species too tall; src/complete_follower_gfx.h written')


if __name__ == '__main__':
    main()
