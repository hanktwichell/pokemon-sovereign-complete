#!/usr/bin/env python3
"""Check that Johto and Kanto's new flags and vars survive a save (test build).

Starts a new game on the test build, then through gCompleteTestSaveProbe (src/complete_test.c):
1. sets four of the new flags (the first, 0x0FFF, 0x1000 and the last) and the first and last new vars;
2. saves as the start menu does (FieldSystem_Save);
3. boots again from that battery, CONTINUEs, and reads them back: the four flags are set, a fifth new flag (5000) is
   not, the two vars hold their values, and Sinnoh's last var is still 0.
Step 1 also puts one of every key item and every Ball in the bag, and step 3 looks for each: all must fit (the
Key Items and Poké Balls pockets, include/bag.h) and be there after the reload.

The Pokéathlon's save (include/complete_pokeathlon.h) counts only once the game is saved, as HeartGold's does: step 1
gives 1234 Athlete Points, which the save keeps; after the save 500 more are given and the game isn't saved again, so
after the reload there are 1234.

A save that loaded as "no save data" (a layout mismatch) would leave only NEW GAME on the main menu, and CONTINUE would
start a new game instead: the read-back then finds the flags clear.

With --then NEW_ROM, the battery is then continued on another build (in a process of its own: --read BATTERY), as a
player's save would be after an update: the flags, vars and bag must read back the same, and the Athlete Points the
given number (--athlete-points, the saved 1234 by default; 0 when the new build's Pokéathlon save has another size, so
its sector starts fresh).

Usage: python3 tools/complete/test_save.py [ROM] [--then NEW_ROM [--athlete-points N]]
       (ROM defaults to decomp/build_test/pokeplatinum.us.nds)
"""
import glob
import json
import os
import struct
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
os.environ.setdefault('SDL_VIDEODRIVER', 'dummy')
os.environ.setdefault('SDL_AUDIODRIVER', 'dummy')
from drive import Driver  # noqa: E402
from test_follower import Check, settle, symbol  # noqa: E402

NONE, WRITE, SAVE, READ, POKEATHLON_UNSAVED = 0, 1, 2, 3, 4
# CompleteTestSaveProbe: u32 request, done, saveOK; u16 flags[5], vars[3], keyItems, balls; u32 athletePoints
PROBE_FORMAT = '<III5H3H2HI'
WANT_FLAGS = (1, 1, 1, 1, 0)
WANT_VARS = (0xC0DE, 0xBEEF, 0)


def pocket_counts():
    """How many items the Key Items and Poké Balls pockets hold, one of each (res/items/data)."""
    pockets = [json.load(open(p, encoding='utf-8')).get('fieldPocket')
               for p in glob.glob(os.path.join(HERE, '..', '..', 'decomp', 'res', 'items', 'data', '*.json'))]
    return pockets.count('POCKET_KEY_ITEMS'), pockets.count('POCKET_BALLS')


def probe(d, addr):
    size = struct.calcsize(PROBE_FORMAT)
    return struct.unpack(PROBE_FORMAT, bytes(d.emu.memory.unsigned[addr:addr + size]))


