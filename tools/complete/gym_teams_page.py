#!/usr/bin/env python3
"""A page of the game's Gym Leaders, Elite Fours and Champions, with their rematch teams, as each battle makes them:
for the owner's redo of the gym teams (Nov 6, 2026).

Each Pokémon as TrainerData_BuildParty (src/trainer_data.c) makes it: Sinnoh's trainers at their levels after Kanto and
evolved to match (data/complete/sinnoh.yaml, src/complete_sinnoh.c), the nature from the seeded personality (Sovereign's
nature, gender and ability changes to it), the ability from the personality's slot unless the JSON names one, the
level-up moves when it gives none, the IVs from the IV scale or its "ivs" (a stat left out is 31), the EVs from "evs".

Usage: python3 tools/complete/gym_teams_page.py [OUT]   (default .cache/gym_teams/index.html)
"""
import base64
import html
import io
import json
import os
import re
import sys

import yaml
from PIL import Image

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
RES = os.path.join(DECOMP, 'res')
TRAINERS = os.path.join(RES, 'trainers', 'data')

JOHTO = ['falkner_falkner', 'bugsy_bugsy', 'whitney', 'morty_morty', 'chuck_chuck', 'jasmine_jasmine', 'pryce_pryce',
         'clair_clair']
KANTO = ['brock_brock', 'misty_misty', 'lt_surge_lt__surge', 'erika_erika', 'janine_janine', 'sabrina_sabrina',
         'blaine_blaine', 'blue_blue']
SINNOH = ['roark', 'gardenia', 'maylene', 'wake', 'fantina', 'byron', 'candice', 'volkner']
TOWNS = {
    'falkner_falkner': 'Violet City', 'bugsy_bugsy': 'Azalea Town', 'whitney': 'Goldenrod City',
    'morty_morty': 'Ecruteak City', 'chuck_chuck': 'Cianwood City', 'jasmine_jasmine': 'Olivine City',
    'pryce_pryce': 'Mahogany Town', 'clair_clair': 'Blackthorn City', 'brock_brock': 'Pewter City',
    'misty_misty': 'Cerulean City', 'lt_surge_lt__surge': 'Vermilion City', 'erika_erika': 'Celadon City',
    'janine_janine': 'Fuchsia City', 'sabrina_sabrina': 'Saffron City', 'blaine_blaine': 'Seafoam Islands',
    'blue_blue': 'Viridian City', 'roark': 'Oreburgh City', 'gardenia': 'Eterna City', 'maylene': 'Veilstone City',
    'wake': 'Pastoria City', 'fantina': 'Hearthome City', 'byron': 'Canalave City', 'candice': 'Snowpoint City',
    'volkner': 'Sunyshore City'}

# (section id, title, [(first battle file, rematch file or None, subtitle)])
SECTIONS = [
    ('johto', 'Johto Gyms', [(f'hgss_leader_{n}', f'hgss_leader_{n}_2', TOWNS[n]) for n in JOHTO]),
    ('kanto', 'Kanto Gyms', [(f'hgss_leader_{n}', f'hgss_leader_{n}_2', TOWNS[n]) for n in KANTO]),
    ('sinnoh', 'Sinnoh Gyms', [(f'leader_{n}', f'leader_{n}_rematch', TOWNS[n]) for n in SINNOH]),
    ('league-jk', 'Indigo Plateau', [(f'hgss_elite_four_{n}_{n}', f'hgss_elite_four_{n}_{n}_2', 'Elite Four')
                                     for n in ('will', 'koga', 'bruno', 'karen')]
     + [('hgss_champion_lance', 'hgss_champion_lance_2', 'Champion'),
        ('hgss_pkmn_trainer_red_red', None, 'Mt. Silver')]),
    ('league-s', 'Sinnoh League', [(f'elite_four_{n}', f'elite_four_{n}_rematch', 'Elite Four')
                                   for n in ('aaron', 'bertha', 'flint', 'lucian')]
     + [('champion_cynthia', 'champion_cynthia_rematch', 'Champion')]),
]

