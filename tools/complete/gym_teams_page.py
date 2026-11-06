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
import collections
import html
import io
import json
import os
import re
import sys

import yaml
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import boss_plan  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
RES = os.path.join(DECOMP, 'res')
TRAINERS = os.path.join(RES, 'trainers', 'data')

def gym(stem, rematch, where, extra=()):
    """A battle with its rematch: tabs First battle and Rematch (and any extra (label, file))"""
    return {'where': where, 'tabs': [('First battle', stem)] + ([('Rematch', rematch)] if rematch else []) + list(extra)}


def by_starter(where, files, note=''):
    """A rival's battle in its versions for the player's starter, each tab named after the rival's own starter line"""
    return {'where': where, 'tabs': [(None, f) for f in files], 'starter_tabs': True, 'note': note}


def tag(where, files, name, note=''):
    """A tag or double battle against two trainers: a tab each"""
    return {'where': where, 'tabs': [(None, f) for f in files], 'name': name, 'note': note}


def sinnoh_rival(place):
    return [f'rival_{place}_{s}' for s in ('turtwig', 'chimchar', 'piplup')]


def silver(*numbers):
    return [f'hgss_rival_silver{"" if n == 1 else "_" + str(n)}' for n in numbers]


def league_s(n):
    return gym(f'elite_four_{n}', f'elite_four_{n}_rematch', 'Elite Four')


def dawn_lucas(route):
    """Dawn's battle (for a male player) and Lucas's (for a female one), each in a version for each starter"""
    files = [f'sovereign_{who}_{route}_{s}' for who in ('dawn', 'lucas') for s in ('turtwig', 'chimchar', 'piplup')]
    return dict(by_starter(route.replace('_', ' ').title(), files), name='Dawn or Lucas', named_tabs=True)


