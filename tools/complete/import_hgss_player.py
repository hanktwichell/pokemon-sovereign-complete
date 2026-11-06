#!/usr/bin/env python3
"""The player as HeartGold's Ethan (the boy) and Platinum's Dawn (the girl): the owner's choice, Nov 6, 2026.

What it writes:

- The overworld: each of the boy's textures (Platinum's player_m*.png, every pose the field draws the player in) from
  HeartGold's own sprites where HeartGold drew Ethan in that pose (walking and running, the bike, surfing, fishing,
  saving, the Pokémon Center's counter; the contest's walk is his walk), into
  decomp/res/graphics/field_sprites/player/complete/, and the field sprites' meson.build reads them in place of
  Platinum's (the same texture names, so every graphics ID that draws the player, in the Distortion World, Hearthome
  Gym, the Frontier and the contest halls too, draws Ethan). HeartGold never drew Ethan raising a Poké Ball, with a
  Pokétch, watering with the Sprayduck or with the VS Seeker: those poses move Lucas's arm and what he holds onto
  Ethan's body (transfer(): the frame of Lucas that each pose was drawn from, found by its head; the pixels the pose
  changed below the head, and the ones beside the head that join them, in Ethan's colours for Lucas's).
- Lucas himself, for Rowan's assistant (the scripts gave the assistant the player's graphics): Platinum's walking
  texture as OBJ_EVENT_GFX_COMPLETE_LUCAS, and the assistant's lines in the Sinnoh scripts use it (each marked).
- The battle: Ethan's back (his throw) and, for HeartGold's tag battles, Lance's and Silver's backs, from HeartGold's
  trainer backs (a/0/0/6 of Sacred Gold's ROM: 0 Ethan, 1 Lyra, 2 Silver, 3 Lance), into their classes' folders in
  decomp/res/trainers/classes/ (Sovereign's class layout: back.png, back_cell.json, back_anim.json, back_scan.png);
  include/data/complete_player.h names the player's classes (the battle's and the Hall of Fame's), and
  SpriteSystem_TrainerClassBackSpriteIndex (src/pokemon.c) takes each class's own back.

GIRL = 'lyra' makes the girl HeartGold's Lyra the same way (and keeps Dawn for the assistant).

Every insertion sits between "Sovereign Complete: the player" markers and is rewritten on each run.

Usage: python3 tools/complete/import_hgss_player.py   (after build_heartgold.sh; needs the regular build's nitrogfx)
"""
import os
import re
import shutil
import subprocess
import sys
import tempfile
from collections import Counter, defaultdict

import ndspy.narc
import ndspy.rom
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from nsbtx_to_png import decode  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
HGSS = os.path.join(ROOT, '.cache', 'pokeheartgold')
ROM = os.path.join(ROOT, '.cache', 'sacredgold.nds')
NITROGFX = os.path.join(DECOMP, 'build/tools/nitrogfx/nitrogfx')
SPRITES = os.path.join(DECOMP, 'res', 'graphics', 'field_sprites')
OUT = os.path.join(SPRITES, 'player', 'complete')
CLASSES = os.path.join(DECOMP, 'res', 'trainers', 'classes')

BOY, GIRL = 'ethan', 'dawn'  # 'lucas' or 'ethan'; 'dawn' or 'lyra'
BEGIN = 'Sovereign Complete: the player (tools/complete/import_hgss_player.py)'
END = 'Sovereign Complete: end of the player'

# Platinum's texture -> HeartGold's sprite drawn in that pose (frames in Platinum's order), or None: moved from
# Platinum's own (transfer)
POSES = {'': 'HERO', '_bike': 'CYCLEHERO', '_surf': 'SWIMHERO', '_fishing': 'FISHINGHERO', '_save': 'SAVEHERO',
         '_pokecenter_heal': 'BANZAIHERO', '_contest': 'HERO', '_holding_pokeball': None, '_poketch': None,
         '_sprayduck': None, '_vs_seeker': None}
