# Johto and Kanto's music (step 6)

Johto and Kanto play HeartGold's own songs: every song its map headers name, its scripts play (Sacred Gold's), its
field music code picks (surfing, cycling, the trainers' encounter themes), and its battle and victory themes. This is
how they fit into Platinum's sound archive and sound memory, measured from both decomps and both built archives.

## The limits

- **Sound memory** (`SOUND_SYSTEM_HEAP_SIZE`, 769,024 bytes) is the limit, not the archive. Platinum loads its basic
  wave archive (`WAVE_ARC_BASIC`, 163 waves, 458 KB) at boot and keeps it loaded the whole game; a map leaves about
  52 KB free and a battle 10-15 KB. Sovereign's new Pokémon have no cries for this reason.
- **HeartGold's songs need HeartGold's own instruments:** its basic wave set shares only 33 of 158 waves with
  Platinum's. Its songs need up to 160 KB of waves Platinum lacks (the trainer battle theme), most 60-150 KB.
- HeartGold's archive is a prebuilt binary in its decomp (`files/data/sound/gs_sound_data.sdat`), in Platinum's format
  with the same players; the decomp's `nitrosfx` unpacks it. Sacred Gold leaves it as it is.

## What's done

1. **Platinum's basic waves split in two** (`tools/complete/split_sound_basic.py`). Only the waves sound effects,
   fanfares and cries can play stay loaded: 106 waves, 301 KB, read from every note of every sequence (by program and
   key, through its bank's instruments; from each MIDI and the sequence built from it, since `nitrosfx` keeps jumps and
   calls in the MIDI as markers), plus those of the songs the game plays without loading anything (evolution, the slot
   machines, and songs scripts play as fanfares). The other 57 (143 KB) move to `WAVE_ARC_BGM_BASIC`, which Platinum's
   five music banks load with their own waves, so Sinnoh's songs load the same waves as before, from two archives.
   The 44 songs on `BANK_BASIC` that load their bank (the encounter themes, cutscenes) move to a copy of it,
   `BANK_BGM_BASIC`. The tool checks that every note of every sequence plays the same WAV as before. It writes
   `decomp/res/sound/complete/`, which the build packs in place of Sovereign's banks and basic waves
   (`res/sound/meson.build`), so Sovereign's files stay as they are for syncs; the sync script reruns it.
2. **HeartGold's songs** (`tools/complete/import_hgss_sound.py`): 116 songs, kept as HeartGold's sequence files byte
   for byte (`nitrosfx` can't turn 22 of them into MIDI). Each gets a bank of its own: HeartGold's instruments it
   plays, at their numbers; a wave Platinum keeps loaded is used from there, any other from `WAVE_ARC_GS`, one archive
   of all of them (160 waves, 454 KB) that loads wave by wave (NitroSystem's single load, a flag `nitrosfx` now sets),
   so a song loads only its own waves. Its tables of which song plays when (encounter themes by trainer class, battle
   themes by class and wild species) are generated into `include/data/hgss_sound.h`.
3. **Engine** (`src/complete_sound.c`): a field song of HeartGold's plays with its own bank, loaded as the field's
   bank when it starts and its waves reloaded when it resumes (Platinum plays surfing and cycling music with the map's
   song's bank, `src/sound.c`, `src/sound_playback.c`); Johto and Kanto have HeartGold's surfing and cycling songs
   (`src/field_bgm.c`).
4. **Data:** the map headers name HeartGold's songs (`tools/complete/import_hgss_headers.py`, Platinum's standing in
   only for a song the archive lacks), and the translated scripts play them. HeartGold's trainers have its encounter
   themes; battles on Johto and Kanto's maps have HeartGold's battle themes (Johto's or Kanto's trainer and wild
   themes by region, the Gym Leaders', Rival's, Team Rocket's, the beasts', Ho-Oh's and Lugia's) and victory themes.
5. **Test** (`tools/complete/test_sound_heap.py`, with the test build's `gCompleteTestSound`): every song of the
   archive's music players played on a map as the game plays it, a trainer battle, and New Bark Town's song and a
   battle there; no load may fail. On a map, 294 of the 295 songs load, HeartGold's all among them; the one that
   doesn't is the credits' song, which the game plays in its own scene (the test now plays it there). The battle
   loads with 5 KB to spare.
6. A bug in `nitrosfx` (Sovereign's tool) wrote the archive's file table 28 bytes off whenever the file block's
   header didn't end on 32 bytes, which crashed the game at boot once the archive grew; the table now counts that
   padding. Sovereign's own archive happened to line up.

## Left

- HeartGold's fanfares (`SEQ_ME_*`: items, badges, Pokémon caught) and its own sound effects: Platinum's stand in
  for them (a fanfare loads no waves, so HeartGold's would need theirs loaded with them). The radio and Pokégear
  songs come with the Pokégear; the Pokéathlon's are skipped with it.
- HeartGold's players use more channels than Platinum's, so a busy song could drop notes; untested by ear.
- Sovereign's new Pokémon still have no cries. The freed memory is for songs; cries would need their own budget.

**ROM size:** the sound archive grew from 7.96 MB to 9.44 MB; the cartridge was already 256 MB (164 MB used).