# The story's boss battles in the order a player meets them (Johto, then Kanto, then Sinnoh), each with its rematch
# where there is one: (section id, title, [battle])
SECTIONS = [
    ('johto', 'Johto', 'johto', [
        dict(by_starter('Cherrygrove City (named \u201cBoy\u201d until you learn his name)',
                        ['hgss_passerby_boy', 'hgss_passerby_boy_2', 'hgss_passerby_boy_3']), name='Silver'),
        gym('hgss_leader_falkner_falkner', 'hgss_leader_falkner_falkner_2', 'Violet City Gym'),
        gym('hgss_executive_proton_proton', None, 'Slowpoke Well (Team Rocket)'),
        gym('hgss_leader_bugsy_bugsy', 'hgss_leader_bugsy_bugsy_2', 'Azalea Town Gym'),
        by_starter('Azalea Town', silver(1, 7, 10)),
        gym('hgss_leader_whitney', 'hgss_leader_whitney_2', 'Goldenrod City Gym'),
        by_starter('Burned Tower (Ecruteak City)', silver(4, 8, 11)),
        gym('hgss_leader_morty_morty', 'hgss_leader_morty_morty_2', 'Ecruteak City Gym'),
        gym('hgss_mystery_man_eusine', None, 'Cianwood City'),
        gym('hgss_leader_chuck_chuck', 'hgss_leader_chuck_chuck_2', 'Cianwood City Gym'),
        gym('hgss_leader_jasmine_jasmine', 'hgss_leader_jasmine_jasmine_2', 'Olivine City Gym'),
        gym('hgss_executive_petrel_petrel_2', None, 'Team Rocket Hideout B3F (Mahogany Town)'),
        tag('Team Rocket Hideout B2F, with Lance at your side', ['hgss_executive_ariana_ariana_2', 'hgss_team_rocket_grunt_25'],
            'Ariana & Grunt'),
        gym('hgss_leader_pryce_pryce', 'hgss_leader_pryce_pryce_2', 'Mahogany Town Gym'),
        gym('hgss_executive_petrel_petrel', None, 'Radio Tower 5F (Goldenrod City)'),
        by_starter('Goldenrod Underground', silver(17, 18, 12)),
        gym('hgss_executive_archer_archer', None, 'Radio Tower, the top floor'),
        tag('Ecruteak Dance Theater, one after another', [f'hgss_kimono_girl_{n}' for n in ('zuki', 'naoko', 'miki', 'sayo', 'kuni')],
            'The Kimono Girls'),
        gym('hgss_leader_clair_clair', 'hgss_leader_clair_clair_2', 'Blackthorn City Gym'),
        by_starter('Victory Road', silver(5, 9, 13)),
        gym('hgss_elite_four_will_will', 'hgss_elite_four_will_will_2', 'Elite Four (Indigo Plateau)'),
        gym('hgss_elite_four_koga_koga', 'hgss_elite_four_koga_koga_2', 'Elite Four'),
        gym('hgss_elite_four_bruno_bruno', 'hgss_elite_four_bruno_bruno_2', 'Elite Four'),
        gym('hgss_elite_four_karen_karen', 'hgss_elite_four_karen_karen_2', 'Elite Four'),
        gym('hgss_champion_lance', 'hgss_champion_lance_2', 'Champion'),
    ]),
    ('kanto', 'Kanto', 'kanto', [
        gym('hgss_leader_brock_brock', 'hgss_leader_brock_brock_2', 'Pewter City Gym'),
        by_starter('Mt. Moon', silver(14, 15, 16)),
        gym('hgss_leader_misty_misty', 'hgss_leader_misty_misty_2', 'Cerulean City Gym'),
        gym('hgss_leader_lt_surge_lt__surge', 'hgss_leader_lt_surge_lt__surge_2', 'Vermilion City Gym'),
        gym('hgss_leader_janine_janine', 'hgss_leader_janine_janine_2', 'Fuchsia City Gym'),
        gym('hgss_leader_erika_erika', 'hgss_leader_erika_erika_2', 'Celadon City Gym'),
        gym('hgss_leader_sabrina_sabrina', 'hgss_leader_sabrina_sabrina_2', 'Saffron City Gym'),
        gym('hgss_leader_blaine_blaine', 'hgss_leader_blaine_blaine_2', 'Seafoam Islands Gym'),
        gym('hgss_leader_blue_blue', 'hgss_leader_blue_blue_2', 'Viridian City Gym'),
        gym('hgss_pkmn_trainer_red_red', None, 'Mt. Silver'),
        by_starter('Indigo Plateau and Saffron’s Dojo (rematches)', silver(19, 20, 21)),
        tag('Dragon’s Den, with Silver at your side', ['hgss_champion_lance_3', 'hgss_leader_clair_clair_3'], 'Lance & Clair'),
        gym('hgss_rocket_boss_giovanni', None, 'Celebi’s journey into the past (Team Rocket)'),
        gym('hgss_youngster_mickey', None, 'Cerulean Cave, after Mewtwo'),
    ]),
    ('sinnoh', 'Sinnoh', 'sinnoh', [
        by_starter('Route 201', sinnoh_rival('route_201')),
        dawn_lucas('route_202'),
        by_starter('Route 203', sinnoh_rival('route_203')),
        gym('leader_roark', 'leader_roark_rematch', 'Oreburgh City Gym'),
        gym('commander_mars_valley_windworks', None, 'Valley Windworks (Team Galactic)'),
        gym('sovereign_cheryl_eterna_forest', None, 'Eterna Forest'),
        gym('leader_gardenia', 'leader_gardenia_rematch', 'Eterna City Gym'),
        gym('commander_jupiter_team_galactic_eterna_building', None, 'Galactic Eterna Building'),
        gym('sovereign_mira_wayward_cave', None, 'Wayward Cave'),
        dawn_lucas('route_207'),
        gym('leader_fantina', 'leader_fantina_rematch', 'Hearthome City Gym'),
        by_starter('Route 209 gate', sinnoh_rival('route_209')),
        tag('Pokémon Mansion, with Cedric at your side', ['sovereign_saturn_pokemon_mansion', 'sovereign_backlot_pokemon_mansion'],
            'Saturn & Backlot'),
        gym('leader_maylene', 'leader_maylene_rematch', 'Veilstone City Gym'),
        by_starter('Pastoria City', sinnoh_rival('pastoria_city')),
        gym('leader_wake', 'leader_wake_rematch', 'Pastoria City Gym'),
        dawn_lucas('route_210'),
        gym('galactic_boss_cyrus_celestic_town_ruins', None, 'Celestic Town ruins'),
        gym('sovereign_darach_pal_park', None, 'Pal Park'),
        by_starter('Canalave City', sinnoh_rival('canalave_city')),
        gym('sovereign_riley_iron_island', None, 'Iron Island'),
        gym('leader_byron', 'leader_byron_rematch', 'Canalave City Gym'),
        gym('commander_mars_lake_verity', None, 'Lake Verity'),
        gym('commander_saturn_valor_cavern', None, 'Valor Cavern'),
        gym('leader_candice', 'leader_candice_rematch', 'Snowpoint City Gym'),
        gym('commander_saturn_galactic_hq', None, 'Galactic HQ'),
        gym('galactic_boss_cyrus_galactic_hq', None, 'Galactic HQ'),
        tag('Spear Pillar, with Cedric at your side', ['commander_mars_spear_pillar', 'commander_jupiter_spear_pillar'], 'Mars & Jupiter'),
        gym('galactic_boss_cyrus_distortion_world', None, 'Distortion World',
            [('Dialga & Palkia', 'sovereign_cyrus_distortion_world_legends')]),
        gym('leader_volkner', 'leader_volkner_rematch', 'Sunyshore City Gym'),
        gym('sovereign_dahlia_sunyshore', None, 'Sunyshore City'),
        gym('sovereign_marley_victory_road', None, 'Victory Road'),
        dawn_lucas('route_224'),
        by_starter('Pokémon League', sinnoh_rival('pokemon_league')),
        league_s('aaron'), league_s('bertha'), league_s('flint'), league_s('lucian'),
        gym('champion_cynthia', 'champion_cynthia_rematch', 'Champion'),
    ]),
    ('postgame', 'Sinnoh after the League', 'sinnoh', [
        by_starter('Fight Area', sinnoh_rival('fight_area')),
        tag('Fight Area, with Cedric at your side', ['leader_volkner_fight_area', 'elite_four_flint_fight_area'], 'Volkner & Flint'),
        tag('Stark Mountain, one after the other', ['commander_mars_stark_mountain', 'commander_jupiter_stark_mountain'],
            'Mars & Jupiter'),
        gym('sovereign_buck_route_227', None, 'Route 227'),
        by_starter('Survival Area', sinnoh_rival('survival_area_1')),
        by_starter('Survival Area, again', sinnoh_rival('survival_area_2')),
        gym('sovereign_steven_oreburgh', None, 'Oreburgh City'),
    ]),
    ('battleground', 'The Battleground', 'sinnoh', [
        gym('sovereign_cyrus_battleground', None, 'Battleground'),
        tag('Battleground', ['sovereign_mars_battleground', 'sovereign_jupiter_battleground', 'sovereign_saturn_battleground'],
            'Mars, Jupiter & Saturn'),
        by_starter('Battleground', [f'sovereign_lucas_battleground_{s}' for s in ('turtwig', 'chimchar', 'piplup')]),
        by_starter('Battleground', [f'sovereign_dawn_battleground_{s}' for s in ('turtwig', 'chimchar', 'piplup')]),
        tag('Battleground', ['cheryl_battleground', 'mira_battleground', 'riley_battleground', 'buck_battleground',
                             'marley_battleground'], 'Cheryl, Mira, Riley, Buck & Marley'),
    ]),
]


