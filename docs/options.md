# Options pages

The standard for every toolkit options page: which controls, what each is for, how the text reads, how a page is ordered and how it is validated. It follows Blizzard's own Settings pages, cut down to what the Gamepad UI can reach. Requested by the owner, 2026-11-26: "I also need to validate options pages, we need to standardize on [the controls] we use, why, when to use notes, language, etc, matching blizzard methodology".

The ethos outranks this page ([standards.md](standards.md), Part 1: fit WoW, stay consistent, be clear). How the kit builds a page is in standards.md, "Options"; why the Gamepad UI bans what it bans is in standards.md, "Gamepad UI".

## Sources

- Blizzard's code: [Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source/tree/forever), `forever` branch, commit `c01a87b` (1.60.1.71091). `Frame/` is `Interface/AddOns/Blizzard_SettingsDefinitions_Frame/`, `Shared/` is `Blizzard_SettingsDefinitions_Shared/`, `Settings/` is `Blizzard_Settings_Shared/`.
- Blizzard's words: [Ketho/BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources/tree/forever), `forever` branch, `Resources/GlobalStrings/enUS.lua` at commit `e230342`.
- Counts are over every page in `Frame/` and `Shared/`: 330 label strings, 293 tooltip strings, 189 dropdown option names, 36 section headers. A few of those files do not load on Forever (`Mounts.lua`, `AdvancedOptions.lua`); the examples below are from files that do.
- Deck: measured on the Steam Deck with the Gamepad UI, other addons off, 2026-11-26. "Unproven" means no clean Deck pass is recorded for that shape. The Control Test that measured them was removed once this standard existed (owner, 2026-11-27); an unproven shape gets its own Deck pass on the first page that uses it.

Three kinds of rule are kept apart. "Blizzard" is what the source shows. "Deck" is what was measured. "Kit pick" is a choice between forms Blizzard itself mixes, made so every page reads as one author.

## Controls Blizzard uses

| Blizzard control | Uses | The value it holds | Examples | On our pages |
|---|---|---|---|---|
| Checkbox | 163 | On or off | `Frame/Controls.lua:52`, `:62`; `Shared/Audio.lua:496` | `checkbox` |
| Child under a parent | 94 | A setting that only matters under another | `Frame/Interface.lua:100-110`; `Shared/Audio.lua:544-552`; `Shared/Audio.lua:523-539` | `under` |
| Dropdown | 103 | One of a few named modes | `Frame/Interface.lua:82-94`; `Frame/Controls.lua:204-212`; `Frame/Social.lua:163-170` | Banned; use `choice` |
| Slider | 58 | A number on a range, shown as a number, percent or seconds | `Frame/Controls.lua:129-136`; `Shared/Audio.lua:514-523`; `Frame/Combat.lua:165-167` | The control behind `choice` |
| Checkbox with a slider | 11 | A switch and its one number | `Frame/Controls.lua:139-152`; `Shared/Graphics.lua:1480`, `:1502` | Not allowed, unproven |
| Checkbox with a dropdown | 5 | A switch and its one mode | `Frame/Controls.lua:154-173`; `Frame/Combat.lua:59`; `Frame/ActionBars.lua:102` | Banned |
| Button | 12 | No value. An action, or another window | `Frame/Social.lua:274-283`; `Shared/Preset.lua:86-90`; `Frame/Interface.lua:39` | Built by the kit only |
| Key binding | 3 | A key for one action | `Frame/Controls.lua:88-95`; `Frame/ActionBars.lua:66` | `keybinding` |
| Section header | 36 | None | `Frame/Controls.lua:101`, `:176`; `Frame/Interface.lua:18` | `heading` |
| Custom row | 12 | A preview, a test or a notice | `Shared/Subtitles.lua:76`; `Shared/Audio.lua:429`; `Shared/Languages.lua:165` | Banned |

## Allowed controls

Every row is built by `lib:BuildOptions` from one of these. Nothing else goes on a page.

| Kind | Use it for | Deck |
|---|---|---|
| `heading` | Naming a group of rows | Passed (18 checkboxes under 3 headers) |
| `checkbox` | One thing that is on or off | Passed (3 plain, 18 under headers) |
| `checkbox` with `under` | An on or off that only matters while its parent checkbox is on | Passed (a parent and 4 children) |
| `choice` | One of 2 to 5 named values | Passed (sliders with named stops) |
| `keybinding` | A key for an action in `Bindings.xml` | Unproven: no Deck pass yet |
| Kit buttons (Commands, Links, Working Build) | An action with no saved value | Unproven. A page with button rows blocked once and passed once |

