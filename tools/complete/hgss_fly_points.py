"""HeartGold's Fly points in Complete (src/spawn_locations.c), for the tests that fly between them
(test_town_map.py, test_sinjoh_fly.py)."""
import os
import re
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import DECOMP  # noqa: E402


def fly_points():
    """{town: (Fly point flag number, x, z)} from the generated spawn points (include/data/hgss_spawn_locations.h)."""
    rows = open(os.path.join(DECOMP, 'include', 'data', 'hgss_spawn_locations.h'), encoding='utf-8').read()
    out = {}
    for fly_map, x, z, unlock, point in re.findall(
            r'\{ \w+, \w+, \w+, MAP_HEADER_HGSS_(\w+), (\w+), (\w+), \w+, (\w+), (\w+) \}', rows):
        if int(unlock, 0):
            out[fly_map] = (int(point, 0), int(x, 0), int(z, 0))
    return out


def spawn_ids():
    """{town: its spawn point} (include/constants/hgss_spawns.h)"""
    text = open(os.path.join(DECOMP, 'include', 'constants', 'hgss_spawns.h'), encoding='utf-8').read()
    return {name: int(n) for name, n in re.findall(r'#define SPAWN_HGSS_(\w+) (\d+)', text)}