def ask(d, addr, idle_addr, request, frames=600):
    """Write request, then run until the game reports it done. Returns the probe."""
    settle(d, idle_addr)
    d.emu.memory.write_long(addr, request)
    for _ in range(frames // 30):
        d.run(30)
        values = probe(d, addr)
        if values[1] == request and values[0] == NONE:
            return values
    return None


def option(name, default=None):
    return sys.argv[sys.argv.index(name) + 1] if name in sys.argv else default


def read_back(d, addr, idle_addr, check, want_bag, athlete_points):
    """Title and CONTINUE (the first entry once a save exists), then the probe's flags, vars, bag and points."""
    for action in ['wait:600', 'A', 'wait:200', 'A', 'wait:200', 'A', 'wait:600']:
        d.do(action)
    values = ask(d, addr, idle_addr, READ)
    check(values is not None, 'the probe was read back after CONTINUE')
    if values:
        flags, vars_ = values[3:8], values[8:11]
        check(tuple(flags) == WANT_FLAGS, f'flags after the reload: {flags} (want {WANT_FLAGS})')
        check(tuple(vars_) == WANT_VARS, 'vars after the reload: ' + ', '.join(f'0x{v:04X}' for v in vars_)
              + ' (want ' + ', '.join(f'0x{v:04X}' for v in WANT_VARS) + ')')
        check(tuple(values[11:13]) == want_bag, f'key items and Balls in the bag after the reload: {values[11:13]} '
              f'(want {want_bag})')
        check(values[13] == athlete_points, f'Athlete Points after the reload: {values[13]} (want {athlete_points})')


def continue_on(rom, battery, athlete_points):
    """--read: continue a battery made by another build on this one."""
    addr = symbol(rom, 'gCompleteTestSaveProbe')
    idle_addr = symbol(rom, 'gSovereignTestIdleFrames')
    check = Check()
    d = Driver(rom, battery=battery)
    read_back(d, addr, idle_addr, check, pocket_counts(), athlete_points)
    print('PASS' if check.failures == 0 else f'FAIL ({check.failures})')
    sys.exit(check.failures != 0)


def main():
    args = [a for i, a in enumerate(sys.argv[1:], 1)
            if not a.startswith('--') and not sys.argv[i - 1].startswith('--')]
    rom = args[0] if args else os.path.join(HERE, '..', '..', 'decomp/build_test/pokeplatinum.us.nds')
    if '--read' in sys.argv:
        continue_on(rom, option('--read'), int(option('--athlete-points', 1234)))
    addr = symbol(rom, 'gCompleteTestSaveProbe')
    idle_addr = symbol(rom, 'gSovereignTestIdleFrames')
    check = Check()

    d = Driver(rom)
    for action in ['wait:600', 'A', 'wait:200', 'A', 'wait:200', 'A', 'wait:400'] + ['A', 'wait:60'] * 12 + ['wait:120']:
        d.do(action)
    want_bag = pocket_counts()
    written = ask(d, addr, idle_addr, WRITE)
    check(written is not None, 'the probe flags and vars are set')
    if written:
        check(tuple(written[11:13]) == want_bag, f'key items and Balls put in the bag: {written[11:13]} (want {want_bag})')
    if written:
        check(written[13] == 1234, f'Athlete Points given: {written[13]} (want 1234)')
    saved = ask(d, addr, idle_addr, SAVE, frames=3600)
    check(saved is not None and saved[2] == 1, f'the game saved (FieldSystem_Save: {saved and saved[2]})')
    unsaved = ask(d, addr, idle_addr, POKEATHLON_UNSAVED)
    check(unsaved is not None and unsaved[13] == 1734, f'500 more Athlete Points, not saved: {unsaved and unsaved[13]} '
          '(want 1734)')
    d.run(600)
    battery = os.path.join(tempfile.mkdtemp(), 'complete_save_test.sav')
    d.do('export:' + battery)

    # Boot again from that battery in the same emulator (a second emulator in one process crashes py-desmume), then
    # title and CONTINUE (the first entry once a save exists).
    d.emu.backup.import_file(battery)
    d.emu.reset()
    read_back(d, addr, idle_addr, check, want_bag, 1234)  # the saved 1234, not 1734

    new_rom = option('--then')
    if new_rom:
        import subprocess
        result = subprocess.run([sys.executable, os.path.abspath(__file__), new_rom, '--read', battery,
                                 '--athlete-points', option('--athlete-points', '1234')],
                                capture_output=True, text=True)
        print(f'continued on {new_rom}:')
        print('\n'.join('  ' + line for line in result.stdout.splitlines()[-8:]))
        check(result.returncode == 0, f'the save continues on {new_rom}')

    print('PASS' if check.failures == 0 else f'FAIL ({check.failures})')
    sys.exit(check.failures != 0)


if __name__ == '__main__':
    main()
