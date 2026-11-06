#!/usr/bin/env python3
"""The Pledges (the owner's call, Nov 6, 2026: "a tutor teaches them to the starters (with the combinations)"): the
data the combinations need in Sovereign's JSON, which can't hold a comment, so this script is the record of its edits
(rerun it if a sync clashes on them):
- res/moves/{fire,water,grass}_pledge/data.json: BATTLE_EFFECT_COMPLETE_PLEDGE (effect_script_0402.s);
- res/text/battle_strings.json: the waiting, combined, field and field's end lines (CompletePledge*, CompleteSeaOfFire*,
  CompleteRainbow*, CompleteSwamp*, CompleteHurtBySeaOfFire*), in the variants the battle's message tags pick from:
  _Ally, _Wild and _Foe for a nickname, the seven pairs for two (as Ally Switch's), your team and the enemy team's.
- res/field/scripts/scripts_common.s: the tutor's starters (between its markers), which CommonScript_CompletePledgeTutor
  (0x829, Elm's lab's tutor: tools/complete/import_hgss_events.py's OWN_OBJECTS) checks: every starter of Gen I to IX,
  at every stage, learns its own type's Pledge (as Sword and Shield's tutor taught them);
- res/text/common_strings.json: the tutor's lines (CommonStrings_Text_CompletePledgeTutor*).
The battle side is src/battle/complete_pledges.c.

Usage: python3 tools/complete/pledges.py
"""
import json
import os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
PLEDGES = ('fire_pledge', 'water_pledge', 'grass_pledge')
EFFECT = 'BATTLE_EFFECT_COMPLETE_PLEDGE'
WHO = {'Ally': '{STRVAR_1 1, %d, 0}', 'Wild': 'the wild {STRVAR_1 1, %d, 0}', 'Foe': 'the foe’s {STRVAR_1 1, %d, 0}'}
PAIRS = ['AllyAlly', 'AllyWild', 'AllyFoe', 'WildAlly', 'WildWild', 'FoeAlly', 'FoeFoe']


STARTERS = {
    'MOVE_GRASS_PLEDGE': 'BULBASAUR IVYSAUR VENUSAUR CHIKORITA BAYLEEF MEGANIUM TREECKO GROVYLE SCEPTILE TURTWIG GROTLE '
                         'TORTERRA SNIVY SERVINE SERPERIOR CHESPIN QUILLADIN CHESNAUGHT ROWLET DARTRIX DECIDUEYE GROOKEY '
                         'THWACKEY RILLABOOM SPRIGATITO FLORAGATO MEOWSCARADA',
    'MOVE_FIRE_PLEDGE': 'CHARMANDER CHARMELEON CHARIZARD CYNDAQUIL QUILAVA TYPHLOSION TORCHIC COMBUSKEN BLAZIKEN '
                        'CHIMCHAR MONFERNO INFERNAPE TEPIG PIGNITE EMBOAR FENNEKIN BRAIXEN DELPHOX LITTEN TORRACAT '
                        'INCINEROAR SCORBUNNY RABOOT CINDERACE FUECOCO CROCALOR SKELEDIRGE',
    'MOVE_WATER_PLEDGE': 'SQUIRTLE WARTORTLE BLASTOISE TOTODILE CROCONAW FERALIGATR MUDKIP MARSHTOMP SWAMPERT PIPLUP '
                         'PRINPLUP EMPOLEON OSHAWOTT DEWOTT SAMUROTT FROAKIE FROGADIER GRENINJA POPPLIO BRIONNE PRIMARINA '
                         'SOBBLE DRIZZILE INTELEON QUAXLY QUAXWELL QUAQUAVAL',
}
MARK = '@ Sovereign Complete: the Pledge tutor\'s starters (tools/complete/pledges.py)'
MARK_END = '@ Sovereign Complete: end of the Pledge tutor\'s starters'
TUTOR_LINES = [
    ('CompletePledgeTutorIntro', ['I teach the Pledges, moves only\n', 'starter Pokémon can learn!\r',
                                  'Grass Pledge to Grass starters,\n', 'Fire Pledge to Fire starters and\f',
                                  'Water Pledge to Water starters.\r',
                                  'In a double battle, two different\n', 'Pledges used together make one\f',
                                  'powerful combined move!\r', 'Shall I teach one of yours?']),
    ('CompletePledgeTutorWhich', ['Which Pokémon should learn it?']),
    ('CompletePledgeTutorAsk', ['Shall I teach {STRVAR_1 6, 1, 0}\n', 'to {STRVAR_1 0, 0, 0}?']),
    ('CompletePledgeTutorCant', ['Only a starter Pokémon can learn\n', 'a Pledge, I’m afraid.']),
    ('CompletePledgeTutorKnows', ['{STRVAR_1 0, 0, 0} knows\n', '{STRVAR_1 6, 1, 0} already!']),
    ('CompletePledgeTutorDone', ['Try it with an ally’s Pledge in a\n', 'double battle: a sea of fire, a\f',
                                 'rainbow or a swamp, by the pair!']),
    ('CompletePledgeTutorBye', ['Come back any time!']),
]