for _sid, _title, _region, _entries in SECTIONS:
    for _e in _entries:
        _stem = _e['tabs'][0][1]
        _e['kind'] = ('e4' if _stem in boss_plan.ELITE_FOUR
                      else 'champion' if _stem in ('hgss_champion_lance', 'champion_cynthia')
                      else 'leader' if 'leader_' in _stem and 'fight_area' not in _stem and not _e.get('name') else 'boss')
# Johto's Whitney: every leader and boss after her has a Mega (the owner's call)
MEGA_FROM = 'hgss_leader_whitney'

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


def build_mon(trainer_file, data, mon, planned=False):
    tid = TRAINER_IDS['TRAINER_' + trainer_file.upper()]
    cls = data['class']
    species, level = mon['species'], mon['level']
    sinnoh = tid < TRAINER_HGSS_FIRST
    if sinnoh and not planned:
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


def mon_card(m, slot, stem=''):
    type_badges = ''.join(f'<span class="ty" style="--t:{TYPE_COLOURS.get(t, "#888")}">{t.title()}</span>' for t in m['types'])
    moves = ''.join(
        f'<li><span class="dot" style="--t:{TYPE_COLOURS.get(t, "#888")}" title="{t.title()} · {c}"></span>{esc(n)}</li>'
        for n, t, c in (move_info(x) for x in m['moves']))
    icon = item_icon(m['item']) if m['item'] else None
    item = (f'<img class="ii" src="{icon}" alt="">' if icon else '') + esc(item_name(m['item'])) if m['item'] else '<span class="none">None</span>'
    old = m.get('now')
    note = (f'<div class="note">now Lv. {old["level"]}{"" if old["species"] == m["species"] else " " + esc(old["name"])}</div>'
            if old else '')
    return f'''<div class="mon" data-slot="{slot}" data-key="{stem}--{slot}" data-name="{esc(m["name"])}">
  <div class="mtop"><img class="ms" src="{m["sprite"]}" alt="{esc(m["name"])}" loading="lazy"><span class="lv">Lv. {m["level"]}</span></div>
  <div class="mname">{esc(m["name"])}{' <span class="shiny" title="Shiny">★</span>' if m['shiny'] else ''}</div>{'<span class="mega">Mega</span>' if m['mega'] else ''}
  <div class="types">{type_badges}</div>{note}
</div>''', f'''<div class="det" data-key="{stem}--{slot}">
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


def raw_ace(stem):
    data = json.load(open(os.path.join(TRAINERS, stem + '.json'), encoding='utf-8'))
    return max(m['level'] for m in data['party'])


_plan = None


def plan():
    global _plan
    if _plan is None:
        _plan = boss_plan.plan_levels(SECTIONS, raw_ace)
    return _plan


def planned_team(key, stem):
    """(trainer data, the planned Pokémon, the Pokémon as the game makes them now) for a tab: key is (section,
    entry, tab)"""
    data = json.load(open(os.path.join(TRAINERS, stem + '.json'), encoding='utf-8'))
    now = [build_mon(stem, data, mon) for mon in data['party']]
    party = data['party']
    if stem == 'champion_cynthia_rematch':  # the owner's call: her first team, as it is
        party = json.load(open(os.path.join(TRAINERS, 'champion_cynthia.json'), encoding='utf-8'))['party']
    sinnoh = TRAINER_IDS['TRAINER_' + stem.upper()] < TRAINER_HGSS_FIRST
    planned = boss_plan.plan_party(
        party, plan().get(key), sinnoh_evolved if sinnoh else (lambda sp, lv: sp),
        lambda sp, form: form_data(sp, form)['base_stats'], lambda mv: move_info(mv)[2], default_moves)
    if plan().get(key) is None:
        mons = now
    else:
        pdata = dict(data, party=planned)
        mons = [build_mon(stem, pdata, mon, planned=True) for mon in planned]
    for i, m in enumerate(mons):
        old = now[i] if i < len(now) and stem != 'champion_cynthia_rematch' else None
        m['now'] = None if old and (old['level'], old['species']) == (m['level'], m['species']) else old
    return data, mons


def team_html(key, stem):
    data, mons = planned_team(key, stem)
    cards, dets = zip(*(mon_card(m, i, stem) for i, m in enumerate(mons)))
    ace = max(m['level'] for m in mons)
    empty = ''.join(f'<div class="mon empty" data-empty="1" data-key="{stem}--{i}" data-level="{min(m["level"] for m in mons)}"></div>'
                    for i in range(len(mons), 6))
    return data, mons, f'''<div class="team" data-stem="{stem}">
  <div class="grid">{''.join(cards)}{empty}</div>
  <div class="dets">{''.join(dets)}</div>
