#!/usr/bin/env python3
"""Check the Pokéathlon Dome's Friendship Room statues (HeartGold's CreatePokeathlonFriendshipRoomStatues;
CompleteScrCmd_PokeathlonStatues in src/overlay007/complete_pokeathlon_shop.c), in the test build, from the bedroom
state: the three Pokémon of the save's friendship records stand in the room as their walking sprites, as in HeartGold.

1. The player warps into the room twice (a new game's records are empty; the first visit has the owner's welcome):
   no statues.
2. The test build's save probe (COMPLETE_TEST_SAVE_POKEATHLON_STATUES, include/complete_test.h) writes three records to
   the Pokéathlon's working copy: a female Pikachu, a Steelix and an Origin Forme Giratina. Back in the room, each
   stands on its spot, (4, 10), (7, 5) and (10, 10), as a map object with its local ID (0xF6 + i) and the walking
   sprite the record names (gCompleteTestPokeathlonStatues), and the room's picture changed there.
3. A male Pikachu and an Altered Forme Giratina: their sprites are the ones just before the female's and the Origin
   Forme's.
4. A record of a species with no walking sprite (past HeartGold's 493) and two empty ones: no statues, and the old ones
   are gone.

Results: a line per check, screenshots of each visit in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pokeathlon_statues.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

from PIL import ImageChops

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
from check_trainer_party import consts  # noqa: E402
from talk_to_objects import SYMBOLS, header_names, symbols, warp  # noqa: E402

ROOM = 'MAP_HEADER_HGSS_POKEATHLON_DOME_INTERIOR_B1F_FRIENDSHIP_ROOM'
STAND = (7, 12)  # two steps in from the room's door (7, 14), facing the statues
FACE_UP = 1  # warp's dir: enum FaceDirection + 1
SPOTS = [(4, 10), (7, 5), (10, 10)]  # HeartGold's sFriendshipRoomStatuesPositions
FIRST_LOCALID = 0xF6
GENDER_MALE, GENDER_FEMALE, GENDER_NONE = 0, 1, 2
STATUES = [('SPECIES_PIKACHU', 0, GENDER_FEMALE), ('SPECIES_STEELIX', 0, GENDER_MALE), ('SPECIES_GIRATINA', 1, GENDER_NONE)]
PLAIN = [('SPECIES_PIKACHU', 0, GENDER_MALE), ('SPECIES_STEELIX', 0, GENDER_MALE), ('SPECIES_GIRATINA', 0, GENDER_NONE)]
NO_SPRITE = [('SPECIES_SYLVEON', 0, GENDER_FEMALE), ('SPECIES_NONE', 0, 0), ('SPECIES_NONE', 0, 0)]
# CompleteTestSaveProbe (include/complete_test.h): u32 request, done, saveOK; u16 flags[5], vars[3], keyItems, balls;
# u32 athletePoints; u16 statueSpecies[3]; u8 statueForm[3], statueGender[3]
PROBE_STATUES = 5  # COMPLETE_TEST_SAVE_POKEATHLON_STATUES
PROBE_SPECIES, PROBE_FORM, PROBE_GENDER = 36, 42, 45
RAM, RAM_SIZE = 0x02000000, 0x400000
# MapObject (src/map_object.c): status, unk_04, localID, mapHeaderID, graphicsID ... x at 100, z at 108
MAPOBJ_GFX, MAPOBJ_X, MAPOBJ_Z = 16, 100, 108
# The room's picture where each statue stands (top screen, the player at STAND): a box around each spot
PIXELS = 16


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestSaveProbe', 'gCompleteTestPokeathlonStatues', 'gSovereignTestClock'))
    species_ids = consts('species.txt')
    ids = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory
    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    def marker():
        at = sym['gCompleteTestPokeathlonStatues']
        return struct.unpack('<4H', bytes(mem.unsigned[at:at + 8]))

    def statues():
        """The map objects with the statues' local IDs: {localID: (x, z, graphicsID)}."""
        ram, found = bytes(mem.unsigned[RAM:RAM + RAM_SIZE]), {}
        for local in range(FIRST_LOCALID, FIRST_LOCALID + 3):
            for m in re.finditer(struct.pack('<I', local), ram):
                o = m.start() - 8
                if o < 0 or o % 4 or not struct.unpack_from('<I', ram, o)[0] & 1:  # active
                    continue
                if struct.unpack_from('<I', ram, o + 12)[0] != ids.index(ROOM):
                    continue
                x, z = struct.unpack_from('<i', ram, o + MAPOBJ_X)[0], struct.unpack_from('<i', ram, o + MAPOBJ_Z)[0]
                found[local] = (x, z, struct.unpack_from('<I', ram, o + MAPOBJ_GFX)[0])
        return found

    def set_records(records):
        probe = sym['gCompleteTestSaveProbe']
        for i, (species, form, gender) in enumerate(records):
            mem.write_short(probe + PROBE_SPECIES + 2 * i, species_ids.index(species))
            mem.write_byte(probe + PROBE_FORM + i, form)
            mem.write_byte(probe + PROBE_GENDER + i, gender)
        mem.write_long(probe, PROBE_STATUES)
        for _ in range(40):
            d.run(30)
            request, done = struct.unpack('<II', bytes(mem.unsigned[probe:probe + 8]))
            if request == 0 and done == PROBE_STATUES:
                return True
        return False

    def visit(name):
        at = sym['gCompleteTestPokeathlonStatues']
        for i in range(4):
            mem.write_short(at + 2 * i, 0xFFFF if i else 0)
        result, frames = warp(d, sym, ids.index(ROOM), *STAND, FACE_UP)
        check(f'{name}: into the Friendship Room ({result} {frames})', result == 'ok')
        d.run(60)
        im = d.screenshot()
        im.save(os.path.join(out, name + '.png'))
        return im, marker(), statues()

    mem.write_byte(sym['gSovereignTestClock'], 12 + 1)  # noon (the clock takes the hour + 1)
    d.run(30)

    # 1. Empty records: the first visit plays the room's welcome (the owner walks the player in), so the empty room's
    # picture is the second visit's
    _, made, objects = visit('first_visit')
    check(f'first visit: no statues (made {made[1:]}, objects {objects})', made[1:] == (0, 0, 0) and not objects)
    empty, made, objects = visit('empty')
    check(f'empty: the room asked for its statues once (ran {made[0]})', made[0] == 1)
    check(f'empty: no statues (made {made[1:]}, objects {objects})', made[1:] == (0, 0, 0) and not objects)

    # 2. Three statues
    check('the probe wrote three records', set_records(STATUES))
    room, made, objects = visit('statues')
    check(f'statues: the room asked for its statues once (ran {made[0]})', made[0] == 1)
    for i, ((species, form, gender), spot) in enumerate(zip(STATUES, SPOTS)):
        gfx = made[1 + i]
        obj = objects.get(FIRST_LOCALID + i)
        check(f'{species} (form {form}): a walking sprite ({gfx}) on {spot} ({obj})',
              gfx not in (0, 0xFFFF) and obj == (*spot, gfx))
    diff = ImageChops.difference(empty.crop((0, 0, 256, 192)).convert('RGB'), room.crop((0, 0, 256, 192)).convert('RGB'))
    check(f'statues: the room\'s picture changed ({diff.getbbox()})', diff.getbbox() is not None)

    # 3. The male Pikachu and the Altered Forme Giratina: each the sprite before the other's (HeartGold's sprites list a
    # species' female or its other form right after it)
    check('the probe wrote a male Pikachu and an Altered Forme Giratina', set_records(PLAIN))
    _, plain, _ = visit('plain')
    check(f'the female Pikachu\'s sprite is her own ({made[1]}, the male\'s {plain[1]})', made[1] == plain[1] + 1)
    check(f'the Origin Forme\'s sprite is its own ({made[3]}, the Altered\'s {plain[3]})', made[3] == plain[3] + 1)

    # 4. No walking sprite, and empty records: the statues go
    check('the probe wrote a Sylveon and two empty records', set_records(NO_SPRITE))
    gone, made, objects = visit('no_sprite')
    check(f'no sprite: none made ({made[1:]}), none left ({objects})', made[1:] == (0, 0, 0) and not objects)
    diff = ImageChops.difference(empty.crop((0, 0, 256, 192)).convert('RGB'), gone.crop((0, 0, 256, 192)).convert('RGB'))
    check(f'no sprite: the room looks as it did empty ({diff.getbbox()})', diff.getbbox() is None)

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
