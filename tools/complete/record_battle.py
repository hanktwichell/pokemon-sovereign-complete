#!/usr/bin/env python3
"""Record a battle on video in the test build, played as a player would: the player's lead made a given Pokémon (its
item, moves, the MEGA toggle on so it Mega Evolves on its first move), the rest of the team Lv. 100 Pokémon of the
caller's choosing.

The lead comes from the test build's gSovereignTestLead (include/sovereign_test.h, src/overlay005/field_control.c),
which a test battle applies as it starts: a wild one (SELECT) the player runs from, so the lead stays made. The team
comes from two test warps onto the player's own tile (gSovereignTestPartyKeep keeps the lead, gSovereignTestPartyAdd
adds three Pokémon a warp). No EXP is gained (gSovereignTestNoExp), so no level-up or new-move prompt holds the battle
up. Then the battle, recorded from here:
- by default, a room's own scene: the test warp into the room (Cynthia's, the Champion room, unless --room says
  another), whose scene walks the player up to the trainer and starts the battle, as in the game;
- with --trainer, a test trainer battle where the player stands (SELECT+R with gSovereignTestBattleTrainer).
With --party-from TRAINER the party is that trainer's team instead, as its battle builds it (items, moves, abilities;
gCompleteTestPartyFromTrainer), owned by the player, with the MEGA toggle on: the developer team, TRAINER_SOVEREIGN_TEST,
for the owner's final boss team. --var VAR_NAME=VALUE sets a var as the team's warp is made (VAR_SOVEREIGN_E4_FORMAT=16
for Cynthia's double battle, as Aaron's room sets it). A double battle is played too: each of the player's Pokémon
picks the move and the foe that it does the most to (a move that hits both foes counts both).
Either is a real battle unless --god makes it the test build's one-sided one (gSovereignTestGodMode: a foe that loses
any HP faints, the player's Pokémon lose none, fast text).

The battle is played from the bottom screen: on the command menu, FIGHT, then the move of the Pokémon out (its own, from the battle) that does the most to
the foe out (its power, the user's type bonus, the sun's or rain's, and the type chart, src/battle/battle_lib.c, against the
foe's types in gSovereignTestBattleMons); everything else (messages, the "Will you switch?" prompt) gets B, so the
player never switches by choice. If the lead faints, the party screen's next Pokémon is sent out. Before the battle
(the scene's lines) A pages the text; the recording ends a few seconds after the battle does (its Pokémon freed).

The recording (both screens, test_hgss_opening.py's Recorder) is cut to an MP4 of both screens at twice the size.

From the repo root, with the test build and a save state in the field made with it (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/record_battle.py ROM STATE OUT.mp4 \\
        SPECIES_CHARIZARD ITEM_CHARIZARDITE_Y MOVE_FLAMETHROWER,MOVE_SOLAR_BEAM,MOVE_AIR_SLASH,MOVE_FOCUS_BLAST \\
        [--team SPECIES_FERALIGATR,...] [--room MAP_HEADER_...:X:Z | --trainer TRAINER_...] [--god] [--level N]\\
        [--nature MODEST] [--delay FRAMES]
    ... ROM STATE OUT.mp4 --party-from TRAINER_SOVEREIGN_TEST --var VAR_SOVEREIGN_E4_FORMAT=16 [--room ...]
"""
import json
import os
import re
import struct
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'test'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'complete'))
os.environ.setdefault('SDL_VIDEODRIVER', 'dummy')
os.environ.setdefault('SDL_AUDIODRIVER', 'dummy')
from battle_all_trainers import HANG_FRAMES, STEP, VBLANK_COUNTER, symbols, trainer_ids  # noqa: E402
from talk_to_objects import SYMBOLS, header_names, warp  # noqa: E402

