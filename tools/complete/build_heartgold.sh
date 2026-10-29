#!/usr/bin/env bash
# Build HeartGold (US) from the pret/pokeheartgold source, then Sacred Gold from Drayano's patch.
#
#   tools/complete/build_heartgold.sh
#
# Sovereign Complete takes Johto and Kanto from the HeartGold source, and Sacred Gold's trainers, wild Pokémon, items and
# events from Sacred Gold itself, the way Sovereign Platinum took Renegade Platinum's. Drayano has given his okay to
# build on his games. Both games are built here into .cache/ (ignored by git) and are never committed.
#
# The source is pinned to HEARTGOLD_COMMIT. Its build is the retail HeartGold (US) ROM, which is also the ROM Drayano's
# patch expects (his readme gives its CRC32, FFD28F00); this checks both, and xdelta3 checks the patch's own source
# checksum before patching.
#
# Needs the decomp build dependencies (decomp/INSTALL.md) and xdelta3.
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root"

src=.cache/pokeheartgold
commit="$(cat HEARTGOLD_COMMIT)"
patch="Sacred Gold & Storm Silver V1.05 5/Patches/Complete Version - EVERYTHING/SacredGoldComplete.patch"
retail_sha1=4fcded0e2713dc03929845de631d0932ea2b5a37
retail_crc32=ffd28f00

if [ ! -d "$src/.git" ]; then
    git init -q "$src"
    git -C "$src" remote add origin https://github.com/pret/pokeheartgold
fi
if [ "$(git -C "$src" rev-parse -q --verify HEAD || true)" != "$commit" ]; then
    git -C "$src" fetch -q --depth=1 origin "$commit"
    git -C "$src" checkout -q --detach FETCH_HEAD
fi

make -C "$src" -j"$(nproc)"
cp "$src/build/heartgold.us/pokeheartgold.us.nds" .cache/heartgold.nds

sha1="$(sha1sum .cache/heartgold.nds | cut -d' ' -f1)"
crc32="$(python3 -c 'import sys, zlib; print("%08x" % zlib.crc32(open(sys.argv[1], "rb").read()))' .cache/heartgold.nds)"
if [ "$sha1" != "$retail_sha1" ] || [ "$crc32" != "$retail_crc32" ]; then
    echo "HeartGold built, but it isn't the retail ROM: SHA-1 $sha1, CRC32 $crc32" >&2
    exit 1
fi
echo "HeartGold (US): SHA-1 $sha1, CRC32 $crc32 (retail; matches Drayano's readme)"

xdelta3 -d -f -s .cache/heartgold.nds "$patch" .cache/sacredgold.nds
echo "Sacred Gold (Complete, v1.05): .cache/sacredgold.nds, SHA-1 $(sha1sum .cache/sacredgold.nds | cut -d' ' -f1)"