1. A value that is on or off is a `checkbox`. A value with two named modes, neither of them "off", is a `choice` (Blizzard: Chat Style, `Frame/Social.lua:165-170`).
2. A `choice` is Blizzard's slider with a name at each stop. This is our one departure from Blizzard, which shows only numbers on a slider (all of its label formatters: `Frame/Controls.lua:135`, `Shared/Audio.lua:516`, `Frame/Combat.lua:165`) and uses a dropdown for named modes. The dropdown is banned below, and the named stops passed on the Deck.
3. Stops run from least to most, left to right, as Blizzard's sliders do (Self Found, Friends, Public).
4. A module never adds a button row. Buttons come from its command table and its TOC links, through `lib:FinishModule`.
5. There is no number slider kind. Add one when a module has a number to set, not before.

## Banned controls

| Banned | Measured reason |
|---|---|
| Dropdown (`Settings.CreateDropdown`, `Settings.SetupCVarDropdown`) | Deck: it cycles, but opening it traps the cursor and breaks navigation for the session |
| Checkbox with a dropdown (`CreateSettingsCheckboxDropdownInitializer`) | Holds the same dropdown. Not measured by itself |
| A row hidden by state (`AddShownPredicate`) | Deck: it blocks the page switch |
| A row added through `Settings.RegisterInitializer`, or built with `Settings.CreateElementInitializer` | Deck: the d-pad cannot reach it and it renders differently |
| Checkbox with a slider (`CreateSettingsCheckboxSliderInitializer`) | Deck: blocked once, passed once. Not allowed until a clean Deck pass |
| A canvas page (`Settings.RegisterCanvasLayoutCategory`, `...Subcategory`) | The d-pad cannot enter it (Recipe Vacuum, `reports/Controller friendly addon settings.md`) |
| Color swatch, expandable section, checkbox with a button | Not measured, and no module needs one |
| Opening a page from module code (`Settings.OpenToCategory`) | standards.md, "Gamepad UI". Use `lib:OpenOptions` |

A banned control comes back only after a clean Deck pass, and this table is updated in the same change.

## Labels

1. Title Case, with small words in lower case. Blizzard: 317 of 330. "Open Loot Window at Mouse" (`Frame/Controls.lua:59`), "Lock Cursor to Window" (`:105`), "Loss of Control Alerts" (`Frame/Combat.lua:38`).
2. Five words at most, two to four where it fits. Blizzard: 306 of 330 have four or fewer, the median is three.
3. A label names the thing, or starts with a plain verb. "Chat Bubbles", "Auto Loot", "Sticky Targeting" name it (`Frame/Interface.lua:100`, `Frame/Controls.lua:62`, `:45`). "Show Move Pad", "Invert Mouse", "Block Trades" start with the verb (`Frame/Accessibility.lua:44`, `Frame/Controls.lua:109`, `Frame/Social.lua:98`). Never a sentence, never a question.
4. No colon and no end punctuation. Blizzard: 0 of 330 have a colon.
5. Say what is on, not what is off. Blizzard turns a negative setting into a positive label: "Sticky Targeting" is the game's `deselectOnClick` flipped (`Frame/Controls.lua:45-46`). A "Do Not" label is rare ("Do Not Flash Screen at Low Health", `Frame/Combat.lua:34`).
6. Use the game's own words, and Blizzard's global string where one exists (standards.md, "Plain text"). A box is "checked", never "ticked" ("Check this to make quest text appear instantly.", `Frame/Camelot/InterfaceOverrides.lua:70`).
7. A label reads by itself, since search shows it alone. A child repeats the noun of its parent: "Chat Bubbles", then "Party Chat Bubbles" and "Raid Chat Bubbles" (`Frame/Interface.lua:100-108`); "Music", then "Loop Music" and "Pet Battle Music" (`Shared/Audio.lua:544-557`).
8. A label is used once on a page and is never the same as its heading. Blizzard: 0 of 36 headers are followed by a row of the same name. Opening a page at a row finds it by its label (`Settings/Blizzard_ImplementationReadme.lua:203-211`).
9. A `choice` label reads with each stop as its answer: "Self Cast" with "Auto" (`Frame/Combat.lua:109-116`), "Status Text" with "Percentage" (`Frame/Interface.lua:84-93`).
10. A stop name is four words at most, in Title Case. Blizzard: 179 of 189 option names have four or fewer, 140 have one or two. "None", "Key Press", "New Tab" (`Frame/Combat.lua:108-110`, `Frame/Social.lua:177`).
11. A key binding's name is a verb phrase in Title Case, as Blizzard's are ("Target Nearest Enemy", "Toggle Autorun").

