#!/usr/bin/env bash
# Build HeartGold (US) from the pret/pokeheartgold source, then Sacred Gold from Drayano's patch.
#
#   tools/complete/build_heartgold.sh
#
# Sovereign Complete takes Johto and Kanto from the HeartGold source, and Sacred Gold's trainers, wild Pokémon, items and
# events from Sacred Gold itself, the way Sovereign Platinum took Renegade Platinum's. Drayano has given his okay to
# build on his games. Both games are built here into .cache/ (ignored by git) and are never committed.
#
# The source is pinned to HEARTGOLD_COMMIT; its build must be the retail HeartGold (US) ROM (checked by SHA-1).
# Drayano's patches are in the XDelta 1 format (not xdelta3's VCDIFF). His readme's CRC32 (FFD28F00) and the patch's
# source MD5 describe a different dump of the same game, the same size; its differing bytes are ones the patch never
# reads. So the check that counts is the output's: the patch records Sacred Gold's MD5, and the result must match it.
#
# Needs the decomp build dependencies (decomp/INSTALL.md) and XDelta 1 (apt package xdelta, version 1.1.3).
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root"

src=.cache/pokeheartgold
commit="$(cat HEARTGOLD_COMMIT)"
patch="Sacred Gold & Storm Silver V1.05 5/Patches/Complete Version - EVERYTHING/SacredGoldComplete.patch"
retail_sha1=4fcded0e2713dc03929845de631d0932ea2b5a37

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
if [ "$sha1" != "$retail_sha1" ]; then
    echo "HeartGold built, but it isn't the retail ROM: SHA-1 $sha1" >&2
    exit 1
fi
echo "HeartGold (US): .cache/heartgold.nds, SHA-1 $sha1 (retail)"

want_md5="$(xdelta info "$patch" 2>&1 | sed -n 's/^xdelta: output md5: *//p')"
xdelta patch "$patch" .cache/heartgold.nds .cache/sacredgold.nds
got_md5="$(md5sum .cache/sacredgold.nds | cut -d' ' -f1)"
if [ -z "$want_md5" ] || [ "$got_md5" != "$want_md5" ]; then
    echo "Sacred Gold doesn't match the MD5 the patch records: got $got_md5, want $want_md5" >&2
    exit 1
fi
echo "Sacred Gold (Complete, v1.05): .cache/sacredgold.nds, MD5 $got_md5 (as the patch records)," \
    "SHA-1 $(sha1sum .cache/sacredgold.nds | cut -d' ' -f1)"
