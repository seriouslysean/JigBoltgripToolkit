# Client notes

What WoW Forever's client does that any toolkit module can run into, as measured or read in Blizzard's own code. A fact only one module depends on stays in that module's `docs/client-notes.md`. Blizzard's UI source for this client: [Gethe/wow-ui-source, `forever` branch](https://github.com/Gethe/wow-ui-source/tree/forever). Rules that follow from these are in [standards.md](standards.md), "Gamepad UI".

## Gamepad

- Gamepad navigation refuses to move when it reads a value addon code wrote: `SmartNavigation:Navigate` calls `SelectButton`, whose `EnsureIsSecure` fails, prints "Interface action failed because of an AddOn" and drops the move (`SmartNavigation.lua`). Scrolling a Blizzard `ScrollBox` reads each row's element data (`HandleScroll`), so rows an addon inserts break navigation of the whole list (Recipe Vacuum, Steam Deck, 2026-11-26).
- That message fires no event, and the taint log stays empty for it. A working build logs it where Blizzard prints it (`ChatFrameUtil.AddSystemMessage`), with the stack. It prints once per session.
- Opening a Blizzard menu or panel from addon code hands the gamepad frame manager tainted state; a later secure reader is then blocked with `ADDON_ACTION_FORBIDDEN: SetPreferredGamepadInteractTarget()` (`MainActionBarFrame.lua`, `UpdateInteractIcons`). Reported for Forever as Stanzilla/WoWUIBugs#896; fixed in addons by not doing it (TrainerSpells PR #9, Macro Assist PR #311, SkillUp Forever #398/#454, Tweaks Forever PR #383).
- Taint spreads: after Recipe Vacuum's list insertion, opening the character window from the gamepad radial raised "attempt to compare a secret number value (execution tainted by 'RecipeVacuum')" in `TextStatusBar.lua`.
- Smart navigation focuses any `Button` or `EditBox`, and anything with an `OnMouseUp` or `OnMouseDown` script (`Utility.lua`, `SmartNavigation_CanFocusFrame`), found among a window's child frames. A plain `ScrollFrame` it scrolls with `SetVerticalScroll` only.
- The professions window's gamepad Create press clicks `CraftingPage.CreateButton` whenever it is enabled, even while hidden (`Blizzard_ProfessionsFrame.lua`, `CanCreate`).
- Under the Gamepad UI, Forever shows one UI window at a time. Changing the interface style reloads the UI.
- `GAME_PAD_ACTIVE_CHANGED (isActive)` fires on switching between gamepad and keyboard and mouse; working-build logs record it as `input:` lines.
- On the Steam Deck the controller layout's key picker has no Print Screen; bind a numpad key (Num Pad \* is untouched by Num Lock) to a back button with Double Press, and WoW's Screen Shot to that key. Each WoW screenshot is logged (`SCREENSHOT_SUCCEEDED`) with the file's own time stamp.

## Settings pages

- Blizzard orders its own Settings pages with `CUSTOM_GAMEPLAY_SETTINGS_ORDER` (`GameplaySettingsGroup.lua`) and titles them `COMBAT_LABEL`, `SETTINGS_KEYBINDINGS_LABEL`, `AUDIO_LABEL`.
- `CreateSettingsButtonInitializer`'s click handler receives the clicked button (`Blizzard_SettingControls.lua`), not text.
- An addon's Settings dropdown runs the addon's option function when opened, so it taints under the Gamepad UI; Blizzard's slider does not open a menu.

## Text and language

- `string.lower` folds only A to Z; `CaseAccentInsensitiveParse(text)` is the client's own fold for every language, and `strcmputf8i` compares the same way.

## Saved data

- Saved variables are written only at logout, `/reload` or quitting the game; a crash loses the session's log.

## Repository and CI

- A clone with `core.fileMode false` commits scripts without their execute bit, and CI cannot run them (exit 126). Keep `core.fileMode` on.
- Run a module's CI with act before its first push, not only the kit's.