</div>''', ace, data.get('double_battle')


def mega_owners():
    """{character: {Mega species}} over every planned team"""
    out = collections.defaultdict(set)
    for si, (_, _, _, entries) in enumerate(SECTIONS):
        for ei, entry in enumerate(entries):
            for ti, (_, stem) in enumerate(entry['tabs']):
                if os.path.exists(os.path.join(TRAINERS, stem + '.json')):
                    data, mons = planned_team((si, ei, ti), stem)
                    out[character(data)] |= {m['name'] for m in mons if m['mega']}
    return out


def mega_options():
    """[(value, label)] for every Mega form in the game: res/pokemon/<species>/forms/mega*"""
    out = []
    root = os.path.join(RES, 'pokemon')
    for sp in sorted(os.listdir(root)):
        forms = os.path.join(root, sp, 'forms')
        if not os.path.isdir(forms):
            continue
        for f in sorted(os.listdir(forms)):
            if f.startswith('mega'):
                extra = f[5:].replace('_', ' ').title()
                extra = {'Female': '(F)', 'Male': '(M)'}.get(extra, extra)
                out.append((f'{sp}/{f}', ('Mega ' + species_name('SPECIES_' + sp.upper()) + (' ' + extra if extra else '')).strip()))
    return sorted(out, key=lambda o: o[1])


def char_id(name):
    return re.sub(r'[^A-Za-z0-9]+', '-', name).strip('-').lower() or 'unknown'


def character(data):
    return {'Boy': 'Silver'}.get(data['name'], data['name'])


def trainer_card(si, ei, entry, megas, after_whitney):
    tabs, panes, first, chars = [], [], None, []
    for i, (label, stem) in enumerate(entry['tabs']):
        if not os.path.exists(os.path.join(TRAINERS, stem + '.json')):
            continue
        data, mons, team, ace, doubles = team_html((si, ei, i), stem)
        if first is None:
            first = data
        if character(data) not in chars and data['name'] != 'Grunt':
            chars.append(character(data))
        if label is None:
            label = species_name(starter_line(data)) if entry.get('starter_tabs') else data['name']
            if entry.get('named_tabs'):
                label = data['name'] + ': ' + label
        on = ' on' if not tabs else ''
        sprite = trainer_sprite(data['class'])
        tabs.append(f'<button class="tab{on}" data-k="{i}" data-sprite="{sprite}">'
                    f'{esc(label)} <span>Lv. {ace}</span></button>')
        panes.append(f'<div class="pane{on}" data-k="{i}">{team}</div>')
    name = entry.get('name') or character(first)
    note = entry.get('note') or ('One version for each starter: the tab names the rival\u2019s own.' if entry.get('starter_tabs') else '')
    chips = []
    if after_whitney:
        for c in chars:
            mine = sorted(megas.get(c, ()))
            shared = sorted(o for o, ms in megas.items() if o != c and set(mine) & ms)
            if not mine:
                chips.append(f'<span class="chip warn">{esc(c)}: needs a Mega</span>')
            else:
                text = f'{esc(c)}: Mega {esc(" / ".join(mine))}' + (f' \u00b7 also {esc(", ".join(shared))}' if shared else '')
                chips.append(f'<span class="chip{" warn" if shared or len(mine) > 1 else ""}">{text}</span>')
    sprite = tabs[0].split('data-sprite="')[1].split('"')[0]
    options = mega_options()
    pickers = []
    for c in chars:
        current = sorted(megas.get(c, ()))
        default = next((v for v, label in options if current and label.startswith('Mega ' + current[0])), '')
        opts = '<option value="">No Mega</option>'
        pickers.append(f'<label class="mp">{esc(c) + ": " if len(chars) > 1 else ""}<select data-char="{char_id(c)}" '
                       f'data-name="{esc(c)}" data-default="{default}" disabled>{opts}</select><span class="mp-warn"></span></label>')
    picker = f'<div class="megas"><span class="mp-h">Mega</span>{"".join(pickers)}</div>' if pickers else ''
    return f"""<article class="trainer" id="{esc(entry['tabs'][0][1])}">
  <header>
    <img class="tsprite" src="{sprite}" alt="{esc(name)}">
    <div class="th"><h3>{esc(name)}</h3><div class="sub">{esc(entry['where'])}</div>{f'<div class="sub">{esc(note)}</div>' if note else ''}
      {picker}
      <div class="review" data-card="{esc(entry['tabs'][0][1])}"><label><input type="checkbox" data-v="done" disabled> Done</label>
        <label><input type="checkbox" data-v="work" disabled> Needs work</label></div>
      <div class="tabs" role="tablist">{''.join(tabs)}</div></div>
  </header>
  {''.join(panes)}
</article>"""


def starter_line(data):
    """The rival's starter, from its team's last Pokémon (the ace)"""
    return data['party'][-1]['species']


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

.mon.empty{border-style:dashed;cursor:default}.mon.empty:hover{background:none}
.mtop{position:relative}
.ms{width:100%;max-width:120px;aspect-ratio:1;image-rendering:pixelated;display:block;margin:0 auto}
.lv{position:absolute;top:0;right:0;font-size:11.5px;font-weight:700;background:var(--ink);color:var(--panel);border-radius:6px;padding:1px 6px}
.mname{font-weight:650;font-size:13.5px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.types{display:flex;gap:3px;justify-content:center;flex-wrap:wrap;margin-top:2px}
.ty{font-size:10px;font-weight:700;color:#fff;background:var(--t);padding:0 6px;border-radius:4px;text-transform:uppercase;letter-spacing:.03em;text-shadow:0 1px 0 rgba(0,0,0,.25)}
.shiny{color:#e0a800}
.megas{display:flex;flex-wrap:wrap;gap:4px 10px;align-items:center;font-size:12.5px;font-weight:600;margin:0 0 8px}
.mp-h{color:var(--muted);font-weight:700}
.mp{display:flex;gap:4px;align-items:center}
.mp select{font:inherit;font-size:12.5px;padding:2px 4px;border:1px solid var(--line);border-radius:6px;background:var(--panel);color:var(--ink);max-width:190px}
.mp select.clash{border-color:var(--accent);color:var(--accent)}
.mp-warn{color:var(--accent);font-size:11.5px}
.review{display:flex;gap:12px;font-size:12.5px;font-weight:650;margin:0 0 8px}
.review label{display:flex;gap:4px;align-items:center;cursor:pointer}
.review input{width:16px;height:16px;margin:0;accent-color:var(--ink)}
.trainer.is-done{border-color:#2f8f5b;box-shadow:inset 0 0 0 1px #2f8f5b}
.trainer.is-work{border-color:#d9822b;box-shadow:inset 0 0 0 1px #d9822b}
.editbar{background:var(--chip);border-radius:10px;padding:10px 12px;font-size:13px;margin:0 0 12px}
#edit-count{font-weight:650}#edit-status{color:var(--muted)}
.ed{display:flex;gap:4px;justify-content:center;margin-top:6px;flex-wrap:wrap}
.edb{font:inherit;font-size:11.5px;font-weight:600;border:1px solid var(--line);background:var(--panel);color:var(--ink);padding:2px 8px;border-radius:6px;cursor:pointer}
.edb:hover{background:var(--sel)}.edb.rm{color:var(--accent)}.edb.add{border-style:dashed}
.mon.empty{display:flex;align-items:center;justify-content:center;min-height:90px;opacity:1}
.mon.removed .mtop,.mon.removed .mname,.mon.removed .types,.mon.removed .note,.mon.removed .mega{opacity:.25;filter:grayscale(1)}
.gone{font-weight:700;color:var(--accent);font-size:12px}
.mon.replaced{border-color:#2f8f5b;border-style:dashed}
.det.edited>dl,.det.edited>ul,.det.edited>.hint{opacity:.35}
.edit-note{font-weight:600;color:var(--accent);margin-bottom:4px}
dialog#picker{border:1px solid var(--line);border-radius:14px;background:var(--panel);color:var(--ink);width:min(760px,calc(100vw - 24px));height:min(86vh,820px);padding:14px;flex-direction:column;overflow:hidden}
dialog#picker[open]{display:flex}
#pick-n{font-size:12px;color:var(--muted);margin:-4px 0 6px}
dialog#picker::backdrop{background:rgba(0,0,0,.4)}
.pick-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px}
#pick-q{width:100%;font:inherit;padding:8px 10px;border:1px solid var(--line);border-radius:8px;background:var(--bg);color:var(--ink);margin-bottom:10px}
#pick-list{display:grid;grid-template-columns:repeat(auto-fill,minmax(104px,1fr));gap:6px;overflow-y:auto;flex:1;min-height:0;align-content:start;overscroll-behavior:contain}
.pk{font:inherit;font-size:12px;font-weight:600;border:1px solid var(--line);background:var(--bg);color:var(--ink);border-radius:8px;padding:4px 2px 6px;cursor:pointer;display:flex;flex-direction:column;align-items:center;gap:1px;min-width:0}
.pk[hidden]{display:none}.pk span{max-width:100%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.pk:hover{background:var(--sel)}.pk img{width:56px;height:56px;image-rendering:pixelated}.pk small{color:var(--muted);font-weight:500}
.chips{display:flex;gap:4px;flex-wrap:wrap;margin:-2px 0 8px}
.chip{font-size:11.5px;font-weight:600;padding:2px 8px;border-radius:999px;background:var(--chip)}
.chip.warn{background:#f6d7c9;color:#7a2a12}
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
    t.querySelector('.tsprite').src=b.dataset.sprite;
  }));
});
document.querySelectorAll('.team').forEach(team=>{
  const mons=team.querySelectorAll('.mon:not(.empty)'),dets=team.querySelectorAll('.det');
  const pick=i=>{mons.forEach((m,j)=>m.classList.toggle('sel',j===i));dets.forEach((d,j)=>d.classList.toggle('show',j===i));};
  mons.forEach((m,i)=>m.addEventListener('click',e=>{if(!e.target.closest('.ed'))pick(i);}));
  pick(0);
});

// Editing: each removal or replacement is a document in the page's shared store ("edits", one per slot),
// which Claude reads back and puts into the game's data.
const EDITS = {};
let DB = null, WRITABLE = false, SPECIES = null, BY_CONST = {};
const status = document.getElementById('edit-status');
const say = t => { status.textContent = t; };

function loadSpecies() {
  if (SPECIES) return Promise.resolve(SPECIES);
  return new Promise((ok, fail) => {
    const sc = document.createElement('script');
    sc.src = 'species.js';
    sc.onload = () => { SPECIES = window.SPECIES_LIST; SPECIES.forEach(r => BY_CONST[r[0]] = r); ok(SPECIES); };
    sc.onerror = () => fail(new Error('species list'));
    document.head.appendChild(sc);
  });
}

function typeBadges(types) {
  const wrap = document.createElement('div');
  wrap.className = 'types';
  types.forEach(t => { const b = document.createElement('span'); b.className = 'ty'; b.textContent = t[0] + t.slice(1).toLowerCase();
    b.style.setProperty('--t', TYPES[t] || '#888'); wrap.appendChild(b); });
  return wrap;
}

function button(label, cls, fn) {
  const b = document.createElement('button');
  b.type = 'button'; b.className = 'edb ' + cls; b.textContent = label;
  b.addEventListener('click', e => { e.stopPropagation(); fn(); });
  return b;
}

function render() {
  document.querySelectorAll('.mon[data-key]').forEach(el => {
    if (!('orig' in el.dataset)) el.dataset.orig = el.innerHTML;
    const edit = EDITS[el.dataset.key];
    el.innerHTML = el.dataset.orig;
    const replaced = !!edit && edit.action === 'replace';
    el.classList.toggle('removed', !!edit && edit.action === 'remove');
    el.classList.toggle('replaced', replaced);
    el.classList.toggle('empty', el.dataset.empty === '1' && !replaced);
    if (replaced) {
      // the same card as any other Pokemon's, with the new species
      const r = BY_CONST[edit.species];
      el.innerHTML = '<div class="mtop"><img class="ms" alt=""><span class="lv"></span></div><div class="mname"></div>';
      if (r) el.querySelector('.ms').src = r[4];
      el.querySelector('.lv').textContent = 'Lv. ' + (edit.level || '');
      el.querySelector('.mname').textContent = edit.name;
      if (r) el.appendChild(typeBadges(r[2]));
      const n = document.createElement('div'); n.className = 'note';
      n.textContent = el.dataset.name ? 'replaces ' + el.dataset.name : 'added';
      el.appendChild(n);
    }
    if (edit && edit.action === 'remove') {
      const n = document.createElement('div'); n.className = 'gone'; n.textContent = 'Removed';
      el.appendChild(n);
    }
    if (WRITABLE) {
      const bar = document.createElement('div'); bar.className = 'ed';
      if (edit) bar.appendChild(button('Undo', '', () => undo(el.dataset.key)));
      else if (el.classList.contains('empty')) bar.appendChild(button('+ Add', 'add', () => choose(el)));
      else { bar.appendChild(button('Replace', '', () => choose(el))); bar.appendChild(button('Remove', 'rm', () => remove(el))); }
      el.appendChild(bar);
    }
  });
  document.querySelectorAll('.det[data-key]').forEach(d => {
    const edit = EDITS[d.dataset.key];
    d.classList.toggle('edited', !!edit);
    d.querySelector('.edit-note')?.remove();
    if (edit) {
      const n = document.createElement('div'); n.className = 'edit-note';
      n.textContent = edit.action === 'remove' ? 'Removed from the team.' : edit.name + ' goes here: its set is built when the edit goes into the game.';
      d.prepend(n);
    }
  });
  const count = Object.keys(EDITS).length;
  document.getElementById('edit-count').textContent = count ? count + (count === 1 ? ' edit saved' : ' edits saved') : 'No edits yet';
}

function slotInfo(el) {
  const [stem, slot] = el.dataset.key.split('--');
  const team = el.closest('.team');
  const lv = el.querySelector('.lv');
  const level = lv ? parseInt(lv.textContent.replace(/\\D/g, ''), 10) : parseInt(el.dataset.level, 10);
  const trainer = el.closest('.trainer').querySelector('h3').textContent;
  const battle = el.closest('.trainer').querySelector('.tab[data-k="' + team.closest('.pane').dataset.k + '"]').firstChild.textContent.trim();
  return { stem, slot: parseInt(slot, 10), level, trainer, battle };
}

async function write(key, body) {
  try {
    if (body) await DB.collection('edits').doc(key).set(body); else await DB.collection('edits').doc(key).delete();
    say('Saved.');
  } catch (e) {
    if (e && (e.code === 'invalid_argument' || e.code === 'not_granted' || e.code === 'revoked')) {
      WRITABLE = false; say('This view can\\u2019t save edits (view-only access).'); render();
    } else say('Couldn\\u2019t save that edit: ' + (e && e.message || e) + '. Try again.');
  }
}

function remove(el) {
  const info = slotInfo(el);
  const body = Object.assign(info, { action: 'remove', was: el.dataset.name, at: new Date().toISOString() });
  EDITS[el.dataset.key] = body; render(); write(el.dataset.key, body);
}

function undo(key) { delete EDITS[key]; render(); write(key, null); }

const dlg = document.getElementById('picker'), q = document.getElementById('pick-q'), list = document.getElementById('pick-list');
let target = null;
async function choose(el) {
  target = el;
  document.getElementById('pick-title').textContent = el.dataset.name ? 'Replace ' + el.dataset.name : 'Add a Pok\\u00e9mon';
  q.value = ''; if (!built) list.textContent = 'Loading…';
  dlg.showModal(); list.scrollTop = 0;
  try { await loadSpecies(); fill(); } catch (e) { list.textContent = 'The species list didn\\u2019t load.'; }
}
let built = false;
function fill() {
  if (!built) {
    list.textContent = '';
    SPECIES.forEach(r => {
      const b = document.createElement('button'); b.type = 'button'; b.className = 'pk';
      const img = document.createElement('img'); img.src = r[4]; img.alt = ''; img.loading = 'lazy';
      const n = document.createElement('span'); n.textContent = r[1];
      const no = document.createElement('small'); no.textContent = '#' + r[3];
      b.append(img, n, no, typeBadges(r[2]));
      b.dataset.find = (r[1] + ' ' + r[3] + ' ' + r[2].join(' ')).toLowerCase();
      b.addEventListener('click', () => pickSpecies(r));
      list.appendChild(b);
    });
    built = true;
  }
  const term = q.value.trim().toLowerCase();
  let shown = 0;
  list.querySelectorAll('.pk').forEach(b => {
    const hit = !term || b.dataset.find.includes(term);
    b.hidden = !hit; if (hit) shown++;
  });
  document.getElementById('pick-n').textContent = term ? shown + ' match' + (shown === 1 ? '' : 'es')
    : SPECIES.length + ' Pokémon, in Pokédex order';
}
q.addEventListener('input', fill);
document.getElementById('pick-close').addEventListener('click', () => dlg.close());
function pickSpecies(r) {
  dlg.close();
  const el = target, key = el.dataset.key, info = slotInfo(el);
  const body = Object.assign(info, { action: 'replace', species: r[0], name: r[1], was: el.dataset.name || null,
    at: new Date().toISOString() });
  EDITS[key] = body; render(); write(key, body);
}

// Review ticks: one document per card in "review", {state: "done" | "work"}
const REVIEW = {};
function renderReview() {
  document.querySelectorAll('.review').forEach(r => {
    const st = REVIEW[r.dataset.card] && REVIEW[r.dataset.card].state;
    r.querySelectorAll('input').forEach(i => { i.checked = st === i.dataset.v; i.disabled = !WRITABLE; });
    const card = r.closest('.trainer');
    card.classList.toggle('is-done', st === 'done');
    card.classList.toggle('is-work', st === 'work');
  });
  const all = document.querySelectorAll('.review').length;
  const done = Object.values(REVIEW).filter(v => v.state === 'done').length;
  const work = Object.values(REVIEW).filter(v => v.state === 'work').length;
  document.getElementById('review-count').textContent = done + ' of ' + all + ' done, ' + work + ' need work';
}
document.querySelectorAll('.review input').forEach(i => i.addEventListener('change', async () => {
  const card = i.closest('.review').dataset.card;
  const state = i.checked ? i.dataset.v : null;
  if (state) REVIEW[card] = { state, trainer: i.closest('.trainer').querySelector('h3').textContent, at: new Date().toISOString() };
  else delete REVIEW[card];
  renderReview();
  try {
    if (state) await DB.collection('review').doc(card).set(REVIEW[card]); else await DB.collection('review').doc(card).delete();
    say('Saved.');
  } catch (e) { say('Couldn\u2019t save that tick: ' + (e && e.message || e) + '.'); }
}));

// Megas: one document per character in "megas", {mega: "<species>/<form>" or ""}; without one, the card shows
// the Mega the character holds now
const MEGAS = {};
document.querySelectorAll('.mp select').forEach(sel => MEGA_OPTIONS.forEach(([v, label]) => {
  const o = document.createElement('option'); o.value = v; o.textContent = label; sel.appendChild(o);
}));
function chosen(sel) { const m = MEGAS[sel.dataset.char]; return m ? m.mega : sel.dataset.default; }
function renderMegas() {
  const sels = [...document.querySelectorAll('.mp select')];
  const owners = {};
  sels.forEach(sel => { const v = chosen(sel); if (v) (owners[v] = owners[v] || new Set()).add(sel.dataset.name); });
  sels.forEach(sel => {
    const v = chosen(sel);
    sel.value = v; sel.disabled = !WRITABLE;
    const others = v ? [...owners[v]].filter(n => n !== sel.dataset.name) : [];
    sel.classList.toggle('clash', others.length > 0);
    sel.parentElement.querySelector('.mp-warn').textContent = others.length ? 'also ' + others.join(', ') : '';
  });
}
document.querySelectorAll('.mp select').forEach(sel => sel.addEventListener('change', async () => {
  const id = sel.dataset.char;
  MEGAS[id] = { mega: sel.value, character: sel.dataset.name, at: new Date().toISOString() };
  renderMegas();
  try { await DB.collection('megas').doc(id).set(MEGAS[id]); say('Saved.'); }
  catch (e) { say('Couldn\u2019t save that Mega: ' + (e && e.message || e) + '.'); }
}));

render();
renderReview();
renderMegas();
(async () => {
  const timer = setTimeout(() => say('Saved edits can\\u2019t be reached yet.'), 10000);
  const db = await claude.use('db');
  if (!db) { clearTimeout(timer); say('Editing works on the page in claude.ai, signed in.'); return; }
  DB = db; WRITABLE = true; renderReview(); renderMegas();
  db.collection('megas').onSnapshot(snap => {
    for (const k of Object.keys(MEGAS)) delete MEGAS[k];
    snap.docs.forEach(d => { MEGAS[d.id] = d.data(); });
    renderMegas();
  }, () => {});
  db.collection('review').onSnapshot(snap => {
    for (const k of Object.keys(REVIEW)) delete REVIEW[k];
    snap.docs.forEach(d => { REVIEW[d.id] = d.data(); });
    renderReview();
  }, () => {});
  db.collection('edits').onSnapshot(snap => {
    if (!snap.metadata.fromCache) { clearTimeout(timer); say(''); }
    for (const k of Object.keys(EDITS)) delete EDITS[k];
    snap.docs.forEach(d => { EDITS[d.id] = d.data(); });
    const need = Object.values(EDITS).some(e => e.action === 'replace');
    (need ? loadSpecies().catch(() => null) : Promise.resolve()).then(render);
  }, e => { clearTimeout(timer); say('Saved edits stopped updating (' + e.code + '). Reload to see the latest.'); });
})();
'''