## Headings

1. A heading is a noun of one to three words, in Title Case: "Mouse", "Camera" (`Frame/Controls.lua:101`, `:176`), "Raid Frames" (`Frame/Interface.lua:138`), "Voice Chat" (`Shared/Audio.lua:222`).
2. Use Blizzard's own page or section name where one exists (`COMBAT_LABEL`, `AUDIO_LABEL`, `SETTINGS_KEYBINDINGS_LABEL`).
3. A heading tooltip is rare in Blizzard: 2 of 36 (`Shared/Graphics.lua:1636`, `Frame/AdvancedOptions.lua:421`). Ours never holds something a row needs, because a heading is not a button and the d-pad may not stop on it. Unproven on the Deck.
4. A section may hold one row (Blizzard: "HUD Modifier", `Shared/Gamepad.lua:144-146`).

## Tooltips

Blizzard shows the label as the tooltip's first line, then the tooltip text, then one line for each option that has a description (`Settings/Blizzard_Settings.lua:289-298`, `:416-461`). So the tooltip never repeats the label.

1. Every `checkbox` has a tooltip. Blizzard: 138 of 148 of its plain checkboxes. A `choice` has a tooltip, or a description on every stop (Blizzard: Chat Style and New Whispers have only option descriptions, `Frame/Social.lua:163-183`).
2. One sentence. Blizzard: 253 of 293. A second sentence is the row's `note`.
3. Sixteen words at most, and 120 characters at most. Blizzard: nine in ten sentences have 16 words or fewer and nine in ten tooltips have 120 characters or fewer; the median is 60 characters.
4. A whole sentence that ends with a period. Blizzard: 199 of 293 end with one. Kit pick.
5. A `checkbox` tooltip says what happens while it is on, verb first in the "-s" form: "Shows bubbles of text above the head of the speaker." (`Frame/Interface.lua:100`), "Plays a sound cue when you become able or unable to interact with a target." (`Frame/Controls.lua:98`), "Adjusts the master sound volume." (`Shared/Audio.lua:523`). Kit pick: Blizzard opens with "Shows" and with "Show" about equally often (108 against 97 among its 30 most common opening words).
6. A `choice` tooltip starts with "Choose": "Choose who can see your current in-game location in the Social menu" (`Frame/Social.lua:142`). Blizzard's most common opening for a dropdown (22). Kit pick.
7. Never open with "Check this to", "If enabled", "When checked" or "Enable this option". Blizzard has these in a few older strings (`Frame/ActionBars.lua:111`, `Frame/Combat.lua:178`, `Frame/Controls.lua:59`); the plain verb is its common form. Kit pick.
8. Speak to the player as "you" and "your". Blizzard: 87 of 293.
9. Never state the default. Blizzard: 0 of 293 state their own default value. The Defaults button does that work.
10. Stop descriptions on one row share one shape: "Set the camera to stay where placed...", "Set the camera to always prefer...", "Set the camera to stay where set..." (`Frame/Controls.lua:161-164`); the Self Cast options (`Frame/Combat.lua:108-111`). A stop whose name says it all has no description ("Numeric Value", "Percentage", "Both", "None", `Frame/Interface.lua:84-87`); on one row either every stop has one or none does.

## Notes

Blizzard has no text row under a setting. Everything a row says is in its tooltip. Its only text-only rows report a state the player must act on: restart needed (`Shared/Languages.lua:165`), microphone access (`Shared/Audio.lua:254`), an addon turned off (`Frame/Interface.lua:144`). A row's `note` is therefore tooltip text: the kit adds it as the last line, as Blizzard adds its own extra tooltip line (`Settings/Blizzard_Settings.lua:490-493`, `Frame/PingSystem.lua:56`).

