#!/usr/bin/env python3
"""The Indigo Plateau's Elite Four in Sovereign's format (docs/Features.md, "The Indigo Plateau's Elite Four"), on
each path through the formats: Sovereign's tools/test/elite_four_runs.py for Johto's League.

Will, Koga, Bruno and Karen: two single and two double battles, chosen as Sinnoh's League chooses them (Will and Koga
ask; when they got the same format, Bruno and Karen get the other and Koga says so after his battle; otherwise Bruno
asks and Karen takes what's left); Lance always a single battle. With the rematch teams (VAR_HGSS_UNK_4135 at 8),
Will first asks how to take them all on: all singles, all doubles, or two and two. A double battle with one Pokémon able
to fight warns first, and "no" makes it a single battle.

Each run starts from the bedroom state in god mode: the first test warp sets the rematch variable, then room by room
the player warps to where the last room's Kadabra (or the League's door) brings them (6, 15), the room's own scene walks
them in, they walk up to the member and talk, and the menus are answered with the run's picks. Lance's scene starts as
the player walks up to him. The battles the game starts (gSovereignTestTrainerBattles) must have the trainer and format
the rules give, and be won; the heaps must be intact after each.

From the repo root, with a test build and its bedroom state:
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_indigo_e4.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR [RUN ...]
"""
import collections
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'test'))
from battle_all_trainers import VBLANK_COUNTER, trainer_ids  # noqa: E402
from elite_four_runs import BATTLE_RESULT_WIN, BATTLE_TYPE_DOUBLES, FACE_UP, battles  # noqa: E402
from gift_pokemon import MENU_SETTLE, talk_and_answer  # noqa: E402
from heap_check import heap_info_address, heap_problems  # noqa: E402
from talk_to_objects import (FRAME_LIMIT, SYMBOLS, header_names, parse_args, play_out, symbols, u32,  # noqa: E402
                             var_ids, warp)

MEMBERS = ('WILL', 'KOGA', 'BRUNO', 'KAREN', 'LANCE')
S, D = 0, 1
ARRIVE = (6, 15)  # where the last room's Kadabra brings the player
WILL_ARRIVE = (6, 22)  # Will's room's door from the League's entrance hall
LANCE_ARRIVE = (6, 28)
AFTER_LANCE = 600

Run = collections.namedtuple('Run', 'name menu picks keep rematch')
RUNS = [
    Run('first challenge: singles, singles', None, (S, S), None, False),
    Run('first challenge: doubles, doubles', None, (D, D), None, False),
    Run('first challenge: singles, doubles, Bruno singles', None, (S, D, S), None, False),
    Run('first challenge: doubles, singles, Bruno doubles', None, (D, S, D), None, False),
    Run('rematch: all singles', 0, (), None, True),
    Run('rematch: all doubles', 1, (), None, True),
    Run('rematch: two and two, doubles, doubles', 2, (D, D), None, True),
    Run('one Pokemon, first challenge: doubles (no), singles', None, (D, S), (False, True, False), False),
]


def plan(run):
    """([the answers to each member's menus], [each battle's format]) for the run's five battles."""
    picks, keep = list(run.picks), list(run.keep or ())
    answers = [[] for _ in MEMBERS]

    def warned(member, fmt):  # before a double battle, with one Pokémon able to fight
        if fmt == D and run.keep is not None:
            answers[member].append(keep[0])
            return D if keep.pop(0) else S
        return fmt

    def ask(member):
        answers[member].append(picks[0])
        return warned(member, picks.pop(0))

    if run.menu is not None:
        answers[0].append(run.menu)
    if run.menu == 0:
        formats = [S] * 4
    elif run.menu == 1:
        formats = [warned(member, D) for member in range(4)]
    else:
        will = ask(0)
        koga = ask(1)
        if will == koga:  # Bruno and Karen get the other format
            bruno, karen = warned(2, 1 - will), warned(3, 1 - will)
        else:
            bruno = ask(2)
            karen = warned(3, 1 - bruno)
        formats = [will, koga, bruno, karen]
    assert not picks and not keep, run.name
    return answers, formats + [S]  # Lance: a single battle


def trainer(member, fmt, rematch):
    if member == 'LANCE':
        return 'TRAINER_HGSS_CHAMPION_LANCE_2' if rematch else 'TRAINER_HGSS_CHAMPION_LANCE'
    if fmt == D:
        return f'TRAINER_COMPLETE_INDIGO_{member}{"_REMATCH" if rematch else ""}_DOUBLES'
    return f'TRAINER_HGSS_ELITE_FOUR_{member}_{member}{"_2" if rematch else ""}'


def walk_to_member(d, sym):
    """The room's scene walks the player in; then up a step at a time until the member stands in the way."""
    idle, free, frames = sym['gSovereignTestIdleFrames'], 0, 0
    while free < 3 and frames < 900:  # the field runs free (no script) for a while: the scene is over
        before = u32(d, idle)
        d.run(10)
        frames += 10
        free = free + 1 if u32(d, idle) != before else 0
    if free < 3:
        return 'STUCK', frames
    blocked, menu = 0, sym['gSovereignTestMenu']
    for _ in range(14):
        pos, seen = d.pos(), u32(d, menu)
        d.press('UP', frames=8, after=16)
        if u32(d, menu) != seen:  # the test save's Super Repel runs out on the way: "Use another?" no
            d.run(MENU_SETTLE)
            d.press('B', frames=4, after=0)
            play_out(d, sym, FRAME_LIMIT, press_a=False)
            continue
        blocked = blocked + 1 if d.pos() == pos else 0
        if blocked >= 2:
            return 'ok', frames
    return 'STUCK', frames


