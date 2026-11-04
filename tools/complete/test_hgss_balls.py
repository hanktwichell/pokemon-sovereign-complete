#!/usr/bin/env python3
"""Check HeartGold's Apricorn Balls in the test build: each can be thrown in battle, catches, and stays the caught
Pokémon's Ball (kept in HeartGold's own byte, src/pokemon.c; docs/Features.md), and a Friend Ball's catch starts at
200 friendship.

For each Ball, from the bedroom state: the party is cut to its first Pokémon (gSovereignTestPartyKeep, applied by a
test warp to where the player stands), then a wild battle (battle_mechanics.py's setup) against a Lv. 5 Caterpie
that only uses Splash, with five of that Ball in the bag (gSovereignTestWild.ball). Once the battle's Pokémon are in,
the Caterpie is put to sleep at 1 HP, so any Ball catches it (catch rate 255, x2 asleep). The harness throws one as
battle_mechanics.py's throw cases do, but picks the pocket's second Ball (the state's Poké Balls come first), and
watches the throw: the top screen must show more of the Ball's own colours (those of its HeartGold throw palette,
decomp/res/graphics/battle/ball_throws/hgss/, that the Poké Ball's hasn't) while it flies than just before (COLOURS, a
Ball drawn as a Poké Ball). Then it presses A on the Pokédex's page and B elsewhere (no nickname) until the field is
back, and reads the party (gSovereignTestParty): the last Pokémon must be the Caterpie in that Ball. Last, it opens
the Caterpie's summary (the start menu, POKéMON, its slot, SUMMARY): the Ball icon beside its name must show the
icon's own colours (those of its HeartGold palette, decomp/res/graphics/pokemon_summary_screen/balls/hgss/, that
Platinum's Balls' haven't). Results per Ball: ok, NOCATCH (the party didn't grow), BALL (another Ball), FRIENDSHIP,
COLOURS, ICON, HANG (the battle didn't end). With SHOTS set, the throw's frames and the summary are saved in OUT_DIR.

From the repo root, with the test build and a bedroom state (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_balls.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from check_trainer_party import consts  # noqa: E402
from gift_pokemon import MON, PARTY  # noqa: E402
from talk_to_objects import DECOMP, u32, warp  # noqa: E402

BALLS = ['FAST_BALL', 'LEVEL_BALL', 'LURE_BALL', 'HEAVY_BALL', 'LOVE_BALL', 'FRIEND_BALL', 'MOON_BALL']
WILD_BALL = 12  # offsetof(struct SovereignTestWild, ball)
SLEEP = 3  # MON_CONDITION_SLEEP: asleep for 3 turns
FRIEND_BALL_FRIENDSHIP = 200
BATTLE_FRAMES = 6000
THROW = ((35, 165), (190, 50), (190, 30), (100, 170))  # BAG, the Poké Balls pocket, its second Ball, USE
POKEDEX_BANNER = ((200, 4), (248, 208, 0))  # the Pokédex page's yellow banner, on a new species' catch
THROW_FRAMES, THROW_STEP = 360, 6  # the throw watched after USE (its message first), a frame every 6
TOP_SCREEN = 192
SHOWN = 6  # pixels of the Ball's own colours a frame must show beyond the frame before the throw
# The start menu (its cursor on the Pokédex), POKéMON, the second slot (the Caterpie), SUMMARY (the menu's first)
OPEN_SUMMARY = [('X', 60), ('DOWN', 40), ('A', 100), ('RIGHT', 40), ('A', 60), ('A', 130)]
ICON = (6, 22, 26, 44)  # the summary's Ball icon, beside the name, on the top screen
ICON_SHOWN = 20  # pixels of the icon's own colours
SYMBOLS = bm.SYMBOLS + ('gSovereignTestParty', 'gSovereignTestPartyKeep', 'gSovereignTestWarpTarget',
                        'gSovereignTestIdleMapHeaderID', 'gSovereignTestPlayerTile', 'gSovereignTestScripts')


def nclr_colours(path):
    """A palette file's first palette, colours 1 to 15 (0 is transparent)."""
    data = open(path, 'rb').read()
    at = 24 + int.from_bytes(data[36:40], 'little')
    return {rgb555(int.from_bytes(data[at + 2 * k:at + 2 * k + 2], 'little')) for k in range(1, 16)}


def rgb555(c):
    return tuple((v << 3) | (v >> 2) for v in (c & 31, (c >> 5) & 31, (c >> 10) & 31))


def own_colours(ball):
    """A Ball's throw colours that the Poké Ball's throw hasn't (each to the nearest 8)."""
    from PIL import Image
    throws = os.path.join(DECOMP, 'res', 'graphics', 'battle', 'ball_throws')
    poke = Image.open(os.path.join(throws, 'poke_ball.png')).getpalette()[3:48]
    poke = {tuple(v & ~7 for v in poke[i:i + 3]) for i in range(0, len(poke), 3)}
    name = ball.lower().replace('_ball', '')
    mine = nclr_colours(os.path.join(throws, 'hgss', f'{name}_ball.NCLR'))
    return {tuple(v & ~7 for v in c) for c in mine} - poke


def shown(image, colours):
    """How many of the image's top-screen pixels are one of the colours (to the nearest 8)."""
    data = image.convert('RGB').crop((0, 0, min(image.width, 256), min(image.height, TOP_SCREEN))).tobytes()
    return sum(1 for i in range(0, len(data), 3) if (data[i] & ~7, data[i + 1] & ~7, data[i + 2] & ~7) in colours)


