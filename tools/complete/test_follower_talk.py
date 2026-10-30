#!/usr/bin/env python3
"""Check talking to the following Pokémon (src/overlay006/complete_follower_talk.c) in the test build, from the bedroom
state. The player warps to New Bark Town (the lead, the test party's Garchomp, follows), steps away from the follower,
turns to face it and talks to it (A, then A through its messages and yes to any question):

1. **Chosen:** the talk HeartGold's tables choose for the moment. Passes when a talk ran with an interaction and showed
   at least one message, and the field is free again with the follower where it was and its sprite back in place.
2. **Question:** interaction 6 (it nudges the player: a motion, its cry, "Nudge it back?"), whose yes leads to 766 (a
   hop, then a message). Passes when both ran: a motion, the question, and 766's message last.
3. **Accessory:** interaction 963, in which it hands over an accessory (a White Fluff). Passes when the Fashion Case has
   one more White Fluff.
4. **Shiny Leaf:** interaction 1018: five motions, then it finds the first Shiny Leaf (and +5 friendship, +120 mood).
   Passes when the lead wears that leaf and its friendship and mood went up.

The test build's gCompleteTestFollowerTalk (include/complete_test.h) asks for an interaction (force) and reports what
the talk did. Results: a line per part, and a screenshot of each talk's first message in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_follower_talk.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, start_warp  # noqa: E402
from test_map_warp import walkable_tile  # noqa: E402

MAP = 'MAP_HEADER_HGSS_NEW_BARK'
DOWN = 0  # the test warp's facing (enum FaceDirection + 1, or 0 for down)
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gCompleteTestFollowerTalk', 'gCompleteTestFollowerTile'})
# struct CompleteTestFollowerTalk
TALK = dict(force=0, talks=2, interaction=4, messages=6, lastMessage=8, motions=10, questions=11, offsetBack=12,
            mood=13, friendship=14, shinyLeaves=15, accessories=16)
NUDGE, NUDGE_BACK, NUDGE_BACK_MESSAGE = 6, 766, 624  # interaction 766's message: msg_0265's 623, + 1
ACCESSORY_FIND = 963
LEAF_FIND, FIRST_LEAF = 1018, 1
DELTA = {'UP': (0, -1), 'DOWN': (0, 1), 'LEFT': (-1, 0), 'RIGHT': (1, 0)}
OPPOSITE = {'UP': 'DOWN', 'DOWN': 'UP', 'LEFT': 'RIGHT', 'RIGHT': 'LEFT'}


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory
    talk_addr = sym['gCompleteTestFollowerTalk']

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def field(name):
        at = talk_addr + TALK[name]
        if name in ('motions', 'questions', 'offsetBack', 'friendship', 'shinyLeaves'):
            return mem.unsigned[at]
        if name == 'mood':
            return struct.unpack('<b', bytes(mem.unsigned[at:at + 1]))[0]
        return struct.unpack('<H', bytes(mem.unsigned[at:at + 2]))[0]

    def follower():
        at = sym['gCompleteTestFollowerTile']
        return struct.unpack('<HH', bytes(mem.unsigned[at:at + 4]))

    def settle(limit=3000):
        """Run until the field has been idle a while (a busy map runs the field every other frame)."""
        frames, idle = 0, 0
        while frames < limit:
            before = u32(sym['gSovereignTestIdleFrames'])
            d.run(20)
            frames += 20
            idle = idle + 1 if u32(sym['gSovereignTestIdleFrames']) - before >= 9 else 0
            if idle >= 6:
                return True
        return False

    def face_follower():
        """From the warp: a step away from the follower, then a turn back to face it. Returns a problem or ''."""
        for key in ('DOWN', 'LEFT', 'RIGHT', 'UP'):
            before = d.pos()
            d.press(key, frames=16, after=24)
            settle()
            after = d.pos()
            if after == before:
                continue
            dx, dz = DELTA[key]
            if follower() != (after[0] - dx, after[1] - dz):
                return f'after {key} {before} -> {after} the follower is on {follower()}'
            d.press(OPPOSITE[key], frames=2, after=20)  # a tap turns the player; the follower's tile is taken
            settle()
            return '' if d.pos() == after else f'the turn moved the player to {d.pos()}'
        return 'the player could not step anywhere'

    def talk(shot):
        """Talk to the follower and play it out: A while the field is busy, until it has been idle a while."""
        talks = field('talks')
        d.press('A', frames=4, after=0)
        frames, idle, shot_taken = 0, 0, False
        while frames < 6000:
            before = u32(sym['gSovereignTestIdleFrames'])
            d.run(20)
            frames += 20
            idle_frames = u32(sym['gSovereignTestIdleFrames']) - before
            if idle_frames >= 9:
                idle += 1
                if idle >= 6:
                    break
            else:
                idle = 0
                if idle_frames == 0:
                    if not shot_taken and field('messages'):
                        d.run(60)  # the line prints
                        d.screenshot().save(os.path.join(out, shot))
                        shot_taken = True
                    d.press('A', frames=4, after=0)
        if field('talks') != talks + 1:
            return f'no talk started (talks {talks} -> {field("talks")})'
        if idle < 6:
            return 'the talk never ended'
        if not field('offsetBack'):
            return 'the follower\'s sprite was not back in place after its motions'
        return ''

    def go_and_talk(force, shot):
        d.load_state(state)
        d.run(30)
        x, z = walkable_tile(MAP)
        start_warp(d, sym, names.index(MAP), x, z, DOWN)
        if not settle():
            return 'New Bark Town never settled'
        problem = face_follower()
        if problem:
            return problem
        mem.write_short(talk_addr + TALK['force'], force)
        return talk(shot)

    results = []

    def report(part, problem):
        results.append(f'{part}: {problem or "ok"}')
        print(results[-1], flush=True)
        print(f'     interaction {field("interaction")}, {field("messages")} messages (last {field("lastMessage")}), '
              f'{field("motions")} motions, {field("questions")} questions', flush=True)

    # 1. The talk the tables choose
    problem = go_and_talk(0, 'chosen.png')
    if not problem and not field('interaction'):
        problem = 'no interaction fitted'
    elif not problem and not field('messages'):
        problem = 'no message'
    report('chosen', problem)

    # 2. A question, and yes
    problem = go_and_talk(NUDGE, 'question.png')
    if not problem:
        if field('interaction') != NUDGE or not field('motions') or field('questions') != 1:
            problem = f'not the nudge: interaction {field("interaction")}, {field("motions")} motions, ' \
                f'{field("questions")} questions'
        elif field('lastMessage') != NUDGE_BACK_MESSAGE:
            problem = f'the yes did not lead to {NUDGE_BACK}: last message {field("lastMessage")}'
    report('question', problem)

    # 3. An accessory
    problem = go_and_talk(ACCESSORY_FIND, 'accessory.png')
    if not problem and field('accessories') == 0:
        problem = 'no White Fluff in the Fashion Case'
    report('accessory', problem)
    print(f'     White Fluffs: {field("accessories")}')

    # 4. A Shiny Leaf, with friendship and mood
    problem = go_and_talk(LEAF_FIND, 'leaf.png')
    if not problem:
        if not field('shinyLeaves') & (1 << (FIRST_LEAF - 1)):
            problem = f'no leaf: {field("shinyLeaves"):#x}'
        elif field('mood') < 100:
            problem = f'mood {field("mood")}, not raised'
    report('leaf', problem)
    print(f'     leaves {field("shinyLeaves"):#x}, mood {field("mood")}, friendship {field("friendship")}')

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of 4 parts ok')
    sys.exit(0 if ok == 4 else 1)


if __name__ == '__main__':
    main()
