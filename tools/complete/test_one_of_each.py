#!/usr/bin/env python3
"""Check that the legendaries met elsewhere aren't met in Sinnoh too (the owner's call, Nov 6, 2026: one of each,
docs/Legendaries.md), with tools/complete/test_hgss_special_events.py's machinery and Sinnoh's scripts: each case sets
what would bring its legendary out, and the script must start no battle.

- Arceus (the Sinjoh Ruins' now): the Hall of Origin's step-on scene, its var set to bring it, plays nothing, as the
  hall's OnTransition resets the var.
- Regirock (Johto's): Rock Peak Ruins's statue, the ruins' state at the statue's turn, only exudes power.

Fullmoon Island's Lati rock (Latias and Latios are Kanto's) isn't here: it shows only once Cresselia is caught, which
the harness can't set up; its script goes straight to "nothing happened" in front of it. The other Sinnoh copies are
objects taken off their maps (data/complete/placed.yaml's `moved`), as the Chronicles'
legendaries that moved already are; tools/complete/list_legendaries.py lists what's left.

From the repo root, with the test build and a bedroom state from it (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_one_of_each.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [NAME ...]
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import test_hgss_special_events as events  # noqa: E402

events.EVENTS = [
    ("no Arceus in the Hall of Origin", ('coord', 'MAP_HEADER_HALL_OF_ORIGIN', 31, 35, 0),
     {'flags': {'VAR_HALL_OF_ORIGIN_STATE': 1}}, [], None),
    ("no Regirock at Rock Peak Ruins' statue", ('bg', 'MAP_HEADER_ROCK_PEAK_RUINS', 7, 1, 0),
     {'flags': {'VAR_ROCK_PEAK_RUINS_STATE': 270}}, [], None),
]

if __name__ == '__main__':
    events.main()