DECOMP = os.path.join(ROOT, 'decomp')
# struct SovereignTestLead (include/sovereign_test.h)
LEAD = {'species': 0, 'form': 2, 'level': 3, 'item': 4, 'moves': 6, 'mega': 14, 'personality': 20}
NATURES = ('HARDY', 'LONELY', 'BRAVE', 'ADAMANT', 'NAUGHTY', 'BOLD', 'DOCILE', 'RELAXED', 'IMPISH', 'LAX', 'TIMID',
           'HASTY', 'SERIOUS', 'JOLLY', 'NAIVE', 'MODEST', 'MILD', 'QUIET', 'BASHFUL', 'RASH', 'CALM', 'GENTLE', 'SASSY',
           'CAREFUL', 'QUIRKY')  # a personality's nature is personality % 25
PARTY_ADDS = 3  # SOVEREIGN_TEST_PARTY_ADDS: struct SovereignTestPartyAdd {u16 species; u8 form; u8 level;}
# struct SovereignTestBattleMons: the pointer, then u16 sizes and offsets
BATTLE_MONS = ('size', 'moves', 'statBoosts', 'types', 'ability', 'ppCur', 'friendship', 'curHP', 'maxHP', 'status',
               'statusVolatile', 'heldItem')
# Against Cynthia's: Ice and Fairy for Garchomp, Electric for Milotic and Togekiss, Steel and Fire for the rest
DEFAULT_TEAM = ['SPECIES_MAMOSWINE', 'SPECIES_GARDEVOIR', 'SPECIES_HEATRAN', 'SPECIES_RAIKOU', 'SPECIES_METAGROSS']
DEFAULT_ROOM = ('MAP_HEADER_POKEMON_LEAGUE_CHAMPION_ROOM', 8, 17)  # inside the door, facing Cynthia
FACE_UP = 1  # enum FaceDirection + 1, for the test warp
# Bottom-screen touch spots (256x192): the command menu's FIGHT, and the move menu's four moves
FIGHT, RUN = (128, 70), (128, 174)
MOVE_SPOTS = ((64, 50), (192, 50), (64, 114), (192, 114))
PARTY_SLOTS = ((60, 30), (190, 30), (60, 80), (190, 86), (60, 128), (190, 134))  # the party screen's panels
PARTY_SHIFT = (128, 100)  # the chosen Pokémon's SHIFT
# A double battle's target screen: the foes' boxes on top (battler 1, the first foe, on the right; battler 3 on the
# left), the player's below (as seen in Cynthia's battle)
TARGET_SPOTS = {1: (190, 30), 3: (64, 30)}
SPREAD = ('RANGE_ADJACENT_OPPONENTS', 'RANGE_ALL_ADJACENT')  # moves that hit both foes: no target to pick
SUN, RAIN = 'TYPE_FIRE', 'TYPE_WATER'  # the types the weather boosts
FRAME_LIMIT = 60 * 60 * 45


def names(kind):
    return [line.strip() for line in open(os.path.join(DECOMP, 'generated', f'{kind}.txt')) if line.strip()]


def type_chart():
    """{(attacking, defending): multiplier}, from the battle's own table (src/battle/battle_lib.c)."""
    src = open(os.path.join(DECOMP, 'src', 'battle', 'battle_lib.c')).read()
    table = src[src.index('sTypeMatchupMultipliers[][3] = {'):]
    table = table[:table.index('};')]
    value = {'TYPE_MULTI_SUPER_EFF': 2.0, 'TYPE_MULTI_NOT_VERY_EFF': 0.5, 'TYPE_MULTI_IMMUNE': 0.0}
    chart = {}
    for attacking, defending, multi in re.findall(r'\{ (TYPE_\w+), (TYPE_\w+), (TYPE_MULTI_\w+) \}', table):
        chart.setdefault((attacking, defending), value.get(multi, 1.0))  # Foresight's lines come after: kept first
    return chart


def move_data(move):
    path = os.path.join(DECOMP, 'res', 'moves', move[len('MOVE_'):].lower(), 'data.json')
    return json.load(open(path))