TYPE_COLOURS = {
    'NORMAL': '#9a9a7c', 'FIRE': '#e8743c', 'WATER': '#5b8ee8', 'ELECTRIC': '#e8c232', 'GRASS': '#6cbb4a',
    'ICE': '#7ccfcf', 'FIGHTING': '#b8382e', 'POISON': '#9a449a', 'GROUND': '#d4b05a', 'FLYING': '#9a8ee8',
    'PSYCHIC': '#e8588a', 'BUG': '#a0b024', 'ROCK': '#b49c3a', 'GHOST': '#6a5896', 'DRAGON': '#6a3ce8',
    'DARK': '#6a5848', 'STEEL': '#a8a8c4', 'FAIRY': '#e09ae0', 'MYSTERY': '#68a090'}
STATS = [('hp', 'HP'), ('atk', 'Atk'), ('def', 'Def'), ('spa', 'SpA'), ('spd', 'SpD'), ('spe', 'Spe')]


def enum(name):
    return [line.strip() for line in open(os.path.join(DECOMP, 'generated', name), encoding='utf-8') if line.strip()]


SPECIES = {s: i for i, s in enumerate(enum('species.txt'))}
ABILITIES = {s: i for i, s in enumerate(enum('abilities.txt'))}
ABILITY_NAMES = [m['en_US'] for m in json.load(open(os.path.join(RES, 'text', 'ability_names.json')))['messages']]
NATURE_NAMES = [m['en_US'] for m in json.load(open(os.path.join(RES, 'text', 'nature_names.json')))['messages']]


def generated_enum(header):
    src = open(os.path.join(DECOMP, 'build', 'generated', header), encoding='utf-8').read()
    return {m.group(1): int(m.group(2)) for m in re.finditer(r'^#define (\w+)\s+(\d+)', src, re.M)}


GENDER_RATIOS = {k.strip(): int(v) for k, v in (line.split('=') for line in enum('gender_ratios.txt') if '=' in line)}
TRAINER_IDS = generated_enum('trainers.h')
CLASS_IDS = generated_enum('trainer_classes.h')
FEMALE_CLASSES = set(re.findall(r'\[(TRAINER_CLASS_\w+)\]\s*=\s*GENDER_FEMALE',
                                open(os.path.join(DECOMP, 'include', 'data', 'trainer_class_genders.h')).read()))
TRAINER_HGSS_FIRST = TRAINER_IDS['TRAINER_HGSS_RIVAL_SILVER']

PLAN = yaml.safe_load(open(os.path.join(ROOT, 'data', 'complete', 'sinnoh.yaml'), encoding='utf-8'))
LEVEL_EVOS = {'EVO_LEVEL', 'EVO_LEVEL_ATK_GT_DEF', 'EVO_LEVEL_ATK_EQ_DEF', 'EVO_LEVEL_ATK_LT_DEF', 'EVO_LEVEL_PID_LOW',
              'EVO_LEVEL_PID_HIGH', 'EVO_LEVEL_NINJASK', 'EVO_LEVEL_MALE', 'EVO_LEVEL_FEMALE'}

_species_cache = {}
FORM_DEFINES = {}
for _m in re.finditer(r'^#define (\w+?)_FORM_(\w+)\s+(\d+)\s*$', open(os.path.join(DECOMP, 'include', 'constants', 'forms.h')).read(), re.M):
    if _m.group(2) != 'COUNT':
        FORM_DEFINES[(_m.group(1), int(_m.group(3)))] = _m.group(2).lower()


def form_dir(species, form):
    """The form's folder in res/pokemon/<species>/forms, or None for the base form"""
    name = FORM_DEFINES.get((species[len('SPECIES_'):], form)) if form else None
    path = os.path.join(species_dir(species), 'forms', name) if name else None
    return path if path and os.path.isdir(path) else None