def icon_colours(ball):
    """A Ball's summary icon colours that none of Platinum's Balls' icon palettes has (to the nearest 8)."""
    balls = os.path.join(DECOMP, 'res', 'graphics', 'pokemon_summary_screen', 'balls')
    platinum = set()
    for i in range(4):
        lines = open(os.path.join(balls, f'balls_{i}.pal')).read().split('\n')[3:]
        platinum |= {tuple(int(v) & ~7 for v in line.split()) for line in lines if line.strip()}
    name = ball.lower().replace('_ball', '')
    mine = nclr_colours(os.path.join(balls, 'hgss', f'hgss_{name}_ball.NCLR'))
    return {tuple(v & ~7 for v in c) for c in mine} - platinum


def note_party(d, sym):
    """[(species, ball, friendship)] of the party, as the field writes it down."""
    mem, at = d.emu.memory, sym['gSovereignTestParty']
    mem.write_byte(at + PARTY['wanted'], 1)
    for _ in range(60):
        d.run(2)
        if mem.unsigned[at + PARTY['wanted']] == 0:
            break
    size = struct.calcsize(MON)
    party = []
    for i in range(mem.unsigned[at + PARTY['count']]):
        fields = struct.unpack(MON, bytes(mem.unsigned[at + PARTY['mons'] + i * size:at + PARTY['mons'] + (i + 1) * size]))
        party.append((fields[0], fields[-2], fields[-1]))
    return party


def run_ball(d, sym, names, state, ball, out):
    d.load_state(state)
    d.run(30)
    mem = d.emu.memory
    header = u32(d, sym['gSovereignTestIdleMapHeaderID'])
    x, z = struct.unpack('<HH', bytes(mem.unsigned[sym['gSovereignTestPlayerTile']:sym['gSovereignTestPlayerTile'] + 4]))
    mem.write_byte(sym['gSovereignTestPartyKeep'], 1)
    warp(d, sym, header, x, z, 0)
    before = note_party(d, sym)
    case = dict(lead='MEGANIUM', lead_move='SPLASH', all_moves=1, foe_move='SPLASH', wild_species='CATERPIE',
                wild_level=5, nogod=1, throw=1)
    d.emu.memory.write_short(sym['gSovereignTestWild'] + WILD_BALL, names['items'].index('ITEM_' + ball))
    bm.setup(d, sym, case, names)
    b = bm.Battle(d, sym)
    phase, frames = 'start', 0
    while frames < BATTLE_FRAMES:
        d.run(10)
        frames += 10
        if phase == 'start' and b.mons() and b.read(bm.FOE_B, 'maxHP', 4):
            d.run(60)
            frames += 60
            b.write(bm.FOE_B, 'curHP', 1, 4)
            b.write(bm.FOE_B, 'status', SLEEP, 4)
            phase = 'menu'
        elif phase == 'menu' and d.screenshot().convert('RGB').getpixel((20, 350)) == (224, 152, 40):
            for x, y in THROW[:-1]:  # battle_mechanics.py's throw
                d.touch(x, y, frames=4, after=60)
                d.run(60)
                frames += 124
            colours = own_colours(ball)
            before_throw = shown(d.screenshot(), colours)
            d.touch(*THROW[-1], frames=4, after=0)
            most = 0
            for step in range(0, THROW_FRAMES, THROW_STEP):
                d.run(THROW_STEP)
                shot = d.screenshot()
                most = max(most, shown(shot, colours) - before_throw)
                if os.environ.get('SHOTS'):
                    shot.save(os.path.join(out, f'{ball.lower()}_throw_{step:03d}.png'))
            frames += 4 + THROW_FRAMES
            if most < SHOWN:
                return f'COLOURS (at most {most} pixels of its own colours)', None
            phase = 'thrown'
        elif phase == 'thrown':
            if not b.mons():
                idle = u32(d, sym['gSovereignTestIdleFrames'])
                d.run(30)
                if u32(d, sym['gSovereignTestIdleFrames']) != idle:
                    break
            pixel, banner = POKEDEX_BANNER
            d.press('A' if d.screenshot().convert('RGB').getpixel(pixel) == banner else 'B', frames=4, after=20)
            frames += 24
    else:
        return 'HANG', None
    after = note_party(d, sym)
    if len(after) != len(before) + 1:
        return 'NOCATCH', after[-1:]
    species, got_ball, friendship = after[-1]
    if got_ball != names['items'].index('ITEM_' + ball):
        return 'BALL', after[-1]
    if ball == 'FRIEND_BALL' and friendship != FRIEND_BALL_FRIENDSHIP:
        return 'FRIENDSHIP', after[-1]
    for key, wait in OPEN_SUMMARY:
        d.press(key, frames=6, after=wait)
    summary = d.screenshot()
    if os.environ.get('SHOTS'):
        summary.save(os.path.join(out, f'{ball.lower()}_summary.png'))
    icon = shown(summary.crop(ICON), icon_colours(ball))
    if icon < ICON_SHOWN:
        return f'ICON (the summary shows {icon} pixels of its own colours)', after[-1]
    return 'ok', after[-1]


def main():
    from drive import Driver
    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = {k: consts(k + '.txt') for k in ('species', 'moves', 'items', 'abilities', 'trainers')}
    d = Driver(rom, state)
    failed = 0
    for ball in BALLS:
        result, mon = run_ball(d, sym, names, state, ball, out)
        print(ball, result, mon, flush=True)
        if result != 'ok':
            failed += 1
            d.screenshot().save(os.path.join(out, f'{ball.lower()}.png'))
    print(f'{len(BALLS) - failed} of {len(BALLS)} Balls ok')
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
