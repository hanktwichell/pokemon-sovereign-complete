# Johto and Kanto's music (step 6)

Johto and Kanto play HeartGold's own songs: every song its map headers name, its scripts play (Sacred Gold's), its
field music code picks (surfing, cycling, the trainers' encounter themes), and its battle and victory themes; and its
scripts' fanfares (an item, a badge, a Pokémon caught). This is how they fit into Platinum's sound archive and sound
memory, measured from both decomps and both built archives.

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
2. **HeartGold's songs** (`tools/complete/import_hgss_sound.py`): 128 songs and 23 fanfares, kept as HeartGold's
   sequence files byte for byte (`nitrosfx` can't turn 22 of them into MIDI). Each gets a bank of its own: HeartGold's
   instruments it plays, at their numbers; a wave Platinum keeps loaded is used from there, any other from
   `WAVE_ARC_GS`, one archive of all of them (160 waves, 454 KB) that loads wave by wave (NitroSystem's single load, a
   flag `nitrosfx` now sets), so a song loads only its own waves. Its tables of which song plays when (encounter themes
   by trainer class, battle themes by class and wild species) are generated into `include/data/hgss_sound.h`. A fanfare
   loads no waves in Platinum (its own play from the loaded basic set), so one of HeartGold's loads its own as it starts
   (`Sound_PlayFanfare`); on Johto's maps the song leaves room for the largest (49 KB).
3. **Engine** (`src/complete_sound.c`): a field song of HeartGold's plays with its own bank, loaded as the field's
   bank when it starts and its waves reloaded when it resumes (Platinum plays surfing and cycling music with the map's
   song's bank, `src/sound.c`, `src/sound_playback.c`); Johto and Kanto have HeartGold's surfing and cycling songs
   (`src/field_bgm.c`).
4. **Data:** the map headers name HeartGold's songs (`tools/complete/import_hgss_headers.py`, Platinum's standing in
   only for a song the archive lacks), and the translated scripts play them, the scenes' themes too: the friend's
   (Lyra's for a boy, Ethan's for a girl), the rival's, the "follow me" ones, Eusine's, Clair's, the Kimono Girls' and
   their dance, Lugia's arrival and the spiky-eared Pichu's, which HeartGold's standard scripts and `TempBGM` play
   (Sinnoh's themes stood in for some, nothing for the rest). HeartGold's trainers have its encounter
   themes; battles on Johto and Kanto's maps have HeartGold's battle themes (Johto's or Kanto's trainer and wild
   themes by region, the Gym Leaders', Rival's, Team Rocket's, the beasts', Ho-Oh's and Lugia's) and victory themes.
   The songs a flag puts on a map, HeartGold's `sMusicOverrideMap`, play too (`CompleteSound_AltMusicForHeader`,
   from Platinum's own table of them, `SystemFlag_GetAltMusicForHeader`): the Bug-Catching Contest's theme in the
   National Park (its own version of it) and its two gatehouses while the contest runs, and the occupation theme on
   every floor of the Radio Tower while Team Rocket holds it.
5. **Test** (`tools/complete/test_sound_heap.py`, with the test build's `gCompleteTestSound`): every song of the
   archive's music players played on a map as the game plays it, a trainer battle, New Bark Town's song, the fanfares
   and a battle there, and the songs a flag puts on a map; no load may fail. All four parts pass (Oct 30, 128 of
   HeartGold's songs): every song loads (the credits' in their own scene, where the game plays them), the tightest of
   Sinnoh's leaving 7 KB (the title screen's; 9 KB before the scene themes and the contest's National Park version); a
   battle leaves 3 KB (5 KB before them: the archive's info and file tables stay in sound memory, and each song adds to
   them); in New Bark Town, its song loads, each of HeartGold's 23 fanfares plays over it (each given back as a script's
   WaitFanfare gives it), and a battle with HeartGold's trainer theme loads: 11 KB to spare at the least; and the
   National Park, a contest gatehouse and the Radio Tower each load the song their flag puts on them.
6. A bug in `nitrosfx` (Sovereign's tool) wrote the archive's file table 28 bytes off whenever the file block's
   header didn't end on 32 bytes, which crashed the game at boot once the archive grew; the table now counts that
   padding. Sovereign's own archive happened to line up.

## Left

- HeartGold's own sound effects: Platinum's stand in. The fanfares the engine's own code plays (a level up, a
  Pokémon caught in battle) are Platinum's in every region. The radio and Pokégear songs come with the Pokégear; the
  Pokéathlon's are skipped with it.
- HeartGold's players use more channels than Platinum's, so a busy song could drop notes; untested by ear.
- The GB Sounds (a key item Sacred Gold's scripts give) do nothing: HeartGold swaps 135 songs for their Game Boy
  versions with it, and each song in the archive keeps about 64 bytes of sound memory, which a battle doesn't have to
  spare (3 KB).
- Sovereign's new Pokémon still have no cries. The freed memory is for songs; cries would need their own budget.

**ROM size:** the sound archive grew from 7.96 MB to 9.44 MB; the cartridge was already 256 MB (164 MB used).