class Battle:
    def __init__(self, d, sym, weather):
        self.d, self.sym, self.weather = d, sym, weather
        self.chart, self.type_names, self.move_names = type_chart(), names('pokemon_types'), names('moves')
        self.data = {}

    def u32(self, addr):
        return struct.unpack('<I', bytes(self.d.emu.memory.unsigned[addr:addr + 4]))[0]

    def mons(self):
        return self.u32(self.sym['gSovereignTestBattleMons'])

    def fields(self):
        base, mem = self.sym['gSovereignTestBattleMons'], self.d.emu.memory.unsigned
        return dict(zip(BATTLE_MONS, struct.unpack('<12H', bytes(mem[base + 4:base + 28]))))

    def hp(self, i):
        """Battler i's current and max HP."""
        f, mem = self.fields(), self.d.emu.memory.unsigned
        mon = self.mons() + f['size'] * i
        cur = struct.unpack('<H', bytes(mem[mon + f['curHP']:mon + f['curHP'] + 2]))[0]
        top = struct.unpack('<H', bytes(mem[mon + f['maxHP']:mon + f['maxHP'] + 2]))[0]
        return cur, top

    def species(self, i):
        mon, mem = self.mons() + self.fields()['size'] * i, self.d.emu.memory.unsigned
        return struct.unpack('<H', bytes(mem[mon:mon + 2]))[0]  # BattleMon's first field

    def is_double(self):
        return all(self.hp(i)[1] for i in (2, 3))

    def chooser(self):
        """The player's battler whose move is being chosen (0 or 2), from the last "What will ... do?" the battle
        printed (gSovereignTestMessageLog), matched to the species of the two out."""
        from battle_mechanics import LOG_CHARS, charmap, decode_log
        if not hasattr(self, 'chars'):
            self.chars, self.species_names = charmap(), names('species')
        log, mem = self.sym['gSovereignTestMessageLog'], self.d.emu.memory.unsigned
        length = mem[log] | mem[log + 1] << 8
        raw = bytes(mem[log + 2:log + 2 + 2 * min(length, LOG_CHARS)])
        lines = decode_log([raw[i] | raw[i + 1] << 8 for i in range(0, len(raw), 2)], self.chars)
        asking = next((m for m in reversed(lines) if m.startswith('What will ')), '')
        for b in (2, 0):
            name = self.species_names[self.species(b)][len('SPECIES_'):].replace('_', ' ')
            if self.hp(b)[0] and name in asking.upper():
                return b
        return 0

    def pp(self, b):
        """Battler b's PP left in each move slot."""
        f, mem = self.fields(), self.d.emu.memory.unsigned
        mon = self.mons() + f['size'] * b
        return [mem[mon + f['ppCur'] + i] for i in range(4)]

    def said(self):
        """How many lines the battle has printed besides its "What will ... do?" questions."""
        from battle_mechanics import LOG_CHARS, charmap, decode_log
        if not hasattr(self, 'chars'):
            self.chars, self.species_names = charmap(), names('species')
        log, mem = self.sym['gSovereignTestMessageLog'], self.d.emu.memory.unsigned
        length = mem[log] | mem[log + 1] << 8
        raw = bytes(mem[log + 2:log + 2 + 2 * min(length, LOG_CHARS)])
        lines = decode_log([raw[i] | raw[i + 1] << 8 for i in range(0, len(raw), 2)], self.chars)
        return sum(1 for m in lines if not m.startswith('What will '))

    def best_double(self, b):
        """For the player's battler b in a double battle: (move slot, foe to aim at or None, the moves, the scores)."""
        moves, user = self.battler(b)
        foes = [f for f in (1, 3) if self.hp(f)[0]]
        best = []
        for name in moves:
            m = self.move(name)
            per = {}
            for f in foes:
                _, types = self.battler(f)
                if m.get('class') == 'CLASS_STATUS' or not m.get('power'):
                    per[f] = 0
                    continue
                v = m['power'] * min(m.get('accuracy') or 100, 100) / 100
                v *= 1.5 if m['type'] in user else 1
                v *= 1.5 if m['type'] == self.weather else 1
                for t in types:
                    v *= self.chart.get((m['type'], t), 1.0)
                per[f] = v
            if m.get('range') in SPREAD:
                best.append((0.75 * sum(per.values()), None))  # a spread move does 3/4 to each
            else:
                f = max(per, key=per.get) if per else None
                best.append((per.get(f, 0), f))
        pp = self.pp(b)
        tried = getattr(self, 'tried', {}).get(b, set())  # slots chosen again and again this turn: not taken
        usable = [i for i in range(4) if moves[i] != 'MOVE_NONE' and pp[i] and i not in tried] or \
            [i for i in range(4) if moves[i] != 'MOVE_NONE' and pp[i]] or [0]
        slot = max(usable, key=lambda i: best[i][0])
        return slot, best[slot][1], moves, [s for s, _ in best]

    def battler(self, i):
        """Battler i's (0 the player's, 1 the foe's in a single battle) moves and types, from the battle's Pokémon."""
        base, mem = self.sym['gSovereignTestBattleMons'], self.d.emu.memory.unsigned
        fields = dict(zip(BATTLE_MONS, struct.unpack('<12H', bytes(mem[base + 4:base + 28]))))
        mon = self.mons() + fields['size'] * i
        moves = struct.unpack('<4H', bytes(mem[mon + fields['moves']:mon + fields['moves'] + 8]))
        types = {mem[mon + fields['types']], mem[mon + fields['types'] + 1]}
        return ([self.move_names[m] if m < len(self.move_names) else 'MOVE_NONE' for m in moves],
                [self.type_names[t] for t in types if t < len(self.type_names)])

    def move(self, name):
        if name not in self.data:
            self.data[name] = move_data(name) if name != 'MOVE_NONE' else {}
        return self.data[name]

    def best_move(self):
        """The slot of the move of the player's Pokémon out that does the most to the foe out: its power and
        accuracy, the user's type bonus, the weather's and the type chart."""
        moves, user = self.battler(0)
        _, foe = self.battler(1)

        def score(name):
            m = self.move(name)
            if m.get('class') == 'CLASS_STATUS' or not m.get('power'):
                return 0
            s = m['power'] * min(m.get('accuracy') or 100, 100) / 100
            s *= 1.5 if m['type'] in user else 1
            s *= 1.5 if m['type'] == self.weather else 1
            for t in foe:
                s *= self.chart.get((m['type'], t), 1.0)
            return s
        scores = [score(name) for name in moves]
        return max(range(4), key=lambda i: scores[i]), moves, foe, scores

    def screen(self):
        """'command', 'moves', 'party' or None, from a few of the bottom screen's pixels."""
        im = self.d.screenshot().convert('RGB')
        px = lambda x, y: im.getpixel((x, 192 + y))  # noqa: E731
        red = lambda c: c[0] > 170 and c[1] < 110 and c[2] < 110  # noqa: E731
        blue = lambda c: c[2] > 150 and c[0] < 110  # noqa: E731
        green = lambda c: c[1] > 140 and c[0] < 130 and c[2] < 140  # noqa: E731
        orange = lambda c: c[0] > 170 and 100 < c[1] < 210 and c[2] < 90  # noqa: E731
        purple = lambda c: c[2] > 140 and c[2] > c[0] + 20 and c[1] < 130 and c[0] > 90  # noqa: E731
        if red(px(128, 60)) and orange(px(40, 180)) and green(px(216, 180)):
            return 'command'
        foe_box = lambda c: c[0] > 180 and 60 < c[1] < 140 and c[2] < 90  # noqa: E731  a target screen's orange box
        if blue(px(128, 174)) and (foe_box(px(64, 30)) or foe_box(px(190, 30))):
            return 'target'
        if blue(px(128, 174)) and blue(px(60, 174)) and blue(px(200, 174)) and not red(px(128, 60)):
            return 'moves'
        if purple(px(2, 100)) and purple(px(128, 160)):
            return 'party'
        return None

    def send_next(self):
        """On the party screen after a faint: the first Pokémon whose panel is a healthy one's blue (a fainted one's
        is orange), then its SHIFT; in a double battle, past the first two panels (the two out)."""
        im = self.d.screenshot().convert('RGB')
        for x, y in PARTY_SLOTS[2 if self.mons() and self.is_double() else 0:]:
            c = im.getpixel((x, 192 + y))
            if c[2] > c[0] + 20:
                self.d.touch(x, y, frames=4, after=40)
                self.d.touch(*PARTY_SHIFT, frames=4, after=40)
                return True
        return False

    def play(self, limit=FRAME_LIMIT, log=print):
        """Page the scene's text with A until the battle starts, then play it to its end (its Pokémon freed)."""
        d, sym = self.d, self.sym
        frames, stalled, started, turns = 0, 0, False, 0
        vblank = self.u32(sym['gSystem'] + VBLANK_COUNTER)
        while frames < limit:
            d.run(STEP)
            frames += STEP
            now = self.u32(sym['gSystem'] + VBLANK_COUNTER)
            stalled = stalled + STEP if now == vblank else 0
            vblank = now
            if stalled >= HANG_FRAMES:
                return 'HANG', frames, turns
            if not self.mons():
                if started:
                    log('the battle is over')
                    return 'ok', frames, turns
                if frames % (3 * STEP) == 0:
                    d.press('A', frames=4, after=0)  # the scene's lines
                continue
            if not started:
                log('the battle starts')
            started = True
            screen = self.screen()
            if screen == 'command':
                d.touch(*FIGHT, frames=4, after=30)
                frames += 34
                screen = self.screen()
            if screen == 'moves' and self.is_double():
                b = self.chooser()
                self.picks = getattr(self, 'picks', {})
                self.tried = getattr(self, 'tried', {})
                self.last_slot = getattr(self, 'last_slot', {})
                said = self.said()
                if said != getattr(self, 'said_before', None):  # the battle printed something since the last choice
                    turns += 1  # (moves used, not just "What will ... do?"): a new turn
                    self.tried = {}
                    self.said_before = said
                key = (turns, b)
                self.picks[key] = self.picks.get(key, 0) + 1
                if self.picks[key] > 2:  # the same choice made over and over: that move isn't being taken (no PP,
                    # Disabled, Taunted, Choice-locked): the next best
                    self.tried.setdefault(b, set()).add(self.last_slot.get(b, -1))
                slot, target, moves, scores = self.best_double(b)
                self.last_slot[b] = slot
                name = self.species_names[self.species(b)][len('SPECIES_'):].title()
                aim = self.species_names[self.species(target)][len('SPECIES_'):].title() if target else 'both foes'
                log(f'turn {turns}: {name}: {moves[slot]} at {aim} '
                    f'({", ".join(f"{m[5:].title()} {s:.0f}" for m, s in zip(moves, scores))})')
                d.touch(*MOVE_SPOTS[slot], frames=4, after=30)
                frames += 34
                if self.screen() == 'target':  # a move with one target: the foe chosen (or the other, if it's gone)
                    aim_at = target if target is not None else next((f for f in (1, 3) if self.hp(f)[0]), 1)
                    d.touch(*TARGET_SPOTS[aim_at], frames=4, after=30)
                    frames += 34
                continue
            if screen == 'target':  # left over: the first foe still standing
                d.touch(*TARGET_SPOTS[next((f for f in (1, 3) if self.hp(f)[0]), 1)], frames=4, after=30)
                frames += 34
                continue
            if screen == 'moves':
                slot, moves, foe, scores = self.best_move()
                turns += 1
                log(f'turn {turns}: {moves[slot]} into {"/".join(t[5:].title() for t in foe) or "?"} '
                    f'({", ".join(f"{m[5:].title()} {s:.0f}" for m, s in zip(moves, scores))})')
                d.touch(*MOVE_SPOTS[slot], frames=4, after=20)
                frames += 24
                continue
            if screen == 'party':
                log('the party screen: the next Pokémon')
                self.send_next()
                frames += 88
                continue
            d.press('B', frames=4, after=0)
        return 'STUCK', frames, turns

    def run_away(self, limit=3000):
        """In a wild battle: RUN from the command menu, then B through the text, until the battle is over."""
        frames, started = 0, False
        while frames < limit:
            self.d.run(STEP)
            frames += STEP
            if not self.mons():
                if started:
                    return True
                continue
            started = True
            if self.screen() == 'command':
                self.d.touch(*RUN, frames=4, after=30)
            else:
                self.d.press('B', frames=4, after=0)
        return False