1. A note is the tooltip's second sentence, for one of three things Blizzard uses a second sentence for:
   - a cost or consequence: "This will affect performance." (`Shared/Audio.lua:610`)
   - a limit, or something it needs: "This only supports keyboard hotkeys..." (`Frame/Combat.lua:178`)
   - another place to set the same thing: "This function can be bound to a function key in the keybindings interface." (`Frame/ActionBars.lua:102`)
2. A note never says the tooltip again in other words.
3. One sentence, 120 characters at most, one note for a row.
4. A note that is true of several rows goes on each of them, from one string. It does not go on the first row alone, and not on the heading (Headings, rule 3).
5. A `keybinding` row shows no tooltip, so it takes no note. What the key does is the binding's name.
6. Name another setting by Blizzard's own label for it ("Enable Interact Key").

## Dependent settings

1. A setting that only matters while a checkbox is on is its child: `under`. Blizzard indents the child, sets it in a smaller font, and while the parent is off greys it and takes it out of gamepad navigation (`Settings/Blizzard_SettingControls.lua:309-319`, `:356`). It stays on the page. Examples: `Frame/Interface.lua:100-110`, `Shared/Audio.lua:544-561`, `Frame/Mainline/InterfaceOverrides.lua:120-132`.
2. Children come straight after their parent, in the same section, one level deep.
3. Never hide a row by state. Blizzard does (`Shared/Gamepad.lua:70-73`, `Shared/Audio.lua:273`); for us it is banned (Deck).
4. A row this client or character can never use is left out when the page is built, as Blizzard leaves out what the client lacks (`Frame/Controls.lua:104`, `Frame/Interface.lua:115`).
5. A need outside the page (a game setting, a profession) goes in the note, by Blizzard's label.
6. Until `under` works on a `choice`, a choice that depends on a checkbox comes after that checkbox's children, not between them.

## Order and grouping

1. Sections go in the kit's one order: sources, the module's features, sections Blizzard names, then the kit's Commands and Links (standards.md, "Options").
2. In a section the switch for the feature is first, then its children, then its choices. Blizzard: "Enable Sound" opens Audio (`Shared/Audio.lua:496`); "Enable Interact Key", then its key, then its sound (`Frame/Controls.lua:72-98`).
3. Most used first. Rows on one subject sit together.
4. A key binding sits right after the checkbox that turns its feature on, or under Blizzard's Keybindings heading.
5. Buttons come last, after the settings (Blizzard: Reset Chat Position, `Frame/Social.lua:274-283`).
6. No row for a taste few will change ([quality-bar.md](quality-bar.md), "Does one job").

## Defaults

