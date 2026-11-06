#!/usr/bin/env python3
"""The owner's redo of the boss battles (Nov 6, 2026), as a plan the gym teams page shows before it goes into the
trainer data: each boss team's levels by the owner's rules, Cynthia's rematch, and optimal EVs, IVs and natures.

The owner's rules:
- Cynthia's first battle at Lv. 95, with room to level up after the League (her rematch at 100). Sinnoh's curve runs
  from Roark (72, after Blue's 70) to her.
- The Gym Leaders and Champions set the level caps; no boss is ever more than two levels below the cap of the moment
  (the next Gym Leader's or Champion's ace).
- A Gym Leader's team: in Johto, nothing more than 2 levels under the ace; in Kanto, 1; in Sinnoh, all at the ace's
  level. A Gym's other trainers are at the level of its leader's lowest Pokémon.
- Cynthia always battles alone; the Elite Four have a singles and a doubles team each (the owner, Nov 6). Her rematch team is her first team.
- Bosses and Gym Leaders: optimal EVs. Grunts and Gym trainers: 20% less in every stat, other trainers 40% less (both
  rounded up to the next 4). Every team: optimal IVs.

Open (for the owner): the Megas (one per character after Whitney), the teams themselves, when Johto's and Kanto's
rematches open (planned here at the Sinnoh post-game's levels), and the first battles in each region (the rival's lone
Lv. 5 starter in Cherrygrove is left as it is).
"""
import math

# Sinnoh's levels: Sovereign's level -> the level here, straight between the points (Roark 16 -> 72, Cynthia 78 -> 95,
# her rematch 89 -> 100)
SINNOH_LEVELS = [[1, 66], [16, 72], [78, 95], [89, 100], [100, 100]]
# The most a Gym Leader's other Pokémon are under the ace, by region
SPREAD = {'johto': 2, 'kanto': 1, 'sinnoh': 0}
# The League's Elite Four, in order, under their Champion (Lance 60, Cynthia 95)
ELITE_FOUR = {'hgss_elite_four_will_will': 58, 'hgss_elite_four_koga_koga': 58, 'hgss_elite_four_bruno_bruno': 59,
              'hgss_elite_four_karen_karen': 59, 'elite_four_aaron': 93, 'elite_four_bertha': 93,
              'elite_four_flint': 94, 'elite_four_lucian': 94}
# Rematches, after Sinnoh's League: the Gym Leaders, the Elite Fours, the Champions
REMATCH = {'leader': 98, 'e4': 99, 'champion': 100}
# Battles after a League, the aces' levels (the next cap is a rematch, so these step up to it)
POSTGAME = {
    'hgss_pkmn_trainer_red_red': 100, 'hgss_rival_silver_19': 99, 'hgss_rival_silver_20': 99,
    'hgss_rival_silver_21': 99, 'hgss_champion_lance_3': 100, 'hgss_leader_clair_clair_3': 100,
    'hgss_rocket_boss_giovanni': 98, 'hgss_youngster_mickey': 100,
    'rival_fight_area': 96, 'leader_volkner_fight_area': 96, 'elite_four_flint_fight_area': 96,
    'commander_mars_stark_mountain': 97, 'commander_jupiter_stark_mountain': 97, 'sovereign_buck_route_227': 97,
    'rival_survival_area_1': 98, 'rival_survival_area_2': 98, 'sovereign_steven_oreburgh': 100,
    'battleground': 100}
# Left as they are: the very first battle (the player has one Lv. 5 Pokémon)
UNCHANGED = {'hgss_passerby_boy', 'hgss_passerby_boy_2', 'hgss_passerby_boy_3'}

NATURES = {  # (raised, lowered)
    'HARDY': None, 'LONELY': ('atk', 'def'), 'BRAVE': ('atk', 'spe'), 'ADAMANT': ('atk', 'spa'),
    'NAUGHTY': ('atk', 'spd'), 'BOLD': ('def', 'atk'), 'RELAXED': ('def', 'spe'), 'IMPISH': ('def', 'spa'),
    'LAX': ('def', 'spd'), 'TIMID': ('spe', 'atk'), 'HASTY': ('spe', 'def'), 'JOLLY': ('spe', 'spa'),
    'NAIVE': ('spe', 'spd'), 'MODEST': ('spa', 'atk'), 'MILD': ('spa', 'def'), 'QUIET': ('spa', 'spe'),
    'RASH': ('spa', 'spd'), 'CALM': ('spd', 'atk'), 'GENTLE': ('spd', 'def'), 'SASSY': ('spd', 'spe'),
    'CAREFUL': ('spd', 'spa')}
BASE_KEYS = {'hp': 'hp', 'atk': 'attack', 'def': 'defense', 'spa': 'special_attack', 'spd': 'special_defense',
             'spe': 'speed'}


def sinnoh_curve(level):
    for (a, b), (c, e) in zip(SINNOH_LEVELS, SINNOH_LEVELS[1:]):
        if a <= level <= c:
            return round(b + (level - a) * (e - b) / (c - a))
    return min(level, 100)


def nature_for(up, down):
    for name, pair in NATURES.items():
        if pair == (up, down):
            return 'NATURE_' + name
    raise KeyError((up, down))


def cut(evs, share):
    """EVs with `share` of each stat's investment taken off, rounded up to the next 4"""
    return {k: (int(math.ceil(v * (1 - share) / 4)) * 4 if v else 0) for k, v in evs.items()}