def team_var(mem, sym, setvar):
    """--var VAR_NAME=VALUE: written to the test build's first var slot, which the next test warp applies."""
    if setvar:
        name, value = setvar.split('=')
        from talk_to_objects import var_ids
        mem.write_short(sym['gSovereignTestVar'], var_ids()[name])
        mem.write_short(sym['gSovereignTestVar'] + 2, int(value))


def party_from_trainer(d, sym, mem, trainer, setvar):
    """The party made the trainer's team (gCompleteTestPartyFromTrainer) by a test warp onto the player's tile, with
    the MEGA toggle on."""
    mem.write_byte(sym['gSovereignTestLead'] + LEAD['mega'], 1)
    mem.write_byte(sym['gSovereignTestNoExp'], 1)
    mem.write_byte(sym['gSovereignTestGodMode'], 0)
    mem.write_short(sym['gCompleteTestPartyFromTrainer'], trainer)
    team_var(mem, sym, setvar)
    x, z = d.pos()
    here = struct.unpack('<I', bytes(mem.unsigned[sym['gSovereignTestIdleMapHeaderID']:
                                                  sym['gSovereignTestIdleMapHeaderID'] + 4]))[0]
    result, _ = warp(d, sym, here, x, z, FACE_UP)
    if result != 'ok':
        sys.exit(f'the warp that makes the party: {result}')
    d.run(60)


