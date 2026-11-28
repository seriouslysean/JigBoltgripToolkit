# 0068 Opening the world map is tested, not assumed to taint

- Date: 2026-11-27
- Status: accepted; mouse and keyboard measured, Deck pending
- Scope: all modules (first use: Recipe Vacuum's Map Pin)
- Kind: gamepad and taint

## Context

Recipe Vacuum's Map Pin opened the world map until RecipeVacuum `d49f59d` (2026-11-26), which removed it together with every write into Blizzard's profession window after the Deck showed `ADDON_ACTION_FORBIDDEN` for `SetPreferredGamepadInteractTarget` blamed on Recipe Vacuum. `OpenWorldMap` was then banned (kit `tests/conformance.lua`, standards "Gamepad UI") without being tested alone. The same block was later traced to other causes (Tackletron's InputBindingManager hooks, decision 0065's stack blame).

## Decision

`OpenWorldMap` stays banned in release code and is allowed inside a working-build block, for one test: Recipe Vacuum's working-build row "Map Pin and Open" [Test] sets the pin and opens the map, and the kit's tainted-field probe (MINOR 77) and stack blame (MINOR 80) report any block that follows.

## Reasons

- Owner, 2026-11-27, on Map Pin not opening the map: "It used to auto open it, are you sure? That doesn't seem right to me."
- The ban rests on a bundled change, not an isolated measurement (RecipeVacuum `docs/client-notes.md`, "Gamepad").

## Rejected

- Naming the map key in the chat line. Owner: "we shouldn't mention the key imo, everyone knows how to open the map".

## Versions

- Kit conformance change: this commit. Recipe Vacuum row: the commit that adds "Map Pin and Open".

## Tests

- Deck and Mac: press the row on a recipe with a place, then use the map, a radial and the bags; read the log for `blocked` lines and tainted fields. Mac clean (2026-11-27 15:26); Deck tainted (2026-11-27 22:29, below).

## Reopen if

- The test is clean on the Deck: Map Pin opens the map again in release (owner's call).
- The test taints: the ban stands, now measured.

## Result, mouse and keyboard (2026-11-27)

The Mac test (`/recipevacuum mapopen`, 15:26:36) opened the map (`map open test map=1415 shown=true`) with no blocked action. Owner: "map opened, but it really needs to be automatic and I swear we used to do it" (it did, until RecipeVacuum d49f59d). Map Pin now opens the map with mouse and keyboard in release; under the Gamepad UI it waits for the Deck test. `OpenWorldMap` leaves conformance's banned list; standards "Gamepad UI" says the gamepad path is untested.

## Result, Gamepad UI (2026-11-27)

The Deck test (RecipeVacuum 72ba5f7, working build only: Map Pin opened the map under the Gamepad UI) opened Westfall (`map open map=1436 opened=true gamepad=true shown=true`), then the map's quest details took the cursor from tainted code: `Blizzard_WorldMap.lua:616` FocusDetails, `SecureHelper.lua:182` SelectFirstButton, `SmartNavigation.lua:652` SelectButton, "Interface action failed because of an AddOn". The log then named 25 tainted fields under `GamepadSharedUtility.BindingStack`, `GamepadMode.FrameControlsManager` and `SmartNavigation.activePanels`, and the game's own SetPreferredGamepadInteractTarget, SpellStopCasting, SpellStopTargeting and ClearTarget were forbidden under RecipeVacuum until a reload. The ban stands under the Gamepad UI, now measured: Map Pin sets the pin and tracking only there; mouse and keyboard keep the open.
