# Decisions

One file per decision across the toolkit and its modules, in the MADR shape (adr.github.io): date, status, scope, kind, context, decision, cited reasons, the owner's words, rejected options, versions, tests and what would reopen it. Numbered by date; module sessions add their own here (docs only, no `MINOR` change).

## Options pages

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0006 | [Herbs and ore in one row](0006-herbs-and-ore-in-one-row.md) | Sparklescope 6000 | accepted |
| 0027 | [Enable Interact Key is named on each sparkle row](0027-enable-interact-key-is-named-on-each-sparkle-row.md) | Sparklescope 6000 | accepted |
| 0028 | [Toolkit page: no module rows, no reload, no clear, no watch switch](0028-toolkit-page-no-module-rows-no-reload-no-clear-no-watch-swit.md) | all modules | accepted |
| 0029 | [Button rows name the thing, verb on the button](0029-button-rows-name-the-thing-verb-on-the-button.md) | all modules | accepted |
| 0040 | [Every page follows one order](0040-every-page-follows-one-order.md) | all modules | accepted |
| 0041 | [Each action gets a key binding and a /click macro](0041-each-action-gets-a-key-binding-and-a-click-macro.md) | all modules | accepted |
| 0042 | [Labels name the thing](0042-labels-name-the-thing.md) | all modules | accepted |
| 0043 | [A repeating chat line gets an Announce checkbox](0043-a-repeating-chat-line-gets-an-announce-checkbox.md) | all modules | accepted |
| 0062 | [Fishing levels come from Fishing Sources cards, one setting like Recipe Vacuum](0062-fishing-levels-come-from-fishing-sources-cards-one-setting-l.md) | Tackletron | accepted |

## Gamepad and taint

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0030 | [Canvas pages stay banned, measured](0030-canvas-pages-stay-banned-measured.md) | all modules | accepted |
| 0031 | [StaticPopup_Show is banned](0031-staticpopup-show-is-banned.md) | all modules | accepted |
| 0039 | [No chat link that opens Settings](0039-no-chat-link-that-opens-settings.md) | all modules | accepted |
| 0044 | [The copy window opens unfocused on the gamepad](0044-the-copy-window-opens-unfocused-on-the-gamepad.md) | all modules | accepted |
| 0065 | [Errors and blocks are logged once, blamed from the stack](0065-errors-and-blocks-are-logged-once-blamed-from-the-stack.md) | all modules | accepted |
- [0068](0068-opening-the-world-map-is-tested-not-assumed-tainting.md) Opening the world map is tested, not assumed to taint (all modules; accepted, test pending)