def starter_block():
    lines = [MARK, 'CommonScript_CompletePledgeTutorStarter:']
    for move, species in STARTERS.items():
        lines.append(f'    SetVar VAR_0x8003, {move}')
        lines += [f'    GoToIfEq VAR_0x8001, SPECIES_{s}, CommonScript_CompletePledgeTutorStarterEnd' for s in species.split()]
    lines += ['    SetVar VAR_0x8003, 0', 'CommonScript_CompletePledgeTutorStarterEnd:', '    Return', MARK_END]
    return '\n'.join(lines) + '\n'


def cap(text):
    return text[0].upper() + text[1:]


def strings():
    out = []
    for pair in PAIRS:
        first = 'Ally' if pair.startswith('Ally') else 'Wild' if pair.startswith('Wild') else 'Foe'
        second = pair[len(first):]
        out.append((f'CompletePledgeWaiting_{pair}',
                    [cap(WHO[first] % 0) + ' is waiting\n', 'for ' + WHO[second] % 1 + '’s move...']))
    out.append(('CompletePledgeCombined', ['The two moves have become one!\n', 'It’s a combined move!']))
    for name, start, end in (('SeaOfFire', 'A sea of fire enveloped', 'The sea of fire around'),
                             ('Swamp', 'A swamp enveloped', 'The swamp around')):
        out.append((f'Complete{name}YourTeam', [start + '\n', 'your team!']))
        out.append((f'Complete{name}EnemyTeam', [start + '\n', 'the enemy team!']))
        out.append((f'Complete{name}EndYourTeam', [end + '\n', 'your team disappeared!']))
        out.append((f'Complete{name}EndEnemyTeam', [end + '\n', 'the enemy team disappeared!']))
    out.append(('CompleteRainbowYourTeam', ['A rainbow appeared in the sky\n', 'on your team’s side!']))
    out.append(('CompleteRainbowEnemyTeam', ['A rainbow appeared in the sky\n', 'on the enemy team’s side!']))
    out.append(('CompleteRainbowEndYourTeam', ['The rainbow on your team’s\n', 'side disappeared!']))
    out.append(('CompleteRainbowEndEnemyTeam', ['The rainbow on the enemy team’s\n', 'side disappeared!']))
    for who in ('Ally', 'Wild', 'Foe'):
        out.append((f'CompleteHurtBySeaOfFire_{who}', [cap(WHO[who] % 0) + ' is hurt\n', 'by the sea of fire!']))
    return [('BattleStrings_Text_' + key, text) for key, text in out]


def main():
    for move in PLEDGES:
        path = os.path.join(DECOMP, 'res', 'moves', move, 'data.json')
        data = json.load(open(path, encoding='utf-8'))
        data['effect']['type'] = EFFECT
        with open(path, 'w', encoding='utf-8') as out:
            json.dump(data, out, indent=4, ensure_ascii=False)
            out.write('\n')

    path = os.path.join(DECOMP, 'res', 'text', 'battle_strings.json')
    raw = open(path, encoding='utf-8').read()
    indent = len(raw.split('\n')[1]) - len(raw.split('\n')[1].lstrip())
    text = json.loads(raw)
    new = strings()
    keys = {key for key, _ in new}
    text['messages'] = [m for m in text['messages'] if m['id'] not in keys] + \
                       [{'id': key, 'en_US': lines} for key, lines in new]
    with open(path, 'w', encoding='utf-8') as out:
        json.dump(text, out, indent=indent, ensure_ascii=False)
        out.write('\n')
    path = os.path.join(DECOMP, 'res', 'field', 'scripts', 'scripts_common.s')
    script = open(path, encoding='utf-8').read()
    start, end = script.index(MARK), script.index(MARK_END) + len(MARK_END) + 1
    with open(path, 'w', encoding='utf-8') as out:
        out.write(script[:start] + starter_block() + script[end:])

    path = os.path.join(DECOMP, 'res', 'text', 'common_strings.json')
    raw = open(path, encoding='utf-8').read()
    indent = len(raw.split('\n')[1]) - len(raw.split('\n')[1].lstrip())
    text = json.loads(raw)
    keys = {'CommonStrings_Text_' + key for key, _ in TUTOR_LINES}
    text['messages'] = [m for m in text['messages'] if m['id'] not in keys] + \
                       [{'id': 'CommonStrings_Text_' + key, 'en_US': lines} for key, lines in TUTOR_LINES]
    with open(path, 'w', encoding='utf-8') as out:
        json.dump(text, out, indent=indent, ensure_ascii=False)
        out.write('\n')
    print(f'{len(PLEDGES)} moves, {len(new)} battle lines, {sum(len(v.split()) for v in STARTERS.values())} starters')


if __name__ == '__main__':
    main()
