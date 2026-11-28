# 0078 Positions on a continent move to the zone under them

- Date: 2026-11-27
- Status: accepted; Mac to measure
- Scope: Recipe Vacuum
- Kind: data

## Context

Odd Child's only saved position is on map 1415, Eastern Kingdoms, at 0.411, 0.791: `C_Map.GetBestMapForUnit("player")` gave the continent where the trainer stands. Map Pin then opened the map on the whole continent and named it in chat. It is 1 of 83 saved positions on the test account (Mac saved variables, 2026-11-27). Why the game gave the continent there is not known.

## Decision

A position on a continent or larger map (`Enum.UIMapType.Continent` or less) moves to the zone under it: `C_Map.GetMapInfoAtPosition` finds the zone, `C_Map.GetMapRectOnMap` converts the coordinates (`ns.ZonePosition`, `Sources.lua`). It runs when a position is saved, and once at login over every saved position (`RepairSaved`, RecipeVacuum `99b17b5`), so a read converts nothing. With no zone under the point the continent stays.

## Reasons

- Map Pin should open the zone, not the continent, so positions convert on save and saved entries convert too.
- Both calls are Blizzard's map API (`Blizzard_APIDocumentationGenerated/MapDocumentation.lua`).

## Rejected

- Keeping the continent: the pin is unreadable and the chat line names the continent.

## Versions

- Recipe Vacuum: the commit that adds `ns.ZonePosition`.

## Tests

- Mac: after login the log has `positions repaired moved=<n>`, with n at least 1 the first time. Then Map Pin on a recipe Odd Child teaches: the chat line names the zone, the map opens on it, and the log has no `zone position` line. Pending.

## Reopen if

- A converted pin lands in the wrong place.