def write_species_list(path):
    """Every species for the page's picker, with its name, types and sprite: species.js beside the page"""
    rows = []
    for const, number in sorted(SPECIES.items(), key=lambda kv: kv[1]):
        front = next((os.path.join(species_dir(const), f) for f in ('male_front.png', 'female_front.png')
                      if os.path.exists(os.path.join(species_dir(const), f))), None)  # female-only species: female_front
        if number == 0 or not front:
            continue
        try:
            sd = species_data(const)
            sprite = png_uri(transparent0(Image.open(front)))
        except (OSError, KeyError, ValueError):
            continue
        rows.append([const, species_name(const), [t[len('TYPE_'):] for t in dict.fromkeys(sd['types'])], number, sprite])
    open(path, 'w', encoding='utf-8').write('window.SPECIES_LIST=' + json.dumps(rows, separators=(',', ':')) + ';')
    return len(rows)


def dedupe_images(page):
    """Each picture once, in a table the page's script fills the images from (the same sprites repeat a lot)"""
    ids = {}

    def key(uri):
        return ids.setdefault(uri, len(ids))

    page = re.sub(r'src="(data:image/png;base64,[^"]+)"', lambda m: f'data-img="{key(m.group(1))}"', page)
    page = re.sub(r'data-sprite="(data:image/png;base64,[^"]+)"', lambda m: f'data-sprite="{key(m.group(1))}"', page)
    table = json.dumps(list(ids))
    script = ('<script>const IMG=' + table + ';document.querySelectorAll("[data-img]").forEach(e=>e.src=IMG[e.dataset.img]);'
              'document.querySelectorAll("[data-sprite]").forEach(e=>e.dataset.sprite=IMG[e.dataset.sprite]);</script>')
    return page.replace('<script>', script + '<script>', 1)


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache', 'gym_teams', 'index.html')
    body = []
    megas = mega_owners()
    after = False
    for si, (sid, title, _, rows) in enumerate(SECTIONS):
        body.append(f'<section id="{sid}"><h2>{esc(title)}</h2><div class="trainers">')
        for ei, entry in enumerate(rows):
            body.append(trainer_card(si, ei, entry, megas, after))
            after = after or entry['tabs'][0][1] == MEGA_FROM
        body.append('</div></section>')
    nav = ''.join(f'<a href="#{sid}">{esc(title)}</a>' for sid, title, _, _ in SECTIONS)
    page = f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="claude:viewport-fit-sides" content="cover">
