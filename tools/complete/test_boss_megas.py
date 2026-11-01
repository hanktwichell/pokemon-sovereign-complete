#!/usr/bin/env python3
"""Battle each boss of Johto's and Kanto's that holds a Mega Stone (docs/BossMegas.md, tools/complete/gen_boss_megas.py)
in the test build and check that its Pokémon Mega Evolves: the test build records the species of the last foe that
did (gSovereignTestFoeMega, src/battle/battle_controller_player.c). The battles are battle_all_trainers.py's (SELECT+R
with gSovereignTestBattleTrainer, god mode), so every Pokémon the boss has is sent out, and a trainer Mega Evolves its
Pokémon as soon as it can (on its first turn out).

From the repo root, with the test build and a save state in the overworld made with it (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_boss_megas.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [TRAINER ...]
"""
import os
import re
import struct
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'test'))
from battle_all_trainers import FRAME_LIMIT, fight, symbols, trainer_ids  # noqa: E402

SPECIES = [line.strip() for line in open(os.path.join(ROOT, 'decomp', 'generated', 'species.txt')) if line.strip()]


def bosses():
    """[(TRAINER_*, its Mega's species)] from docs/BossMegas.md's rows with a stone."""
    out = []
    for line in open(os.path.join(ROOT, 'docs', 'BossMegas.md'), encoding='utf-8'):
        m = re.match(r'\| `(hgss_\w+)` \| .*? \| Mega ([^(|]+?) (?:[XY] )?\(Lv\. \d+\) \| (ITEM_\w+) \|', line)
        if m:
            species = 'SPECIES_' + re.sub(r'[^A-Z0-9]+', '_', m.group(2).upper()).strip('_')
            out.append(('TRAINER_' + m.group(1).upper(), species))
    return out


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    only = sys.argv[4:]
    os.makedirs(out, exist_ok=True)
    sym = symbols(('gSovereignTestBattleTrainer', 'gSovereignTestGodMode', 'gSovereignTestIdleFrames', 'gSystem',
                   'gSovereignTestFoeMega'))
    index = {name: i for i, name in trainer_ids()}
    d = Driver(rom, state)
    mem = d.emu.memory
    results = []
    for trainer, species in bosses():
        if only and trainer not in only:
            continue
        d.load_state(state)
        d.run(30)
        mem.write_short(sym['gSovereignTestBattleTrainer'], index[trainer])
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        mem.write_short(sym['gSovereignTestFoeMega'], 0)
        d.press('SELECT+R')
        result, frames = fight(d, sym, FRAME_LIMIT[0] + FRAME_LIMIT[1] * 6)
        mega = struct.unpack('<H', bytes(mem.unsigned[sym['gSovereignTestFoeMega']:sym['gSovereignTestFoeMega'] + 2]))[0]
        problem = ''
        if result != 'ok':
            problem = f'the battle: {result} after {frames} frames'
        elif SPECIES[mega] != species:
            problem = f'{SPECIES[mega] if mega else "nothing"} Mega Evolved, not {species}'
        if problem:
            d.screenshot().save(os.path.join(out, f'{trainer}.png'))
        results.append(f'{trainer}: {problem or "ok"}')
        print(results[-1], flush=True)
    print(f'{sum(r.endswith(": ok") for r in results)} of {len(results)} ok')
    sys.exit(0 if all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