def walk_to_lance(d, sym):
    """Up the long room until Lance's scene takes over."""
    idle = sym['gSovereignTestIdleFrames']
    for _ in range(40):
        before = u32(d, idle)
        d.press('UP', frames=14, after=2)
        if u32(d, idle) == before:  # a script runs: his scene
            return 'ok'
    return 'STUCK'


def run_league(d, sym, state, variables, ids, run, heaps, out, index):
    mem = d.emu.memory
    answers, formats = plan(run)
    names = dict(trainer_ids())
    d.load_state(state)
    d.run(30)
    mem.write_byte(sym['gSovereignTestGodMode'], 1)
    mem.write_byte(sym['gCompleteTestNoRepel'], 1)  # the test save's Super Repel ends at the first warp: no prompt
    mem.write_long(sym['gSovereignTestTrainerBattles'], 0)
    if run.keep is not None:
        mem.write_byte(sym['gSovereignTestPartyKeep'], 1)
    mem.write_short(sym['gSovereignTestVar'], variables['VAR_HGSS_UNK_4135'])  # applied by the first warp
    mem.write_short(sym['gSovereignTestVar'] + 2, 8 if run.rematch else 0)
    steps, total = [], 0
    for m, member in enumerate(MEMBERS):
        header = ids.index(f'MAP_HEADER_HGSS_POKEMON_LEAGUE_{member}_ROOM')
        x, z = {'LANCE': LANCE_ARRIVE, 'WILL': WILL_ARRIVE}.get(member, ARRIVE)
        result, frames = warp(d, sym, header, x, z, FACE_UP + 1)
        if result == 'ok' and member == 'LANCE':
            result = walk_to_lance(d, sym)
            if result == 'ok':
                result, frames = talk_and_answer(d, sym, answers[m], FRAME_LIMIT, press_a=False,
                                                 done=lambda: any(b[3] for b in battles(d, sym)[4:5]))
                for _ in range(AFTER_LANCE // 20):
                    d.press('A', frames=2, after=18)
        elif result == 'ok':
            result, frames = walk_to_member(d, sym)
            if result == 'ok':
                result, frames = talk_and_answer(d, sym, answers[m])
        d.screenshot().save(os.path.join(out, f'{index:02d}_{m}_{member.lower()}.png'))
        total += frames
        noted = battles(d, sym)
        got = noted[m] if len(noted) > m else None
        want = trainer(member, formats[m], run.rematch)
        wrong = [] if result == 'ok' else [result]
        if got is None:
            wrong.append(f'no battle (want {want})')
        else:
            first, _, kind, won = got
            fmt = D if kind & BATTLE_TYPE_DOUBLES else S
            if names.get(first) != want:
                wrong.append(f'trainer {names.get(first, first)} (want {want})')
            if fmt != formats[m]:
                wrong.append(f'{"doubles" if fmt else "singles"} (want {"doubles" if formats[m] else "singles"})')
            if won != BATTLE_RESULT_WIN:
                wrong.append(f'result {won:#x}')
        if len(noted) > m + 1:
            wrong.append(f'{len(noted) - m - 1} more battles')
        wrong += [f'heap {heap_id}: {problem}' for heap_id, problem in heap_problems(mem, heaps)]
        steps.append((member, None if got is None else D if got[2] & BATTLE_TYPE_DOUBLES else S, wrong))
        if wrong:
            break
    return steps, total


def main():
    from drive import Driver

    rom, state, out, only, part, parts = parse_args(sys.argv[1:])
    sym = symbols(SYMBOLS + ('gSovereignTestMenu', 'gSovereignTestPartyKeep', 'gSovereignTestTrainerBattles',
                           'gCompleteTestNoRepel'))
    variables = var_ids()
    ids = header_names()
    heaps = heap_info_address()
    chosen = [(i, r) for i, r in enumerate(RUNS) if (not only or str(i) in only) and i % parts == part]
    d = Driver(rom, state)
    d.added, d.armed = [], False
    bad = 0
    with open(os.path.join(out, 'results.txt'), 'w') as f:
        for index, run in chosen:
            steps, frames = run_league(d, sym, state, variables, ids, run, heaps, out, index)
            vblank = u32(d, sym['gSystem'] + VBLANK_COUNTER)
            d.run(30)
            if u32(d, sym['gSystem'] + VBLANK_COUNTER) == vblank:
                steps[-1][2].append('HANG after the run')
            failed = len(steps) < len(MEMBERS) or any(wrong for _, _, wrong in steps)
            bad += failed
            what = ', '.join(f'{member.lower()} {"-" if fmt is None else "SD"[fmt]}' for member, fmt, _ in steps)
            line = f'{index} {run.name}: {what}: {"FAIL" if failed else "ok"} {frames}' + ''.join(
                f'\n    WRONG {member.lower()}: {w}' for member, _, wrong in steps for w in wrong)
            print(line, file=f, flush=True)
            print(line, flush=True)
        print(f'{len(chosen) - bad} of {len(chosen)} runs ok', file=f)
    print(f'{len(chosen) - bad} of {len(chosen)} runs ok')
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
