#!/usr/bin/env python3
"""Bring in HeartGold's Pokéathlon performance (each species' base stars and range for Speed, Power, Skill, Stamina and
Jump) into data/complete/pokeathlon_performance.json, for every one of Complete's species.

HeartGold's data (files/poketool/personal/performance.narc, 20 bytes a member: the five base values, 4 unused bytes,
each stat's lowest and highest, 1 unused; members by sPokeathlonPerformanceArcIdxs[species] + form) covers its 493
species and the forms it has (Pichu, Unown, Deoxys, Burmy, Wormadam, Shellos, Gastrodon, Rotom, Giratina, Shaymin,
Arceus). The values are 0 to 4 (one to five stars). The archive's order, by what its data shows (Ninjask's two highest
are Speed and Jump, Shuckle's and Snorlax's Stamina, Alakazam's Skill), is Power, Speed, Jump, Stamina, Skill; pret's
HeartGold names the slots ARCPERF_POWER, _STAMINA, _JUMP, _SKILL, _SPEED, which the data doesn't bear out.

Complete's species past 493 have no HeartGold performance. Until the owner decides (docs/Roadmap.md), each gets a
provisional one from its base stats: for each stat, a least-squares score over the six base stats and their total,
fitted to HeartGold's 493 here, cut where HeartGold's own spread of stars puts the cuts (on HeartGold's species this
gets 40-52% of the stars exactly and 83-96% within one); its range one below and one above. Those entries say
"source": "base stats"; an entry whose source is "owner" is kept as it is on a rerun, so the owner's choices stay.
A form Complete has that HeartGold doesn't (regional forms, Megas) takes its species' entry.

Nothing reads the file yet: the course (stage 2) and the Aprijuice stand will, through an archive made from it.

Usage, after tools/complete/build_heartgold.sh (or with pret's HeartGold checked out in .cache/pokeheartgold):
    python3 tools/complete/import_hgss_performance.py
"""
import json
import os
import re
import struct
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
HG = os.path.join(ROOT, '.cache', 'pokeheartgold')
DECOMP = os.path.join(ROOT, 'decomp')
OUT = os.path.join(ROOT, 'data', 'complete', 'pokeathlon_performance.json')
HG_SPECIES = 493
ARCHIVE_ORDER = ['power', 'speed', 'jump', 'stamina', 'skill']  # what the archive's five slots hold
STATS = ['speed', 'power', 'skill', 'stamina', 'jump']  # the order HeartGold's screens show them in
BASE_STATS = ['hp', 'attack', 'defense', 'speed', 'special_attack', 'special_defense']


def narc_members(path):
    data = open(path, 'rb').read()
    assert data[16:20] == b'BTAF'
    size, count = struct.unpack_from('<IH', data, 20)
    fat = [struct.unpack_from('<II', data, 28 + 8 * i) for i in range(count)]
    off = 16 + size
    assert data[off:off + 4] == b'BTNF'
    off += struct.unpack_from('<I', data, off + 4)[0]
    assert data[off:off + 4] == b'GMIF'
    return [data[off + 8 + start:off + 8 + end] for start, end in fat]


def hg_index():
    src = open(os.path.join(HG, 'src', 'pokemon.c'), encoding='utf-8').read()
    table = src[src.index('sPokeathlonPerformanceArcIdxs[] = {'):]
    table = table[table.index('{') + 1:table.index('};')]
    return [int(x) for x in re.findall(r'\b(\d+)\b', table)]


def entry(member, source):
    base = dict(zip(ARCHIVE_ORDER, member[0:5]))
    lo = dict(zip(ARCHIVE_ORDER, member[9:19:2]))
    hi = dict(zip(ARCHIVE_ORDER, member[10:20:2]))
    return {'base': {s: base[s] for s in STATS}, 'min': {s: lo[s] for s in STATS}, 'max': {s: hi[s] for s in STATS},
            'source': source}


def solve(a, b):
    """Gaussian elimination for the normal equations (a square)."""
    n = len(a)
    m = [row[:] + [b[i]] for i, row in enumerate(a)]
    for col in range(n):
        pivot = max(range(col, n), key=lambda r: abs(m[r][col]))
        m[col], m[pivot] = m[pivot], m[col]
        for r in range(n):
            if r != col and m[col][col]:
                f = m[r][col] / m[col][col]
                m[r] = [x - f * y for x, y in zip(m[r], m[col])]
    return [m[i][n] / m[i][i] if m[i][i] else 0.0 for i in range(n)]


