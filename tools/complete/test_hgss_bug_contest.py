#!/usr/bin/env python3
"""Check HeartGold's Bug-Catching Contest in the test build (src/complete_bug_contest.c; docs/Features.md), from the
bedroom state, on a Tuesday (gSovereignTestClock's weekday), with the party cut to two (gSovereignTestPartyKeep):

1. **Entry:** talking to the Route 36 gate's guard and answering yes twice (to the contest, and to leaving the second
   Pokémon with him), the player is on the contest map with one Pokémon, and the contest runs (sBugContest).
2. **Encounters:** a survey (wild_forms.py's) of the contest map's grass: every Pokémon is one of the day's ten, at
   that slot's levels.
3. **A battle:** walking in the grass until one starts, the wild Pokémon is put to sleep at 1 HP, and BALL (BAG's
   button) throws a Sport Ball, drawn as itself (its own colours on the top screen as it flies: test_hgss_balls.py's
   check), until one catches it (A on the Pokédex's page, B elsewhere). The contest keeps it, with a Sport Ball fewer
   for each thrown. Then a second battle's menu must show the kept Pokémon over it (its icon, gender and level, where
   the first battle's had none), and RUN ends that battle.
4. **Time up:** with the contest's start moved back 21 minutes, the announcement plays, the player goes to the
   National Park, and the judging runs (no nickname). Then the contest is over, and the party is the two Pokémon and
   the caught one, in its Sport Ball.

Results: one line per part, 'ok' or what went wrong, and a screenshot of a part that failed.

From the repo root, with the test build and a bedroom state (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_bug_contest.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from check_object_tiles import Maps  # noqa: E402
from check_trainer_party import consts  # noqa: E402
from gift_pokemon import MON, PARTY, talk_and_answer  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS as TALK_SYMBOLS, arrive, cases, header_names, u32, var_ids, warp  # noqa: E402
from wild_forms import MON_SIZE, SURVEY, run_survey  # noqa: E402
from test_hgss_balls import SHOWN, THROW_FRAMES, THROW_STEP, own_colours, shown  # noqa: E402

GATE = ('events_hgss_101', 'obj_R36R0201_counterm_2')  # Route 36's gatehouse guard on contest days (the other, on others)
CONTEST_MAP = 'MAP_HEADER_HGSS_NATIONAL_PARK_BUG_CATCHING_CONTEST'
CONTEST_MATRIX = 'map_matrix_hgss_0027'
PARK_MAP = 'MAP_HEADER_HGSS_NATIONAL_PARK'
TUESDAY = 2
CLOCK_WEEKDAY = 2  # offsetof(struct SovereignTestClock, weekday)
TALL_GRASS = 2  # TILE_BEHAVIOR_TALL_GRASS
SLEEP = 3  # MON_CONDITION_SLEEP: asleep for 3 turns
# struct BugContest (src/complete_bug_contest.c)
CONTEST = {'startTime': 0, 'nationalDex': 24, 'caught': 28, 'sportBalls': 32}
SPORT_BALL_ITEM = 'ITEM_SPORT_BALL'
STEPS_MAX = 300
HOME_STEPS = 25
BATTLE_FRAMES = 6000
BAG = (35, 165)
RUN = (128, 180)
# Over the menu, between the bug net and the Sport Ball: the kept Pokémon's icon, gender and level (HeartGold's
# BattleInput_CreateMainMenuObjects; in screenshot pixels, the bottom screen from y 192)
KEPT_BOX = (104, 192, 184, 216)
KEPT_SHOWN = 40  # pixels there that change once a Pokémon is kept
POKEDEX_BANNER = ((200, 4), (248, 208, 0))
SYMBOLS = tuple(set(TALK_SYMBOLS) | set(bm.SYMBOLS) | {
    'gSovereignTestParty', 'gSovereignTestMenu', 'gSovereignTestWildSurvey', 'gSovereignTestPlayerTile', 'sBugContest'})


def day_set(national):
    """The day's ten (species, min level, max level) for a Tuesday, from the engine's table."""
    text = open(os.path.join(DECOMP, 'include', 'data', 'complete_bug_contest.h')).read()
    rows = re.findall(r'\{ (SPECIES_\w+), (\d+), (\d+), \d+, \d+ \}', text)
    s = TUESDAY // 2 if national else 0
    return [(name, int(lo), int(hi)) for name, lo, hi in rows[s * 10:(s + 1) * 10]]


def note_party(d, sym):
    """[(species, ball, friendship)] of the party, as the field writes it down."""
    mem, at = d.emu.memory, sym['gSovereignTestParty']
    mem.write_byte(at + PARTY['wanted'], 1)
    for _ in range(60):
        d.run(2)
        if mem.unsigned[at + PARTY['wanted']] == 0:
            break
    size = struct.calcsize(MON)
    out = []
    for i in range(mem.unsigned[at + PARTY['count']]):
        fields = struct.unpack(MON, bytes(mem.unsigned[at + PARTY['mons'] + i * size:at + PARTY['mons'] + (i + 1) * size]))
        out.append((fields[0], fields[-2], fields[-1]))
    return out


def contest(d, sym):
    return u32(d, sym['sBugContest'])


def field(d, sym, name, size=4):
    at = contest(d, sym) + CONTEST[name]
    return int.from_bytes(bytes(d.emu.memory.unsigned[at:at + size]), 'little')


def grass_spot(maps):
    """A tall-grass tile with tall grass to its east, nearest the contest map's way in."""
    spots = [(x, z) for z in range(96) for x in range(127)
             if all((maps.tile(CONTEST_MATRIX, x + dx, z) or 0) & 0xff == TALL_GRASS for dx in (0, 1))]
    return min(spots, key=lambda p: abs(p[0] - 75) + abs(p[1] - 39))