<title>Sovereign Complete Boss Teams</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;650;700&display=swap" rel="stylesheet">
<style>{CSS}</style></head>
<body><div class="wrap">
<h1>Boss battles: the plan</h1>
<p class="lede">Every Gym Leader, rival, villain, Elite Four and Champion in the order a player meets them, with the owner's
new rules applied (not in the game yet): Cynthia at Lv. 95 and her first team again at 100 in the rematch; no boss more than
two levels under the level cap of the moment; Gym Leaders' teams within 2 levels of the ace in Johto, 1 in Kanto, all at
the ace's level in Sinnoh; optimal EVs, IVs and natures everywhere. A Pokémon's grey note says what it is in the game
now. Each character has a Mega picker (red when two characters share one), and each card a Done / Needs work tick. Tap a Pokémon to see its set.</p>
<div class="editbar"><strong>Editing</strong> \u00b7 Replace or remove any Pok\u00e9mon, or add one to an empty slot.
Your edits are saved here for Claude to put into the game; a new Pok\u00e9mon's set (moves, item, EVs) is built then.
<span id="edit-count"></span> \u00b7 <span id="review-count"></span> <span id="edit-status"></span></div>
<nav>{nav}</nav>
{''.join(body)}
<footer>Built from the repository by <code>tools/complete/gym_teams_page.py</code>, with the plan in
<code>tools/complete/boss_plan.py</code>. EVs: an attacker maxes its attacking stat and Speed (HP if it's slow or on a
Trick Room team); a Pokémon with one attack or none maxes HP and its weaker defence. IVs are 31, with 0 Attack on a
Pokémon with no physical move and 0 Speed on Trick Room's slow ones; a Pokémon with Hidden Power keeps 31s
until its type is chosen. Moves marked “Level-up moves” are the last four it learns by its level.</footer>
</div>
<dialog id="picker"><div class="pick-head"><strong id="pick-title">Replace</strong>
<button type="button" id="pick-close" class="edb">Close</button></div>
<input id="pick-q" type="search" placeholder="Name, Pok\u00e9dex number or type" autocomplete="off">
<div id="pick-n"></div><div id="pick-list"></div></dialog>
<script>const TYPES={json.dumps(TYPE_COLOURS)};const MEGA_OPTIONS={json.dumps(mega_options())};</script><script>{JS}</script></body></html>'''
    page = dedupe_images(page)
    os.makedirs(os.path.dirname(out), exist_ok=True)
    print(write_species_list(os.path.join(os.path.dirname(out), 'species.js')), 'species')
    open(out, 'w', encoding='utf-8').write(page)
    print(out, f'{len(page) / 1e6:.2f} MB')


if __name__ == '__main__':
    main()
