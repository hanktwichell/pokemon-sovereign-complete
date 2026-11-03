#!/usr/bin/env python3
"""Run Sovereign Complete's emulator tests (tools/complete/test_*.py) on a test build, a few at a time, and sum up.

Each test runs as its usage line says (ROM STATE OUT_DIR), from a bedroom state made on the same build
(tools/test/new_game.sh, made first when it's missing or older than the ROM), with TEST_BUILD set and SDL's dummy
drivers. Its output goes to .cache/tests/BUILD/NAME.log and its screenshots to .cache/tests/BUILD/NAME/; a test that
runs past its time is stopped with SIGKILL (SDL catches SIGTERM). The summary, a line per test ('ok', or FAIL with
its exit code and the last result line), is printed and kept in .cache/tests/BUILD/summary.txt.

The long ones (LONG: the story test, every map's wild Pokémon, every person's talk, every hidden item, every tile
behavior, every placement and boss Mega, the sound heap's every map) run only with --all or by name. Tools that aren't
ROM STATE OUT_DIR tests (OTHER) are left out.

From the repo root, after building a test build (tools/test/build_test_rom.sh, or make BUILD=build_test3 rom):
    TEST_BUILD=build_test3 python3 tools/complete/run_tests.py [--jobs N] [--all] [--minutes M] [NAME ...]
NAME is a test's name without test_ and .py (hgss_radio, follower_inhibit...).
"""
import argparse
import glob
import os
import signal
import subprocess
import sys
import time

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
LONG = {'hgss_opening', 'hgss_encounters', 'follower_talk', 'hgss_hidden_items', 'hgss_tile_behaviors', 'placed',
        'boss_megas', 'sound_heap'}
OTHER = {'follower', 'save', 'map_warp'}  # ROM-only tests and the warp tool


def tests():
    names = [os.path.basename(p)[len('test_'):-len('.py')]
             for p in glob.glob(os.path.join(ROOT, 'tools', 'complete', 'test_*.py'))]
    return sorted(n for n in names if n not in OTHER)


def last_result(log):
    """The log's last line that reads as a result ('...: ok', '... parts ok', '...: what went wrong')"""
    lines = [line.rstrip() for line in open(log, errors='replace') if line.strip()]
    for line in reversed(lines):
        if not line.startswith((' ', '\t')) and (' ok' in line or ': ' in line) and 'DeSmuME' not in line \
                and not line.startswith(('Slot1', 'BackupDevice', 'CPU mode', 'WIFI', 'Savestate', 'Save created')):
            return line[:160]
    return lines[-1][:160] if lines else '(no output)'


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    parser.add_argument('names', nargs='*')
    parser.add_argument('--jobs', type=int, default=2)
    parser.add_argument('--all', action='store_true')
    parser.add_argument('--minutes', type=float, default=90, help='each test\'s time limit')
    args = parser.parse_args()

    build = os.environ.get('TEST_BUILD', 'build_test')
    rom = os.path.join(ROOT, 'decomp', build, 'pokeplatinum.us.nds')
    out = os.path.join(ROOT, '.cache', 'tests', build)
    state = os.path.join(out, 'bedroom.state')
    os.makedirs(out, exist_ok=True)
    env = dict(os.environ, TEST_BUILD=build, SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')

    chosen = args.names or [n for n in tests() if args.all or n not in LONG]
    unknown = [n for n in chosen if not os.path.exists(os.path.join(ROOT, 'tools', 'complete', f'test_{n}.py'))]
    if unknown:
        sys.exit(f'no such test: {", ".join(unknown)}')

    if not os.path.exists(state) or os.path.getmtime(state) < os.path.getmtime(rom):
        print(f'making the bedroom state on {build}', flush=True)
        subprocess.run([os.path.join(ROOT, 'tools', 'test', 'new_game.sh'), rom, state, os.path.join(out, 'newgame')],
                       cwd=ROOT, env=env, check=True, stdout=subprocess.DEVNULL)

    waiting, running, results = list(chosen), {}, {}
    while waiting or running:
        while waiting and len(running) < args.jobs:
            name = waiting.pop(0)
            log = open(os.path.join(out, f'{name}.log'), 'w')
            proc = subprocess.Popen([sys.executable, os.path.join('tools', 'complete', f'test_{name}.py'), rom, state,
                                     os.path.join(out, name)], cwd=ROOT, env=env, stdout=log, stderr=subprocess.STDOUT)
            running[name] = (proc, log, time.time())
            print(f'started {name}', flush=True)
        time.sleep(5)
        for name, (proc, log, start) in list(running.items()):
            minutes = (time.time() - start) / 60
            if proc.poll() is None and minutes > args.minutes:
                os.kill(proc.pid, signal.SIGKILL)
                proc.wait()
                results[name] = (None, minutes)
            elif proc.poll() is not None:
                results[name] = (proc.returncode, minutes)
            else:
                continue
            log.close()
            del running[name]
            code = results[name][0]
            print(f'{name}: {"ok" if code == 0 else "FAIL"} ({minutes:.0f} min)', flush=True)

    lines = []
    for name in chosen:
        code, minutes = results[name]
        result = last_result(os.path.join(out, f'{name}.log'))
        status = 'ok' if code == 0 else 'TIMED OUT' if code is None else f'FAIL (exit {code})'
        lines.append(f'{name}: {status}, {minutes:.0f} min; {result}')
    summary = '\n'.join(lines) + f'\n{sum(results[n][0] == 0 for n in chosen)} of {len(chosen)} ok on {build}\n'
    open(os.path.join(out, 'summary.txt'), 'w').write(summary)
    print(summary, end='')
    sys.exit(0 if all(results[n][0] == 0 for n in chosen) else 1)


if __name__ == '__main__':
    main()