## Data

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0004 | [Known recipes count as met](0004-known-recipes-count-as-met.md) | Recipe Vacuum | accepted |
| 0020 | [Difficulty re-read stays uncapped](0020-difficulty-re-read-stays-uncapped.md) | Recipe Vacuum | accepted |
| 0021 | [Built-in data: self found first, with named exceptions](0021-built-in-data-self-found-first-with-named-exceptions.md) | all modules | accepted |
| 0022 | [Sparklescope ships a chest list on for everyone](0022-sparklescope-ships-a-chest-list-on-for-everyone.md) | Sparklescope 6000 | accepted |
| 0023 | [Quest loot teaches no chest](0023-quest-loot-teaches-no-chest.md) | Sparklescope 6000 | accepted |
| 0024 | [No sharing safeguard for chests](0024-no-sharing-safeguard-for-chests.md) | Sparklescope 6000 | accepted |
| 0056 | [Lures and Fishing food come from the client's data, by ID](0056-lures-and-fishing-food-come-from-the-client-s-data-by-id.md) | Tackletron | accepted |
| 0061 | [Zone fishing facts are kept, never guessed into a level](0061-zone-fishing-facts-are-kept-never-guessed-into-a-level.md) | Tackletron | accepted |
| 0063 | [Zone fishing levels are built in, as hidden logic](0063-zone-fishing-levels-are-built-in-hidden-logic.md) | Tackletron | accepted in part |

## Performance

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0003 | [A split always advances; no frame of ours over 5 ms](0003-a-split-always-advances-no-frame-of-ours-over-5-ms.md) | all modules | accepted |
| 0019 | [Don't fix edge cases that don't exist](0019-don-t-fix-edge-cases-that-don-t-exist.md) | all modules | accepted |

## Scope

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0001 | [AutoOmniadjustor acts with three spells only](0001-autoomniadjustor-acts-with-three-spells-only.md) | AutoOmniadjustor | accepted |
| 0007 | [Buffulator does one job: see, buff, thank](0007-buffulator-does-one-job-see-buff-thank.md) | Buffulator | accepted |
| 0008 | [Buffulator scans anyone nearby from the start](0008-buffulator-scans-anyone-nearby-from-the-start.md) | Buffulator | accepted |
| 0064 | [The fishing-data probe stays a working-build command](0064-the-fishing-data-probe-stays-a-working-build-command.md) | Tackletron | accepted |

## Safety

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0002 | [AutoOmniadjustor never acts on equipment set items; no other gate yet](0002-autoomniadjustor-never-acts-on-equipment-set-items-no-other.md) | AutoOmniadjustor | accepted |
| 0036 | [The use key acts only while the marks are on](0036-the-use-key-acts-only-while-the-marks-are-on.md) | AutoOmniadjustor | accepted |
| 0051 | [Combat with the pole in hand: the weapons go back by themselves, the key is the fallback](0051-combat-with-the-pole-in-hand-the-weapons-go-back-by-themselv.md) | Tackletron | accepted |

## Trainers

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0045 | [Trainer learned read: once per trainer, account-wide](0045-trainer-learned-read-once-per-trainer-account-wide.md) | Recipe Vacuum | accepted |
| 0046 | [Not built: a trainer seed list](0046-not-built-a-trainer-seed-list.md) | Recipe Vacuum | not built |
| 0047 | [Not built: trainer groups](0047-not-built-trainer-groups.md) | Recipe Vacuum | not built |

## Panel

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0005 | [Skill-up arrows, not numbers, on Recipe Vacuum rows](0005-skill-up-arrows-not-numbers-on-recipe-vacuum-rows.md) | Recipe Vacuum | accepted |
| 0066 | [Recipe Vacuum's details scroll as one, header included](0066-recipe-vacuum-details-scroll-as-one-header-included.md) | Recipe Vacuum | accepted |
| 0048 | [The key's button is one secure macro button, also the visible one](0048-the-key-s-button-is-one-secure-macro-button-also-the-visible.md) | Tackletron | accepted |
| 0052 | [The leave arrow puts the weapons back, and the addon remembers them](0052-the-leave-arrow-puts-the-weapons-back-and-the-addon-remember.md) | Tackletron | accepted |
| 0053 | [A square for the best lure and one for the best Fishing food](0053-a-square-for-the-best-lure-and-one-for-the-best-fishing-food.md) | Tackletron | accepted |
| 0058 | [Tips are Tackletron's own frames, said once](0058-tips-are-tackletron-s-own-frames-said-once.md) | Tackletron | accepted |
| 0060 | [The button sits where the cast bar appears](0060-the-button-sits-where-the-cast-bar-appears.md) | Tackletron | accepted |

## Look

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0025 | [The sparkle is fireflies](0025-the-sparkle-is-fireflies.md) | Sparklescope 6000 | accepted |
| 0054 | [A needed lure is a steady highlight, and the button stays Fishing's icon](0054-a-needed-lure-is-a-steady-highlight-and-the-button-stays-fis.md) | Tackletron | accepted |
| 0069 | [Buffulator's need frame is one line under the portrait](0069-buffulators-need-frame-is-one-line-under-the-portrait.md) | Buffulator | accepted, check in game pending |

## Game settings

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0026 | [No outlines](0026-no-outlines.md) | Sparklescope 6000 | accepted |
| 0050 | [The hook waits for the soft-targeted bobber, on temporary CVars](0050-the-hook-waits-for-the-soft-targeted-bobber-on-temporary-cva.md) | Tackletron | accepted |
| 0059 | [Music, ambience and dialog are lowered while a pole is on](0059-music-ambience-and-dialog-are-lowered-while-a-pole-is-on.md) | Tackletron | accepted |

## Buffing

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0010 | [Buff Next casts only on a press](0010-buff-next-casts-only-on-a-press.md) | Buffulator | accepted |
| 0011 | [Buff Next picks the best rank the target can take](0011-buff-next-picks-the-best-rank-the-target-can-take.md) | Buffulator | accepted |
| 0032 | [Buff Next is a secure button, a key binding and a /click macro](0032-buff-next-is-a-secure-button-a-key-binding-and-a-click-macro.md) | Buffulator | accepted |
| 0033 | [PvP-flagged strangers are buffed by default, told once](0033-pvp-flagged-strangers-are-buffed-by-default-told-once.md) | Buffulator | accepted |
| 0070 | [Buffulator's need line casts Buff Next on a tap](0070-buffulators-need-line-casts-buff-next-on-a-tap.md) | Buffulator | accepted, check in game pending |

## Thanks

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0012 | [Thanks emotes are checkboxes, picked at random](0012-thanks-emotes-are-checkboxes-picked-at-random.md) | Buffulator | accepted |
| 0013 | [Thanks delay: Quick 1 to 3 s, Relaxed 3 to 5 s](0013-thanks-delay-quick-1-to-3-s-relaxed-3-to-5-s.md) | Buffulator | accepted |
| 0014 | [Many buffs get one thanks](0014-many-buffs-get-one-thanks.md) | Buffulator | accepted |
| 0015 | [A player is thanked once per buff](0015-a-player-is-thanked-once-per-buff.md) | Buffulator | accepted |
| 0034 | [Thanks on by default, /thank alone](0034-thanks-on-by-default-thank-alone.md) | Buffulator | accepted |
| 0035 | [No thanks while away or stealthed](0035-no-thanks-while-away-or-stealthed.md) | Buffulator | accepted |

## Keys and marks

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0016 | [Two keys: marks, then use](0016-two-keys-marks-then-use.md) | AutoOmniadjustor | accepted |
| 0017 | [Marks: autocast corners, a color per action](0017-marks-autocast-corners-a-color-per-action.md) | AutoOmniadjustor | accepted |
| 0037 | [Overlays are our own frames over Blizzard's buttons](0037-overlays-are-our-own-frames-over-blizzard-s-buttons.md) | AutoOmniadjustor | accepted |
| 0049 | [One key setting: the binding; F fishes when none is bound; Interact is the last choice](0049-one-key-setting-the-binding-f-fishes-when-none-is-bound-inte.md) | Tackletron | accepted |

## Chat

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0038 | [A borrowed stick press is told once, with no Announce checkbox](0038-a-borrowed-stick-press-is-told-once-with-no-announce-checkbo.md) | AutoOmniadjustor | accepted |
| 0057 | [Chat lines are a noise and a report, once where they repeat](0057-chat-lines-are-a-noise-and-a-report-once-where-they-repeat.md) | Tackletron | accepted |

## Name

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0009 | [The module is named Buffulator](0009-the-module-is-named-buffulator.md) | Buffulator | accepted |
| 0018 | [The module is named Auto-Omniadjustor](0018-the-module-is-named-auto-omniadjustor.md) | AutoOmniadjustor | accepted |

## Fishing gear

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0055 | [One lure per escape, and Use Lures steps Always, Auto, Never](0055-one-lure-per-escape-and-use-lures-steps-always-auto-never.md) | Tackletron | accepted |

## Working build

| No. | Decision | Scope | Status |
|---|---|---|---|
| 0067 | [Working-build log lines are logfmt](0067-working-build-log-lines-are-logfmt.md) | all modules | accepted |

## Open, not decided

- Sparklescope 6000: replacing the zoom formula and scene camera that match another addon Sparkles, which ships no licence. Owner: "I don't want their exact code, that's weird and has a smell, and they'd be able to tell"; "TBD". A Mac session with the mouse wheel decides.
- Buffulator: skip a player after a failed cast, rebuff early, a voiced macro line, the macro on mouse and keyboard, full character macros, a fail-closed stranger macro.
- AutoOmniadjustor: the Deck taint (`SetPreferredGamepadInteractTarget` blocked, `MainActionBarFrame.lua:373`). With the module off, the menu and radial check passed on 2026-11-27, so the cause is in the module's own code.

## Process

- [0071](0071-rules-from-the-owners-corrections.md) Rules from the owner's corrections (all modules; accepted)
