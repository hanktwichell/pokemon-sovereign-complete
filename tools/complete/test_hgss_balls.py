#!/usr/bin/env python3
"""Check HeartGold's Apricorn Balls in the test build: each can be thrown in battle, catches, and stays the caught
Pokémon's Ball (kept in HeartGold's own byte, src/pokemon.c; docs/Features.md), and a Friend Ball's catch starts at
200 friendship.

For each Ball, from the bedroom state: the party is cut to its first Pokémon (gSovereignTestPartyKeep, applied by a
test warp to where the player stands), then a wild battle (battle_mechanics.py's setup) against a Lv. 5 Caterpie
that only uses Splash, with five of that Ball in the bag (gSovereignTestWild.ball). Once the battle's Pokémon are in,
the Caterpie is put to sleep at 1 HP, so any Ball catches it (catch rate 255, x2 asleep). The harness throws one as
battle_mechanics.py's throw cases do, but picks the pocket's second Ball (the state's Poké Balls come first). Then it
presses A on the Pokédex's page and B elsewhere (no nickname) until the field is back, and reads the party
(gSovereignTestParty): the last Pokémon must be the Caterpie in that Ball. Results per Ball: ok, NOCATCH (the party
didn't grow), BALL (another Ball), FRIENDSHIP, HANG (the battle didn't end).

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
from talk_to_objects import u32, warp  # noqa: E402

BALLS = ['FAST_BALL', 'LEVEL_BALL', 'LURE_BALL', 'HEAVY_BALL', 'LOVE_BALL', 'FRIEND_BALL', 'MOON_BALL']
WILD_BALL = 12  # offsetof(struct SovereignTestWild, ball)
SLEEP = 3  # MON_CONDITION_SLEEP: asleep for 3 turns
FRIEND_BALL_FRIENDSHIP = 200
BATTLE_FRAMES = 6000
THROW = ((35, 165), (190, 50), (190, 30), (100, 170))  # BAG, the Poké Balls pocket, its second Ball, USE
POKEDEX_BANNER = ((200, 4), (248, 208, 0))  # the Pokédex page's yellow banner, on a new species' catch
SYMBOLS = bm.SYMBOLS + ('gSovereignTestParty', 'gSovereignTestPartyKeep', 'gSovereignTestWarpTarget',
                        'gSovereignTestIdleMapHeaderID', 'gSovereignTestPlayerTile', 'gSovereignTestScripts')


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


def run_ball(d, sym, names, state, ball):
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
            for x, y in THROW:  # battle_mechanics.py's throw
                d.touch(x, y, frames=4, after=60)
                d.run(60)
                frames += 124
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
        result, mon = run_ball(d, sym, names, state, ball)
        print(ball, result, mon, flush=True)
        if result != 'ok':
            failed += 1
            d.screenshot().save(os.path.join(out, f'{ball.lower()}.png'))
    print(f'{len(BALLS) - failed} of {len(BALLS)} Balls ok')
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