def menu_up(d):
    """Whether the battle's menu is on the bottom screen (BALL's button)."""
    return d.screenshot().convert('RGB').getpixel((20, 350)) == (224, 152, 40)


def start_battle(d, b, home):
    """Walk in the grass until a battle starts, back on its tile (home()) every so often: a step blocked one way
    walks the player off the grass. Returns '' or what went wrong."""
    for step in range(STEPS_MAX):
        if step and step % HOME_STEPS == 0:
            home()
        d.press('RIGHT' if step % 2 == 0 else 'LEFT', frames=20, after=8)  # long enough to turn and step
        if b.mons():
            return ''
        d.press('B', frames=4, after=4)  # the bedroom state's Super Repel wears off: no other
    return f'no battle in {STEPS_MAX} steps'


def battle(d, sym, names, home):
    """Walk in the grass until a battle starts, then catch with Sport Balls (thrown again after a miss). Returns
    ('' or what went wrong, the Balls thrown, the menu's screenshot)."""
    b = bm.Battle(d, sym)
    problem = start_battle(d, b, home)
    if problem:
        return problem, 0, None
    phase, frames, thrown, menu = 'start', 0, 0, None
    while frames < BATTLE_FRAMES:
        d.run(10)
        frames += 10
        if phase == 'start' and b.mons() and b.read(bm.FOE_B, 'maxHP', 4):
            d.run(60)
            frames += 60
            b.write(bm.FOE_B, 'curHP', 1, 4)
            b.write(bm.FOE_B, 'status', SLEEP, 4)
            phase = 'menu'
        elif phase in ('menu', 'thrown') and b.mons() and menu_up(d):  # the first throw, or the next after a miss
            d.run(20)
            menu = menu or d.screenshot()
            colours = own_colours('SPORT_BALL')
            before_throw = shown(d.screenshot(), colours)
            d.touch(*BAG, frames=4, after=0)
            thrown += 1
            most = 0
            for _ in range(0, THROW_FRAMES, THROW_STEP):
                d.run(THROW_STEP)
                most = max(most, shown(d.screenshot(), colours) - before_throw)
            frames += 4 + THROW_FRAMES
            if most < SHOWN:
                return f'the Sport Ball wasn\'t drawn as itself ({most} pixels of its own colours)', thrown, menu
            phase = 'thrown'
        elif phase == 'thrown':
            if not b.mons():
                idle = u32(d, sym['gSovereignTestIdleFrames'])
                d.run(30)
                if u32(d, sym['gSovereignTestIdleFrames']) != idle:
                    return '', thrown, menu
            pixel, banner = POKEDEX_BANNER
            d.press('A' if d.screenshot().convert('RGB').getpixel(pixel) == banner else 'B', frames=4, after=20)
            frames += 24
    return f'battle not over ({phase})', thrown, menu