HG_NAMES = {'m': {}, 'f': {'HERO': 'HEROINE', 'CYCLEHERO': 'CYCLEHEROINE', 'SWIMHERO': 'SWIMHEROINE',
                           'FISHINGHERO': 'FISH_HEROINE', 'SAVEHERO': 'SAVEHEROINE', 'BANZAIHERO': 'BANZAIHEROINE'}}
# The assistant's copy of the player that the new player replaces
ASSISTANT = {'m': ('COMPLETE_LUCAS', 1900, 'complete_lucas', 'cpl_lucas'),
             'f': ('COMPLETE_DAWN', 1901, 'complete_dawn', 'cpl_dawn')}
# HeartGold's trainer backs (a/0/0/6, five files each) -> the class folder they go to
BACKS = {0: 'hgss_pkmn_trainer_ethan', 1: 'hgss_pkmn_trainer_lyra', 2: 'hgss_rival', 3: 'hgss_pkmn_trainer_lance'}


def swapped():
    """The genders whose player is HeartGold's: 'm', 'f'."""
    return [g for g, on in (('m', BOY == 'ethan'), ('f', GIRL == 'lyra')) if on]


# --- the overworld ---------------------------------------------------------------------------------------------------

def hg_sprite(name):
    """HeartGold's sprite's frames (lists of 1024 colour indices) and its palette (16 RGB)."""
    mmodel = {}
    for line in open(os.path.join(HGSS, 'include/constants/mmodel.h')):
        m = re.match(r'#define MMODEL_(\w+)\s+(\d+)', line)
        if m:
            mmodel[m.group(1)] = int(m.group(2))
    frames, palettes = decode(os.path.join(HGSS, f'files/data/mmodel/mmodel/mmodel_{mmodel[name]:08d}.NSBTX'))
    assert all(f[1] == f[2] == 32 for f in frames), name
    return [list(f[3]) for f in frames], [tuple(c) for c in next(iter(palettes.values()))]


