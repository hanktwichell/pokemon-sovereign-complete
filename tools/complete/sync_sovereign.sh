#!/usr/bin/env bash
# Bring Sovereign Platinum's engine changes into Sovereign Complete.
#
#   tools/complete/sync_sovereign.sh [COMMIT]     (COMMIT defaults to Sovereign's main)
#
# Sovereign Complete carries a copy of Sovereign Platinum's engine (decomp/, tools/, data/, assets/, CITATIONS.md),
# pinned to the commit in SOVEREIGN_COMMIT. This takes Sovereign's changes between that commit and COMMIT and applies
# them as a three-way patch: Sovereign Complete's own edits to the same files are kept, and any clash is left marked in
# the file for fixing by hand. Then SOVEREIGN_COMMIT is updated. Nothing is committed: build, test, then commit.
#
# Sovereign is fetched into .cache/sovereign (ignored by git), two commits at depth 1.
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root"

repo=https://github.com/hanktwichell/pokemon-imperial-platinum
cache=.cache/sovereign
paths=(decomp tools data assets CITATIONS.md)
old="$(cat SOVEREIGN_COMMIT)"
target="${1:-main}"

if [ -n "$(git status --porcelain -- "${paths[@]}" SOVEREIGN_COMMIT)" ]; then
    echo "Commit or stash the changes to ${paths[*]} first, so the sync can be told apart from them." >&2
    exit 1
fi

if [ ! -d "$cache/.git" ]; then
    git init -q "$cache"
    git -C "$cache" remote add origin "$repo"
fi
git -C "$cache" fetch -q --depth=1 origin "$old"
git -C "$cache" fetch -q --depth=1 origin "$target"
new="$(git -C "$cache" rev-parse FETCH_HEAD)"

if [ "$new" = "$old" ]; then
    echo "Already at Sovereign $old."
    exit 0
fi

patch="$(mktemp)"
trap 'rm -f "$patch"' EXIT
git -C "$cache" diff --binary --full-index "$old" "$new" -- "${paths[@]}" > "$patch"

echo "$new" > SOVEREIGN_COMMIT
if [ ! -s "$patch" ]; then
    echo "Sovereign ${old:0:8}..${new:0:8} changes nothing in ${paths[*]}; SOVEREIGN_COMMIT updated."
    exit 0
fi

changed="$(git -C "$cache" diff --name-only "$old" "$new" -- "${paths[@]}" | wc -l)"
# git apply reports every file; keep only the clashes and errors.
set +e
git apply --3way --whitespace=nowarn "$patch" 2>&1 |
    grep -v -e '^Falling back to direct application' -e "^Applied patch to '.*' cleanly" -e '^Checking patch '
result="${PIPESTATUS[0]}"
set -e
if [ "$result" -eq 0 ]; then
    echo "Applied Sovereign ${old:0:8}..${new:0:8}: $changed files. Build, test, then commit."
else
    echo "Applied Sovereign ${old:0:8}..${new:0:8} ($changed files) with clashes. Fix the files git status lists as" >&2
    echo "unmerged (look for <<<<<<<), then build, test and commit." >&2
    exit 2
fi
