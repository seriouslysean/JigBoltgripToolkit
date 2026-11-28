# 0068 Opening the world map is tested, not assumed to taint

- Date: 2026-11-27
- Status: accepted; mouse and keyboard measured, Deck pending
- Scope: all modules (first use: Recipe Vacuum's Map Pin)
- Kind: gamepad and taint

## Context

Recipe Vacuum's Map Pin opened the world map until RecipeVacuum `ce79a4a` (2026-11-26), which removed it together with every write into Blizzard's profession window after the Deck showed `ADDON_ACTION_FORBIDDEN` for `SetPreferredGamepadInteractTarget` blamed on Recipe Vacuum. `OpenWorldMap` was then banned (kit `tests/conformance.lua`, standards "Gamepad UI") without being tested alone. The same block was later traced to other causes (Tackletron's InputBindingManager hooks, decision 0065's stack blame).

## Decision

`OpenWorldMap` stays banned in release code and is allowed inside a working-build block, for one test: Recipe Vacuum's working-build row "Map Pin and Open" [Test] sets the pin and opens the map, and the kit's tainted-field probe (MINOR 77) and stack blame (MINOR 80) report any block that follows.

## Reasons

- Map Pin used to open the map on its own (until RecipeVacuum ce79a4a), so the taint claim was tested, not assumed (2026-11-27).
- The ban rests on a bundled change, not an isolated measurement (RecipeVacuum `docs/client-notes.md`, "Gamepad").

## Rejected

- Naming the map key in the chat line: everyone knows how to open the map.

## Versions

- Kit conformance change: this commit. Recipe Vacuum row: the commit that adds "Map Pin and Open".

## Tests

- Deck and Mac: press the row on a recipe with a place, then use the map, a radial and the bags; read the log for `blocked` lines and tainted fields. Mac clean (2026-11-27 15:26); Deck tainted (2026-11-27 22:29, below).

## Reopen if

- The test is clean on the Deck: Map Pin opens the map again in release.
- The test taints: the ban stands, now measured.

## Result, mouse and keyboard (2026-11-27)

The Mac test (`/recipevacuum mapopen`, 15:26:36) opened the map (`map open test map=1415 shown=true`) with no blocked action. It has to open on its own, as it did until RecipeVacuum ce79a4a. Map Pin now opens the map with mouse and keyboard in release; under the Gamepad UI it waits for the Deck test. `OpenWorldMap` leaves conformance's banned list; standards "Gamepad UI" says the gamepad path is untested.

## Result, Gamepad UI (2026-11-27)

The Deck test (RecipeVacuum d1f3707, working build only: Map Pin opened the map under the Gamepad UI) opened Westfall (`map open map=1436 opened=true gamepad=true shown=true`), then the map's quest details took the cursor from tainted code: `Blizzard_WorldMap.lua:616` FocusDetails, `SecureHelper.lua:182` SelectFirstButton, `SmartNavigation.lua:652` SelectButton, "Interface action failed because of an AddOn". The log then named 25 tainted fields under `GamepadSharedUtility.BindingStack`, `GamepadMode.FrameControlsManager` and `SmartNavigation.activePanels`, and the game's own SetPreferredGamepadInteractTarget, SpellStopCasting, SpellStopTargeting and ClearTarget were forbidden under RecipeVacuum until a reload. The ban stands under the Gamepad UI, now measured: Map Pin sets the pin and tracking only there; mouse and keyboard keep the open.

## Result, secure click under the Gamepad UI (2026-11-27)

RecipeVacuum 595d930 (working build only): Map Pin is a `SecureActionButtonTemplate` button whose `click` action (`SecureTemplates.lua:557`) clicks the minimap's zone text, whose own handler calls `ToggleWorldMap` (`Blizzard_Minimap/Mainline/Minimap.lua:110`); the pin is set in `PreClick`. SmartNavigation presses it through `SecureHelper.SecureCallOptionalFunction` (`SmartNavigation.lua:1639`). On the Deck the map opened on the press (`secure map open down=true shown=true`), and the session to logout (bags, game menu) logged no blocked action and no tainted field. The map opens on the player's zone (`Blizzard_WorldMap.lua:381`); moving it to the pin's zone is the next test. Not yet measured: the button in combat (a protected button cannot be shown, moved or enabled from addon code then).

## Result, moving the open map to the pin's zone (2026-11-27)

RecipeVacuum 6f3e9bd (working build only) added `WorldMapFrame:SetMapID(pin's map)` one frame after the secure open (`secure map zone map=1436 now=1436`). Four seconds later a gamepad press in the map failed: `Blizzard_WorldMap.lua:634` SetGamepadFocus, `MapCanvas_ScrollContainerMixin.lua:901`, `SmartNavigation.lua:361` SuspendCursor, "Interface action failed because of an AddOn"; then 40 tainted gamepad binding fields and the same forbidden game calls as the first test until a reload. Setting the map's zone from addon code taints it under the Gamepad UI; the secure open alone stays, on the player's zone.

## Result, /run macro from the secure button (2026-11-27)

RecipeVacuum 7f7b3cb (working build only): the secure Map Pin ran the macro `/run OpenWorldMap(1436)` (`SecureTemplates.lua:450`, `C_Macro.RunMacroText`). The map opened on Westfall (`secure map open down=true shown=true map=1436`), and 3 s later SetPreferredGamepadInteractTarget was forbidden with the taint named `*** ForceTaint_Strong ***`, then `SmartNavigation.lua:277` ActivateBinding failed with "Interface action failed because of an AddOn". Script lines in a macro run tainted even from a secure button, as warcraft.wiki.gg "Secure Execution and Tainting" says of macro code. Next: the game's own `/mappin` command in the macro, whose handler opens the map in Blizzard's code (`WaypointLocationDataProvider.lua:213-229`).

## Result, /mappin from the secure button (2026-11-27)

RecipeVacuum b7c1fc8 (working build only): the secure Map Pin ran the macro `/mappin 1436 <x> <y>` (`SLASH_MAPPIN1`), whose handler sets the waypoint and calls `OpenMapToUserWaypoint` (`WaypointLocationDataProvider.lua:213-229`, `Blizzard_WorldMap.lua:1482`). The map opened on Westfall (`secure map open down=true shown=true map=1436`), and the session to logout (38 gamepad moves through the map, bags and game menu) logged no blocked action and no tainted field. A slash command's handler is Blizzard's function, so the macro carries only data; a `/run` line is a script chunk and runs tainted (above). This is the path for Map Pin under the Gamepad UI; still to measure: the protected button in combat.

## Result, the shipped Map Pin (2026-11-27)

RecipeVacuum fd82f53, release path: a secure button over Map Pin runs `/mappin`, our control then super-tracks the pin and says so; in combat Map Pin is greyed out and the Vacuum says once a session that it refuses to triangulate. On the Deck the map opened on Westfall before and after a fight (`map opened down=true shown=true map=1436`, 23:15 and 23:18), and 75 gamepad moves logged no blocked action and no tainted field. `OpenWorldMap` is no longer called by any module; ban it again in conformance.
