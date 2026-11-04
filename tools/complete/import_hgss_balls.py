#!/usr/bin/env python3
"""Bring in HeartGold's graphics for its own Balls (Fast, Level, Lure, Heavy, Love, Friend, Moon, Sport, Park), which a
Pokémon keeps as HeartGold keeps them (src/pokemon.c) and Pokemon_BallToDraw gives the Ball graphics' tables as
HeartGold's Ball numbers, 17 to 25:

- **Thrown and sent out** (src/battle_anim/ov12_02235E94.c): each Ball's throw tiles and palette from HeartGold's
  battle sprites (a/0/0/8, Platinum's pl_batt_obj; HeartGold's members 309 + 3n and 99 + n, Fast first), into
  decomp/res/graphics/battle/ball_throws/hgss/ (*_ball.NCGR, which the build compresses into
  ball_throws/hgss/*_ball.NCGR.lz as Platinum's are, and *_ball.NCLR, at the end of res/graphics/battle/sprites.order).
  Their cells and animations are byte for byte the shared ones Platinum's Balls use, as are their open and catch
  particles in HeartGold's ball_particle archive (each a copy of its Poké Ball's), so the new rows point at
  Platinum's. The Park Ball's tiles are Platinum's own Park Ball's (Pal Park's throw); its
  palette is HeartGold's.
- **The summary screen** (src/applications/pokemon_summary_screen/sprites.c): HeartGold's Ball icons (a/1/6/2, members
  41 to 48, Fast to Sport) and each one's palette (53 to 60), into
  decomp/res/graphics/pokemon_summary_screen/balls/hgss/ (hgss_*_ball.NCGR and .NCLR, at the end of
  pokemon_summary_screen.order). HeartGold has no Park Ball icon (its summary screen reads a palette there), so the
  Park Ball shows a Poké Ball.

- **The Bug-Catching Contest's battle bottom screen** (src/battle/battle_subscreen.c): HeartGold's bug net and Sport
  Ball sprites over the menu (a/0/0/8, members 343 to 345: tiles, cells, animations), into
  decomp/res/graphics/battle/interface/hgss/ (contest_net*, compressed by the build), and HeartGold's bottom-screen
  sprite palettes (member 72, as contest_menu.NCLR), which the contest's battles load in place of Platinum's: they're
  Platinum's seven with the net's and Ball's colours in the fifth and sixth and the Pokémon's gender's in the fourth,
  and the bottom screen's sixteen palettes have no room for more.

The members are copied as they are (the throw tiles decompressed, since git leaves out .lz files). The numbers are
checked against Platinum's built archives: HeartGold's members just before each range are Platinum's own Balls'.

Usage, after a build of decomp (for the check) and tools/complete/build_heartgold.sh:
    python3 tools/complete/import_hgss_balls.py
"""
import hashlib
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402
from narc import read_narc  # noqa: E402

BALLS = ['fast', 'level', 'lure', 'heavy', 'love', 'friend', 'moon', 'sport', 'park']  # HeartGold's order, from 17
BATTLE = os.path.join(HG, 'files', 'a', '0', '0', '8')
SUMMARY = os.path.join(HG, 'files', 'a', '1', '6', '2')
THROW_TILES, THROW_PALETTES = 309, 99  # Fast's; each Ball's tiles three members on (tiles, animation, cell)
ICON_TILES, ICON_PALETTES = 41, 53  # Fast's; Fast to Sport
THROWS_OUT = os.path.join(DECOMP, 'res', 'graphics', 'battle', 'ball_throws', 'hgss')
ICONS_OUT = os.path.join(DECOMP, 'res', 'graphics', 'pokemon_summary_screen', 'balls', 'hgss')
CONTEST_TILES = 343  # then its cells and animations
CONTEST_PALETTES = 72  # the bottom screen's sprite palettes
CONTEST_OUT = os.path.join(DECOMP, 'res', 'graphics', 'battle', 'interface', 'hgss')


def lz10(data):
    size = int.from_bytes(data[1:4], 'little')
    out, i = bytearray(), 4
    while len(out) < size:
        flags = data[i]
        i += 1
        for bit in range(8):
            if len(out) >= size:
                break
            if flags & (0x80 >> bit):
                count, back = (data[i] >> 4) + 3, ((data[i] & 0xF) << 8 | data[i + 1]) + 1
                i += 2
                for _ in range(count):
                    out.append(out[-back])
            else:
                out.append(data[i])
                i += 1
    return bytes(out)


