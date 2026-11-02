#!/usr/bin/env python3
"""Show HeartGold's walking Pokémon following the player (test build): a contact sheet of the follower for each
species (and form) asked for.

From a bedroom state (tools/test/new_game.sh), the test warp takes the player out to New Bark Town; for each Pokémon,
the test build's gCompleteTestFollowerAction (COMPLETE_TEST_FOLLOWER_SET_LEAD, src/complete_follower.c) makes the lead
that species and form, the player takes two steps right so the follower comes out beside them, side on, and the
top screen around them is kept. gCompleteTestFollowerGfx gives the follower's graphics ID, which must be the species' sprite in the
range (tools/complete/gen_follower_sprites.py).

Usage: python3 tools/complete/show_followers.py ROM STATE OUT.png [SPECIES[:FORM] ...]
"""
import os
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
os.environ.setdefault('SDL_VIDEODRIVER', 'dummy')
os.environ.setdefault('SDL_AUDIODRIVER', 'dummy')
from PIL import Image, ImageDraw  # noqa: E402

from drive import Driver  # noqa: E402
from talk_to_objects import header_names, symbols, SYMBOLS, warp  # noqa: E402
from test_follower import follower, gfx, settle, symbol  # noqa: E402

DECOMP = os.path.join(HERE, '..', '..', 'decomp')
SET_LEAD = 3  # enum CompleteTestFollowerAction
DEFAULT = ['PIKACHU', 'CHARIZARD', 'TYPHLOSION', 'STEELIX', 'LUGIA', 'HO_OH', 'UNOWN:7', 'GARCHOMP', 'ARCEUS:9',
           'GYARADOS', 'MEWTWO', 'TOGEKISS']
NEW_BARK = ('MAP_HEADER_HGSS_NEW_BARK', 688, 395)  # below Elm's lab, open ground around


def main():
    rom, state, out = sys.argv[1:4]
    wanted = sys.argv[4:] or DEFAULT
    species = [line.strip() for line in open(os.path.join(DECOMP, 'generated', 'species.txt')) if line.strip()]
    d = Driver(rom, state)
    sym = symbols(SYMBOLS)
    tile, idle = symbol(rom, 'gCompleteTestFollowerTile'), symbol(rom, 'gSovereignTestIdleFrames')
    action, lead, gfx_at = (symbol(rom, n) for n in ('gCompleteTestFollowerAction', 'gCompleteTestFollowerLead',
                                                     'gCompleteTestFollowerGfx'))
    settle(d, idle)
    names = header_names()
    shots = []
    for entry in wanted:
        name, _, form = entry.partition(':')
        result, _ = warp(d, sym, names.index(NEW_BARK[0]), NEW_BARK[1], NEW_BARK[2], 0)
        if result != 'ok':
            sys.exit(f'the warp to New Bark Town: {result}')
        d.emu.memory.write_short(lead, species.index(f'SPECIES_{name}'))
        d.emu.memory.write_short(lead + 2, int(form or 0))
        d.emu.memory.write_byte(action, SET_LEAD)
        d.run(30)
        for key in ('RIGHT', 'RIGHT'):
            settle(d, idle)
            d.press(key, frames=16, after=24)
        settle(d, idle)
        d.run(30)
        g, f = gfx(d, gfx_at), follower(d, tile)
        print(f'{entry}: follower graphics {g}, on {f}, player on {d.pos()}', flush=True)
        top = d.screenshot().convert('RGB').crop((0, 0, 256, 192))
        shots.append((entry.replace(':', ' form '), top.crop((72, 40, 168, 136)).resize((192, 192), Image.NEAREST)))
    cols = 4
    sheet = Image.new('RGB', (cols * 196, ((len(shots) + cols - 1) // cols) * 212), (250, 250, 250))
    draw = ImageDraw.Draw(sheet)
    for i, (label, im) in enumerate(shots):
        x, y = (i % cols) * 196, (i // cols) * 212
        sheet.paste(im, (x + 2, y + 18))
        draw.text((x + 6, y + 3), label.title().replace('_', '-'), fill=(0, 0, 0))
    sheet.save(out)
    print(f'{len(shots)} followers: {out}')


if __name__ == '__main__':
    main()
