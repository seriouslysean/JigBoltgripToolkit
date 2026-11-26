# Translations

How a Jig Boltgrip's Toolkit module is translated. Releases ship English; another language is added as a file, written with Opus against the game's own translated terms, and shipped once it has been read in game.

## Files

- Every string a player reads is a key in the module's `Locales/enUS.lua`, the key being the English text: `L["Share My Finds"] = true`.
- A language is `Locales/<locale>.lua`, one line per key:

  ```lua
  local addonName = ...
  local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "deDE")
  if not L then return end
  L["Share My Finds"] = "Meine Funde teilen"
  ```

- A key left out shows in English. A new file stays out of the TOC until it has been read in game; the conformance check reads it either way.
- The kit's own strings (source option names, the friends option, "Boltgrip's %s %s.", the Commands and Links sections) are registered as `JigBoltgripToolkit` and translated the same way, in the kit.
- The game's client languages: deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW.

## Rules

1. Translate whole sentences. A module never slots a word into another sentence (the source choices take the module's own sentences), since word order, case and gender change around the slot.
2. Keep every format argument. `%s` and `%d` may be reordered with positions: `"Aufnahme von %2$s fertig! %1$d Rezept!"`. The conformance check fails a line that drops or adds one, and a key the English file does not have.
3. Game terms are the game's own words in that language, never a guess. Read them by ID with the glossary tool:

   ```sh
   luajit tools/glossary.lua <build> <locale> <table> <key column> <name column> <key>...
   luajit tools/glossary.lua 1.60.1.71139 deDE SpellName ID Name_lang 7620 3273
   luajit tools/glossary.lua 1.60.1.71139 deDE GlobalStrings BaseTag TagText_lang FRIENDS COMBAT_LABEL
   ```

   Useful tables: `GlobalStrings` (the UI's own words, by name), `SpellName` (professions and spells), `ItemSparse` (`Display_lang`, items), `ItemSubClass` (`DisplayName_lang`, item kinds such as Fishing Pole), `SpellItemEnchantment` (`Name_lang`, lures and other enchants).
4. Labels follow the language's own capitalization in the game, not English Title Case.
5. The robot voice is each device speaking: a short noise in the present tense ("whirs and rattles"), then beats ending in "!". Keep the beats short and mechanical in the target language; read the game's own gnomish devices in that language (Homing Robot OOX-17/TN's quest text, the Mobile Alert System) for the tone.
6. Working-build lines (logs, development commands) stay English.

## Checks

The conformance check (`tests/conformance.lua`) reads every file in `Locales/`: each key must be an English key, with the same format arguments. Reading a file in game is the last step before it goes in the TOC.
