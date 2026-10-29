# Johto and Kanto's music (step 6, planned)

Johto and Kanto's maps play Sinnoh stand-ins today (`stand_in_music()`, `tools/complete/import_hgss_headers.py`; the
translator's `sound()`, `tools/complete/translate_hgss_scripts.py`). This is the plan for HeartGold's own, from both
decomps and both built sound archives (measured, not estimated).

## Where things stand

- **The archive grows from source.** Platinum's sound archive is built by `nitrosfx` from `res/sound/` (songs as
  MIDI, banks as text, wave archives as WAV folders, players and groups in `pl_sound_data.json`), with room in its
  tables. HeartGold's is a prebuilt binary (`files/data/sound/gs_sound_data.sdat`, 8.66 MB) in the same format, with
  the same players; `nitrosfx` can unpack it.
- **What's needed:** about 120 of HeartGold's songs (79 in map headers, 24 in scripts, 9 trainer encounter themes, 16
  battle themes), 103 song files, about 0.78 MB. The 140 GB Sounds versions are left out.
- **Sound memory** (`SOUND_SYSTEM_HEAP_SIZE`, 769,024 bytes) is the limit, not the archive. About 610 KB is loaded at
  boot, almost all of it Platinum's `WAVE_ARC_BASIC` (458 KB), which stays loaded the whole game. A map leaves about
  52 KB free; a battle 10-15 KB. Sovereign's new Pokémon have no cries for this reason.
- **HeartGold's songs need HeartGold's own instruments:** its basic wave set shares only 33 of 158 waves with
  Platinum's. A typical map song needs about 62 KB of waves Platinum lacks (the largest, Violet and Olivine, 135 KB);
  a battle theme 62 KB at least, and the trainer battle theme 158 KB. Most songs can't simply be added.

## Plan

1. **Split Platinum's basic wave set.** Sound effects and fanfares use 109 of its waves (321 KB), which must stay
   loaded (fanfares load no waves of their own). The music-only rest (135 KB) moves to a wave archive each music bank
   loads with its own. That frees 137 KB, and Sinnoh still fits. A rerunnable tool
   (`tools/complete/split_sound_basic.py`) rewrites the banks, so a Sovereign sync can be followed by a rerun.
2. **Import the songs** (`tools/complete/import_hgss_sound.py`): unpack HeartGold's archive, turn each song back into
   MIDI (checking it converts back to the same bytes), give each song a small bank with only the instruments it plays,
   point waves Platinum already has at Platinum's, and put the rest in HeartGold wave archives. The new entries go
   after Platinum's.
3. **Engine:** the music loader only takes Platinum's two field banks (`src/sound.c`); it takes any bank, as
   HeartGold's does. Walking from one map into the next fades to the next song on the old song's bank
   (`src/field_bgm.c`), which only works while both share one bank: it loads the new one.
4. **Data:** the map headers' real songs in place of the stand-ins; HeartGold's rows in the trainer encounter and
   battle music tables; Johto's and Kanto's surfing and cycling themes; HeartGold's alternate songs by flag.
5. **Test** (`tools/complete/test_sound_heap.py`): every imported song on a map and in battle, failing on a load
   failure or too little free memory.

After the split, a map has about 205 KB for its song (the largest needs 135-154 KB) and a battle about 160 KB (the
trainer battle theme's 158 KB is too tight: it may need a smaller instrument set or more sound memory, if the game's
memory has room, which has to be measured).

**ROM size:** about 0.8 MB of songs and 0.9 MB of waves, more than the 2 MB left, so the cartridge moves to 256 MB,
as the cries were already expected to.

**Risks:** the split touches every Sinnoh song and sound effect, and a mistake silences an instrument rather than
crashing, so it needs a full listening and memory test; the battle themes have little margin; HeartGold's players
use more channels than Platinum's, so some notes could drop.