def platinum_sheet(stem):
    """Platinum's sheet's frames and palette."""
    image = Image.open(os.path.join(SPRITES, 'player', stem + '.png'))
    palette = image.getpalette()[:48]
    data = list(image.tobytes())
    return [data[i * 1024:(i + 1) * 1024] for i in range(image.height // 32)], \
        [tuple(palette[i:i + 3]) for i in range(0, 48, 3)]


def shift(frame, dy):
    out = [0] * 1024
    for k, c in enumerate(frame):
        row = k // 32 + dy
        if 0 <= row < 32:
            out[row * 32 + k % 32] = c
    return out


def top_row(frame):
    return min(k // 32 for k, c in enumerate(frame) if c)


def transfer(old_walk, old_palette, new_walk, new_palette, pose):
    """The pose's frames (drawn on the old player) on the new player: see the module's notes."""
    together = defaultdict(Counter)  # old colour -> the new colours at the same pixels of the same walking frames
    for a, b in zip(old_walk, new_walk):
        for x, y in zip(a, b):
            if x and y:
                together[x][y] += 1

    def nearest(rgb):
        return min(range(1, 16), key=lambda j: sum((rgb[i] - new_palette[j][i]) ** 2 for i in range(3)))
    colour = {0: 0}
    for i in range(1, 16):
        colour[i] = together[i].most_common(1)[0][0] if sum(together[i].values()) > 20 else nearest(old_palette[i])
    # the old head's colours (the hat, the hair): mostly in the top half of the walking frames
    count, high = Counter(), Counter()
    for frame in old_walk[:16]:
        top = top_row(frame)
        bottom = max(k // 32 for k, c in enumerate(frame) if c)
        for k, c in enumerate(frame):
            if c:
                count[c] += 1
                high[c] += k // 32 < (top + bottom) / 2
    head = {c for c in count if high[c] / count[c] > 0.45}
    outline = min(range(1, 16), key=lambda j: sum(old_palette[j]))
    shifted = {(j, dy): shift(old_walk[j], dy) for j in range(16) for dy in (-2, -1, 0, 1, 2)}
    out = []
    for frame in pose:
        top = top_row(frame)
        # the standing frame it was drawn from: its direction and its bob, by the head
        _, base, dy = min((sum(1 for k in range(top * 32, (top + 13) * 32) if frame[k] != moved[k]), j - j % 4, dy)
                          for (j, dy), moved in shifted.items())
        old, new_base = shift(old_walk[base], dy), shift(new_walk[base], dy)
        new = list(new_base)
        head_end = top_row(new_base) + 13
        below, beside = set(), set()
        for k, (x, y) in enumerate(zip(frame, old)):
            if x == y:
                continue
            if k // 32 >= head_end:
                new[k] = colour[x]
                if x:
                    below.add(k)
            elif x and not new_base[k] and x not in head:
                beside.add(k)
        # a raised arm or a held item reaches up from the body: keep what joins the changes below the head (through
        # its own colours, then its outline), not the old hat's rim around the new head
        keep, todo = set(), list(below)
        while todo:
            k = todo.pop()
            for n in (k - 1, k + 1, k - 32, k + 32):
                if n in beside and n not in keep and frame[n] != outline and abs(n % 32 - k % 32) <= 1:
                    keep.add(n)
                    todo.append(n)
        keep |= {n for k in keep for n in (k - 1, k + 1, k - 32, k + 32) if n in beside and frame[n] == outline}
        for k in keep:
            new[k] = colour[frame[k]]
        out.append(new)
    return out


def save_sheet(frames, palette, path):
    image = Image.new('P', (32, 32 * len(frames)))
    image.putpalette([c for rgb in palette for c in rgb])  # 16 colours, as the build packs a 16-colour texture
    image.putdata([c for frame in frames for c in frame])
    image.save(path, transparency=0)


def overworld():
    os.makedirs(OUT, exist_ok=True)
    for old in os.listdir(OUT):
        os.remove(os.path.join(OUT, old))
    for g in swapped():
        old_walk, old_palette = platinum_sheet(f'player_{g}')
        new_walk, new_palette = hg_sprite(HG_NAMES[g].get('HERO', 'HERO'))
        for pose, sprite in POSES.items():
            stem = f'player_{g}{pose}'
            want = len(platinum_sheet(stem)[0])
            if sprite:
                frames, palette = hg_sprite(HG_NAMES[g].get(sprite, sprite))
                frames = frames[:want]
            else:
                frames, palette = transfer(old_walk, old_palette, new_walk, new_palette, platinum_sheet(stem)[0]), \
                    new_palette
            assert len(frames) == want, (stem, len(frames), want)
            save_sheet(frames, palette, os.path.join(OUT, stem + '.png'))
        _, _, copy, _ = ASSISTANT[g]
        shutil.copyfile(os.path.join(SPRITES, 'player', f'player_{g}.png'), os.path.join(OUT, copy + '.png'))
    print(f'overworld: {len(os.listdir(OUT))} sheets in {os.path.relpath(OUT, ROOT)}')


# --- the build's lists -----------------------------------------------------------------------------------------------

def replace_block(text, block, before, comment='//', indent='', tag='list'):
    body = ''.join(f'{indent}{line}\n' for line in block)
    begin, end = f'{BEGIN} [{tag}]', f'{END} [{tag}]'
    marked = f'{indent}{comment} {begin}\n{body}{indent}{comment} {end}\n' if block else ''
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


def build_lists():
    genders = swapped()
    note = '  # Sovereign Complete: the player (tools/complete/import_hgss_player.py)'

    def meson(text):
        def entry(m):
            g = m.group(2)[len('player_')]
            folder = 'player/complete/' if g in genders else 'player/'
            return f"{m.group(1)}'file': '{folder}{m.group(2)}.png', 'basename': '{m.group(3)}'}},{note if g in genders else ''}"
        text = re.sub(r"( *\{ )'file': 'player/(?:complete/)?(player_[mf]\w*)\.png', 'basename': '(\w+)'\},(?:  # Sovereign "
                      r"Complete: the player \(tools/complete/import_hgss_player\.py\))?", entry, text)
        return replace_block(text, [f"{{ 'file': 'player/complete/{ASSISTANT[g][2]}.png', 'basename': '{ASSISTANT[g][3]}'}},"
                                    for g in genders],
                             "    { 'file': 'player/dp_player_m.png'", comment='#', indent='    ')
    edit('res/graphics/field_sprites/meson.build', meson)

    def order(text):
        lines = [line for line in text.splitlines() if line not in {f'{a[2]}.nsbtx' for a in ASSISTANT.values()}]
        return '\n'.join(lines + [f'{ASSISTANT[g][2]}.nsbtx' for g in genders]) + '\n'
    edit('res/graphics/field_sprites/field_sprites.order', order)

    edit('generated/object_events_gfx.txt', lambda t: replace_block(
        t, [f'OBJ_EVENT_GFX_{ASSISTANT[g][0]} = {ASSISTANT[g][1]}' for g in genders], 'OBJ_EVENT_GFX_BERRY_SPROUT',
        comment='#'))

    def tables(text):
        ids = [(f'OBJ_EVENT_GFX_{ASSISTANT[g][0]}', ASSISTANT[g][2]) for g in genders]
        text = replace_block(text, [f'{{ {gfx}, &Unk_ov5_021FB0F0 }},' for gfx, _ in ids],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, NULL }', indent='    ', tag='graphics')
        text = replace_block(text, [f'{{ {gfx}, {stem}_nsbtx }},' for gfx, stem in ids],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, 0 }', indent='    ', tag='textures')
        text = replace_block(text, [f'{{ {gfx}, BILLBOARD_MODEL_GENERIC_32x32, BILLBOARD_FRAME_SEQ_WALK_AND_RUN, '
                                    'sWalkRunBillboardAnims },' for gfx, _ in ids],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, BILLBOARD_MODEL_SENTINEL_ID', indent='    ', tag='billboards')
        text = replace_block(text, [f'{{ {gfx}, MODEL_TYPE_BILLBOARD, .hasShadow = TRUE, TRACK_TYPE_FOOTSTEPS, '
                                    '.hasReflection = TRUE },' for gfx, _ in ids],
                             '{ OBJ_EVENT_GFX_SENTINEL_ID, 0, 0, 0, 0 }', indent='    ', tag='model types')
        return text
    edit('src/overlay005/object_event_gfx_data.c', tables)


def assistant_scripts():
    """The assistant's lines in the scripts: Lucas (or Dawn) as he was, not the player's graphics."""
    folder = os.path.join(DECOMP, 'res', 'field', 'scripts')
    marker = ' // Sovereign Complete: Rowan\'s assistant, not the player (tools/complete/import_hgss_player.py)'
    changed = 0
    for name in sorted(os.listdir(folder)):
        if not name.endswith('.s'):
            continue
        path = os.path.join(folder, name)
        text = open(path).read()
        new = text
        for g, plat in (('m', 'PLAYER_M'), ('f', 'PLAYER_F')):
            gfx = f'OBJ_EVENT_GFX_{ASSISTANT[g][0]}'
            if g in swapped():
                new = re.sub(rf'(SetVar VAR_OBJ_GFX_ID_\w+|GoToIfEq VAR_MAP_LOCAL_0x01), OBJ_EVENT_GFX_{plat}\b(,[^\n]*?)?$',
                             lambda m: f'{m.group(1)}, {gfx}{m.group(2) or ""}{marker}', new, flags=re.M)
            else:  # back to Platinum's, when this gender's player is Platinum's again
                new = re.sub(rf', {gfx}\b(,[^\n]*?)?{re.escape(marker)}$',
                             lambda m: f', OBJ_EVENT_GFX_{plat}{m.group(1) or ""}', new, flags=re.M)
        if new != text:
            open(path, 'w').write(new)
            changed += 1
    print(f'scripts: the assistant in {changed} files')


# --- the battle -------------------------------------------------------------------------------------------------------

def nitrogfx(*args):
    subprocess.run([NITROGFX, *args], check=True, capture_output=True)


def eight_bit(png):
    """As import_hgss_trainer_classes.py's: the build converts the picture with -convertTo4Bpp."""
    im = Image.open(png)
    im.load()
    out = Image.frombytes('P', im.size, im.tobytes())
    palette = im.getpalette()[:48]
    out.putpalette(palette + [0] * (768 - len(palette)))
    out.save(png, bits=8, **({'transparency': im.info['transparency']} if 'transparency' in im.info else {}))


def backs():
    narc = ndspy.narc.NARC(ndspy.rom.NintendoDSRom.fromFile(ROM).getFileByName('a/0/0/6'))
    wanted = {0: BOY == 'ethan', 1: GIRL == 'lyra', 2: True, 3: True}
    for number, folder in BACKS.items():
        out_dir = os.path.join(CLASSES, folder)
        names = ('back.png', 'back_cell.json', 'back_anim.json', 'back_scan.png', 'back_scan.png.key')
        if not wanted[number]:
            for name in names:
                if os.path.exists(os.path.join(out_dir, name)):
                    os.remove(os.path.join(out_dir, name))
            continue
        ncgr, nclr, ncer, nanr, scan = narc.files[number * 5:number * 5 + 5]
        with tempfile.TemporaryDirectory() as tmp:
            t = lambda name: os.path.join(tmp, name)  # noqa: E731
            o = lambda name: os.path.join(out_dir, name)  # noqa: E731
            for name, data in (('b.NCGR', ncgr), ('b.NCLR', nclr), ('b.NCER', ncer), ('b.NANR', nanr), ('s.NCGR', scan)):
                open(t(name), 'wb').write(data)
            nitrogfx(t('b.NCER'), o('back_cell.json'))
            nitrogfx(t('b.NANR'), o('back_anim.json'))
            nitrogfx(t('b.NCGR'), o('back.png'), '-palette', t('b.NCLR'), '-cell', o('back_cell.json'))
            eight_bit(o('back.png'))
            nitrogfx(t('s.NCGR'), o('back_scan.png'), '-palette', t('b.NCLR'), '-scanfronttoback', '-width', '20')
            # they convert back to the same files
            nitrogfx(o('back_cell.json'), t('c.NCER'))
            nitrogfx(o('back_anim.json'), t('c.NANR'))
            nitrogfx(o('back_scan.png'), t('c.NCGR'), '-encodefronttoback', '-scan')
            for ours, theirs in (('c.NCER', ncer), ('c.NANR', nanr), ('c.NCGR', scan)):
                assert open(t(ours), 'rb').read() == theirs, (folder, ours)
        print(f'battle: {folder}\'s back')

    header = os.path.join(DECOMP, 'include', 'data', 'complete_player.h')
    open(header, 'w').write(f'''#ifndef POKEPLATINUM_DATA_COMPLETE_PLAYER_H
#define POKEPLATINUM_DATA_COMPLETE_PLAYER_H

#include "generated/trainer_classes.h"

// Sovereign Complete: the player's trainer classes, the boy {BOY.title()} and the girl {GIRL.title()}
// (tools/complete/import_hgss_player.py). Generated. Platinum's TRAINER_CLASS_PLAYER_MALE and _FEMALE stay Lucas and
// Dawn, for Rowan's assistant in battle.
#define COMPLETE_PLAYER_CLASS_MALE   {'TRAINER_CLASS_HGSS_PKMN_TRAINER_ETHAN' if BOY == 'ethan' else 'TRAINER_CLASS_PLAYER_MALE'}
#define COMPLETE_PLAYER_CLASS_FEMALE {'TRAINER_CLASS_HGSS_PKMN_TRAINER_LYRA' if GIRL == 'lyra' else 'TRAINER_CLASS_PLAYER_FEMALE'}

#endif
''')


def main():
    overworld()
    build_lists()
    assistant_scripts()
    backs()


if __name__ == '__main__':
    main()
