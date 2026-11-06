#!/usr/bin/env python3
"""People who stand where Sinnoh's HMs used to hold the player back (the owner's note, Nov 6, 2026: "we are going to
have to put npcs in places where hms would normally block progression").

The player reaches Sinnoh with every HM from Johto and Kanto, whose badges let them use it there, and Sinnoh's HM givers
give Mega Stones now, so the trees, rocks, water and cliffs that kept Platinum's story in order no longer do. Each
place below, found by a survey of every Sinnoh map's tiles against the story's order (docs/Features.md, "People where
Sinnoh's HMs held the player back"), gets a person (or two or three) in the way, who goes once the player reaches the
point where Platinum would have let them through: the badge that allowed the HM there, or the story's own flag.

This writes:
- each person into the map's events (Sovereign's res/field/events/events_*.json, which can't hold a comment: this
  script is their record; rerun it if a sync clashes on them), at the end of the map's object events so no local ID
  moves, with a hide flag of their group;
- decomp/include/data/complete_blockers.h: each group's hide flag and what lifts it, which src/complete_blockers.c sets
  or clears as each map loads (before its objects are made, and before its own transition script).
Each group's words are its common script (CommonScript_CompleteBlocker*, scripts_common.s) and its text
(CommonStrings_Text_CompleteBlocker*, common_strings.json).

Usage: python3 tools/complete/sinnoh_blockers.py
"""
import json
import os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
OUT = os.path.join(DECOMP, 'include', 'data', 'complete_blockers.h')
DIRS = {'north': (0, 'MOVEMENT_TYPE_LOOK_NORTH'), 'south': (1, 'MOVEMENT_TYPE_LOOK_SOUTH'),
        'west': (2, 'MOVEMENT_TYPE_LOOK_WEST'), 'east': (3, 'MOVEMENT_TYPE_LOOK_EAST')}

# (group, its hide flag, what lifts it: ('flag', FLAG_*), ('badge', BADGE_ID_*) or ('var', VAR_*, at least), its common
# script, [(events file, local ID, sprite, x, z, facing)])
GROUPS = [
    # Mt. Coronet 1F South: the stairs up to the climb to Spear Pillar (Surf and Rock Climb), before the Galactic HQ
    ('SPEAR_PILLAR', 'FLAG_COMPLETE_HIDE_BLOCKER_SPEAR_PILLAR', ('flag', 'FLAG_FREED_GALACTIC_HQ_POKEMON'), 0x824,
     [('mt_coronet_1f_south', 'LOCALID_COMPLETE_BLOCKER_HIKER', 'OBJ_EVENT_GFX_HIKER', 25, 4, 'south')]),
    # Acuity Lakefront: Lake Acuity's door (Rock Climb), before Candice's Icicle Badge; Jupiter's scene there would open
    # the Galactic HQ early
    ('LAKE_ACUITY', 'FLAG_COMPLETE_HIDE_BLOCKER_LAKE_ACUITY', ('badge', 'BADGE_ID_ICICLE'), 0x825,
     [('acuity_lakefront', 'LOCALID_COMPLETE_BLOCKER_SKIER_M', 'OBJ_EVENT_GFX_SKIER_M', 308, 230, 'south'),
      ('acuity_lakefront', 'LOCALID_COMPLETE_BLOCKER_SKIER_F', 'OBJ_EVENT_GFX_SKIER_F', 309, 230, 'south')]),
    # Route 205 South: Eterna Forest's door, which Surf on the river reaches past the bridge's grunts, before the Valley
    # Windworks is freed
    ('ETERNA_FOREST', 'FLAG_COMPLETE_HIDE_BLOCKER_ETERNA_FOREST', ('var', 'VAR_VALLEY_WINDWORKS_STATE', 2), 0x826,
     [('route_205_south', 'LOCALID_COMPLETE_BLOCKER_CAMPER', 'OBJ_EVENT_GFX_CAMPER', 206, 582, 'south'),
      ('route_205_south', 'LOCALID_COMPLETE_BLOCKER_PICNICKER', 'OBJ_EVENT_GFX_PICNICKER', 207, 582, 'south')]),
    # Ravaged Path: the rocks between Route 204's halves (Rock Smash), before Roark's Coal Badge
    ('RAVAGED_PATH', 'FLAG_COMPLETE_HIDE_BLOCKER_RAVAGED_PATH', ('badge', 'BADGE_ID_COAL'), 0x827,
     [('ravaged_path', 'LOCALID_COMPLETE_BLOCKER_WORKER_1', 'OBJ_EVENT_GFX_WORKER', 21, 42, 'west'),
      ('ravaged_path', 'LOCALID_COMPLETE_BLOCKER_WORKER_2', 'OBJ_EVENT_GFX_WORKER', 21, 43, 'west'),
      ('ravaged_path', 'LOCALID_COMPLETE_BLOCKER_WORKER_3', 'OBJ_EVENT_GFX_WORKER', 21, 44, 'west')]),
    # Mt. Coronet 1F North Room 1: the boulder on the way through to Route 211 East and Celestic Town (Strength), before
    # the Psyduck on Route 210 move
    ('CORONET_NORTH', 'FLAG_COMPLETE_HIDE_BLOCKER_CORONET_NORTH', ('flag', 'FLAG_USED_SECRETPOTION'), 0x828,
     [('mt_coronet_1f_north_room_1', 'LOCALID_COMPLETE_BLOCKER_HIKER', 'OBJ_EVENT_GFX_HIKER', 17, 39, 'west')]),
]
# Sovereign's own people whose hide flags this keeps too: Route 221's workers at the Pal Park lobby's door, which Surf
# reaches from Sandgem Town, stay until the Fen Badge (Platinum's Surf)
OWN = [('FLAG_HIDE_ROUTE_221_WORKER_WEST', ('badge', 'BADGE_ID_FEN')),
       ('FLAG_HIDE_ROUTE_221_WORKER_EAST', ('badge', 'BADGE_ID_FEN'))]