1. Every `checkbox` and `choice` has a default. The Settings window's Defaults button sets every row on the page back to it (`Settings/Blizzard_SettingsPanel.lua:78-79`, `:500-521`), so a default is always a safe place to land.
2. The default is what a player expects from the module just installed: its one job on, the extras as the game would have them. Blizzard keeps new behavior off until asked: Enable Interact Key (`Frame/Controls.lua:82`), the extra action bars (`Frame/ActionBars.lua:47`).
3. A setting that makes the character speak or emote to other players starts off (Buffulator's thanks, `Settings.lua:10-11`). Kit pick.
4. The default is never in the text (Tooltips, rule 9).

## Gamepad

1. One page for every input. No gamepad-only branch.
2. Every row is one of the allowed kinds, built by the kit. Module code never calls the Settings API (standards.md, "Conformance").
3. Nothing a player needs is in a place the d-pad cannot stop: not in a heading tooltip, not on a key binding row.
4. A greyed child is skipped by the d-pad. That is Blizzard's behavior, not a fault (`Settings/Blizzard_SettingControls.lua:314-318`).
5. A page does not change its rows while it is open.
6. An unproven shape is named as untested in the release notes until its Deck pass is recorded.

## Validating a page

Do all four for every page before a release, and after any change to its rows.

Text (offline):

- [ ] `scripts/check` passes: conformance runs the rules under "Checks".
- [ ] Each label, tooltip and note was read against the rules above that conformance cannot check: the verb form, shared stop shapes, a note that repeats its tooltip, a label that reads by itself.
- [ ] Every Blizzard term on the page was looked up in the global strings, not recalled.

Mouse and keyboard (desktop):

- [ ] The page opens from the AddOns list and from the module's slash command.
- [ ] Every row shows its tooltip on hover: the label, the sentence, the stop lines, the note.
- [ ] Every checkbox and choice changes what it says it changes, at once.
- [ ] Turning a parent off greys each child; turning it on brings them back.
- [ ] Defaults sets every row back, and the module follows.
- [ ] Typing a label in the Settings search finds the row.
- [ ] No stop name or label is cut off.

Gamepad (Steam Deck, Gamepad UI, other addons off, after a reload):

- [ ] Open Options, go to the page, then switch to one other page and back.
- [ ] D-pad down stops on every row in order, top to the last Links button, skipping only greyed children.
- [ ] A toggles each checkbox; left and right step each choice; each button runs.
- [ ] Each row's tooltip shows while the d-pad is on it.
- [ ] A key binding row can be reached and set.
- [ ] After leaving the page, a Blizzard page still navigates.

Working log (after the Deck pass):

- [ ] No blocked-action line ("Interface action failed because of an AddOn", `ADDON_ACTION_FORBIDDEN`) from opening Options to the end of the pass.
- [ ] No Lua error.
- [ ] The log is kept with the release as the record of the pass.

## Checks

`tests/conformance.lua` runs these on every module's options page, one line per rule naming the rule and each row that breaks it. A section whose heading is not in the locale file is a working-build test page (text written in place inside `--@debug@`) and the text rules skip it.

| Check | Rule |
|---|---|
| A label has five words or fewer | Labels 2 |
| A label does not end in punctuation | Labels 4 |
| A label is used once on a page and differs from its heading | Labels 8 |
| A heading written by us has three words or fewer | Headings 1 |
| A stop name has four words or fewer and is in Title Case | Labels 10 |
| A `choice` has 2 to 5 stops | Allowed controls |
| On one `choice`, every stop has a description or none does | Tooltips 10 |
| A `checkbox` has a tooltip; a `choice` has a tooltip or a description on every stop | Tooltips 1 |
| A tooltip is 120 characters or fewer, starts with a capital and ends with a period | Tooltips 3, 4 |
| A `choice` tooltip starts with "Choose" | Tooltips 6 |
| A tooltip does not open with "Check this", "If enabled", "When checked", "Enable this option" | Tooltips 7 |
| A tooltip and a note do not contain "default" | Tooltips 9 |
| A tooltip does not start with its own label | Tooltips |
| No text says "tick", "ticked" or "untick" | Labels 6 |
| A note is one sentence | Notes 3 |
| A `keybinding` row has no `note` or `tooltip` | Notes 5 |
| A row with `under` follows its parent or another child of it, in the same section | Dependent settings 2 |
| Every `checkbox` and `choice` has a `default` | Defaults 1 |
| The row kind `button` fails: `BuildOptions` builds nothing for it | Allowed controls |
| Banned calls in a module's files, added to the list: `AddShownPredicate`, `Settings.RegisterInitializer`, `Settings.RegisterCanvasLayoutCategory`, `Settings.RegisterCanvasLayoutSubcategory`, `CreateSettingsCheckboxSliderInitializer`, `CreateSettingsCheckboxDropdownInitializer`, `CreateSettingsExpandableSectionInitializer`, `CreateSettingsButtonInitializer`, `CreateKeybindingEntryInitializer`, `SetParentInitializer` | Banned controls |

Left to review, because a pattern cannot judge them: the "-s" verb form, stops from least to most, shared stop shapes, a note that repeats its tooltip, a label that reads by itself.

## Kit gaps

Found while writing this page. Each is the kit's, not a module's. Gap 1 is closed in conformance, not in the library.

1. Closed: `BuildOptions` still drops a `note` on a `keybinding` row without a word, but conformance now fails a note or tooltip there (Notes 5). The row kind `button` is likewise rejected, since `BuildOptions` never built it.
2. `under` works only on a `checkbox`. A `choice` cannot be a child, so Buffulator's Thank Delay stays live while its parent is off. A slider under a parent is Blizzard's own shape (`Shared/Audio.lua:333`) and is not measured on the Deck.
3. A `choice` does not write its default into saved data until it is changed, so modules repeat the default where they read it (Sparklescope 6000 `Finds.lua:11`, Buffulator `Settings.lua:9-13`).
4. The `keybinding` row and the kit's button rows have no clean Deck pass. Every module page ends in button rows, and two pages hold key binding rows.
5. standards.md, "Options", says a choice's tooltip has one line "Label: description" for each option. The code shows the label on its own line over the sentence, because settings text takes no colons. Blizzard's own format is "Label: description" (`Settings/Blizzard_Settings.lua:458`).
6. A Commands row is labelled with the slash command ("/recipevacuum export") and its button says "Run". Blizzard's button rows name the thing and put the verb on the button ("Reset Chat Position" and "Reset", `Frame/Social.lua:281`), and no Blizzard row shows a slash command. One command table driving chat help and the rows is the owner's decision, so this is an open question, not a violation.
7. Heading tooltips hold text on the kit's own Commands and Working Build headings. Whether the d-pad can show one is not measured.
8. Conformance cannot see which rows are working-build only. It skips a section whose heading is not a key in `Locales/enUS.lua`, which is how Sparklescope 6000's Test Settings page (12 and 6 stops, no "Choose") passes. A module that put a release section's heading in place would escape the text rules.

## Each module's page against this standard

Read from each module's `Settings.lua` and `Locales/enUS.lua`. Written 2026-11-26 from each module's files at the commit named; some have been fixed since. Conformance ("Checks") run on the modules' pages 2026-11-27 fails only Recipe Vacuum (Labels 8: "Recipe Sources"; Notes 3: the Share My Finds note). The rest of this list is review-only.

### Recipe Vacuum (`7914b15`)

1. Labels 8: the row "Recipe Sources" has the same name as its heading (`Settings.lua:18-19`).
2. Notes 2 and 3: the Share My Finds note says the tooltip again, then adds a second sentence (`Settings.lua:28-29`). Only "Nothing else is sent." is new.
3. Tooltips 5: two forms on one page. "Send what you find..." and "Print a message in chat..." against "Remembers the trainers..." (`Settings.lua:28`, `:36`, `:34`).

### Tackletron (`6ab9c2c`)

1. Labels 8: the row "Fishing Sources" has the same name as its heading (`Settings.lua:71-72`).
2. Notes 5: the note on the key binding row is never shown, and it is three sentences (`Settings.lua:82-84`).
3. Labels 10: the stop "When a Fish Gets Away" is five words (`Settings.lua:11`). Check in game that it is not cut off.
4. Allowed controls 3: the lure stops run from most to least: Always, When a Fish Gets Away, Never (`Settings.lua:10-11`).
5. Tooltips 10: the three lure descriptions have three shapes (`Settings.lua:12-16`).
6. Tooltips 5: "In combat, your fishing key equips your weapons.", "Equip your weapons as soon as combat starts.", "Lower music, ambience and dialog..." do not open with the "-s" verb (`Settings.lua:88`, `:95`, `:99`).
7. Labels 7: the child "Swap Automatically" does not say what is swapped when read alone (`Settings.lua:93`).
8. Labels 3: "Weapons Back in Combat" neither names a thing nor starts with a verb (`Settings.lua:87`).

### Buffulator (`0bfb948`)

1. Dependent settings 2 and 6: the Thank Delay choice sits between the Thank checkbox and its children (`Settings.lua:42-49`).
2. Dependent settings 2: the emote checkboxes are children of Thank but sit in another section, under their own heading (`Settings.lua:26-27`, `:51-52`).
3. Tooltips 1 and Headings 3: the emote rows have no tooltip. Their one explanation is the heading's tooltip, which the d-pad may not show (`Settings.lua:51-52`).
4. Tooltips 4 and 6: the Thank Delay tooltip "How long to wait before the emote, a little different each time." is not a sentence and does not start with "Choose" (`Settings.lua:45`).
5. Labels 6: "the emotes you tick" (`Settings.lua:52`). The game says "check".

### Sparklescope 6000 (`ad0b524`)

1. Labels 8: the row "Chest Sources" has the same name as its heading (`Settings.lua:11-12`).
2. Notes 4: the Interact Key note is true of all four Sparkles rows and sits on Herbs alone (`Settings.lua:24-26`).
3. Tooltips 5: "Sparkles on herbs while you know Herbalism." and the three like it have no verb (`Settings.lua:25-32`); "Send the chests you open..." is the other form (`Settings.lua:20`).

### Auto Omniadjustor (`9feff06`)

1. Notes 5: both key binding rows carry a note that is never shown (`Settings.lua:22-25`).
2. Gamepad 6: the page is key binding rows only, which has no Deck pass yet.