def form_data(species, form):
    d = form_dir(species, form)
    if d and os.path.exists(os.path.join(d, 'data.json')):
        return json.load(open(os.path.join(d, 'data.json'), encoding='utf-8'))
    return species_data(species)


def species_dir(species):
    return os.path.join(RES, 'pokemon', species[len('SPECIES_'):].lower())


def species_data(species):
    if species not in _species_cache:
        _species_cache[species] = json.load(open(os.path.join(species_dir(species), 'data.json'), encoding='utf-8'))
    return _species_cache[species]


def species_name(species):
    name = species_data(species)['pokedex_data']['en']['name']
    # Plain case, as Sacred Gold's text: a capital after a space, a hyphen or a dot only (Farfetch'd, Ho-Oh, Mr. Mime)
    return re.sub(r"(^|[ .\-])([a-z])", lambda m: m.group(1) + m.group(2).upper(), name.lower())


def sinnoh_level(level):
    pts = PLAN['levels']
    for (a, b), (c, e) in zip(pts, pts[1:]):
        if a <= level <= c:
            return b + ((level - a) * (e - b) * 2 + (c - a)) // ((c - a) * 2)
    return min(level, 100)


def sinnoh_evolved(species, level):
    first, second = PLAN['evolve_at']
    for stage in range(2):
        nxt = None
        for evo in species_data(species).get('evolutions') or []:
            method, param, target = evo[0], (evo[1] if len(evo) == 3 else 0), evo[-1]
            if method in ('EVO_NONE', 'EVO_LEVEL_SHEDINJA'):
                continue
            at = param if method in LEVEL_EVOS else (first if stage == 0 else second)
            if level >= at:
                nxt = target
                break
        if not nxt:
            break
        species = nxt
    return species


def lcrng(seed):
    seed = (seed * 0x41C64E6D + 0x6073) & 0xFFFFFFFF
    return seed, seed >> 16


def personality(trainer_id, cls, mon, species, level):
    seed = (mon['iv_scale'] + level + SPECIES[species] + trainer_id) & 0xFFFFFFFF
    rnd = seed
    for _ in range(CLASS_IDS[cls]):
        seed, rnd = lcrng(seed)
    return ((rnd << 8) + (120 if cls in FEMALE_CLASSES else 136)) & 0xFFFFFFFF


def sovereign_personality(pid, species, mon, ability_slot):
    """TrainerData_SovereignPersonality: the nature, gender and ability slot asked for"""
    ratio = species_data(species)['gender_ratio']
    fixed = ratio in ('GENDER_RATIO_MALE_ONLY', 'GENDER_RATIO_FEMALE_ONLY', 'GENDER_RATIO_NO_GENDER')
    ratio_n = GENDER_RATIOS[ratio]
    low, high = pid & 0xFF, pid >> 8
    gender = mon.get('gender')
    for i in range(256):
        cand = (low + i) & 0xFF
        if gender and not fixed:
            g = 'GENDER_FEMALE' if ratio_n > cand else 'GENDER_MALE'
            if g != gender and gender.upper() not in (g, g[7:]):
                continue
        if ability_slot >= 0 and (cand & 1) != ability_slot:
            continue
        low = cand
        break
    if mon.get('nature'):
        nature = enum('natures.txt').index(mon['nature'])
        if high > 0xFFFFFF - 25:
            high -= 25
        for i in range(25):
            if (((high + i) << 8) | low) % 25 == nature:
                high += i
                break
    return (high << 8) | low


def default_moves(species, level):
    moves = []
    for lv, move in species_data(species)['learnset']['by_level']:
        if lv > level:
            break
        if move in moves:
            continue
        if len(moves) == 4:
            moves.pop(0)
        moves.append(move)
    return moves


_move_cache = {}