SCRIPT_ID_OFFSET_COMMON_SCRIPTS = 2000


def place(events, local_id, sprite, x, z, facing, flag, script):
    path = os.path.join(DECOMP, 'res', 'field', 'events', f'events_{events}.json')
    raw = open(path, encoding='utf-8').read()
    indent = len(raw.split('\n')[1]) - len(raw.split('\n')[1].lstrip())
    data = json.loads(raw)
    objects = [o for o in data['object_events'] if o['id'] != local_id]
    initial, movement = DIRS[facing]
    objects.append({'id': local_id, 'graphics_id': sprite, 'movement_type': movement, 'trainer_type': 'TRAINER_TYPE_NONE',
                    'hidden_flag': flag, 'script': script, 'initial_dir': initial, 'data': [], 'movement_range_x': 0,
                    'movement_range_z': 0, 'x': x, 'z': z, 'y': 0})
    data['object_events'] = objects
    with open(path, 'w', encoding='utf-8') as out:
        json.dump(data, out, indent=indent, ensure_ascii=False)
        out.write('\n')


def condition(lift):
    kind = {'flag': 'COMPLETE_BLOCKER_UNTIL_FLAG', 'badge': 'COMPLETE_BLOCKER_UNTIL_BADGE',
            'var': 'COMPLETE_BLOCKER_UNTIL_VAR'}[lift[0]]
    return f'{kind}, {lift[1]}, {lift[2] if len(lift) > 2 else 0}'


def main():
    rows = []
    for group, flag, lift, script, people in GROUPS:
        for events, local_id, sprite, x, z, facing in people:
            place(events, local_id, sprite, x, z, facing, flag, script - 0x7D0 + SCRIPT_ID_OFFSET_COMMON_SCRIPTS)
        rows.append(f'    {{ {flag}, {condition(lift)} }}, // {group.lower().replace("_", " ")}')
    rows += [f'    {{ {flag}, {condition(lift)} }}, // Sovereign\'s' for flag, lift in OWN]
    with open(OUT, 'w', encoding='utf-8') as out:
        out.write(f"""// Generated by tools/complete/sinnoh_blockers.py. Do not edit.
#ifndef POKEPLATINUM_DATA_COMPLETE_BLOCKERS_H
#define POKEPLATINUM_DATA_COMPLETE_BLOCKERS_H

#include "generated/badges.h"
#include "generated/vars_flags.h"

// Each group of people standing where Sinnoh's HMs held the player back: their hide flag, set once what lifts it is
// reached (a flag set, a badge won, a var at least a value), clear before
static const CompleteBlocker sCompleteBlockers[] = {{
{chr(10).join(rows)}
}};

#endif // POKEPLATINUM_DATA_COMPLETE_BLOCKERS_H
""")
    print(f'{sum(len(g[4]) for g in GROUPS)} people in {len(GROUPS)} groups, and {len(OWN)} of Sovereign\'s')


if __name__ == '__main__':
    main()