def make_team(d, sym, mem, battle, species, item, moves, level, nature, team, setvar):
    """The lead, made as a test wild battle starts (the player runs), then the team added three a warp."""
    species_ids, item_ids, move_ids = names('species'), names('items'), names('moves')
    # The lead, made as a test wild battle starts; the player runs
    lead = sym['gSovereignTestLead']
    mem.write_short(lead + LEAD['species'], species_ids.index(species))
    mem.write_byte(lead + LEAD['form'], 0)
    mem.write_byte(lead + LEAD['level'], level)
    mem.write_short(lead + LEAD['item'], item_ids.index(item))
    for i, move in enumerate(moves.split(',')[:4]):
        mem.write_short(lead + LEAD['moves'] + 2 * i, move_ids.index(move))
    mem.write_byte(lead + LEAD['mega'], 1)
    mem.write_long(lead + LEAD['personality'], NATURES.index(nature) + 200)  # its low byte 200 or more: male
    mem.write_byte(sym['gSovereignTestNoExp'], 1)
    mem.write_byte(sym['gSovereignTestGodMode'], 0)
    d.press('SELECT')
    if not battle.run_away():
        sys.exit('the wild battle that makes the lead never ended')
    d.run(120)

    # The team: the lead kept, the others added three a warp, onto the player's own tile
    x, z = d.pos()
    here = struct.unpack('<I', bytes(mem.unsigned[sym['gSovereignTestIdleMapHeaderID']:
                                                  sym['gSovereignTestIdleMapHeaderID'] + 4]))[0]
    team_var(mem, sym, setvar)
    for start in range(0, len(team), PARTY_ADDS):
        adds = team[start:start + PARTY_ADDS]
        mem.write_byte(sym['gSovereignTestPartyKeep'], 1 if start == 0 else 0)
        for i in range(PARTY_ADDS):
            slot = sym['gSovereignTestPartyAdd'] + 4 * i
            mem.write_short(slot, species_ids.index(adds[i]) if i < len(adds) else 0)
            mem.write_byte(slot + 2, 0)
            mem.write_byte(slot + 3, 100)
        result, _ = warp(d, sym, here, x, z, FACE_UP)
        if result != 'ok':
            sys.exit(f'the warp that adds {adds}: {result}')
    d.run(60)