def move_info(move):
    if move not in _move_cache:
        path = os.path.join(RES, 'moves', move[len('MOVE_'):].lower(), 'data.json')
        d = json.load(open(path, encoding='utf-8')) if os.path.exists(path) else {'name': move[5:].title(), 'type': 'TYPE_NORMAL'}
        _move_cache[move] = (d['name'], d['type'][len('TYPE_'):], d.get('class', '')[len('CLASS_'):].title())
    return _move_cache[move]


def item_name(item):
    path = os.path.join(RES, 'items', 'data', item[len('ITEM_'):].lower() + '.json')
    if os.path.exists(path):
        return json.load(open(path, encoding='utf-8'))['name']
    return item[len('ITEM_'):].replace('_', ' ').title()


def png_uri(im, scale=1):
    if scale != 1:
        im = im.resize((im.width * scale, im.height * scale), Image.NEAREST)
    buf = io.BytesIO()
    im.save(buf, 'PNG', optimize=True)
    return 'data:image/png;base64,' + base64.b64encode(buf.getvalue()).decode()


def jasc(path):
    lines = open(path, encoding='utf-8').read().split('\n')[3:]
    flat = [int(c) for line in lines if line.strip() for c in line.split()]
    return flat + [0] * (768 - len(flat))


def transparent0(im):
    """An indexed sprite with its palette's first colour see-through, cropped to its first 80x80 frame"""
    im = im.crop((0, 0, 80, 80))
    rgba = im.convert('RGBA')
    px, idx = rgba.load(), im.load()
    for y in range(im.height):
        for x in range(im.width):
            if idx[x, y] == 0:
                px[x, y] = (0, 0, 0, 0)
    return rgba


def trim(im, margin=1):
    box = im.getbbox()
    if not box:
        return im
    l, t, r, b = box
    return im.crop((max(0, l - margin), max(0, t - margin), min(im.width, r + margin), min(im.height, b + margin)))


_sprite_cache = {}


def mon_sprite(species, form, female):
    key = (species, form, female)
    if key not in _sprite_cache:
        d = species_dir(species)
        name = 'female_front.png' if female and os.path.exists(os.path.join(d, 'female_front.png')) else 'male_front.png'
        path = os.path.join(d, name)
        fd = form_dir(species, form)
        if fd and os.path.exists(os.path.join(fd, 'front.png')):
            path = os.path.join(fd, 'front.png')
        _sprite_cache[key] = png_uri(transparent0(Image.open(path)), 2)
    return _sprite_cache[key]


def trainer_sprite(cls):
    folder = cls[len('TRAINER_CLASS_'):].lower()
    return png_uri(trim(transparent0(Image.open(os.path.join(RES, 'trainers', 'classes', folder, 'front.png')))), 2)


_item_icon_cache = {}


def item_icon(item):
    if item not in _item_icon_cache:
        stem = os.path.join(RES, 'items', 'icons', item[len('ITEM_'):].lower())
        uri = None
        if os.path.exists(stem + '.png') and os.path.exists(stem + '.pal'):
            im = Image.open(stem + '.png')
            im.putpalette(jasc(stem + '.pal'))
            rgba = im.convert('RGBA')
            px, idx = rgba.load(), im.load()
            for y in range(im.height):
                for x in range(im.width):
                    if idx[x, y] == 0:
                        px[x, y] = (0, 0, 0, 0)
            uri = png_uri(trim(rgba, 0))
        _item_icon_cache[item] = uri
    return _item_icon_cache[item]


