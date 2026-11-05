"""Sinnoh's levels after Kanto, for the tests: Sovereign's level -> the level Complete's build gives it
(CompleteSinnoh_Level, decomp/src/complete_sinnoh.c), between the points of the generated header
(decomp/include/data/complete_sinnoh.h, from data/complete/sinnoh.yaml by gen_sinnoh.py), rounded as the C rounds.

Sovereign's tests (tools/test) import it where they compare a level the game moves up: Sinnoh's wild Pokémon, its
gifts and Sovereign's roamers.
"""
import os
import re

HEADER = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp', 'include', 'data',
                      'complete_sinnoh.h')
_points = None


def points():
    """[(Sovereign's level, the level here)] from the generated header ([] without it: levels as they are)."""
    global _points
    if _points is None:
        _points = []
        if os.path.exists(HEADER):
            text = open(HEADER, encoding='utf-8').read()
            table = text[text.index('sCompleteSinnohLevels'):]
            _points = [(int(a), int(b)) for a, b in re.findall(r'\{ (\d+), (\d+) \}', table[:table.index('};')])]
    return _points


def level(sovereign_level):
    """The level a Sinnoh map gives for Sovereign's level."""
    pts = points()
    for (a, b), (c, e) in zip(pts, pts[1:]):
        if a <= sovereign_level <= c:
            return b + ((sovereign_level - a) * (e - b) * 2 + (c - a)) // ((c - a) * 2)
    return min(sovereign_level, 100)