def kept_menu(d, sym, home):
    """A second battle's menu, which shows the kept Pokémon over it; then RUN. Returns ('' or what went wrong, the
    menu's screenshot)."""
    b = bm.Battle(d, sym)
    problem = start_battle(d, b, home)
    if problem:
        return problem, None
    for _ in range(BATTLE_FRAMES // 10):
        d.run(10)
        if b.mons() and menu_up(d):
            break
    else:
        return 'the second battle\'s menu never came', None
    d.run(20)
    menu = d.screenshot()
    d.touch(*RUN, frames=4, after=60)
    for _ in range(BATTLE_FRAMES // 10):
        d.press('B', frames=4, after=6)
        if not b.mons():
            idle = u32(d, sym['gSovereignTestIdleFrames'])
            d.run(30)
            if u32(d, sym['gSovereignTestIdleFrames']) != idle:
                return '', menu
    return 'the second battle didn\'t end', menu


def changed(before, after, box):
    """How many of the box's pixels differ between two screenshots."""
    one, two = before.convert('RGB').crop(box).tobytes(), after.convert('RGB').crop(box).tobytes()
    return sum(1 for i in range(0, len(one), 3) if one[i:i + 3] != two[i:i + 3])


def main():
    from drive import Driver
    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = {k: consts(k + '.txt') for k in ('species', 'moves', 'items', 'abilities', 'trainers')}
    headers = header_names()
    variables = var_ids()
    guard = next(c for c in cases() if c[:2] == GATE)
    _, _, header, way_in, x, z, face = guard
    d = Driver(rom, state)
    mem = d.emu.memory
    results = []

    def part(name, problem):
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)
        if problem:
            d.screenshot().save(os.path.join(out, f'{name}.png'))
        return not problem

    def setup():
        mem.write_byte(sym['gSovereignTestClock'] + CLOCK_WEEKDAY, TUESDAY + 1)
        mem.write_byte(sym['gSovereignTestPartyKeep'], 2)

    # 1. Entry
    arrived, _ = arrive(d, sym, state, variables, GATE[0], header, way_in, x, z, face, setup=setup)
    mem.write_byte(sym['gSovereignTestGodMode'], 0)  # the contest's battle must be able to catch
    mem.write_byte(sym['gSovereignTestClock'], 0)  # the real time again (a set hour reads minute 0): the contest's clock
    problem = '' if arrived == 'ok' else arrived
    if not problem:
        result, _ = talk_and_answer(d, sym, [True, True])
        party = note_party(d, sym)
        where = headers[u32(d, sym['gSovereignTestIdleMapHeaderID'])]
        if result != 'ok':
            problem = f'the guard\'s script: {result}'
        elif where != CONTEST_MAP:
            problem = f'on {where}'
        elif len(party) != 1 or not contest(d, sym):
            problem = f'party {len(party)}, contest {contest(d, sym):#x}'
    if not part('entry', problem):
        return finish(results)

    # 2. Encounters
    national = field(d, sym, 'nationalDex') != 0  # the contest's own reading of it
    allowed = {(names['species'].index(s), lv) for s, lo, hi in day_set(national) for lv in range(lo, hi + 1)}
    survey = sym['gSovereignTestWildSurvey']
    count = run_survey(d, survey, 0)
    seen = [struct.unpack('<IHBB', bytes(mem.unsigned[survey + SURVEY['mons'] + i * MON_SIZE:
                                                      survey + SURVEY['mons'] + (i + 1) * MON_SIZE]))
            for i in range(max(count, 0))]
    wrong = [(names['species'][s], lv) for _, s, _, lv in seen if (s, lv) not in allowed]
    part('encounters', f'survey made {count}' if count <= 0 else
         f'{len(wrong)} of {count} not the day\'s: {wrong[:5]}' if wrong else '')

    # 3. A battle
    gx, gz = grass_spot(Maps(DECOMP))

    def home():
        return warp(d, sym, headers.index(CONTEST_MAP), gx, gz, 0)[0]

    arrived = home()
    problem, thrown, first_menu = (battle(d, sym, names, home) if arrived == 'ok' else
                                   (f'warp to the grass: {arrived}', 0, None))
    balls = field(d, sym, 'sportBalls', 2)
    if not problem and (field(d, sym, 'caught') != 1 or balls != 20 - thrown):
        problem = f'caught {field(d, sym, "caught")}, Sport Balls {balls} after {thrown} thrown'
    if not problem:
        arrived = home()  # the walk can have left the grass
        problem, second_menu = kept_menu(d, sym, home) if arrived == 'ok' else (f'warp back: {arrived}', None)
        problem = problem and f'the second battle: {problem}'
        if os.environ.get('SHOTS') and first_menu and second_menu:
            first_menu.save(os.path.join(out, 'menu_first.png'))
            second_menu.save(os.path.join(out, 'menu_kept.png'))
        kept = changed(first_menu, second_menu, KEPT_BOX) if not problem else 0
        if not problem and kept < KEPT_SHOWN:
            problem = f'the second battle\'s menu doesn\'t show the kept Pokémon ({kept} pixels changed)'
    if not part('battle', problem):
        return finish(results)

    # 4. Time up and the judging
    at = contest(d, sym) + CONTEST['startTime']
    start = struct.unpack('<q', bytes(mem.unsigned[at:at + 8]))[0]
    for i, byte in enumerate(struct.pack('<q', start - 21 * 60)):
        mem.write_byte(at + i, byte)
    problem = ''
    for _ in range(3):  # the announcement, then the judging on arriving at the National Park
        result, _ = talk_and_answer(d, sym, [False] if headers[u32(d, sym['gSovereignTestIdleMapHeaderID'])] == PARK_MAP
                                    else [], press_a=False)
        if not contest(d, sym):
            break
    party = note_party(d, sym)
    where = headers[u32(d, sym['gSovereignTestIdleMapHeaderID'])]
    day = {names['species'].index(s) for s, _, _ in day_set(national)}
    if contest(d, sym):
        problem = f'contest still running on {where} ({result})'
    elif where != PARK_MAP:
        problem = f'on {where}'
    elif len(party) != 3 or party[2][0] not in day or party[2][1] != names['items'].index(SPORT_BALL_ITEM):
        problem = f'party {[(names["species"][s], names["items"][b]) for s, b, _ in party]}'
    part('judging', problem)
    finish(results)


def finish(results):
    print(f'{sum(r.endswith(": ok") for r in results)} of 4 parts ok')
    sys.exit(0 if len(results) == 4 and all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