def tile_data(member):
    """An NCGR's tiles, without its headers."""
    data = lz10(member) if member[0] == 0x10 else member
    size = int.from_bytes(data[40:44], 'little')
    offset = int.from_bytes(data[44:48], 'little')
    return data[24 + offset:24 + offset + size]


def platinum_members(path):
    """A built archive's members but those this script brings in (the hgss ones its .naix names)."""
    names = {}
    for line in open(os.path.splitext(path)[0] + '.naix'):
        parts = line.split()
        if len(parts) == 3 and parts[0] == '#define':
            names[int(parts[2])] = parts[1]
    return [m for i, m in enumerate(read_narc(path)) if 'hgss' not in names.get(i, '')]


def check(battle, summary):
    """HeartGold's member before each range is Platinum's last Ball's of its kind (when a build is there to check)."""
    built = os.path.join(DECOMP, 'build')
    throws = os.path.join(built, 'res', 'graphics', 'battle', 'sprites.narc')
    icons = os.path.join(built, 'res', 'graphics', 'pokemon_summary_screen', 'pl_pst_gra.narc')
    if not (os.path.exists(throws) and os.path.exists(icons)):
        print('no build to check the members against; copying them as numbered')
        return
    digest = lambda data: hashlib.md5(data).hexdigest()  # noqa: E731
    pt_tiles = {digest(tile_data(m)) for m in platinum_members(throws) if m[:1] == b'\x10'}
    for n, expect in ((THROW_TILES - 3, True), (THROW_TILES + 3 * 8, True), (THROW_TILES, False)):
        if (digest(tile_data(battle[n])) in pt_tiles) != expect:
            sys.exit(f'HeartGold\'s battle sprite {n} isn\'t what this script expects')
    pt_icons = {digest(m[16:]) for m in platinum_members(icons)}
    for n, expect in ((ICON_TILES - 1, True), (ICON_PALETTES - 1, True), (ICON_TILES, False), (ICON_PALETTES, False)):
        if (digest(summary[n][16:]) in pt_icons) != expect:
            sys.exit(f'HeartGold\'s summary graphic {n} isn\'t what this script expects')


def write(path, data):
    with open(path, 'wb') as f:
        f.write(data)


def main():
    battle, summary = read_narc(BATTLE), read_narc(SUMMARY)
    check(battle, summary)
    os.makedirs(THROWS_OUT, exist_ok=True)
    os.makedirs(ICONS_OUT, exist_ok=True)
    for i, name in enumerate(BALLS):
        tiles, palette = battle[THROW_TILES + 3 * i], battle[THROW_PALETTES + i]
        assert tiles[0] == 0x10 and lz10(tiles)[:4] == b'RGCN' and palette[:4] == b'RLCN', name
        write(os.path.join(THROWS_OUT, f'{name}_ball.NCGR'), lz10(tiles))
        write(os.path.join(THROWS_OUT, f'{name}_ball.NCLR'), palette)
        if name == 'park':
            continue
        icon, icon_palette = summary[ICON_TILES + i], summary[ICON_PALETTES + i]
        assert icon[:4] == b'RGCN' and icon_palette[:4] == b'RLCN', name
        write(os.path.join(ICONS_OUT, f'hgss_{name}_ball.NCGR'), icon)
        write(os.path.join(ICONS_OUT, f'hgss_{name}_ball.NCLR'), icon_palette)
    os.makedirs(CONTEST_OUT, exist_ok=True)
    for name, member, magic in (('contest_net.NCGR', CONTEST_TILES, b'RGCN'),
                                ('contest_net_cell.NCER', CONTEST_TILES + 1, b'RECN'),
                                ('contest_net_anim.NANR', CONTEST_TILES + 2, b'RNAN')):
        data = lz10(battle[member])
        assert data[:4] == magic, name
        write(os.path.join(CONTEST_OUT, name), data)
    assert battle[CONTEST_PALETTES][:4] == b'RLCN'
    write(os.path.join(CONTEST_OUT, 'contest_menu.NCLR'), battle[CONTEST_PALETTES])
    print(f'{len(BALLS)} Balls\' throws into {THROWS_OUT}, {len(BALLS) - 1} icons into {ICONS_OUT}, the contest\'s net '
          f'and Ball into {CONTEST_OUT}')


if __name__ == '__main__':
    main()