def build_mon(trainer_file, data, mon):
    tid = TRAINER_IDS['TRAINER_' + trainer_file.upper()]
    cls = data['class']
    species, level = mon['species'], mon['level']
    sinnoh = tid < TRAINER_HGSS_FIRST
    if sinnoh:
        level = sinnoh_level(level)
        species = sinnoh_evolved(species, level)
    form = mon.get('form', 0)
    sd = form_data(species, form)
    pid = personality(tid, cls, mon, species, level)
    abilities = sd['abilities']
    sovereign = any(k in m for m in data['party'] for k in ('nature', 'ability', 'ivs', 'evs', 'gender', 'shiny', 'ball'))
    ability = None
    if sovereign:
        slot = -1
        asked = mon.get('ability')
        if asked and asked != 'ABILITY_NONE':
            if asked == abilities[0]:
                slot = -1 if abilities[1] in ('ABILITY_NONE', abilities[0]) else 0
            elif asked == abilities[1]:
                slot = 1
            ability = asked
        pid = sovereign_personality(pid, species, mon, slot)
    if not ability:
        ability = abilities[1] if (pid & 1) and abilities[1] != 'ABILITY_NONE' else abilities[0]
    ivs = {k: mon['iv_scale'] * 31 // 255 for k, _ in STATS}
    if sovereign and mon.get('ivs'):
        ivs = {k: mon['ivs'].get(k, 31) for k, _ in STATS}
    evs = {k: (mon.get('evs') or {}).get(k, 0) for k, _ in STATS} if sovereign else {k: 0 for k, _ in STATS}
    moves = mon.get('moves') or default_moves(species, level)
    ratio = sd['gender_ratio']
    female = False
    if ratio not in ('GENDER_RATIO_MALE_ONLY', 'GENDER_RATIO_NO_GENDER'):
        female = ratio == 'GENDER_RATIO_FEMALE_ONLY' or (mon.get('gender', '').upper().endswith('FEMALE'))
    return {
        'species': species,
        'name': (FORM_DEFINES[(species[8:], form)].title() + ' ' if form_dir(species, form) else '') + species_name(species),
        'mega': bool(mon.get('item')) and re.search(r'ITE(_[XYZ])?$', mon['item']) is not None
                and mon['item'][5:9] == species[8:12]
                and any(f.startswith('mega') for f in os.listdir(os.path.join(species_dir(species), 'forms'))
                        if os.path.isdir(os.path.join(species_dir(species), 'forms'))), 'level': level, 'form': mon.get('form', 0),
        'evolved': species != mon['species'], 'from': species_name(mon['species']), 'from_level': mon['level'],
        'item': mon.get('item') if mon.get('item') not in (None, 'ITEM_NONE') else None,
        'ability': ABILITY_NAMES[ABILITIES[ability]], 'ability_set': bool(mon.get('ability')),
        'nature': NATURE_NAMES[pid % 25], 'nature_set': bool(mon.get('nature')),
        'moves': [m for m in moves if m != 'MOVE_NONE'], 'moves_set': bool(mon.get('moves')),
        'ivs': ivs, 'evs': evs, 'shiny': bool(mon.get('shiny')),
        'types': [t[len('TYPE_'):] for t in dict.fromkeys(sd['types'])], 'sprite': mon_sprite(species, mon.get('form', 0), female),
    }


def esc(s):
    return html.escape(str(s))


def spread(values, empty):
    if all(v == 0 for v in values.values()) and empty == 'ev':
        return '<span class="none">None</span>'
    if len(set(values.values())) == 1:
        v = next(iter(values.values()))
        return f'<span class="all">{v} all</span>'
    return ''.join(f'<span class="st"><b>{label}</b>{values[k]}</span>' for k, label in STATS if empty != 'ev' or values[k])


def mon_card(m, slot):
    type_badges = ''.join(f'<span class="ty" style="--t:{TYPE_COLOURS.get(t, "#888")}">{t.title()}</span>' for t in m['types'])
    moves = ''.join(
        f'<li><span class="dot" style="--t:{TYPE_COLOURS.get(t, "#888")}" title="{t.title()} · {c}"></span>{esc(n)}</li>'
        for n, t, c in (move_info(x) for x in m['moves']))
    icon = item_icon(m['item']) if m['item'] else None
    item = (f'<img class="ii" src="{icon}" alt="">' if icon else '') + esc(item_name(m['item'])) if m['item'] else '<span class="none">None</span>'
    note = f'<div class="note">Lv. {m["from_level"]} {esc(m["from"])} in the data</div>' if m['evolved'] else ''
    return f'''<div class="mon" data-slot="{slot}">
  <div class="mtop"><img class="ms" src="{m["sprite"]}" alt="{esc(m["name"])}" loading="lazy"><span class="lv">Lv. {m["level"]}</span></div>
  <div class="mname">{esc(m["name"])}{' <span class="shiny" title="Shiny">★</span>' if m['shiny'] else ''}</div>{'<span class="mega">Mega</span>' if m['mega'] else ''}
  <div class="types">{type_badges}</div>{note}
</div>''', f'''<div class="det">
  <div class="dh"><img src="{m["sprite"]}" alt=""><div><div class="dn">{esc(m["name"])} <span class="dl">Lv. {m["level"]}</span></div><div class="types">{type_badges}</div></div></div>
  <dl>
    <dt>Ability</dt><dd>{esc(m["ability"])}</dd>
    <dt>Item</dt><dd>{item}</dd>
    <dt>Nature</dt><dd>{esc(m["nature"])}{'' if m['nature_set'] else ' <span class="hint">(seeded)</span>'}</dd>
    <dt>IVs</dt><dd class="sp">{spread(m["ivs"], "iv")}</dd>
    <dt>EVs</dt><dd class="sp">{spread(m["evs"], "ev")}</dd>
  </dl>
  <ul class="moves">{moves}</ul>{'' if m['moves_set'] else '<div class="hint">Level-up moves</div>'}
</div>'''


def team_html(trainer_file):
    data = json.load(open(os.path.join(TRAINERS, trainer_file + '.json'), encoding='utf-8'))
    mons = [build_mon(trainer_file, data, mon) for mon in data['party']]
    cards, dets = zip(*(mon_card(m, i) for i, m in enumerate(mons)))
    ace = max(m['level'] for m in mons)
    return data, f'''<div class="team">
  <div class="grid">{''.join(cards)}{''.join('<div class="mon empty"></div>' for _ in range(6 - len(mons)))}</div>
  <div class="dets">{''.join(dets)}</div>
</div>''', ace, data.get('double_battle')


def trainer_card(first, rematch, subtitle):
    data, first_html, ace, doubles = team_html(first)
    tabs = f'<button class="tab on" data-k="a">First battle <span>Lv. {ace}</span></button>'
    panes = f'<div class="pane on" data-k="a">{first_html}</div>'
    if rematch and os.path.exists(os.path.join(TRAINERS, rematch + '.json')):
        _, re_html, re_ace, _ = team_html(rematch)
        tabs += f'<button class="tab" data-k="b">Rematch <span>Lv. {re_ace}</span></button>'
        panes += f'<div class="pane" data-k="b">{re_html}</div>'
    cls_label = data['class'][len('TRAINER_CLASS_'):]
    return f'''<article class="trainer" id="{esc(first)}">
  <header>
    <img class="tsprite" src="{trainer_sprite(data["class"])}" alt="{esc(data["name"])}">
    <div class="th"><h3>{esc(data["name"])}</h3><div class="sub">{esc(subtitle)}{' · Double battle' if doubles else ''}</div>
      <div class="tabs" role="tablist">{tabs}</div></div>
  </header>
  {panes}
</article>'''


CSS = '''
:root{--bg:#f4f1ea;--panel:#fffdf8;--ink:#1e1c19;--muted:#6d675e;--line:#e3ddd1;--chip:#efe9dd;--accent:#c0392b;--sel:#fff3d6}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){--bg:#17161a;--panel:#211f25;--ink:#ece8e1;--muted:#a39d94;--line:#34313a;--chip:#2c2931;--accent:#ff7b6b;--sel:#3a3222}}
:root[data-theme="dark"]{--bg:#17161a;--panel:#211f25;--ink:#ece8e1;--muted:#a39d94;--line:#34313a;--chip:#2c2931;--accent:#ff7b6b;--sel:#3a3222}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);font:15px/1.45 "Inter",system-ui,sans-serif;-webkit-font-smoothing:antialiased}
.wrap{max-width:1180px;margin:0 auto;padding:24px max(16px,env(safe-area-inset-right)) 64px max(16px,env(safe-area-inset-left))}
h1{font:700 30px/1.15 "Inter",system-ui,sans-serif;margin:8px 0 4px;letter-spacing:-.02em}
.lede{color:var(--muted);margin:0 0 18px;max-width:72ch}
nav{position:sticky;top:0;z-index:5;background:var(--bg);padding:10px 0;display:flex;gap:6px;flex-wrap:wrap;border-bottom:1px solid var(--line);margin-bottom:8px}
nav a{color:var(--ink);text-decoration:none;font-weight:600;font-size:13px;padding:6px 12px;border-radius:999px;background:var(--chip)}
nav a:hover{background:var(--sel)}
h2{font-size:21px;margin:34px 0 12px;letter-spacing:-.01em}
.trainers{display:grid;grid-template-columns:repeat(auto-fill,minmax(min(100%,540px),1fr));gap:16px}
.trainer{background:var(--panel);border:1px solid var(--line);border-radius:14px;padding:14px;min-width:0}
.trainer header{display:flex;gap:14px;align-items:flex-end;margin-bottom:10px}
.tsprite{width:96px;height:auto;max-height:120px;object-fit:contain;image-rendering:pixelated;flex:none;background:var(--chip);border-radius:10px;padding:4px}
.th{min-width:0;flex:1}
.th h3{margin:0;font-size:19px}
.sub{color:var(--muted);font-size:13px;margin-bottom:8px}
.tabs{display:flex;gap:6px;flex-wrap:wrap}
.tab{font:inherit;font-size:12.5px;font-weight:600;border:1px solid var(--line);background:transparent;color:var(--ink);padding:4px 10px;border-radius:8px;cursor:pointer}
.tab span{color:var(--muted);font-weight:500;margin-left:4px}
.tab.on{background:var(--ink);color:var(--panel);border-color:var(--ink)}
.tab.on span{color:inherit;opacity:.75}
.pane{display:none}.pane.on{display:block}
.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:8px}
.mon{border:1px solid var(--line);border-radius:10px;padding:6px 6px 8px;text-align:center;cursor:pointer;min-width:0;transition:background .12s}
.mon:hover{background:var(--chip)}

.mon.empty{border-style:dashed;cursor:default;opacity:.5}.mon.empty:hover{background:none}
.mtop{position:relative}
.ms{width:100%;max-width:120px;aspect-ratio:1;image-rendering:pixelated;display:block;margin:0 auto}
.lv{position:absolute;top:0;right:0;font-size:11.5px;font-weight:700;background:var(--ink);color:var(--panel);border-radius:6px;padding:1px 6px}
.mname{font-weight:650;font-size:13.5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.types{display:flex;gap:3px;justify-content:center;flex-wrap:wrap;margin-top:2px}
.ty{font-size:10px;font-weight:700;color:#fff;background:var(--t);padding:0 6px;border-radius:4px;text-transform:uppercase;letter-spacing:.03em;text-shadow:0 1px 0 rgba(0,0,0,.25)}
.shiny{color:#e0a800}
.mega{position:absolute;top:6px;left:6px;font-size:10px;font-weight:700;color:#fff;background:linear-gradient(135deg,#7b4fd6,#d64f9a);border-radius:5px;padding:1px 6px}
.mon{position:relative}
.note{font-size:11px;color:var(--muted);margin-top:3px}
.dets{display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-top:10px}
.det{font-size:12.5px;border-top:2px solid var(--line);padding-top:6px;min-width:0}
.dh{display:none}
.det dl{display:grid;grid-template-columns:auto 1fr;gap:1px 8px;margin:0 0 6px}
.det dt{color:var(--muted);font-weight:600}
.det dd{margin:0;min-width:0;overflow-wrap:anywhere}
.ii{width:18px;height:18px;object-fit:contain;image-rendering:pixelated;vertical-align:-4px;margin-right:3px}
.sp{display:flex;flex-wrap:wrap;gap:2px 6px}
.st b{font-weight:600;color:var(--muted);margin-right:2px;font-size:11px}
.none,.hint{color:var(--muted)}
.hint{font-size:11px}
.moves{list-style:none;margin:0;padding:0;display:grid;gap:1px}
.moves li{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.dot{display:inline-block;width:8px;height:8px;border-radius:50%;background:var(--t);margin-right:6px;vertical-align:1px}
footer{color:var(--muted);font-size:12.5px;margin-top:40px;max-width:80ch}
@media (max-width:620px){
  .dets{grid-template-columns:1fr}
  .det{display:none;border:1px solid var(--accent);border-radius:10px;padding:10px;background:var(--sel)}
  .det.show{display:block}
  .mon.sel{background:var(--sel);border-color:var(--accent)}
  .dh{display:flex;gap:8px;align-items:center;margin-bottom:6px}
  .dh img{width:48px;height:48px;image-rendering:pixelated}
  .dn{font-weight:700}.dl{color:var(--muted);font-weight:500}
  .dh .types{justify-content:flex-start}
  .tsprite{width:72px}
}
'''

JS = '''
document.querySelectorAll('.trainer').forEach(t=>{
  t.querySelectorAll('.tab').forEach(b=>b.addEventListener('click',()=>{
    t.querySelectorAll('.tab,.pane').forEach(e=>e.classList.toggle('on',e.dataset.k===b.dataset.k));
  }));
});
document.querySelectorAll('.team').forEach(team=>{
  const mons=team.querySelectorAll('.mon:not(.empty)'),dets=team.querySelectorAll('.det');
  const pick=i=>{mons.forEach((m,j)=>m.classList.toggle('sel',j===i));dets.forEach((d,j)=>d.classList.toggle('show',j===i));};
  mons.forEach((m,i)=>m.addEventListener('click',()=>pick(i)));
  pick(0);
});
'''


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache', 'gym_teams', 'index.html')
    body = []
    for sid, title, rows in SECTIONS:
        body.append(f'<section id="{sid}"><h2>{esc(title)}</h2><div class="trainers">')
        body.extend(trainer_card(*row) for row in rows)
        body.append('</div></section>')
    nav = ''.join(f'<a href="#{sid}">{esc(title)}</a>' for sid, title, _ in SECTIONS)
    page = f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="claude:viewport-fit-sides" content="cover">
<title>Sovereign Complete Gym Teams</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;650;700&display=swap" rel="stylesheet">
<style>{CSS}</style></head>
<body><div class="wrap">
<h1>Gym Leaders, Elite Fours and Champions</h1>
<p class="lede">Every team as the game builds it today: Johto's and Kanto's from Sacred Gold, Sinnoh's from Renegade Platinum
through Sovereign, at their levels after Kanto and evolved to match. Tap a Pokémon to see its set below the grid; switch to the
rematch with the tabs.</p>
<nav>{nav}</nav>
{''.join(body)}
<footer>Built from the repository by <code>tools/complete/gym_teams_page.py</code>. IVs come from each Pokémon's IV scale
unless its data sets them; a nature marked “seeded” comes from the trainer's fixed random seed, as the game makes it, and
changes if the trainer's class, level, species or IV scale does. Moves marked “Level-up moves” are the last four it learns
by its level, because its data names none.</footer>
</div><script>{JS}</script></body></html>'''
    os.makedirs(os.path.dirname(out), exist_ok=True)
    open(out, 'w', encoding='utf-8').write(page)
    print(out, f'{len(page) / 1e6:.2f} MB')


if __name__ == '__main__':
    main()
