# Toolkit standards

How every Jig Boltgrip's Toolkit addon is written, in three parts: the ethos first, because it decides everything else, then Lua practice, then WoW addon standards. Each rule says what enforces it: the kit at runtime, the shared conformance test, or review. A module's own `AGENTS.md` adds only what is specific to that module and links here.

The bar an addon is checked against before a release: [quality-bar.md](quality-bar.md). Worked examples: [Recipe Vacuum](https://github.com/seriouslysean/RecipeVacuum) and Tackletron.

# Part 1. Ethos

The owner's rules; where they and anything below disagree, these win (owner, 2026-11-25: "the most important is simple, dry, kiss code. Working from data, documentation, and that the code looks like one person wrote it. All tests need to add value, no low value tests at all, for any reason unless there's a specific, known bug we're preventing").

1. Simple, DRY, KISS. The smallest version that does the job; one place for each thing. Duplication is a DRY violation by default; performance is the one reason to accept it (a hot path that cannot afford the call), and only after asking the owner (owner, 2026-11-25: "I also want to be really careful with duplication, sometimes it's ok, but generally it's a dry violation"; "Performance IS important though, so performance take precedence when considering those things, but definitely ask me first"). Enforced by: review.
2. Work from data and documentation. Behavior comes from tables and the game's own data, decisions from the docs; code follows them. Enforced by: review.
3. One author. Every file reads as if one person wrote it: one way to write each thing, enforced by tooling where it can be. Enforced by: conformance, luacheck, review.
4. Tests only where they prevent a specific, known bug. No test for coverage, completeness or habit. Each names the bug it guards. Enforced by: review.
5. Vanilla-style quality of life. Each module does one job the game leaves undone, and looks and behaves like part of the game. Enforced by: review, quality bar.
6. Quiet. A module speaks only when it has done something the player wants to know. Enforced by: quality bar.
7. Plain game words, the machine voice for the one voiced line (Part 3, "Voice"). Enforced by: conformance.
8. Mouse and keyboard and gamepad are both first-class: every feature works fully either way, and reads clearly. No release until both are checked in game. Not breaking the controller is a release requirement; an extra beside a module's main feature may work by mouse and keyboard only, as long as it never gets in the controller's way; anything that gives the player information or an action they need is not an extra and must be reachable both ways (owner, 2026-11-26). No minimap icons. Enforced by: review and the quality bar.
9. Documentation holds the reasons, decisions and history; code holds the reason only (Part 2, "Comments"). Enforced by: conformance.

## Game-facing principles

1. Blizzard's design language, on Forever's own frames: its templates, atlases, fonts, colors, global strings, enums and APIs.
2. Blizzard's own patterns, cited in a short comment: Blizzard's source, game data, or our own in-game tests. Other addons may be studied in research but are not named or credited in the repos (owner, 2026-11-26). An outside data source that is not an addon (a database dump, a measurement someone published) stays cited where its numbers come from: in the data tool, the generated data's header and the docs, never in code comments (owner, 2026-11-26). Nothing custom without a real need.
3. When standing out and matching the game pull in different directions, match the game.
4. Simple and in one place. Data lives in tables, not in branches.
5. Quiet: the addon says something only when it has done something for the player.
6. Claims are backed by data from the game, not by reading the code.
7. Self-found and friends first. A module enhances the game with what the player and their friends find; data from public sources (included tables, outside databases) is opt-in, never the default. The source choice defaults to Friends where the module shares, else Self Found. The suite reads as Jig Boltgrip building what he finds useful for himself and others (owner, 2026-11-26: "Opt in only for public data sources"). Enforced by: review.

## Look before designing

- For anything the player sees, look at what the game does first: Blizzard's UI source ([Gethe/wow-ui-source, `forever`](https://github.com/Gethe/wow-ui-source/tree/forever)), Forever's own strings ([Ketho/BlizzardInterfaceResources, `forever`](https://github.com/Ketho/BlizzardInterfaceResources/tree/forever), `Resources/GlobalStrings/enUS.lua`), and the game itself.
- Then look at the addons installed next to ours for how the community does it.
- A copied Blizzard value (a size, an anchor, a texture path) is named at the top of the file and marked with the file it came from.
- Never imitate the game's own message formats ("says:", "whispers:", bracketed names). Fit in beside them.

# Part 2. Lua

Lua 5.1, as the client runs. Where WoW practice and general Lua practice differ, Blizzard's own code wins (tabs, `PascalCase` functions, `UPPER_CASE` constants); otherwise the [LuaRocks style guide](https://github.com/luarocks/lua-style-guide) (one reference among several it cites, with its reasons given).

## Comments

A comment gives the reason for the code: why it is this way, what it protects, which Blizzard file or established addon it follows. Never what the code does, and never history: no quotes, dates, review findings or who decided. Anything that specific goes in `docs/`, and the comment may point there. At most three lines. Debug-only blocks, third-party libraries and tests are exempt. The LuaRocks guide puts it the same way: "the implementation should be simple enough so that comments aren't needed". Enforced by: conformance.

## Tests

Rules for every module's tests (owner, 2026-11-25: "Rules now, then migrate"), from the community's practice for WoW addons and Lua; Blizzard publishes no testing standard.

1. Test only to prevent a specific, known bug, and name it in the test.
2. Run tests under Lua 5.1 semantics, as the client does.
3. Use the community's test runner (busted, as other addons do), not a home-made one.
4. Stand in for only the game calls the code makes, and check the stand-ins against the client's own API documentation so they cannot drift.
5. Run the addon's real files; never re-implement them in a test.
6. Assert what a player or a saved file would see, never which internal calls were made.
7. Test the release build as well as the working build.
8. Never let a test skip itself; a missing input fails the run.
9. Prove each new test can fail: break the code, watch it fail, restore it.
10. Treat offline tests as evidence, not proof; confirm in the client before calling work done.

Enforced by: review, the check script (rules 2, 7, 8), conformance (stand-ins, once checked against the API docs).

## Code

| Pattern | Rule |
|---|---|
| Namespace | `local addonName, ns = ...`; nothing global but saved variables, slash commands and frames the game must find by name (a key binding's click target, a window closed by Escape), all listed in `.luacheckrc` |
| Constants | No number or path inline: name it at the top of the file |
| Names written once | `Core.lua` looks the libraries up once and keeps them on the namespace (`ns.toolkit`, `ns.L`); locale tables are named by the addon's name from the TOC (`local addonName = ...`), never a string. The addon's own name and its saved variables follow the same rule: the name comes from the TOC, and saved variables are read in the one file that keeps them on the namespace (`ns.db`). A string that is a contract (a message prefix, an export format) is a named constant. A numeric ID used in more than one file is named once too. Enforced by: conformance, except numeric IDs (review) |
| Hooks | After Blizzard's code only: `hooksecurefunc`, `Menu.ModifyMenu`, `ScrollUtil.AddInitializedFrameCallback` |
| State on Blizzard frames | In a weak-keyed side table, never as fields on their frames |
| Settings and commands | Through the toolkit library: `RegisterModule`, `RegisterCommands`, `FinishModule`; one command table drives chat help and the settings rows |
| Chat lines | All in one `Voice.lua`; code never holds a line inline |
| Comments | A line or two of why. Explanations, measurements and history go in `docs/`, and the comment points there |
| Lua | 5.1, as the client runs; `luacheck` with reads of WoW globals allowed and writes reported |

Suggested files: `Core.lua` (saved data, schema, migrations), `Voice.lua`, `Settings.lua`, `Troubleshooting.lua`, feature files, `Data/` for shipped data, `tools/` for generators, `tests/`, `docs/`.

## Checks

- One command, `scripts/check`, runs every check; the pre-push hook (`.githooks/pre-push`, copied byte for byte from splitleafhq/.github) runs it before every push, and CI runs it on every pull request and push to `main`. Turn the hook on once per clone with `git config core.hooksPath .githooks`; never skip it.
- A module's `scripts/check` exports what its specs read and runs the kit's shared steps, `Libs/JigBoltgripToolkit/tests/module-check.sh`: Lua 5.1 syntax, ShellCheck and shfmt on `scripts/check`, luacheck, conformance, the release build with debug blocks removed, and the specs on the source and on that release build. Each step prints one `ok` or `FAIL` line with its seconds; a failure shows its output and fails the run. Inputs a spec needs (Blizzard's UI source at a pinned commit, a saved file) are provisioned by `scripts/check` or kept as made-up fixtures in `tests/fixtures`, so no spec ever skips.
- A module's `.github/workflows/ci.yml`, named `CI`, has one job, `test`, which calls the kit's `.github/workflows/module-ci.yml` at a pinned commit; that workflow installs the pinned tools (Lua 5.1, LuaJIT, luacheck 1.2.0, busted 2.3.0, ShellCheck 0.11.0, shfmt 3.14.1) and runs `scripts/check`. A change to a workflow is run with act on the local Podman before it is pushed.
- A new module starts from `tools/new-module.sh` in the kit, which copies `skeleton/` (the smallest module that passes every check), embeds the kit, LibStub and AceLocale, turns the hook on and runs the check.
- Specs are `tests/*_spec.lua`, found by the `.busted` file in the repository root. Inputs the specs need (a UI source checkout, a saved file) come in as environment variables, not fixed paths. The client's globals are set on the real global table (busted gives each spec function its own environment, which the loaded addon files cannot see), so a spec wraps its `it` and `setup` functions to run there.
- `luacheck` lints `tests/` with busted's globals (`std = "+busted"`).
- Tests run the addon's real code, against a real saved-variables file and, where the interface matters, against Blizzard's real UI code from the source mirror.
- A test stand-in must not share a value with the code under test. A stand-in color defined equal to the constant it was compared with hid a bug here until it was seen in game.
- A test exists only to prevent a specific, known bug, and names it (Part 1, rule 4). A test that guards nothing known is removed.
- Offline tests do not replace the game. Work not yet seen in the client is reported as untested in game.

## Conformance

One checker, `tests/conformance.lua` (not a busted spec: it runs on each addon's own files), runs the rules above on each addon's own files, so a rule lands in every addon at once (owner, 2026-11-25: "lets get some rules baked in to the kit so we don't make this mistake or drift again"). It travels with the library in `Libs/JigBoltgripToolkit/tests/` together with `tests/stubs.lua`, the kit's stand-ins for every client call it makes; the addon's packaging leaves that folder out. Each addon's checks run `luajit Libs/JigBoltgripToolkit/tests/conformance.lua .`. It checks:

- the addon's own files: no chat, options rows or working-build setup outside the kit (`DEFAULT_CHAT_FRAME`, `print(`, `Settings.Create*`, `CreateSettingsListSectionHeaderInitializer`, `SetCVar("scriptErrors")`); nothing that taints the Gamepad UI ("Gamepad UI" below: `Settings.CreateDropdown`, `Settings.CreateElementInitializer`, `Menu.ModifyMenu`, `MenuUtil.CreateContextMenu`, `SetupMenu`, `ShowUIPanel`, `HideUIPanel`, `OpenWorldMap`); a row kind other than checkbox, choice, button or keybinding; no XML; packager markers alone on their lines and in pairs;
- the embedded kit: no XML, and the same files as the toolkit checkout beside the addon when there is one;
- `AGENTS.md`: its first `##` section is the kit's `tests/agents-opening.md`, word for word, so every module's agents read the same rules first;
- translations: every key in a `Locales/<locale>.lua` is an English key, with the same format arguments;
- the addon loaded on the stand-ins: headings, labels, tooltips, command descriptions, source choices and voiced lines against the rules marked "Enforced by: conformance".

Runtime checks stay for what would break the page or the line; style is never a load error for a player. A rule marked "Enforced by: review" has no check yet.

# Part 3. WoW addon standards

Blizzard's UI Add-On policy, Forever's own interface code and our own in-game tests; each section cites its source.



## IDs, never text

- Identify everything by ID: items, spells, recipes, NPCs, quests, maps, categories. Names are for display.
- Never match English text. Where a test on text is unavoidable, test its shape, not its words: "is there a number in it", "is the category empty", compared against the game's own localized string.
- Before settling for a name match, look for the ID in tooltip data. `C_TooltipInfo` lines carry fields the plain API does not: a recipe item's `ItemSpellTriggerLearn` line holds the recipe's spell ID, which replaced a whole name-matching scheme.
- Labels come from Blizzard's global strings where one exists (`DISPLAY`, `SOURCES`, `MISCELLANEOUS`, `UNKNOWN`), so they are translated for free.

## Data

Each kind of data has one home, and none is copied into another.

| Kind | Home | Rule |
|---|---|---|
| Seed: what the game says about itself | A generated file in `Data/`, shipped | Generated by a script from the client, never edited by hand, IDs only |
| What players saw | Saved variables | Found and shared kept apart; a later sighting updates and never deletes |
| Cache of game facts | Saved variables, stamped with the game build | Rebuilt when the build changes |
| Development captures | Saved variables, working build only | Never read by released code |

- Saved data has a schema number and ordered migrations, one function per step.
- Seed data never enters saved data. Save only what the seed lacks, and drop it at load once the seed covers it.
- A generator refuses to remove or change existing entries without an explicit flag, so a capture cut short cannot ship.
- Received data is validated field by field and never executed.

## Resilience

- Item and spell data load on demand. Check `C_Item.IsItemDataCachedByID` (or the spell equivalent) before reading a tooltip; a tooltip read too early comes back with lines missing and looks complete.
- Never save a fact read from data that might be incomplete. Return "not known yet" and try again later.
- A requirement shown on a recipe can belong to the item it makes. Read each fact from the thing that owns it.
- Remember what will not answer. An item that never loads, or a peer that cannot be reached, is asked once, not on every run.
- Loops that walk game data are bounded three ways: a time budget per frame, a hard cap, and `pcall` inside any ticker so an error ends the work instead of repeating every frame.
- Decide before acting rather than hiding the result. Check that a whisper can arrive (online, this realm, this faction) instead of filtering the game's error line; never hide anything from the player's chat.
- Guard values the client may hide (`issecretvalue`) before comparing or formatting them.
- Additive first: a new path for a case the old one missed is added beside the old path until it is proven in game.
- Keep a fallback for what the seed or cache lacks, so a game update degrades to "slower", not "broken".

## Performance

- Measure, then fix what the numbers name. The working build times its own work all session and writes the table to the saved log; a guess about the slow part was wrong once here and the table was right.
- Budget: nothing of ours should take a frame (16 ms). Recipe Vacuum's steady state is about 5 ms for a list rebuild, under 0.01 ms per row, 0.01 ms for pane controls.
- Cache what is expensive, with a named event that clears it. Know for each cache what refreshes it.
- Do first-open work lazily: only for rows on screen, as they are drawn, with one coalesced redraw when answers arrive.
- What is fixed for a game build is read once per build and kept, not once per session.
- Skip work whose inputs have not changed: key it on the selection, a change counter and the zone.
- Server requests are paced in small batches, and only for what has never been asked.
- Ordinary play costs almost nothing: non-relevant loot is one item-class check.

## Gamepad UI

On WoW Forever with the Gamepad UI (Steam Deck), anything addon code adds into Blizzard's Settings list or menus is tainted, and Blizzard's gamepad navigation refuses to work on it. The same rule holds for every input: one way, not a gamepad-only branch (owner, 2026-11-26: "That just means no cards and stick to blizzard standard implementation with enough supplementary information").

- Never write into Blizzard's lists, menus or panels from addon code. Evidence: the kit's source cards, a custom row built with `Settings.CreateElementInitializer`, could not be reached or changed with the d-pad and broke navigation of the list (seen in game, 2026-11-26); `SmartNavigation.lua` refuses an insecure target (`EnsureIsSecure`) and the client reports `ADDON_ACTION_FORBIDDEN` for `SetPreferredGamepadInteractTarget`. Enforced by: conformance.
- No addon-owned dropdowns or menus (`Settings.CreateDropdown`, `Menu.ModifyMenu`, `MenuUtil.CreateContextMenu`, `SetupMenu`); a choice is Blizzard's slider. Evidence: opening an addon-owned Settings dropdown runs the addon's option function, then the menu takes gamepad focus and taints; the kit's own source-choice dropdowns broke Settings navigation on the Steam Deck, and Blizzard's slider fixed it (2026-11-26). Enforced by: conformance.
- No `ShowUIPanel`, `HideUIPanel` or `OpenWorldMap` from addon code. Show a map pin with `C_Map.SetUserWaypoint` instead. Evidence: Recipe Vacuum's menus and panels opened from addon code led to `ADDON_ACTION_FORBIDDEN: SetPreferredGamepadInteractTarget()` (`MainActionBarFrame.lua`, `UpdateInteractIcons`) on the Steam Deck (2026-11-26). Enforced by: conformance.
- Our own controls are real `Button`s, so the gamepad cursor can focus and click them (same sources). Enforced by: review.
- A decoration on a Blizzard frame lives in our own weak table keyed by that frame, and nothing is written onto Blizzard's frames. Evidence: Recipe Vacuum's rows inserted into Blizzard's recipe list stopped the d-pad, refused in `SmartNavigation` `EnsureIsSecure` (Steam Deck, 2026-11-26). Enforced by: review.
- Under the Gamepad UI Forever shows one window at a time: opening the character window from the gamepad radial closed Professions (seen on the Steam Deck, 2026-11-26). A panel of ours is a child of a Blizzard window, never a window of its own. Enforced by: review.
- The options page opens through `lib:OpenOptions(module)`, never `Settings.OpenToCategory`: from addon code it runs `ShowUIPanel` tainted, so under the Gamepad UI the kit says where the page is instead, and leaves out its Open buttons (the gamepad interface is chosen before load). Enforced by: conformance.
- A list of our own is a Blizzard `ScrollFrame` (`UIPanelScrollFrameTemplate`) with one real `Button` per row: the gamepad moves between rows that exist and scrolls the frame to reach one out of view, and a `ScrollBox` would hand our data to Blizzard's secure navigation. Evidence: a pool of one screenful of relabelled rows left the d-pad stuck at the last row shown (Steam Deck, 2026-11-26). Enforced by: review.
- Selection works as Blizzard's lists do: a press (gamepad A or a click) selects, and what it shows stays until the next selection; moving the gamepad cursor or hovering only shows a tooltip. Nothing changes layout on focus: the d-pad has to leave a row to reach the controls its selection shows, and a layout that moves on focus moves rows under the cursor (Recipe Vacuum's panel, owner, 2026-11-26). Enforced by: review.
- Shared findings about the client are in [client-notes.md](client-notes.md).

## Voice

The toolkit's chat lines show a gnomish machine at work: the noise it makes, then its own report, the way the game's robots speak. "Boltgrip's Recipe Vacuum whirs and rattles. Intake complete! 2 recipes from Corporal Bluth!" (owner, 2026-11-25, of this line: "I like the 1 options above, can we apply that to all lines in both addons?").

1. Two parts (enforced by: runtime, both required; conformance, the end marks). The noise: a short present-tense phrase, no end mark ("whirs and rattles", "starts whirring and beeping"); the library adds the period after it. The report: one or more robot-speak beats, each ending in "!", with no "I" and no subject ("Intake complete!", "Hostile contact detected!"). In code, `lib:Say(module, noise, report)`.
2. The noise never repeats the device's name. No doubled words, no questions, no jokes.
3. Facts stay exact: real counts, names and places. A line that changes a setting ends its report with the plain effect ("A lure for every cast!"); other lines do not explain what the addon will do.
4. Read real in-game gnome text before writing a line and model on it without copying it: Homing Robot OOX-17/TN ("Flight systems online! CLUCK! Engaging rockets for transport to Booty Bay!", [Rescue OOX-17/TN!](https://warcraft.wiki.gg/wiki/Rescue_OOX-17/TN!)), the Mobile Alert System, Tinkmaster Overspark ("Our scanners report...").
5. Fitting the game's forms is the aim. What a line never borrows is one of the game's own chat colors (whisper, emote, system announcement), which would make it read as that kind of message.

### Plain text

Everything a player reads outside the voiced line: options labels, tooltips, notes, option descriptions, command help, window titles (owner, 2026-11-25: "specificity matters"; "please be specific, and stick to game terms, just like our bot/device language").

1. Name the exact game thing: Fishing skill, lure, fishing pole, trainer, vendor, recipe, "a fish got away". Never the addon's machinery: addon, data, database, community, server, sync, export, record. Enforced by: conformance (a word list).
2. Say the number and what it is for ("%d to cast, %d so no fish get away", not "from %d").
3. Prefer the game's own phrases and global strings.
4. A setting's text says exactly what changes when it is on.
6. WoW-style plain language (owner, 2026-11-25: "wow style plain language, simple sentences"; "Your subnotes are also insanely long"): no colons or semicolons in labels, tooltips, notes, option descriptions or command help; sentences of 16 words at most; a note 120 characters at most. Enforced by: conformance.
5. Source choices share one sentence shape in every module (rule under Options). Enforced by: runtime (`lib:SourceChoices` writes the sentences) and conformance.

### Translations

Every string a player reads is looked up through AceLocale-3.0 (Ace3), English by default, the key being the English text (owner, 2026-11-25: "English as the default ... I want the strings pulled out for localization"). Each module keeps its own `Locales/enUS.lua`; the kit registers its own strings as "JigBoltgripToolkit". An addon embeds `Libs/AceLocale-3.0` before the kit, and without it the kit's English stands. Releases ship English only for now; other languages are added as files, made with Opus against Blizzard's own translated game terms, as [translations.md](translations.md) describes (whole sentences, format arguments kept, game terms read by ID with `tools/glossary.lua`). Working-build lines stay English. Enforced by: conformance (player text written in place outside working-build blocks fails; a language file's keys and format arguments must match English).

### Delivery

The library prints every chat line, and an addon keeps no chat formatting of its own.

| Call | Prints | Use |
|---|---|---|
| `lib:Say(module, noise, report)` | the gear mark, "Boltgrip's", the device's name, the noise and a period, the report | a voiced line |
| `lib:Print(text)` | the gear mark, the text | a plain line: an error's text, a development answer |
| `lib:PrintBlock(header, rows)` | the header with the mark, then rows aligned under its text | several lines that belong together, such as help |

- The mark is the world map's gear. The line color is the family's own, a teal (5BD9DE) chosen in game because it matches none of the game's chat colors; measured against the client's `ChatTypeInfo` on 2026-11-25, its nearest neighbours are party chat and the Battle.net whisper.
- Only the device's name has its own color: a class color from `RAID_CLASS_COLORS`, with a quarter of the line color mixed in so the names sit together. A module names its class once, at `RegisterModule`.
- Devices: Recipe Vacuum Druid, Tackletron Shaman, the sparkle tool Paladin, the buff tool Warlock. Mage is not used: it is too close to the line color.
- A failure is a voiced line followed by the error's text on a plain line, so the text stays exact.

Known limits: chat-copy features strip inline textures, so the gear is missing from copied text and "Boltgrip's" carries the family there; lines printed this way get no Blizzard timestamp; they cannot be redirected to another chat frame.

Help lists commands in Blizzard's own shape (`CHAT_HELP_TEXT_LINE*`): "/command <arguments> - What it does", one short line each, help itself not listed. Rows sit under the header's text, after a blank the gear's size (Blizzard's `Interface\\Common\\spacer`), as a tooltip's lines sit under its heading. Commands are in the device's color; the description stays in the line color. Help must be clear above all: each description says exactly what happens, in plain words, and says what each argument does; no shorthand a new player would have to guess at. An entry's `usage` field holds its arguments ("on|off", "[all|clear]").

Settings labels and tooltips are not in this voice. They follow Blizzard's wording and capitalization ("Auto Loot", "Enable Sound").

## Side panels

No module needs a side panel yet. The first expected use is Recipe Vacuum's sources when there are more than its recipe pane shows: one row per source, each with its own map button (owner, 2026-11-25). If one is needed, the candidate is the Dressing Room's custom set details panel, which the owner picked on 2026-11-25: it sits beside its main frame and lists rows with icons. Blizzard draws it as a black background, a class background and the `dressingroom-sideframe` atlas on top (`Blizzard_UIPanels_Game/Mainline/DressUpFrames.xml`, `CustomSetDetailsPanel`). Not yet checked: whether the atlas exists on Forever and how it stretches.

## Working build helpers

The library holds the working-build helpers, so every module gets the same ones and no release runs them (owner, 2026-11-25: "that debug functionality seems really nice while testing, we won't want to ship it, so it should also live in the shared kit"). The library file is identical in every build, so a module calls them only from its own `--@debug@` block:

- `lib:EnableWorkingBuild()`: turns on the game's Lua error display and prints any action the client blocked (`ADDON_ACTION_BLOCKED`, `ADDON_ACTION_FORBIDDEN`). Safe to call from several modules.
- `lib:Time(module, name, started)` and `lib:TimeMs(module, name, ms)`: record a timing; `lib:TimingLines(module)` returns them for the module's own log.
- The working-build log, one per module, kept in the module's own saved table (`devLog`, `devLogRun`, `watch`), since the library has no saved variables (owner, 2026-11-25: "Debug mode should be in the shared kit so we can hook in and benefit also, and share calls"):
  - `lib:StartLog(module, saved, handlers)` once saved data is loaded; `handlers` are `{ [event] = function(...) }` that run while the watch is on.
  - `lib:Log(module, line)` appends a timestamped line; `lib:ShowLog(module, all)` opens it in the copy window.
  - A working build logs from the start, always (owner, 2026-11-25: "don't I want an always on debug mode while testing?"); `/boltgrip watch off` pauses it and is remembered. It keeps at most 20,000 lines per module (owner, 2026-11-25), about 1.1 MB and 17 ms per load; past that it trims back to 19,000 at once. A paused log writes nothing: no session header, shared context or timings. The log window clears its log marker whenever other text is shown, so only the log views are treated as logs (Astra review). Each log gets the session's timings at logout as one dated block, and its lines are timestamped so a long watch reads as a timeline. `lib:IsLogging(module)` lets a caller skip building a line nobody will keep. `lib:Trace(module, line)` writes a line only while logging, so shipped code can trace events (sharing, timers) at no cost in a release, where no log is started.
  - `lib:LoggedCommand(module, action, run, details)` wraps a command with a header and shows its lines.
  - `/boltgrip watch on|off` and `/boltgrip log [all|clear]` act on every module that started a log; there is no per-module form (owner, 2026-11-25: "Go, kit commands only"). The log window shows one section per module, not merged by time. Both are listed in `/boltgrip` help only once a log has started, so release builds never show them.
  - The split (owner, 2026-11-25, "All three"): each module says which events it watches and what its lines mean; the kit owns the switch, the window, saving, timings, one listener that passes each event to every watching module, one chat line for `/boltgrip watch`, and shared context written into every log: a session header at each load, zone changes while watching, blocked actions with the call stack, and Lua errors (hooked on Blizzard's error window, since `AddLuaErrorHandler` takes secure code only). Each session's timings are logged at logout, with the game's own measurement of the addon (`C_AddOnProfiler`, read as Blizzard's addon list reads it: share of frame time, peak, frames over 1, 5 and 10 ms; owner, 2026-11-25: "Add CPU numbers"). The zone line gives IDs first (uiMapID and explored area IDs), names after, so anything that reads it back uses the IDs.
  - Offline tests: since MINOR 22, `StartLog` and `EnableWorkingBuild` call `GetBuildInfo`, `date`, `UnitName`, `UnitLevel`, `C_AddOns.GetAddOnMetadata`, `C_Map`, `C_MapExplorationInfo`, `GetSubZoneText`, `EventUtil` and `hooksecurefunc`, so a test that loads the library and starts a log stubs those (tests/loadorder_spec.lua shows the set).

## Options

Every module's options page is built by the library from data: `lib:BuildOptions(module, db, sections)`, then `lib:RegisterCommands` and `lib:FinishModule`. A module never builds rows itself. The library ships no XML: a named template in an embedded library is defined again by every addon that embeds it, and the client warns on the second (seen in game, 2026-11-25). Every row is one of Blizzard's own controls (checkbox, slider, button, key binding); the kit adds no row of its own ("Gamepad UI", Part 3). The row kinds and fields are listed below.

- One order on every page (owner, 2026-11-25: "The order needs to be aligned between both addons, we need standardized language, positioning, and order"; chose "Sources first"):
  1. Sources: the source choice, headed "<what> Sources" ("Recipe Sources", "Fishing Sources"), with sharing under them if the module shares.
  2. The module's own features ("Personal Finds", "Lures").
  3. Sections Blizzard names, titled with its Settings page titles (`COMBAT_LABEL`, `SETTINGS_KEYBINDINGS_LABEL`, `AUDIO_LABEL`), in the order of Blizzard's own pages (`CUSTOM_GAMEPLAY_SETTINGS_ORDER`); a page not in that table comes after, in the order listed.
  4. The kit's Commands and Links (added by `lib:FinishModule`).
  Each section declares `place = "sources" | "features" | "blizzard"`; `lib:BuildOptions` puts them in this order, Blizzard's sections among themselves in the order of its own pages, and stops with an error on a section without a place, or on a sources section that does not start with its one source choice. Enforced by: runtime.
- The source choices are the kit's, words included (owner, 2026-11-25: "These words don't match how recipe vacuum works which feels like a miss"): `lib:SourceChoices(spec)` gives the values of a `choice` row: Self Found, Friends and Public (`lib.SOURCE_LEVEL` 1, 2, 3), each as `{ value, label, description }`, with the "Short range." / "Medium range." / "Long range." openings and each description's sentence: "Tracks only <what> you see for yourself.", "Also tracks what your party, guild and friends find.", "Also tracks <public>.". The module passes only `what` (game terms), `friends = true` if it shares, `public` if it has a Public level, and `openings = false` to leave out the range openings (Tackletron). Enforced by: runtime (BuildOptions refuses source choices not made here).
- Section headings use Blizzard's own words where one exists (`SETTINGS_KEYBINDINGS_LABEL`, `COMBAT_LABEL`, `AUDIO_LABEL`); otherwise Title Case. Enforced by: conformance.
- Labels in Title Case, as Blizzard's options are ("Auto Loot", "Enable Sound"). Enforced by: conformance.
- A tooltip is one sentence. Anything longer goes in the row's `note`, in plain words; the kit appends it to the control's tooltip, after the option lines of a choice. A command's note goes into its Run button's tooltip, after its description. A key binding row has no tooltip, so no note. Enforced by: conformance.
- A command's description is short (60 characters) with its arguments in `usage`. Enforced by: conformance.
- A choice is a `choice` row: Blizzard's slider over the options, never a dropdown ("Gamepad UI"). The tooltip carries what the label cannot: the row's tooltip, then one line "Label: description" per option. Enforced by: conformance (row kinds).
- Row kinds, in `lib:BuildOptions(module, db, sections)`, where `sections = { { heading = text, rows = { row, ... } }, ... }`. Every row may have a `note`, and a section a `tooltip` (shown on its heading). Saved values live in `db[key]`; the setting is named `<addon>_<key>`; it returns the settings by key.
  - `{ kind = "checkbox", key, label, tooltip, default, onChange, under = key of a checkbox it is indented under }`
  - `{ kind = "choice", key, label, tooltip, default = a value, values = { { value, label, description }, ... }, onChange }`: the slider's value is the option's position; the module's saved value stays its own `value`, and a saved value no option has reads as the default. `onChange` gets the option's `value`.
  - `{ kind = "keybinding", binding = the Bindings.xml name }`
- `lib:SourceChoices(spec)`: `spec.self` is the module's whole sentence for the Self Found option ("Tracks only recipes you see for yourself."); `spec.friends` is true when it shares with party, guild and friends, otherwise there is no Friends option (the kit words it); `spec.public` is the module's whole sentence for what Public adds ("Also tracks recipes people link in chat."), nil leaves out the Public option; `spec.openings = false` leaves out the range openings (owner, 2026-11-25, Tackletron: "Game terms, no range opening"). Whole sentences, not a word slotted into the kit's, because word order, case and gender change around the slot in other languages.
- Commands: `lib:RegisterCommands` takes a table of entries, `{ action = "" | word, usage = arguments shown in help ("on|off"), description, run = function(arguments), troubleshooting = true for diagnostics }`. It drives both the chat help and the Commands rows. Troubleshooting entries ship in every build and show in chat help under their own heading, not on the settings page. Each module answers to `/boltgrip <module>` and `/<module>`: full names, not aliases, since slash clashes resolve unpredictably (`ChatFrameUtil.lua` imports `SlashCmdList`).

## Working build

- Code between `--@debug@` and `--@end-debug@` exists in a checkout and is stripped from released builds by the BigWigs packager. Development commands, captures and timing live there.
- A file must still compile with the marked blocks removed; check it.
- Commands for players reporting a problem ship in every build and are listed in the chat help only. Development commands are removed once their question is answered.
- A development command prints one or two lines to chat and puts the detail in the log.
- A test copy to a device is labeled by its copy time and commit: the copied TOC's version becomes `<MMDD.HHMM> <git describe --tags --always --dirty>`, the module shows the time where it shows its version, and the session log shows both. No build counter (a counter numbers copies, not code, and lives in one clone). Releases take the tag through `@project-version@`. Every module's `scripts/deploy-deck` is the skeleton's one line, calling the kit's shared `tests/deploy-deck.sh`. Enforced by: conformance.
- A working build starts its log through one hook, `ns.StartWorkingLog`, defined in the module's debug-only `Troubleshooting.lua` and called by the skeleton's `Core.lua` after `ns.InitSettings` (owner, 2026-11-26: "we need to be perfect considering we're sharing a grouping"). Enforced by: review.

## Game settings

- A module changes a game setting only as a temporary value (`C_CVar.SetTempCVar`), never a saved one, so removing the addon leaves the player's settings as they were.
- A temporary value has one holder in the game, shared with every addon: another addon's `RemoveTempCVar` clears ours. So a module only ever asks for a setting on (never forces one off, which would fight any addon that wants it on), puts its value back when it sees it reverted while it still needs it, and removes it only once it no longer does. There is no shared holder in the kit (owner, 2026-11-26: "Sounds good, handle them").

## Versions

The kit follows LibStub's versioning, as Ace3 does: the major is in the name (`JigBoltgripToolkit-1.0`) and promises compatible calls; `MINOR` rises with every change, and LibStub keeps the highest copy any addon embeds. So an older addon can run on a newer kit. From the first released addon on, a call under `-1.0` is never removed and never changes what it takes or returns; new behavior is a new call. A change that cannot keep that becomes `JigBoltgripToolkit-2.0`, which loads beside 1.0. Enforced by: review (before that release, calls changed freely; versions 19 to 29 were never released).

## Repository

- `README.md`, `AGENTS.md` (the kit's opening, then rules, file layout, a table of the docs), a one-line `CLAUDE.md`, `LICENSE` (GPL-3.0), `.pkgmeta`, `.luacheckrc`, `.busted`, `scripts/check`, `.githooks/pre-push` and `.github/workflows/ci.yml` at the root; every other document in lowercase `docs/`.
- Typical docs: `data.md`, `client-notes.md` (what the client does, as measured), `voice.md`, `development.md`.
- Working notes and decision logs are never committed. Keep them out through `.git/info/exclude`, and list the tracked files before a first push.
- `.pkgmeta` excludes everything that is not the addon: `AGENTS.md`, `CLAUDE.md`, `docs`, `scripts`, `tests`, `tools`, `Libs/JigBoltgripToolkit/tests`.
- The toolkit library is embedded unchanged in every module. Any change raises its `MINOR`, and every module takes the identical file.