def optimal_set(base, moves, move_class, trick_room=False):
    """(EVs, IVs, nature) for a Pokémon from its base stats and moves: an attacker maxes its attacking stat and its
    Speed (its HP when it's slow or on a Trick Room team), a Pokémon with at most one attack maxes its HP and its
    weaker defence. Natures raise what's maxed and lower what isn't used."""
    b = {k: base[v] for k, v in BASE_KEYS.items()}
    classes = [move_class(m) for m in moves]
    phys, spec = classes.count('Physical'), classes.count('Special')
    names = set(moves)
    evs = dict.fromkeys(BASE_KEYS, 0)
    ivs = dict.fromkeys(BASE_KEYS, 31)
    slow = trick_room and b['spe'] <= 70 or 'MOVE_GYRO_BALL' in names or 'MOVE_TRICK_ROOM' in names
    if phys + spec <= 1:
        weak = 'def' if b['def'] <= b['spd'] else 'spd'
        other = 'spd' if weak == 'def' else 'def'
        evs.update({'hp': 252, weak: 252, other: 4})
        nature = nature_for(weak, 'atk' if not phys else 'spa')
    else:
        attack = 'atk' if (phys, b['atk']) > (spec, b['spa']) else 'spa'
        unused = 'spa' if attack == 'atk' else 'atk'
        mixed = min(phys, spec) >= 2
        if slow:
            evs.update({'hp': 252, attack: 252, 'def' if b['def'] <= b['spd'] else 'spd': 4})
            nature = nature_for(attack, 'spe')
        elif b['spe'] < 50:
            evs.update({'hp': 252, attack: 252, 'def' if b['def'] <= b['spd'] else 'spd': 4})
            nature = nature_for(attack, 'spd' if mixed else unused)
        else:
            evs.update({attack: 252, 'spe': 252, 'hp': 4})
            fast = 80 <= b['spe'] <= 115
            nature = nature_for('spe' if fast else attack, 'spd' if mixed else unused)
        if mixed:
            evs[attack], evs[unused] = 128, 124
    if not phys and 'MOVE_FOUL_PLAY' not in names:
        ivs['atk'] = 0
    if slow:
        ivs['spe'] = 0
    if 'MOVE_HIDDEN_POWER' in names:
        ivs = dict.fromkeys(BASE_KEYS, 31)  # its type comes from the IVs: kept at 31s (Dark) until it's chosen
    return evs, ivs, nature


def stem_key(stem):
    """The plan's key for a trainer file: its rival versions share one (rival_fight_area_piplup -> rival_fight_area)"""
    for suffix in ('_turtwig', '_chimchar', '_piplup'):
        if stem.endswith(suffix):
            stem = stem[:-len(suffix)]
    if stem.endswith('_battleground'):
        return 'battleground'
    return stem


def plan_levels(sections, ace_of):
    """{(entry index, tab index): (target ace, floor, spread)} over the story's battles. ace_of(stem) is the team's ace
    as the game makes it now (Sinnoh's at Sovereign's own level, before the curve)."""
    flat = [(si, ei, entry, region) for si, (_, _, region, entries) in enumerate(sections)
            for ei, entry in enumerate(entries)]

    def first_ace(entry, region):
        stem = entry['tabs'][0][1]
        if entry['kind'] == 'e4':
            return ELITE_FOUR[stem]
        return sinnoh_curve(ace_of(stem)) if region == 'sinnoh' else ace_of(stem)

    out = {}
    for n, (si, ei, entry, region) in enumerate(flat):
        # the cap of the moment: the next Gym Leader's or Champion's ace, this one included
        cap = next((first_ace(e, r) for _, _, e, r in flat[n:] if e['kind'] in ('leader', 'champion')), 100)
        for ti, (label, stem) in enumerate(entry['tabs']):
            spread = SPREAD.get(region, 0)
            key = stem_key(stem)
            if stem in UNCHANGED:
                out[(si, ei, ti)] = None
            elif label and label.startswith('Rematch'):
                spread = SPREAD.get(entry.get('region', region), 0)  # a rematch keeps its region's team rule
                kind = entry.get('rematch_of', entry['kind'])
                out[(si, ei, ti)] = (REMATCH[kind if kind in REMATCH else 'leader'], None, spread)
            elif key in POSTGAME or stem in POSTGAME:
                ace = POSTGAME.get(stem, POSTGAME.get(key))
                out[(si, ei, ti)] = (ace, ace - 2, spread)
            elif entry['kind'] in ('leader', 'champion', 'e4'):
                out[(si, ei, ti)] = (first_ace(entry, region), None, spread)
            else:
                now = sinnoh_curve(ace_of(stem)) if region == 'sinnoh' else ace_of(stem)
                ace = max(cap - 2, min(cap, now))
                out[(si, ei, ti)] = (ace, cap - 2, spread)
    return out


def plan_party(party, target, evolve, base_of, move_class, default_moves):
    """The party with its planned levels (Sinnoh's evolved to match: `evolve(species, level)`), EVs, IVs and natures"""
    if target is None:
        return [dict(m) for m in party]
    ace, floor, spread = target
    old_ace = max(m['level'] for m in party)
    moves_of = []
    out = []
    for m in party:
        m = dict(m)
        level = min(ace, max(ace - spread, m['level'] + ace - old_ace))
        if floor is not None:
            level = max(level, floor)
        m['level'] = level
        m['species'] = evolve(m['species'], level)
        moves_of.append(m.get('moves') or default_moves(m['species'], level))
        out.append(m)
    trick_room = any('MOVE_TRICK_ROOM' in mv for mv in moves_of)
    for m, moves in zip(out, moves_of):
        evs, ivs, nature = optimal_set(base_of(m['species'], m.get('form', 0)), moves, move_class, trick_room)
        m.update(evs=evs, ivs=ivs, nature=nature, iv_scale=255)
    return out
