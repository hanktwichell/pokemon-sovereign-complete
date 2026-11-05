#!/usr/bin/env bash
# Build Sovereign Complete's playtest ROM and write a patch for it: one .xdelta per Pokémon Platinum (US) revision, as
# Sovereign's release patches are made (tools/build/make_release_patch.sh). The playtest is the release game, with a
# new game that starts with a team to travel with and every Fly point (src/complete_playtest.c):
#   - Garchomp Lv. 80 with Champion Cynthia's set (Earthquake, Outrage, Stone Edge, Swords Dance; Yache Berry)
#   - Staraptor Lv. 50 with Fly and Empoleon Lv. 50 with Surf (Fly and Surf need no badge)
#   - the Fly point of every town in Johto, Kanto and Sinnoh
# The story plays as in the release: badges, flags and the starter are untouched.
#
#   tools/complete/make_playtest_patch.sh [--no-build] [OUT_DIR] CLEAN_ROM [CLEAN_ROM]
#
# CLEAN_ROM: an unmodified Pokémon Platinum (US) dump, Rev 1 ("4997") and/or Rev 0 ("3541"), told apart by SHA-1.
# OUT_DIR defaults to .cache/playtest. --no-build patches the existing decomp/build_playtest/pokeplatinum.us.nds.
# Requires xdelta3. Never commit the ROM or the patch.
set -euo pipefail
cd "$(dirname "$0")/../.."

usage() { echo "usage: $0 [--no-build] [OUT_DIR] CLEAN_ROM [CLEAN_ROM]" >&2; exit 2; }
build=1
if [ "${1:-}" = "--no-build" ]; then build=0; shift; fi
out=".cache/playtest"
if [ $# -ge 1 ] && [ -d "$1" -o "${1##*.}" != "nds" ]; then out="$1"; shift; fi
[ $# -ge 1 ] || usage
command -v xdelta3 >/dev/null || { echo "xdelta3 is not installed" >&2; exit 2; }

rom="decomp/build_playtest/pokeplatinum.us.nds"
if [ "$build" = 1 ]; then
    make -C decomp BUILD=build_playtest configure >/dev/null
    python3 decomp/subprojects/meson-*/meson.py configure decomp/build_playtest -Dcomplete_playtest=true
    make -C decomp BUILD=build_playtest rom
fi
[ -f "$rom" ] || { echo "$rom not found: build it first" >&2; exit 1; }
mkdir -p "$out"

for clean in "$@"; do
    [ -f "$clean" ] || { echo "$clean: not found" >&2; exit 1; }
    case "$(sha1sum "$clean" | cut -d' ' -f1)" in
        0862ec35b24de5c7e2dcb88c9eea0873110d755c) rev=4997 ;;
        ce81046eda7d232513069519cb2085349896dec7) rev=3541 ;;
        *) echo "$clean: not a clean Pokémon Platinum (US) dump (SHA-1 matches neither Rev 0 nor Rev 1)" >&2; exit 1 ;;
    esac
    patch="$out/SovereignCompletePlaytest$rev.xdelta"
    xdelta3 -e -9 -f -s "$clean" "$rom" "$patch"
    # Check the patch round-trips to exactly the built ROM.
    tmp="$(mktemp)"
    xdelta3 -d -f -s "$clean" "$patch" "$tmp"
    cmp -s "$tmp" "$rom" || { rm -f "$tmp"; echo "$patch doesn't reproduce $rom" >&2; exit 1; }
    rm -f "$tmp"
    echo "$patch ($(du -h "$patch" | cut -f1)): for $rev dumps -> SHA-1 $(sha1sum "$rom" | cut -d' ' -f1)"
done