def features(stats):
    values = [stats[k] for k in BASE_STATS]
    return values + [sum(values), 1.0]


def fit(known):
    """For each stat, the weights of a least-squares score and its cuts (the scores where the stars change), so the
    stars' spread over HeartGold's species stays HeartGold's."""
    rules = {}
    rows = [features(stats) for stats, _ in known]
    for stat in STATS:
        y = [e['base'][stat] for _, e in known]
        ata = [[sum(r[i] * r[j] for r in rows) for j in range(len(rows[0]))] for i in range(len(rows[0]))]
        aty = [sum(r[i] * v for r, v in zip(rows, y)) for i in range(len(rows[0]))]
        weights = solve(ata, aty)
        scores = sorted(sum(w * x for w, x in zip(weights, r)) for r in rows)
        cuts, seen = [], 0
        for star in range(4):
            seen += y.count(star)
            cuts.append(scores[min(seen, len(scores) - 1)] if seen else float('-inf'))
        rules[stat] = (weights, cuts)
    return rules


def derive(rules, stats):
    out = {'base': {}, 'min': {}, 'max': {}, 'source': 'base stats'}
    for stat in STATS:
        weights, cuts = rules[stat]
        score = sum(w * x for w, x in zip(weights, features(stats)))
        star = sum(1 for cut in cuts if score >= cut)
        out['base'][stat] = star
        out['min'][stat] = max(0, star - 1)
        out['max'][stat] = min(4, star + 1)
    return out


def main():
    species = [line.strip() for line in open(os.path.join(DECOMP, 'generated', 'species.txt'))]
    dex = species.index('SPECIES_BAD_EGG') - 2  # NATIONAL_DEX_COUNT
    members, index = narc_members(os.path.join(HG, 'files', 'poketool', 'personal', 'performance.narc')), hg_index()
    old = json.load(open(OUT)) if os.path.exists(OUT) else {'species': {}}

    def base_stats(n):
        path = os.path.join(DECOMP, 'res', 'pokemon', species[n][len('SPECIES_'):].lower(), 'data.json')
        return json.load(open(path))['base_stats'] if os.path.exists(path) else None

    out, known, forms = {}, [], {}
    for n in range(1, HG_SPECIES + 1):
        first = index[n]
        count = (index[n + 1] if n + 1 < len(index) else len(members)) - first
        out[species[n]] = entry(members[first], 'HeartGold')
        if count > 1:
            forms[species[n]] = [entry(members[first + f], 'HeartGold') for f in range(count)]
        stats = base_stats(n)
        if stats:
            known.append((stats, out[species[n]]))
    rules = fit(known)
    missing = []
    for n in range(HG_SPECIES + 1, dex + 1):
        stats = base_stats(n)
        if stats is None:
            missing.append(species[n])
            continue
        out[species[n]] = derive(rules, stats)
    for name, e in old.get('species', {}).items():
        if e.get('source') == 'owner':
            out[name] = e
    doc = {
        '_about': 'Each species\' Pokéathlon performance: base stars and range per stat, 0-4 meaning one to five stars '
                  '(tools/complete/import_hgss_performance.py). "source": HeartGold (its data), base stats (Complete\'s '
                  'species past 493, provisional until the owner decides), owner (kept on a rerun). A form not listed '
                  'under "forms" takes its species\' entry.',
        'stats': STATS,
        'species': out,
        'forms': forms,
    }
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, 'w', encoding='utf-8') as f:  # one species a line, so an entry is easy to find and change
        f.write('{\n')
        f.write(f' "_about": {json.dumps(doc["_about"], ensure_ascii=False)},\n')
        f.write(f' "stats": {json.dumps(STATS)},\n')
        f.write(' "species": {\n')
        f.write(',\n'.join(f'  {json.dumps(k)}: {json.dumps(v)}' for k, v in out.items()))
        f.write('\n },\n "forms": {\n')
        f.write(',\n'.join(f'  {json.dumps(k)}: [\n' + ',\n'.join(f'   {json.dumps(e)}' for e in v) + '\n  ]'
                            for k, v in forms.items()))
        f.write('\n }\n}\n')
    json.load(open(OUT, encoding='utf-8'))  # still JSON
    sources = {}
    for e in out.values():
        sources[e['source']] = sources.get(e['source'], 0) + 1
    print(f'{len(out)} species ({sources}), {len(forms)} with HeartGold forms -> {os.path.relpath(OUT, ROOT)}')
    if missing:
        print(f'no base stats for {len(missing)}: {missing[:8]}', file=sys.stderr)


if __name__ == '__main__':
    main()