def main():
    from drive import Driver
    from test_hgss_opening import Recorder

    args = sys.argv[1:]
    option = lambda name, default: args[args.index(name) + 1] if name in args else default  # noqa: E731
    rom, state, out = args[:3]
    species, item, moves = args[3:6] if len(args) > 5 and not args[3].startswith('--') else (None, None, None)
    level = int(option('--level', 100))
    team = option('--team', ','.join(DEFAULT_TEAM)).split(',')
    trainer = option('--trainer', None)
    room = option('--room', None)
    room = (room.split(':')[0], int(room.split(':')[1]), int(room.split(':')[2])) if room else DEFAULT_ROOM
    god = '--god' in args
    nature = option('--nature', 'MODEST')  # the lead's: Modest for a special attacker such as Mega Charizard Y
    delay = int(option('--delay', 0))  # frames to wait before the battle: the battle's luck follows the frame it starts on
    party_from = option('--party-from', None)
    setvar = option('--var', None)
    sym = symbols(tuple(SYMBOLS) + ('gSovereignTestBattleTrainer', 'gSovereignTestLead', 'gSovereignTestNoExp',
                                    'gSovereignTestBattleMons', 'gSovereignTestWild', 'gSovereignTestMessageLog')
                  + (('gCompleteTestPartyFromTrainer',) if party_from else ()))
    index = {name: i for i, name in trainer_ids()}
    species_ids, item_ids, move_ids = names('species'), names('items'), names('moves')
    headers = header_names()

    d = Driver(rom, state)
    mem = d.emu.memory
    d.run(30)
    weather = {'ITEM_CHARIZARDITE_Y': SUN, 'ITEM_KYOGRE_ORB': RAIN}.get(item)  # the lead's Drought, Drizzle
    if party_from:
        weather = SUN if 'CHARIZARDITE_Y' in open(os.path.join(DECOMP, 'res', 'trainers', 'data',
                                                                 party_from[len('TRAINER_'):].lower() + '.json')).read().split('"party"')[1][:400] else None
    battle = Battle(d, sym, weather)
    if party_from:
        party_from_trainer(d, sym, mem, index[party_from], setvar)
    else:
        make_team(d, sym, mem, battle, species, item, moves, level, nature, team, setvar)

    d.run(delay)
    mem.write_byte(sym['gSovereignTestGodMode'], 1 if god else 0)  # the test build's one-sided battle
    mem.write_short(sym['gSovereignTestMessageLog'], 0)  # the message log from the battle's first line
    raw = out + '.ts'
    video = Recorder(d, raw, 3)
    if trainer:
        mem.write_short(sym['gSovereignTestBattleTrainer'], index[trainer])
        d.press('SELECT+R')
    else:
        from talk_to_objects import start_warp
        start_warp(d, sym, headers.index(room[0]), room[1], room[2], FACE_UP)  # the room's scene starts the battle
    def log(what):  # printed, and marked in the recording (OUT.mp4.ts.events) for cutting it
        print(what, flush=True)
        video.mark(what)
    result, frames, turns = battle.play(log=log)
    try:  # the battle's messages, as it printed them (gSovereignTestMessageLog), beside the video
        from battle_mechanics import LOG_CHARS, charmap, decode_log
        base, um = sym['gSovereignTestMessageLog'], mem.unsigned
        length = um[base] | um[base + 1] << 8
        raw = bytes(um[base + 2:base + 2 + 2 * min(length, LOG_CHARS)])
        with open(out + '.messages.txt', 'w', encoding='utf-8') as f:
            f.write('\n'.join(decode_log([raw[i] | raw[i + 1] << 8 for i in range(0, len(raw), 2)], charmap())) + '\n')
    except Exception as e:  # noqa: BLE001  the video matters more than its text
        print(f'(no message log: {e})', flush=True)
    d.run(360)
    video.close()
    print(f'{trainer or room[0]}: {result} after {frames} frames ({frames / 60:.0f} s, {turns} turns)', flush=True)
    subprocess.run(['ffmpeg', '-loglevel', 'error', '-y', '-i', raw, '-vf', 'scale=512:768:flags=neighbor',
                    '-c:v', 'libx264', '-crf', '20', '-pix_fmt', 'yuv420p', '-movflags', '+faststart', out],
                   check=True)
    print(f'{out} written', flush=True)


if __name__ == '__main__':
    main()
